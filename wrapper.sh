#!/bin/bash
ACTIONS=("add reset")
ALLOWEDSERVICES=("All  Accessibility  AddressBook  AppleEvents  Calendar  Camera  ContactsFull  ContactsLimited  DeveloperTool  Facebook  LinkedIn  ListenEvent  Liverpool  Location  MediaLibrary  Microphone  Motion  Photos  PhotosAdd  PostEvent  Reminders  ScreenCapture  ShareKit  SinaWeibo  Siri  SpeechRecognition  SystemPolicyAllFiles  SystemPolicyDesktopFolder  SystemPolicyDeveloperFiles  SystemPolicyDocumentsFolder  SystemPolicyDownloadsFolder  SystemPolicyNetworkVolumes  SystemPolicyRemovableVolumes  SystemPolicySysAdminFiles  TencentWeibo  Twitter  Ubiquity  Willow")

PLISTFILE=$1/Contents/Info.plist

if [ ! -f $PLISTFILE ]; then
    echo 'Application PList $PLISTFILE not found'
    exit 1
fi
if [[ ! " ${ACTIONS[@]} " =~ " $2 " ]]; then
    echo "Action ($2) not allowed"
    exit 2
fi
BUNDLE=`awk '/CFBundleIdentifier/{getline; print}' $PLISTFILE  | awk -F '[<>]' '/string/{print $3}'`


IFS=',' read -ra SERVICES <<< "$3"

echo "RUN THE FOLLOWING:"
for SERVICE in "${SERVICES[@]}"
do
    if [[ ! " ${ALLOWEDSERVICES[@]} " =~ " $SERVICE " ]]; then
       #echo "Service ($SERVICE) not allowed, skipping"
       continue
    fi
    echo tccplus $2 $SERVICE $BUNDLE
done
