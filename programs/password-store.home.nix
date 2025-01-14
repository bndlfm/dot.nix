{ pkgs, ... }:{
  programs.password-store = {
    package = pkgs.pass.withExtensions (exts: [ exts.pass-otp ]);
  };
}
