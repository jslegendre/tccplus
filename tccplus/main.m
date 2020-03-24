//
//  main.m
//  tccplus
//
//  Created by j on 3/23/20.
//  Copyright © 2020 Jeremy Legendre. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <dlfcn.h>

int (*_TCCAccessSetForBundle)(CFStringRef, CFBundleRef);
int (*_TCCAccessResetForBundle)(CFStringRef, CFBundleRef);

void print_help() {
    printf("tccplus [add/reset] SERVICE [BUNDLE_ID]\n"
                    "Services: \n"
                    " - All \n"
                    " - Accessibility \n"
                    " - AddressBook \n"
                    " - AppleEvents \n"
                    " - Calendar \n"
                    " - Camera \n"
                    " - ContactsFull \n"
                    " - ContactsLimited \n"
                    " - DeveloperTool \n"
                    " - Facebook \n"
                    " - LinkedIn \n"
                    " - ListenEvent \n"
                    " - Liverpool \n"
                    " - Location \n"
                    " - MediaLibrary \n"
                    " - Microphone \n"
                    " - Motion \n"
                    " - Photos \n"
                    " - PhotosAdd \n"
                    " - PostEvent \n"
                    " - Reminders \n"
                    " - ScreenCapture \n"
                    " - ShareKit \n"
                    " - SinaWeibo \n"
                    " - Siri \n"
                    " - SpeechRecognition \n"
                    " - SystemPolicyAllFiles \n"
                    " - SystemPolicyDesktopFolder \n"
                    " - SystemPolicyDeveloperFiles \n"
                    " - SystemPolicyDocumentsFolder \n"
                    " - SystemPolicyDownloadsFolder \n"
                    " - SystemPolicyNetworkVolumes \n"
                    " - SystemPolicyRemovableVolumes \n"
                    " - SystemPolicySysAdminFiles \n"
                    " - TencentWeibo \n"
                    " - Twitter \n"
                    " - Ubiquity \n"
                    " - Willow \n");
}


int main(int argc, const char * argv[]) {
    @autoreleasepool {
        if(argc < 4 ||
           (strcmp(argv[1], "add") != 0 && strcmp(argv[1], "reset") != 0)) {
            print_help();
            exit(0);
        }
        
        _TCCAccessSetForBundle = 0;
        _TCCAccessResetForBundle = 0;
        
        void *tccHandle = dlopen("/System/Library/PrivateFrameworks/TCC.framework/Versions/A/TCC", RTLD_LAZY);
        if(tccHandle == NULL) {
            printf("Could not open TCC framework\n");
            exit(0);
        }
        
        _TCCAccessSetForBundle = dlsym(tccHandle, "TCCAccessSetForBundle");
        _TCCAccessResetForBundle = dlsym(tccHandle, "TCCAccessResetForBundle");
        dlclose(tccHandle);
        
        if(_TCCAccessSetForBundle == 0) {
            printf("Could not find symbol for TCCAccessSetForBundle\n");
            exit(0);
        }
        
        if(_TCCAccessResetForBundle == 0) {
            printf("Could not find symbol for TCCAccessResetForBundle\n");
            exit(0);
        }
        
        CFStringRef bundleId = CFStringCreateWithCString(NULL, argv[3], kCFStringEncodingMacRoman);
        CFArrayRef urls = LSCopyApplicationURLsForBundleIdentifier(bundleId, NULL);
        CFRelease(bundleId);
        if(urls == NULL) {
            printf("Could not locate bundle for bundle id %s\n", argv[3]);
            exit(0);
        }
        
        CFURLRef bundleURL = CFArrayGetValueAtIndex(urls, 0);
        CFBundleRef bundle = CFBundleCreate(kCFAllocatorDefault, bundleURL);
        CFRelease(bundleURL);
        CFRelease(urls);
        if(bundle == NULL) {
            printf("Could not create CFBundleRef\n");
            exit(0);
        }
        
        CFStringRef serviceFormat = CFSTR("kTCCService%s");
        CFStringRef service = CFStringCreateWithFormat(NULL, NULL, serviceFormat, argv[2]);
        CFRelease(serviceFormat);
        
        if(strcmp(argv[1], "add") == 0) {
            if(_TCCAccessSetForBundle(service, bundle) == 0) {
                printf("Could not add %s approval status for %s\n", argv[2], argv[3]);
            } else {
                /* Tack on accessibility service as it seems to be a prerequisite */
                _TCCAccessSetForBundle(CFSTR("kTCCServiceAccessibility"), bundle);
                printf("Successfully added %s approval status for %s\n", argv[2], argv[3]);
            }
        }
        
        if(strcmp(argv[1], "reset") == 0) {
            if(_TCCAccessResetForBundle(service, bundle) == 0) {
                printf("Could not reset %s approval status for %s\n", argv[2], argv[3]);
            } else {
                printf("Successfully reset %s approval status for %s\n", argv[2], argv[3]);
            }
        }
        
        CFRelease(service);
        CFRelease(bundle);
    }
    return 0;
}
