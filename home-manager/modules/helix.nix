{ pkgs, ... }: {
  programs.yazi = let
    gruvboxSource = pkgs.fetchgit {
      url = "https://github.com/bennyyip/gruvbox-dark.yazi";
      sha256 = "sha256-RWqyAdETD/EkDVGcnBPiMcw1mSd78Aayky9yoxSsry4=";
    };

    grv = pkgs.stdenv.mkDerivation {
      pname = "yazi-gruvbox-theme";
      version = "1.0";
      src = gruvboxSource;
      installPhase = ''
        mkdir $out
        cp -r * $out
      '';
    };
  in {
    enable = true;
    enableZshIntegration = true;
    flavors = { gruvbox-dark = grv; };
    theme = {
      flavor = {
        dark = "gruvbox-dark";
        light = "gruvbox-dark";
      };
    };
  };

  programs.helix = {
    enable = true;
    settings = {
      theme = "gruvbox";
      editor = {
        bufferline = "always";
        line-number = "relative";
        lsp = {
          display-messages = true;
          #display-inlay-hints = true;
        };
        inline-diagnostics = {
          cursor-line = "hint";
          other-lines = "hint";
        };
        cursor-shape = {
          insert = "bar";
          normal = "block";
          select = "underline";
        };
      };
    };
    languages = {
      language = [
        {
          name = "nix";
          auto-format = true;
          formatter.command = "${pkgs.nixfmt}/bin/nixfmt";
        }
        {
          name = "rust";
          auto-format = true;
          formatter.command = "${pkgs.rustfmt}/bin/rustfmt";
        }
      ];

      language-server = {
        rust-analyzer = {
          command = "${pkgs.rust-analyzer}/bin/rust-analyzer";
          config = {
            #check = {
            #  command = "${pkgs.clippy}/bin/clippy";
            #};
            cargo = { features = "all"; };
          };
        };
      };
    };
  };
}
