{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    nordvpn
  ];

  services.nordvpn.enable = true;

  users.users."mario".extraGroups = [
    "nordvpn"
  ];

  networking.firewall.enable = true;
  networking.firewall.checkReversePath = "loose";
}
