{ stdenv
, lib
, fetchFromGitHub
, git
, perl
, gnumake
, gcc
, unzip
, utillinux
, python3
, rsync
, patch
, wget
, file
, subversion
, which
, pkgconfig
, openssl
, systemd
, binutils
, ncurses
, zlib
, glibc
}:

stdenv.mkDerivation {
  name = "OpenWRT-MR42";

  src = fetchFromGitHub {
    rev = "master";
    owner = "openwrt";
    repo = "openwrt";
    sha256 = "sha256-aIl/jeVL1r+73U1z67MINDMc15rDycj5KeUqEFzOzQo=";
  };

  buildInputs = [
    git
    perl
    gnumake
    gcc
    unzip
    utillinux
    python3
    rsync
    patch
    wget
    file
    subversion
    which
    pkgconfig
    openssl
    systemd
    binutils
    ncurses
    zlib
    zlib.static
    glibc.static
  ];

  hardeningDisable = [ "format" ];

  meta = with lib; {
    homepage = "";
    description = "";
    license = licenses.mit;
    maintainers = with maintainers; [ rgrunbla ];
  };
}
