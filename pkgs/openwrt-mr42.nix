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
, systemd
, binutils
, ncurses
, zlib
, coreutils
, curl
, cacert
, re2c
, help2man
, ninja
, cmake
, bison
}:

stdenv.mkDerivation {
  name = "OpenWRT-MR42";

  src = fetchFromGitHub {
    rev = "cryptid";
    owner = "clayface";
    repo = "openwrt";
    sha256 = "sha256-2O9gJJev4c78MYgOuSzmH7YlMMJOUbmNSDjlyPar/iE=";
  };

  outputHashAlgo = "sha256";
  outputHashMode = "recursive";
  outputHash = "";
  CXXFLAGS = "-std=c++17";

  buildInputs = [
    git
    perl
    gnumake
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
    systemd
    ncurses
    zlib
    zlib.static
    coreutils
    curl
    re2c
    help2man
    ninja
    cmake
    bison
  ];

  GIT_SSL_CAINFO = "${cacert}/etc/ssl/certs/ca-bundle.crt";

  patchPhase = ''
    find ./ -type f -exec sed -i "s_/usr/bin/env_${coreutils}/bin/env_g" {} \;
  '';

  configurePhase = ''
    cp ${./menuconfig} .config
  '';

  buildPhase = ''
    make -j1 V=s
  '';

  hardeningDisable = [ "all" ];

  meta = with lib; {
    homepage = "";
    description = "";
    license = licenses.mit;
    maintainers = with maintainers; [ rgrunbla ];
  };
}
