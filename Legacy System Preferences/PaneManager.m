//
//  PaneManager.m
//  Legacy System Preferences
//
//  Created by Taevon Turner on 11/11/22.
//

#import "Legacy System Preferences-Bridging-Header.h"

@interface PaneManager ()

@property (strong) NSBundle* prefBundle;
@property (strong) Class prefPaneClass;
@property (strong) NSPreferencePane* prefPaneObject;
@property (strong) NSView* prefView;
@end

@implementation PaneManager

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

        [[[[NSApplication sharedApplication] windows] objectAtIndex:0] setContentView:prefView];

        NSRect rect = [[[[NSApplication sharedApplication] windows] objectAtIndex:0] frame];
        rect.origin.y += rect.size.height;
        rect.origin.y -= [prefView frame].size.height;
        rect.size = [prefView frame].size;
        
        [[[[NSApplication sharedApplication] windows] objectAtIndex:0] setFrame:rect display:true animate:true];
        
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
        [[[[NSApplication sharedApplication] windows] objectAtIndex:0] setContentView:nil];
        [prefPaneObject didUnselect];
        NSLog(@"Closed pane successfully");
        [self resetProperties];
    }
}

- (void)shouldClosePreference:(NSNotification *)notification {
    [prefPaneObject willUnselect];
    [[[[NSApplication sharedApplication] windows] objectAtIndex:0] setContentView:nil];
    [prefPaneObject didUnselect];
    NSLog(@"Closed pane successfully");
    [self resetProperties];
}

- (void)resetProperties {
    prefBundle     = NULL;
    prefPaneClass  = NULL;
    prefPaneObject = NULL;
    prefView       = [[NSView alloc] init];
}
@end

//@implementation NiblessViewController
//
//- (void)loadView {
//    NSView* v = [[NSView alloc] init];
//    v.frame = NSMakeRect(0, 0, 670, 0);
//    self.view = v;
//}
//
//@end
