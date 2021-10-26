{
  description = "A flake to build OpenWRT";
  inputs = {
    nixpkgs.url = github:NixOS/nixpkgs/nixos-21.05;
    rgrunbla-pkgs.url = github:rgrunbla/Flakes;
  };

  outputs = { self, nixpkgs, rgrunbla-pkgs }:
    with import nixpkgs { system = "x86_64-linux"; };
    {
      packages.x86_64-linux.openwrt-mr42 = callPackage ./pkgs/openwrt-mr42.nix { };
      packages.x86_64-linux.defaultPackage.x86_64-linux = self.packages.x86_64-linux.openwrt-mr42;
    };
}
