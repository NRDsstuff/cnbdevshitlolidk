let
  nixpkgs = fetchTarball "https://github.com/NixOS/nixpkgs/tarball/nixos-23.11";
  pkgs = import nixpkgs { config = { allowUnfree = true; }; overlays = []; };
  authtoken = builtins.readFile ./.env;
in

pkgs.mkShellNoCC{
  packages = with pkgs; [
    ngrok
  ];

  shellHook = ''
    if [ -d "./site" ]; then
      cd site
      ${pkgs.nodejs_20}/bin/npm run dev
      ngrok config add-authtoken ${authtoken}
      ngrok http 5173
    else
      ${pkgs.git}/bin/git clone https://github.com/raluvy95/raluvy95.github.io
      cd site
      ${pkgs.nodejs_20}/bin/npm run dev
      ngrok config add-authtoken ${authtoken}
      ngrok http 5173
    fi
  '';
}