#Requires AutoHotkey v2.0
if not (A_IsAdmin)
{
    Run '*RunAs "' A_AhkPath '" /restart "' A_ScriptFullPath '"'
    ExitApp
}
#SingleInstance Force
#Include AutomationModV1\Libs\ImagePut.ahk
#Include AutomationModV1\Libs\adb.ahk
#Include AutomationModV1\Libs\OCR.ahk
#Include AutomationModV1\Libs\FuzzyMatch.ahk
Similarity := Fuzzy()
global Wintitle := "Main"
global Wintitle2 := 0
global Stopped := 1
global Downloadlink := IniRead("Settings.ini", "sim_g_Mod", "Link", "Past your link in there")
global mode := IniRead("Settings.ini", "sim_g_Mod", "mode", "Once")
global B4Clear := IniRead("Settings.ini", "sim_g_Mod", "B4Clear", "10")
global Path := "AutomationModV1\GPAccList.txt"
global Path2 := "AutomationModV1\CustomGPAccList.txt"
global Path3 := "AutomationModV1\content.html"
global Link := IniRead("Settings.ini", "sim_g_Mod", "Link", "")
global webhook := IniRead("Settings.ini", "sim_g_Mod", "Webhook", "")
global discordid := IniRead("Settings.ini", "UserSettings", "discordUserId", "")
FindMain()

;-------------------------------------GUI-------------------------------------;

;--------------------MainGUI Initialization--------------------;

MainGUI := Gui()
TraySetIcon("AutomationModV1\Assets\SillyCatExplosion.ico")
MainGUI.BackColor := "0x201A1E"
MainGUI.SetFont("s13 cc2255c ", "Comic Sans MS")
MainGUI.Title := "FunnyGUI"
MainGUI.opt("-SysMenu -Caption")
MainGUI.OnEvent("Close", (*) => ExitApp())  

MainGUI.Add("Picture", "x0 y0 w518.5 h368", "AutomationModV1\Assets\Frame1.png")
MainGUI.Add("Picture", "x0 y0 w518.5 h55", "AutomationModV1\Assets\Title1.png")
Close := MainGUI.Add("Picture", "x468 y7 w44.5 h41.5", "AutomationModV1\Assets\Close.png")
Minimize := MainGUI.Add("Picture", "x420 y7 w44.5 h41.5", "AutomationModV1\Assets\Minimize.png")
Arturo := MainGUI.Add("Picture", "x-30 y25 w352 h376 BackgroundTrans", "AutomationModV1\Assets\ArturoUwU.png")
Stop := MainGUI.Add("Picture", "x-30 y25 w352 h376 BackgroundTrans", "AutomationModV1\Assets\Stop.png")
ClearFriendListMode := MainGUI.Add("Picture", "x289 y62 w219 h40", "AutomationModV1\Assets\ClearFriendListMode.png")
AutomationLink := MainGUI.Add("Picture", "x322 y110 w186 h40", "AutomationModV1\Assets\AutomationLink.png")
CustomList := MainGUI.Add("Picture", "x317 y158 w191 h40", "AutomationModV1\Assets\CustomGPAccList.png")
MyGithub := MainGUI.Add("Picture", "x273 y207 w236.5 h33", "AutomationModV1\Assets\MyGithub.png")
MainGUI.Add("Picture", "x388 y242 w123.5 h22 BackgroundTrans", "AutomationModV1\Assets\Autosoon.png")
Finance := MainGUI.Add("Picture", "x372 y266 BackgroundTrans", "AutomationModV1\Assets\Finance.png")
FrenchDiscord := MainGUI.Add("Picture", "x361 y298 w147 h59", "AutomationModV1\Assets\FrenchDiscord.png")
Running1 := MainGUI.Add("Picture", "x320 y20 w74.5 h31.5 BackgroundTrans", "AutomationModV1\Assets\Running1.png")
Running2 := MainGUI.Add("Picture", "x320 y20 w79.5 h31.5 BackgroundTrans", "AutomationModV1\Assets\Running2.png")
Running3 := MainGUI.Add("Picture", "x320 y20 w84.5 h31.5 BackgroundTrans", "AutomationModV1\Assets\Running3.png")
Running4 := MainGUI.Add("Picture", "x320 y20 w89.5 h31.5 BackgroundTrans", "AutomationModV1\Assets\Running4.png")
AddImageToGui(MainGUI, "AutomationModV1\Assets\pikachu.gif", "x188 y245 BackgroundTrans")

Close_O := MainGUI.Add("Picture", "x468 y7 w44.5 h41.5", "AutomationModV1\Assets\Close_O.png")
Minimize_O := MainGUI.Add("Picture", "x420 y7 w44.5 h41.5", "AutomationModV1\Assets\Minimize_O.png")
ClearFriendListMode_O := MainGUI.Add("Picture", "x289 y62 w219 h40", "AutomationModV1\Assets\ClearFriendListMode_O.png")
AutomationLink_O := MainGUI.Add("Picture", "x322 y110 w186 h40", "AutomationModV1\Assets\AutomationLink_O.png")
CustomList_O := MainGUI.Add("Picture", "x317 y158 w191 h40", "AutomationModV1\Assets\CustomGPAccList_O.png")
MyGithub_O := MainGUI.Add("Picture", "x273 y207 w236.5 h33", "AutomationModV1\Assets\MyGithub_O.png")
Finance_O := MainGUI.Add("Picture", "x372 y266 BackgroundTrans", "AutomationModV1\Assets\Finance_O.png")
FrenchDiscord_O := MainGUI.Add("Picture", "x361 y298 w147 h59", "AutomationModV1\Assets\FrenchDiscord_O.png")
Arturo_O := MainGUI.Add("Picture", "x-30 y25 w352 h376 BackgroundTrans", "AutomationModV1\Assets\Arturo_O.png")
Stop_O := MainGUI.Add("Picture", "x-30 y25 w352 h376 BackgroundTrans", "AutomationModV1\Assets\Stop_O.png")

