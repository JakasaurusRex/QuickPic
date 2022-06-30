//
//  OtherProfileViewController.m
//  QuickPic
//
//  Created by Jake Torres on 6/29/22.
//

#import "OtherProfileViewController.h"
#import <Parse/Parse.h>
#import "ProfileViewCell.h"
#import "Post.h"
#import "DetailsViewController.h"

@interface OtherProfileViewController () <UICollectionViewDelegate, UICollectionViewDataSource>
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UINavigationItem *navBar;
@property (strong, nonatomic) NSArray *posts;

@end

@implementation OtherProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    
    [self setup];
    [self query];
    [self.collectionView reloadData];
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
    self.navBar.title = self.user[@"username"];
    
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

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    ProfileViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ProfileCell" forIndexPath:indexPath];
    Post *post = self.posts[indexPath.item];
    
    [post.image getDataInBackgroundWithBlock:^(NSData * _Nullable data, NSError * _Nullable error) {
        if(error == nil) {
            cell.postPic.image = [UIImage imageWithData:data];
            NSLog(@"Image loaded");
        } else {
            NSLog(@"Error loading image");
        }
    }];
    
    return cell;
    
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [self.posts count];
}

-(void) query {
    // construct query
    PFQuery *query = [PFQuery queryWithClassName:@"Post"];
    [query orderByDescending:@"createdAt"];
    query.limit = 20;
    [query includeKey:@"author"];
    [query whereKey:@"author" equalTo:self.user];
    // fetch data asynchronously
    [query findObjectsInBackgroundWithBlock:^(NSArray *posts, NSError *error) {
        if (posts != nil) {
            // do something with the array of object returned by the call
            self.posts = posts;
            NSLog(@"Received Posts!");
            [self.collectionView reloadData];
        } else {
            NSLog(@"%@", error.localizedDescription);
        }
    }];
}



#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 if([segue.identifier isEqualToString:@"detailsSegue"]) {
     UINavigationController *navigationController = [segue destinationViewController];
     DetailsViewController *detailVC = (DetailsViewController*)navigationController.topViewController;
     NSIndexPath *indexPath = [self.collectionView indexPathForCell:sender];
     detailVC.post = self.posts[indexPath.row];
 }
}


@end
