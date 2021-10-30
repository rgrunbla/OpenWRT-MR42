{ stdenv
, buildFHSUserEnv
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
, clang
, pkgs
, cacert
}:

let
  fixWrapper = pkgs.runCommand "fix-wrapper" { } ''
    mkdir -p $out/bin
    for i in ${pkgs.gcc.cc}/bin/*-gnu-gcc*; do
      ln -s ${pkgs.gcc}/bin/gcc $out/bin/$(basename "$i")
    done
    for i in ${pkgs.gcc.cc}/bin/*-gnu-{g++,c++}*; do
      ln -s ${pkgs.gcc}/bin/g++ $out/bin/$(basename "$i")
    done
  '';
  fhs = buildFHSUserEnv {
    name = "openwrt-env";

    targetPkgs = _: [
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
      fixWrapper
    ];
    multiPkgs = null;
    extraOutputsToInstall = [ "dev" ];

    profile = ''
      export GIT_SSL_CAINFO="${cacert}/etc/ssl/certs/ca-bundle.crt";
    '';
  };

in

stdenv.mkDerivation {
  pname = "OpenWRT-MR42";
  version = "1";
  src = fetchFromGitHub {
    rev = "cryptid";
    owner = "clayface";
    repo = "openwrt";
    sha256 = "sha256-2O9gJJev4c78MYgOuSzmH7YlMMJOUbmNSDjlyPar/iE=";
  };

  outputHashAlgo = "sha256";
  outputHashMode = "recursive";
  outputHash = "";

  configurePhase = ''
    cp ${./menuconfig} .config
  '';

hardeningDisable = [ "all" ];

  buildPhase = ''
    ${fhs}/bin/openwrt-env -c 'env'
    ${fhs}/bin/openwrt-env -c 'make -j1 V=sc'
  '';

  installPhase = ''

  '';

  meta = with lib; {
    homepage = "";
    description = "";
    license = licenses.mit;
    maintainers = with maintainers; [ rgrunbla ];
  };
}