Close_O.Visible := 0
Minimize_O.Visible := 0
ClearFriendListMode_O.Visible := 0
MyGithub_O.Visible := 0
Finance_O.Visible := 0
FrenchDiscord_O.Visible := 0
Arturo_O.Visible := 0
AutomationLink_O.Visible := 0
CustomList_O.Visible := 0
Stop_O.Visible := 0
Stop.Visible := 0
Running1.Visible := 0
Running2.Visible := 0
Running3.Visible := 0
Running4.Visible := 0


Close_C := MainGUI.Add("Picture", "x468 y7 w44.5 h41.5", "AutomationModV1\Assets\Close_C.png")
Minimize_C := MainGUI.Add("Picture", "x420 y7 w44.5 h41.5", "AutomationModV1\Assets\Minimize_C.png")
ClearFriendListMode_C := MainGUI.Add("Picture", "x289 y62 w219 h40", "AutomationModV1\Assets\ClearFriendListMode_C.png")
AutomationLink_C := MainGUI.Add("Picture", "x322 y110 w186 h40", "AutomationModV1\Assets\AutomationLinks_C.png")
CustomList_C := MainGUI.Add("Picture", "x317 y158 w191 h40", "AutomationModV1\Assets\CustomGPAccList_C.png")
MyGithub_C := MainGUI.Add("Picture", "x273 y207 w236.5 h33", "AutomationModV1\Assets\MyGithub_C.png")
Finance_C := MainGUI.Add("Picture", "x372 y266 BackgroundTrans", "AutomationModV1\Assets\Finance_C.png")
FrenchDiscord_C := MainGUI.Add("Picture", "x361 y298 w147 h59", "AutomationModV1\Assets\FrenchDiscord_C.png")
Arturo_C := MainGUI.Add("Picture", "x-30 y25 w352 h376 BackgroundTrans", "AutomationModV1\Assets\Arturo_C.png")
Stop_C := MainGUI.Add("Picture", "x-30 y25 w352 h376 BackgroundTrans", "AutomationModV1\Assets\Stop_C.png")

Close_C.Visible := 0
Minimize_C.Visible := 0
ClearFriendListMode_C.Visible := 0
AutomationLink_C.Visible := 0
CustomList_C.Visible := 0
MyGithub_C.Visible := 0
Finance_C.Visible := 0
FrenchDiscord_C.Visible := 0
Arturo_C.Visible := 0
Stop_C.Visible := 0

MainGUI.Show("w518.5 h368")

;--------------------ClearFLModeGUI Initialization--------------------;

ClearFLModeGUI := Gui()
ClearFLModeGUI.BackColor := "0x201A1E"
ClearFLModeGUI.SetFont("s13 cc2255c ", "Comic Sans MS")
ClearFLModeGUI.Title := "ClearFLModeGUI"
ClearFLModeGUI.Opt("+Owner" MainGUI.Hwnd)
ClearFLModeGUI.opt("-SysMenu -Caption")

ClearFLModeGUI.Add("Picture", "x0 y0 w248 h211", "AutomationModV1\Assets\Frame2.png")
ClearFLModeGUI.Add("Picture", "x0 y0 w248 h55.5", "AutomationModV1\Assets\Title2.png")
Close2 := ClearFLModeGUI.Add("Picture", "x197 y7 w44.5 h41.5", "AutomationModV1\Assets\Close2.png")
Validate := ClearFLModeGUI.Add("Picture", "x149 y7 w44.5 h41.5", "AutomationModV1\Assets\Validate.png")
ClearFLOnce := ClearFLModeGUI.Add("Picture", "x7 y62 w143 h40.5", "AutomationModV1\Assets\ClearFLOnce.png")
AutoClearFL := ClearFLModeGUI.Add("Picture", "x7 y111 w142.5 h40.5", "AutomationModV1\Assets\AutoClearFL.png")
FLUpdate := ClearFLModeGUI.Add("Picture", "x7 y160 w237.5 h38", "AutomationModV1\Assets\FLUpdate.png")
GreenCircle := ClearFLModeGUI.Add("Picture", "x165 y62 w38.5 h39", "AutomationModV1\Assets\GreenCircle.png")
if mode = "Once" 
    GreenCircle.Move(165 ,62 ,38.5 ,39)
if mode = "Auto" 
    GreenCircle.Move(165, 110, 38.5, 39)
Close_O2 := ClearFLModeGUI.Add("Picture", "x197 y7 w44.5 h41.5", "AutomationModV1\Assets\Close_O2.png")
Validate_O := ClearFLModeGUI.Add("Picture", "x149 y7 w44.5 h41.5", "AutomationModV1\Assets\Validate_O.png")
ClearFLOnce_O := ClearFLModeGUI.Add("Picture", "x7 y62 w143 h40.5", "AutomationModV1\Assets\ClearFLOnce_O.png")
AutoClearFL_O := ClearFLModeGUI.Add("Picture", "x7 y111 w142.5 h40.5", "AutomationModV1\Assets\AutoClearFL_O.png")
FLUpdate_O := ClearFLModeGUI.Add("Picture", "x7 y160 w237.5 h38", "AutomationModV1\Assets\FLUpdate_O.png")

Close_O2.Visible := 0
Validate_O.Visible := 0
ClearFLOnce_O.Visible := 0
AutoClearFL_O.Visible := 0
FLUpdate_O.Visible := 0

Close_C2 := ClearFLModeGUI.Add("Picture", "x197 y7 w44.5 h41.5", "AutomationModV1\Assets\Close_C2.png")
Validate_C := ClearFLModeGUI.Add("Picture", "x149 y7 w44.5 h41.5", "AutomationModV1\Assets\Validate_C.png")
ClearFLOnce_C := ClearFLModeGUI.Add("Picture", "x7 y62 w143 h40.5", "AutomationModV1\Assets\ClearFLOnce_C.png")
AutoClearFL_C := ClearFLModeGUI.Add("Picture", "x7 y111 w142.5 h40.5", "AutomationModV1\Assets\AutoClearFL_C.png")
FLUpdate_C := ClearFLModeGUI.Add("Picture", "x7 y160 w237.5 h38", "AutomationModV1\Assets\FLUpdate_C.png")

