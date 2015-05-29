#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_Version=beta
#AutoIt3Wrapper_Icon=icone.ico
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****
#cs ----------------------------------------------------------------------------

	AutoIt Version: 1.0 BETA
	Author:         olivier BRIZARD

	Script Function:
		Préconfigure SyncToy pour faire de la synchronisation avec une
		ressource webDAV

#ce ----------------------------------------------------------------------------
#include <String.au3>
#include <GUIConstants.au3>
#include <IE.au3>

; Intègre SyncToy dans le paquet lors du build le build
Local $b = True
If $b = True Then
	FileInstall(".\wait.gif", @TempDir&"\wait.gif",1)
	FileInstall(".\cloudDav.jpg", @TempDir&"\cloudDav.jpg",1)
	FileInstall(".\logo.jpg", @TempDir&"\logo.jpg",1)

	DirCreate(@TempDir&"\x64")
	FileInstall(".\extra\ProviderServices-v2.0-x64-ENU.msi", @TempDir&"\ProviderServices-v2.0-x64-ENU.msi",1)
	FileInstall(".\extra\Synchronization-v2.0-x64-ENU.msi", @TempDir&"\Synchronization-v2.0-x64-ENU.msi",1)
	if FileInstall(".\extra\SyncToySetup-x64.msi", @TempDir&"\x64\SyncToySetup.msi",1) = 0 Then
		MsgBox(0,"Message","Erreur d'extraction des MSI")
		exit
	EndIf

	FileInstall(".\extra\ProviderServices-v2.0-x86-ENU.msi", @TempDir&"\ProviderServices-v2.0-x86-ENU.msi",1)
	FileInstall(".\extra\Synchronization-v2.0-x86-ENU.msi", @TempDir&"\Synchronization-v2.0-x86-ENU.msi",1)
	if FileInstall(".\extra\SyncToySetup-x86.msi", @TempDir&"\SyncToySetup.msi",1) = 0 Then
		MsgBox(0,"Message","Erreur d'extraction des MSI")
		exit
	EndIf
EndIf

; Interface graphique
#include <ButtonConstants.au3>
#include <EditConstants.au3>
#include <GUIConstantsEx.au3>
#include <StaticConstants.au3>
#include <WindowsConstants.au3>

$Form1_1 = GUICreate("Installation de SyncToyDAV", 744, 505, 267, 484)
GUISetBkColor(0xCAE4FB)
$select_RepLocal = GUICtrlCreateButton("Browser...", 371, 150, 61, 21)
$input_webDAV = GUICtrlCreateInput("", 411, 264, 305, 21)
GUICtrlSetColor(-1, 0x0066CC)
$input_Login = GUICtrlCreateInput("", 555, 300, 161, 21)
GUICtrlSetColor(-1, 0x0066CC)
$input_Passwd = GUICtrlCreateInput("", 555, 332, 161, 21, BitOR($GUI_SS_DEFAULT_INPUT,$ES_PASSWORD))
GUICtrlSetColor(-1, 0x0066CC)
$button_setup = GUICtrlCreateButton("Installer", 656, 456, 73, 25)
$button_cancel = GUICtrlCreateButton("Annuler", 576, 456, 73, 25)
$Graphic1 = GUICtrlCreateGraphic(0, 0, 742, 59)
GUICtrlSetGraphic(-1, $GUI_GR_PENSIZE, 0)
GUICtrlSetGraphic(-1, $GUI_GR_COLOR, 0x7fa0cb, 0x7fa0cb)
GUICtrlSetGraphic(-1, $GUI_GR_RECT, 0, 0, 745, 54)
$Pic0 = GUICtrlCreatePic(@TempDir&"\logo.jpg", 450, 0, 294, 53)

