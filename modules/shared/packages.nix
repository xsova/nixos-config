{ pkgs }:

with pkgs; [
  # Encryption and security tools
  age
  age-plugin-yubikey
  gnupg
  libfido2

  # Cloud-related tools and SDKs
  docker
  docker-compose

  # Media-related packages
  dejavu_fonts
  ffmpeg
  fd
  font-awesome
  hack-font
  noto-fonts
  noto-fonts-emoji
  meslo-lgs-nf
  jetbrains-mono

  # Node.js development tools
  nodePackages.npm # globally install npm
  nodePackages.prettier
  nodejs

  # Text editors
  helix
  neovim

  # Shells
  fish
  dash
  nushell

  # Terminal utils
  wezterm
  zellij
  btop
  hunspell
  iftop
  jq
  ripgrep
  tree
  unrar
  unzip
  aspell
  aspellDicts.en
  bash-completion
  bat
  btop
  coreutils
  killall
  openssh
  wget
  zip

  # Python packages
  python39
  python39Packages.virtualenv # globally install virtualenv

  # Languages / LSPs / Linters / Debuggers
  ## General
  llvm
  vscode-langservers-extracted
  
  ## Rust
  rustc
  cargo
  rust-analyzer
  
  ## Zig
  zls
  
  ## Go
  go
  delve
  golangci-lint-langserver
  gopls

  ## Typescript
  typescript-language-server

  ## Nix
  nixd
  nil
]
