//
//  MapNavigator.m
//  PPAutoInsurance
//
//  Created by Lilong on 16/4/26.
//  Copyright © 2016年 第七代目. All rights reserved.
//

#import "MapNavigator.h"
#include <math.h>
#define URL_SCHEME @"lgwmapnav://"

#define APP_NAME @"lgwmapnav"

//iOS版本判断
#define iOS7 ([[[UIDevice currentDevice]systemVersion]floatValue] >= 7.0)

#define iOS8 ([[[UIDevice currentDevice]systemVersion]floatValue] >= 8.0)
@interface MapNavigator ()<UIActionSheetDelegate>
@property (nonatomic, assign) CLLocationCoordinate2D toLocation;
@end

@implementation MapNavigator

- (instancetype)init{
    self = [super init];
    if (self) {
    }
    return  self;
}

+ (void)mapNavigatorWithEndLocation:(CLLocationCoordinate2D )endLocation andViewController:(UIViewController *)superVC{
    // 坐标转换 （百度坐标系 (BD-09) 转 火星坐标系 (GCJ-02)）
    //算法一 简单算法
//    endLocation.latitude = endLocation.latitude - 0.0060;
//    endLocation.longitude = endLocation.longitude - 0.0065;
    //算法二
    const double x_pi = 3.14159265358979324 * 3000.0 / 180.0;
    double x = endLocation.longitude - 0.0065, y = endLocation.latitude - 0.006;
    double z = sqrt(x * x + y * y) - 0.00002 * sin(y * x_pi);
    double theta = atan2(y, x) - 0.000003 * cos(x * x_pi);
    endLocation.longitude = z * cos(theta);
    endLocation.latitude = z * sin(theta);
    
    NSString *urlScheme = URL_SCHEME;
    NSString *appName = APP_NAME;
    CLLocationCoordinate2D coordinate = endLocation;
    
    if (iOS8) {  // ios8以上系统
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"选择地图" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
        
        if ( [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"baidumap://"]])
        {
            UIAlertAction *action = [UIAlertAction actionWithTitle:@"百度地图" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                
                NSString *urlString = [[NSString stringWithFormat:@"baidumap://map/direction?origin={{我的位置}}&destination=latlng:%f,%f|name=目的地&mode=driving&coord_type=gcj02",coordinate.latitude, coordinate.longitude] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlString]];
            }];
            [alert addAction:action];
        }
        
        if ( [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"iosamap://"]])
        {
            UIAlertAction *action = [UIAlertAction actionWithTitle:@"高德地图" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                
                NSString *urlString = [[NSString stringWithFormat:@"iosamap://navi?sourceApplication=%@&backScheme=%@&lat=%f&lon=%f&dev=0&style=2",appName,urlScheme,coordinate.latitude, coordinate.longitude] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlString]];
                
            }];
            [alert addAction:action];
        }
        
        //这个判断其实是不需要的(苹果地图系统有自带)
        if ( [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"http://maps.apple.com/"]])
        {
            UIAlertAction *action = [UIAlertAction actionWithTitle:@"苹果地图" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                
                MKMapItem *currentLocation = [MKMapItem mapItemForCurrentLocation];
                MKMapItem *toLocation = [[MKMapItem alloc] initWithPlacemark:[[MKPlacemark alloc] initWithCoordinate:coordinate addressDictionary:nil]];
                
                [MKMapItem openMapsWithItems:@[currentLocation, toLocation]
                               launchOptions:@{MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving,MKLaunchOptionsShowsTrafficKey: [NSNumber numberWithBool:YES]}];
            }];
            
            [alert addAction:action];
        }
        
        if ( [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"comgooglemaps://"]])
        {
            UIAlertAction *action = [UIAlertAction actionWithTitle:@"谷歌地图" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                
                NSString *urlString = [[NSString stringWithFormat:@"comgooglemaps://?x-source=%@&x-success=%@&saddr=&daddr=%f,%f&directionsmode=driving",appName,urlScheme,coordinate.latitude, coordinate.longitude] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlString]];
            }];
            [alert addAction:action];
        }
        
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
        [alert addAction:action];
        
        [superVC presentViewController:alert animated:YES completion:^{
            
        }];

    }else{  //ios8 之下的系统
        MapNavigator *navigator = [[MapNavigator alloc] init];
        navigator.toLocation = endLocation;

        UIActionSheet *alert = [[UIActionSheet alloc] initWithTitle:@"选择地图"  delegate:navigator
                                                  cancelButtonTitle:@"取消"
                                             destructiveButtonTitle:nil 
                                                  otherButtonTitles:nil];
        if ( [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"baidumap://"]])
        {
            [alert addButtonWithTitle:@"百度地图"];
        }
        if ( [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"iosamap://"]])
        {
            [alert addButtonWithTitle:@"高德地图"];
        }
        if ( [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"http://maps.apple.com/"]])
        {
            [alert addButtonWithTitle:@"苹果地图"];
        }
        if ( [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"comgooglemaps://"]])
        {
            [alert addButtonWithTitle:@"谷歌地图"];
        }

        [superVC.view addSubview:navigator];
        [alert showFromRect:superVC.view.bounds inView:superVC.view animated:YES];
    }
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    NSString *urlScheme = URL_SCHEME;
    NSString *appName = APP_NAME;
    CLLocationCoordinate2D coordinate = self.toLocation;

    NSString *buttonTitleStr = [actionSheet buttonTitleAtIndex:buttonIndex];
    
    if (buttonIndex == actionSheet.cancelButtonIndex) {
        return;
    }
    if ([buttonTitleStr isEqualToString:@"苹果地图"]) { // 苹果地图
        MKMapItem *currentLocation = [MKMapItem mapItemForCurrentLocation];
        MKMapItem *toLocation = [[MKMapItem alloc] initWithPlacemark:[[MKPlacemark alloc] initWithCoordinate:coordinate addressDictionary:nil]];
        [MKMapItem openMapsWithItems:@[currentLocation, toLocation]
                       launchOptions:@{MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving,MKLaunchOptionsShowsTrafficKey: [NSNumber numberWithBool:YES]}];
    }else if ([buttonTitleStr isEqualToString:@"百度地图"]){ // 百度地图
        NSString *urlString = [[NSString stringWithFormat:@"baidumap://map/direction?origin={{我的位置}}&destination=latlng:%f,%f|name=目的地&mode=driving&coord_type=gcj02",coordinate.latitude, coordinate.longitude] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlString]];
    }else if ([buttonTitleStr isEqualToString:@"高德地图"]){ // 高德地图
        NSString *urlString = [[NSString stringWithFormat:@"iosamap://navi?sourceApplication=%@&backScheme=%@&lat=%f&lon=%f&dev=0&style=2",appName,urlScheme,coordinate.latitude, coordinate.longitude] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlString]];
    }else if ([buttonTitleStr isEqualToString:@"谷歌地图"]){ //谷歌地图
        NSString *urlString = [[NSString stringWithFormat:@"comgooglemaps://?x-source=%@&x-success=%@&saddr=&daddr=%f,%f&directionsmode=driving",appName,urlScheme,coordinate.latitude, coordinate.longitude] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlString]];
    }
    [self removeFromSuperview];
}
@end
