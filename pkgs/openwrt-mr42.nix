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
, curl
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
      curl
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

openwrt-mr42-sources = stdenv.mkDerivation {
  pname = "OpenWRT-MR42-Source";
  version = "1";
  src = fetchFromGitHub {
    rev = "cryptid";
    owner = "clayface";
    repo = "openwrt";
    sha256 = "sha256-mxPWFDLAhBjr2Iq7XEUtF/k9mzoIRGNFi1QRXMuluC4=";
  };

  outputHashAlgo = "sha256";
  outputHashMode = "recursive";
  outputHash = "sha256-e+uGgzgV/50O8H3HXsoEk2wRiw4EIDvCsGYiGfXMkM0=";

  dontBuild = true;

  configurePhase = ''
    cp ${./menuconfig} .config
    ${fhs}/bin/openwrt-env -c 'make download'
  '';

  installPhase = ''
    rm ./tmp/.packageusergroup
    rm ./tmp/.config-package.in
    mkdir -p $out/src
    cp -r * $out/src/
  '';

  meta = with lib; {
    homepage = "";
    description = "";
    license = licenses.mit;
    maintainers = with maintainers; [ rgrunbla ];
  };
};

in

stdenv.mkDerivation {
  pname = "OpenWRT-MR42";
  version = "1";
  src = openwrt-mr42-sources.out;

  configurePhase = ''
    cp ${./menuconfig} .config
    find ./ -iname "*util-linux-2.37*"
  '';

  hardeningDisable = [ "all" ];
  GIT_SSL_CAINFO = "${cacert}/etc/ssl/certs/ca-bundle.crt";

  buildPhase = ''
    ${fhs}/bin/openwrt-env -c 'env'
    ${fhs}/bin/openwrt-env -c 'make -j8 || true' || true
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
