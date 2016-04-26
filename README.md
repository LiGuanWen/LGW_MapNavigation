# LGW_MapNavigation
集成地图导航 可以调起百度 谷歌 高德（其他需要可以自己添加）app进行导航

使用时 将MapNavigator文件夹加到工程中
然后在LSApplicationQueriesSchemes 添加百度地图 高德地图 谷歌地图等的shcheme   baidumap iosamap comgooglemaps

调用时 直接
24.486370999999998,118.193896 修改为所需的地址的经纬度
    CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(24.486370999999998,118.193896);
    [MapNavigator mapNavigatorWithEndLocation:coordinate andViewController:self];
