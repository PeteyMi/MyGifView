//
//  MyGifView.m
//  MyGifView
//
//  Created by Petey Mi on 8/3/15.
//  Copyright © 2015 Petey Mi. All rights reserved.
//

#import "MyGifView.h"
#import <ImageIO/ImageIO.h>

@interface MyGifView()

@property(nonatomic, strong) NSMutableArray* frames;
@property(nonatomic, strong) NSMutableArray* delayTimes;
@property(nonatomic, assign) CGFloat width;
@property(nonatomic, assign) CGFloat height;
@property(nonatomic, assign) CGFloat totalTime;

@end

@implementation MyGifView

@synthesize frames = _frames;
@synthesize delayTimes = _delayTimes;
@synthesize width = _width, height = _height, totalTime = _totalTime;
@synthesize autorepeat = _autorepeat , autoBegin = _autoBegin;;
@synthesize data = _data;


-(id)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self initializer];
    }
    return self;
}

-(id)initWithFrame:(CGRect)frame url:(NSURL*)url
{
    NSData* data = [NSData dataWithContentsOfURL:url];
    return [self initWithFrame:frame data:data];
}

-(id)initWithFrame:(CGRect)frame data:(NSData*)data
{
    if (self = [super initWithFrame:frame]) {
        _data = data;
        [self getFrameInfo:data];
        [self initializer];
        [self beginGif];
    }
    return self;
}

-(void)awakeFromNib
{
    [super awakeFromNib];
    [self initializer];
}

-(void)initializer
{
    self.contentMode = UIViewContentModeScaleAspectFit;
    _autorepeat = YES;
    _autoBegin = YES;
}

-(void)setAutorepeat:(BOOL)autorepeat
{
    _autorepeat = autorepeat;
    [self stopGif];
    if (_autorepeat) {
        [self beginGif];
    }
}
-(void)setAutoBegin:(BOOL)autoBegin
{
    _autoBegin = autoBegin;
    if (_autoBegin) {
        [self beginGif];
    } else {
        [self stopGif];
    }
}

-(void)setData:(NSData *)data
{
    if (_data != data) {
        _data = data;
        [self stopGif];
        [self getFrameInfo:_data];
        if (_autoBegin) {
            [self beginGif];
        }
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(NSMutableArray*)frames
{
    if (_frames == nil) {
        _frames = [[NSMutableArray alloc] init];
    }
    return _frames;
}
-(NSMutableArray*)delayTimes
{
    if (_delayTimes == nil) {
        _delayTimes = [[NSMutableArray alloc] init];
    }
    return _delayTimes;
}

-(void)getFrameInfo:(NSData*)data
{
//    CGImageSourceRef gifSource = CGImageSourceCreateWithURL((CFURLRef)url, NULL);
    CGImageSourceRef gifSource = CGImageSourceCreateWithData((CFDataRef)data, NULL);
    
    NSUInteger frameCount = CGImageSourceGetCount(gifSource);
    for (NSUInteger index = 0; index < frameCount; index++) {
        
        // Get each frame
        CGImageRef frame = CGImageSourceCreateImageAtIndex(gifSource, index, NULL);
        [self.frames addObject:(__bridge id __nonnull)(frame)];
        CGImageRelease(frame);
        
        // Get gif info with each frame
        NSDictionary* dic = CFBridgingRelease(CGImageSourceCopyPropertiesAtIndex(gifSource, index, NULL));
        // Get gif size
        _width = [[dic valueForKey:(NSString*)kCGImagePropertyPixelWidth] floatValue];
        _height = [[dic valueForKey:(NSString*)kCGImagePropertyPixelHeight] floatValue];
        
        // Get delay time
        NSDictionary* dicDelay = [dic valueForKey:(NSString*)kCGImagePropertyGIFDictionary];
        [self.delayTimes addObject:[dicDelay valueForKey:(NSString*)kCGImagePropertyGIFDelayTime]];
        
        _totalTime += [[dicDelay valueForKey:(NSString*)kCGImagePropertyGIFDelayTime] floatValue];
    }
}

-(void)beginGif
{
    CAKeyframeAnimation* animation = [CAKeyframeAnimation animationWithKeyPath:@"contents"];
    
    NSMutableArray* timesPercent = [[NSMutableArray alloc] initWithCapacity:3];
    CGFloat currentTime = 0;
    for (NSUInteger index = 0; index < _delayTimes.count; index++) {
        [timesPercent addObject:[NSNumber numberWithFloat:currentTime / _totalTime]];
        currentTime += [[_delayTimes objectAtIndex:index] floatValue];
    }
    
    [animation setKeyTimes:timesPercent];
    
    [animation setValues:_frames];
    [animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear]];
    animation.duration = _totalTime;
    animation.delegate = self;
    if (_autorepeat) {
        animation.repeatCount = INFINITY;
    } else {
        animation.repeatCount = 1;
    }
    
    
    [self.layer addAnimation:animation forKey:@"gifAnimation"];
}

-(void)stopGif
{
    [self.layer removeAllAnimations];
    self.frames = nil;
    self.delayTimes = nil;
    self.totalTime = 0;
    self.width = 0;
    self.height = 0;
}

-(void)animationDidStop:(nonnull CAAnimation *)anim finished:(BOOL)flag
{
    self.layer.contents = nil;
}

@end











