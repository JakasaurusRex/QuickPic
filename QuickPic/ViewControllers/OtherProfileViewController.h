//
//  OtherProfileViewController.h
//  QuickPic
//
//  Created by Jake Torres on 6/29/22.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

NS_ASSUME_NONNULL_BEGIN

@interface OtherProfileViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIImageView *profilePic;
@property (weak, nonatomic) IBOutlet UILabel *postCount;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *desc;
@property (weak, nonatomic) IBOutlet UILabel *pronouns;
@property (nonatomic, strong) PFUser *user;
@end

NS_ASSUME_NONNULL_END