Close_C2.Visible := 0
Validate_C.Visible := 0
ClearFLOnce_C.Visible := 0
AutoClearFL_C.Visible := 0
FLUpdate_C.Visible := 0

;--------------------LinkGUI Initialization--------------------;

LinkGUI := Gui()
LinkGUI.BackColor := "0x201A1E"
LinkGUI.SetFont("s15 cc2255c ", "Comic Sans MS")
LinkGUI.Title := "LinkGUI"
LinkGUI.Opt("+Owner" MainGUI.Hwnd)
LinkGUI.opt("-SysMenu -Caption")

LinkGUI.Add("Picture", "x0 y0 w894 h77", "AutomationModV1\Assets\Frame3.png")
CheckedMark := LinkGUI.Add("Picture", "x857 y44 w28.5 h24.5 BackgroundTrans", "AutomationModV1\Assets\CheckedMark.png")
LinkField := LinkGUI.Add("Edit", "x107 y4 w783 h33")
LinkField2 := LinkGUI.Add("Edit", "x107 y40 w742 h33")
LinkField.Value := Downloadlink
LinkField2.Value := Webhook

CheckedMark_O := LinkGUI.Add("Picture", "x857 y44 w28.5 h24.5 BackgroundTrans", "AutomationModV1\Assets\CheckedMark_O.png")

CheckedMark_O.Visible := 0

CheckedMark_C := LinkGUI.Add("Picture", "x857 y44 w28.5 h24.5 BackgroundTrans", "AutomationModV1\Assets\CheckedMark_C.png")

CheckedMark_C.Visible := 0

;--------------------FLUpdateGUI Initialization--------------------;

FLUpdateGUI := Gui()
FLUpdateGUI.BackColor := "0x201A1E"
FLUpdateGUI.SetFont("s15 cc2255c ", "Comic Sans MS")
FLUpdateGUI.Title := "FLUpdateGUI"
FLUpdateGUI.Opt("+Owner" ClearFLModeGUI.Hwnd)
FLUpdateGUI.opt("-SysMenu -Caption")

FLUpdateGUI.Add("Picture", "x0 y0 w86 h40", "AutomationModV1\Assets\Frame4.png")
CheckedMark2 := FLUpdateGUI.Add("Picture", "x49 y8 w28.5 h24.5 BackgroundTrans", "AutomationModV1\Assets\CheckedMark2.png")
FLUpdatesSet := FLUpdateGUI.Add("Edit", "x4 y4 w38 h33 Limit2 Number")
FLUpdatesSet.Value := B4Clear

CheckedMark_O2 := FLUpdateGUI.Add("Picture", "x49 y8 w28.5 h24.5 BackgroundTrans", "AutomationModV1\Assets\CheckedMark_O2.png")

CheckedMark_O2.Visible := 0

CheckedMark_C2 := FLUpdateGUI.Add("Picture", "x49 y8 w28.5 h24.5 BackgroundTrans", "AutomationModV1\Assets\CheckedMark_C2.png")

CheckedMark_C2.Visible := 0

;--------------------CustomListGUI Initialization--------------------;

CustomListGUI := Gui()
CustomListGUI.BackColor := "0x201A1E"
CustomListGUI.SetFont("s15 cc2255c ", "Comic Sans MS")
CustomListGUI.Title := "CustomListGUI"
CustomListGUI.Opt("+Owner" MainGUI.Hwnd)
CustomListGUI.opt("-SysMenu -Caption")

CustomListGUI.Add("Picture", "x0 y0 w536.5 h354", "AutomationModV1\Assets\Frame5.png")
CustomListGUI.Add("Picture", "x0 y0 w536.5 h56.5", "AutomationModV1\Assets\Title3.png")
Close3 := CustomListGUI.Add("Picture", "x485 y7 w44.5 h41.5", "AutomationModV1\Assets\Close3.png")
Validate2 := CustomListGUI.Add("Picture", "x437 y7 w44.5 h41.5", "AutomationModV1\Assets\Validate2.png")
CustomAccList := CustomListGUI.Add("Edit", "x4 y57 w528 h294")

CustomAccList.Value := FileRead(Path2)

Close_O3 := CustomListGUI.Add("Picture", "x485 y7 w44.5 h41.5", "AutomationModV1\Assets\Close_O3.png")
Validate_O2 := CustomListGUI.Add("Picture", "x437 y7 w44.5 h41.5", "AutomationModV1\Assets\Validate_O2.png")

Close_O3.Visible := 0
Validate_O2.Visible := 0

Close_C3 := CustomListGUI.Add("Picture", "x485 y7 w44.5 h41.5", "AutomationModV1\Assets\Close_C3.png")
Validate_C2 := CustomListGUI.Add("Picture", "x437 y7 w44.5 h41.5", "AutomationModV1\Assets\Validate_C2.png")

Close_C3.Visible := 0
Validate_C2.Visible := 0
;--------------------Overall GUI Functions--------------------;

OnMessage(0x0200, Highlight)
OnMessage(0x0201, WindowDrag)

WindowDrag(wParam, lParam, Msg, Hwnd) {
    if WinActive("FunnyGUI")
        ActiveWindow := WinActive("FunnyGUI")
    if WinActive("ClearFLModeGUI")
        ActiveWindow := WinActive("ClearFLModeGUI")
    if WinActive("LinkGUI")
        ActiveWindow := WinActive("LinkGUI")
    if WinActive("FLUpdateGUI")
        ActiveWindow := WinActive("FLUpdateGUI")
    if WinActive("CustomListGUI")
        ActiveWindow := WinActive("CustomListGUI")
    DllCall("PostMessage", "Ptr", ActiveWindow, "UInt", 0xA1, "Ptr", 2, "Ptr", 0)
}

