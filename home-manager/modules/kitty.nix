{ pkgs, ... }: {
  programs.kitty = {
    enable = true;
    font = {
      package = pkgs.nerd-fonts.jetbrains-mono;
      name = "JetBrainsMono Nerd Font";
      size = 14;
    };
    #shellIntegration.enableZshIntegration = true; # does not seem to work in tmux
    #extraConfig = builtins.readFile ./kitty.conf;

  };

  #files below are taken straigth from the source - in order to have kitty dynamically adjust to systme light/dark themes
  home.file.".config/kitty/no-preference.auto.conf".text = ''
    # vim:ft=kitty
    ## name: Gruvbox Material Dark Medium
    ## author: Sainnhe Park
    ## license: MIT
    ## upstream: https://raw.githubusercontent.com/rsaihe/gruvbox-material-kitty/main/colors/gruvbox-material-dark-medium.conf
    ## blurb: A modified version of Gruvbox with softer contrasts

    background #282828
    foreground #d4be98

    selection_background #d4be98
    selection_foreground #282828

    cursor #a89984
    cursor_text_color background

    # Black
    color0 #665c54
    color8 #928374

    # Red
    color1 #ea6962
    color9 #ea6962

    # Green
    color2  #a9b665
    color10 #a9b665

    # Yellow
    color3  #e78a4e
    color11 #d8a657

    # Blue
    color4  #7daea3
    color12 #7daea3

    # Magenta
    color5  #d3869b
    color13 #d3869b

    # Cyan
    color6  #89b482
    color14 #89b482

    # White
    color7  #d4be98
    color15 #d4be98
  '';

  home.file.".config/kitty/dark-theme.auto.conf".text = ''
    # vim:ft=kitty
    ## name: Gruvbox Material Dark Medium
    ## author: Sainnhe Park
    ## license: MIT
    ## upstream: https://raw.githubusercontent.com/rsaihe/gruvbox-material-kitty/main/colors/gruvbox-material-dark-medium.conf
    ## blurb: A modified version of Gruvbox with softer contrasts

    background #282828
    foreground #d4be98

    selection_background #d4be98
    selection_foreground #282828

    cursor #a89984
    cursor_text_color background

    # Black
    color0 #665c54
    color8 #928374

    # Red
    color1 #ea6962
    color9 #ea6962

    # Green
    color2  #a9b665
    color10 #a9b665

    # Yellow
    color3  #e78a4e
    color11 #d8a657

    # Blue
    color4  #7daea3
    color12 #7daea3

    # Magenta
    color5  #d3869b
    color13 #d3869b

    # Cyan
    color6  #89b482
    color14 #89b482

    # White
    color7  #d4be98
    color15 #d4be98
  '';

  home.file.".config/kitty/light-theme.auto.conf".text = ''
    # vim:ft=kitty
    ## name: Gruvbox Material Light Medium
    ## author: Sainnhe Park
    ## license: MIT
    ## upstream: https://raw.githubusercontent.com/rsaihe/gruvbox-material-kitty/main/colors/gruvbox-material-light-medium.conf
    ## blurb: A modified version of Gruvbox with softer contrasts

    background #fbf1c7
    foreground #654735

    selection_background #654735
    selection_foreground #fbf1c7

    cursor #928374
    cursor_text_color background

    # Black
    color0 #bdae93
    color8 #928374

    # Red
    color1 #c14a4a
    color9 #c14a4a

    # Green
    color2  #6c782e
    color10 #6c782e

    # Yellow
    color3  #c35e0a
    color11 #b47109

    # Blue
    color4  #45707a
    color12 #45707a

    # Magenta
    color5  #945e80
    color13 #945e80

    # Cyan
    color6  #4c7a5d
    color14 #4c7a5d

    # White
    color7  #654735
    color15 #654735
  '';
}
