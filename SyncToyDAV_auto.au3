#cs ----------------------------------------------------------------------------

 AutoIt Version: 0.1
 Author:         o.brizard a.k.a beemoon

 Script Function:
	Controle ou connecte une ressource webDAV
	Synchronisation SyncToy par tache planifiée

#ce ----------------------------------------------------------------------------
#include <Constants.au3>
#include <String.au3>

; controle l'acces à la ressource webDAV
Local $configFile = @AppDataDir&"\SyncToy 2.1\webDaV.dat"
Local $file = FileOpen($configFile, 0)
If $file = -1 Then
    MsgBox(0, "Error", "Unable to open file.")
    Exit
Else
	Dim $lineCrypted = FileReadLine($file)
EndIf
FileClose($file)

; Décodage des information de connexion au webDAV
Local $lineDecrypted = _StringEncrypt(0,$lineCrypted,"SyncToyDAV")

;Controle de la connexion au webDAV
Local $myString = StringSplit($lineDecrypted,"|")
if $myString[0] <> 3 Then
	MsgBox(0,"Erreur","Le Fichier "&$configFile&" est endommagé")
	Exit
Else
	Local $login = $myString[1]
	Local $password = $myString[2]
	Local $urlWebDAV = $myString[3]
EndIf
$line=""
Local $findNetUse = Run(@ComSpec & " /c net use|findstr /c:"""&$urlWebDAV&"""", @SystemDir, @SW_HIDE, $STDERR_MERGED)
While 1
	$line &= StdoutRead($findNetUse)
	If @error Then ExitLoop
WEnd

If ($line == "") Then
MsgBox(0, "Erreur","Pas ou plus de connexion webDAV, on reconnecte...")
	; net use $url_webDAV /user:login password
	If DriveMapAdd("",$urlWebDAV,0,$login,$password) <> 1 Then
		;MsgBox(0, "Erreur", "Impossible de se connecter au webDAV")
		exit
	EndIf
EndIf

; Execute la synchronisation SyncToy
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



