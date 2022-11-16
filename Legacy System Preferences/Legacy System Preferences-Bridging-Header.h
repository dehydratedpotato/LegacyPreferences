
#import <Foundation/Foundation.h>
#import <PreferencePanes/PreferencePanes.h>
#import <IOKit/ps/IOPowerSources.h>

@interface PaneManager : NSObject

- (void)loadPreference:(NSString*)path;
- (BOOL)applyViewFromPreference;
- (void)attempClosePreference;
- (void)shouldClosePreference:(NSNotification *)notification;
- (void)resetProperties;

@end
//
//@interface NiblessViewController : NSViewController
//@end
