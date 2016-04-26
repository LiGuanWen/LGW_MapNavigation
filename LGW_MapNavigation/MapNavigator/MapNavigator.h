//
//  MapNavigator.h
//  PPAutoInsurance
//
//  Created by Lilong on 16/4/26.
//  Copyright © 2016年 第七代目. All rights reserved.
//
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
#import <Foundation/Foundation.h>

@interface MapNavigator : UIView


+ (void)mapNavigatorWithEndLocation:(CLLocationCoordinate2D )endLocation andViewController:(UIViewController *)superVC;

@end