Highlight(wParam, lParam, Msg, Hwnd) {
    MouseGetPos( ,,, &Control, 2)
    if Control {
        Text := ControlGetText(Control)
        MouseON(Text,Close,Close_O)
        MouseON(Text,Close2,Close_O2)
        MouseON(Text,Minimize,Minimize_O)
        MouseON(Text,Validate,Validate_O)
        MouseON(Text,ClearFriendListMode,ClearFriendListMode_O)
        MouseON(Text,AutomationLink,AutomationLink_O)
        MouseON(Text,CustomList,CustomList_O)
        MouseON(Text,MyGithub,MyGithub_O)
        MouseON(Text,Finance,Finance_O)
        MouseON(Text,FrenchDiscord,FrenchDiscord_O)
        MouseON(Text,ClearFLOnce,ClearFLOnce_O)
        MouseON(Text,AutoClearFL,AutoClearFL_O)
        MouseON(Text,FLUpdate,FLUpdate_O)
        MouseON(Text,Arturo,Arturo_O)
        MouseON(Text,CheckedMark,CheckedMark_O)
        MouseON(Text,CheckedMark2,CheckedMark_O2)
        MouseON(Text,Validate2,Validate_O2)
        MouseON(Text,Close3,Close_O3)
        MouseON(Text,Stop,Stop_O)
    }
}

MouseON(Text,pic1,pic2) {
    if Text = pic1.text {
        pic2.Visible := 1
    }
    if Text = pic2.text {
        pic2.Visible := 1
    }
    else if Text != (pic1.text or pic2.text) { 
        pic2.Visible := 0
    }
}

AddImageToGui(gui, image, options, text:="") {
    static WS_CHILD                  := 0x40000000   ; Creates a child window.
    static WS_VISIBLE                := 0x10000000   ; Show on creation.
    static WS_DISABLED               :=  0x8000000   ; Disables Left Click to drag.
    ImagePut.gdiplusStartup()
    pBitmap := ImagePutBitmap(image)
    DllCall("gdiplus\GdipGetImageWidth", "ptr", pBitmap, "uint*", &width:=0)
    DllCall("gdiplus\GdipGetImageHeight", "ptr", pBitmap, "uint*", &height:=0)
    display := Gui.Add("Text", options " w" width " h" height, text)
    display.imagehwnd := ImagePut.show(pBitmap,, [0, 0], WS_CHILD | WS_VISIBLE | WS_DISABLED,, display.hwnd)
    ImagePut.gdiplusShutdown()
    return display
}

;--------------------GUI Butoon Functions--------------------;

Close_O.OnEvent("Click",CloseGUI)
Close_O2.OnEvent("Click",CloseGUI)
Close_O3.OnEvent("Click",CloseGUI)

Minimize_O.OnEvent("Click",MinimizeGUI)

Validate_O.OnEvent("Click",ValidateParameters)
Validate_O2.OnEvent("Click",ValidateParameters)
CheckedMark_O.OnEvent("Click",ValidateParameters)
CheckedMark_O2.OnEvent("Click",ValidateParameters)

ClearFriendListMode_O.OnEvent("Click",ModWin)
FLUpdate_O.OnEvent("Click",ModWin)
AutomationLink_O.OnEvent("Click",ModWin)
CustomList_O.OnEvent("Click",ModWin)

ClearFLOnce_O.OnEvent("Click",SetMode)
AutoClearFL_O.OnEvent("Click",SetMode)

Arturo_O.OnEvent("Click",Main)
Stop_O.OnEvent("Click",StopMacro)

FrenchDiscord_O.OnEvent("Click",LinkDiscord)
MyGithub_O.OnEvent("Click",LinkGithub)
Finance_O.OnEvent("Click",Linkcoffee)

CloseGUI(GuiCtrlObj, Info) {
    img := GuiCtrlObj.hwnd 
    if img = Close_O.Hwnd {
        Close_C.Visible := 1
        sleep 200
    }
    if img = Close_O2.Hwnd {
        Close_C2.Visible := 1
        sleep 200
        WinSetTransparent("Off","FunnyGUI")
    }
    if img = Close_O3.Hwnd {
        Close_C3.Visible := 1
        sleep 200
        WinSetTransparent("Off","FunnyGUI")
    }
    MainGUI.Opt("-Disabled")
    WinClose("A")
    Close_C3.Visible := 0
    Close_C2.Visible := 0
    Close_C.Visible := 0
}

MinimizeGUI(GuiCtrlObj, Info) {
    Minimize_C.Visible := 1
    sleep 200
    WinMinimize("A")
    Minimize_C.Visible := 0
}

ModWin(GuiCtrlObj, Info) {
    img := GuiCtrlObj.hwnd 
    if img = ClearFriendListMode_O.Hwnd {
        ClearFriendListMode_O.Visible := 1
        sleep 200
        MainGUI.Opt("+Disabled")
        WinSetTransparent(100,"FunnyGUI")
        ClearFLModeGUI.Show("w248 h211")
        ClearFriendListMode_O.Visible := 0
    }
    else if img = FLUpdate_O.Hwnd {
        FLUpdate_C.Visible := 1
        sleep 200
        ClearFLModeGUI.Opt("+Disabled")
        WinSetTransparent(100,"ClearFLModeGUI")
        FLUpdateGUI.Show("w86 h40")
        FLUpdate_C.Visible := 0
    }
    else if img = AutomationLink_O.Hwnd {
        AutomationLink_C.Visible := 1
        sleep 200
        MainGUI.Opt("+Disabled")
        WinSetTransparent(100,"FunnyGUI")
        LinkGUI.Show("w894 h77")
        AutomationLink_C.Visible := 0
    }
    else if img = CustomList_O.Hwnd {
        CustomList_C.Visible := 1
        MainGUI.Opt("+Disabled")
        WinSetTransparent(100,"FunnyGUI")
        CustomAccList.Value := FileRead(Path2)
        CustomListGUI.Show("w536.5 h354")
        CustomList_C.Visible := 0
    }
}

