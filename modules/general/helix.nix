{ self, ... }:
{
  flake.nixosModules.helix = {
    # TODO change all the other wrapper installs to this method
    imports = [ self.wrappers.helix.install ];
    wrappers.helix.enable = true;
  };

  flake.wrappers.helix = { wlib, ... }: {
    imports = [ wlib.wrapperModules.helix ];
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
        w = "move_next_sub_word_start";
        e = "move_next_sub_word_end";
        b = "move_prev_sub_word_start";
      };
      keys.insert = {
        "C-s" = ":w";
      };
    };
  };
}
