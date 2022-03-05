#import "AppDelegate.h"
#import "GeneratedPluginRegistrant.h"
@import GoogleMaps;

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application
    didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {

    [GMSServices provideAPIKey:@"AIzaSyDsOmLYe4ILzp4UxBER-CiX6I_nUHddvzI"];
    [GeneratedPluginRegistrant registerWithRegistry:self];
  // Override point for customization after application launch.
  return [super application:application didFinishLaunchingWithOptions:launchOptions];
}

@end