ValidateParameters(GuiCtrlObj, Info) {
    img := GuiCtrlObj.hwnd
    if img = Validate_O.Hwnd {
        MainGUI.Opt("-Disabled")
        WinSetTransparent("Off","FunnyGUI")
        if mode = "Once" {
            IniWrite("Once", "Settings.ini", "sim_g_Mod", "mode")
            GreenCircle.Move(165 ,62 ,38.5 ,39)
        }
        if mode = "Auto" {
            IniWrite("Auto", "Settings.ini", "sim_g_Mod", "mode")
            GreenCircle.Move(165, 110, 38.5, 39)
        }
        ClearFLModeGUI.Hide()
    }
    else if img = CheckedMark_O.Hwnd {
        MainGUI.Opt("-Disabled")
        WinSetTransparent("Off","FunnyGUI")
        IniWrite(LinkField.Value, "Settings.ini", "sim_g_Mod", "Link")
        IniWrite(LinkField2.Value, "Settings.ini", "sim_g_Mod", "Webhook")
        global webhook := LinkField2.Value
        global Link := LinkField.Value
        LinkGUI.Hide()
    }
    else if img = CheckedMark_O2.Hwnd {
        ClearFLModeGUI.Opt("-Disabled")
        WinSetTransparent("Off","ClearFLModeGUI")
        IniWrite(FLUpdatesSet.Value, "Settings.ini", "sim_g_Mod", "B4Clear")
        FLUpdateGUI.Hide()
    }
    else if img = Validate_O2.Hwnd {
        MainGUI.Opt("-Disabled")
        WinSetTransparent("Off","FunnyGUI")
        FileDelete(Path2)
        FileAppend(CustomAccList.Value, Path2)
        CustomListGUI.Hide()
    }
}

SetMode(GuiCtrlObj, Info) {
    img := GuiCtrlObj.hwnd
    if img = ClearFLOnce_O.Hwnd { 
        ClearFLOnce_C.Visible := 1
        global mode := "Once"
        GreenCircle.Move(165 ,62 ,38.5 ,39)
        sleep 200
        ClearFLOnce_C.Visible := 0
    }
    else if img = AutoClearFL_O.Hwnd { 
        AutoClearFL_C.Visible := 1
        global mode := "Auto" 
        GreenCircle.Move(165, 110, 38.5, 39)
        sleep 200
        AutoClearFL_C.Visible := 0
    }
}

StopMacro(*) {
    global Stopped := 1
    Stop.Visible := 0
    Stop_O.Visible := 0
}

SetTimer(UpdateGUI, 1000)

UpdateGUI() {
    if stopped = 1 {
        if Arturo.Visible != 1
            Arturo.Visible := 1
        if Stop.Visible != 0
            Stop.Visible := 0
    }
    if stopped = 0 {
        if Arturo.Visible != 0
            Arturo.Visible := 0
        if Stop.Visible != 1
            Stop.Visible := 1
        if Running1.Visible = 1 {
            Running2.Visible := 1
            Running1.Visible := 0
        }
        else if Running2.Visible = 1 {
            Running3.Visible := 1
            Running2.Visible := 0
        }
        else if Running3.Visible = 1 {
            Running4.Visible := 1
            Running3.Visible := 0
        }
        else if Running4.Visible = 1 {
            Running1.Visible := 1
            Running4.Visible := 0
        }
    }
}

LinkDiscord(*) {
    Run("https://discord.gg/pn6XSn42m6")
}

LinkGithub(*) {
    Run("https://github.com/gmisSe/Automation-mod-for-PTCFPB")
}

Linkcoffee(*) {
    Run("https://buymeacoffee.com/sim_g")
}
;-------------------------------------Main loop-------------------------------------;

Main(*) {
    Stop.Visible := 1
    Running1.Visible := 1
    Arturo.Visible := 0
    Arturo_O.Visible := 0
    global stopped := 0
    ConnectAdb()
    FindMain()
    if mode = "Auto" {
        loop {
            if Stopped = 1
                break
            WaitForFull()
            FindMain()
            if  Mod(A_Index, B4Clear) {
                SendToDiscord("Friendlist is full, refreshing")
                Start(&winX, &winY, &WinW, &WinH)
                GoToSocial()
                GoToFR()
                WinMove(winX, winY, WinW, WinH, Wintitle)
                end(winX, winY, WinW, WinH)
            }
            else {
                Start(&winX, &winY, &WinW, &WinH)
                GoToFL(3)
                sleep 500
                DeleteNoneGP()
                GoToFR
                ClearAll(2)
                end(winX, winY, WinW, WinH)
            }
            sleep 10000
        }
    }
    if mode = "Once" {
        Start(&winX, &winY, &WinW, &WinH)
        GoToSocial()
        GoToFL(3)
        sleep 500
        DeleteNoneGP()
        GoToFR()
        ClearAll(2)
        end(winX, winY, WinW, WinH, 0)
    }
    Running1.Visible := 0
    Running2.Visible := 0
    Running3.Visible := 0
    Running4.Visible := 0
    global Stopped := 1
}



;-------------------------Some Functions-------------------------;

FindMain() {
    TextMacro := []
    TextMain := WinGetList("Main")
    TextMacro.Push(WinGetList("ahk_exe AutoHotkeyU64.exe")*)
    TextMacro.push(WinGetList("ahk_exe AutoHotkey.exe")*)
    TextMumu := WinGetList("ahk_exe MuMuPlayer.exe")
    for id in TextMain {
        for id2 in TextMumu {
            if id = id2 {
                global Wintitle := "ahk_id " id
                break
            }
        }
        for id3 in TextMacro {
            if id = id3 {
                global Wintitle2 := "ahk_id " id
                break
            }
        }
    }
} 

