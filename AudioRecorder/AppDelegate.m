//
//  AppDelegate.m
//  AudioRecorder
//
//  Created by hdk on 2014. 6. 30..
//  Copyright (c) 2014년 Kevin. All rights reserved.
//

#import "AppDelegate.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    /* 책과는 다르게 MainWindow.xib를 만들지 않고 코딩으로 뷰를 붙여줌 */
    
    
    // 윈도우를 하나 만들어줌
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    // Override point for customization after application launch.
    
    // 첫 화면이 될 rootViewController, xib로 초기화해줌
    self.rootViewController = [[RootViewController alloc]initWithNibName:@"RootViewController" bundle:nil];
    
    // 윈도우의 rootViewController프로퍼티에 첫 화면을 지정해줌.
    self.window.rootViewController = self.rootViewController;
    
    // 윈도우의 기본이 되는 배경 색임
    self.window.backgroundColor = [UIColor whiteColor];

    // 윈도우를 화면에 표시함
    [self.window makeKeyAndVisible];
    
    // 상단 StatusBar 숨김
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:YES];
    
    [self copyOfDataBaseIfNeeded]; // 데이터 베이스르 파일을 복사한다.
    
    // 이건 그냥 YES해줘야함
    return YES;
}

- (BOOL)copyOfDataBaseIfNeeded
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentationDirectory, NSUserDomainMask, YES); // Documents 폴더 위치를 구한다.
    NSString *documentDirectory = paths[0];
    
    NSString *myPath = [documentDirectory stringByAppendingPathComponent:@"RecordDB.sqlite"];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL exist = [fileManager fileExistsAtPath:myPath]; // 파일이 존재하는지 체크
    
    if (exist) {
        NSLog(@"DB가 존재합니다.");
        return YES;
    }
    
    NSString *defaultDBPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"RecordDB.sqlite"];
    return [fileManager copyItemAtPath:defaultDBPath toPath:myPath error:nil];
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
