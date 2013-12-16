//
//  IMPViewController.h
//  ImageProcessingTest2
//

#import <UIKit/UIKit.h>
#import <MobileCoreServices/UTCoreTypes.h>
#import <Twitter/Twitter.h>
#import <MessageUI/MessageUI.h>
#import <QuartzCore/QuartzCore.h>
#import <iAd/iAd.h>


@class MyManager;
@interface IMPViewController : UIViewController<UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIActionSheetDelegate, MFMailComposeViewControllerDelegate, MFMessageComposeViewControllerDelegate, UIActionSheetDelegate, UIGestureRecognizerDelegate, ADBannerViewDelegate, UIAlertViewDelegate> {
    IBOutlet UIActivityIndicatorView *activityIndicator;
    UIImageView *imgView;
    IBOutlet UIToolbar *toolbar;
    MyManager * manager;
    UIActionSheet * frameAction;
    UIActionSheet * rateActionSheet;
    UIActionSheet * photoAction;
    
    CGAffineTransform * defaultTransform;
    
    IBOutlet ADBannerView *bannerView;
    IBOutlet UIScrollView *scrollView;
    IBOutlet UIView *contentView;  
    IBOutlet UIView *freeContent;

    IBOutlet UIBarButtonItem *cameraBarButton;
    UIPinchGestureRecognizer *pinchGesture;
    UIPanGestureRecognizer *panGesture;
    UIRotationGestureRecognizer *rotationGesture;

    UIView *brightnessView;
    UIPopoverController * popoverController;
    __unsafe_unretained IBOutlet UIBarButtonItem *infoButton;
    UIPopoverController * infoPop;
    UIPopoverController * moreFramesPopover;
}
- (IBAction)changeBrightness:(id)sender;

@property (strong, nonatomic) IBOutlet UIImageView *imgView;
@property (strong, nonatomic) IBOutlet UIPinchGestureRecognizer *pinchGesture;
@property (strong, nonatomic) IBOutlet UIPanGestureRecognizer *panGesture;
@property (strong, nonatomic) IBOutlet UIRotationGestureRecognizer *rotationGesture;
@property (strong, nonatomic) UIGestureRecognizer *gesture;

- (IBAction)resizeFrame:(id)sender;
- (IBAction)showInfo:(id)sender;

- (IBAction)pinchGestureMethod:(id)sender;
- (IBAction)rotationGestureMethod:(id)sender;
- (IBAction)panGestureMethod:(id)sender;
- (BOOL) amIAnIPad;
@property (strong, nonatomic) IBOutlet UIImageView *frameImgView;
- (IBAction)rateApp:(id)sender;
- (IBAction)rotateFrame:(id)sender;

- (IBAction)undoToDefaultFrame:(id)sender;
- (IBAction)shareActions:(id)sender;
- (IBAction)takePhoto:(id)sender;
- (IBAction)showFrames:(id)sender;
-(void)layoutForCurrentOrientation:(BOOL)animated;
- (IBAction)pickFrame:(id)sender;
- (BOOL) startCameraControllerFromViewController: (UIViewController*) controller
                                   usingDelegate: (id <UIImagePickerControllerDelegate,
                                                   UINavigationControllerDelegate>) delegate;
- (BOOL) startCameraControllerPickerViewController: (UIViewController*) controller
                                     usingDelegate: (id <UIImagePickerControllerDelegate,
                                                     UINavigationControllerDelegate>) delegate;
-(UIImage *)resizeImage:(UIImage *)img;

@end