DownloadList() {
    global link
    gistlist := 0
    if RegExMatch(Link, "gist.github", &test)
        gistlist := 1
    if RegExMatch(Link, "raw", &test) {
        l := (StrSplit(Link, "/"))
        Link := l[1] "/" l[2] "/" l[3] "/" l[4] "/" l[5]
    }
    if gistlist = 1 {
        MsgBox(Link)
        Download(Link, "AutomationModV1\content.html")
        if RegExMatch(content := FileRead(Path3), "/" (StrSplit(Link, "/"))[4] "/.+?/.*\.txt", &test) {
            fullUrl := "https://gist.github.com" . test[]
            Download(fullUrl, Path)
        }
    }
    else
        Download(Link, Path)
}

GetlistofGP() {
    resend := 1
    global names := []
    global codes := []
    global stars := []
    if Link
        While resend = 1 {
            try {
                resend := 0
                DownloadList()
            }
            catch as e {
                Resend := 1
            }
        }
    FileContents := FileRead(Path) "`n" FileRead(Path2)
    Loop parse, FileContents, "`n", "`r" {  
        line := Trim(A_LoopField)
        line := StrReplace(line," ","")
        Split := StrSplit(line, "|")
        if Split.Length >= 1 {  
            codes.Push(Split[1])
        }
        if Split.Length >= 2 { 
            names.Push(Split[2])
        }
        if Split.Length >= 3 { 
            stars.Push(Split[3])
        }
    }
}


findcode() {
    scale := 2
    loop {
        code := (OCRWindowRegion(Wintitle,337, 102, 187, 27,&result,scale).Text)
        code := StrReplace(code," ","")
        code := StrReplace(code,"-","")
        if StrLen(code) = 12 or 13 or 14 or 15 or 16 or 17
            finalcode := code
        if StrLen(code) = 16
            break
        if scale > 50
            break
        scale := scale + 2
    }
    return finalcode 
}

;-------------------------More Functions-------------------------;

OCRWindowRegion(Wintitle,x1,y1,w,h,&result,scale:=1) {
    ImagePut.gdiplusStartup()
    pic := ImagePutBitmap({window: Wintitle, crop: [x1, y1, w, h]})
    result := OCR.FromBitmap(pic, {scale:scale})
    ImageDestroy(pic)
    if result
        return result
}

PixelCountWindowRegion(Wintitle,pixels,&count,x1,y1,w,h,variance:=0) {
    count := 0
    pic := ImagePutBuffer({window: Wintitle, crop: [x1, y1, w, h]})
    if PixelArray := pic.PixelSearchAll(pixels,variance) {
        count := PixelArray.Length
        return count
    }
}

;-------------------------Even More Functions-------------------------;

Start(&winX, &winY, &WinW, &WinH) {
    if Wintitle2
        loop 50 {
            ControlClick("Button2", Wintitle2)
            sleep 10
        }
    WinGetPos(&winX, &winY, &WinW, &WinH, Wintitle)
    WinMove(,,550,1010,Wintitle)
}

end(winX, winY, WinW, WinH,unpause:=1) {
    WinMove(winX, winY, WinW, WinH, Wintitle)
    if (unpause = 1 and Wintitle2) {
        loop 50 {
            ControlClick("Button3", Wintitle2)
            sleep 10
        }
    }
}

DeleteNoneGP() {
    SendToDiscord("Clearing")
    PreviousFriendFound := 0
    Finished := 0
    GPAccOnScreen := 0
    GetlistofGP()
    loop {
        Finished := Finished + 1
        if Finished > 15 or (Stopped = 1)
            break
        GoToFL(3)
        sleep 1000
        WaitLoad()
        FriendFound := OCRWindowRegion(Wintitle,154, 214, 198, 621,&result,4).Words
        Friends := FriendFound.Length
        Loop Friends {
            i := Friends - A_Index + 1
            if (FriendFound[i].x) >= 26
                FriendFound.RemoveAt(i)
            else if (FriendFound[i].y) < 23
                FriendFound.RemoveAt(i)
        }
        Friends := FriendFound.length
        loop (Friends) {
            GP := 0
            S := 0
            Friend := FriendFound[A_Index]
            if Friend.text = "No" or (Friend.text = "n'avez") { 
                Finished := 100
                break
            }
            for n in names {
                nameSimilarity := Similarity.match(Friend.text, names[A_Index])
                if Friend.text = names[A_Index] {
                    GP := 1
                    break
                }
                else if nameSimilarity > 0.8 {
                    GP := 0.60
                }
            }
            if GP < 1 {
                GoToProfile(Friend.x,Friend.y)
                WaitLoad()
                code := findcode()
                if StrLen(code) < 16
                    GP := 0.5
                for n in codes {
                    codesimilarity := Similarity.match(code, codes[A_Index])
                    If codesimilarity > S
                        S := codesimilarity
                    if code = codes[A_Index] {
                        GP := 1
                        GoToFL(3)
                        break
                    }
                }
            }
            if (GP+S) < 1 {
                GoToProfile(Friend.x,Friend.y)
                Delete(6)
                WaitLoad()
                GoToFL(3)
                Finished := 0
                break
            }
            else if (GP+S) >= 1{
                GPAccOnScreen := GPAccOnScreen + 1
                if S { 
                    names.Push(Friend.text)
                    break
                } 
                if GPAccOnScreen >= 3 {
                    SmallScroll()
                    GPAccOnScreen := 0
                    break
                }
            }
        }
    }
    if stopped != 1
        SendToDiscord("Friendlist Cleared")
}


