{
  description = "A Nix-flake-based Pulumi development environment";

  inputs.nixpkgs.url = "github:auxolotl/nixpkgs/nixpkgs-unstable";

  outputs = { self, nixpkgs }:
    let
      supportedSystems = [ "x86_64-linux" "aarch64-linux" "x86_64-darwin" "aarch64-darwin" ];
      forEachSupportedSystem = f: nixpkgs.lib.genAttrs supportedSystems (system: f {
        pkgs = import nixpkgs { inherit system; };
      });
    in
    {
      devShells = forEachSupportedSystem ({ pkgs }: {
        default = pkgs.mkShell {
          packages = with pkgs; [
            # Pulumi plus:
            # pulumi-watch
            # pulumi-analyzer-* utilities
            # pulumi-language-* utilities
            # pulumi-resource-* utilities
            pulumi-bin

            # Python SDK
            python311

            # Go SDK
            go_1_22

            # Node.js SDK
            nodejs

            # .NET SDK
            dotnet-sdk_6

            # Java SDK
            jdk
            maven

            # Kubernetes
            kubectl

            # Miscellaneous utilities
            jq
          ];
        };
      });
    };
}
