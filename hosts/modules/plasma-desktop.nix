# Desktop environment configuration
# KDE Plasma 6, SDDM
{ config, pkgs, ... }:

{
  services = {
    # Enable the X11 windowing system.
    # You can disable this if you're only using the Wayland session.
    xserver.enable = false;

    # Enable the KDE Plasma Desktop Environment.
    displayManager.sddm.enable = true;
    desktopManager.plasma6.enable = true;
  };

  # Make GTK use its simple IM implementation to enable compose/dead keys in ghostty
  environment.sessionVariables = {
    GTK_IM_MODULE = "simple";
  };
}
