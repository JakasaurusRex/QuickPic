//
//  PostCell.m
//  QuickPic
//
//  Created by Jake Torres on 6/28/22.
//

#import "PostCell.h"

@implementation PostCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
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
