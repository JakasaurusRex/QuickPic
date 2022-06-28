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

@interface HomeViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSArray *posts;

@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    // Do any additional setup after loading the view.
}

- (IBAction)logoutButton:(id)sender {
    [self logout];
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
    // fetch data asynchronously
    [query findObjectsInBackgroundWithBlock:^(NSArray *posts, NSError *error) {
        if (posts != nil) {
            // do something with the array of object returned by the call
            self.posts = posts;
        } else {
            NSLog(@"%@", error.localizedDescription);
        }
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 20;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    PostCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PostCell" forIndexPath:indexPath];
    
    Post *post = self.posts[indexPath.row];
    
    cell.username.text = post.author[@"username"];
    cell.caption.text = post.caption;
    
    //turning PFFileObject that is the post image into data to be used to turn into an image
    [post.image getDataInBackgroundWithBlock:^(NSData * _Nullable data, NSError * _Nullable error) {
        if(error == nil) {
            cell.postImage.image = [UIImage imageWithData:data];
        } else {
            NSLog(@"Error receiving image");
        }
    }];
    
    return cell;
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
