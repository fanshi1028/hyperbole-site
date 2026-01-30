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

}
