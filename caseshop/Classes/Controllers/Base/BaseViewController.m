//
//  BaseViewController.m
//  scomdcom
//
//  Created by Yongnam Park on 12. 9. 7..
//  Copyright (c) 2012년 Yongnam Park. All rights reserved.
//

#import "BaseViewController.h"
#import "MainViewController.h"

@interface BaseViewController ()

@end

@implementation BaseViewController

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewShouldRefresh{
    [self.view setNeedsDisplay];
}

- (void)viewDidDisappear:(BOOL)animated
{
    SDImageCache *imageCache = [SDImageCache sharedImageCache];
    [imageCache clearMemory];
    [super viewDidDisappear:animated];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    /* 네이게이션 배경 */
//    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"NavBar"] forBarMetrics:UIBarMetricsDefault];
    
    UINavigationController *nav = self.navigationController;
    
    if ([nav.navigationBar respondsToSelector:@selector(setShadowImage:)]){
        nav.navigationBar.shadowImage = [[UIImage alloc] init];
    }
    
    [nav.navigationBar setBackgroundImage:[[UIImage alloc] init] forBarMetrics:UIBarMetricsDefault];
    nav.navigationBar.backgroundColor = [UIColor colorWithRed:0.431 green:0.792 blue:0.992 alpha:1.000];
    
    
    /* 네비게이션 타이틀 텍스트 커스터마이징 */
    NSDictionary *textTitleOptions = [NSDictionary dictionaryWithObjectsAndKeys:
                                      [UIFont fontWithName:@"DINPro-Bold" size:18.0f], UITextAttributeFont, // 글꼴
                                      [UIColor whiteColor], UITextAttributeTextColor, // 글자색
                                      [UIColor colorWithWhite:1 alpha:1], UITextAttributeTextShadowColor, // 그림자 색
                                      [NSValue valueWithCGSize:CGSizeMake(0, 0)], UITextAttributeTextShadowOffset, nil]; // 그림자 오프셋
    
    [[UINavigationBar appearance] setTitleTextAttributes: textTitleOptions];
    
    
    
    // 백버튼 커스터마이징
    UIImage *btn = [UIImage imageNamed:@"WBtnBack"];
    UIImage *btnOn = [UIImage imageNamed:@"WBtnBack_On"];
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, btn.size.width, btn.size.height)];
    [button setImage:btn forState:UIControlStateNormal];
    [button setImage:btnOn forState:UIControlStateHighlighted];
    [button addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:button];
    self.navigationItem.leftBarButtonItem = item;
    
    
    
    // 빈이미지뷰
    _empty = [[UIImageView alloc] initWithFrame:CGRectZero];
    [self.view addSubview:_empty];
    _empty.hidden = YES;
    
    
    
    // 
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(viewShouldRefresh) name:NSCurrentLocaleDidChangeNotification object:nil];
    
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
    
    [[SDImageCache sharedImageCache] clearMemory];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


#pragma mark - Button Actions

- (void)back{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)close{
    
}

- (void)cancel{
    
}

- (void)done{
    
}

- (void)next{
    
}

- (void)reply{
    
}

- (void)zzim{
    
}

- (void)edit{
    
}

- (void)customAction{
    
}

- (void)device{
    
}

- (void)tile{
    
}

- (void)list{
    
}


#pragma mark - Navigation Button

- (void)setLeftBackButton{
    
    // 백버튼 커스터마이징
    UIImage *btn = [UIImage imageNamed:@"WBtnBack"];
    UIImage *btnOn = [UIImage imageNamed:@"WBtnBack_On"];
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, btn.size.width, btn.size.height)];
    [button setImage:btn forState:UIControlStateNormal];
    [button setImage:btnOn forState:UIControlStateHighlighted];
    [button addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:button];
    self.navigationItem.leftBarButtonItem = item;
}

