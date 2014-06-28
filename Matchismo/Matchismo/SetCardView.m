//
//  SetCardView.m
//  Matchismo
//
//  Created by scott.moen on 6/27/14.
//  Copyright (c) 2014 Scott Moen. All rights reserved.
//

#import "SetCardView.h"

@implementation SetCardView

#pragma mark - Properties

-(void)setNumber:(NSUInteger)number
{
    _number = number;
    [self setNeedsDisplay];
}

-(void)setSymbol:(NSUInteger)symbol
{
    _symbol = symbol;
    [self setNeedsDisplay];
}

-(void)setColor:(NSUInteger)color
{
    _color = color;
    [self setNeedsDisplay];
}

-(void)setStyle:(NSUInteger)shading
{
    _shading = shading;
    [self setNeedsDisplay];
}

#pragma mark - Initialization

- (void)setup
{
    self.backgroundColor = nil;
    self.opaque = NO;
    self.contentMode = UIViewContentModeRedraw;
}

- (void)awakeFromNib
{
    [self setup];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}

#pragma mark - Drawing

#define CORNER_FONT_STANDARD_HEIGHT 180.0
#define CORNER_RADIUS 12.0

- (CGFloat)cornerScaleFactor { return self.bounds.size.height / CORNER_FONT_STANDARD_HEIGHT; }
- (CGFloat)cornerRadius { return CORNER_RADIUS * [self cornerScaleFactor]; }
- (CGFloat)cornerOffset { return [self cornerRadius] / 3.0; }

- (void)drawRect:(CGRect)rect
{
    UIBezierPath *roundedRect = [UIBezierPath bezierPathWithRoundedRect:self.bounds cornerRadius:[self cornerRadius]];
    
    [roundedRect addClip];
    
    [[UIColor whiteColor] setFill];
    UIRectFill(self.bounds);
    
    [[UIColor blackColor] setStroke];
    [roundedRect stroke];
    
    
    if (self.color == 0) {
        [[UIColor redColor] setFill];
        [[UIColor redColor] setStroke];
    }
    else if (self.color == 1) {
        [[UIColor greenColor] setFill];
        [[UIColor greenColor] setStroke];
    }
    else if (self.color == 2) {
        [[UIColor blueColor] setFill];
        [[UIColor blueColor] setStroke];
    }
    
    [self drawSymbol:self.symbol
        withShading:self.shading
             inRect:CGRectMake(10,
                               10,
                               self.bounds.size.width-20,
                               40)];
    
    NSLog(@"%f, %f, %f, %f",
          self.bounds.origin.x,
          self.bounds.origin.y,
          self.bounds.size.width,
          self.bounds.size.height);
}

-(void)drawSymbol:(NSUInteger)symbol
     withShading:(NSUInteger)shading
          inRect:(CGRect)rect
{
    UIBezierPath *path;
    int midx = rect.origin.x + (rect.size.width/2);
    int midy = rect.origin.y + (rect.size.height/2);
    if (symbol == 0) {
        path = [UIBezierPath bezierPathWithOvalInRect:rect];
    }
    else if (symbol == 1) {
        path = [[UIBezierPath alloc] init];
        [path moveToPoint:CGPointMake(midx, rect.origin.y)];
        [path addLineToPoint:CGPointMake(rect.origin.x + rect.size.width, midy)];
        [path addLineToPoint:CGPointMake(midx, rect.origin.y + rect.size.height)];
        [path addLineToPoint:CGPointMake(rect.origin.x, midy)];
        [path closePath];
    }
    else if (symbol == 2) {
        path = [[UIBezierPath alloc] init];
    }
    path.lineWidth = 3;
    [path addClip];
    [path stroke];
    
    if (shading == 1) {
        UIBezierPath *stripes = [[UIBezierPath alloc] init];
        stripes.lineWidth = 0.7;
        for (int i = 5; i < rect.size.width; i+= 5 ) {
            [stripes moveToPoint:CGPointMake(i + rect.origin.x - 2, rect.origin.y)];
            [stripes addLineToPoint:CGPointMake(i + rect.origin.x + 2, rect.size.height + rect.origin.y)];
        }
        [stripes stroke];
    }
    else if (shading == 2) {
        [path fill];
    }
}

@end
