{ ... }:
{
  programs.domicile = {
    enable = true;

    # Keep Miracast opt-in: enabling it opens TCP/7236 and enables Avahi.
    miracast = false;
  };
}
