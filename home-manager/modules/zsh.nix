{pkgs, ...}: {
  programs.zsh = {
    enable = true;
    syntaxHighlighting.enable = true;
    shellAliases = {
      rm = "echo 'Do not use rm to remove files. Use rip instead. Use backslash rf if you are absolutely certain.'";
    };
    oh-my-zsh = {
      enable = true;
      plugins = ["git"];
      theme = "robbyrussell";
    };
    history.ignoreAllDups = true;
    initExtra = ''if [ "$TMUX" = "" ]; then tmux; fi'';
  };
}
