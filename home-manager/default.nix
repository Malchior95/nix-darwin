{ pkgs, config, user, inputs, ... }: {
  imports = [ ./modules ];

  nixpkgs.config.allowUnfree = true;

  home = {
    username = user;
    homeDirectory = "/Users/${user}";
    stateVersion = "25.05";

    sessionVariables = { EDITOR = "hx"; };
    packages = with pkgs; [
      discord
      fastfetch
      wget
      rip2
      sops
      lazygit
      onefetch
      maccy
      whatsapp-for-mac
      squirreldisk
      #qbittorrent
      #libreoffice
    ];
  };
}
