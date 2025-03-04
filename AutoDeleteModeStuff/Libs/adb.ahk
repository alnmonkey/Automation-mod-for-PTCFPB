#Requires AutoHotkey v2.0
;stall all of that from Arturo's bot 
;|-----------------Variables and other shit-----------------|

folderPath := IniRead("Settings.ini", "UserSettings", "folderPath", "C:\Program Files\Netease")
adbPath := folderPath . "\MuMuPlayerGlobal-12.0\shell\adb.exe"
adbPort := findAdbPorts(folderPath)
global Wintitle := "Main"
global scriptName := "Main"
global e := 0
global adbShell := 0
global border := 43

;|-----------------Adb setup functions-----------------|

hideconsol() {
    DllCall("AllocConsole")
    WinHide("ahk_id " DllCall("GetConsoleWindow", "ptr"))
}


findAdbPorts(baseFolder := "C:\Program Files\Netease") {
    global adbPorts, winTitle, scriptName
    global scriptName := "Main"
    adbPorts := Map() ; Initialize an empty associative array

    mumuFolder := baseFolder "\MuMuPlayerGlobal-12.0\vms\*"
    if !DirExist(StrReplace(mumuFolder, "*", "")) {
        mumuFolder := baseFolder "\MuMu Player 12\vms\*"
    }

    if !DirExist(StrReplace(mumuFolder, "*", "")) {
        ;MsgBox("Double-check your folder path! It should contain the MuMuPlayer 12 folder.`nDefault is C:\Program Files\Netease", "Error", 16)
        ExitApp()
    }

    ; Loop through all directories in the base folder
    Loop Files mumuFolder, "D" { ; "D" flag for directories only
        folder := A_LoopFileFullPath
        configFolder := folder "\configs"

        if DirExist(configFolder) {
            vmConfigFile := configFolder "\vm_config.json"
            extraConfigFile := configFolder "\extra_config.json"
            adbPort := ""

            ; Read adb host port from vm_config.json
            if FileExist(vmConfigFile) {
                vmConfigContent := FileRead(vmConfigFile)
                if RegExMatch(vmConfigContent, '"host_port":\s*"(\d+)"', &match) {
                    adbPort := match[1]
                }
            }

            ; Read playerName from extra_config.json
            if FileExist(extraConfigFile) {
                extraConfigContent := FileRead(extraConfigFile)
                if RegExMatch(extraConfigContent, '"playerName":\s*"(.*?)"', &match) {
                    if match[1] = scriptName {
                        return adbPort
                    }
                }
            }
        }
    }
}

initializeAdbShell() {
    global adbShell, adbPath, adbPort
    RetryCount := 0
    MaxRetries := 10
    BackoffTime := 1000  ; Initial backoff time in milliseconds

    while RetryCount <= MaxRetries {
        try {
            if (!adbShell) {
                ; Validate adbPath and adbPort
                if (!FileExist(adbPath)) {
                    throw Error("ADB path is invalid.")
                }
                if (adbPort < 0 || adbPort > 65535)
                    throw Error("ADB port is invalid.")

                adbShell := ComObject("WScript.Shell").Exec(adbPath . " -s 127.0.0.1:" . adbPort . " shell")
                adbShell.StdIn.WriteLine("su")
            } else if (adbShell.Status != 0) {
                Sleep(BackoffTime)
                BackoffTime += 1000 ; Increase the backoff time
            } else {
                break
            }
        } catch Error as e {
            RetryCount++
            if (RetryCount > MaxRetries) {
                Pause
            }
        }
        Sleep(BackoffTime)
    }
    if WinExist("ahk_exe adb.exe")
        WinHide("ahk_exe adb.exe")
}

ConnectAdb() {
    global adbPath, adbPort
    MaxRetries := 5
    RetryCount := 0
    connected := false
    ip := "127.0.0.1:" . adbPort ; Specify the connection IP:port

    Loop MaxRetries {
        ; Attempt to connect using CmdRet
        connectionResult := CmdRet(adbPath . " connect " . ip)
        if InStr(connectionResult, "connected to " . ip) {
            connected := true
            return true
        } else {
            RetryCount++
            Sleep(2000)
        }
    }

    if !connected {
        Reload
    }
}