- (void)setLeftCloseButton{
    UIImage *btn = [UIImage imageNamed:@"NavBtnGeneral"];
    UIImage *btnOn = [UIImage imageNamed:@"NavBtnGeneral_On"];
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, btn.size.width, btn.size.height)];
    [button setTitle:@"닫기" forState:UIControlStateNormal];
    [button.titleLabel setFont:[UIFont boldSystemFontOfSize:13]];
    [button.titleLabel setShadowColor:[UIColor blueColor]];
    [button.titleLabel setShadowOffset:CGSizeMake(0, -1)];
    [button setBackgroundImage:btn forState:UIControlStateNormal];
    [button setBackgroundImage:btnOn forState:UIControlStateHighlighted];
    [button addTarget:self action:@selector(close) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:button];
    self.navigationItem.leftBarButtonItem = item;

}

- (void)setLeftCancelButton{
    
    UIImage *btn = [UIImage imageNamed:@"NavBtnGeneral"];
    UIImage *btnOn = [UIImage imageNamed:@"NavBtnGeneral_On"];
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, btn.size.width, btn.size.height)];
    [button setTitle:@"취소" forState:UIControlStateNormal];
    [button.titleLabel setFont:[UIFont boldSystemFontOfSize:13]];
    [button.titleLabel setShadowColor:[UIColor blueColor]];
    [button.titleLabel setShadowOffset:CGSizeMake(0, -1)];
    [button setBackgroundImage:btn forState:UIControlStateNormal];
    [button setBackgroundImage:btnOn forState:UIControlStateHighlighted];
    [button addTarget:self action:@selector(cancel) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:button];
    self.navigationItem.leftBarButtonItem = item;
}


- (void)setRightButtonType:(RightButtonType)type{ 
    UIImage *btn = [UIImage imageNamed:@"NavBtnDone"];
    UIImage *btnOn = [UIImage imageNamed:@"NavBtnDone_On"];
    
    if (type ==  RightButtonTypeList){
        btn = [UIImage imageNamed:@"WBtnModeList"];
        btnOn = [UIImage imageNamed:@"WBtnModeList_On"]; 
    }
    
    else if (type ==  RightButtonTypeTile){
        btn = [UIImage imageNamed:@"WBtnModeThumb"]; 
        btnOn = [UIImage imageNamed:@"WBtnModeThumb_On"];
    }
    
    else if (type == RightButtonTypeEdit){
        btn = [UIImage imageNamed:@"WBtnEdit"];
        btnOn = [UIImage imageNamed:@"WBtnEdit_On"];
    }
    
    
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, btn.size.width, btn.size.height)];
    [button.titleLabel setFont:[UIFont boldSystemFontOfSize:13]];
    [button.titleLabel setShadowColor:[UIColor blueColor]];
    [button.titleLabel setShadowOffset:CGSizeMake(0, -1)];
    [button setBackgroundImage:btn forState:UIControlStateNormal];
    [button setBackgroundImage:btn forState:UIControlStateDisabled];
    [button setBackgroundImage:btnOn forState:UIControlStateHighlighted];
    
    
    if (type ==  RightButtonTypeList){
        [button addTarget:self action:@selector(list) forControlEvents:UIControlEventTouchUpInside];
    }
    
    else if (type ==  RightButtonTypeTile){
        [button addTarget:self action:@selector(tile) forControlEvents:UIControlEventTouchUpInside];
    }
    
    else if (type == RightButtonTypeEdit){
        [button addTarget:self action:@selector(edit) forControlEvents:UIControlEventTouchUpInside];
    }
    
    
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:button];
    self.navigationItem.rightBarButtonItem = item;
}

