//
//  VIViewController.m
//  IntroductionExample
//
//  Rebuilt and Expanded upon by Thomas Fallon 3/18/13
//
//  Special thanks to MYIntroductionView and Matthew York - https://github.com/MatthewYork/iPhone-IntroductionTutorial
//
//  Original License:
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy of
//  this software and associated documentation files (the "Software"), to deal in
//  the Software without restriction, including without limitation the rights to
//  use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies
//  of the Software, and to permit persons to whom the Software is furnished to do
//  so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//  SOFTWARE.
//

#import "VIViewController.h"
#import "VIIntroductionPanel.h"

@interface VIViewController ()

@end

@implementation VIViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)viewDidAppear:(BOOL)animated{
    
    VIIntroductionPanel *panel = [[VIIntroductionPanel alloc] initWithImage:[UIImage imageNamed:@"SampleImage1"]
                                                                description:@"Welcome to VIIntroductionView, your 100 percent customizable interface for introductions and tutorials! Simply add a few classes to your project, and you are ready to go!"
                                                              andTextCenter:CGPointMake(160, self.view.frame.size.height-80)];
    
    VIIntroductionPanel *panel2 = [[VIIntroductionPanel alloc] initWithImage:[UIImage imageNamed:@"SampleImage2"]
                                                                 description:@"VIIntroductionView is your ticket to a great tutorial or introduction!"
                                                               andTextCenter:CGPointMake(160, self.view.frame.size.height-80)];
    
    
    VIIntroductionPanel *panel3;
    if ([UIScreen mainScreen].bounds.size.height == 568) {
        panel3 = [[VIIntroductionPanel alloc] initWithImage:[UIImage imageNamed:@"FullscreenSample_phone5"]
                                                description:@"This is a fullscreen Example"
                                              andTextCenter:self.view.center];
    }else{
        panel3 = [[VIIntroductionPanel alloc] initWithImage:[UIImage imageNamed:@"FullscreenSample"]
                                                description:@"This is a fullscreen Example"
                                              andTextCenter:self.view.center];
    }
    
    [panel3 setImageWantsFullscreen:YES];
    
    [panel3 setFont:[UIFont boldSystemFontOfSize:30]];
    [panel3 setTextColor:[UIColor blackColor]];
    
    VIIntroductionView *introductionView = [[VIIntroductionView alloc] initWithFrame:CGRectMake(0, 0,
                                                                                                self.view.frame.size.width,
                                                                                                self.view.frame.size.height)
                                                                          headerText:@"VIIntroductionView"
                                                                              panels:@[panel, panel2, panel3]];
    
    [introductionView setBackgroundImage:[UIImage imageNamed:@"SampleBackground"]];
    
    
    
    //Set delegate to self for callbacks (optional)
    
    //introductionView.delegate = self;
    introductionView.skipAvailable = NO;
    introductionView.swipeToEndAvailable = NO;
    introductionView.scrollWantsFullscreen = YES;
    introductionView.notifyCompletionBeforeFadeout = NO;
    introductionView.animateContentAlpha = YES;
    
    [introductionView showInView:self.view withCompletion:^(FinishType finishType) {
        if (finishType == FinishTypeSkipButton) {
            NSLog(@"Did Finish Introduction By Skipping It");
        } else if (finishType == FinishTypeSwipeOut){
            NSLog(@"Did Finish Introduction By Swiping Out");
        }
        
        [introductionView removeFromSuperview];
    } andPanelChange:^(VIIntroductionPanel *panel, NSInteger index) {
            NSLog(@"%@ \nPanelIndex: %d", panel.descriptionText, index);
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - Sample Delegate Methods

- (void)introduction:(VIIntroductionView*)introductionView didFinishWithType:(FinishType)finishType{
    if (finishType == FinishTypeSkipButton) {
        NSLog(@"Did Finish Introduction By Skipping It");
    } else if (finishType == FinishTypeSwipeOut){
        NSLog(@"Did Finish Introduction By Swiping Out");
    }
    
    [introductionView removeFromSuperview];
}

- (void)introductionDidChangeToPanel:(VIIntroductionPanel *)panel withIndex:(NSInteger)panelIndex{
    NSLog(@"%@ \nPanelIndex: %d", panel.descriptionText, panelIndex);
}

@end
