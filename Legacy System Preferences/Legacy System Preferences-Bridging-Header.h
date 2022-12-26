//
//  Legacy System Preferences-Bridging-Header.h
//  Legacy System Preferences
//
//  Created by BitesPotatoBacks on 12/23/22.
//

#ifndef Legacy_System_Preferences_Bridging_Header_h
#define Legacy_System_Preferences_Bridging_Header_h

#import <Foundation/Foundation.h>
#import <PreferencePanes/PreferencePanes.h>

@interface PaneAccessLayer : NSObject

@property (nonatomic,strong) NSView* prefView;

- (void)loadPreference:(NSString*)path;
- (BOOL)applyViewFromPreference;
- (void)attempClosePreference;
- (void)shouldClosePreference:(NSNotification *)notification;
- (void)resetProperties;

@end

#endif /* Legacy_System_Preferences_Bridging_Header_h */
