//
//  VIIntroductionPanel.m
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

#import "VIIntroductionView.h"
#import "VIIntroductionPanel.h"

#define IS_RETINA() [[UIScreen mainScreen] respondsToSelector:@selector(scale)] && [[UIScreen mainScreen] scale] == 2.0f

NSInteger const HEADER_VIEW_HEIGHT      = 50;
NSInteger const PAGE_CONTROL_PADDING    =  2;

UIColor * DEFAULT_BACKGROUND_COLOR      = nil;
UIColor * DESCRIPTION_TEXT_COLOR        = nil;
UIColor * HEADER_TEXT_COLOR             = nil;

UIFont * DESCRIPTION_FONT               = nil;
UIFont * HEADER_FONT                    = nil;

@interface VIIntroductionView ()

@property (nonatomic, copy) CompletionBlock completion;
@property (nonatomic, copy) PanelChangeBlock panelChange;

@property (nonatomic, strong) NSArray *panels;
@property (nonatomic, strong) NSMutableArray *panelViews;

@property (nonatomic, strong) UIImage *headerImage;
@property (nonatomic, strong) NSString *headerText;

@property (nonatomic, assign) NSInteger lastPanelIndex;

@property (nonatomic, assign) IBOutlet UIView *view;

//Header properties
@property (nonatomic, weak) IBOutlet UIImageView *headerImageView;
@property (nonatomic, weak) IBOutlet UIView *headerView;

@end

@implementation VIIntroductionView

- (id)initWithFrame:(CGRect)frame panels:(NSArray *)panels
{
    return [self initWithFrame:frame headerImage:nil headerText:nil panels:panels];
}

- (id)initWithFrame:(CGRect)frame headerText:(NSString *)headerText panels:(NSArray *)panels
{
    return [self initWithFrame:frame headerImage:nil headerText:headerText panels:panels];
}

- (id)initWithFrame:(CGRect)frame headerImage:(UIImage *)headerImage panels:(NSArray *)panels
{
    return [self initWithFrame:frame headerImage:headerImage headerText:nil panels:panels];
}

- (id)initWithFrame:(CGRect)frame headerImage:(UIImage *)headerImage headerText:(NSString *)headerText panels:(NSArray *)panels
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        _headerImage = headerImage;
        _headerText = headerText;
        
        [[NSBundle mainBundle] loadNibNamed:@"VIIntroductionView" owner:self options:nil];
        [self addSubview:self.view];
        
        [self sharedInitialize:panels forFrame:frame];
    }
    
    return self;
}


- (void)sharedInitialize:(NSArray*)panels forFrame:(CGRect)frame
{
    
    DEFAULT_BACKGROUND_COLOR = [UIColor colorWithWhite:0 alpha:0.9];
    
    HEADER_FONT = [UIFont fontWithName:@"HelveticaNeue-Light" size:25.0];
    HEADER_TEXT_COLOR = [UIColor whiteColor];
    
    DESCRIPTION_FONT = [UIFont fontWithName:@"HelveticaNeue-Light" size:14.0];
    DESCRIPTION_TEXT_COLOR = [UIColor whiteColor];
    
    _skipAvailable = TRUE;
    _swipeToEndAvailable = TRUE;
    _notifyCompletionBeforeFadeout = TRUE;
    _animateContentAlpha = TRUE;
    _scrollWantsFullscreen = FALSE;
    
    _panelViews = [@[] mutableCopy];
    _panels = [panels copy];
    
}

- (void)willMoveToSuperview:(UIView *)newSuperview
{
    self.frame = [UIScreen mainScreen].bounds;
    [self buildUIWithFrame:self.frame];
}


#pragma mark - UI Builder Methods


