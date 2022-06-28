//
//  ProfileViewController.m
//  QuickPic
//
//  Created by Jake Torres on 6/27/22.
//

#import "ProfileViewController.h"
#import <Parse/Parse.h>

@interface ProfileViewController ()
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@end

@implementation ProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    PFUser *user = [PFUser currentUser];
    self.username.text = user.username;
    self.desc.text = user[@"desc"];
    self.pronouns.text = user[@"pronouns"];
    self.followerCount.text = [NSString stringWithFormat:@"%d", [user[@"followerCount"] intValue]];
    self.postNum.text = [NSString stringWithFormat:@"%d", [user[@"postCount"] intValue]];
    self.followingCount.text = [NSString stringWithFormat:@"%d", [user[@"followingCount"] intValue]];
}

- (IBAction)settingsButton:(id)sender {
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
