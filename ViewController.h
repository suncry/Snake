//
//  ViewController.h
//  Snake
//
//  Created by a a a a a on 12-10-13.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController
{
//    UIView * snake;
    UIImageView * head;
    NSMutableArray * tailArray;
    
    int width;
    int height;
    
    UIImageView * fruit ;
    NSTimer * timer;
    
}
-(BOOL)isRectsInteract:(CGRect)rect1 other:(CGRect)rect2;
-(BOOL)isPointInRect:(CGPoint)point rect:(CGRect )rect;


@end
