//
//  AppDelegate.m
//  AudioPlayerTest
//
//  Created by Eric McConkie on 4/13/13.
//  Copyright (c) 2013 Eric McConkie. All rights reserved.
//

#import "AppDelegate.h"

#import "EMAudioObject.h"

#import "EMAudioPlayerViewController.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    self.viewController = [[EMAudioPlayerViewController alloc] initWithNibName:@"EMAudioPlayerViewController" bundle:nil];
    

    NSString *path = [[NSBundle mainBundle] pathForResource:@"sample" ofType:@"m4a"];
    NSURL *url = [NSURL fileURLWithPath:path];
//    NSURL *url = [NSURL URLWithString:@"http://path.to.a.remote.file"];
    
    NSString *pathArt = @"http://www.glidemagazine.com/hiddentrack/wp-content/uploads/2013/04/Beastie_Boys_1.jpg";
    NSURL *urlArt = [NSURL URLWithString:pathArt];
    
    EMAudioObject *audioObject = [[EMAudioObject alloc] init];
    [audioObject setAlbum:@"Ill Communication"];
    [audioObject setTitle:@"Root Down"];
    [audioObject setArtist:@"Beastie Boys"];
    [audioObject setUrlToFile:url];
    [audioObject setUrlToAlbumArt:urlArt];
    
    [self.viewController setAudioObject:audioObject];

    self.window.rootViewController = self.viewController;
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
