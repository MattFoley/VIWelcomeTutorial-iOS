//  VIIntroductionPanel.h
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

#import <Foundation/Foundation.h>

@class VIIntroductionView;

@interface VIIntroductionPanel : NSObject

//Image
@property (nonatomic, strong) UIImage *image;
@property (nonatomic, assign) CGFloat imageHeight;

//Setting this to TRUE will force images to take up the full screen of the panel
//If you set this to TRUE, the UIPageControl and endIntroButton will not be moved or resized, and will be pinned to the bottom of the screen, or where ever you choose to set them after initialization.
//If a description is set for panels, it will obey textCenter property set on each panel.
//Defaults to FALSE
@property (nonatomic, assign) BOOL imageWantsFullscreen;

//Description
@property (nonatomic, strong) NSString *descriptionText;
@property (nonatomic, strong) UIFont *font;
@property (nonatomic, strong) UIColor *textColor;
@property (nonatomic, assign) NSTextAlignment textAlignment;

//Display point for text (If not set, will default to just below Image with padding)
@property (nonatomic, assign) CGPoint textCenter;


- (id)initWithImage:(UIImage *)image;
- (id)initWithImage:(UIImage *)image
        description:(NSString *)description;

- (id)initWithImage:(UIImage *)image
        description:(NSString *)description
      andTextCenter:(CGPoint)textCenter;

- (id)initWithImage:(UIImage *)image
        description:(NSString *)description
         textCenter:(CGPoint)textCenter
            andFont:(UIFont*)font;

- (UIView *)viewForPanel:(VIIntroductionView *)view atXIndex:(CGFloat*)xIndex;

- (CGRect)frameForPageControl:(VIIntroductionView *)view;
- (CGRect)frameForDoneButton:(VIIntroductionView *)view;

- (void)cleanForDealloc;
- (void)sharedInit;


@end
