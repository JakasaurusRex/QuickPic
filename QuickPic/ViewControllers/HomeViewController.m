//
//  HomeViewController.m
//  QuickPic
//
//  Created by Jake Torres on 6/27/22.
//

#import "HomeViewController.h"
#import <Parse/Parse.h>
#import "PostCell.h"
#import "Post.h"
#import "Parse/PFImageView.h"
#import "DetailsViewController.h"
#import "OtherProfileViewController.h"

@interface HomeViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSArray *posts;

@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    
    //Pull to refresh
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
    [refreshControl addTarget:self action:@selector(beginRefresh:) forControlEvents:UIControlEventValueChanged];
    [self.tableView insertSubview:refreshControl atIndex:0];
    
    // Do any additional setup after loading the view.
    [self query];
    [self.tableView reloadData];
    if([PFUser.currentUser[@"firstTime"] intValue] == 1) {
        [self alertWithTitle:@"Welcome to QuickPic!" message:@"If you would like to customize your profile and add your email go to the settings page found on the top right corner of the profile."];
        PFUser.currentUser[@"firstTime"] = @(0);
    } else if(PFUser.currentUser[@"email"] == nil) {
        [self alertWithTitle:@"Please add email" message:@"It appears you do not have an email on your account. Please go to setting on the profile page to add one to reset your password if needed."];
    }
}


- (void)beginRefresh:(UIRefreshControl *)refreshControl {
    [self query];
    [self.tableView reloadData];
    [refreshControl endRefreshing];
}


-(void) query {
    // construct query
    PFQuery *query = [PFQuery queryWithClassName:@"Post"];
    [query orderByDescending:@"createdAt"];
    query.limit = 20;
    [query includeKey:@"author"];
    // fetch data asynchronously
    [query findObjectsInBackgroundWithBlock:^(NSArray *posts, NSError *error) {
        if (posts != nil) {
            // do something with the array of object returned by the call
            self.posts = posts;
            NSLog(@"Received Posts!");
            [self.tableView reloadData];
        } else {
            NSLog(@"%@", error.localizedDescription);
        }
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.posts count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    PostCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PostCell" forIndexPath:indexPath];
    
    Post *post = self.posts[indexPath.row];
    
    cell.username.text = post.author[@"username"];
    
    cell.caption.text = post[@"caption"];
    if(![cell.caption.text isEqualToString:@""]) {
        cell.usernameCap.text = post.author[@"username"];
    }
    
    //turning PFFileObject that is the post image into data to be used to turn into an image
    [post.image getDataInBackgroundWithBlock:^(NSData * _Nullable data, NSError * _Nullable error) {
        if(error == nil) {
            cell.postImage.image = [UIImage imageWithData:data];
            NSLog(@"Image loaded");
        } else {
            NSLog(@"Error loading image");
        }
    }];
    
    [post.author[@"profilePic"] getDataInBackgroundWithBlock:^(NSData * _Nullable data, NSError * _Nullable error) {
        if(error == nil) {
            cell.profilePic.image = [UIImage imageWithData:data];
            NSLog(@"Image loaded");
        } else {
            NSLog(@"Error loading image");
        }
    }];
    
    cell.profilePic.layer.masksToBounds = false;
    cell.profilePic.layer.cornerRadius = cell.profilePic.bounds.size.width/2;
    cell.profilePic.clipsToBounds = true;
    cell.profilePic.contentMode = UIViewContentModeScaleAspectFill;
    cell.profilePic.layer.borderWidth = 0.05;
    
    NSDate *postDate = post.createdAt;
    NSDate *curDate = [NSDate date];
    NSTimeInterval diff = [curDate timeIntervalSinceDate:postDate];
    
    //format the createdstring based on if it was tweeted an hour or more ago or a minute or more ago
    NSInteger interval = diff;
    long seconds = interval % 60;
    long minutes = (interval / 60) % 60;
    long hours = (interval / 3600);
    if(hours >= 24) {
        if(hours >48) {
            cell.timeSInce.text = [NSString stringWithFormat:@"%ld days ago", hours/24];
        } else {
            cell.timeSInce.text = [NSString stringWithFormat:@"%ld day ago", hours/24];
        }
    } else if(hours >= 1) {
        if(hours == 1) {
            cell.timeSInce.text = [NSString stringWithFormat:@"%ld hour ago", hours];
        } else {
            cell.timeSInce.text = [NSString stringWithFormat:@"%ld hours ago", hours];
        }
        
    } else if(minutes >= 1) {
        if(minutes == 1) {
            cell.timeSInce.text = [NSString stringWithFormat:@"%ld minute ago", minutes];
        } else {
            cell.timeSInce.text = [NSString stringWithFormat:@"%ld minutes ago", minutes];
        }
    } else {
        if(seconds > 1) {
            cell.timeSInce.text = [NSString stringWithFormat:@"%ld seconds ago", seconds];
        } else {
            cell.timeSInce.text = [NSString stringWithFormat:@"%ld second ago", seconds];
        }
    }
    
    // allow user to go to other profiles
    cell.username.userInteractionEnabled = YES;
    cell.profilePic.userInteractionEnabled = YES;
    UITapGestureRecognizer *tapGesture = \
    [[UITapGestureRecognizer alloc]
     initWithTarget:self action:@selector(didTapWithGesture:)];
    [cell.username addGestureRecognizer:tapGesture];
    [cell.profilePic addGestureRecognizer:tapGesture];
    [cell.profileButton setTitle:@"" forState:UIControlStateNormal];
    cell.likeCount.text = [NSString stringWithFormat:@"%d likes", [post.likeCount intValue]];
    
    
    return cell;
}

- (void)didTapWithGesture:(UITapGestureRecognizer *)tapGesture {
    
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.tableView deselectRowAtIndexPath:[self.tableView indexPathForSelectedRow] animated:YES];
}

- (void) alertWithTitle: (NSString *)title message:(NSString *)text {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title
                                                                               message:text
                                                                        preferredStyle:(UIAlertControllerStyleAlert)];
    // create an OK action
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK"
                                                       style:UIAlertActionStyleDefault
                                                     handler:^(UIAlertAction * _Nonnull action) {
                                                             // handle response here.
                                                     }];
    // add the OK action to the alert controller
    [alert addAction:okAction];
    [self presentViewController:alert animated:YES completion:^{
        // optional code for what happens after the alert controller has finished presenting
    }];
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if([segue.identifier isEqualToString:@"detailSegue"]) {
        UINavigationController *navigationController = [segue destinationViewController];
        DetailsViewController *detailVC = (DetailsViewController*)navigationController.topViewController;
        NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
        detailVC.post = self.posts[indexPath.row];
    } else if([segue.identifier isEqualToString:@"profileSegue"]) {
        UINavigationController *navigationController = [segue destinationViewController];
        OtherProfileViewController *profileController = (OtherProfileViewController*)navigationController.topViewController;
         UIView *content = (UIView *)[(UIView *) sender superview];
         PostCell *cell = (PostCell *)[content superview];
        NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
        Post *post =self.posts[indexPath.row];
        PFUser *user = post.author;
        profileController.user = user;
    }
}

@end
