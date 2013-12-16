//
//  IMPViewController.m
//  ImageProcessingTest2
//


#import "IMPViewController.h"
#import "CoreImageFunctions.h"
#import "SocialHelper.h"
#import "InfoViewController.h"

@implementation IMPViewController
@synthesize panGesture;
@synthesize frameImgView;
@synthesize rotationGesture;
@synthesize imgView;
@synthesize pinchGesture;

CGRect defaultFrame;
CGRect scrollDefaultFrame;
CGRect scrollDefaultFrameLandscape;
CGRect scrollHidden;
CGAffineTransform defaultTransform;
UIImage * imageToSave;
SocialHelper * socialHelper;




#pragma mark cropping image
-(CGRect)frameForImage:(UIImage*)image inImageViewAspectFit:(UIImageView*)imageView{
    CGAffineTransform trans2= frameImgView.transform;
    CGAffineTransform t0 = CGAffineTransformMakeRotation(degreesToRadians(0));
    CGAffineTransform t90 = CGAffineTransformMakeRotation(degreesToRadians(90));
    CGAffineTransform t180 = CGAffineTransformMakeRotation(degreesToRadians(180));
    CGAffineTransform t270 = CGAffineTransformMakeRotation(degreesToRadians(270));
    CGAffineTransform t360 = CGAffineTransformMakeRotation(degreesToRadians(360));
    
    BOOL portrait = NO;
    
    if(CGAffineTransformEqualToTransform(trans2, t0))
    {
        NSLog(@"T 0");
        portrait = YES;
    }
    if(CGAffineTransformEqualToTransform(trans2, t90))
    {
        NSLog(@"T 90");
        portrait = NO;
    }
    if(CGAffineTransformEqualToTransform(trans2, t180))
    {
        NSLog(@"T 180");
        portrait = YES;
    }
    if(CGAffineTransformEqualToTransform(trans2, t270))
    {
        NSLog(@"T 270");
        portrait = NO;
    }
    if(CGAffineTransformEqualToTransform(trans2, t360))
    {
        NSLog(@"T 360");
        portrait = YES;
    }
    //Getting Dimensions
    float frameWidth = imageView.frame.size.width;
    float frameHeight = imageView.frame.size.height;
    float frameY = imageView.frame.origin.y;
    
    float imageRawWidth = image.size.width;
    float imageRawHeight = image.size.height;
    
    NSLog(@"Image Width %f Image Height %f Frame Width %f Frame Height %f", imageRawWidth,imageRawHeight, frameWidth, frameHeight);
    float frameRatio = frameWidth/frameHeight;
    float imageRatio = imageRawWidth/imageRawHeight;
    NSLog(@"Ratio Image %f Ratio Frame %f",imageRatio, frameRatio);
    
    CGRect frameToCut;
    
    float x, y, w,h;
    
    if(imageRatio > frameRatio)//That means that the image will fill width of the frame
    {
        if(portrait){
            NSLog(@"Portrait");
            //and the height will be proportional to the newly calculated image ratio
            w= frameWidth;
            //calculating h w/h = imageRatio 
            h= w/imageRatio;
            x =0; //because it will take all width of the screen
            //we will need to calculate the y 
            y = (frameHeight - h)/2.0 + frameY;
            frameToCut=CGRectMake(x, y, w, h);
        }
        else{
            NSLog(@"Landscape");
            //We need to switch width and height 
            float newImageRatio = imageRawHeight/imageRawWidth;
            w =frameWidth;// so w in this case is really h
            h= w/newImageRatio;
            x=0; //because it will take all width of the screen
            //we will need to calculate the y 
            y = (frameHeight - h)/2.0 + frameY;
            frameToCut=CGRectMake(x, y, w, h);            
        }
    }
    else{
        if(portrait){
            h = frameHeight;
            w= h * imageRatio;
            y= frameY;
            x= (frameWidth- w)/2.0;
            frameToCut=CGRectMake(x, y, w, h); 
        }
        else{
            
            float newImageRatio = imageRawHeight/imageRawWidth; ///h/w = 
            h = frameHeight;
            w= h*newImageRatio;
            
            y= frameY;
            x= (frameWidth- w)/2.0;
            frameToCut=CGRectMake(x, y, w, h); 
            
        }
    }
    return  frameToCut;
}






