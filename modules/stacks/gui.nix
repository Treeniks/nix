{ treeniks, ... }:
{
  treeniks.stackPipewire.includes = [
    treeniks.pipewire
    treeniks.pipewireClockRates
    treeniks.pipewireVBCable
    treeniks.pipewireVirtualSurround
  ];

  treeniks.stackGui.includes = [
    treeniks.commonGui
    treeniks.commonPackagesGui
    treeniks.stackPipewire
    treeniks.defaultAppsGui
    treeniks.virtualisationGui

    treeniks.niri
    treeniks.greetdNiriReGreet

    treeniks.noctalia
    treeniks.umbriel

    treeniks.fuzzel
    treeniks.kitty
    treeniks.nemo
    treeniks.mpv
    treeniks.sublime
    treeniks.zed
    treeniks.firefox

    treeniks.gtkqtTheme
    treeniks.noctaliaDynamicTheme
  ];
}
