//
//  VIIntroductionView.h
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

#import <UIKit/UIKit.h>
#import "VIIntroductionPanel.h"
#import <QuartzCore/QuartzCore.h>

typedef enum {
    FinishTypeSwipeOut,
    FinishTypeSkipButton
} FinishType;

typedef void(^CompletionBlock)(FinishType finishType);
typedef void(^PanelChangeBlock)(VIIntroductionPanel* panel, NSInteger index);

@class VIIntroductionView;
@protocol VIIntroductionDelegate

@optional
- (void)introduction:(VIIntroductionView*)introductionView didFinishWithType:(FinishType)finishType;
- (void)introductionDidChangeToPanel:(VIIntroductionPanel *)panel withIndex:(NSInteger)panelIndex;
@end


/******************************/
//VIIntroductionView
/******************************/
@interface VIIntroductionView : UIView <UIScrollViewDelegate>

/******************************/
//Properties
/******************************/

//Delegate
@property (weak) id <VIIntroductionDelegate> delegate;

//Panel management
@property (nonatomic, assign) NSInteger currentPanelIndex;

//Intoduction Properties
@property (nonatomic, strong) UIImageView *backgroundImageView;

//Header properties
@property (nonatomic, strong) UILabel *headerLabel;
@property (nonatomic, strong) UIImageView *headerImageView;
@property (nonatomic, strong) UIView *headerView;

//Content properties
@property (nonatomic, strong) UIScrollView *contentScrollView;

//PageControl/Skip Button
@property (nonatomic, strong) UIPageControl *pageControl;
@property (nonatomic, strong) UIButton *endIntroButton;


//Customization Settings

//Setting this to FALSE will fade in the End Tutorial Button as the Last Panel slides in.
//Defaults to TRUE
@property (nonatomic, assign) BOOL skipAvailable;

//Setting this to FALSE will require the End Tutorial Button to be hit to remove the tutorial from the view;
//Defaults to TRUE
@property (nonatomic, assign) BOOL swipeToEndAvailable;

//Setting this to TRUE will force images to take up the full screen of the panel
//If you set this to TRUE, the UIPageControl and endIntroButton will not be moved or resized, and will be pinned to the bottom of the screen, or where ever you choose to set them after initialization.
//If a description is set for panels, it will obey textCenter property set on each panel.
//Defaults to FALSE
@property (nonatomic, assign) BOOL imagesWantFullscreen;

//Setting this to FALSE will force the fadeout to complete before completion is called.
//Defaults to TRUE so that your view can prepare for Fadeout on Skip.
@property (nonatomic, assign) BOOL notifyCompletionBeforeFadeout;


//Setting this to FALSE will cause content to be constantly shown, rather than alpha'd in on page settle. 
//Defaults to TRUE
@property (nonatomic, assign) BOOL animateContentAlpha;


/******************************/
//Methods
/******************************/

//Custom Init Methods
- (id)initWithFrame:(CGRect)frame headerText:(NSString *)headerText panels:(NSArray *)panels;
- (id)initWithFrame:(CGRect)frame headerImage:(UIImage *)headerImage panels:(NSArray *)panels;


//Use this to construct a intro with no header
- (id)initWithFrame:(CGRect)frame panels:(NSArray *)panels;

//Header Content
- (void)setHeaderText:(NSString *)headerText;
- (void)setHeaderImage:(UIImage *)headerImage;

//Introduction Content
- (void)setBackgroundImage:(UIImage *)backgroundImage;

//Show/Hide

//**NOTE** Be sure to removeFromSuperview the returned Intro view in your completion block,
//         as well as nil any other references.
- (void)showInView:(UIView *)view withCompletion:(CompletionBlock)completion andPanelChange:(PanelChangeBlock)panelChange;
- (void)showInView:(UIView *)view withCompletion:(CompletionBlock)completion;

//**NOTE** Use delegate Protocol, or you'll end up leaking memory.
- (void)showInView:(UIView *)view;

//To Remove the view on your own, use this call. Your delegate methods will still be called.
- (void)cleanupViewAndEndWithType:(FinishType)type;

//This will clean and remove the view without callbacks
- (void)cleanupViewAndEndWithOutCallbacks;

//Calling this will simply temporarily hide the view, it will not clean it for dealloc.
- (void)hideWithFadeOutDuration:(CGFloat)duration;

@end
