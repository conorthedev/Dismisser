#import "Dismisser.h"

NSDictionary *dismisserPrefs;
BOOL dismisserEnabled;
BOOL dismisserRemoveCancel;

%group Alerts
%hook UIAlertController
%property (nonatomic, strong) UIAlertAction *dismisserCancelAction;

-(void)addAction:(UIAlertAction*)arg1 {
	if(!dismisserEnabled || self.preferredStyle != 1) {
		%orig;
		return;
	} 
	
	if(arg1.style == UIAlertActionStyleCancel) {
		self.dismisserCancelAction = arg1;
		if(!dismisserRemoveCancel) {
			%orig;
		}
	} else {
		%orig;
	}
}

-(void)setPreferredAction:(UIAlertAction *)arg1 {
	if(!dismisserEnabled || self.preferredStyle != 1) {
		%orig;
		return;
	} 
	
	if(arg1.style != UIAlertActionStyleCancel) {
		%orig;
	}
}

-(void)viewDidAppear:(bool)animated {
	%orig;
	if(dismisserEnabled) {
		UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismisser_handleTap)];
		[self.view.superview addGestureRecognizer:tapGesture];
	}
}

%new
-(void)dismisser_handleTap {
	[self _dismissWithAction:self.dismisserCancelAction];	
}
%end
%end

%group ZebraFix
%hook ZBSourceListTableViewController
- (void)textDidChange:(NSNotification *)notification {
	if(!dismisserEnabled || !dismisserRemoveCancel) {
		%orig;
		return;
	}

    UIAlertController *alertController = (UIAlertController *)self.presentedViewController;
    UITextField *textField = alertController.textFields.firstObject;
    UIAlertAction *add = alertController.actions[0];

    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"(http(s)?://){2}" options:NSRegularExpressionCaseInsensitive
    error:nil];
    NSTextCheckingResult *match = [regex firstMatchInString:textField.text options:0 range:NSMakeRange(0, textField.text.length)];
    if (match) {
        if ([textField.text hasPrefix:@"https"]) {
            textField.text = [textField.text substringFromIndex:8];
        } else {
            textField.text = [textField.text substringFromIndex:7];
        }
    }
    
    regex = [NSRegularExpression regularExpressionWithPattern:@"(http(s)?://){1}((\\w)|([0-9])|([-|_]))+(\\.|/)+((\\w)|([0-9])|([-|_]))+" options:NSRegularExpressionCaseInsensitive
    error:nil];
    NSTextCheckingResult *isURL = [regex firstMatchInString:textField.text options:0 range:NSMakeRange(0, textField.text.length)];
    
    [add setEnabled:isURL];
}
%end
%end

static void DismisserReloadPrefs() {
	CFPreferencesAppSynchronize((CFStringRef)kIdentifier);

    if ([NSHomeDirectory()isEqualToString:@"/var/mobile"]) {
        CFArrayRef keyList = CFPreferencesCopyKeyList((CFStringRef)kIdentifier, kCFPreferencesCurrentUser, kCFPreferencesAnyHost);

        if (keyList) {
            dismisserPrefs = (NSDictionary *)CFBridgingRelease(CFPreferencesCopyMultiple(keyList, (CFStringRef)kIdentifier, kCFPreferencesCurrentUser, kCFPreferencesAnyHost));

            if (!dismisserPrefs) {
                dismisserPrefs = [NSDictionary new];
            }
            CFRelease(keyList);
        }
    } else {
        dismisserPrefs = [NSDictionary dictionaryWithContentsOfFile:kSettingsPath];
    }
	
	dismisserEnabled = [dismisserPrefs objectForKey:@"enabled"] ? [[dismisserPrefs valueForKey:@"enabled"] boolValue] : YES;
	dismisserRemoveCancel = [dismisserPrefs objectForKey:@"removeCancel"] ? [[dismisserPrefs valueForKey:@"removeCancel"] boolValue] : YES;
}

%ctor {
	DismisserReloadPrefs();
	CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(), NULL, (CFNotificationCallback)DismisserReloadPrefs, kSettingsChangedNotification, NULL, CFNotificationSuspensionBehaviorCoalesce);

	%init(Alerts);
	%init(ZebraFix);
}
