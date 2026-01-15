{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    (magnetic-catppuccin-gtk.override { accent = [ "purple" ]; })
    catppuccin-cursors.mochaLavender
    fkorpsvart-catppuccin-icons
  ];

  catppuccin = {
    accent = "lavender";
    flavor = "mocha";

    # global enable
    enable = true;
  };
}
