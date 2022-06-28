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
    [NSTimer scheduledTimerWithTimeInterval:30 target:self selector:@selector(query) userInfo:nil repeats:true];

}

- (IBAction)logoutButton:(id)sender {
    [self logout];
}

- (void)beginRefresh:(UIRefreshControl *)refreshControl {
    [self query];
    [self.tableView reloadData];
    [refreshControl endRefreshing];
}

-(void) logout{
    [PFUser logOutInBackgroundWithBlock:^(NSError * _Nullable error) {
        if(error != nil) {
            NSLog(@"rip cant logout: %@", error);
        } else {
            NSLog(@"User logged out successfully");
            // display view controller that needs to shown after successful login
            [self performSegueWithIdentifier:@"logoutSegue" sender:nil];
        }
    }];
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
    
    
    
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.tableView deselectRowAtIndexPath:[self.tableView indexPathForSelectedRow] animated:YES];
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
    }
}

@end
