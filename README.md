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