-(void)dismissPopover{
        NSLog(@"Delegate Method Just Called");
    if([self amIAnIPad]){

        [moreFramesPopover dismissPopoverAnimated:YES];
    }
}





- (BOOL) amIAnIPad {
#if (__IPHONE_OS_VERSION_MAX_ALLOWED >= 30200)
    if ([[UIDevice currentDevice] respondsToSelector: @selector(userInterfaceIdiom)])
        return ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad);
#endif
    return NO;
}



-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
self= [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if(self)
    {
     
    }   
    return  self;
}

#pragma mark gestures

- (IBAction)resizeFrame:(id)sender {
  if(frameImgView.contentMode==UIViewContentModeScaleAspectFit)
  {
      frameImgView.contentMode=UIViewContentModeScaleToFill;
  }  else{
      frameImgView.contentMode=UIViewContentModeScaleAspectFit;
  }
    
}

- (IBAction)showInfo:(id)sender {
    if([self amIAnIPad]){
    InfoViewController * i=[[InfoViewController alloc]initWithNibName:@"InfoViewController" bundle:nil];
    i.contentSizeForViewInPopover=i.view.frame.size;
    //  [self presentModalViewController:i animated:YES];
    if([infoPop isPopoverVisible])
    {
        [infoPop dismissPopoverAnimated:YES];
    }
    else{
        infoPop=[[UIPopoverController alloc]initWithContentViewController:i];
        [infoPop presentPopoverFromBarButtonItem:infoButton permittedArrowDirections:UIPopoverArrowDirectionDown animated:YES];
        }
    }
    
}



- (IBAction)pinchGestureMethod:(id)gestureRecognizer {
    float k= [(UIPinchGestureRecognizer*)gestureRecognizer scale];   
    float rawWidth=  imgView.frame.size.width;
    float scaledWidth=k* rawWidth;    
    
    if ([gestureRecognizer state] == UIGestureRecognizerStateBegan || [gestureRecognizer state] == UIGestureRecognizerStateChanged) {
        if([self amIAnIPad]){
            if(scaledWidth <MAX_SIZE_IPAD && scaledWidth>MIN_SIZE_IPAD)
            {
                CGAffineTransform transform=CGAffineTransformScale(imgView.transform, k, k);
                imgView.transform=transform;   
                [gestureRecognizer setScale:1];
                
            }
        }
        else{
            if(scaledWidth <MAX_SIZE && scaledWidth>MIN_SIZE)
            {
                CGAffineTransform transform=CGAffineTransformScale(imgView.transform, k, k);
                imgView.transform=transform;   
                [gestureRecognizer setScale:1];
                
            }
        }
    }
    //[self.view bringSubviewToFront:imgView];
    [self preserveHierarchy];
}

- (IBAction)rotationGestureMethod:(id)gestureRecognizer{
    if ([gestureRecognizer state] == UIGestureRecognizerStateBegan || [gestureRecognizer state] == UIGestureRecognizerStateChanged) {
        
        imgView.transform = CGAffineTransformRotate([imgView  transform], [gestureRecognizer rotation]);
        [gestureRecognizer setRotation:0];
    }
    //[self.view bringSubviewToFront:imgView];
    [self preserveHierarchy];
}

- (IBAction)panGestureMethod:(id)gestureRecognizer {

 
    if ([gestureRecognizer state] == UIGestureRecognizerStateBegan || [gestureRecognizer state] == UIGestureRecognizerStateChanged) {
        CGPoint translation = [gestureRecognizer translationInView:[imgView superview]];
        
        [imgView setCenter:CGPointMake([imgView center].x + translation.x, [imgView center].y + translation.y)];
        [gestureRecognizer setTranslation:CGPointZero inView:[imgView superview]];
    }
      [self preserveHierarchy];
}


- (void) touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event{

   // [self.view sendSubviewToBack:imgView];
  //  [self.view bringSubviewToFront:frameImgView];
  //  [self.view insertSubview:frameImgView aboveSubview:imgView];
    [self preserveHierarchy];
}


#pragma mark Action Sheet


