{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    opencode-sandbox.url = "github:OpencodeSandbox/opencode-sandbox";
  };

  outputs = {
    self,
    nixpkgs,
    opencode-sandbox,
    ...
  }: let
    system = "x86_64-linux";
    pkgs = nixpkgs.legacyPackages.${system};
  in {
    packages.${system} = rec {
      sandbox = opencode-sandbox.packages.${system}.sandbox.override {
        opencode-sandbox = {
          git.remote.url = "https://github.com/Trantorian1/tt-metal.git";
          forwardPorts = [8888];
          env.extend = [devenv];
        };
      };

      devenv = pkgs.buildEnv {
        name = "devenv";
        paths = with pkgs; [nil alejandra];
      };

      default = sandbox;
    };

    devShells.${system}.default = pkgs.mkShell {
      packages = [self.packages.${system}.devenv];
    };
  };
}
