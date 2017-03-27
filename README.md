# Description
Utility to quickly disable/enable SteamVR to avoid it opening constantly when playing VR-compatible games without a HMD plugged in (see bug report [here](https://github.com/ValveSoftware/openvr/issues/428))

# Using the program
Program loads into system tray. Right click on it and use its context menu to: 1) Disable SteamVR, 2) Enable SteamVR, 3) Exit the program

When SteamVR is "enabled" (default directory name), the current (buggy) behavior is exhibited. When SteamVR is "disabled" (directory renamed so steam doesn't think it's installed), any checks for VR will return false and not open SteamVR. While useful for preventing SteamVR from opening when a headset isn't plugged in, you may also find this useful in the event you have a headset plugged in but don't want games to use it.

The program does not need to be open all the time -- it can be opened only when you want to toggle SteamVR off/on and closed when you're done, but it's very lightweight so there's no downside to leaving it open in your system tray / opening it on boot if you'd prefer to do that. You may also get a Windows SmartScreen popup when you first run this, which you'll need to confirm that you want to run the program.

# Modifying the program

**Custom Install Path:** If you have a custom install directory for SteamVR (not C:\Program Files (x86)\Steam\steamapps\common\SteamVR), create a shortcut to the exe and pass the custom directory as a parameter. For instance, if SteamVR was installed to D:\Steam\steamapps\common\SteamVR, the "Target" field for the shortcut would be "..\SteamVR Fix.exe" "D:\Steam\steamapps\common\SteamVR"

**Icons:** Since AutoHotkey (implementation language) doesn't support packaging icons into compiled executables, I injected them after compliation using a 3rd-party tool. If the executable is recompiled, the icons will be missing, and will need to manually be re-added. You may use any tool to add the icons to the EXE: the default icon needs to be in position `#1`, the enabled icon needs to be in position `#2`, and the disabled icon needs to be in position `#3`.

Injecting icons in IcoFX 2: 
1. Open Tools > Icon Resource Editor
2. Click Open and open compiled EXE
3. Click Add and select the three icons
4. Edit the properties of each icon and ensure the default is #1, the enabled icon is #2, and the disabled icon is #3