- (IBAction)shareActions:(id)sender {
    scrollView.frame=scrollHidden;
    
    UIActionSheet * a=[[UIActionSheet alloc]initWithTitle:@"Share" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:nil];
    
    if([MFMailComposeViewController canSendMail])
    {
        [a addButtonWithTitle:@"Email"];
    }
    
    [a addButtonWithTitle:@"Facebook"];
    [a addButtonWithTitle:@"Twitter"];
    [a addButtonWithTitle:@"Save to Album"];
    [a addButtonWithTitle:@"Sino Weibo"];
   
    [a showInView:self.view];


  
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    if([actionSheet isEqual:photoAction]){
        if(buttonIndex==0) // make photo
        {
            [self startCameraControllerFromViewController:self usingDelegate:self]; 

        }
        else//pick photo
        {
            [self startCameraControllerPickerViewController:self usingDelegate:self];

        }
    }
      else{
    //Creting a crop
        UIGraphicsBeginImageContext(self.view.bounds.size);
        [self.view.layer renderInContext:UIGraphicsGetCurrentContext()];
        
        
        UIImage *myScreenshot = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        CGRect aspectFrame;
        if(frameImgView.contentMode ==UIViewContentModeScaleAspectFit){
            aspectFrame = [self frameForImage:frameImgView.image inImageViewAspectFit:frameImgView];
        }
        else{
            aspectFrame = frameImgView.frame;
        }

        
        CGImageRef imageRef = CGImageCreateWithImageInRect([myScreenshot CGImage], aspectFrame);
        
        UIImage * resultImage = [UIImage imageWithCGImage:imageRef];
        CGImageRelease(imageRef);
        NSURL * url = [NSURL URLWithString:@"http://itunes.apple.com/us/app/scary-pictures/id530522038?ls=1&mt=8"];
        NSString * message = @"Download Scary Pictures";
   if( [[actionSheet buttonTitleAtIndex:buttonIndex]isEqualToString:@"Email"]) 
   {
       MFMailComposeViewController  * mf=[[MFMailComposeViewController alloc]init];
       mf.mailComposeDelegate=self;
       
       //Setting Subject
       NSMutableString * body=[[NSMutableString alloc]initWithCapacity:0]; 
       [body appendString:@"<a href=\"http://itunes.apple.com/us/app/scary-pictures/id530522038?ls=1&mt=8\">Download Scary Pictures App!</a>\n"];

       [mf setSubject:@"Hey, look at this!"];
       [mf setMessageBody:body isHTML:YES];
       
       //Adding Image
       NSData *imageData = UIImagePNGRepresentation(resultImage);
       [mf addAttachmentData:imageData mimeType:@"image/png" fileName:@"CoolImage"];
       [self presentViewController:mf animated:YES completion:nil];
    }

    if( [[actionSheet buttonTitleAtIndex:buttonIndex]isEqualToString:@"Facebook"])
    {
          [socialHelper postMessage:message image:resultImage  andURL:url forService:SLServiceTypeFacebook andTarget:self];
            
    }
        
    if( [[actionSheet buttonTitleAtIndex:buttonIndex]isEqualToString:@"Twitter"])
    {
       [socialHelper postMessage:message image:resultImage  andURL:url forService:SLServiceTypeTwitter andTarget:self];
    
    }
        
    if( [[actionSheet buttonTitleAtIndex:buttonIndex]isEqualToString:@"Sino Weibo"])
    {
        [socialHelper postMessage:message image:resultImage  andURL:url forService:SLServiceTypeSinaWeibo andTarget:self];
            
    }
        
    if( [[actionSheet buttonTitleAtIndex:buttonIndex]isEqualToString:@"Save to Album"]) 
    {
        
        UIImageWriteToSavedPhotosAlbum(resultImage, self, @selector(image:didFinishWithError:contextInfo:), nil);
    }
    }
}

#pragma mark saving image
- (void) image: (UIImage *) image
    didFinishWithError: (NSError *) error
                 contextInfo: (void *) contextInfo{
 if(error!=nil)
 {
     UIAlertView * alert=[[UIAlertView alloc]initWithTitle:@"Error" message:@"Image couldn't be saved at this time." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil];
     [alert show];

 }
 else{
     UIAlertView * alert=[[UIAlertView alloc]initWithTitle:@"Message" message:@"Image was successfully saved." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil];
     [alert show];
 }
}