$input_RepLocal = GUICtrlCreateInput("", 435, 150, 273, 21)
GUICtrlSetColor(-1, 0x0066CC)
$label_RepLocal = GUICtrlCreateLabel("   Répertoire local (Left Folder)", 339, 118, 179, 17)
GUICtrlSetFont(-1, 8, 800, 0, "MS Sans Serif")
GUICtrlSetColor(-1, 0x003C77)
GUICtrlSetBkColor(-1, 0xFFFFFF)
$label_WebDAV = GUICtrlCreateLabel("   Information webDAV (Right Folder)", 339, 238, 212, 17)
GUICtrlSetFont(-1, 8, 800, 0, "MS Sans Serif")
GUICtrlSetColor(-1, 0x003C77)
GUICtrlSetBkColor(-1, 0xFFFFFF)
$label_Passwd = GUICtrlCreateLabel("Mot de passe : ", 475, 334, 77, 17, $SS_RIGHT)
GUICtrlSetFont(-1, 9, 400, 0, "MS Sans Serif")
GUICtrlSetColor(-1, 0x6082B0)
GUICtrlSetBkColor(-1, 0xFFFFFF)
$label_Login = GUICtrlCreateLabel("Identifiant : ", 491, 302, 59, 17, $SS_RIGHT)
GUICtrlSetFont(-1, 9, 400, 0, "MS Sans Serif")
GUICtrlSetColor(-1, 0x6082B0)
GUICtrlSetBkColor(-1, 0xFFFFFF)
$Label1 = GUICtrlCreateLabel("URL :", 374, 264, 32, 17, $SS_RIGHT)
GUICtrlSetFont(-1, 9, 400, 0, "MS Sans Serif")
GUICtrlSetColor(-1, 0x6082B0)
GUICtrlSetBkColor(-1, 0xFFFFFF)
$Graphic2 = GUICtrlCreateGraphic(338, 54, 404, 384)
GUICtrlSetGraphic(-1, $GUI_GR_COLOR, 0xFFFFFF, 0xFFFFFF)
GUICtrlSetGraphic(-1, $GUI_GR_RECT, 0, 0, 407, 386)

$Pic1 = GUICtrlCreatePic(@TempDir&"\cloudDav.jpg", 8, 224, 324, 183)
$Label2 = GUICtrlCreateLabel("SynToyDav est un assistant d'installation et de"&@LF&@LF&"configuration pour SyncToy v2.1 afin de"&@LF&@LF&"synchroniser un répertoire local et une ressource"&@LF&@LF&"webDAV.", 16, 96, 306, 90)
GUICtrlSetFont(-1, 8, 800, 0, "MS Sans Serif")
GUICtrlSetColor(-1, 0x003C77)
$Label3 = GUICtrlCreateLabel("www.beemoon.fr", 344, 448, 98, 17)
GUICtrlSetFont(-1, 8, 800, 0, "MS Sans Serif")
GUICtrlSetColor(-1, 0x003C77)
GUISetState(@SW_SHOW)



