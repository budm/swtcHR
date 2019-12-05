;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;                                   SwtcHR                                        ;;
;;           a switcher to run certain programs at certain hours                   ;;
;;                                                                                 ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

#include <Timers.au3>
#include <Date.au3>
#include <Process.au3>
#Include <WinAPI.au3>
#include <Array.au3>

;;;;;;;;;;;;;;;;;;;;;
;; SwtcHR Config    ;
;;;;;;;;;;;;;;;;;;;;;

$instance = "SwtcHR" ;The name of the program
$defaultstart = 16; Start time 5PM (5PM:  12+5=17)
$defaultToTime = 6; End time 6AM
$dayInst = "xmrig.exe"  ;Name of program for between 6AM and 5PM
$NightInst = "xmrig.exe"  ;Name of program for between 5PM and 6AM

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;     SwtcHR Internals        ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

$task1done = 0
$fromtime = $defaultstart
$totime = $defaultToTime
$INST_STARTED = False

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;     SwtcHR  Night Function          ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

While 1
    If $fromtime > $totime Then
     $totime = 24 + $totime
    EndIf

    If  (@HOUR >= $fromtime) AND (@HOUR < $totime) AND ($task1done = 0) Then
     If MsgBox(4,'SwtcHR is scheduled to ( start at' & $fromtime & ')',' Can I switch? ',$defaultstart) = 7 Then;No pressed
      If MsgBox(4,'Postpone SwtcHR?','Try agin in 1 hour?') = 7 Then
       $task1done = 1
		 Else
			$fromtime = Mod(@HOUR + 1,24)
			If $fromtime = 0 then
		 $fromtime = 24
			EndIf
			If $fromtime = $totime Then
		 $totime = Mod($totime + 1,24)
			EndIf
		 EndIf
      EndIf
     Else
      ;$val = RunWait($NightInst);
	  $val = ShellExecute( @ScriptDir & "\" & $NightInst, "" , "" , "" )
	  $task1done = 1
      $fromtime = $defaultstart
      $totime = $defaultToTime
   EndIf



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;       SwtcHR  Day Function          ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

   If $task1done = 1 Then
    If @HOUR < $defaultstart AND @HOUR >= $defaultToTime Then
     $task1done = 0
     $fromtime = $defaultstart
     $totime = $defaultToTime
	 ProcessClose($val)
    EndIf
   EndIf

    Sleep(100000);100 sec

WEnd
