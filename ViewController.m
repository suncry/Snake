//
//  ViewController.m
//  Snake
//
//  Created by a a a a a on 12-10-13.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "ViewController.h"

@implementation ViewController
#define z 10
#define f -10
#define snake_x head.frame.origin.x
#define snake_y head.frame.origin.y

static int length = 1;
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

-(void)addTail
{
    UIImageView * tail;
    if ([tailArray count] == 0) {
        tail = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"ball.png"]];
        tail.frame = CGRectMake(head.frame.origin.x-20, head.frame.origin.y, 20, 20);
    }else{
        UIImageView * prevTail = [tailArray lastObject];
        tail = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"ball.png"]];
        tail.center = prevTail.center;
    }
    tail.tag = 101;
    [tailArray addObject:tail];
    [self.view addSubview:tail];
}

-(void)builtUI
{
    tailArray = [[NSMutableArray alloc]initWithCapacity:0];
    head = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"Strawberry.png"]];
    head.frame = CGRectMake(100, 250, 20, 20);
        
    [self.view addSubview:head];
    [self addTail];

    
    fruit = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"Strawberry.png"]];
    fruit.frame = CGRectMake(30, 30, 15, 15);
    

    [self.view addSubview:fruit];
}

- (IBAction)playBtnPressed:(id)sender {
    static BOOL isPlaying = NO;
    UIButton * btn = (UIButton *)[self.view viewWithTag:100];
    if (!isPlaying) {
        [btn setImage:[UIImage imageNamed:@"pause.png"] forState:UIControlStateNormal];
        
        timer = [NSTimer scheduledTimerWithTimeInterval:0.07 target:self selector:@selector(snakeMove) userInfo:nil repeats:YES];

    }
    else{
        [btn setImage:[UIImage imageNamed:@"play.png"] forState:UIControlStateNormal];
        if ([timer isValid]) {
            [timer invalidate];
        }
    } 
    isPlaying = !isPlaying;
}



#pragma mark - View lifecycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor grayColor];
    
    [self builtUI];
    
    width = 10;
    height = 0;
    
    
}



-(void)changeFruitLocation
{
    int x = rand()%300;
    int y = rand()%440;
    CGPoint point = CGPointMake(x, y);
    for (int i = 0; i < [tailArray count]; i++) {
        UIImageView * tail = [tailArray objectAtIndex:i];
        CGRect rect = CGRectMake(tail.frame.origin.x, tail.frame.origin.y, tail.frame.size.width, tail.frame.size.height);
        if ([self isPointInRect:point rect:rect]) {
            NSLog(@"递归调用了哦 (%f,%f)",point.x,point.y);
            [self changeFruitLocation];
            return;
        }
    }
    fruit.center = CGPointMake(x, y);
}

-(void)isSnakeBeyongdBounce{
    if (snake_x < 0 ) 
        head.center = CGPointMake(320, snake_y);
    if(snake_x-20> 320)
        head.center = CGPointMake(0, snake_y);
    if (snake_y < 0 ) 
        head.center = CGPointMake(snake_x, 460);
    if (snake_y-20> 460)
        head.center = CGPointMake(snake_x,0);
}
    
-(BOOL)isSnakeTouchItself
{
    CGPoint point = head.center;
    if ([tailArray count] > 3) {
        for (int i = 3; i < [tailArray count]; i++) {
            UIImageView * tail = [tailArray objectAtIndex:i];
            CGRect rect = CGRectMake(tail.frame.origin.x, tail.frame.origin.y, tail.frame.size.width, tail.frame.size.height);
            if ([self isPointInRect:point rect:rect]) {
                return YES;
            }
        }
    }
        
    return NO;
}

-(void)reStartGame
{
    for(UIView * v in self.view.subviews){
        if (v.tag == 101) {
            [v removeFromSuperview];
        }
    }
    [tailArray removeAllObjects];
    
    [self playBtnPressed:nil];
    head.center = CGPointMake(100, 250);
    [self addTail];
}

//  定时器调用
-(void)snakeMove
{
    CGPoint orign = head.center;
    head.center = CGPointMake(orign.x+ width, orign.y+height);
    
    for (int i = [tailArray count]-1; i >= 0; i--) {
        UIImageView * tail = [tailArray objectAtIndex:i];
        if (i == 0) {
            tail.center = orign;

        }else{
            UIImageView * prevTail = [tailArray objectAtIndex:i-1];
            tail.center = CGPointMake(prevTail.center.x, prevTail.center.y);
        }
    }
        
    CGRect headRect = CGRectMake(head.frame.origin.x, head.frame.origin.y, head.frame.size.width, head.frame.size.height);
    CGRect fruitRect = CGRectMake(fruit.frame.origin.x, fruit.frame.origin.y, fruit.frame.size.width, fruit.frame.size.height);
    
    if ([self isRectsInteract:headRect other:fruitRect]) {
        
        [self changeFruitLocation];
        [self addTail];
    }
    else if ([self isSnakeTouchItself]) {
        [self reStartGame];
    }

    [self isSnakeBeyongdBounce];
        
        
    
}


-(BOOL)isPointInRect:(CGPoint)point rect:(CGRect )rect
{
    if ((point.x >= rect.origin.x && point.x <= rect.origin.x+rect.size.width) && (point.y >= rect.origin.y && point.y <= rect.origin.y+rect.size.height) ) {
        
        return YES;
    }
    return NO;
}

-(BOOL)isRectsInteract:(CGRect)rect1 other:(CGRect)rect2
{
    for (float x = rect1.origin.x; x < rect1.origin.x + rect1.size.width; x++) {
        for (float y = rect1.origin.y; y < rect1.origin.y + rect1.size.height; y++) {
            CGPoint point = CGPointMake(x, y);
            
            if ( [self isPointInRect:point rect:rect2]) {
                NSLog(@"point:(%d,%d)",(int)point.x,(int)point.y);
                return YES;
            }
        
        }
    }
    return NO;
}



-(void)changeDirect:(CGPoint )point 
{
    if (height == 0) {
        if (point.y > head.frame.origin.y) {
            height = z;
            width = 0;
            
            static int hz = 1;
            if (hz < length) {
                NSLog(@"hz:%d",hz);
                head.frame = CGRectMake(snake_x, snake_y, 20, -hz*20);
                hz++;
            }
        }
        else if (point.y < head.frame.origin.y){
            height = f;
            width = 0;
            static int hf = 1;
            if (hf < length) {
                head.frame = CGRectMake(snake_x, snake_y, 20, +hf*20);
                hf++;
            }
            
        }
    }
    else if (width == 0){
        if (point.x > head.frame.origin.x) {
            width = z;
            height = 0;
            static int wz = 1;
            if (wz < length) {
                head.frame = CGRectMake(snake_x, snake_y, -wz*20,20);
                wz++;
            }

        }
        else if (point.x < snake_x){
            width = f;
            height = 0;
            static int wf = 1;
            if (wf < length) {
                head.frame = CGRectMake(snake_x, snake_y,-wf*20,20);
                wf++;
            }

        }
    }
} 

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch * oneTouch = [touches anyObject];
    CGPoint  point = [oneTouch locationInView:self.view];
    
    [self changeDirect:point];
    
    
}


- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

@end
