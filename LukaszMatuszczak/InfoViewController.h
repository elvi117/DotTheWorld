//
//  InfoViewController.h
//  LukaszMatuszczak
//
//  Created by Lukasz Matuszczak on 28/04/16.
//
//

#import <UIKit/UIKit.h>
#import "AchievmentTableViewCell.h"
@interface InfoViewController : UIViewController
- (IBAction)backButton:(id)sender;
@property (weak, nonatomic) IBOutlet UITableView *myTableView;
@property (strong, nonatomic) NSArray* arrayOfLevels;
@end
