{pkgs, ...}: {
  programs.gh.enable = true;

  programs.git = {
    enable = true;
    extraConfig = {
      user.name = "Malchior95";
      user.email = "malchior95@gmail.com";
    };
  };
}
