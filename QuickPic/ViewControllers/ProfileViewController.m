//
//  ProfileViewController.m
//  QuickPic
//
//  Created by Jake Torres on 6/27/22.
//

#import "ProfileViewController.h"
#import <Parse/Parse.h>
#import "ProfileViewCell.h"
#import "Post.h"
#import "DetailsViewController.h"

@interface ProfileViewController () <UICollectionViewDelegate, UICollectionViewDataSource>
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (strong, nonatomic) NSArray *posts;

@end

@implementation ProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    self.user = [PFUser currentUser];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setup) name:@"profile" object:nil];
    
    //Pull to refresh
    self.collectionView.alwaysBounceVertical = YES;
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
    [refreshControl addTarget:self action:@selector(beginRefresh:) forControlEvents:UIControlEventValueChanged];
    [self.collectionView insertSubview:refreshControl atIndex:0];
    
    
    [self query];
    [self setup];
}

- (void)beginRefresh:(UIRefreshControl *)refreshControl {
    [self query];
    [self setup];
    [self.collectionView reloadData];
    [refreshControl endRefreshing];
}


-(void) setup {
    PFUser *user = self.user;
    self.username.text = user.username;
    self.desc.text = user[@"desc"];
    self.pronouns.text = user[@"pronouns"];
    self.name.text = user[@"name"];
    int x = [user[@"postCount"] intValue];
    self.postNum.text = [NSString stringWithFormat:@"%d", x];
    
    [user[@"profilePic"] getDataInBackgroundWithBlock:^(NSData * _Nullable data, NSError * _Nullable error) {
        if(error == nil) {
            self.profileImage.image = [UIImage imageWithData:data];
            NSLog(@"Image loaded");
        } else {
            NSLog(@"Error loading image");
        }
    }];
    self.profileImage.layer.masksToBounds = false;
    self.profileImage.layer.cornerRadius = self.profileImage.bounds.size.width/2;
    self.profileImage.clipsToBounds = true;
    self.profileImage.contentMode = UIViewContentModeScaleAspectFill;
    self.profileImage.layer.borderWidth = 0.05;
}

- (IBAction)settingsButton:(id)sender {
    
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
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if([segue.identifier isEqualToString:@"detailsSegue"]) {
        UINavigationController *navigationController = [segue destinationViewController];
        DetailsViewController *detailVC = (DetailsViewController*)navigationController.topViewController;
        NSIndexPath *indexPath = [self.collectionView indexPathForCell:sender];
        detailVC.post = self.posts[indexPath.row];
    }
}


@end
