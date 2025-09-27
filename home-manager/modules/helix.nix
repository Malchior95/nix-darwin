{ pkgs, inputs, ... }:
{
  programs.yazi =
    let
      gruvboxSource = pkgs.fetchgit {
        url = "https://github.com/bennyyip/gruvbox-dark.yazi";
        sha256 = "sha256-NeePBNhMVXyIrED4Iu4ZSHwwgsd3CV8oBzYoQOWsD/U=";
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

    in
    {
      enable = true;
      enableZshIntegration = true;
      flavors = {
        gruvbox-dark = grv;
      };
      theme = {
        flavor = {
          dark = "gruvbox-dark";
          light = "gruvbox-dark"; # TODO: need light theme
        };
      };
    };

  home.packages = with pkgs; [
    #rust
    # rustc
    # cargo
    rustup
    # clippy
    # rustfmt
    cargo-generate
    # rust-analyzer
    #web
    bun
  ];

  programs.helix =
    let
      crates-lsp-source = pkgs.fetchgit {
        url = "https://github.com/MathiasPius/crates-lsp.git";
        sha256 = "sha256-s42nWQC2tD7vhQNPdTQNRokwXqeBhELidVYTlos+No0=";
      };
      crates-lsp-drv = pkgs.rustPlatform.buildRustPackage {
        pname = "crates-lsp";
        version = "1.0";
        src = crates-lsp-source;
        cargoLock = {
          lockFile = "${crates-lsp-source}/Cargo.lock";
        };
      };

    in
    {
      enable = true;
      #package = inputs.helix.packages.${pkgs.system}.default;
      package = pkgs.buildEnv {
        # adding clippy to helix runtime closure - I want clippy to always be available in helix
        name = "helix-with-clippy";
        paths = [
          # inputs.helix.packages.${pkgs.system}.default
          pkgs.helix
          # pkgs.clippy
          # pkgs.rustfmt
          pkgs.markdown-oxide
        ];
      };
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
        C-g = ":insert-output kitty @ launch --type=tab --cwd=current zsh --interactive ${../../scripts/lazygit.sh} > /dev/null"
        space.0 = ":insert-output kitty @ launch --type=tab --cwd=current zsh --interactive ${../../scripts/git_diff_delta.sh} %{buffer_name} > /dev/null"
        C-9 = [
          ':theme gruvbox_light_soft'
        ]
        C-0 = [
          ':theme gruvbox'
        ]
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
            # formatter.command = "${pkgs.rustfmt}/bin/rustfmt";
            # formatter =
            #   let maudfmt = inputs.maudfmt.packages.${pkgs.system}.default;
            #   in {
            #     command = "bash";
            #     #args = [ "-c" "rustfmt | dx fmt -f -" ];
            #     args = [
            #       "-c"
            #       "${pkgs.rustfmt}/bin/rustfmt | ${maudfmt}/bin/maudfmt -s"
            #     ];
            #   };
          }
          {
            name = "markdown";
            auto-format = true;
          }
          {
            name = "c-sharp";
            auto-format = true;
            language-servers = [ "omnisharp" ];
          }
          {
            name = "toml";

            auto-format = true;
            formatter = {
              command = "${pkgs.taplo}/bin/taplo";
              args = [
                "format"
                "-"
              ];
            };
            language-servers = [
              {
                name = "crates-lsp";
                except-features = [ "format" ];
              }
              "taplo"
            ];
          }
          {
            name = "typescript";
            language-servers = [ "typescript-language-server" ];
            formatter = {
              command = "${pkgs.prettier}/bin/prettier";
              args = [
                "--parser"
                "typescript"
              ];
            };
            auto-format = true;
          }

          {
            name = "html";
            language-servers = [ "vscode-html-language-server" ];
            formatter = {
              command = "${pkgs.prettier}/bin/prettier";
              args = [
                "--parser"
                "html"
              ];
            };
            auto-format = true;
          }
          {
            name = "css";
            language-servers = [ "vscode-css-language-server" ];
            formatter = {
              command = "${pkgs.prettier}/bin/prettier";
              args = [
                "--parser"
                "css"
              ];
            };
            auto-format = true;
          }
          {
            name = "json";
            formatter = {
              command = "${pkgs.prettier}/bin/prettier";
              args = [
                "--parser"
                "json"
              ];
            };
            auto-format = true;
          }
          {
            name = "svelte";
            # formatter = {

            #   command = "${pkgs.prettier}/bin/prettier";
            #   args = [
            #     "--parser"
            #     "svelte"
            #   ];
            # };
            language-servers = [ "svelte-language-server" ];
            auto-format = true;
          }
        ];

        language-server = {
          #ok, so I'm having the following problem - I have installed nightly rust in one of the direnvs and it conflicts with older
          # version of rust-analyzer here. What do?
          rust-analyzer = {

            #ok, I don't know how to approach this anymore. Rust-analyzer needs to match version with the project rustc compiled binary
            #command = "${pkgs.rust-analyzer}/bin/rust-analyzer";
            command = "rust-analyzer";
            config = {
              check = {
                command = "clippy";
              }; # the problem here is that clippy is not run as a binary, but as cargo run, so I cannot invoke pkgs.clippy here
              cargo = {
                features = "all";
              };
            };
          };
          omnisharp = {
            command = "${pkgs.omnisharp-roslyn}/bin/omnisharp";
            args = [
              "-l"
              "Error"
              "--languageserver"
              "-z"
            ];
          };
          nil = {
            command = "${pkgs.nil}/bin/nil";
            config.nil = {
              formatting.command = [ "${pkgs.nixpkgs-fmt}/bin/nixpkgs-fmt" ];
              nix.flake.autoEvalInputs = true;
            };
          };
          crates-lsp = {
            command = "${crates-lsp-drv}/bin/crates-lsp";
          };
          typescript-language-server = {
            command = "${pkgs.typescript-language-server}/bin/typescript-language-server";
          };
          taplo = {
            command = "${pkgs.taplo}/bin/taplo";
          };
          vscode-html-language-server = {
            command = "${pkgs.vscode-langservers-extracted}/bin/vscode-html-language-server";
          };
          vscode-css-language-server = {
            command = "${pkgs.vscode-langservers-extracted}/bin/vscode-css-language-server";
          };
          svelte-language-server = {
            command = "${pkgs.svelte-language-server}/bin/svelteserver";
            args = [
              "--stdio"
              "--log=error"
            ];
          };
        };
      };
    };

  #syntax injection
  # home.file.".config/helix/runtime/queries/typescript/injections.scm".text = ''
  #    ((string_expression) @html
  #   (#match? @html ".*<.*>.*"))
  # '';

  home.file.".config/helix/runtime/queries/rust/injections.scm".text =
    builtins.readFile (pkgs.helix + "/lib/runtime/queries/rust/injections.scm")
    + ''
      ((block_comment) @_comment
      (raw_string_literal (string_content) @injection.content)
         (#eq? @_comment "/*html*/")
        (#set! injection.language "html")
      )

      ((block_comment) @_comment
      (raw_string_literal (string_content) @injection.content)
         (#eq? @_comment "/*css*/")
        (#set! injection.language "css")
      )

            ((block_comment) @_comment
      (raw_string_literal (string_content) @injection.content)
         (#eq? @_comment "/*sql*/")
        (#set! injection.language "sql")
      )
    '';

  home.file.".config/helix/runtime/queries/ecma/injections.scm".text =
    builtins.readFile (pkgs.helix + "/lib/runtime/queries/ecma/injections.scm")
    + ''
      ((comment) @_comment
      . (template_string) @injection.content
         (#eq? @_comment "/*html*/")
        (#set! injection.language "html")
      )


      ((comment) @_comment
      . (template_string) @injection.content
         (#eq? @_comment "/*css*/")
        (#set! injection.language "css")
      )

    '';
}
