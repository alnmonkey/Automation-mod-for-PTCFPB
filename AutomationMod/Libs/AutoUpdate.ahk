#Requires AutoHotkey v2.0.18+
; i stall of that from arturo and translated it to v2, ty Arturo my King <3


CheckForUpdate() {
	global githubUser, repoName, localVersion, zipPath, extractPath, scriptFolder
	url := "https://api.github.com/repos/" githubUser "/" repoName "/releases/latest"

	response := HttpGet(url)
	if !response {
		MsgBox("Failed to fetch release info.")
		return
	}

	latestReleaseBody := FixFormat(ExtractJSONValue(response, "body"))
	latestVersion := ExtractJSONValue(response, "tag_name")
	zipDownloadURL := ExtractJSONValue(response, "zipball_url")
	A_Clipboard := latestReleaseBody

	if (zipDownloadURL = "" || !InStr(zipDownloadURL, "http")) {
		MsgBox("Failed to find the ZIP download URL in the release.")
		return
	}

	if (latestVersion = "") {
		MsgBox("Failed to retrieve version info.")
		return
	}

	if (VersionCompare(latestVersion, localVersion) > 0)
	{
		; Get release notes from the JSON (ensure this is populated earlier in the script)
		releaseNotes := latestReleaseBody  ; Assuming `latestReleaseBody` contains the release notes

		; Show a message box asking if the user wants to download
		msgResult := MsgBox(releaseNotes "`n`nDo you want to download the latest version?", "Update Available " latestVersion, 4)

		; If the user clicks Yes (return value 6)
		if (msgResult = "Yes")
		{
			MsgBox("Downloading the latest version...", "Downloading...", 64)

			; Proceed with downloading the update
            try
                {
                    Download(zipDownloadURL,zipPath)
                    i := 0
                }
                catch as e
                {
                    MsgBox("Failed to download update.")
                    i := 1
                    return
                }
			if i = 0 {
				MsgBox("Download complete. Extracting...")

				; Create a temporary folder for extraction
				tempExtractPath := A_Temp "\PTCGPB_Temp"
				DirCreate(tempExtractPath)

				; Extract the ZIP file into the temporary folder
				RunWait("powershell -Command `"Expand-Archive -Path '" zipPath "' -DestinationPath '" tempExtractPath "' -Force`"", , "Hide")

				; Check if extraction was successful
				if !FileExist(tempExtractPath)
				{
					MsgBox("Failed to extract the update.")
					return
				}

				; Get the first subfolder in the extracted folder
				Loop Files, tempExtractPath "\*", "D"
				{
					extractedFolder := A_LoopFilePath
					break
				}

				; Check if a subfolder was found and move its contents recursively to the script folder
				if (extractedFolder)
				{
					MoveFilesRecursively(extractedFolder, scriptFolder)

					; Clean up the temporary extraction folder
					DirDelete(tempExtractPath, 1)
					MsgBox("Update installed. Restarting...")
					Reload()
				}
				else
				{
					MsgBox("Failed to find the extracted contents.")
					return
				}
			}
		}
		else
		{
			MsgBox("The update was canceled.")
			return
		}
	}
	else
	{
		MsgBox("You are running the latest version (" localVersion ").")
	}
}

MoveFilesRecursively(srcFolder, destFolder) {
	; Loop through all files and subfolders in the source folder
	Loop Files, srcFolder . "\*", "R"
	{
		; Get the relative path of the file/folder from the srcFolder
		relativePath := SubStr(A_LoopFilePath, (StrLen(srcFolder) + 2)<1 ? (StrLen(srcFolder) + 2)-1 : (StrLen(srcFolder) + 2))

		; Create the corresponding destination path
		destPath := destFolder . "\" . relativePath

		; If it's a directory, create it in the destination folder
		if (InStr(A_LoopFileAttrib, "D"))
		{
			; Ensure the directory exists, if not, create it
			DirCreate(destPath)
		}
		else
		{
			if ((relativePath = "ids.txt" && FileExist(destPath)) || (relativePath = "usernames.txt" && FileExist(destPath)) || (relativePath = "discord.txt" && FileExist(destPath))) {
                continue
            }
			if (relativePath = "usernames.txt" && FileExist(destPath)) {
                continue
            }
			if (relativePath = "usernames.txt" && FileExist(destPath)) {
                continue
            }
			; If it's a file, move it to the destination folder
			; Ensure the directory exists before moving the file
			DirCreate(SubStr(destPath, 1, InStr(destPath, "\", 0, -1) - 1))
			FileMove(A_LoopFilePath, destPath, 1)
		}
	}
}

HttpGet(url) {
	http := ComObject("WinHttp.WinHttpRequest.5.1")
	http.Open("GET", url, false)
	http.Send()
	return http.ResponseText
}

; Existing function to extract value from JSON
ExtractJSONValue(json, key1, key2:="", ext:="") {
	value := ""
	json := StrReplace(json, "`"", "")
	lines := StrSplit(json, ",")

	Loop lines.Length != 0 ? lines.Length : ""
	{
		if InStr(lines[A_Index], key1 ":") {
			; Take everything after the first colon as the value
			value := SubStr(lines[A_Index], (InStr(lines[A_Index], ":") + 1)<1 ? (InStr(lines[A_Index], ":") + 1)-1 : (InStr(lines[A_Index], ":") + 1))
			if (key2 != "")
			{
				if InStr(lines[A_Index+1], key2 ":") && InStr(lines[A_Index+1], ext)
					value := SubStr(lines[A_Index+1], (InStr(lines[A_Index+1], ":") + 1)<1 ? (InStr(lines[A_Index+1], ":") + 1)-1 : (InStr(lines[A_Index+1], ":") + 1))
			}
			break
		}
	}
	return Trim(value)
}

FixFormat(text) {
	; Replace carriage return and newline with an actual line break
	text := StrReplace(text, "\r\n", "`n")  ; Replace \r\n with actual newlines
	text := StrReplace(text, "\n", "`n")    ; Replace \n with newlines

	; Remove unnecessary backslashes before other characters like "player" and "None"
	text := StrReplace(text, "\player", "player")   ; Example: removing backslashes around words
	text := StrReplace(text, "\None", "None")       ; Remove backslash around "None"
	text := StrReplace(text, "\Welcome", "Welcome") ; Removing \ before "Welcome"

	; Escape commas by replacing them with %2C (URL encoding)
	text := StrReplace(text, ",", "")

	return text
}

VersionCompare(v1, v2) {
	; Remove non-numeric characters (like 'alpha', 'beta')
	cleanV1 := RegExReplace(v1, "[^\d.]")
	cleanV2 := RegExReplace(v2, "[^\d.]")

	v1Parts := StrSplit(cleanV1, ".")
	v2Parts := StrSplit(cleanV2, ".")

	Loop Max(v1Parts.Length != 0 ? v1Parts.Length : "", v2Parts.Length != 0 ? v2Parts.Length : "") {
		num1 := v1Parts[A_Index] ? v1Parts[A_Index] : 0
		num2 := v2Parts[A_Index] ? v2Parts[A_Index] : 0
		if (num1 > num2)
			return 1
		if (num1 < num2)
			return -1
	}

	; If versions are numerically equal, check if one is an alpha version
	isV1Alpha := InStr(v1, "alpha") || InStr(v1, "beta")
	isV2Alpha := InStr(v2, "alpha") || InStr(v2, "beta")

	if (isV1Alpha && !isV2Alpha)
		return -1 ; Non-alpha version is newer
	if (!isV1Alpha && isV2Alpha)
		return 1 ; Alpha version is older

	return 0 ; Versions are equal
}
