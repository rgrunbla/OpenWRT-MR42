{ stdenv
, lib
, fetchFromGitHub
, cacert
, envsubst
, file
, git
, gcc
, gnumake
, ncurses
, perl
, pkg-config
, unzip
, which
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
    cacert
    envsubst
    file
    git
    gcc
    gnumake
    ncurses
    perl
    pkg-config
    unzip
    which
  ];


  hardeningDisable = [ "format" ];


  meta = with lib; {
    homepage = "";
    description = "";
    license = licenses.mit;
    maintainers = with maintainers; [ rgrunbla ];
  };
}
