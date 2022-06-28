//
//  ProfileViewController.h
//  QuickPic
//
//  Created by Jake Torres on 6/27/22.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ProfileViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIImageView *profileImage;
@property (weak, nonatomic) IBOutlet UILabel *postNum;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *desc;
@property (weak, nonatomic) IBOutlet UILabel *pronouns;
@property (weak, nonatomic) IBOutlet UILabel *username;

@end

NS_ASSUME_NONNULL_END