#pragma mark mail delegate
// The mail compose view controller delegate method

- (void)mailComposeController:(MFMailComposeViewController *)controller

          didFinishWithResult:(MFMailComposeResult)result

                        error:(NSError *)error

{
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

-(void) messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result{


}

- (IBAction)takePhoto:(id)sender {
    
    photoAction=[[UIActionSheet alloc]initWithTitle:@"Share" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"New Photo", @"Photo Library", nil];
    [photoAction showInView:self.view];

        
}
#pragma mark uiactionsheet


- (IBAction)showFrames:(id)sender {

    [UIView beginAnimations:@"a" context:nil];
    [UIView setAnimationDuration:0.3];
      float h=self.view.frame.size.height-scrollViewHeight-toolbar.frame.size.height;
    scrollView.frame=CGRectMake(0, h, self.view.frame.size.width, scrollViewHeight);
    [UIView commitAnimations];

    [self.view addSubview:scrollView];
    NSLog(@"Showing the frames");
    

}




- (IBAction)rateApp:(id)sender {
    rateActionSheet =[[UIActionSheet alloc]initWithTitle:@"Would you like to rate this app and leave us a review?\n\n It will only take a minute and will help make this app better for everyone." delegate:self cancelButtonTitle:@"No" destructiveButtonTitle:@"Rate It" otherButtonTitles: nil];
    [rateActionSheet showInView:self.view];
                      
}

- (IBAction)rotateFrame:(id)sender {
    CGAffineTransform trans= frameImgView.transform;
    frameImgView.transform = CGAffineTransformRotate(trans, degreesToRadians(90));
   
}

- (IBAction)undoToDefaultFrame:(id)sender {
    
    [UIView beginAnimations:@"a" context:nil];
    [UIView setAnimationDuration:0.3];
    imgView.transform = CGAffineTransformIdentity;
    imgView.frame=defaultFrame;
    [UIView commitAnimations];
}

- (void) imagePickerControllerDidCancel: (UIImagePickerController *) picker {
    
    NSLog(@"Cancel ");
    [[picker parentViewController] dismissViewControllerAnimated:YES completion:nil];
     [picker dismissViewControllerAnimated:YES completion:nil];
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    if(  [[ (UITouch *)  [touches.allObjects lastObject]view] isEqual:brightnessView]);{
       NSLog(@"Brightness View ");
        [brightnessView removeFromSuperview];
    }
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    if(  [[ (UITouch *)  [touches.allObjects lastObject]view] isEqual:brightnessView]);{
        NSLog(@"Brightness View Ended");
        [brightnessView removeFromSuperview];

    
    }
    
}

#pragma mark - View lifecycle
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer;{
    //[brightnessView removeFromSuperview];
    return YES;
}



- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _gesture = [[UIGestureRecognizer alloc]initWithTarget:self
                                                  action:nil];
    _gesture.delegate = self;
    [brightnessView addGestureRecognizer:_gesture];
    
    
    socialHelper = [[SocialHelper alloc]init];
    scrollHidden=CGRectMake(0, 1024, 0, 0);
  
    brightnessView = [[UIView alloc]initWithFrame:self.view.bounds];
    brightnessView.backgroundColor = [UIColor blackColor];
    brightnessView.alpha=0;

    [scrollView setContentSize:freeContent.frame.size];
    [scrollView addSubview:freeContent];
    
    scrollView.frame=scrollHidden;
        
    rotationGesture=[[UIRotationGestureRecognizer alloc]initWithTarget:self action:@selector(rotationGestureMethod:)];
    rotationGesture.delegate=self;
 
    panGesture=[[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(panGestureMethod:)];
    panGesture.delegate=self;
  
    pinchGesture=[[UIPinchGestureRecognizer alloc]initWithTarget:self action:@selector(pinchGestureMethod:)];
    pinchGesture.delegate=self;    
    
    [imgView addGestureRecognizer:rotationGesture];
    [imgView addGestureRecognizer:pinchGesture];
    [imgView addGestureRecognizer:panGesture];
    bannerView.autoresizingMask =  UIViewAutoresizingFlexibleWidth;
    
    

    [self layoutForCurrentOrientation:YES];
    if(![self amIAnIPad]){
        infoButton.width=0.01; 
    }
    
}

- (void)viewDidUnload
{
    [self setImgView:nil];
    activityIndicator = nil;
    [self setPinchGesture:nil];
    [self setRotationGesture:nil];
    [self setPanGesture:nil];
    [self setFrameImgView:nil];
    toolbar = nil;
    bannerView = nil;
    scrollView = nil;
    contentView = nil;
  
    cameraBarButton = nil;
    infoButton = nil;
    freeContent = nil;
    brightnessView = nil;
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    //return (interfaceOrientation == UIInterfaceOrientationPortrait);
    return YES;
}

#pragma mark camera
- (BOOL) startCameraControllerFromViewController: (UIViewController*) controller
                                   usingDelegate: (id <UIImagePickerControllerDelegate,
                                                   UINavigationControllerDelegate>) delegate {
    
    if (([UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera] == NO))
        {   UIAlertView * alert=[[UIAlertView alloc]initWithTitle:@"Error" message:@"We were not able to find a camera on this device" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil];
            [alert show];
            return NO;
        }
    
    UIImagePickerController *cameraUI = [[UIImagePickerController alloc] init];
    cameraUI.sourceType = UIImagePickerControllerSourceTypeCamera;
    
    // Displays a control that allows the user to choose picture or
    // movie capture, if both are available:
    cameraUI.mediaTypes =
    [UIImagePickerController availableMediaTypesForSourceType:
     UIImagePickerControllerSourceTypeCamera];
    
    // Hides the controls for moving & scaling pictures, or for
    // trimming movies. To instead show the controls, use YES.
    cameraUI.allowsEditing = YES;
    cameraUI.delegate = self;
    if([self amIAnIPad])
    {
        if(!popoverController.isPopoverVisible){
        popoverController=[[UIPopoverController alloc]initWithContentViewController:cameraUI];
        [popoverController presentPopoverFromBarButtonItem:cameraBarButton permittedArrowDirections:UIPopoverArrowDirectionDown animated:YES];
        }
    }
    else{

        [controller presentViewController:cameraUI animated:YES completion:nil];
    }
    return YES;
}

- (BOOL) startCameraControllerPickerViewController: (UIViewController*) controller
                                   usingDelegate: (id <UIImagePickerControllerDelegate,
                                                   UINavigationControllerDelegate>) delegate {
    
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary] == NO )
    {
        UIAlertView * alert=[[UIAlertView alloc]initWithTitle:@"Error" message:@"We were not able to use photo album on this device" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil];
        [alert show];   
        return NO;
    }
    UIImagePickerController *cameraUI = [[UIImagePickerController alloc] init];
    cameraUI.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    
    // Displays a control that allows the user to choose picture or
    // movie capture, if both are available:
    cameraUI.mediaTypes =[UIImagePickerController availableMediaTypesForSourceType:
                          UIImagePickerControllerSourceTypePhotoLibrary];
    
    // Hides the controls for moving & scaling pictures, or for
    // trimming movies. To instead show the controls, use YES.
    cameraUI.allowsEditing = NO;
    cameraUI.delegate = self;

    if([self amIAnIPad])
    {
        if(!popoverController.isPopoverVisible){
        
        popoverController=[[UIPopoverController alloc]initWithContentViewController:cameraUI];
        [popoverController presentPopoverFromBarButtonItem:cameraBarButton permittedArrowDirections:UIPopoverArrowDirectionDown animated:YES];
        }
    }
    else{
        
       [controller presentViewController:cameraUI animated:YES completion:nil];
    return YES;
    }    
    return YES;    
}



