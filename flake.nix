{
  description = "R development environment for dtlscores";

  inputs = {
    nixpkgs.url = "github:rstats-on-nix/nixpkgs/2026-03-11";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs { inherit system; };

        rpkgs = builtins.attrValues {
          inherit (pkgs.rPackages)
            devtools
            diffviewer
            languageserver
            rvest
						tidyverse
						gt
						ggplot2
						fitdistrplus
            targets;

        };

        tex = (pkgs.texlive.combine {
          inherit (pkgs.texlive)
            scheme-small
            collection-fontsextra;
        });

        system_packages = builtins.attrValues {
          inherit (pkgs)
            glibcLocales
            gnumake
            html-tidy
            nix
            pandoc
						qpdf
            R;

        };
      in
      {
        devShells.default = pkgs.mkShell {
          LOCALE_ARCHIVE = if pkgs.stdenv.hostPlatform.system == "x86_64-linux" then "${pkgs.glibcLocales}/lib/locale/locale-archive" else "";
          LANG = "en_US.UTF-8";
          LC_ALL = "en_US.UTF-8";
          LC_TIME = "en_US.UTF-8";
          LC_MONETARY = "en_US.UTF-8";
          LC_PAPER = "en_US.UTF-8";
          LC_MEASUREMENT = "en_US.UTF-8";

          buildInputs = [ rpkgs tex system_packages ];
        };
      }
    );
}
