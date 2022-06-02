{
  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  inputs.home-manager.url = "github:nix-community/home-manager";

  outputs = { self, home-manager, nixpkgs }: {

    nixosConfigurations.gpg-test = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules =
        [
          ({ pkgs, ... }: {
              system.configurationRevision = nixpkgs.lib.mkIf (self ? rev) self.rev;
              users.users.user = {
                isNormalUser = true;
                home = "/home/user";
                initialPassword = "pass";
                extraGroups = [ "wheel" ];
              };
              home-manager.useGlobalPkgs = true;
              home-manager.users.user = {
                programs.gpg.enable = true;
                services.gpg-agent = {
                  enable = true;
                  pinentryFlavor = "tty";
                };
              };
            })
          home-manager.nixosModule
        ];
    };

  };
}
