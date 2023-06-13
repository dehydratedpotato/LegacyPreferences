//
//  AppearancePane.h
//  AppearancePane
//
//  Created by dehydratedpotato on 6/12/23.
//

#import <Foundation/Foundation.h>

//! Project version number for Appearance.
FOUNDATION_EXPORT double AppearancePaneVersionNumber;

//! Project version string for Appearance.
FOUNDATION_EXPORT const unsigned char AppearancePaneVersionString[];

typedef NS_ENUM(NSInteger, AppearanceType) {
    AppearanceTypeLight = 0,
    AppearanceTypeDark = 1,
};

//typedef NS_ENUM(NSInteger, AccentColorType) {
//    AccentColorTypeMulticolor = -2,
//    AccentColorTypeGraphite = -1,
//    AccentColorTypeRed = 0,
//    AccentColorTypeOrange = 1,
//    AccentColorTypeYellow = 2,
//    AccentColorTypeGreen = 3,
//    AccentColorTypeBlue = 4,
//    AccentColorTypePurple = 5,
//    AccentColorTypePink = 6,
//};

/* generic */
void SLSSetAppearanceThemeLegacy(AppearanceType);
AppearanceType SLSGetAppearanceThemeLegacy();
/* auto switch
 */
void SLSSetAppearanceThemeSwitchesAutomatically(uint32_t);
uint64_t SLSGetAppearanceThemeSwitchesAutomatically();

/* accent */
void NSColorSetUserAccentColor(int);
int NSColorGetUserAccentColor();

/* highlight */
void NSColorSetUserHighlightColor(int);
int NSColorGetUserHighlightColor();
