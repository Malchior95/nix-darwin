{
  pkgs,
  config,
  user,
  inputs,
  ...
}: {
  imports = [
    ./modules
  ];

  nixpkgs.config.allowUnfree = true;

  home = {
    username = user;
    homeDirectory = "/Users/${user}";
    stateVersion = "25.05";

    sessionVariables = {
      EDITOR = "nvim";
    };
    packages = with pkgs; [
      discord
      fastfetch
      wget
      rip2
      sops
      #qbittorrent
      #libreoffice
    ];
  };
}
