{ pkgs, ... }:
let

  jumptab = pkgs.fetchgit {
    url = "https://github.com/LinusVanElswijk/kitty-jumptab.git";
    sha256 = "sha256-xnB2kIcPhAaB2SvWajVfrpkcTh/9/l9xoIw2m/aznno=";
  };

  mainSettings = ''

    macos_option_as_alt yes
    macos_quit_when_last_window_closed yes
    tab_bar_style powerline

    allow_remote_control yes

    # jumptab open: focus or launch a predefined tab
    action_alias open kitten jumptab.py open --cwd=current
    map alt+1 open 1
    map alt+2 open 2
    map alt+3 open 3
    map alt+4 open 4
    map alt+5 open 5
    map alt+6 open 6
    map alt+7 open 7
    map alt+8 open 8
    map alt+9 open 9
  '';

  darkTheme = ''


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

  lightTheme = ''
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
in
{
  programs.kitty = {
    enable = true;
    font = {
      package = pkgs.nerd-fonts.jetbrains-mono;
      name = "JetBrainsMono Nerd Font";
      size = 14;
    };
    shellIntegration.enableZshIntegration = true;
    #extraConfig = builtins.readFile ./kitty.conf;
    extraConfig = mainSettings;

  };

  #files below are taken straigth from the source - in order to have kitty dynamically adjust to systme light/dark themes
  home.file.".config/kitty/no-preference.auto.conf".text = darkTheme;

  home.file.".config/kitty/dark-theme.auto.conf".text = darkTheme;

  home.file.".config/kitty/light-theme.auto.conf".text = lightTheme;

  home.file.".config/kitty/jumptab.py".text = builtins.readFile (jumptab + "/src/jumptab.py");
}
