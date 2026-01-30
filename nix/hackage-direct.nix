{ haskell }:
hself: hsuper: {
  hyperbole = hself.callHackageDirect {
    pkg = "hyperbole";
    ver = "0.6.0";
    sha256 = "sha256-9kJhNbqN20SYfqdRoeDzdus8DXxka5Gqu5oWyhUgmHY=";
  } { };

  atomic-css = haskell.lib.dontCheck (
    hself.callHackageDirect {
      pkg = "atomic-css";
      ver = "0.2.0";
      sha256 = "sha256-16vwXrrWJm2zIKUDbhjpYOJA/vK9zXM6Qm1rd/x0PYg=";
    } { }
  );

  skeletest = hself.callHackageDirect {
    pkg = "skeletest";
    ver = "0.3.2";
    sha256 = "sha256-B8hFzph73qdHAMm0AJmP0XNjehc1kZYRCe19hPRbHy4=";
  } { };

  effectful = hself.callHackageDirect {
    pkg = "effectful";
    ver = "2.6.1.0";
    sha256 = "sha256-krNjGxqdbmFpt1g3anTd5ajGtYnyvGaG+AiDLfJN8No=";
  } { };

  effectful-core = hself.callHackageDirect {
    pkg = "effectful-core";
    ver = "2.6.1.0";
    sha256 = "sha256-0UTeE7JnUkNx77QobyjKjQFpUVQsz6a1E55WEohJ+hI=";
  } { };

  Diff = hself.callHackageDirect {
    pkg = "Diff";
    ver = "1.0.2";
    sha256 = "sha256-fRxDSt8/CSGyUrmGNwF22ASjEzIRGifNk3M9j9HrC2g=";
  } { };

  data-default = hself.callHackageDirect {
    pkg = "data-default";
    ver = "0.8.0.2";
    sha256 = "sha256-u3ida68KfdhGpHs4LiStuv49lsffxypf15dYYIHYcd4=";
  } { };

  tls = hself.callHackageDirect {
    pkg = "tls";
    ver = "2.2.1";
    sha256 = "sha256-XrksEXOsZDF+jn/rI5m2F+fIu05zCPcO5CZRXFNoeJY=";
  } { };

  crypton-asn1-encoding = hself.callHackageDirect {
    pkg = "crypton-asn1-encoding";
    ver = "0.10.0";
    sha256 = "sha256-dTP26qiOVnAb5XO/gibuG1rYI03vDTpBr6+L79PsjEA=";
  } { };

  crypton-asn1-types = hself.callHackageDirect {
    pkg = "crypton-asn1-types";
    ver = "0.4.1";
    sha256 = "sha256-+mjsNBKhhxFrNmCCMLPsugzlz/61Glqw8hKoYndy+wc=";
  } { };

  time-hourglass = hself.callHackageDirect {
    pkg = "time-hourglass";
    ver = "0.3.0";
    sha256 = "sha256-zVgLI6zt0FPFzRiey3wG6NLOT08ENDIweAUDyj0n1YU=";
  } { };

  base16 = hself.callHackageDirect {
    pkg = "base16";
    ver = "1.0";
    sha256 = "sha256-pLnipLnF7YuQvCwgw7Lp7sbwhab63sdEpubeSpaoEmY=";
    rev = {
      revision = "4";
      sha256 = "sha256-TdNBIoFo8s3gOVTdchde5yagcT4iAPbHtz9M2NIgc3c=";
    };
  } { };

}
