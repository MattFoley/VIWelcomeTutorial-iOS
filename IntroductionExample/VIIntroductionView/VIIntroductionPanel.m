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

#import "VIIntroductionPanel.h"
#import "VIIntroductionView.h"

@implementation VIIntroductionPanel

- (id)initWithImage:(UIImage *)image description:(NSString *)description textCenter:(CGPoint)textCenter andFont:(UIFont*)font
{
    if (self = [super init]) {
        [self sharedInit];
        
        _image = image;
        _descriptionText = [description copy];
        _font = font;
        _textCenter = textCenter;
    }
    
    return self;
}

- (id)initWithImage:(UIImage *)image description:(NSString *)description andTextCenter:(CGPoint)textCenter
{
    return [self initWithImage:image description:description textCenter:textCenter andFont:nil];
}

- (id)initWithImage:(UIImage *)image description:(NSString *)description
{
    return [self initWithImage:image description:description andTextCenter:CGPointZero];
}

- (id)initWithImage:(UIImage *)image
{
    return [self initWithImage:image description:nil];
}

- (void)sharedInit
{
    _textCenter = CGPointZero;
    _textAlignment = NSTextAlignmentCenter;
    
    _textColor = nil;
    _font = nil;
    _imageWantsFullscreen = NO;
}

- (void)cleanForDealloc
{
    _image = nil;
    _descriptionText = nil;
    _font = nil;
    _textColor = nil;
}

#pragma mark Layout Methods - Must Be Overidden in Subclasses

//This is not super pretty, but just an example of a simple programmatically built view.
- (UIView *)viewForPanel:(VIIntroductionView *)view atXIndex:(CGFloat*)xIndex
{
    //Build panel now that we have all the desired dimensions
    UIView *panelView = [[UIView alloc] initWithFrame:CGRectMake(*xIndex, 0, view.contentScrollView.frame.size.width, 0)];
    CGFloat maxScrollViewHeight = view.frame.size.height - view.contentScrollView.frame.origin.y - (36+PAGE_CONTROL_PADDING);
    
    CGFloat imageHeight = MIN(self.image.size.height, view.frame.size.height);
    
    
    UIImageView *panelImageView = [[UIImageView alloc] initWithImage:self.image];
    if (self.imageWantsFullscreen) {
        panelImageView.frame = CGRectMake(0, 0,
                                          view.contentScrollView.frame.size.width,
                                          view.contentScrollView.frame.size.height);
        panelView.frame = CGRectMake(*xIndex, 0,
                                     view.contentScrollView.frame.size.width,
                                     view.contentScrollView.frame.size.height);
    }else{
        panelImageView.frame = CGRectMake(5, 0, view.contentScrollView.frame.size.width - 10, imageHeight);
    }
    
    panelImageView.contentMode = UIViewContentModeScaleAspectFill;
    panelImageView.backgroundColor = [UIColor clearColor];
    panelImageView.image = self.image;
    panelImageView.layer.cornerRadius = 3;
    panelImageView.clipsToBounds = YES;
    
    [panelView addSubview:panelImageView];
    
    CGFloat contentWrappedScrollViewHeight = imageHeight;
    UITextView *panelTextView = nil;
    
    if(self.descriptionText != nil && self.descriptionText.length > 0){
        //Build text container;
        panelTextView = [[UITextView alloc] initWithFrame:CGRectMake(0, 0,
                                                                     view.contentScrollView.frame.size.width, 10)];
        
        panelTextView.scrollEnabled = NO;
        panelTextView.backgroundColor = [UIColor clearColor];
        panelTextView.textAlignment = self.textAlignment;
        
        if (self.font) {
            panelTextView.font = self.font;
        }else{
            panelTextView.font = DESCRIPTION_FONT;
        }
        
        if (self.textColor) {
            panelTextView.textColor = self.textColor;
        }else{
            panelTextView.textColor = DESCRIPTION_TEXT_COLOR;
        }
        
        panelTextView.text = self.descriptionText;
        
        panelTextView.editable = NO;
        [panelView addSubview:panelTextView];
        
        //Correct layout parameters
        NSInteger textHeight = panelTextView.contentSize.height;
        
        if ((imageHeight+textHeight) > maxScrollViewHeight) {
            contentWrappedScrollViewHeight = maxScrollViewHeight;
            imageHeight = contentWrappedScrollViewHeight-textHeight - 10;
        } else if ((imageHeight+textHeight) <= maxScrollViewHeight){
            contentWrappedScrollViewHeight = imageHeight + textHeight;
        }
        
        panelTextView.frame = CGRectMake(0, imageHeight + 5,
                                         view.contentScrollView.frame.size.width,
                                         textHeight);
    }
    
    if (!self.imageWantsFullscreen) {
        panelView.frame = CGRectMake(*xIndex, 0,
                                     view.contentScrollView.frame.size.width,
                                     contentWrappedScrollViewHeight);
    }
    
    panelTextView.autoresizingMask = UIViewAutoresizingNone;
    
    if (panelTextView != nil && CGPointEqualToPoint(self.textCenter, CGPointZero) == NO) {
        panelTextView.center = self.textCenter;
    }
    
    *xIndex += view.contentScrollView.frame.size.width;
    
    return panelView;
}

- (CGRect)frameForPageControl:(VIIntroductionView *)view
{
    if (self.imageWantsFullscreen) {
        return view.pageControl.frame;
    }else{
        CGFloat yOriginDynamic =  (view.contentScrollView.frame.origin.y +
                                   view.contentScrollView.frame.size.height + PAGE_CONTROL_PADDING);
        
        CGFloat yOrigin =  MIN(yOriginDynamic, view.frame.size.height -
                               view.pageControl.frame.size.height - PAGE_CONTROL_PADDING);
        
        return CGRectMake(view.pageControl.frame.origin.x,
                          yOrigin,
                          view.pageControl.frame.size.width,
                          view.pageControl.frame.size.height);
    }
}

- (CGRect)frameForDoneButton:(VIIntroductionView *)view
{
    if (self.imageWantsFullscreen) {
        return view.endIntroButton.frame;
    }else{
        CGFloat yOriginDynamic =  (view.contentScrollView.frame.origin.y +
                                   view.contentScrollView.frame.size.height + PAGE_CONTROL_PADDING);
        
        CGFloat yOrigin =  MIN(yOriginDynamic, view.frame.size.height -
                               view.endIntroButton.frame.size.height - PAGE_CONTROL_PADDING);
        
        return CGRectMake(view.endIntroButton.frame.origin.x,
                          yOrigin,
                          view.endIntroButton.frame.size.width,
                          view.endIntroButton.frame.size.height);
    }
}

- (void)dealloc
{
    NSLog(@"Congrats, dealloc'd %@", self.description);
}

#pragma mark Class Methods

@end