- (void)buildUIWithFrame:(CGRect)frame
{
    self.backgroundColor = DEFAULT_BACKGROUND_COLOR;

    [self buildBackgroundImage];
    
    [self buildContentScrollViewWithFrame:frame];
    [self buildFooterView];
    
    [self buildHeaderViewWithFrame:frame];
    
    if ([self.pageControl respondsToSelector:@selector(pageIndicatorTintColor)]) {
        self.pageControl.pageIndicatorTintColor = UIColorFromRGB(0xBFBFBF);
        self.pageControl.currentPageIndicatorTintColor = UIColorFromRGB(0xFFFFFF);
    }
}

- (void)buildBackgroundImage
{
    self.backgroundImageView = [[UIImageView alloc] initWithFrame:self.frame];
    self.backgroundImageView.backgroundColor = [UIColor clearColor];
    self.backgroundImageView.contentMode = UIViewContentModeScaleToFill;
    self.backgroundImageView.autoresizesSubviews = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    [self insertSubview:self.backgroundImageView atIndex:0];
}

- (void)buildHeaderViewWithFrame:(CGRect)frame
{    
    self.headerView.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin;
    self.headerView.backgroundColor = [UIColor clearColor];
    
    //Setup HeaderImageView
    if (self.headerImage) {
        self.headerImageView.contentMode = UIViewContentModeScaleAspectFit;
        self.headerImageView.image = self.headerImage;

    } else if (self.headerText) {
        
        //Setup HeaderLabel
        self.headerLabel.font = HEADER_FONT;
        self.headerLabel.textColor = HEADER_TEXT_COLOR;
        self.headerLabel.textAlignment = NSTextAlignmentCenter;
        self.headerLabel.text = self.headerText;
    }
    
}

- (void)buildContentScrollViewWithFrame:(CGRect)frame
{
    self.contentScrollView.pagingEnabled = YES;
    self.contentScrollView.showsHorizontalScrollIndicator = NO;
    self.contentScrollView.showsVerticalScrollIndicator = NO;
    self.contentScrollView.delegate = self;
    self.contentScrollView.clipsToBounds = YES;
    
    //If panels exist, build views for them and add them to the ContentScrollView
    if (self.panels) {
        if (self.panels.count > 0) {
            
            //A running x-coordinate. This grows for every page
            CGFloat contentXIndex = 0;
            for (int ii = 0; ii < self.panels.count; ii++) {
                
                //Create a new view for the panel and add it to the array
                [self.panelViews addObject:[self.panels[ii] viewForPanel:self atXIndex:&contentXIndex]];
                
                //Add the newly created panel view to ContentScrollView
                [self.contentScrollView addSubview:self.panelViews[ii]];
            }
            
            
            [self makePanelVisibleAtIndex:0];
            
            //Dynamically sizes the content to fit the text content
            [self setContentScrollViewHeightForPanelIndex:0 animated:NO];
            
            //Add a view at the end. This is simply "something to scroll toward" on the final panel.
            [self appendCloseViewAtXIndex:&contentXIndex];
            
            //Finally, resize the content size of the scrollview to account for all the new views added to it
            [self setSwipeToEndAvailable:self.swipeToEndAvailable];
            
            //Add the ContentScrollView to the introduction view
        }
    }
}

- (void)appendCloseViewAtXIndex:(CGFloat*)xIndex
{
    UIView *closeView = [[UIView alloc] initWithFrame:CGRectMake(*xIndex, 0, self.frame.size.width, 400)];
    
    [self.contentScrollView addSubview:closeView];
    
     *xIndex += self.contentScrollView.frame.size.width;
}

- (void)buildFooterView
{
    self.pageControl.numberOfPages = _panels.count;
    
    if (self.skipAvailable) {
        [self.endIntroButton setAlpha:1];
    }else{
        [self.endIntroButton setAlpha:0];
    }
}

