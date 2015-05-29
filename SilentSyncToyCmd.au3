#cs ----------------------------------------------------------------------------

	AutoIt Version: 1.0
	Author:         olivier BRIZARD (contact@beemoon.fr)

	Script Function:
		Hide SyncToyCmd.exe

#ce ----------------------------------------------------------------------------

If (@OSArch = "X64" And @OSType = "WIN32_NT") Then
	Local $setupFile = "C:\Program Files\SyncToy 2.1\SyncToyCmd.exe"

ElseIf (@OSArch = "X86" And @OSType = "WIN32_NT") Then
	Local $setupFile = "C:\Program Files (x86)\SyncToy 2.1\SyncToyCmd.exe"
EndIf

if $CmdLine[0] = 0 Then
	ShellExecuteWait($setupFile,"-R","","",@SW_HIDE)
	exit
EndIf

if ($CmdLine[0] = 1 AND $CmdLine[1] = "-R") Then
	ShellExecuteWait($setupFile,"-R","","",@SW_HIDE)
	exit
EndIf

if ($CmdLine[0] = 2) Then
	if ($CmdLine[1] = "-R") Then
		Local $pairName = $CmdLine[2]
		ShellExecuteWait($setupFile,"-R "&$pairName&"","","",@SW_HIDE)
		exit
	Else
		MsgBox (64,"Information","Usage: "&@LF&@LF&"    SilentSyncToyCmd.exe -R <pairName>")
		exit
	EndIf

Else
	MsgBox (64,"Information","Usage: "&@LF&@LF&"    SilentSyncToyCmd.exe -R <pairName>")
	exit
EndIf


