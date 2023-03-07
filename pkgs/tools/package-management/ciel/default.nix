{ lib
, fetchFromGitHub
, rustPlatform
, systemd
, dbus
, openssl
, libssh2
, fetchurl
, xz
, pkg-config
, libgit2
, zlib
}:

rustPlatform.buildRustPackage rec {
  pname = "ciel";
  version = "3.1.3";

  src = fetchFromGitHub {
    owner = "AOSC-Dev";
    repo = "ciel-rs";
    rev = "02eac316765f27239b7b17176df812da702895cd";
    hash = "sha256-WzrOCiIOdg3fBLKNjCPlr/XGrXC2424hO1nrwWXjx2A=";
  };

  nativeBuildInputs = [ pkg-config zlib ];

  doCheck = false;

  buildInputs = [ systemd dbus openssl libssh2 libgit2 xz ];

  cargoLock = {
    lockFile = fetchurl {
      url = "https://raw.githubusercontent.com/AOSC-Dev/ciel-rs/02eac316765f27239b7b17176df812da702895cd/Cargo.lock";
      sha256 = "sha256-hFjKf3psCj9ntQaKpVjeIhnWh5EzKphsTr82LXZ9XsA=";
    };
    outputHashes = {
      "libmount-0.1.15" = "sha256-g3UbVVQjbZ82Nunat5a9RKwd73Y/mMtiCfAifr6k00U=";
    };
  };

  postInstall = ''
    mv -v "$out/bin/ciel-rs" "$out/bin/ciel"
  '';

  meta = with lib; {
    description = "A tool for controlling multi-layer file systems and containers.";
    homepage = "https://www.rustup.rs/";
    license = licenses.mit;
    platforms = platforms.unix;
    maintainers = with maintainers; [ yisuidenghua ];
  };
}
