# tccplus
tccutil with extended capabilities allowing you to grant/remove accessibility permissions to any app.

I never recommend manually modifying any system database because if a mistake is made you risk boot-looping your computer. This is why this tool is using the undocumented TCC.framework to make changes just like macOS does internally. 

Requires SIP and AMFI to be disabled.

Currently can only add one or all (not recommended) services at a time. Using `reset All` is fine.

```
tccplus [add/reset] SERVICE [BUNDLE_ID]
Services: 
 - All 
 - Accessibility 
 - AddressBook 
 - AppleEvents 
 - Calendar 
 - Camera 
 - ContactsFull 
 - ContactsLimited 
 - DeveloperTool 
 - Facebook 
 - LinkedIn 
 - ListenEvent 
 - Liverpool 
 - Location 
 - MediaLibrary 
 - Microphone 
 - Motion 
 - Photos 
 - PhotosAdd 
 - PostEvent 
 - Reminders 
 - ScreenCapture 
 - ShareKit 
 - SinaWeibo 
 - Siri 
 - SpeechRecognition 
 - SystemPolicyAllFiles 
 - SystemPolicyDesktopFolder 
 - SystemPolicyDeveloperFiles 
 - SystemPolicyDocumentsFolder 
 - SystemPolicyDownloadsFolder 
 - SystemPolicyNetworkVolumes 
 - SystemPolicyRemovableVolumes 
 - SystemPolicySysAdminFiles 
 - TencentWeibo 
 - Twitter 
 - Ubiquity 
 - Willow
 ```
Usage Example:
Get application bundle ID:

`grep 'BundleIdent' -A 1 /Applications/<APPLICATION NAME>/Contents/Info.plist`

Pass result to `tccplus`
```bash
user@iMac ~ % grep 'BundleIdent' -A 1 /Applications/Discord.app/Contents/Info.plist
    <key>CFBundleIdentifier</key>
    <string>com.hnc.Discord</string>
user@iMacc ~ % grep 'BundleIdent' -A 1 /Applications/zoom.us.app/Contents/Info.plist
    <key>CFBundleIdentifier</key>
    <string>us.zoom.xos</string>
user@iMac ~ % ./tccplus add Microphone com.hnc.Discord
Successfully added Microphone approval status for com.hnc.Discord
```
