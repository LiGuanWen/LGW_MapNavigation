//
//  ViewController.m
//  LGW_MapNavigation
//
//  Created by Lilong on 16/4/26.
//  Copyright © 2016年 第七代目. All rights reserved.
//

#import "ViewController.h"
#import "MapNavigator.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}


- (IBAction)gotoXiaMenSomeWhere:(id)sender {
    CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(24.486370999999998,118.193896);
    [MapNavigator mapNavigatorWithEndLocation:coordinate andViewController:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
