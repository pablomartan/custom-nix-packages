{pkgs, ...}:
with pkgs;
  maven.buildMavenPackage rec {
    pname = "autofirma";
    version = "1.8.2";
    owner = "ctt-gob-es";
    repo = "clienteafirma";
    rev = "v${version}";

    mvnHash = "sha256-CR3Xt5jqnlja4dEjicZvuYKZLPFiznA9+OqiRltRA3E=";
    mvnParameters = "-Denv=install";
    mvnJdk = jdk11;
    doCheck = false;

    nativeBuildInputs = [
      makeWrapper
    ];

    installPhase = ''
      mkdir -p $out/usr/{lib,share}
      mkdir -p $out/bin

      echo "#!/bin/bash\njava -Djdk.tls.maxHandshakeMessageSize=65536 -jar /usr/lib/AutoFirma/AutoFirma.jar "$@"" > autofirma

      install -Dm644 autofirma $out/bin/autofirma

      mkdir -p $out/usr/lib/firefox/defaults/pref
      install -Dm644 afirma-simple-installer/linux/instalador_deb/src/etc/firefox/pref/AutoFirma.js \
        $out/usr/lib/firefox/defaults/pref/autofirma.js

      mkdir -p $out/usr/share/java/autofirma
      install -Dm644 afirma-simple/target/AutoFirma.jar \
        $out/usr/share/java/autofirma/autofirma.jar

      mkdir -p $out/usr/share/pixmaps
      install -Dm644 afirma-simple-installer/linux/instalador_deb/src/usr/share/AutoFirma/AutoFirma.svg \
        $out/usr/share/pixmaps/autofirma.svg

      mkdir -p $out/usr/share/application
      install -Dm644 afirma-simple-installer/linux/instalador_deb/src/usr/share/applications/afirma.desktop \
        $out/usr/share/applications/autofirma.desktop

      mkdir -p $out/usr/share/licenses
      install -Dm644 afirma-simple-installer/linux/instalador_deb/src/usr/share/common-licenses/* \
          $out/usr/share/licenses

      makeWrapper ${jdk11}/bin/java $out/bin/autofirma \
        --add-flags "-jar $out/usr/share/java/autofirma/autofirma.jar"
    '';

    src = fetchFromGitHub {
      inherit owner;
      inherit repo;
      inherit rev;
      sha256 = "sha256-YtGtTeWDWwCCIikxs6Cyrypb0EBX2Q2sa3CBCmC6kK8=";
    };

    meta = with lib; {
      license = licenses.bsd3;
    };
  }
