#define kIdentifier @"me.conorthedev.dismisser.prefs"
#define kSettingsChangedNotification (CFStringRef)@"me.conorthedev.dismisser.prefs/ReloadPrefs"
#define kSettingsPath @"/var/mobile/Library/Preferences/me.conorthedev.dismisser.prefs.plist"

/* Apps */
@interface UIAlertController (Private)
-(UIAlertAction *)_cancelAction;
-(void)_dismissAnimated:(BOOL)arg1 triggeringAction:(id)arg2;
@end

@interface UIAlertController (Dismisser)
-(void)dismisser_handleTap:(id)sender;
@end

@interface UIAlertAction (Private)
@property (nonatomic,copy) id handler;                                                                                                                         //@synthesize handler=_handler - In the implementation block
@end

/* Springboard */
@interface SBAlertItem : NSObject
-(void)dismiss;
@end

@interface _SBAlertController : UIAlertController
@property (assign, nonatomic) SBAlertItem *alertItem;
@end