//
//  Zone.h
//  MapPolygonSample
//
//  Created by mac_tomita on 11/01/27.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//  GeoHex by @sa2da (http://geogames.net) is licensed under Creative Commons BY-SA 2.1 Japan License. 

#import <Foundation/Foundation.h>


@interface Zone : NSObject 

@property (assign) double lat,lon;
@property (assign) long x,y;
@property(copy,nonatomic) NSString *code;
@property (assign) int level;

-(instancetype)initWitLat:(double)lat
                      lon:(double)lon
                        x:(long)x
                        y:(long)y
                    level:(int)level
                     code:(NSString*)code;

-(NSArray*) getHexCoords;

@end
