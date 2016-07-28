//
//  ViewController.h
//  LukaszMatuszczak
//
//  Created by Lukasz Matuszczak on 27/04/16.
//
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>
#import <CoreData/CoreData.h>
@interface ViewController : UIViewController <CLLocationManagerDelegate>
@property (strong, nonatomic) CLLocationManager *locationManager;
@property (weak, nonatomic) IBOutlet MKMapView *myMapView;
@property (weak, nonatomic) IBOutlet UIButton *achievementButtonOutlet;
- (IBAction)buttonClickAction:(id)sender;

@end

