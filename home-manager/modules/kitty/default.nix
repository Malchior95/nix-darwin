{pkgs, ...}: {
  programs.kitty = {
    enable = true;
    font = {
      package = pkgs.nerd-fonts.jetbrains-mono;
      name = "JetBrainsMono Nerd Font";
      size = 12;
    };
    extraConfig = builtins.readFile ./kitty.conf;
  };
}
