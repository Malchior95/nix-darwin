{ pkgs, inputs, ... }: {
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

  programs.helix = let
    crates-lsp-source = pkgs.fetchgit {
      url = "https://github.com/MathiasPius/crates-lsp.git";
      sha256 = "sha256-r+bSc98YsUc5ANc8WbXI8N2wdEF53uJoWQbsBHYmrGc=";
    };
    crates-lsp-drv = pkgs.rustPlatform.buildRustPackage {
      pname = "crates-lsp";
      version = "1.0";
      src = crates-lsp-source;
      cargoLock = { lockFile = "${crates-lsp-source}/Cargo.lock"; };
    };

  in {
    enable = true;
    package = inputs.helix.packages.${pkgs.system}.default;
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
    extraConfig = ''
      [keys.normal]
      C-y = [
        ':sh rm -f /tmp/unique-file',
        ':insert-output ${pkgs.yazi}/bin/yazi %{buffer_name} --chooser-file=/tmp/unique-file',
        ':insert-output echo "\x1b[?1049h\x1b[?2004h" > /dev/tty',
        ':open %sh{cat /tmp/unique-file}',
        ':redraw',
        ':set mouse false',
        ':set mouse true',
      ]
    '';
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
        {
          name = "c-sharp";
          language-servers = [ "omnisharp" ];
        }
        {
          name = "toml";
          language-servers = [{
            name = "crates-lsp";
            except-features = [ "format" ];
          }];
        }
        {
          name = "typescript";
          language-servers = [ "typescript-language-server" ];
          formatter = {
            command = "${pkgs.prettier}/bin/prettier";
            args = [ "--parser" "typescript" ];
          };
          auto-format = true;
        }

        # {
        #   name = "html";
        #   language-servers = [ "vscode-html-language-server" ];
        #   formatter = {
        #     command = "${pkgs.prettier}/bin/prettier";
        #     args = [ "--parser" "html" ];
        #   };
        #   auto-format = true;
        # }
        # {
        #   name = "css";
        #   language-servers = [ "vscode-css-language-server" ];
        #   formatter = {
        #     command = "${pkgs.prettier}/bin/prettier";
        #     args = [ "--parser" "css" ];
        #   };
        #   auto-format = true;
        # }
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
        omnisharp = {
          command = "${pkgs.omnisharp-roslyn}/bin/omnisharp";
          args = [ "-l" "Error" "--languageserver" "-z" ];
        };
        nil = {
          command = "${pkgs.nil}/bin/nil";
          config.nil = {
            formatting.command = [ "${pkgs.nixpkgs-fmt}/bin/nixpkgs-fmt" ];
            nix.flake.autoEvalInputs = true;
          };
        };
        crates-lsp = { command = "${crates-lsp-drv}/bin/crates-lsp"; };
        typescript-language-server = {
          command =
            "${pkgs.typescript-language-server}/bin/typescript-language-server";
        };
      };
    };
  };
}
