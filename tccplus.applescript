# Applescript Initially created by Will http://junebeetle.github.io/
# Modified by Ben https://github.com/plessbd/
# Uses tccplus https://github.com/jslegendre/tccplus/
to getHomePath()
	do shell script "echo ~"
end getHomePath

set strAppPath to POSIX file "/Applications"

set toolPageURL to "https://github.com/jslegendre/tccplus/"
set toolDownloadURL to "https://github.com/jslegendre/tccplus/releases/download/1.0/tccplus.zip"
set supportPath to getHomePath() & "/Library/Application Support/tccplus Wrapper/"
set toolPath to supportPath & "tccplus"

try
	do shell script quoted form of toolPath
on error
	display dialog "The `tccplus` tool by Jeremy Legendre doesn't seem to be installed." buttons {"Quit", "Visit GitHub", "Download Automatically"} cancel button 1 default button 3
	
	if button returned of result is "Visit GitHub" then
		open location toolPageURL
		return
	end if
	
	do shell script "set -e
mkdir -p " & quoted form of supportPath & "
cd " & quoted form of supportPath & "
curl -fLO " & quoted form of toolDownloadURL & "
unzip tccplus.zip
rm -r __MACOSX
rm tccplus.zip"
	
	display dialog "The tool was downloaded to the following location." default answer toolPath buttons {"OK"} default button 1
end try

set serviceNames to {}
do shell script quoted form of toolPath
repeat with outputLine in paragraphs of result
	if outputLine contains " - " then
		set serviceNames to serviceNames & (characters 4 thru end of outputLine as string)
	end if
end repeat

choose file of type "app" with prompt "Choose an application to add privileges." default location strAppPath
set appPath to POSIX path of result

choose from list serviceNames with prompt "Choose privileges to add." with multiple selections allowed
set services to result

do shell script "defaults read " & quoted form of (appPath & "/Contents/Info.plist") & " CFBundleIdentifier"
set appID to result

set command to ""

repeat with service in services
	set command to command & quoted form of toolPath & " add " & service & " " & appID & ";"
end repeat

# set command to quoted form of toolPath & " add " & service & " " & appID
display dialog "The following commands will be run. Is that okay?" buttons {"Cancel", "Run"} default answer command cancel button 1 default button 2

tell application "Terminal"
	do script command
	activate
end tell