CmdRet(sCmd, callBackFuncObj := "", encoding := "") {
    global hPipeRead := 0
    global hPipeWrite := 0
    static HANDLE_FLAG_INHERIT := 0x00000001, flags := HANDLE_FLAG_INHERIT
        , STARTF_USESTDHANDLES := 0x100, CREATE_NO_WINDOW := 0x08000000

    if (encoding = "")
        encoding := "cp" . DllCall("GetOEMCP", "UInt")
    DllCall("CreatePipe", "PtrP", &hPipeRead, "PtrP", &hPipeWrite, "Ptr", 0, "UInt", 0)
    DllCall("SetHandleInformation", "Ptr", hPipeWrite, "UInt", flags, "UInt", HANDLE_FLAG_INHERIT)

    STARTUPINFO := Buffer(A_PtrSize * 4 + 4 * 8 + A_PtrSize * 5, 0) ; Allocate memory for STARTUPINFO structure

    NumPut("UInt", STARTUPINFO.size, STARTUPINFO, 0)  ; Set the size of the structure
    NumPut("UInt", STARTF_USESTDHANDLES, STARTUPINFO, A_PtrSize * 4 + 4 * 7) ; Set STARTF_USESTDHANDLES flag
    NumPut("Ptr", hPipeWrite, STARTUPINFO, A_PtrSize * 4 + 4 * 8 + A_PtrSize * 3) ; Assign hPipeWrite to correct offset
    NumPut("Ptr", hPipeWrite, STARTUPINFO, A_PtrSize * 4 + 4 * 8 + A_PtrSize * 4) ; Assign hPipeWrite again

    PROCESS_INFORMATION := Buffer(A_PtrSize * 2 + 4 * 2, 0)

    if !DllCall("CreateProcess", "Ptr", 0, "Str", sCmd, "Ptr", 0, "Ptr", 0, "UInt", true, "UInt", CREATE_NO_WINDOW
                                  , "Ptr", 0, "Ptr", 0, "Ptr", STARTUPINFO.Ptr, "Ptr", PROCESS_INFORMATION.Ptr) {
        DllCall("CloseHandle", "Ptr", hPipeRead)
        DllCall("CloseHandle", "Ptr", hPipeWrite)
        throw Error("CreateProcess failed")
    }
    DllCall("CloseHandle", "Ptr", hPipeWrite)
    sOutput := ""
    sTemp := Buffer(4096)
    nSize := 0
    while DllCall("ReadFile", "Ptr", hPipeRead, "Ptr", sTemp.Ptr, "UInt", 4096, "UIntP", &nSize, "UInt", 0) {
        stdOut := StrGet(sTemp.Ptr, nSize, encoding)
        sOutput .= stdOut
        if callBackFuncObj
            callBackFuncObj(stdOut)
    }
    DllCall("CloseHandle", "Ptr", NumGet(PROCESS_INFORMATION, 0, "Ptr"))
    DllCall("CloseHandle", "Ptr", NumGet(PROCESS_INFORMATION, A_PtrSize, "Ptr"))
    DllCall("CloseHandle", "Ptr", hPipeRead)
    return sOutput
}

;|-----------------adb Interact functions-----------------|

adbClick(X, Y) {
    global adbShell, adbPath, adbPort
    initializeAdbShell()
    Y := Y - border
    adbShell.StdIn.WriteLine("input tap " X " " Y)
}

adbInput(name) {
    global adbShell, adbPath, adbPort
    initializeAdbShell()
    adbShell.StdIn.WriteLine("input text " name)
}

adbSwipe(X,Y,X2,Y2,ms) {
    global adbShell, adbPath, adbPort
    initializeAdbShell()
    Y := Y - border
    Y2 := Y2 - border
    adbShell.StdIn.WriteLine("input swipe " X " " Y " " X2 " " Y2 " " ms)
}



