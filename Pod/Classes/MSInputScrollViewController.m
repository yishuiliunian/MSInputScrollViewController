//
//  MSInputScrollViewController.m
//  MoShang
//
//  Created by stonedong on 15/2/12.
//  Copyright (c) 2015年 stonedong. All rights reserved.
//

#import "MSInputScrollViewController.h"
#import <DZGeometryTools.h>
#import <objc/runtime.h>
#import <DZProgramDefines.h>
const void* kUIViewIsScrollInputView = &kUIViewIsScrollInputView;
@implementation UIView (Extand)

- (BOOL) isScrollInputView
{
    return [objc_getAssociatedObject(self, kUIViewIsScrollInputView) boolValue];
}

- (void) setIsScrollInputView:(BOOL)isScrollInputView
{
    objc_setAssociatedObject(self, kUIViewIsScrollInputView, @(isScrollInputView), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
@end

@interface UIView (First)
@property (nonatomic, assign, readonly) BOOL isContaionsFirstResponse;
@end

@implementation UIView (First)

- (BOOL) isContaionsFirstResponse
{
    if (self.isFirstResponder) {
        return YES;
    }
    NSArray* subViews = [self.subviews copy];
    for (UIView* v in subViews) {
        if (v.isContaionsFirstResponse) {
            return YES;
        }
    }
    return NO;
}

@end

@interface MSInputScrollViewController () <UIGestureRecognizerDelegate>

@end

@implementation MSInputScrollViewController
- (void) dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
- (instancetype) initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (!self) {
        return self;
    }
    _isKeyboardShowing = NO;
    return self;
}
- (void) keybordWillShow:(NSNotification*)nc
{
    _isKeyboardShowing = YES;
    CGRect rect = [nc.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGRect scrollRect = self.view.bounds;
    scrollRect.size.height = CGRectGetHeight(self.view.bounds) - rect.size.height;
    _scrollView.frame = scrollRect;
    [self reloadScrollContentSize];
    [self showFirstResponse];
    
}

- (void) showFirstResponse
{
    NSArray* subViews = [self.scrollView subviews];
    for (UIView* v in subViews) {
        if (!v.isScrollInputView) {
            continue;
        }
        if (v.hidden) {
            continue;
        }
        
        BOOL first = v.isContaionsFirstResponse;
        NSLog(@"is first %d", first);
        if (first) {
            [self.scrollView scrollRectToVisible:v.frame animated:YES];
            break;
        }
    }
}
- (void) reloadScrollContentSize
{
    CGFloat maxHeight = 0;
    NSArray* subViews = [self.scrollView subviews];
    for (UIView* v in subViews) {
        if (!v.isScrollInputView) {
            continue;
        }
        if (v.hidden) {
            continue;
        }
        maxHeight = MAX(maxHeight, CGRectGetMaxY(v.frame));
    }
    if (_isKeyboardShowing) {
        maxHeight += 20;
    }
    CGSize size = CGSizeMake(CGRectGetViewControllerWidth, CGRectGetViewControllerHeight);
    size.height = MAX(maxHeight, CGRectGetHeight(_scrollView.frame));
    _scrollView.contentSize = size;
}
- (void) keybordWillHide:(NSNotification*)nc
{
    _isKeyboardShowing = NO;
    CGRect scrollRect = self.view.bounds;
    _scrollView.frame = scrollRect;
    [self reloadScrollContentSize];
    [self.scrollView scrollRectToVisible:CGRectZero animated:YES];
}

- (void) viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    _scrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:_scrollView];
    _scrollView.contentSize = self.view.bounds.size;
    
    UITapGestureRecognizer* tapG = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleHideKeyboardTap:)];
    tapG.numberOfTapsRequired = 1;
    tapG.numberOfTouchesRequired = 1;
    tapG.delegate = self;
    [self.view addGestureRecognizer:tapG];
    
}

- (void) handleHideKeyboardTap:(UITapGestureRecognizer*)tapG
{
    if (tapG.state == UIGestureRecognizerStateRecognized) {
        NSArray* subViews = self.scrollView.subviews;
        CGPoint point = [tapG locationInView:self.scrollView];
        for (UIView* v in subViews) {
            if (CGRectContainsPoint(v.frame, point)) {
                return;
            }
        }
        for (UIView* v in subViews) {
            if ([v respondsToSelector:@selector(resignFirstResponder)]) {
                [v resignFirstResponder];
            }
        }
    }
}
- (void) viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
}

- (BOOL) gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    NSArray* subViews = [self.scrollView subviews];
    CGPoint point = [gestureRecognizer locationInView:self.scrollView];
    for (UIView* v in subViews) {
        if (CGRectContainsPoint(v.frame, point)) {
            return NO;
        }
    }
    return YES;
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    _scrollView.frame = self.view.bounds;
    [self reloadScrollContentSize];
}
- (void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keybordWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keybordWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

- (void) viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}
@end

