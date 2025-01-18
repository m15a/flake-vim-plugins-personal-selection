final: _:

with final;

rec {
  devShells = rec {
    default = mkShell {
      inputsFrom = [
        ci-update
      ];
      packages = [
        fennel-ls
        luajit.pkgs.readline
      ];
    };

    ci-update = final.mkShell {
      packages = [
        final.nix
        final.jq.bin
        (final.luajit.withPackages (
          ps: with ps; [
            http
            cjson
            fennel
          ]
        ))
      ];
    };
  };
}
