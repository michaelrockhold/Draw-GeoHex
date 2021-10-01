//
//  XY.m
//  MapPolygonSample
//
//  Created by mac_tomita on 11/01/27.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//  GeoHex by @sa2da (http://geogames.net) is licensed under Creative Commons BY-SA 2.1 Japan License. 

#import "XY.h"


@implementation XY

- (instancetype)initWithX:(double)x y:(double)y {
    self = [super init];
    _x = x;
    _y = y;
    return self;
}

@end
