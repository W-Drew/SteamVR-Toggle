#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.

global steamVRPath := "C:\Program Files (x86)\Steam\steamapps\common\SteamVR"

getSteamVREnabled() {
	defaultExists := InStr(FileExist(steamVRPath), "D") > 0
	disabledExists := InStr(FileExist(steamVRPath . "_Disabled"), "D") > 0
	
	return % (defaultExists && disabledExists) ? 2 : defaultExists ? 1 : disabledExists ? 0 : -1
}

getSteamVRFolder() {
	enabled := getSteamVREnabled()	
	return % (enabled = 1) ? steamVRPath : (enabled = 0) ? steamVRPath . "_Disabled" :
}

updateIcon() {
	enabled := getSteamVREnabled()
	tooltip := ""
	icon := 1
	
	if (enabled = 0) {
		icon := 3
		tooltip := "SteamVR is disabled"
	} else if (enabled = 1) {
		icon := 2
		tooltip := "SteamVR is enabled"
	} else if (enabled = 2) {
		tooltip := "SteamVR is installed twice"
	} else if (enabled = -1) {
		tooltip := "SteamVR is not installed"
	}
	
	Menu, tray, Icon, %A_ScriptFullPath%, %icon%,1
	Menu, tray, Tip, %tooltip%
}

toggleSteamVREnabled(enabled) {
	steamVRFolder := getSteamVRFolder()
	if (steamVRFolder) {
		targetName := (enabled ? steamVRPath : steamVRPath . "_Disabled")
		FileMoveDir, %steamVRFolder%, %targetName%
	}
	updateIcon()
}

updateIcon()
#Persistent
	Menu, tray, NoStandard
	Menu, tray, add, Disable SteamVR, Disable
	Menu, tray, add, Enable SteamVR, Enable
	Menu, tray, add
	Menu, tray, add, Exit, ExitScript
return

Disable:
	toggleSteamVREnabled(false)
return

Enable:
	toggleSteamVREnabled(true)
return

ExitScript:
	ExitApp
return