# Base system packages and utilities
# Essential tools for development, system management, and desktop use
{ config, pkgs, ... }:

{
  # Install firefox.
  programs.firefox.enable = true;

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # Make GTK use its simple IM implementation to enable compose/dead keys in ghostty
  environment.sessionVariables = {
    GTK_IM_MODULE = "simple";
  };

  # Fix for Copilot CLI on NixOS (issue #3392)
  # Copilot CLI >= 1.0.49 hardcodes /bin/bash lookup
  # envfs mounts the Nix store at standard FHS paths for compatibility
  services.envfs.enable = true;

  # Base system packages
  environment.systemPackages = with pkgs; [
    # Text editors & tools
    vim
    neovim

    # Utilities
    wget
    git
    stow
    lazygit
    tmux
    ripgrep
    fzf
    bat
    delta
    eza
    just

    # Shells & tools
    zsh
    bash
    starship
    zoxide

    # Development
    nodejs
    go
    uv
    air
    gcc

    # Fonts
    nerd-fonts.jetbrains-mono

    # Desktop & media
    ghostty
    plymouth
    google-chrome
    obsidian
    vlc
    btop

    # Audio & system
    asunder
    picard
    orca-slicer
    cliamp

    # Utilities
    podman
    podman-compose
    github-copilot-cli
    ente-auth
  ];

  # Podman
  virtualisation = {
    containers.enable = true;
    podman = {
      enable = true;
      dockerCompat = true;
      defaultNetwork.settings.dns_enabled = true; # Required for containers under podman-compose to be able to talk to each other.
    };
  };

  nix = {
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 30d";
    };

    # Optmize storage
    settings = {
      auto-optimise-store = true;
    };
  };

  services = {
    # Enable flatpak
    flatpak.enable = true;

    # Enable network printing
    avahi = {
      enable = true;
      nssmdns4 = true;
      openFirewall = true;
    };

    printing = {
      enable = true;
      drivers = with pkgs; [
        cups-filters
        cups-browsed
      ];
    };

  };
}
