//
//  Loc.h
//  MapPolygonSample
//
//  Created by mac_tomita on 11/01/27.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//  GeoHex by @sa2da (http://geogames.net) is licensed under Creative Commons BY-SA 2.1 Japan License. 

#import <Foundation/Foundation.h>


@interface Loc : NSObject

@property (assign) double lat,lon;

-(instancetype)initWithLat:(double)latitude lon:(double)longitude;

+(Loc*) getLoc:(double)lat :(double)lon;
@end