- (void)setLeftButtonType:(LeftButtonType)type{
    
    
    UIImage *btn = [UIImage imageNamed:@"NavBtnDone"];
    UIImage *btnOn = [UIImage imageNamed:@"NavBtnDone_On"];
    
    if (type ==  LeftButtonTypeCancel){
        btn = [UIImage imageNamed:@"WBtnCancel"];
        btnOn = [UIImage imageNamed:@"WBtnCancel_On"];
    }
    
    else if (type ==  LeftButtonTypeDevice){
        btn = [UIImage imageNamed:@"WBtnDevice"];
        btnOn = [UIImage imageNamed:@"WBtnDevice_On"];
    }
    
    else if (type == LeftButtonTypeDone){
        btn = [UIImage imageNamed:@"NavBtnDone"];
        btnOn = [UIImage imageNamed:@"NavBtnDone_On"];
    }
    
    else if (type == LeftButtonTypeEdit){
        btn = [UIImage imageNamed:@"WBtnEdit"];
        btnOn = [UIImage imageNamed:@"WBtnEdit_On"];
    }
    
    
    
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, btn.size.width, btn.size.height)];
    [button setImage:btn forState:UIControlStateNormal];
    [button setImage:btnOn forState:UIControlStateHighlighted];
    
    
    if (type ==  LeftButtonTypeCancel){
        [button addTarget:self action:@selector(cancel) forControlEvents:UIControlEventTouchUpInside];
    }
    
    else if (type ==  LeftButtonTypeDevice){
        [button addTarget:self action:@selector(device) forControlEvents:UIControlEventTouchUpInside];
    }
    
    else if (type == LeftButtonTypeDone){
        [button addTarget:self action:@selector(done) forControlEvents:UIControlEventTouchUpInside];
    }
    
    else if (type == LeftButtonTypeEdit){
        [button addTarget:self action:@selector(edit) forControlEvents:UIControlEventTouchUpInside];
    }
    
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:button];
    self.navigationItem.leftBarButtonItem = item;
    
}

- (void)setRightCustomButtonWithTitle:(NSString*)title target:(id)target selector:(SEL)selector{
    UIFont *titleFont = [UIFont fontWithName:@"DINPro-Bold" size:11.0f];
    CGSize size = [title sizeWithFont:titleFont];
    
    UIImage *btn = [[UIImage imageNamed:@"WBtnBlank"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 20, 0, 20)];
    UIImage *btnOn = [UIImage imageNamed:@"WBtnBlank_On"];
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, size.width + 20, btn.size.height)];
    [button setTitle:title forState:UIControlStateNormal];
    [button.titleLabel setFont:titleFont];
    
    [button setTitleColor:[UIColor colorWithRed:0.431 green:0.792 blue:0.992 alpha:1.000] forState:UIControlStateNormal];
    [button.titleLabel setShadowColor:[UIColor clearColor]];
    [button.titleLabel setShadowOffset:CGSizeMake(0, 0)];
    [button setBackgroundImage:btn forState:UIControlStateNormal];
    [button setBackgroundImage:btnOn forState:UIControlStateHighlighted];
    [button addTarget:target action:selector forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:button];
    self.navigationItem.rightBarButtonItem = item;
}

- (void)setLeftCustomButtonWithTitle:(NSString*)title target:(id)target selector:(SEL)selector{
    UIFont *titleFont = [UIFont fontWithName:@"DINPro-Bold" size:11.0f];
    CGSize size = [title sizeWithFont:titleFont];
    
    UIImage *btn = [[UIImage imageNamed:@"WBtnBlank"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 20, 0, 20)];
    UIImage *btnOn = [UIImage imageNamed:@"WBtnBlank_On"];
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, size.width + 20, btn.size.height)];
    [button setTitle:title forState:UIControlStateNormal];
    [button.titleLabel setFont:titleFont];
    
    [button setTitleColor:[UIColor colorWithRed:0.431 green:0.792 blue:0.992 alpha:1.000] forState:UIControlStateNormal];
    [button.titleLabel setShadowColor:[UIColor clearColor]];
    [button.titleLabel setShadowOffset:CGSizeMake(0, 0)];
    [button setBackgroundImage:btn forState:UIControlStateNormal];
    [button setBackgroundImage:btnOn forState:UIControlStateHighlighted];
    [button addTarget:target action:selector forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:button];
    self.navigationItem.leftBarButtonItem = item;
}


- (void)setLeftCustomButtonWithTitle:(NSString*)title{
    UIFont *titleFont = [UIFont fontWithName:@"DINPro-Bold" size:11.0f];
    CGSize size = [title sizeWithFont:titleFont];
    
    UIImage *btn = [[UIImage imageNamed:@"NavBtn"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 20, 0, 20)];
    UIImage *btnOn = [UIImage imageNamed:@"NavBtn"];
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, size.width + 20, btn.size.height)];
    [button setTitle:title forState:UIControlStateNormal];
    [button.titleLabel setFont:titleFont];

    [button setTitleColor:[UIColor colorWithRed:0.431 green:0.792 blue:0.992 alpha:1.000] forState:UIControlStateNormal];
    [button.titleLabel setShadowColor:[UIColor clearColor]];
    [button.titleLabel setShadowOffset:CGSizeMake(0, 0)];
    [button setBackgroundImage:btn forState:UIControlStateNormal];
    [button setBackgroundImage:btnOn forState:UIControlStateHighlighted];
    [button addTarget:self action:@selector(customAction) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:button];
    self.navigationItem.leftBarButtonItem = item;
}


