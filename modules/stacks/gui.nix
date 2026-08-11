{ den, ... }:
{
  den.aspects.stackPipewire.includes = [
    den.aspects.pipewire
    den.aspects.pipewireClockRates
    den.aspects.pipewireVBCable
    den.aspects.pipewireVirtualSurround
  ];

  den.aspects.stackGui.includes = [
    den.aspects.commonGui
    den.aspects.commonPackagesGui
    den.aspects.stackPipewire
    den.aspects.defaultAppsGui
    den.aspects.virtualisationGui

    den.aspects.niri
    den.aspects.greetdNiriReGreet

    den.aspects.noctalia
    den.aspects.fuzzel
    den.aspects.kitty
    den.aspects.nemo
    den.aspects.mpv
    den.aspects.sublime
    den.aspects.zed

    den.aspects.gtkqtTheme
    den.aspects.noctaliaDynamicTheme
  ];
}
