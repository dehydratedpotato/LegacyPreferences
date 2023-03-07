//
//  PaneAccessLayer.m
//  Legacy System Preferences
//
//  Created by BitesPotatoBacks on 12/23/22.
//

#import "Legacy System Preferences-Bridging-Header.h"

@interface PaneAccessLayer ()

@property (nonatomic,strong) NSBundle* prefBundle;
@property (nonatomic,strong) Class prefPaneClass;
@property (nonatomic,strong) NSPreferencePane* prefPaneObject;
@end

@implementation PaneAccessLayer

@synthesize prefBundle;
@synthesize prefPaneClass;
@synthesize prefPaneObject;
@synthesize prefView;

- (void)loadPreference:(NSString*)path{
    prefBundle     = [NSBundle bundleWithPath:path];
    prefPaneClass  = [prefBundle principalClass];
    prefPaneObject = [[prefPaneClass alloc] initWithBundle:prefBundle];
}

- (BOOL)applyViewFromPreference {
    if ( [prefPaneObject loadMainView] ) {
        [prefPaneObject willSelect];
        
        prefView = [prefPaneObject mainView];
        
        [prefPaneObject didSelect];
        
        return YES;
    } else {
        NSLog(@"Failure to apply pref pane view");
        [self resetProperties];
        
        return NO;
    }
}

- (void)attempClosePreference {
    NSPreferencePaneUnselectReply reply = [prefPaneObject shouldUnselect];
    
    if (reply == NSUnselectLater) {
        NSLog(@"Must wait for pane to close");
        [[NSNotificationCenter defaultCenter] addObserver:self
                            selector:@selector(shouldClosePreference:)
                            name:NSPreferencePaneDoUnselectNotification object:nil];
    } else if (reply == NSUnselectNow) {
        [prefPaneObject willUnselect];
        [prefPaneObject didUnselect];
        
        NSLog(@"Closed pane successfully");
        
        [self resetProperties];
    } else {
        NSLog(@"Unknown closing reply for pane");
    }
}

- (void)shouldClosePreference:(NSNotification *)notification {
    [prefPaneObject willUnselect];
    [prefPaneObject didUnselect];
    
    NSLog(@"Closed pane successfully");
    
    [self resetProperties];
}

- (void)resetProperties {
    prefBundle     = NULL;
    prefPaneClass  = NULL;
    prefPaneObject = NULL;
    prefView       = [NSView alloc];
}
@end