- (void)setRightZzimButtonZzimmed:(BOOL)zzimmed target:(id) target{
    
    UIImage *btn = [UIImage imageNamed:@"NavBtnLike"];
    if (zzimmed){
        btn = [UIImage imageNamed:@"NavBtnLike_On"];
    }
    
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, btn.size.width, btn.size.height)];
    [button.titleLabel setFont:[UIFont boldSystemFontOfSize:13]];
    [button.titleLabel setShadowColor:[UIColor blueColor]];
    [button.titleLabel setShadowOffset:CGSizeMake(0, -1)];
    [button setBackgroundImage:btn forState:UIControlStateNormal];
    
    [button setTitle:@"" forState:UIControlStateNormal];
    [button addTarget:target action:@selector(zzim) forControlEvents:UIControlEventTouchUpInside];
    
    button.tag = 0;
    if (zzimmed){
        button.tag = 1;
    }
    
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:button];
    self.navigationItem.rightBarButtonItem = item;
    
   
}

- (void)setRightEditButton{
    UIImage *btn = [UIImage imageNamed:@"NavBtnGeneral"];
    UIImage *btnOn = [UIImage imageNamed:@"NavBtnGeneral_On"];
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, btn.size.width, btn.size.height)];
    [button setTitle:@"편집" forState:UIControlStateNormal];
    [button.titleLabel setFont:[UIFont boldSystemFontOfSize:13]];
    [button.titleLabel setShadowColor:[UIColor blueColor]];
    [button.titleLabel setShadowOffset:CGSizeMake(0, -1)];
    [button setBackgroundImage:btn forState:UIControlStateNormal];
    [button setBackgroundImage:btnOn forState:UIControlStateHighlighted];
    [button addTarget:self action:@selector(edit) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:button];
    self.navigationItem.rightBarButtonItem = item;
}

- (void)setLeftDoneButton{
    UIImage *btn = [UIImage imageNamed:@"NavBtnDone"];
    UIImage *btnOn = [UIImage imageNamed:@"NavBtnDone_On"];
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, btn.size.width, btn.size.height)];
    [button setTitle:@"완료" forState:UIControlStateNormal];
    [button.titleLabel setFont:[UIFont boldSystemFontOfSize:13]];
    [button.titleLabel setShadowColor:[UIColor blueColor]];
    [button.titleLabel setShadowOffset:CGSizeMake(0, -1)];
    [button setBackgroundImage:btn forState:UIControlStateNormal];
    [button setBackgroundImage:btnOn forState:UIControlStateHighlighted];
    [button addTarget:self action:@selector(done) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:button];
    self.navigationItem.leftBarButtonItem = item;
}

- (void)setLeftEditButton{
    UIImage *btn = [UIImage imageNamed:@"NavBtnGeneral"];
    UIImage *btnOn = [UIImage imageNamed:@"NavBtnGeneral_On"];
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, btn.size.width, btn.size.height)];
    [button setTitle:@"편집" forState:UIControlStateNormal];
    [button.titleLabel setFont:[UIFont boldSystemFontOfSize:13]];
    [button.titleLabel setShadowColor:[UIColor blueColor]];
    [button.titleLabel setShadowOffset:CGSizeMake(0, -1)];
    [button setBackgroundImage:btn forState:UIControlStateNormal];
    [button setBackgroundImage:btnOn forState:UIControlStateHighlighted];
    [button addTarget:self action:@selector(edit) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:button];
    self.navigationItem.leftBarButtonItem = item;
}