- (void)setContentScrollViewHeightForPanelIndex:(NSInteger)panelIndex animated:(BOOL)animated
{
    CGFloat newPanelHeight = [_panelViews[panelIndex] frame].size.height;

    if (self.scrollWantsFullscreen) {
        newPanelHeight = self.frame.size.height;
    }
    
    self.contentScrollView.frame = CGRectMake(self.contentScrollView.frame.origin.x,
                                              self.contentScrollView.frame.origin.y,
                                              self.contentScrollView.frame.size.width,
                                              newPanelHeight);
    
    if (animated){
        [UIView animateWithDuration:0.3 animations:^{
            [self layoutFrame:panelIndex];
            [self juggleSkipButton:panelIndex];
        }];
    } else {
        [self layoutFrame:panelIndex];
        [self juggleSkipButton:panelIndex];
    }
    
    self.contentScrollView.contentSize = CGSizeMake(self.contentScrollView.contentSize.width, newPanelHeight);
}

- (void)layoutFrame:(NSInteger)panelIndex
{
    if ([self.panels[panelIndex] respondsToSelector:@selector(frameForPageControl:)]) {
        self.pageControl.frame = [self.panels[panelIndex] frameForPageControl:self];
    }
    
    if ([self.panels[panelIndex] respondsToSelector:@selector(frameForDoneButton:)]) {
        self.endIntroButton.frame = [self.panels[panelIndex] frameForDoneButton:self];
    }
}

- (void)juggleSkipButton:(NSInteger)panelIndex
{
    if ((!self.skipAvailable && panelIndex == (self.panelViews.count-1)) || self.skipAvailable) {
        [self.endIntroButton setAlpha:1];
    } else if (!self.skipAvailable && panelIndex != (self.panelViews.count-1)) {
        [self.endIntroButton setAlpha:0];
    }
}

#pragma mark - Header Content

- (void)setHeaderText:(NSString *)headerText
{
    _headerLabel.hidden = NO;
    _headerImageView.hidden = YES;
    _headerLabel.text = headerText;
}

- (void)setHeaderImage:(UIImage *)headerImage
{
    _headerLabel.hidden = YES;
    _headerImageView.hidden = NO;
    _headerImageView.image = headerImage;
}

#pragma mark - Show/Hide

- (void)showInView:(UIView *)view{
    //Add introduction view
    self.alpha = 0;
    
    [view addSubview:self];
    
    //Fade in
    [UIView animateWithDuration:0.3 animations:^{
        self.alpha = 1;
    }];
}

- (void)showInView:(UIView *)view withCompletion:(CompletionBlock)completion andPanelChange:(PanelChangeBlock)panelChange
{
    self.panelChange = panelChange;
    [self showInView:view withCompletion:completion];
}

- (void)showInView:(UIView *)view withCompletion:(CompletionBlock)completion
{
    self.completion = completion;
    [self showInView:view];
}

- (void)hideForFinishType:(FinishType)type withFadeOutDuration:(CGFloat)duration
{
    //Fade out
    [UIView animateWithDuration:duration animations:^{
        self.alpha = 0;
    } completion:^(BOOL finished) {
        if (!self.notifyCompletionBeforeFadeout) {
            [self cleanupViewAndEndWithType:type];
        }
    }];
}

- (void)hideWithFadeOutDuration:(CGFloat)duration
{
    //Fade out
    [UIView animateWithDuration:duration animations:^{
        self.alpha = 0;
    } completion:nil];
}

- (void)removeWithFadeOutDuration:(CGFloat)duration
{
    //Fade out
    [UIView animateWithDuration:duration animations:^{
        self.alpha = 0;
    } completion:^(BOOL finished) {
        [self cleanupViewAndEndWithOutCallbacks];
    }];
}

- (void)makePanelVisibleAtIndex:(NSInteger)panelIndex
{
    if (self.animateContentAlpha) {
        [UIView animateWithDuration:0.3 animations:^{
            for (int ii = 0; ii < self.panelViews.count; ii++) {
                
                if (ii == panelIndex) {
                    [self.panelViews[ii] setAlpha:1];
                } else {
                    [self.panelViews[ii] setAlpha:0];
                }
            }
        }];
    }
}

