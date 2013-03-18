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
    
}

- (void)dealloc
{
    NSLog(@"Congrats, dealloc'd %@", self.description);
}

@end