; Traitement des données
Dim $result
While 1
	$nMsg = GUIGetMsg()
	Switch $nMsg
		Case $GUI_EVENT_CLOSE
			Exit

		Case $button_cancel
			Exit

		Case $select_RepLocal
			Local $val_RepLocal = FileSelectFolder("Sélectionner le répertoire local à synchroniser.", "")
			GUICtrlSetData($input_RepLocal, $val_RepLocal)

		Case $button_setup
				If GUICtrlRead($input_RepLocal) = "" Then
					MsgBox(0,"Message","Vous devez remplir tous les champs")

				ElseIf GUICtrlRead($input_WebDAV) = "" Then
						MsgBox(0,"Message","Vous devez remplir tous les champs")

				Else
						$nOffset = 1
						$result = StringRegExp(GUICtrlRead($input_WebDAV), '(.*?)://.*',1,$nOffset)
						If (@error <> 0) Then
							MsgBox(0, "Information", "L'URL doit commencer par http:// ou https://")
						Else
							$nOffset = @extended
							If  GUICtrlRead($input_Login) = "" Then
								MsgBox(0,"Message","Vous devez remplir tous les champs")

							ElseIf GUICtrlRead($input_Passwd) = "" Then
								MsgBox(0,"Message","Vous devez remplir tous les champs")

							EndIf

							; Lecture des informations saisie par l'utilisateur
							Dim $login = GUICtrlRead($input_Login)
							Dim $passwd = GUICtrlRead($input_Passwd)
							Dim $webDAV_url = GUICtrlRead($input_WebDAV)
							Dim $localDir = GUICtrlRead($input_RepLocal)

							; Réécriture de l'URL webDaV saisie par l'utilisateur pour une utilisation par SyncToy
							; et la commande net use
							Dim $webDAV_url_Replace = StringReplace($webDAV_url,'/','\')
							Dim $path_NetUse_tmp = StringRegExp($webDAV_url_Replace, '.*(\\\\.*)',1,1)
							Dim $path_NetUse
							Switch StringLower($result[0])
								Case "http"
									$path_NetUse = $path_NetUse_tmp[0]
								Case "https"
									Local $path_NetUse_SSL = StringRegExpReplace($path_NetUse_tmp[0], '(\\\\)([a-z.\-]*\.[a-z]{2,3})(\\.*)', '$1$2@SSL$3')
									$path_NetUse = $path_NetUse_SSL
							EndSwitch

							; Tentative de connexion à la ressource webDAV
							If DriveMapAdd("",$path_NetUse,0,$login,$passwd) = 1 Then
								ExitLoop
							Else
								MsgBox(0,"Message erreur","Vérifiez les informations de connexion au webDAV")
							EndIf


						EndIf

				EndIf
	EndSwitch


WEnd
GUIDelete()

; On encode le login / password avant le stockage dans un fichier
Local $loginPassPath = $login&"|"&$passwd&"|"&$path_NetUse
Local $encodeAccess= _StringEncrypt(1,$loginPassPath,"SyncToyDAV")

; Stockage du login:password
Local $repertoire = @AppDataDir&"\SyncToy 2.1\"
DirCreate($repertoire)
Local $file =$repertoire&"\webDaV.dat"
FileOpen($file, 2)
If FileWrite($file,$encodeAccess) <> 1 Then
	MsgBox(0,"Message","Impossible d''écrire dans "&$file)
EndIf
FileClose($file)

; On lance l'installation de SyncToy
_IEErrorHandlerRegister ()
$oIE = _IECreateEmbedded ()
GUICreate("Installation...", 220,220,-1, -1)
$GUIActiveX = GUICtrlCreateObj($oIE, 0, 0, 250, 250)
GUISetState()       ;Show GUI
_IENavigate ($oIE, @TempDir&"\wait.gif")


If (@OSArch = "X64" And @OSType = "WIN32_NT") Then
	$msg = GUIGetMsg()
	; en premier (RunAsWait)
	ShellExecuteWait(@TempDir&"\Synchronization-v2.0-x64-ENU.msi","/qn")
	; en deuxieme (RunAsWait)
	ShellExecuteWait(@TempDir&"\ProviderServices-v2.0-x64-ENU.msi","/qn")
	;en troisieme (RunAsWait)
	ShellExecuteWait(@TempDir&"\x64\SyncToySetup.msi","/qn")

	; On fixe l'executable de SyncToy
	Local $SyncToyRep = "C:\Program Files\SyncToy 2.1"

ElseIf (@OSArch = "X86" And @OSType = "WIN32_NT") Then
	$msg = GUIGetMsg()
	; en premier (RunAsWait)
	ShellExecuteWait(@TempDir&"\Synchronization-v2.0-x86-ENU.msi","/qn")
	; en deuxieme (RunAsWait)
	ShellExecuteWait(@TempDir&"\ProviderServices-v2.0-x86-ENU.msi","/qn")
	;en troisieme (RunAsWait)
	ShellExecuteWait(@TempDir&"\SyncToySetup-x86.msi","/qn")

	; On fixe l'executable de SyncToy
	Local $SyncToyRep = "C:\Program Files (x86)\SyncToy 2.1\SyncToy 2.1"

Else
	MsgBox(0,"Message","Votre système n'est pas compatible.")
	Exit
EndIf
Local $SyncToy = $SyncToyRep&"\SyncToy.exe"
sleep(3000)
GUIDelete()

; On lance SyncToy pour le paramétrage (c'est le but de ce programme !!!)
FileInstall(".\SilentSyncToyCmd.exe", $SyncToy&"\SilentSyncToyCmd.exe",1)

Local $pairName = "synchroWebDAV"
ShellExecuteWait($SyncToy,"-d(left="&$localDir&",right="&$path_NetUse&",name="&$pairName&",operation=Synchronize,check=yes,exclude=*.log)")

; On lance une tache pour une synchronisation automatique (en attendant de trouve une solution avec
; FileSystemWatcher (http://msdn.microsoft.com/en-us/library/system.io.filesystemwatcher.aspx)
ShellExecuteWait("schtasks","/create /sc minute /mo 60 /tn ""webDAVSync"" /tr ""'"&$SyncToy&"\SilentSyncToyCmd.exe' -R "&$pairName&"","","",@SW_HIDE)

;nettoyage
if FileExists(@TempDir&"\ProviderServices-v2.0-x64-ENU.msi") Then FileDelete(@TempDir&"\ProviderServices-v2.0-x64-ENU.msi")
if FileExists(@TempDir&"\Synchronization-v2.0-x64-ENU.msi") Then FileDelete(@TempDir&"\Synchronization-v2.0-x64-ENU.msi")
if FileExists(@TempDir&"\x64\SyncToySetup.msi") Then FileDelete(@TempDir&"\x64\SyncToySetup.msi")

if FileExists(@TempDir&"\ProviderServices-v2.0-x86-ENU.msi") Then FileDelete(@TempDir&"\ProviderServices-v2.0-x86-ENU.msi")
if FileExists(@TempDir&"\Synchronization-v2.0-x86-ENU.msi") Then FileDelete(@TempDir&"\Synchronization-v2.0-x86-ENU.msi")
if FileExists(@TempDir&"\SyncToySetup.msi") Then FileDelete(@TempDir&"\SyncToySetup.msi")


MsgBox(0,"Message","Installation terminée")

;https://espaces-collaboratifs-webdav.grenet.fr/alfresco/webdav/Sites/persoINPG/documentLibrary

