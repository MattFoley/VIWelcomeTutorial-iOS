VIIntroductionView
================================

This class was built using MYIntroductionView which was created by Matthew York and can be found here: https://github.com/MatthewYork/iPhone-IntroductionTutorial

I needed a lot more customization and functionality, and this is the result.


Requirements
========================

This project requires ARC and the QuartzCore framework


Installation
========================

- Add the QuartzCore framework by clicking on your Project File -> Build Phases -> Link Binary With Libraries
- Add `VIIntroductionView.h` and `VIIntroductionView.m` to your project.
- Add `VIIntroductionPanel.h` and `VIIntroductionPanel.m` to your project.
- `#import "VIIntroductionView.h"` to use it in a class
- Either setup a VIIntroductionViewDelegate, or run your Introduction with one of the block methods.

Some Sample Images
========================

![BackgroundImage](http://i.imgur.com/1dbUi3C.png)      ![Fullscreen](http://i.imgur.com/l8q3a7u.png)


How To Use It?
========================

Constructing your Introductions Content
------------------------

An introduction is usually made up of multiple example images, with some optional text. To create a panel, simply call one of the `initWithImage:…` methods. Here are some examples, simple to more complicated.

    VIIntroductionPanel *panel1 = [[VIIntroductionPanel alloc] initWithimage:[UIImage imageNamed:@"SampleImage1"]];

    VIIntroductionPanel *panel2 = [[VIIntroductionPanel alloc] initWithimage:[UIImage imageNamed:@"SampleImage1"] description];
  
    VIIntroductionPanel *panel3 = [[VIIntroductionPanel alloc] initWithImage:[UIImage imageNamed:@"SampleImage2"] description:@"VIIntroductionView is your ticket to a great tutorial or introduction!" andTextCenter:CGPointMake(160, self.view.frame.size.height-80)];

    
Creating an Introduction
-----------------------
Once you panels have been created,  you are ready to create the introduction view. You will pass the panels you just created into this method where they will be rendered (in order) in the introduction view. An example can be found below.

    VIIntroductionView *introductionView = [[VIIntroductionView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) headerImage:[UIImage imageNamed:@"SampleHeaderImage.png"] panels:@[panel, panel2, panel3]];

Don't forget to set the delegate to the calling class if you are using delegation for any callbacks and setup your delegate methods:

    introductionView.delegate = self;

    - (void)introduction:(VIIntroductionView*)introductionView didFinishWithType:(FinishType)finishType{
 if (finishType == FinishTypeSkipButton) {
            NSLog(@"Did Finish Introduction By Skipping It");
        } else if (finishType == FinishTypeSwipeOut){
            NSLog(@"Did Finish Introduction By Swiping Out");
        }
        
        [introductionView removeFromSuperview];
}


Starting the Introduction
-----------------------

If you're using the delegate protocol, show your view using:
    
    [introductionView showInView:self.view];

Otherwise, show your introduction with Blocks:

    [introductionView showInView:self.view withCompletion:^(FinishType finishType) {
        if (finishType == FinishTypeSkipButton) {
            NSLog(@"Did Finish Introduction By Skipping It");
        } else if (finishType == FinishTypeSwipeOut){
            NSLog(@"Did Finish Introduction By Swiping Out");
        }
        
        [introductionView removeFromSuperview];
    } andPanelChange:^(VIIntroductionPanel *panel, NSInteger index) {
            NSLog(@"%@ \nPanelIndex: %d", panel.description, index);
    }];


Customization
=======================

VIIntroductionView.h lists out the following properties for customization:
-----------------------

- skipAvailable: This variable defaults to TRUE and dictates whether endIntroButton is visible before the final panel. Turning it off will cause endIntroButton to fade in as you swipe into the final panel.

- swipeToEndAvailable: This variable defaults to TRUE and dictates whether or not a user can exit the tutorial by swiping past the final panel. If FALSE, a user must tap the endIntroButton to remove the tutorial.

- imagesWantFullscreen: This variable defaults to FALSE. If you plan on showing full screen images, you must set this variable to TRUE. When set to TRUE your PageControl and Exit Button will be pinned to the bottom of the view. The descriptionText label for panels will no longer be dynamically positioned and will obey each VIIntroductionPanel's textCenter property.

- notifyCompletionBeforeFadeout: This variable defaults to TRUE, this way your delegate completion callback or block will be called before the Introduction view begins fading, so that you may prepare for it to be removed by constructing your next view. If your next view is already constructed, set this to FALSE and your callback/block will be called on the fade of the view. (If set to FALSE, you must remove the Introduction view from your view hierarchy yourself)

- animateContentAlpha: This variable defaults to TRUE, which dictates that each panel's content will be faded in when a panel has settled. Setting this to FALSE will keep each panel's content visible for the entire tutorial.

VIIntroductionPanel.h lists out the following properties for customization:
-----------------------

- font: If this is set, the panel's label will be set to this font. Otherwise, the font will default to the value set at #define DESCRIPTION_FONT in VIIntroductionView.h.

- textColor: If this is set, the panel's label will be set to this text color. Otherwise, the font will default to the value set at #define DESCRIPTION_TEXT_COLOR in VIIntroductionView.h.

- textAlignment: If this is set, the panel's label will be set to this alignment. Otherwise, it will default to NSTextAlignmentCenter.

- textCenter: If this is set, the panel's label will be centered to this position. Otherwise, it will be positioned dynamically underneath the Image set for the panel.




