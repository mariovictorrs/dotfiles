# GNOME desktop environment, using GDM
{ config, pkgs, ... }:

{
  services = {
    xserver.enable = false;

    displayManager.gdm.enable = true;
    desktopManager.gnome.enable = true;

    gnome = {
      core-developer-tools.enable = false;
      games.enable = false;
    };
  };

  environment.systemPackages = with pkgs; [
    # Gnome power apps
    gnome-tweaks
    refine
    # Gnome Extensions
    gnomeExtensions.blur-my-shell
    gnomeExtensions.just-perfection
    gnomeExtensions.appindicator

    # Themes the app titlebars
    pkgs.qadwaitadecorations
    pkgs.qadwaitadecorations-qt6
    # Themes the apps
    pkgs.qgnomeplatform
    pkgs.qgnomeplatform-qt6
  ];

  # Theme QT Apps
  qt = {
    enable = true;
    platformTheme = "gnome";
    style = "adwaita-dark";
  };
}
