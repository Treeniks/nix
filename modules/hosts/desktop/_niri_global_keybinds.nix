{
  pkgs,
  lib,
}:
pkgs.writeScriptBin "niri-global-keybind" ''
  #!${lib.getExe pkgs.python3}

  import subprocess
  import json
  import sys

  def run(cmd):
      return subprocess.run(cmd, capture_output=True, text=True).stdout

  focused_window = json.loads(run(["niri", "msg", "-j", "focused-window"]))
  windows = json.loads(run(["niri", "msg", "-j", "windows"]))

  obs_id = None
  for w in windows:
      app_id = w["app_id"]
      if app_id == sys.argv[1]:
          obs_id = w["id"]

  if obs_id is None:
      print(f"{sys.argv[1]} not found")
      exit(1)

  run(["niri", "msg", "action", "focus-window", "--id", str(obs_id)])
  run(["${lib.getExe pkgs.wtype}", "-k", sys.argv[2]])
  try:
      prev_focus_id = focused_window["id"]
      run(["niri", "msg", "action", "focus-window", "--id", str(prev_focus_id)])
  except:
      # there was no window focused
      pass
''