;PixelCountWindowRegion(Wintitle, [0x57677F], &count1, 231, 278, 20, 20, 10) ; > 300 si full 
;PixelCountWindowRegion(Wintitle, [0xE2EDF6], &count2, 245, 244, 50, 50, 10)  ; < 50 si profil chargé
;PixelCountWindowRegion(Wintitle, [0x0FD7E1], &count3, 164, 742, 31, 27, 10) ; > 10 si ami 
;PixelCountWindowRegion(Wintitle, [0xD4DAEE], &count4, 106, 103, 50, 50, 10) ; 2500 si profile
;PixelCountWindowRegion(Wintitle, [0xE0EBF5], &count5, 160, 857, 13, 22, 0) ; > 150 si dans fl 
;PixelCountWindowRegion(Wintitle, [0xDEEAF4], &count6, 496, 861, 13, 12, 0) ; > 150 si dans Fr
;PixelCountWindowRegion(Wintitle, [0xF03E44], &count7, 373, 671, 42, 24, 5) ; > 10 si ok pour remove
;PixelCountWindowRegion(Wintitle, [0x3FEC99], &count8, 241, 311, 50, 50, 5) ; > 50 si dans social
;PixelCountWindowRegion(Wintitle, [0x525B6A], &count9, 254, 954, 42, 41, 5) ; > 50 si social button
;PixelCountWindowRegion(Wintitle, [0xE93D44], &count10, 381, 941, 20, 21, 5) ; < 30 si cleat all
;PixelCountWindowRegion(Wintitle, [0xD4DAEE], &count11, 470, 168, 50, 50, 10) ; > 500 si dans profil
;PixelCountWindowRegion(Wintitle, [0x85EF6B, 0x9CF056, 0xFDB44D, 0xFF9F69, 0xE3F314, 0xBDF237, 0x6ACFF9, 0x80C7FD, 0xEA8CF8, 0xD19AFF, 0xF7DE1E, 0xFACA35, 0x37E6E0, 0x3CE8D3, 0x39E2F0, 0x33E5EA, 0xB6AAFF, 0xA8B2FF, 0xFF859C, 0xFE81A6, 0x51ED9D, 0x64EE89, 0xEF89E2, 0xEC8BEF, 0x47EAB7, 0x4CEBAA, 0xFF9B72, 0xFF957C, 0x59D6F6, 0x4CDBF4, 0xFEAD56, 0xFFA362, 0x93BEFF, 0x86C5FE, 0xE1F316, 0xC9F22C], &count12, 246, 488, 58, 69, 5) ; > 5 si loading
;PixelCountWindowRegion(Wintitle, [0xE8F0F7], &count13, 48, 244, 119, 547, 5) ; < 30000 si FL loaded


GoToProfile(FriendX:=0, FriendY:=0) {

    PixelCountWindowRegion(Wintitle, [0xD4DAEE], &count4, 106, 103, 50, 50, 10)
    Spam_detection(FriendX+154, FriendY+214, count4, 0, 2499, 5, "0xD4DAEE", 106, 103, 50, 50, 10)

    PixelCountWindowRegion(Wintitle, [0xE2EDF6], &count2, 245, 244, 50, 50, 10)
    Spam_detection("", "", count2, 51, 5000, 5, "0xE2EDF6", 245, 244, 50, 50, 10)
}

GoToFL(it) {
    loop it { 
        PixelCountWindowRegion(Wintitle, [0xE2EDF6], &count2, 245, 244, 50, 50, 10)
        PixelCountWindowRegion(Wintitle, [0xD4DAEE], &count4, 106, 103, 50, 50, 10)
        PixelCountWindowRegion(Wintitle, [0xE0EBF5], &count5, 160, 857, 13, 22, 0)
        PixelCountWindowRegion(Wintitle, [0xDEEAF4], &count6, 496, 861, 13, 12, 0)
        PixelCountWindowRegion(Wintitle, [0xD4DAEE], &count11, 470, 168, 50, 50, 10)
        PixelCountWindowRegion(Wintitle, [0x3FEC99], &count8, 241, 311, 50, 50, 5)
        if count5 > 80
            return 2
        else if count2 = 0 and count4 = 0 and count8 > 50 {
            Spam_detection(39, 896, count5 , 0, 80, 5, "0xE0EBF5", 160, 857, 13, 22, 0, 50)
    
            PixelCountWindowRegion(Wintitle, [0xE8F0F7], &count13, 48, 244, 119, 547, 5) ; < 30000 si FL loaded
            Spam_detection("", "", count13, 50000, 80000, 5, "0xE8F0F7", 48, 244, 119, 547, 5, 50)
        }
        else if count2 < 50 {
            failsafe := 0
            adbClick(274, 946)
            while count4 > 1000 or count11 > 300 and (failsafe < 100) {
                failsafe := failsafe + 1
                if !Mod(A_Index, 5)
                    adbClick(274, 946)
                sleep 100
                PixelCountWindowRegion(Wintitle, [0xD4DAEE], &count4, 106, 103, 50, 50, 10)
                PixelCountWindowRegion(Wintitle, [0xD4DAEE], &count11, 470, 168, 50, 50, 10)
                failsafe := failsafe + 1
            }
            Spam_detection(180, 871, count5, 0, 80, 5, "0xE0EBF5", 40, 853, 13, 22, 5, 50)

            PixelCountWindowRegion(Wintitle, [0xE8F0F7], &count13, 48, 244, 119, 547, 5) ; < 30000 si FL loaded
            Spam_detection("", "", count13, 50000, 80000, 5, "0xE8F0F7", 48, 244, 119, 547, 5, 50)
        }
        else if count6 > 150 {
            Spam_detection(180, 871, count5, 0, 150, 5, "0xE0EBF5", 40, 853, 13, 22, 5, 50)
    
            PixelCountWindowRegion(Wintitle, [0xE8F0F7], &count13, 48, 244, 119, 547, 5) ; < 30000 si FL loaded
            Spam_detection("", "", count13, 50000, 80000, 5, "0xE8F0F7", 48, 244, 119, 547, 5, 50)
        }
    }
}

GoToFR() {
    PixelCountWindowRegion(Wintitle, [0xDEEAF4], &count6, 496, 861, 13, 12, 0)
    PixelCountWindowRegion(Wintitle, [0xE2EDF6], &count2, 245, 244, 50, 50, 10)
    if count2 = 0 {
        Spam_detection(39, 896, count2, 0, 0, 10, "0xE2EDF6", 245, 244, 50, 50, 10, 100)
    }
    if count6 < 80 {
        Spam_detection(369, 886, count6, 0, 80, 10, "0xDEEAF4", 496, 861, 13, 12, 5, 100)
    }
}

