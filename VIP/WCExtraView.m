//
//  WCExtraView.m
//  VIP
//
//  Created by NJWC on 16/3/23.
//  Copyright © 2016年 wancun. All rights reserved.
//

#import "WCExtraView.h"
#import "WCSelectAlbumView.h"

@interface WCExtraView ()<WCSelectAlbumViewDelegate>

/**
 *  选择图片的按钮
 */
@property (weak, nonatomic) IBOutlet UIButton *selectBtn;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *leftConstraint;


- (IBAction)selectImage:(UIButton *)sender;


@end

@implementation WCExtraView

+(instancetype)extraViewWithFrame:(CGRect)frame
{
    WCExtraView * extraView = [[[NSBundle mainBundle] loadNibNamed:@"WCExtraView" owner:nil options:nil] lastObject];
    extraView.frame = frame;
    return extraView;
}

- (IBAction)selectImage:(UIButton *)sender {
    
    UIWindow *window = [UIApplication sharedApplication].delegate.window;
    WCSelectAlbumView *albumView = [WCSelectAlbumView selectAlbumViewFrame:window.bounds];
    albumView.delegate = self;
    [window addSubview:albumView];
}

- (void)selectAlbumWithIndex:(NSInteger)index
{
    if ([_delegate respondsToSelector:@selector(selectImageWithView:withIndex:)]) {
        [_delegate selectImageWithView:self withIndex:index];
    }
}

-(void)setImage:(UIImage *)image
{
    _image = image;
    
    WCImageView *album = [[WCImageView alloc]init];
    album.image = image;
    [self addSubview:album];
}

-(void)layoutSubviews
{
    CGFloat Y = self.selectBtn.top;
    NSInteger i = 0;
    for (id obj in self.subviews) {
        if ([obj isKindOfClass:[WCImageView class]]) {
    
            WCImageView *album = (WCImageView *)obj;
            album.frame = CGRectMake( 20 + (150 + 20) * (i++), Y, 150, 150);
        }
    }
    
    if(self.hiddenSelectBtn){
        
        self.selectBtn.hidden = YES;
        self.selectBtn.enabled = NO;
    }else{
        if (i >= 3) {
            self.selectBtn.hidden = YES;
            self.selectBtn.enabled = NO;
        }else{
            self.selectBtn.hidden = NO;
            self.selectBtn.enabled = YES;
        }
        self.leftConstraint.constant = 20 + (150 + 20) * i;
    }
    
    [super layoutSubviews];
}

//移除上面的图片
- (void)removeImage
{
    for (id obj in self.subviews) {
        if ([obj isKindOfClass:[WCImageView class]]) {
            
            WCImageView *album = (WCImageView *)obj;
            [album removeFromSuperview];
        }
    }
}

@end

@implementation WCImageView

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.contentMode = UIViewContentModeScaleAspectFill;
        self.clipsToBounds = YES;
    }
    return self;
}

@end

