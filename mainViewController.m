//
//  mainViewController.m
//  snowProj
//
//  Created by Shaun Stehly on 7/29/14.
//  Copyright (c) 2014 youtube. All rights reserved.
//

#import "mainViewController.h"

@interface mainViewController ()

@property (nonatomic, strong) UIDynamicAnimator *animator;
@property (nonatomic, strong) UIGravityBehavior *gravity;
@property (nonatomic, strong) UICollisionBehavior *collision;

- (void)onTimer;
- (void)collisionBehavior:(UICollisionBehavior*)behavior;
- (void)meltSnow:(UIView *)view;

@end

@implementation mainViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    CGRect frame = CGRectMake(0, 0, 5, 5);
    UIView *view = [[UIView alloc] initWithFrame:frame];
    view.backgroundColor = [UIColor redColor];
    [self.view addSubview:view];
    
    
    self.animator = [[UIDynamicAnimator alloc] initWithReferenceView:self.view];
    
    self.gravity = [[UIGravityBehavior alloc] init];
    [self.animator addBehavior:self.gravity];
    
    [self.gravity addItem:view];
    
    self.collision = [[UICollisionBehavior alloc] init];
    [self.animator addBehavior:self.collision];
    
    [self.collision addItem:view];
    
    [self.collision addBoundaryWithIdentifier:@"ground" fromPoint:CGPointMake(0, 568)toPoint:CGPointMake(320, 568)];
    
    [self.collision addBoundaryWithIdentifier:@"ramp" fromPoint:CGPointMake(0, 300)toPoint:CGPointMake(220, 360)];


    self.collision.collisionDelegate = self;

//    self.collision.translatesReferenceBoundsIntoBoundary = YES;
    
    self.gravity.gravityDirection = CGVectorMake(.2,1);
    
    NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:.05 target:self selector:@selector(onTimer) userInfo:nil repeats:YES];

    
//    [view removeFromSuperview];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) onTimer {
    CGRect frame = CGRectMake(arc4random_uniform(320), 0, 5, 5);
    UIView *view = [[UIView alloc] initWithFrame:frame];
    view.backgroundColor = [UIColor redColor];
    [self.view addSubview:view];
    
    [self.gravity addItem:view];
    [self.collision addItem:view];
//    [self.collision addBoundaryWithIdentifier:@"snow" ];


}

- (void)collisionBehavior:(UICollisionBehavior*)behavior beganContactForItem:(id <UIDynamicItem>)item withBoundaryIdentifier:(id <NSCopying>)identifier atPoint:(CGPoint)p {
    // You have to convert the identifier to a string
    NSString *boundary = (NSString *)identifier;
    
    // The view that collided with the boundary has to be converted to a view
    UIView *view = (UIView *)item;
    
    if ([boundary isEqualToString:@"ground"]) {
        [self performSelector:@selector(meltSnow:) withObject:view afterDelay:1];

        
    } else if (boundary == nil) {
        // Detected collision with bounds of reference view
    }
}


- (void) meltSnow: (UIView *)view {
    [UIView animateWithDuration:1 animations:^{
        view.alpha = 0;
    } completion:^(BOOL finished) {
        [view removeFromSuperview];
        [self.gravity removeItem:view];
        [self.collision removeItem:view];
    }];
}

//- (void)collisionBehavior:(UICollisionBehavior*)behavior beganContactForItem:(id <UIDynamicItem>)item1 withItem:(id <UIDynamicItem>)item2 atPoint:(CGPoint)p {
//    UIView *view = (UIView *)item1;
//    UIView *view2 = (UIView *)item2;
//}

@end
