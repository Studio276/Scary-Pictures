//
//  InfoViewController.h
//  My World
//


#import <UIKit/UIKit.h>


@interface InfoViewController : UIViewController {
    IBOutlet UIScrollView *scrollView;
    IBOutlet UIView *infoSubView;
}
//Open App Store Address
- (IBAction)openAppStore:(id)sender;
- (IBAction)dismissInfoView:(id)sender;



@end
