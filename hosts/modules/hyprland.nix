# Hyprland configuration
{ config, pkgs, ... }:

{
  programs.hyprland = {
    enable = true;
    withUWSM = true; # recommended for most users
    xwayland.enable = true; # Xwayland can be disabled.
  };

  xdg.portal = {
    enable = true;
    extraPortals = with pkgs; [ xdg-desktop-portal-hyprland ];
  };

  environment.systemPackages = with pkgs; [
    waybar
    quickshell
    rofi
    nautilus
    # Media and feedback
    swayosd
    brightnessctl
    playerctl
    # Lock and Wallpaper
    hypridle
    hyprpaper
    hyprlock
    hyprshutdown
  ];

  services.gnome.gnome-keyring.enable = true;
}
