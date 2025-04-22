{pkgs, ...}: {
  #programs.eza = {
  #  enable = true;
  #  #enableZshIntegration = true;
  #  colors = "always";
  #  git = true;
  #  icons = "always";
  #  extraOptions = ["--group-directories-first" "--header"];
  #};

  #config above does not seem to work for me
  #checking source, it looks like it just tries to create shell aliases, so that's what I will do too
  home.packages = [pkgs.eza];

  programs.zsh = {
    #enable = true;
    shellAliases = {
      ls = "eza --color always --icons always --git -h --group-directories-first";
      lt = "eza --color always --icons always --git -h --group-directories-first -lT";
    };
  };
}