- (IBAction)skipIntroduction:(id)sender
{
    if (self.notifyCompletionBeforeFadeout) {
        
        if ([(id)self.delegate respondsToSelector:@selector(introduction:didFinishWithType:)]) {
        
            [self.delegate introduction:self didFinishWithType:FinishTypeSkipButton];

        } else if (self.completion){
            
            self.completion(FinishTypeSkipButton);
        }
        
        [self removeWithFadeOutDuration:.3];
    } else {
        
        [self hideForFinishType:FinishTypeSkipButton withFadeOutDuration:0.3];
    }
}

#pragma mark - UIScrollView Delegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    self.currentPanelIndex = scrollView.contentOffset.x/self.contentScrollView.frame.size.width;
    
    //remove self if you are at the end of the introduction
    if (self.currentPanelIndex == (self.panelViews.count)) {

        dispatch_async(dispatch_get_main_queue(), ^{
            [self cleanupViewAndEndWithType:FinishTypeSwipeOut];
        });
        
    } else {
        
        //Update Page Control
        self.lastPanelIndex = self.pageControl.currentPage;
        self.pageControl.currentPage = self.currentPanelIndex;
        
        //Format and show new content
        [self setContentScrollViewHeightForPanelIndex:self.currentPanelIndex animated:YES];
        
        [self makePanelVisibleAtIndex:(NSInteger)self.currentPanelIndex];
        
        //Call Back, if applicable
        if (self.lastPanelIndex != self.currentPanelIndex) {
            //Keeps from making the callback when just bouncing and not actually changing pages
            if ([(id)self.delegate respondsToSelector:@selector(introductionDidChangeToPanel:withIndex:)]) {
                
                [self.delegate introductionDidChangeToPanel:self.panels[self.currentPanelIndex] withIndex:self.currentPanelIndex];
                
            } else if (self.panelChange) {
                
                self.panelChange(self.panels[self.currentPanelIndex], self.currentPanelIndex);
            }
        }
    }
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    self.currentPanelIndex = scrollView.contentOffset.x/self.contentScrollView.frame.size.width;
    
    self.lastPanelIndex = self.pageControl.currentPage;
    self.pageControl.currentPage = self.currentPanelIndex;
    
    [self setContentScrollViewHeightForPanelIndex:self.currentPanelIndex animated:YES];
    [self makePanelVisibleAtIndex:(NSInteger)self.currentPanelIndex];
    

    if (self.lastPanelIndex != self.currentPanelIndex) {
        
        if ([(id)self.delegate respondsToSelector:@selector(introductionDidChangeToPanel:withIndex:)]) {
            
            [self.delegate introductionDidChangeToPanel:self.panels[self.currentPanelIndex] withIndex:self.currentPanelIndex];
            
        } else if (self.panelChange) {
            
            self.panelChange(self.panels[self.currentPanelIndex], self.currentPanelIndex);
        }
    }
    
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    CGFloat currentX = self.contentScrollView.contentOffset.x;
    
    if ((self.currentPanelIndex == (self.panelViews.count - 1) && self.swipeToEndAvailable )) {
        CGFloat lastPanelX = (self.contentScrollView.frame.size.width*self.panelViews.count);
        self.alpha = (lastPanelX -currentX)/self.contentScrollView.frame.size.width;
    }
    
    if (!self.skipAvailable) {
        CGFloat secondToLastPanelX = self.contentScrollView.frame.size.width * (self.panelViews.count-2);
        self.endIntroButton.alpha = (currentX-secondToLastPanelX) / self.contentScrollView.frame.size.width;
    }
}

- (IBAction)pageChanged:(UIPageControl*)control
{
    [self.view bringSubviewToFront:self.endIntroButton];
    NSLog(@"Page Changed %d", control.currentPage);
    [self.contentScrollView setContentOffset:CGPointMake((self.contentScrollView.frame.size.width*control.currentPage), 0)
                                    animated:YES];

}

