/* Preferences */
#define kIdentifier @"me.conorthedev.dismisser.prefs"
#define kSettingsChangedNotification (CFStringRef)@"me.conorthedev.dismisser.prefs/ReloadPrefs"
#define kSettingsPath @"/var/mobile/Library/Preferences/me.conorthedev.dismisser.prefs.plist"

/* Alerts */
@interface UIAlertController (Private)
-(void)_dismissWithAction:(UIAlertAction *)arg1;
@end

@interface UIAlertController (Dismisser)
@property (nonatomic, strong) UIAlertAction *dismisserCancelAction;
-(void)dismisser_handleTap;
@end

/* Zebra Fix */
@interface ZBSourceListTableViewController : UITableViewController
@end
