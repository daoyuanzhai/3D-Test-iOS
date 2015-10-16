//
//  WelcomePageViewController.m
//  3D Test
//
//  Created by Daoyuan Zhai on 10/14/15.
//  Copyright © 2015 Daoyuan Zhai. All rights reserved.
//

#import "WelcomePageViewController.h"


@interface WelcomePageViewController ()

@property (weak, nonatomic) IBOutlet UIButton *buttonFacebook;
@property (nonatomic) ICETutorialController* subController;

@end

@implementation WelcomePageViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.buttonFacebook.backgroundColor = [UIColor clearColor];
    [self.buttonFacebook setTitle:NSLocalizedString(@"connect_with_facebook", nil) forState:UIControlStateNormal];
    [self.buttonFacebook setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.buttonFacebook setTitleColor:[UIColor blackColor] forState:(UIControlStateHighlighted | UIControlStateSelected)];
    [self.buttonFacebook setBackgroundImage:[self imageWithColor:[UIColor colorWithRed:(59/255.0) green:(89/255.0) blue:(152/255.0) alpha:1.0]] forState:UIControlStateNormal];
    [self.buttonFacebook setBackgroundImage:[self imageWithColor:[UIColor colorWithRed:(59/255.0) green:(59/255.0) blue:(100/255.0) alpha:1.0]] forState:(UIControlStateHighlighted | UIControlStateSelected)];
    
    [self setupSubView];
}

-(void) setupSubView {
    
    // Init the pages texts, and pictures.
    ICETutorialPage *layer1 = [[ICETutorialPage alloc] initWithTitle:@""
                                                            subTitle:@""
                                                         pictureName:@"welcome_screen_01.png"
                                                            duration:3.0];
    ICETutorialPage *layer2 = [[ICETutorialPage alloc] initWithTitle:@""
                                                            subTitle:@""
                                                         pictureName:@"welcome_screen_02.png"
                                                            duration:3.0];
    ICETutorialPage *layer3 = [[ICETutorialPage alloc] initWithTitle:@""
                                                            subTitle:@""
                                                         pictureName:@"welcome_screen_03.png"
                                                            duration:3.0];
    ICETutorialPage *layer4 = [[ICETutorialPage alloc] initWithTitle:@""
                                                            subTitle:@""
                                                         pictureName:@"welcome_screen_04.png"
                                                            duration:3.0];
    ICETutorialPage *layer5 = [[ICETutorialPage alloc] initWithTitle:@""
                                                            subTitle:@""
                                                         pictureName:@"welcome_screen_05.png"
                                                            duration:3.0];
    
    NSArray *tutorialLayers = @[layer1,layer2,layer3,layer4,layer5];
    
    // Set the common style for the title.
    ICETutorialLabelStyle *titleStyle = [[ICETutorialLabelStyle alloc] init];
    [titleStyle setFont:[UIFont fontWithName:@"Helvetica-Bold" size:17.0f]];
    [titleStyle setTextColor:[UIColor whiteColor]];
    [titleStyle setLinesNumber:1];
    [titleStyle setOffset:180];
    [[ICETutorialStyle sharedInstance] setTitleStyle:titleStyle];
    
    // Set the subTitles style with few properties and let the others by default.
    [[ICETutorialStyle sharedInstance] setSubTitleColor:[UIColor whiteColor]];
    [[ICETutorialStyle sharedInstance] setSubTitleOffset:150];
    
    self.subController = [[ICETutorialController alloc] initWithPages:tutorialLayers delegate:self];
    // [self.subController startScrolling];

    [self addChildViewController:self.subController];
    [[self view] addSubview:[self.subController view]];
    [self.subController view].frame = CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width, [[UIScreen mainScreen] bounds].size.height - 60);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(UIImage *)imageWithColor:(UIColor *)color {
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - ICETutorialController delegate
- (void)tutorialController:(ICETutorialController *)tutorialController scrollingFromPageIndex:(NSUInteger)fromIndex toPageIndex:(NSUInteger)toIndex {
    NSLog(@"Scrolling from page %lu to page %lu.", (unsigned long)fromIndex, (unsigned long)toIndex);
}

- (void)tutorialControllerDidReachLastPage:(ICETutorialController *)tutorialController {
    NSLog(@"Tutorial reached the last page.");
}

- (void)tutorialController:(ICETutorialController *)tutorialController didClickOnLeftButton:(UIButton *)sender {
    NSLog(@"Button 1 pressed.");
}

- (void)tutorialController:(ICETutorialController *)tutorialController didClickOnRightButton:(UIButton *)sender {
    NSLog(@"Button 2 pressed.");
    NSLog(@"Auto-scrolling stopped.");
    
    [self.subController stopScrolling];
}

@end
