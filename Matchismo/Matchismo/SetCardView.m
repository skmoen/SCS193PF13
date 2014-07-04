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

-(void)setSelected:(BOOL)selected
{
    _selected = selected;
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

#define CORNER_RADIUS 16.0
#define SIDE_SPACE 10.0
#define SYMBOL_HEIGHT 40.0
#define STANDARD_VIEW_HEIGHT 240.0

-(CGFloat)scaleFactor { return self.bounds.size.height / STANDARD_VIEW_HEIGHT; }
-(CGFloat)cornerRadius { return CORNER_RADIUS * [self scaleFactor]; }
-(CGFloat)sideSpace { return SIDE_SPACE * [self scaleFactor]; }
-(CGFloat)symbolHeight { return SYMBOL_HEIGHT * [self scaleFactor]; }

- (void)drawRect:(CGRect)rect
{
    UIBezierPath *roundedRect = [UIBezierPath bezierPathWithRoundedRect:self.bounds cornerRadius:[self cornerRadius]];
    
    [roundedRect addClip];
    
    [[UIColor whiteColor] setFill];
    UIRectFill(self.bounds);
    
    if ( self.selected ) {
        [[UIColor orangeColor] setStroke];
        roundedRect.lineWidth = CORNER_RADIUS * [self scaleFactor];
    }
    else {
        [[UIColor blackColor] setStroke];
    }
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
    
    CGPoint symbolShape = CGPointMake(self.bounds.size.width - [self symbolHeight]/2, [self symbolHeight]);
    
    if (self.number == 0 || self.number == 2) {
        [self drawSymbol:self.symbol
             withShading:self.shading
                  inRect:CGRectMake([self sideSpace],
                                    self.bounds.size.height/2 - 2*[self sideSpace],
                                    symbolShape.x,
                                    symbolShape.y)];
    }
    if (self.number == 2) {
        int offset = self.bounds.size.height * 0.125;
        [self drawSymbol:self.symbol
             withShading:self.shading
                  inRect:CGRectMake([self sideSpace],
                                    offset,
                                    symbolShape.x,
                                    symbolShape.y)];

        [self drawSymbol:self.symbol
             withShading:self.shading
                  inRect:CGRectMake([self sideSpace],
                                    self.bounds.size.height - [self symbolHeight] - offset,
                                    symbolShape.x,
                                    symbolShape.y)];
 
    }
    if (self.number == 1) {
        int offset = self.bounds.size.height * 0.25;
        [self drawSymbol:self.symbol
             withShading:self.shading
                  inRect:CGRectMake([self sideSpace],
                                    offset,
                                    symbolShape.x,
                                    symbolShape.y)];
        [self drawSymbol:self.symbol
             withShading:self.shading
                  inRect:CGRectMake([self sideSpace],
                                    self.bounds.size.height - [self symbolHeight] - offset,
                                    symbolShape.x,
                                    symbolShape.y)];
    }
}

-(NSString*)description{
    NSArray *colors = @[@"red",@"green",@"blue"];
    NSArray *symbols = @[@"oval",@"diamond",@"squiggle"];
    NSArray *shadings = @[@"open",@"striped",@"solid"];
    return [NSString stringWithFormat:@"%d %@ %@ %@", self.number+1, colors[self.color], shadings[self.shading], symbols[self.symbol]];
}

-(void)drawSymbol:(NSUInteger)symbol
     withShading:(NSUInteger)shading
          inRect:(CGRect)rect
{
    CGContextRef contextRef = UIGraphicsGetCurrentContext();
    CGContextSaveGState(contextRef);
    /*
    UIBezierPath *debug = [UIBezierPath bezierPathWithRect:rect];
    debug.lineWidth = 0.5;
    [debug stroke];
     */
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
        CGPoint start = CGPointMake(rect.origin.x + 10*[self scaleFactor],
                                    rect.origin.y + rect.size.height);
        CGPoint end = CGPointMake(rect.origin.x + rect.size.width - 10*[self scaleFactor], rect.origin.y);
        [path moveToPoint:start];
        [path addCurveToPoint:end
                controlPoint1:CGPointMake(start.x - 30*[self scaleFactor], start.y - 80*[self scaleFactor])
                controlPoint2:CGPointMake(end.x - 20*[self scaleFactor], end.y + 40*[self scaleFactor])];
        [path addCurveToPoint:start
                controlPoint1:CGPointMake(end.x + 30*[self scaleFactor], end.y + 80*[self scaleFactor])
                controlPoint2:CGPointMake(start.x + 20*[self scaleFactor], start.y - 40*[self scaleFactor])];
    }
    path.lineWidth = 5*[self scaleFactor];
    [path addClip];
    [path stroke];

    if (shading == 1) {
        UIBezierPath *stripes = [[UIBezierPath alloc] init];
        stripes.lineWidth = 1*[self scaleFactor];
        for (int i = 4; i < rect.size.width; i+= 4 ) {
            [stripes moveToPoint:CGPointMake(i + rect.origin.x - 2, rect.origin.y)];
            [stripes addLineToPoint:CGPointMake(i + rect.origin.x + 2, rect.size.height + rect.origin.y)];
        }
        [stripes stroke];
        
    }
    else if (shading == 2) {
        [path fill];
    }
    CGContextRestoreGState(contextRef);
}

@end
