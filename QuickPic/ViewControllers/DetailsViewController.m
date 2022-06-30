//
//  DetailsViewController.m
//  QuickPic
//
//  Created by Jake Torres on 6/28/22.
//

#import "DetailsViewController.h"
#import "OtherProfileViewController.h"
#import "HomeViewController.h"

@interface DetailsViewController ()
@property (weak, nonatomic) IBOutlet UIButton *profileButton;
@property (weak, nonatomic) IBOutlet UIButton *likeButton;
@property (weak, nonatomic) IBOutlet UILabel *likeCount;

@end

@implementation DetailsViewController


- (IBAction)backButton:(id)sender {
    [self dismissViewControllerAnimated:true completion:nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"load" object:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.username.text = self.post.author[@"username"];
    self.caption.text = self.post[@"caption"];
    self.titleUsername.text = self.post.author[@"username"];
    
    NSDate *date = self.post.createdAt;
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"MMM d, yyyy"];
    self.createdAt.text = [dateFormatter stringFromDate:date];
    
    [self.profileButton setTitle:@"" forState:UIControlStateNormal];
    
    
    //turning PFFileObject that is the post image into data to be used to turn into an image
    [self.post.image getDataInBackgroundWithBlock:^(NSData * _Nullable data, NSError * _Nullable error) {
        if(error == nil) {
            self.postImage.image = [UIImage imageWithData:data];
            NSLog(@"Image loaded");
        } else {
            NSLog(@"Error loading image");
        }
    }];
    [self.post.author[@"profilePic"] getDataInBackgroundWithBlock:^(NSData * _Nullable data, NSError * _Nullable error) {
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
    
    [self.likeButton setTitle:@"" forState:UIControlStateNormal];
    PFUser *curUser = [PFUser currentUser];
    self.likeCount.text = [NSString stringWithFormat:@"%lu likes", (unsigned long)[self.post.likedUsers count]];
    if([self.post.likedUsers containsObject:curUser.username]) {
        [self.likeButton setImage:[UIImage systemImageNamed:@"heart.fill"] forState:UIControlStateNormal];
        self.likeButton.tintColor = UIColor.systemPinkColor;
        self.liked = YES;
    } else {
        [self.likeButton setImage:[UIImage systemImageNamed:@"heart"] forState:UIControlStateNormal];
        self.likeButton.tintColor = UIColor.lightGrayColor;
        self.liked = NO;
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if([segue.identifier isEqualToString:@"profileSegue"]) {
        UINavigationController *navigationController = [segue destinationViewController];
        OtherProfileViewController *profileController = (OtherProfileViewController*)navigationController.topViewController;
        PFUser *user = self.post.author;
        profileController.user = user;
    }
}


- (IBAction)likeButtonPressed:(id)sender {
    PFUser *user = [PFUser currentUser];
    NSMutableArray *likedUsers = [[NSMutableArray alloc] initWithArray:self.post.likedUsers];
    
    if(self.liked) {
        //visual stuff
        [self.likeButton setImage:[UIImage systemImageNamed:@"heart"] forState:UIControlStateNormal];
        self.likeButton.tintColor = UIColor.lightGrayColor;
        self.liked = NO;
        //mutable array stuff
        [likedUsers removeObject:user.username];
        NSArray *dbLikedUsers = [[NSArray alloc] initWithArray:likedUsers];
        self.post.likedUsers = dbLikedUsers;
    } else {
        //visual stuff
        [self.likeButton setImage:[UIImage systemImageNamed:@"heart.fill"] forState:UIControlStateNormal];
        self.likeButton.tintColor = UIColor.systemPinkColor;
        self.liked = YES;
        //mutable array stuff
        [likedUsers addObject:user.username];
        NSArray *dbLikedUsers = [[NSArray alloc] initWithArray:likedUsers];
        self.post.likedUsers = dbLikedUsers;
    }
    
    //pushing the information to the database
    [self.post saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
        if(error == nil) {
            NSLog(@"Liked or unliked post!");
        } else {
            NSLog(@"Error liking or unliking post!");
        }
    }];
    
    //updating label
    [self updateLabels];
}

-(void) updateLabels {
    self.likeCount.text = [NSString stringWithFormat:@"%lu likes", (unsigned long)[self.post.likedUsers count]];
}

@end
