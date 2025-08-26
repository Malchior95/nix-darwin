{ pkgs, ... }: {
  programs.gh.enable = true;

  programs.git = {
    enable = true;
    extraConfig = {
      user.name = "Malchior95";
      user.email = "malchior95@gmail.com";
    };
  };

  home.packages = [ pkgs.delta ];

  programs.lazygit = {
    enable = true;
    settings = {
      customCommands = [{
        key = "L";
        command =
          "git diff HEAD -- {{ .SelectedFile.Name | quote }} | delta -s";
        output = "terminal";
        context = "files";
      }];
      # git = {
      #   paging = {
      #     colorArgs = "always";
      #     pager = "${pkgs.delta}/bin/delta --paging=never -s";
      #   };
      # };
    };
  };
}
