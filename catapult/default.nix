{pkgs, ...}:
pkgs.python3.pkgs.buildPythonApplication {
  name = "catapult";
  src = pkgs.fetchFromGitHub {
    owner = "otsaloma";
    repo = "catapult";
    rev = "1.1";
    sha256 = "sha256-hjbiiI9UNB8knM5GMdry1kVqbDPboKC8VXiJ1D2p1f4=";
  };

  nativeBuildInputs = with pkgs; [
    gettext
    glib
    gtk4
    pango
    libqalculate
  ];

  buildInputs = with pkgs; [
    wrapGAppsHook4
  ];

  dontWrapGApps = true;

  preFixup = ''
    makeWrapperArgs+=("''${gappsWrapperArgs[@]}")
  '';

  buildPhase = ''
    make PREFIX=$out build
  '';

  installPhase = ''
    make PREFIX=$out install
  '';

  format = "other";

  propagatedBuildInputs = with pkgs; [
    python3Packages.pygobject3
  ];
}
