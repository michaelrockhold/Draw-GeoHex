//
//  Loc.m
//  MapPolygonSample
//
//  Created by mac_tomita on 11/01/27.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//  GeoHex by @sa2da (http://geogames.net) is licensed under Creative Commons BY-SA 2.1 Japan License. 

#import "Loc.h"


@implementation Loc

-(instancetype)initWithLat:(double)latitude lon:(double)longitude {
    self = [super init];
    _lat = latitude;
    _lon = longitude;
    return self;
}

+(Loc*) getLoc:(double)lat :(double)lon {
    return [[Loc alloc] initWithLat:lat lon:lon];
}

@end
