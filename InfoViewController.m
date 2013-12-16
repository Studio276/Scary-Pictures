//
//  InfoViewController.m
//  My World
//


#import "InfoViewController.h"


@implementation InfoViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}


- (IBAction)openAppStore:(id)sender {
     if([sender tag]==0)
    {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"itms://itunes.apple.com/us/app/math-stars/id447998622?ls=1&mt=8"]];
    }
    else{
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"itms://itunes.apple.com/us/book/developing-ios-5-applications/id511626472?mt=11"]];
    }
}

- (IBAction)dismissInfoView:(id)sender {
        [self dismissViewControllerAnimated:YES completion:nil];
}






- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    //Setting up sroll view
    [scrollView setContentSize:infoSubView.frame.size];
    [scrollView addSubview:infoSubView];
    scrollView.scrollEnabled=YES;

    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    infoSubView = nil;

    scrollView = nil;

    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
