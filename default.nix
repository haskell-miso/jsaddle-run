with (builtins.fromJSON (builtins.readFile ./nixpkgs.json));

{}:

let
  nixpkgs = builtins.fetchTarball {
    url = "https://github.com/alexfmpe/nixpkgs/archive/${rev}.tar.gz";
    inherit sha256;
  };
  pkgs = import nixpkgs {};
  source = {
    jsaddle = pkgs.fetchFromGitHub {
       owner = "ghcjs";
       repo = "jsaddle";
       rev = "2513cd19184376ac8a2f0e3797a1ae7d2e522e87";
       hash = "sha256-xJ3BLiFtQmH92Y0jqIgdzJqidQHm3M1ZKHRAUEgNZF0=";
     };
    jsaddle-run = ./.;
  };

  overrides = self: super: with pkgs.haskell.lib; {
    jsaddle-run =
        self.callCabal2nix "jsaddle-run" source.jsaddle-run {};
    jsaddle =
        self.callCabal2nix "jsaddle" "${source.jsaddle}/jsaddle" {};
    jsaddle-warp =
        dontCheck (self.callCabal2nix "jsaddle-warp" "${source.jsaddle}/jsaddle-warp" {});

     /* cruft */
     crypton = dontCheck super.crypton;

  };

  hPkgs =
    pkgs.haskell.packages.ghc9122.override { inherit overrides; };

in

{
  inherit (hPkgs) jsaddle-run;
}
