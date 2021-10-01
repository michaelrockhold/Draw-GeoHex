//
//  ViewController.m
//  GeoHexDemo
//
//  Created by Michael Rockhold on 10/1/21.
//

#import "ViewController.h"
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
#import "GeoHex/GeoHex.h"

@interface ViewController () <MKMapViewDelegate>

@property (assign) IBOutlet MKMapView* mapView;
@property (assign) IBOutlet UISegmentedControl *modeControl;
@property (assign) IBOutlet UISegmentedControl *mapControl;
@property (assign) IBOutlet UILabel *levelLabel;
@property (assign) IBOutlet UIButton *plusButton;
@property (assign) IBOutlet UIButton *minusButton;
@property (assign) IBOutlet UIButton *resetButton;
@end

UIPanGestureRecognizer *panGesture;
int level;
NSMutableSet *hexCodeSet;
NSMutableArray *polyArray;

@implementation ViewController

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.mapView.delegate = self;
    MKCoordinateRegion region = self.mapView.region;
    region.span.latitudeDelta = 0.5; // 地図の表示倍率
    region.span.longitudeDelta = 0.5;
    region.center = CLLocationCoordinate2DMake(35.658517, 139.701334); //near Shibuya,Tokyo
    [self.mapView setRegion:region animated:YES];
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapGesture:)];
    [self.mapView addGestureRecognizer:tapGesture];

    panGesture = [[UIPanGestureRecognizer alloc]
                  initWithTarget:self
                  action:@selector(handlePanGesture:)];
    level = 1; //[[self.levelLabel text] intValue];
    hexCodeSet = [NSMutableSet set];
    polyArray = [[NSMutableArray alloc] init];
}


- (void) handlePanGesture:(UIPanGestureRecognizer*)sender {
    CGPoint location = [sender locationInView:self.mapView];
    CLLocationCoordinate2D mapPoint = [self.mapView convertPoint:location toCoordinateFromView:self.mapView];
    [self drawHex:mapPoint.latitude lon:mapPoint.longitude level:level];
}


- (void) handleTapGesture:(UITapGestureRecognizer*)sender {
    CGPoint location = [sender locationInView:self.mapView];
    //NSLog(@"tap: x:%f, y:%f", location.x, location.y );
    CLLocationCoordinate2D mapPoint = [self.mapView convertPoint:location toCoordinateFromView:self.mapView];
    //NSLog(@"tap: x:%f, y:%f", mapPoint.latitude, mapPoint.longitude);
    [self drawHex:mapPoint.latitude lon:mapPoint.longitude level:level];
}


-(void) drawHex:(double)lat lon:(double)lon level:(int)level {
    Zone *zone = [GeoHex getZoneByLocation:lat longitude:lon level:level];
    if([hexCodeSet containsObject: zone.code] == FALSE) {
        NSArray *locArray = [zone getHexCoords];
        CLLocationCoordinate2D coors[6];
        coors[0] = CLLocationCoordinate2DMake(((Loc*)[locArray objectAtIndex:0]).lat,((Loc*)[locArray objectAtIndex:0]).lon);
        coors[1] = CLLocationCoordinate2DMake(((Loc*)[locArray objectAtIndex:1]).lat,((Loc*)[locArray objectAtIndex:1]).lon);
        coors[2] = CLLocationCoordinate2DMake(((Loc*)[locArray objectAtIndex:2]).lat,((Loc*)[locArray objectAtIndex:2]).lon);
        coors[3] = CLLocationCoordinate2DMake(((Loc*)[locArray objectAtIndex:3]).lat,((Loc*)[locArray objectAtIndex:3]).lon);
        coors[4] = CLLocationCoordinate2DMake(((Loc*)[locArray objectAtIndex:4]).lat,((Loc*)[locArray objectAtIndex:4]).lon);
        coors[5] = CLLocationCoordinate2DMake(((Loc*)[locArray objectAtIndex:5]).lat,((Loc*)[locArray objectAtIndex:5]).lon);
        MKPolygon *polygon = [MKPolygon polygonWithCoordinates:coors count:6];
        [self.mapView addOverlay:polygon];
        [hexCodeSet addObject:zone.code];
        [polyArray addObject:polygon];
    }
}


- (MKOverlayView *)mapView:(MKMapView *)mapView viewForOverlay:(id<MKOverlay>)overlay {
    MKPolygonView *view = [[MKPolygonView alloc] initWithOverlay:overlay];
    view.strokeColor = [UIColor orangeColor];
    view.lineWidth = 1.0;
    view.fillColor = [UIColor colorWithRed:1 green:0.5 blue:0 alpha:0.3];
    return view;
}

-(IBAction)changeLevel:(UIButton *)sender {
    NSString *buttonText = [[sender titleLabel] text];
    level = [[self.levelLabel text] intValue];
    if ([buttonText isEqual:@"＋"]) {
        if (level <= 14) {
            level ++;
            [self.levelLabel setText:[NSString stringWithFormat:@"%d", level]];
            if(level == 15) {
                [self.plusButton setEnabled:FALSE];
            } else {
                [self.plusButton setEnabled:TRUE];
                [self.minusButton setEnabled:TRUE];
            }
        }
    } else if([buttonText isEqual:@"ー"]) {
        if (level >= 1) {
            level --;
            [self.levelLabel setText:[NSString stringWithFormat:@"%d", level]];
            if(level == 0) {
                [self.minusButton setEnabled:FALSE];
            } else {
                [self.plusButton setEnabled:TRUE];
                [self.minusButton setEnabled:TRUE];
            }
        }
    }
}

-(IBAction)changeMode:(UISegmentedControl *)sender {
    if ([sender selectedSegmentIndex] == 0) {
        self.mapView.scrollEnabled = TRUE;
        [self.mapView removeGestureRecognizer:panGesture];
    } else {
        self.mapView.scrollEnabled = FALSE;
        [self.mapView addGestureRecognizer:panGesture];
    }
}

-(IBAction)changeMap:(UISegmentedControl *)sender {
    self.mapView.mapType = sender.selectedSegmentIndex;
}

-(IBAction)resetMap:(UIButton *)sender {
    for (MKPolygon* poly in polyArray) {
        [self.mapView removeOverlay:poly];
    }
    [polyArray removeAllObjects];
    [hexCodeSet removeAllObjects];
}

@end
