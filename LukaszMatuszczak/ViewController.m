//
//  ViewController.m
//  LukaszMatuszczak
//
//  Created by Lukasz Matuszczak on 27/04/16.
//
//

#import "ViewController.h"

@interface ViewController ()

@property (strong, nonatomic) CLLocationManager *locationManager;
@property (weak, nonatomic) IBOutlet MKMapView *myMapView;
@property (weak, nonatomic) IBOutlet UIButton *achievementButtonOutlet;
- (IBAction)buttonClickAction:(id)sender;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *level = [defaults objectForKey:@"myLevelKey"];
    if (level == nil) {
        [defaults setObject:[NSNumber numberWithInteger:0] forKey:@"myLevelKey"];
        [defaults synchronize];

    }

    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    [self.locationManager startUpdatingLocation];
    [self.locationManager requestAlwaysAuthorization];
    [self.myMapView  setRegion:MKCoordinateRegionMake(CLLocationCoordinate2DMake(10, 10), MKCoordinateSpanMake(180, 180)) animated:YES];

    
    NSManagedObjectContext *managedObjectContext = [self managedObjectContext];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"MapPlace"];
    NSMutableArray * tmpArray = [[managedObjectContext executeFetchRequest:fetchRequest error:nil] mutableCopy];
    for (NSManagedObjectContext *x in tmpArray) {
        [self.myMapView addOverlay:[MKCircle circleWithCenterCoordinate:CLLocationCoordinate2DMake( [[x valueForKey:@"latitude"] doubleValue], [[x valueForKey:@"longitude"] doubleValue]) radius:0]];
    }
}

- (NSManagedObjectContext *)managedObjectContext {
    NSManagedObjectContext *context = nil;
    id delegate = [[UIApplication sharedApplication] delegate];
    if([delegate performSelector:@selector(managedObjectContext)]) {
        context = [delegate managedObjectContext];
    }
    return context;
}


- (MKOverlayView *)mapView:(MKMapView *)mapView viewForOverlay:(id)overlay
{
    MKCircleView *circleView = [[MKCircleView alloc] initWithCircle:(MKCircle*)overlay];
    circleView.fillColor = [[UIColor redColor] colorWithAlphaComponent:1.0];
    circleView.strokeColor = [[UIColor redColor] colorWithAlphaComponent:1.0];
    
    circleView.exclusiveTouch = YES;
    circleView.clipsToBounds = YES;
   
    return circleView;
}

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    NSManagedObjectContext *managedObjectContext = [self managedObjectContext];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"MapPlace"];
    NSMutableArray * tmpArray = [[managedObjectContext executeFetchRequest:fetchRequest error:nil] mutableCopy];
    NSInteger tmpCounter = 0 ;
    for (NSManagedObjectContext *x in tmpArray) {
        CLLocation* tmpLocation = [[CLLocation alloc] initWithLatitude:[[x valueForKey:@"latitude"] doubleValue] longitude:[[x valueForKey:@"longitude"] doubleValue] ];
        const NSInteger valueOfLocationZoom = 100000;
        if([newLocation distanceFromLocation:tmpLocation] > (valueOfLocationZoom))tmpCounter++;
    }
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    if(tmpCounter == [tmpArray count]){
        [self.myMapView  setRegion:MKCoordinateRegionMake(CLLocationCoordinate2DMake(newLocation.coordinate.latitude, newLocation.coordinate.longitude), MKCoordinateSpanMake(180, 180)) animated:YES];
        [self.myMapView addOverlay:[MKCircle circleWithCenterCoordinate:CLLocationCoordinate2DMake(newLocation.coordinate.latitude, newLocation.coordinate.longitude) radius:50000]];
        [ self saveToCoreData:newLocation.coordinate.latitude:newLocation.coordinate.longitude ];
        if(tmpCounter +1 ==10000){ [self showButton:@"Master of world dotted"];   [defaults setObject:[NSNumber numberWithInteger:0] forKey:@"myLevelKey"];}
       
        else  if(tmpCounter +1 ==5000){ [self showButton:@"Traveler"];
            [defaults setObject:[NSNumber numberWithInteger:6] forKey:@"myLevelKey"];}
       
        else  if(tmpCounter +1 ==1000){ [self showButton:@"Touring"];
            [defaults setObject:[NSNumber numberWithInteger:5] forKey:@"myLevelKey"];}
      
        else if(tmpCounter +1 ==100){ [self showButton:@"Holidays"];
            [defaults setObject:[NSNumber numberWithInteger:4] forKey:@"myLevelKey"];}
       
        else if(tmpCounter +1 ==10){ [self showButton:@"Family trip"];
            [defaults setObject:[NSNumber numberWithInteger:3] forKey:@"myLevelKey"];}
       
        else if(tmpCounter +1 ==5){ [self showButton:@"Short out"];
            [defaults setObject:[NSNumber numberWithInteger:2] forKey:@"myLevelKey"];}
       
        else if(tmpCounter +1 ==1){ [self showButton:@"Stay-at-home"];
            [defaults setObject:[NSNumber numberWithInteger:1] forKey:@"myLevelKey"];}
        
            [defaults synchronize];
    }}

