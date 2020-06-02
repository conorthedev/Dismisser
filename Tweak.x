#import "Dismisser.h"

NSDictionary *dismisser_prefs;
BOOL dismisser_enabled;
BOOL dismisser_removeCancelButtons;

%hook _SBAlertController
-(void)viewDidAppear:(bool)animated {
	%orig;
	if(dismisser_enabled) {
		UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismisser_handleTap:)];
		[self.view.superview addGestureRecognizer:tapGesture];
	}
}

%new
-(void)dismisser_handleTap:(id)sender {
	[self.alertItem dismiss];
}
%end

%hook UIAlertController
-(void)addAction:(UIAlertAction*)arg1 {
	if(!dismisser_enabled || self.preferredStyle != 1) {
		%orig;
		return;
	} 
	
	if(dismisser_removeCancelButtons) {
		if(arg1.style != 1 && ![arg1.title isEqualToString:@"Close"] && ![arg1.title isEqualToString:@"Cancel"]) {
			%orig;
		}
	} else {
		%orig;
	}
}

-(void)setPreferredAction:(UIAlertAction *)arg1 {
	if(!dismisser_enabled || self.preferredStyle != 1) {
		%orig;
		return;
	}
	
	if(dismisser_removeCancelButtons) {
		if(arg1.style != 1 && ![arg1.title isEqualToString:@"Close"] && ![arg1.title isEqualToString:@"Cancel"]) {
			%orig;
		}
	} else {
		%orig;
	}
}

-(void)viewDidAppear:(bool)animated {
	%orig;
	if(dismisser_enabled) {
		UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismisser_handleUITap:)];
		[self.view.superview addGestureRecognizer:tapGesture];
	}
}

%new
-(void)dismisser_handleUITap:(id)sender {
	[self dismissViewControllerAnimated:YES completion:nil];
}
%end

static void DismisserReloadPrefs() {
	CFPreferencesAppSynchronize((CFStringRef)kIdentifier);

    if ([NSHomeDirectory()isEqualToString:@"/var/mobile"]) {
        CFArrayRef keyList = CFPreferencesCopyKeyList((CFStringRef)kIdentifier, kCFPreferencesCurrentUser, kCFPreferencesAnyHost);

        if (keyList) {
            dismisser_prefs = (NSDictionary *)CFBridgingRelease(CFPreferencesCopyMultiple(keyList, (CFStringRef)kIdentifier, kCFPreferencesCurrentUser, kCFPreferencesAnyHost));

            if (!dismisser_prefs) {
                dismisser_prefs = [NSDictionary new];
            }
            CFRelease(keyList);
        }
    } else {
        dismisser_prefs = [NSDictionary dictionaryWithContentsOfFile:kSettingsPath];
    }
	
	dismisser_enabled = [dismisser_prefs objectForKey:@"enabled"] ? [[dismisser_prefs valueForKey:@"enabled"] boolValue] : YES;
	dismisser_removeCancelButtons = [dismisser_prefs objectForKey:@"removeCancel"] ? [[dismisser_prefs valueForKey:@"removeCancel"] boolValue] : YES;
}

%ctor {
	DismisserReloadPrefs();
	CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(), NULL, (CFNotificationCallback)DismisserReloadPrefs, kSettingsChangedNotification, NULL, CFNotificationSuspensionBehaviorCoalesce);
}