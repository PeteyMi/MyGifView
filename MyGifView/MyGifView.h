//
//  MyGifView.h
//  MyGifView
//
//  Created by Petey Mi on 8/3/15.
//  Copyright © 2015 Petey Mi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyGifView : UIView

@property(nonatomic, assign) BOOL autorepeat;   // Default value is YES.
@property(nonatomic, assign) BOOL autoBegin;    //Defalut value is YES.

@property(nonatomic, strong) NSData* data;

-(id)initWithFrame:(CGRect)frame url:(NSURL*)url;
-(id)initWithFrame:(CGRect)frame data:(NSData*)data;

-(void)beginGif;
-(void)stopGif;

@end