- (void)setRightCustomButtonWithTitle:(NSString*)title{
    UIFont *titleFont = [UIFont fontWithName:@"DINPro-Bold" size:11.0f];
    CGSize size = [title sizeWithFont:titleFont];
    
    UIImage *btn = [[UIImage imageNamed:@"WBtnBlank"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 20, 0, 20)];
    UIImage *btnOn = [[UIImage imageNamed:@"WBtnBlank_On"]resizableImageWithCapInsets:UIEdgeInsetsMake(0, 20, 0, 20)];
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, size.width + 20, btn.size.height)];
    [button setTitleColor:[UIColor colorWithRed:0.416 green:0.788 blue:0.992 alpha:1.000] forState:UIControlStateNormal];
    [button setTitle:title forState:UIControlStateNormal];
    [button.titleLabel setFont:titleFont];
    [button.titleLabel setShadowOffset:CGSizeMake(0, 0)];
    [button setBackgroundImage:btn forState:UIControlStateNormal];
    [button setBackgroundImage:btnOn forState:UIControlStateHighlighted];
    [button addTarget:self action:@selector(customAction) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:button];
    self.navigationItem.rightBarButtonItem = item;
}

- (void)setRightCustomDoneButtonWithTitle:(NSString*)title{
    
    CGSize size = [title sizeWithFont:[UIFont boldSystemFontOfSize:13]];
    
    UIImage *btn = [[UIImage imageNamed:@"NavBtnDone"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 20, 0, 20)];
    UIImage *btnOn = [UIImage imageNamed:@"NavBtnDone_On"];
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, size.width + 20, btn.size.height)];
    [button setTitle:title forState:UIControlStateNormal];
    [button.titleLabel setFont:[UIFont boldSystemFontOfSize:13]];
    [button.titleLabel setShadowColor:[UIColor blueColor]];
    [button.titleLabel setShadowOffset:CGSizeMake(0, -1)];
    [button setBackgroundImage:btn forState:UIControlStateNormal];
    [button setBackgroundImage:btnOn forState:UIControlStateHighlighted];
    [button addTarget:self action:@selector(customAction) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:button];
    self.navigationItem.rightBarButtonItem = item;
}

#pragma mark - 로딩 마스크

- (void)showBlackLoadingMask{
    if (!_loadingMask){
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.navigationController.view.frame.size.width, self.navigationController.view.frame.size.height)];
        view.backgroundColor = [UIColor colorWithWhite:0 alpha:.5];
        view.alpha = .0f;
        
        UIActivityIndicatorView *act = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        [view addSubview:act];
        [act startAnimating];
        [act hidesWhenStopped];
        [act setCenter:view.center];
        
        
        _loadingMask = view;
    }
    [self.navigationController.view addSubview:_loadingMask];
    
    
    [UIView animateWithDuration:.3
                     animations:^{
                         _loadingMask.alpha = 1.0f;
                     }
                     completion:^(BOOL finished){
                         
                     }];
    
}

- (void)hideBlackLoadingMask{
    if (_loadingMask){
        [UIView animateWithDuration:.5
                         animations:^{
                             [_loadingMask setAlpha:.0f];
                         }
                         completion:^(BOOL finished){
                             [_loadingMask removeFromSuperview];
                         }];
    }
}


- (void)showEmptyViewType:(EmptyImageType)type{
    
    UIImage *img = nil;
    switch (type) {
        case EmptyImageTypeCart:
            img = [UIImage imageNamed:@"NoImage_Cart"];
            break;
        case EmptyImageTypeZzim:
            img = [UIImage imageNamed:@"NoImage_Like"];
            break;
        case EmptyImageTypeOrder:
            img = [UIImage imageNamed:@"NoImage_Order"];
            break;
        case EmptyImageTypeQna:
            img = [UIImage imageNamed:@"NoImage_Question"];
            break;
        case EmptyImageTypeInquery:
            img = [UIImage imageNamed:@"NoImage_Question"];
            break;
        default:
            break;
    }

    if (img){
        _empty.frame = CGRectMake(0, 0, img.size.width, img.size.height);
        _empty.image = img;
        
        for (UIView *v in self.view.subviews){
            v.hidden = YES;
        }
        
        _empty.center = self.view.center;
        _empty.hidden = NO;
    } else {
        for (UIView *v in self.view.subviews){
            v.hidden = NO;
        }
        
        _empty.hidden = YES;
    }


}


@end
