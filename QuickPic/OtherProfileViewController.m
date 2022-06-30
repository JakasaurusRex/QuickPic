//
//  OtherProfileViewController.m
//  QuickPic
//
//  Created by Jake Torres on 6/29/22.
//

#import "OtherProfileViewController.h"
#import <Parse/Parse.h>

@interface OtherProfileViewController ()
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@end

@implementation OtherProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setup];
}
- (IBAction)backButton:(id)sender {
    [self dismissViewControllerAnimated:true completion:nil];
}

-(void) setup {
    PFUser *user = self.user;
    self.desc.text = user[@"desc"];
    self.pronouns.text = user[@"pronouns"];
    self.name.text = user[@"name"];
    NSLog(@"%@", user[@"postCount"]);
    int x = [user[@"postCount"] intValue];
    self.postCount.text = [NSString stringWithFormat:@"%d", x];
    
    [user[@"profilePic"] getDataInBackgroundWithBlock:^(NSData * _Nullable data, NSError * _Nullable error) {
        if(error == nil) {
            self.profilePic.image = [UIImage imageWithData:data];
            NSLog(@"Image loaded");
        } else {
            NSLog(@"Error loading image");
        }
    }];
    self.profilePic.layer.masksToBounds = false;
    self.profilePic.layer.cornerRadius = self.profilePic.bounds.size.width/2;
    self.profilePic.clipsToBounds = true;
    self.profilePic.contentMode = UIViewContentModeScaleAspectFill;
    self.profilePic.layer.borderWidth = 0.05;
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
