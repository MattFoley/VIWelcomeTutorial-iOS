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
        _descriptionText = [[NSString alloc] initWithString:description];
        _font = font;
        _textCenter = textCenter;
    }
    
    return self;
}

- (id)initWithImage:(UIImage *)image description:(NSString *)description andTextCenter:(CGPoint)textCenter
{
    if (self = [super init]) {
        [self sharedInit];
        
        _image = image;
        _descriptionText = [[NSString alloc] initWithString:description];
        _textCenter = textCenter;
    }
    
    return self;
}

- (id)initWithImage:(UIImage *)image description:(NSString *)description
{
    if (self = [super init]) {
        _image = image;
        _descriptionText = [[NSString alloc] initWithString:description];
        [self sharedInit];
    }
    
    return self;
}

- (id)initWithImage:(UIImage *)image
{
    if (self = [super init]) {
        _image = image;
        [self sharedInit];
    }
    
    return self;
}

- (void)sharedInit
{
    _textCenter = CGPointZero;
    self.textColor = nil;
    self.textAlignment = NSTextAlignmentCenter;
    self.font = nil;
    
}

- (void)dealloc
{
    NSLog(@"Congrats, dealloc'd %@", self.description);
}

@end
