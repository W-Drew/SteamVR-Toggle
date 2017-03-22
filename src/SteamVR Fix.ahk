#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.

;Default SteamVR install path. Change if you installed it elsewhere
global steamVRPath := "C:\Program Files (x86)\Steam\steamapps\common\SteamVR"

getSteamVREnabled() {
	defaultExists := InStr(FileExist(steamVRPath), "D") > 0 ;Default install dir exists
	disabledExists := InStr(FileExist(steamVRPath . "_Disabled"), "D") > 0 ;install dir renamed to "SteamVR_Disabled" exists
	
	;-1: SteamVR is not installed or has non-standard name
	; 0: disabled
	; 1: enabled
	; 2: SteamVR was installed again while it was disabled and now there are two (delete _Disabled dir)
	return % (defaultExists && disabledExists) ? 2 : defaultExists ? 1 : disabledExists ? 0 : -1
}

getSteamVRFolder() {
	enabled := getSteamVREnabled()	
	return % (enabled = 1) ? steamVRPath : (enabled = 0) ? steamVRPath . "_Disabled" :
}

;Updates icon and tooltip; green for enabled, red for disabled, white for other
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
	
	;Icons injected into exe after compliation because AHK doesn't support packaging icons within exes
	;See readme for more info concerning this
	Menu, tray, Icon, %A_ScriptFullPath%, %icon%,1 
	Menu, tray, Tip, %tooltip%
}

;"Enable"/"Disable" SteamVR by renaming its installation directory so Steam can/can't find it
toggleSteamVREnabled(enabled) {
	steamVRFolder := getSteamVRFolder()
	if (steamVRFolder) {
		targetName := (enabled ? steamVRPath : steamVRPath . "_Disabled")
		FileMoveDir, %steamVRFolder%, %targetName%
	}
	updateIcon()
}

updateIcon() ;Update icon to current SteamVR status
#Persistent
	Menu, tray, NoStandard ;Remove default AHK tray menu options
	Menu, tray, add, Disable SteamVR, Disable ;Add button for disabling SteamVR with text "Disable SteamVR"
	Menu, tray, add, Enable SteamVR, Enable ;Add button for enabling SteamVR with text "Enable SteamVR"
	Menu, tray, add ;Add separator
	Menu, tray, add, Exit, ExitScript ;Add button for exiting program with text "Exit"
return

;On disable click in tray menu
Disable:
	toggleSteamVREnabled(false)
return

;On enable click in tray menu
Enable:
	toggleSteamVREnabled(true)
return

;On exit click in tray menu
ExitScript:
	ExitApp
return