#pragma mark Getters


#pragma mark Setters

- (void)setSwipeToEndAvailable:(BOOL)swipeToEndAvailable
{
    _swipeToEndAvailable = swipeToEndAvailable;
    
    CGFloat sizeWithSwipeToEnd = self.contentScrollView.frame.size.width * (self.panels.count+1);
    CGFloat sizeWithOutSwipeToEnd = self.contentScrollView.frame.size.width * (self.panels.count);
    
    NSLog(@"with %f without %f", sizeWithSwipeToEnd, sizeWithOutSwipeToEnd);
    
    if (self.swipeToEndAvailable) {
        [self.contentScrollView setContentSize:CGSizeMake(sizeWithSwipeToEnd,
                                                          self.contentScrollView.contentSize.height)];
    }else{
        [self.contentScrollView setContentSize:CGSizeMake(sizeWithOutSwipeToEnd,
                                                          self.contentScrollView.contentSize.height)];
    }
}

- (void)setSkipAvailable:(BOOL)skipAvailable
{
    _skipAvailable = skipAvailable;
    [self juggleSkipButton:self.currentPanelIndex];
}

- (void)setScrollWantsFullscreen:(BOOL)scrollWantsFullscreen
{
    
    _scrollWantsFullscreen = scrollWantsFullscreen;
    if (scrollWantsFullscreen) {
        [self.contentScrollView setFrame:CGRectMake(0, 0,
                                                    self.frame.size.width,
                                                    self.frame.size.height)];
    }
}

- (void)setBackgroundImage:(UIImage *)backgroundImage
{
    if (self.backgroundImageView == nil) {
        [self buildBackgroundImage];
    }
    
    self.backgroundImageView.image = backgroundImage;
}

- (void)setAnimateContentAlpha:(BOOL)animateContentAlpha
{
    _animateContentAlpha = animateContentAlpha;
    
    if (animateContentAlpha) {
        [self makePanelVisibleAtIndex:self.currentPanelIndex];
    }else{
        for (UIView *panel in self.panelViews) {
            [panel setAlpha:1];
        }
    }
}


#pragma mark Memory Management

- (void)cleanupViewAndEndWithType:(FinishType)type
{
    [self cleanVariables];
    [self cleanPanelViews];
    
    [self cleanPanelData];
    
    if ([(id)self.delegate respondsToSelector:@selector(introduction:didFinishWithType:)]) {
        [self.delegate introduction:self didFinishWithType:type];
    } else if (self.completion){
        self.completion(type);
    }

    self.completion = nil;
    self.panelChange = nil;
}

- (void)cleanupViewAndEndWithOutCallbacks
{
    [self cleanVariables];
    
    self.completion = nil;
    self.panelChange = nil;

    [self cleanPanelViews];
    [self cleanPanelData];
    [self removeFromSuperview];
}

- (void)cleanPanelViews
{
    for (UIView *view in self.panelViews) {
        [view removeFromSuperview];
    }
    
    [self.panelViews removeAllObjects];
    self.panelViews = nil;
}

- (void)cleanPanelData
{
    for (VIIntroductionPanel *panel in self.panels) {
        [panel cleanForDealloc];
    }
    
    self.panels = nil;
}

- (void)cleanVariables
{
    [self.headerLabel removeFromSuperview];
    self.headerLabel = nil;
    
    [self.headerImageView removeFromSuperview];
    self.headerImageView = nil;
    
    [self.backgroundImageView removeFromSuperview];
    self.backgroundImageView = nil;
    
    [self.headerView removeFromSuperview];
    self.headerView = nil;
    
    [self.contentScrollView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [self.contentScrollView removeFromSuperview];

    self.contentScrollView.delegate = nil;
    self.contentScrollView = nil;
    
    [self.pageControl removeFromSuperview];
    self.pageControl = nil;
}

- (void)dealloc
{
    NSLog(@"Congrats, dealloc'd %@", self.description);
}
@end
