{ pkgs, ...}:

pkgs.stdenv.mkDerivation rec {
    pname = "openfortivpn-webview";
    version = "1.20";
    owner = "gm-vm";
    repo = "openfortivpn-webview";
    rev = "36fd3ea39306152470ab202e9049f282822a0eef";

    src = pkgs.fetchFromGitHub {
        owner = owner;
        repo = repo;
        rev = rev;
        sha256 = "sha256-BM5hurJDPYpbt2WV6C1dldLx2wD9eDZlTK/TeHXpmY0=";
    };

    buildInputs = with pkgs.qt6; [ qmake qtwebengine qtwayland ];

    nativeBuildInputs = with pkgs.qt6; [ wrapQtAppsHook qtwebengine qtwayland ];
    dontWrapQtApps = false;

    configurePhase = ''
        cd ./openfortivpn-webview-qt
    '';

    buildPhase = ''
        qmake . DESTDIR=$out/bin && make
    '';
}
