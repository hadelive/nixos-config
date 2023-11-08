{ pkgs, ... }:
{
  time.timeZone = "Asia/Ho_Chi_Minh";

  # fcitx with Unikey engine for Vietnamese.
  i18n.inputMethod = {
    enabled = "fcitx";
    fcitx.engines = [ pkgs.fcitx-engines.unikey ];
  };
}
