#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_Icon=internet.ico
#AutoIt3Wrapper_Res_Comment=Written By Jacob Stewart
#AutoIt3Wrapper_Res_Description=Logs internet ping to an output log file.
#AutoIt3Wrapper_Res_Fileversion=1.1.0.1
#AutoIt3Wrapper_Res_ProductName=Internet uptime logging
#AutoIt3Wrapper_Res_ProductVersion=1.1.0.1
#AutoIt3Wrapper_Res_CompanyName=Internet uptime logging
#AutoIt3Wrapper_Res_LegalCopyright=Internet uptime logging
#AutoIt3Wrapper_Res_LegalTradeMarks=Internet uptime logging
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****
Global $Version='1.1.0.1'
#cs - Version Log
1.1.0.0+ and above see GitHub
-
1.0.0.0
logs internet ping to www.google.com and writes a log when log is clicked

#ce --- START

;--- SETUP
#include <TrayConstants.au3> ; Required for the $TRAY_CHECKED and $TRAY_ICONSTATE_SHOW constants.
#include <File.au3>

;File Setup
Global $File_Log=@ScriptDir&"\internet_log.log"
_FileWriteLog($File_Log,'--- New Log ---',1)

;Tray setup
Opt("TrayMenuMode", 3)
$TrayLog=TrayCreateItem("Log")
$TrayAbout=TrayCreateItem("About")
$TrayExit=TrayCreateItem("Exit")

;timers
Global $timer_runningTime=TimerInit()
Global $timer_LogOut=TimerInit()
Global $timer=TimerInit()

;ping vars
Global $pingSuccess=0
Global $pingFail=0
Global $pingCount=0

;--- MAIN LOOP

While 1
	Switch TrayGetMsg()
		Case $TrayExit
			Exit
		Case $TrayAbout
			MsgBox(0,"About","Program Version: "&$Version&@CRLF&"Program written by Jacob Stewart")
		Case $TrayLog
			_Log(1)
	EndSwitch

	If TimerDiff($timer)>1000 Then
		$timer=TimerInit()
		$ping=ping("www.google.com",500)
		$pingCount+=1
		If $ping>0 Then
			$pingSuccess+=1
		Else
			$pingFail+=1
		EndIf
	EndIf

	If TimerDiff($timer_LogOut)>600000 Then
		$timer_LogOut=TimerInit()
		_Log(0)
	EndIf

WEnd

;--- FUNCTIONS

;Logging Funcion
Func _Log($_Log_msg)
	$LogOut="Program has been running for: "&Round(TimerDiff($timer_runningTime)/1000/60,1)&"min ("&Round(TimerDiff($timer_runningTime)/1000/60/60,2)&" hours)"&@CRLF& _
	$pingCount&" Pings."&@CRLF&$pingSuccess&" | Successful Pings."&@CRLF&$pingFail&" | Failed Pings."&@CRLF&"Up percentage | "&$pingSuccess/$pingCount*100
	_FileWriteLog($File_Log,$LogOut,1)
	If $_Log_msg=1 Then	ShellExecute($File_Log)
EndFunc

