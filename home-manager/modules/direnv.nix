{pkgs, ...}: {
  #direnv will prevent dev shells from getting garbage collected
  # use `$ echo "use flake" >> .envrc && direnv allow` to make an existing dev env persistent
  # use $ nix flake new -t github:nix-community/nix-direnv <desired output path> for a new persisten flake
  programs.direnv = {
    enable = true;
    enableZshIntegration = true;
    nix-direnv.enable = true;
  };

  programs.zsh.shellAliases.direnv-init = ''echo "use flake" >> .envrc && direnv allow'';
}
