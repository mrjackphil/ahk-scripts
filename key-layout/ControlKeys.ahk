; Originally developed by Pavel Chikulaev
; Modified by Degtyar Eugene aka MrJackphil
; Distributed under BSD license

SetTitleMatchMode,RegEx

if not A_IsAdmin
{
   DllCall("shell32\ShellExecuteA", uint, 0, str, "RunAs", str, A_AhkPath
      , str, """" . A_ScriptFullPath . """", str, A_WorkingDir, int, 1)
   ExitApp
}

#InstallKeybdHook

Loop
{
   Input, SingleKey, L1 V
   {
	  SetFormat, Integer, H
	  lang := DllCall("GetKeyboardLayout", Int,DllCall("GetWindowThreadProcessId", int,WinActive("A"), Int,0))
	  SetFormat, Integer, D

	  if (lang = "0x4090409") {
	      SoundPlay, %A_ScriptDir%\typeeng.wav
	  } else {
	      SoundPlay, %A_ScriptDir%\typerus.wav
	  }
   }
}

press_count := 0
global width_toggled := 0
global mouse_mode := 0

MyAppsKeyHotkeys(enable) {
   if (enable = "Off")
   {
      mouse_mode := 0
      Menu, TRAY, Icon, %A_ScriptDir%\Letter-E.ico
      Gui, Name: New
      Gui, Destroy
   }
   else
   {
	  moveHelp(true)
   }
    ;Hotkey, IfWinNotActive, ahk_exe (sublime_text.exe)
    ;HotKey,  a, MyEmpty, %enable%
     HotKey,  b, MyEnter, %enable%
    ;HotKey,  c, MyEmpty, %enable%
    ;HotKey,  d, MyEmpty, %enable%
    ;HotKey,  e, MyEmpty, %enable%
    ;HotKey,  f, FirefoxActive, %enable%
    ;HotKey,  g, MyEmpty, %enable%
     HotKey, *h, MyLeft,  %enable%
    ;HotKey, *q, MyMouseOff, %enable%
     HotKey, *j, MyDown,  %enable%
     HotKey, *k, MyUp,    %enable%
     HotKey, *l, MyRight, %enable%
     Hotkey, *m, MyToggleMouse,  %enable%
     HotKey, *n, MyPgDn,  %enable%
    ;HotKey, *o, MyEnd,   %enable%
     HotKey, *p, MyBS,    %enable%
    ;HotKey,  q, MyEmpty, %enable%
     HotKey,  r, MyApps, %enable%
    ;HotKey,  s, MyEmpty, %enable%
    ;HotKey,  t, MyEmpty, %enable%
     HotKey, *i, myPgUp, %enable%
     HotKey, *u, MyPgDn, %enable%
    ;HotKey,  v, MyEmpty, %enable%
    ;HotKey,  w, MyEmpty, %enable%
     HotKey,  x, MyDel,   %enable%
     Hotkey, *y, MyEsc,   %enable%
    ;HotKey,  z, MyEmpty, %enable%
    ;HotKey, *;, MyEnter, %enable%
     HotKey, *[, MyDel,   %enable%
     HotKey, *?, MyApps,   %enable%
     Hotkey, Space, MyMouseClick, %enable%
     Hotkey, Space Up, MyMouseClickUp, %enable%
     Hotkey, +Space, MyMouseRClick, %enable%
    ;HotKey,  ], MyEmpty, %enable%
    ;HotKey,  ', MyEmpty, %enable%
     HotKey,  ., MySoundToggle, %enable%
     HotKey,  /, HelpMove, %enable%
     HotKey, *^, MyHome,  %enable%
     HotKey, *$, MyEnd,   %enable%
     HotKey,  e, Block,   %enable%
}
moveHelp(isLeft) {
  width := A_ScreenWidth-150
  Menu, TRAY, Icon, %A_ScriptDir%\Letter-C.ico
  Gui, Name: New
  Gui, Add, Text,, H - Left
  Gui, Add, Text,, L - Right
  Gui, Add, Text,, K - Up
  Gui, Add, Text,, J - Down
  Gui, Add, Text,, R - Apps
  Gui, Add, Text,, B - PgUp
  Gui, Add, Text,, N - PgDn
  Gui, Add, Text,, M - Mouse
  Gui, Add, Text,, P - Bs
  Gui, Add, Text,, U - Enter
  Gui, Add, Text,, X - Del
  Gui, Add, Text,, Y - Esc
  Gui, Add, Text,, . - TglSnd
  Gui, Add, Text,, ^ - Home
  Gui, Add, Text,, $ - End
  Gui, Add, Text,, E - Block
  ; Make a white background
  Gui, Color, FFFFFFAA
  Gui +LastFound

  Gui, -Caption -Border -Resize -MaximizeBox +AlwaysOnTop +Disabled +ToolWindow
  if (isLeft) {
    Gui, Show, x%width% y0 NoActivate
  } else {
    Gui, Show, x0 y0 NoActivate
  }
  return
}
updateTooltip(mode) {
  if (mode) {
    ToolTip, "Mouse Mode"
    SetTimer, updateTooltip, 0 
  } else {
    ToolTip
  }
}
mouseSpeed() {
  shiftPressed := GetKeyState("Shift", "P")
  ctrlPressed  := GetKeyState("Ctrl", "P")

  if (shiftPressed) {
    return 100 
  }
  if (ctrlPressed) {
    return 1
  }

  return 10
}

updateTooltip: 
  updateTooltip(mouse_mode)
  return
HelpMove:
  press_count += 1
  if (width_toggled = 0) 
  {
    Gui, Name: New
    Gui, Show, x0 y0 NoActivate
    moveHelp(true)
    width_toggled := 1
  } 
  else 
  {
    width := A_ScreenWidth-150
    width_toggled := 0
    Gui, Name: New
    moveHelp(false)
  }

  return
FirefoxActive:
   press_count += 1
   DetectHiddenWindows, On
   WinActivate, Mozilla Firefox
   Return
MyMouseClick:
  if (mouse_mode) {
    SendEvent {Click down}
  } else {
    SendEvent {Space} 
  }
  Return
MyMouseClickUp:
  if (mouse_mode) {
    SendEvent {Click up}
  }
  Return
MyMouseRClick:
   SendEvent {Click right}
   Return
Block:
  press_count += 1
  CoordMode, Mouse
  SendEvent, {Click 1322, 945}
  SendEvent, {Click 1678, 887}
  Return
MyToggleMouse:
  if (mouse_mode) {
    mouse_mode = 0
  } else {
    mouse_mode = 1
    updateTooltip(mouse_mode)
  }
  Return
MySoundToggle:
   press_count += 1           
   SoundSet, +1, , mute
   Return
MyEmpty:
 ;  Return
MyUp:
   press_count += 1
   if (mouse_mode) {
     Move( 0, -1 )
   } else {
     Send {Blind}{Up} ;fix for OneNote use SendPlay
   }
   Return
MyDown:
   press_count += 1
   if (mouse_mode) {
     Move( 0, 1 )
   } else {
     Send {Blind}{Down} ;fix for OneNote use SendPlay
   }
   Return
MyLeft:
   press_count += 1
   if (mouse_mode) {
     Move( -1, 0 )
   } else {
     Send {Blind}{Left}
   }
   Return
MyRight:
   press_count += 1
   if (mouse_mode) {
     Move( 1, 0 )
   } else {
     Send {Blind}{Right}
   }
   Return
MyPgUp:
   press_count += 1
   if (mouse_mode) {
     Send {WheelUp}
   } else {
     Send {Blind}{PgUp}
   }
   Return
MyPgDn:
   press_count += 1

   if (mouse_mode) {
     Send {WheelDown}
   } else {
     Send {Blind}{PgDn}
   }
   Return
MyEnter:
   press_count += 1
   Send {Blind}{Enter}
   Return
MyBS:
   press_count += 1
   Send {Blind}{BS}
   Return
MyDel:
   press_count += 1
   Send {Blind}{Del}
   Return
MyHome:
   press_count += 1
   Send {Blind}{Home}
   Return
MyEnd:
   press_count += 1
   Send {Blind}{End}
   Return
MyApps:
   press_count += 1
   Send {Blind}{AppsKey}
   Return
MyEsc:
   press_count += 1
   Send {Esc}
   Return

SetCapsLockState, AlwaysOff
SetScrollLockState, AlwaysOff

#IfWinNotActive ahk_class TscShellContainerClass
CapsLock::HotkeyHook("Down")
CapsLock Up::HotkeyHook("Up")
ScrollLock::HotkeyHook("Down")
ScrollLock Up::HotkeyHook("Up")
#IfWinNotActive

HotkeyHook(Mode)
{
   static sticky_hotkeys = 0
   global press_count
   if (Mode = "Down")
   {
      if (sticky_hotkeys = 1)
      {
         sticky_hotkeys = 2
      }
      else
      {
         MyAppsKeyHotkeys("On")
         press_count = 0
      }
   }
   else if (Mode = "Up")
   {
      if (sticky_hotkeys = 0)
      {
         if (press_count = 0)
         {
            sticky_hotkeys = 1
         }
         else
         {
            MyAppsKeyHotkeys("Off")
         }
      }
      else if (sticky_hotkeys = 2)
      {
         MyAppsKeyHotkeys("Off")
         sticky_hotkeys = 0
      }
   }
}

Move( x, y ) {
	global accelerate, repeat
	++repeat
	factor := accelerate ? Floor( ( repeat + 1 ) / 2 ) : 1
	x := x * factor * mouseSpeed()
	y := y * factor * mouseSpeed()
	MouseMove, x, y, 0, R
}