- (void)saveToCoreData:(double)latitude :(double)longitude {
    NSManagedObjectContext *context = [self managedObjectContext];
    
    NSManagedObject *newPlace = [NSEntityDescription insertNewObjectForEntityForName:@"MapPlace" inManagedObjectContext:context];
    [newPlace setValue:[NSNumber numberWithDouble:latitude] forKey:@"latitude"];
    [newPlace setValue:[NSNumber numberWithDouble:longitude] forKey:@"longitude"];
    NSError *error = nil;
    if (![context save:&error]) {
    }
    [self dismissViewControllerAnimated:YES completion:nil];

}

- (IBAction)buttonClickAction:(id)sender {
   
    CGRect screenBound = [[UIScreen mainScreen] bounds];
    CGSize screenSize = screenBound.size;
    [UIView animateWithDuration:2.0 delay:0.0 options:UIViewAnimationOptionCurveEaseInOut
                     animations:^(void) {
                         
                        
                     }
                     completion:^(BOOL finished){
                                 self.achievementButtonOutlet.layer.frame = CGRectMake(screenSize.width/2-100, screenSize.height/2, 200, 150);
                                                 [UIView animateWithDuration:1.0 delay:0.0 options:
                          UIViewAnimationOptionCurveEaseIn animations:^{
                              self.achievementButtonOutlet.frame = CGRectMake(0, 0, 0, 0);

                          } completion:^ (BOOL completed) { self.achievementButtonOutlet.hidden = YES;}];
                     }];

   
}
-(void) showButton: (NSString*) title{
    [self.achievementButtonOutlet.titleLabel setTextAlignment: NSTextAlignmentCenter];
    self.achievementButtonOutlet.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
    [self.achievementButtonOutlet setTitle:[NSString stringWithFormat:@"Achievement unlocked!\nYeah! You got new level:\n%@", title] forState:UIControlStateNormal];
    CGRect screenBound = [[UIScreen mainScreen] bounds];
    CGSize screenSize = screenBound.size;
    [UIView animateWithDuration:2.0 delay:0.0 options:UIViewAnimationOptionCurveEaseInOut
                     animations:^(void) {
                                                  }
                     completion:^(BOOL finished){
                         
                         self.achievementButtonOutlet.frame = CGRectMake(0, 0, 0, 0);
                         self.achievementButtonOutlet.hidden = NO;

                         [UIView animateWithDuration:1.0 delay:0.0 options:
                          UIViewAnimationOptionCurveEaseIn animations:^{
                              
                              self.achievementButtonOutlet.layer.frame = CGRectMake(screenSize.width/2-100, screenSize.height/2, 200, 150);
                          } completion:^ (BOOL completed) {}];
                     }];

}
@end