// For responding to the user accepting a newly-captured picture or movie
- (void) imagePickerController: (UIImagePickerController *) picker
 didFinishPickingMediaWithInfo: (NSDictionary *) info {
    
    NSString *mediaType = [info objectForKey: UIImagePickerControllerMediaType];
    NSLog(@"Did Finish Picking");
    UIImage *originalImage, *editedImage;
    
    // Handle a still image capture
    if (CFStringCompare ((__bridge CFStringRef) mediaType, kUTTypeImage, 0)
        == kCFCompareEqualTo) {
        
        originalImage = (UIImage *) [info objectForKey:
                                     UIImagePickerControllerOriginalImage];
        
        if (editedImage) {
            imageToSave = editedImage;
        
        
        } else {
            imageToSave = originalImage;
        }
           
    }
 //    manager.defaultImage=imageToSave;
     [picker dismissViewControllerAnimated:YES completion:nil];
    frameImgView.image=imageToSave;
    [self preserveHierarchy];
    
    
    if([self amIAnIPad])
    {
        [popoverController dismissPopoverAnimated:YES];
    }


}
#pragma mark ADBannerViewDelegate methods

-(void)bannerViewDidLoadAd:(ADBannerView *)banner
{
    [self layoutForCurrentOrientation:YES];
    //banner.hidden=NO;
    NSLog(@"Ad Loaded");
}


