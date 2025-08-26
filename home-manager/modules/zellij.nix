{ pkgs, ... }:
{
  programs.zellij = {
    enable = false;
    enableZshIntegration = true;
    settings = {
      theme = "gruvbox-dark";
    };
  };
}
