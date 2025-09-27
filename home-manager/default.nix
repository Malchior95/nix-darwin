{
  pkgs,
  config,
  user,
  inputs,
  ...
}:
{
  imports = [ ./modules ];

  nixpkgs.config.allowUnfree = true;

  home = {
    username = user;
    homeDirectory = "/Users/${user}";
    stateVersion = "25.05";

    sessionVariables = {
      EDITOR = "hx";
    };
    packages = with pkgs; [
      fastfetch
      wget
      rip2
      onefetch
      ffmpeg_6-headless
      sqlite
      yt-dlp
      sops
      #squirreldisk
      #qbittorrent
      #libreoffice
    ];
  };

  home.file.".config/scripts/screenshot_region.sh" = {
    text = ''
      #!/bin/bash
      timestamp=$(date +%Y-%m-%d_%H-%M-%S)
      filepath="$HOME/Pictures/Screenshots/Region_$timestamp.png"
      screencapture -i "$filepath"
      osascript -e "set the clipboard to (read (POSIX file \"$filepath\") as JPEG picture)"
    '';
    executable = true;
    enable = true;
  };

  home.file.".config/scripts/screenshot_screen.sh" = {
    text = ''
      #!/bin/bash
      timestamp=$(date +%Y-%m-%d_%H-%M-%S)
      filepath="$HOME/Pictures/Screenshots/Screen_$timestamp.png"
      screencapture "$filepath"
      osascript -e "set the clipboard to (read (POSIX file \"$filepath\") as JPEG picture)"
    '';
    executable = true;
    enable = true;
  };
}
