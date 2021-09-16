#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_Icon=internet.ico
#AutoIt3Wrapper_Res_Comment=Written By Jacob Stewart
#AutoIt3Wrapper_Res_Description=Logs internet ping to an output log file.
#AutoIt3Wrapper_Res_Fileversion=1.0.0.1
#AutoIt3Wrapper_Res_Fileversion_AutoIncrement=y
#AutoIt3Wrapper_Res_ProductName=Internet uptime logging
#AutoIt3Wrapper_Res_ProductVersion=1.0.0.0
#AutoIt3Wrapper_Res_CompanyName=Internet uptime logging
#AutoIt3Wrapper_Res_LegalCopyright=Internet uptime logging
#AutoIt3Wrapper_Res_LegalTradeMarks=Internet uptime logging
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****
Global $Version='1.0.0.0'
#cs - Version Log
1.0.0.0
logs internet ping to www.google.com and writes a log when log is clicked

#ce
#include <TrayConstants.au3> ; Required for the $TRAY_CHECKED and $TRAY_ICONSTATE_SHOW constants.
#include <File.au3>

Opt("TrayMenuMode", 3)

Global $File_Log=@ScriptDir&"\internet_log.log"
_FileWriteLog($File_Log,'--- New Log ---',1)

$TrayLog=TrayCreateItem("Log")
$TrayAbout=TrayCreateItem("About")
$TrayExit=TrayCreateItem("Exit")

Global $timer_runningTime=TimerInit()
Global $timer=TimerInit()

Global $pingSuccess=0
Global $pingFail=0
Global $pingCount=0

While 1
	Switch TrayGetMsg()
		Case $TrayExit
			Exit
		Case $TrayAbout
			MsgBox(0,"About","Program Version: "&$Version&@CRLF&"Program written by Jacob Stewart")
		Case $TrayLog
			_Log()
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

WEnd

Func _Log()
	$LogOut="Program has been running for: "&Round(TimerDiff($timer_runningTime)/1000/60,1)&"min ("&Round(TimerDiff($timer_runningTime)/1000/60/60,2)&" hours)"&@CRLF& _
	$pingCount&" Pings."&@CRLF&$pingSuccess&" | Successful Pings."&@CRLF&$pingFail&" | Failed Pings."&@CRLF&"Up percentage | "&$pingSuccess/$pingCount*100
	_FileWriteLog($File_Log,$LogOut,1)
	ShellExecute($File_Log)
EndFunc

