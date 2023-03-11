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
    rev = "refs/tags/v{version}";
    hash = "sha256-WzrOCiIOdg3fBLKNjCPlr/XGrXC2424hO1nrwWXjx2A=";
  };

  cargoHash = "sha256-qGWRw71jrS7sl9+SYVff6aM6tXAFu3NGWWZkJ/vhwaY=";

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ systemd dbus openssl libssh2 libgit2 xz zlib ];

  postInstall = ''
    mv -v "$out/bin/ciel-rs" "$out/bin/ciel"
    env PREFIX="$out/" ./install-assets.sh
    # https://github.com/AOSC-Dev/ciel-rs/pull/15
    mv -v $out/share/fish/completions $out/share/fish/vendor_completions.d
  '';

  meta = with lib; {
    description = "A tool for controlling AOSC OS packaging environments using multi-layer filesystems and containers.";
    homepage = "https://github.com/AOSC-Dev/ciel-rs";
    license = licenses.mit;
    platforms = platforms.unix;
    maintainers = with maintainers; [ yisuidenghua ];
  };
}