-(void)bannerView:(ADBannerView *)banner didFailToReceiveAdWithError:(NSError *)error
{
    [self layoutForCurrentOrientation:YES];
    //banner.hidden=YES;
    NSLog(@"Ad Failed to Load");
}


-(BOOL)bannerViewActionShouldBegin:(ADBannerView *)banner willLeaveApplication:(BOOL)willLeave
{
    return YES;
}



-(void)bannerViewActionDidFinish:(ADBannerView *)banner
{
}


//Orientation changes:

-(void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation{        
      //[self resizeFrameWithOrientation:currentOrientation];
    [self layoutForCurrentOrientation:YES];
}

-(void)layoutForCurrentOrientation:(BOOL)animated
{
    CGFloat animationDuration = animated ? 0.2f : 0.0f;
    CGPoint bannerOrigin = CGPointMake(0, 0);    
    
    if(bannerView.bannerLoaded)
    {
        bannerOrigin.y = 0;
    }
    else
    {   bannerOrigin.y=-100;//bannerHeight;
       
    }

    [UIView animateWithDuration:animationDuration
                     animations:^{
                         bannerView.frame = CGRectMake(bannerOrigin.x, bannerOrigin.y,self.view.frame.size.width, bannerView.frame.size.height);
                         
                         NSLog(@"Banner Frame is: %f %f %f %f",bannerView.frame.origin.x,bannerView.frame.origin.y,bannerView.frame.size.width, bannerView.frame.size.height);
                         [self.view addSubview:bannerView];
                     }];
}


- (IBAction)pickFrame:(id)sender {
    UIImage * img=[(UIButton *) sender currentImage];
    [self.view addSubview:imgView];
    

    [UIView transitionWithView:imgView duration:0.6
     
                       options:
     UIViewAnimationOptionTransitionCrossDissolve
                    animations:^{
                            imgView.image=img;
                    }
                    completion:^(BOOL finished) {
                          [self preserveHierarchy];
                    }];
    
    
    
        [UIView beginAnimations:@"a" context:nil];
        [UIView setAnimationDuration:1];
        scrollView.frame=scrollHidden;
        [UIView commitAnimations];
}


- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if(buttonIndex == 0)//NO
    {
        //[
    }
   }


-(UIImage *)resizeImage:(UIImage *)img{


    return img;
}


-(void)preserveHierarchy{
    [self.view addSubview:bannerView];
    [self.view addSubview:frameImgView];
    [self.view addSubview:imgView];
    [brightnessView removeFromSuperview];

    [self.view addSubview:brightnessView];
       brightnessView.frame = self.view.frame;
    [brightnessView addGestureRecognizer:_gesture];
    _gesture.delegate =self;
    
    
    [self.view addSubview: toolbar];
}


-(void) didReceiveMemoryWarning{
   [super didReceiveMemoryWarning];
    NSLog(@"Inside the memory warning method");
    self.view.backgroundColor=[UIColor whiteColor];
    imgView.image=imageToSave;
}


- (IBAction)changeBrightness:(id)sender {
    NSLog(@"Change brightness to: %f",[(UIStepper *) sender value]);
    brightnessView.alpha =[(UIStepper *) sender value];
    [self preserveHierarchy];
}
@end
