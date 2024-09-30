{ config, pkgs, lib, ... }:

let name = "bryce";
    user = "bryce";
    email = "bryce@bryces.email"; in
{
  # Shared shell configuration
  zsh = {
    enable = true;
    autocd = false;
    plugins = [
      {
        name = "powerlevel10k";
        src = pkgs.zsh-powerlevel10k;
        file = "share/zsh-powerlevel10k/powerlevel10k.zsh-theme";
      }
      {
        name = "powerlevel10k-config";
        src = lib.cleanSource ./config;
        file = "p10k.zsh";
      }
    ];

    initExtraFirst = ''
      if [[ -f /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh ]]; then
        . /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh
        . /nix/var/nix/profiles/default/etc/profile.d/nix.sh
      fi
      export PATH=$HOME/.pnpm-packages/bin:$HOME/.pnpm-packages:$PATH
      export PATH=$HOME/.npm-packages/bin:$HOME/bin:$PATH
      export PATH=$HOME/.local/share/bin:$PATH
      export HISTIGNORE="pwd:ls:cd"
    '';
  };

  fish = {
    enable = true;
    shellAbbrs = {
      ea = "$EDITOR ~/nixos-config/modules/shared/home-manager.nix";
    };
    functions = {
      __fish_command_not_found_handler = {
        body = "__fish_default_command_not_found_handler $argv[1]";
        onEvent = "fish_command_not_found";
      };
      gitignore = "curl -sL https://www.gitignore.io/api/$argv";
    };
    shellInit = ''
      # XDG Base Directories
        set -q XDG_CONFIG_HOME; or set -Ux XDG_CONFIG_HOME $HOME/.config
        set -q XDG_DATA_HOME; or set -Ux XDG_DATA_HOME $HOME/.local/share
        set -q XDG_STATE_HOME; or set -Ux XDG_STATE_HOME $HOME/.local/state
        set -q XDG_CACHE_HOME; or set -Ux XDG_CACHE_HOME $HOME/.cache
        
      # Fish-specific Directories
        set -q __fish_config_dir; or set -Ux __fish_config_dir $XDG_CONFIG_HOME/fish
        set -q __fish_data_dir; or set -Ux __fish_data_dir $XDG_DATA_HOME/fish
        set -q __fish_cache_dir; or set -Ux __fish_cache_dir; or set -Ux __fish_cache_dir $XDG_CACHE_HOME/fish
        set -q __fish_plugins_dir; or set -Ux __fish_plugins_dir $__fish_config_dir/plugins

      # Default apps
        set -q EDITOR; or set -gx EDITOR hx
        set -q VISUAL; or set -gx VISUAL code
        set -q PAGER; or set -gx PAGER more

      # Fisher
        set -q fisher_path; or set -gx fisher_path $fish_config_dir/.fisher

      # Host-specific
        set -q HOSTNAME; or set -gx HOSTNAME (hostname -s)

      # Initial Working Directory
        set -q IWD; or set -g IWD $PWD

      # Homebrew
        set -q HOMEBREW_PREFIX; or set -gx HOMEBREW_NO_ANALYTICS 1
        set -q HOMEBREW_PREFIX; or set -gx HOMEBREW_PREFIX /opt/homebrew

      # OpenJDK / LLVM
        set -gx CPPFLAGS -I/opt/homebrew/opt/openjdk/include
        set -gx LDFLAGS -L/opt/homebrew/opt/llvm/lib
        set -gx CPPFLAGS -I/opt/homebrew/opt/llvm/include
        
      # Set path up
        fish_add_path --path ~/.local/bin
        fish_add_path --path ~/go/bin
        fish_add_path --path $DENO_INSTALL/bin
        fish_add_path --path /opt/homebrew/opt/llvm/bin
        fish_add_path --path --append ~/bin
      '';
    shellAliases = {
      # Maps aliases
      g = "git";
      "..." = "cd ../..";
      ls = "lsd -F";
    };
  };

  git = {
    enable = true;
    ignores = [ "*.swp" ];
    userName = name;
    userEmail = email;
    lfs = {
      enable = true;
    };
    extraConfig = {
      init.defaultBranch = "main";
      core = {
	      editor = "helix";
        autocrlf = "input";
      };
      pull.rebase = true;
      rebase.autoStash = true;
    };
  };

  wezterm = {
    enable = true;
    extraConfig = builtins.readFile ./config/wezterm.lua;
  };
  
  ssh = { # TODO: Check me out
    enable = true;
    includes = [
      (lib.mkIf pkgs.stdenv.hostPlatform.isLinux
        "/home/${user}/.ssh/config_external"
      )
      (lib.mkIf pkgs.stdenv.hostPlatform.isDarwin
        "/Users/${user}/.ssh/config_external"
      )
    ];
    matchBlocks = {
      "github.com" = {
        identitiesOnly = true;
        identityFile = [
          (lib.mkIf pkgs.stdenv.hostPlatform.isLinux
            "/home/${user}/.ssh/id_github"
            )
          (lib.mkIf pkgs.stdenv.hostPlatform.isDarwin
            "/Users/${user}/.ssh/id_github"
            )
          ];
        };
      };
    };

  helix = {
    enable = true;
    settings = {
      theme = "catppuccin_frappe";
      
      editor = {
        mouse = true;
        auto-save = true;
        cursorline = false;
        cursorcolumn = false;
        cursor-shape = {
          insert = "block";
          normal = "block";
          select = "underline";
        };
        lsp.display-messages = true;
        file-picker.hidden = false;
      };
      
      keys = {
        normal = {
          w = [ "move_next_word_start" "move_char_right" "collapse_selection" ];
          W = [ "move_next_long_word_start" "move_char_right" "collapse_selection" ];
          e = [ "move_next_word_end" "collapse_selection" ];
          E = [ "move_next_long_word_end" "collapse_selection" ];
          b = [ "move_prev_word_start" "collapse_selection" ];
          B = [ "move_prev_long_word_start" "collapse_selection" ];
          i = [ "insert_mode" "collapse_selection" ];
          a = [ "append_mode" "collapse_selection" ];
          u = [ "undo" "collapse_selection" ];
          p = "paste_clipboard_before";
          y = "yank_main_selection_to_clipboard";
          esc = [ "collapse_selection" "keep_primary_selection" ];
          "*" = [ "move_char_right" "move_prev_word_start" "move_next_word_end" "search_selection" "search_next" ];
          "#" = [ "move_char_right" "move_prev_word_start" "move_next_word_end" "search_selection" "search_prev"];
          A-S-up = [ "extend_to_line_bounds" "delete_selection" "move_line_up" "paste_before" ];
          A-S-down = [ "extend_to_line_bounds" "delete_selection" "move_line_down" "paste_before" ];
          C-tab = ":buffer-next";
          C-S-tab = ":buffer-previous";
          A-w = ":buffer-close";
          C-o = ":config-open";
          C-r = ":config-reload";
          S-space = [ "half_page_up" ];
          space.c = "toggle_comments";
          space."." = "file_picker_in_current_buffer_directory";
          g.T = "find_till_char";
          # Engram layout
          # n = "move_char_right";
          # t = "move_visual_line_down";
          # s = "move_visual_line_up";
          # C-S = "select_regex";
          # C-N = "search_next";
          # C-T = "find_till_char";
        };
        insert.esc = [ "collapse_selection" "normal_mode" ];
        select = {
          "{" = [ "extend_to_line_bounds" "goto_prev_paragraph" ];
          "}" = [ "extend_to_line_bounds" "goto_next_paragraph" ];
          "0" = "goto_line_start";
          "$" = "goto_line_end";
          "^" = "goto_first_nonwhitespace";
          G = "goto_file_end";
          C = [ "goto_line_start" "extend_to_line_bounds" "change_selection" ];
          D = [ "extend_to_line_bounds" "delete_selection" "normal_mode" ];
          "%" = "match_brackets";
          S = "surround_add";
          u = [ "switch_to_lowercase" "collapse_selection" "normal_mode" ];
          U = [ "switch_to_uppercase" "collapse_selection" "normal_mode" ];
          d = [ "yank_main_selection_to_clipboard" "delete_selection" ];
          x = [ "yank_main_selection_to_clipboard" "delete_selection" ];
          y = [ "yank_main_selection_to_clipboard" "normal_mode" "flip_selections" "collapse_selection" ];
          Y = [ "extend_to_line_bounds" "yank_main_selection_to_clipboard" "goto_line_start" "collapse_selection" "normal_mode" ];
          p = [ "replace_selections_with_clipboard" ];
          P = [ "paste_clipboard_before" ];
          esc = [ "collapse_selection" "keep_primary_selection" "normal_mode" ];
          # Engram layout
          # C-S = "select_regex";
          # C-N = "search_next";
          # C-t = "find_till_char";
          # n = "extend_char_right";
          # s = "extend_visual_line_up";
          # t = "extend_visual_line_down";          
        };
      };
    };

    languages = {
      language = [
        {
          name = "fish";
          language-servers = [ "fish-lsp" ];
        }
        {
          name = "go";
          language-servers = [ "golangci-lint-langserver" ];
        }
      ];
      language-server = {
        fish-lsp = {
          command = "fish-lsp";
          args = [ "start" ];
        };
        golangci-lint-langserver = {
          command = "golangci-lint-langserver";
          args = [ "--stdio" ];
        };
        eslint = {
          command = "golangci-lint-langserver";
          args = [ "--stdio" ];
          config = {
            format = true;
            nodePath = "";
            onIgnoredFiles = "off";
            packageManager = "npm";
            quiet = false;
            run = "onType";
            useESLintClass = "false";
            validate = "on";
            codeAction = {
              disableRuleComment = {
                enable = true;
                location = "separateLine";
              };
            };
            codeActionOnSave.mode = "all";
            problems.shortenToSingleLine = false;
            workingDirectory.mode = "auto";
          };
        };
      };
    };
  };
}
