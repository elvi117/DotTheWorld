//
//  InfoViewController.m
//  LukaszMatuszczak
//
//  Created by Lukasz Matuszczak on 28/04/16.
//
//

#import "InfoViewController.h"

@interface InfoViewController ()

- (IBAction)backButton:(id)sender;

@property (weak, nonatomic) IBOutlet UITableView *myTableView;

@end

@implementation InfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
     self.arrayOfLevels = @[@"Stay-at-home", @"Short out", @"Family trip", @"Holidays", @"Touring", @"Traveler", @"Master of world dotted"];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
   
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)backButton:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *level = [defaults objectForKey:@"myLevelKey"];
    return [level integerValue];
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

AchievmentTableViewCell* cell  = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    cell.levelLabel.text = [self.arrayOfLevels objectAtIndex: indexPath.row];
    return cell;
}

@end
