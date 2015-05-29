#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_Version=Beta
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****
#cs ----------------------------------------------------------------------------

	AutoIt Version: 1.0 BETA
	Author:         olivier BRIZARD

	Script Function:
		Préconfigure SyncToy pour faire de la synchronisation avec une
		ressource webDAV

#ce ----------------------------------------------------------------------------

; Intègre SyncToy dans le paquet lors du build le build
Local $b = True
If $b = True Then
	FileInstall(".\wait.gif", @TempDir&"\wait.gif",1)

	DirCreate(@TempDir&"\x64")
	FileInstall(".\ProviderServices-v2.0-x64-ENU.msi", @TempDir&"\ProviderServices-v2.0-x64-ENU.msi",1)
	FileInstall(".\Synchronization-v2.0-x64-ENU.msi", @TempDir&"\Synchronization-v2.0-x64-ENU.msi",1)
	if FileInstall(".\SyncToySetup-x64.msi", @TempDir&"\x64\SyncToySetup.msi",1) = 0 Then
		MsgBox(0,"Message","Erreur d'extraction des MSI")
		exit
	EndIf

	FileInstall(".\ProviderServices-v2.0-x86-ENU.msi", @TempDir&"\ProviderServices-v2.0-x86-ENU.msi",1)
	FileInstall(".\Synchronization-v2.0-x86-ENU.msi", @TempDir&"\Synchronization-v2.0-x86-ENU.msi",1)
	if FileInstall(".\SyncToySetup-x86.msi", @TempDir&"\SyncToySetup.msi",1) = 0 Then
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
#include <GUIConstants.au3>
#include <IE.au3>

$Form1_1 = GUICreate("Installation de DavBox", 656, 354, 432, 197)
GUISetBkColor(0xA6CAF0)
$Group1 = GUICtrlCreateGroup("Paramètres", 296, 16, 345, 305)
GUICtrlSetFont(-1, 12, 800, 0, "MS Sans Serif")
GUICtrlSetColor(-1, 0x0066CC)
$label_RepLocal = GUICtrlCreateLabel("   Répertoire local (Left Folder)", 298, 72, 212, 17)
GUICtrlSetFont(-1, 8, 800, 0, "MS Sans Serif")
GUICtrlSetBkColor(-1, 0x3399FF)
$select_RepLocal = GUICtrlCreateButton("...", 336, 104, 21, 21)
$input_RepLocal = GUICtrlCreateInput("", 360, 104, 265, 21)
GUICtrlSetState(-1, $GUI_DISABLE)
$label_WebDAV = GUICtrlCreateLabel("   Information webDAV (Right Folder)", 298, 160, 212, 17)
GUICtrlSetFont(-1, 8, 800, 0, "MS Sans Serif")
GUICtrlSetBkColor(-1, 0x3399FF)
$input_WebDAV = GUICtrlCreateInput("", 336, 192, 289, 21)
$label_Passwd = GUICtrlCreateLabel("Mot de passe : ", 384, 258, 77, 17, $SS_RIGHT)
$label_Login = GUICtrlCreateLabel("Identifiant : ", 402, 226, 59, 17, $SS_RIGHT)
$input_Login = GUICtrlCreateInput("", 464, 224, 161, 21)
$input_Passwd = GUICtrlCreateInput("", 464, 256, 161, 21, BitOR($GUI_SS_DEFAULT_INPUT, $ES_PASSWORD))
GUICtrlCreateGroup("", -99, -99, 1, 1)
$button_setup = GUICtrlCreateButton("Installer", 424, 304, 97, 33)
GUISetState(@SW_SHOW)


; Traitement des données
Dim $result
While 1
	$nMsg = GUIGetMsg()
	Switch $nMsg
		Case $GUI_EVENT_CLOSE
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

; On encode le login / password en base64 avant le stockage dans un fichier
Local $loginPass = $login&":"&$passwd
Local $encodeAccess= $loginPass

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
ShellExecuteWait("schtasks","/create /sc minute /mo 5 /tn ""webDAVSync"" /tr ""'"&$SyncToy&"\SilentSyncToyCmd.exe' -R "&$pairName&"","","",@SW_HIDE)

;nettoyage
if FileExists(@TempDir&"\ProviderServices-v2.0-x64-ENU.msi") Then FileDelete(@TempDir&"\ProviderServices-v2.0-x64-ENU.msi")
if FileExists(@TempDir&"\Synchronization-v2.0-x64-ENU.msi") Then FileDelete(@TempDir&"\Synchronization-v2.0-x64-ENU.msi")
if FileExists(@TempDir&"\x64\SyncToySetup.msi") Then FileDelete(@TempDir&"\x64\SyncToySetup.msi")

if FileExists(@TempDir&"\ProviderServices-v2.0-x86-ENU.msi") Then FileDelete(@TempDir&"\ProviderServices-v2.0-x86-ENU.msi")
if FileExists(@TempDir&"\Synchronization-v2.0-x86-ENU.msi") Then FileDelete(@TempDir&"\Synchronization-v2.0-x86-ENU.msi")
if FileExists(@TempDir&"\SyncToySetup.msi") Then FileDelete(@TempDir&"\SyncToySetup.msi")


MsgBox(0,"Message","Installation terminée")

;https://espaces-collaboratifs-webdav.grenet.fr/alfresco/webdav/Sites/persoINPG/documentLibrary

