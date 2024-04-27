let
  nixpkgs = fetchTarball "https://github.com/NixOS/nixpkgs/tarball/nixos-23.11";
  pkgs = import nixpkgs { config = { allowUnfree = true; }; overlays = []; };
  authtoken = builtins.readFile ./.token;
in

pkgs.mkShellNoCC{
  packages = with pkgs; [
    ngrok
  ];

  shellHook = ''
    if [ -d "./site" ]; then
      ngrok config add-authtoken ${authtoken}
      cd site
      ${pkgs.nodejs_20}/bin/npm run dev
      ngrok http 5173
    else
      ngrok config add-authtoken ${authtoken}
      ${pkgs.git}/bin/git clone https://github.com/raluvy95/raluvy95.github.io site
      cd site
      ${pkgs.nodejs_20}/bin/npm i
      ${pkgs.nodejs_20}/bin/npm i -D vite
      ${pkgs.nodejs_20}/bin/npm run dev 
      ngrok http 5173
    fi
  '';
}