Delete(it) {
    loop it {
        PixelCountWindowRegion(Wintitle, [0x0FD7E1], &count3, 164, 742, 31, 27, 10)
        if count3 > 10 {
            PixelCountWindowRegion(Wintitle, [0xF03E44], &count7, 370, 665, 70, 50, 15)
            Spam_detection(278, 757, count7, 0, 5, 5, "0xF03E44", 370, 665, 70, 50, 50, 15)
            sleep 200
    
            PixelCountWindowRegion(Wintitle, [0xF03E44], &count7, 370, 665, 70, 50, 15)
            Spam_detection(296, 680, count7, 5, 5000, 5, "0xF03E44",  370, 665, 70, 50, 50, 15)
            sleep 300

            PixelCountWindowRegion(Wintitle, [0xF03E44], &count7, 370, 665, 70, 50, 15)
            Spam_detection(296, 680, count7, 5, 5000, 5, "0xF03E44",  370, 665, 70, 50, 50, 15)
        }
    }
}

SmallScroll() {
    adbSwipe(528, 830, 528, 300,100)
    adbClick(528, 830)
    return 8
}

WaitForFull() {
    PixelCountWindowRegion(Wintitle, [0x57677F], &count1, 231, 278, 20, 20, 10)
    Spam_detection("", "", count1, 0, 300, 5, "0x57677F", 231, 278, 20, 20, 10)
}

GoToSocial() {
    PixelCountWindowRegion(Wintitle, [0x3FEC99], &count8, 241, 311, 50, 50, 5)
    PixelCountWindowRegion(Wintitle, [0x525B6A], &count9, 254, 954, 42, 41, 5)
    if count9 < 50 {
        Spam_detection(272, 951, count9, 0, 50, 500, "0x525B6A", 254, 954, 42, 41, 5)
    }
    if count8 < 50 {
        Spam_detection(274, 966, count8, 0, 50, 100, "0x3FEC99", 241, 311, 50, 50, 5)   
    }
    sleep 2000
    Spam_detection("", "", count8, 0, 50, 100, "0x3FEC99", 241, 311, 50, 50, 5)
}

ClearAll(it) {
    loop it { 
        PixelCountWindowRegion(Wintitle, [0xE93D44], &count10, 381, 941, 20, 21, 5)
        Spam_detection(450, 952, count10, 30, 5000, 5,"0xE93D44", 381, 941, 20, 21, 5, 50)
        sleep 500
    
        PixelCountWindowRegion(Wintitle, [0xF03E44], &count7, 373, 671, 42, 24, 10)
        Spam_detection(296, 680, count7, 10, 5000, 5, "0xF03E44", 373, 671, 42, 24, 50, 50)
    }

}

WaitLoad() {
    PixelCountWindowRegion(Wintitle, [0x85EF6B, 0x9CF056, 0xFDB44D, 0xFF9F69, 0xE3F314, 0xBDF237, 0x6ACFF9, 0x80C7FD, 0xEA8CF8, 0xD19AFF, 0xF7DE1E, 0xFACA35, 0x37E6E0, 0x3CE8D3, 0x39E2F0, 0x33E5EA, 0xB6AAFF, 0xA8B2FF, 0xFF859C, 0xFE81A6, 0x51ED9D, 0x64EE89, 0xEF89E2, 0xEC8BEF, 0x47EAB7, 0x4CEBAA, 0xFF9B72, 0xFF957C, 0x59D6F6, 0x4CDBF4, 0xFEAD56, 0xFFA362, 0x93BEFF, 0x86C5FE, 0xE1F316, 0xC9F22C], &count12, 246, 488, 58, 69, 5)
    while count12 > 3 {
        PixelCountWindowRegion(Wintitle, [0x85EF6B, 0x9CF056, 0xFDB44D, 0xFF9F69, 0xE3F314, 0xBDF237, 0x6ACFF9, 0x80C7FD, 0xEA8CF8, 0xD19AFF, 0xF7DE1E, 0xFACA35, 0x37E6E0, 0x3CE8D3, 0x39E2F0, 0x33E5EA, 0xB6AAFF, 0xA8B2FF, 0xFF859C, 0xFE81A6, 0x51ED9D, 0x64EE89, 0xEF89E2, 0xEC8BEF, 0x47EAB7, 0x4CEBAA, 0xFF9B72, 0xFF957C, 0x59D6F6, 0x4CDBF4, 0xFEAD56, 0xFFA362, 0x93BEFF, 0x86C5FE, 0xE1F316, 0xC9F22C], &count12, 246, 488, 58, 69, 5)
        sleep 50
    }
}

Spam_detection(x,y,count,inf,sup,cr,color,xd,yd,w,h,v,fs:=10000000000000000) {
    global stopped
    failsafe := 0
    if x
        adbClick(x, y)
    while (inf <= count) and (count <= sup) and (failsafe < fs) {
        if !Mod(A_Index, cr) and x
            adbClick(x, y)
        sleep 100
        PixelCountWindowRegion(Wintitle, [color], &count, xd, yd, w, h, v)
        failsafe := failsafe + 1
        if Stopped = 1
            break
    }
}


SendToDiscord(message) {
    resend := 1
    if webhook {
        if discordid 
            message := "<@" discordid ">" " " message
        http := ComObject("WinHttp.WinHttpRequest.5.1")
        http.Open("POST", webhook)
        http.SetRequestHeader("Content-Type", "application/json")
        While resend = 1 {
            try {
                resend := 0
                http.Send('{"content": "' . message . '"}')
            }
            catch as e {
                Resend := 1
            }
        }
    }
}

;---------------------------------Test Place---------------------------------;

F9::
{
    StopMacro()
}

F10::
{
    MainGUI.Show("w518.5 h368")
}

^r::
{
    Reload
}

^p::
{
    FindMain()
    WinMove(0, 0, 277, 537, Wintitle)
}

^t::
{
    GetlistofGP()
    MsgBox("done")
}
