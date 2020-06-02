#define kIdentifier @"me.conorthedev.dismisser.prefs"
#define kSettingsChangedNotification (CFStringRef)@"me.conorthedev.dismisser.prefs/ReloadPrefs"
#define kSettingsPath @"/var/mobile/Library/Preferences/me.conorthedev.dismisser.prefs.plist"

/* Apps */
@interface UIAlertController (Dismisser)
-(void)dismisser_handleTap:(id)sender;
@end

/* Springboard */
@interface SBAlertItem : NSObject
-(void)dismiss;
@end

@interface _SBAlertController : UIAlertController
@property (assign, nonatomic) SBAlertItem *alertItem;
@end