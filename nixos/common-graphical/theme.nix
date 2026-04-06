{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    (magnetic-catppuccin-gtk.override {
      accent = [ "lavender" ];
    })
    catppuccin-cursors.mochaLavender
    catppuccin-cursors.mochaMaroon
    fkorpsvart-catppuccin-icons
  ];

  catppuccin = {
    accent = "lavender";
    flavor = "mocha";

    # global enable
    enable = true;
  };
}
