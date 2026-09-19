# User configuration module
# Defines user account setup, groups, and shell preferences
{ config, pkgs, ... }:

{
  # Define a user account. Don't forget to set a password with 'passwd'.
  users.users."mario" = {
    isNormalUser = true;
    description = "Mario";
    extraGroups = [
      "networkmanager"
      "wheel"
      "podman"
    ];
    shell = pkgs.zsh;
  };

  # Enable programs needed for user
  programs = {
    zsh.enable = true;
    zoxide.enable = true;
  };
}
