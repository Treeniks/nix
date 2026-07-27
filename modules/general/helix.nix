{ self, ... }:
let
  settings = {
    theme = "rose_pine";
    editor = {
      line-number = "relative";
      cursor-shape.insert = "bar";
      cursor-shape.normal = "block";
      cursor-shape.select = "underline";
    };
    keys.normal = {
      "C-s" = ":w";
      # integrate yazi
      # see https://github.com/helix-editor/helix/discussions/12934#discussioncomment-12438498
      "C-y" = [
        ":sh rm -f /tmp/helix-yazi-integration"
        '':insert-output yazi "%{buffer_name}" --chooser-file=/tmp/helix-yazi-integration''
        '':sh printf "\x1b[?1049h\x1b[?2004h" > /dev/tty''
        ":open %sh{cat /tmp/helix-yazi-integration}"
        ":redraw"
      ];
      "S-s" = [
        "extend_to_line_bounds"
        "change_selection"
      ];
      "C-u" = [
        "page_cursor_half_up"
        "align_view_center"
      ];
      "C-d" = [
        "page_cursor_half_down"
        "align_view_center"
      ];
      "C-k" = "hover";
      w = "move_next_sub_word_start";
      e = "move_next_sub_word_end";
      b = "move_prev_sub_word_start";
      D = "kill_to_line_end";
      "$" = "extend_to_line_end";
    };
    keys.insert = {
      "C-s" = ":w";
    };
  };
in
{
  flake.nixosModules.helix = {
    # TODO change all the other wrapper installs to this method
    imports = [ self.wrappers.helix.install ];
    wrappers.helix.enable = true;

    environment.sessionVariables.EDITOR = "hx";
  };

  flake.homeModules.helix = { config, lib, ... }: {
    # Noctalia themeing only works when the config location of helix is writeable,
    # so we need to use home manager if that's the case.
    #
    # If I ever use helix more permanently and want more proper hot-reloading of the config,
    # I'll have the wrapper point to a fixed location on install instead, like I do with neovim.
    programs.helix = lib.mkIf config.my.noctalia-themeing {
      enable = true;
      settings = lib.mkMerge [
        settings
        { theme = lib.mkForce "noctalia"; }
      ];
    };
  };

  flake.wrappers.helix = { wlib, ... }: {
    imports = [ wlib.wrapperModules.helix ];
    inherit settings;
  };
}
