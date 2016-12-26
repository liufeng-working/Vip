//
//  CustomAnnotationView.m
//  VIPNavi
//
//  Created by 万存 on 16/4/6.
//  Copyright © 2016年 WanCun. All rights reserved.
//

#import "CustomAnnotationView.h"
@interface CustomAnnotationView()
@property (nonatomic ,strong) UIImageView * portraitImageView ;
@end

@implementation CustomAnnotationView

- (UIImage *)portrait
{
    return self.portraitImageView.image;
}

- (void)setPortrait:(UIImage *)portrait
{
    self.portraitImageView.image = portrait;
}
#pragma mark - Life Cycle

- (id)initWithAnnotation:(id<MAAnnotation>)annotation reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithAnnotation:annotation reuseIdentifier:reuseIdentifier];
    
    if (self)
    {
        UIImage * image = [UIImage imageNamed:@"icon_map_signal-lamp_focusing"] ;
        self.bounds = CGRectMake(0.f, 0.f, image.size.width, image.size.height);
        
        self.backgroundColor = [UIColor clearColor];
        
        /* Create portrait image view and add to view hierarchy. */
        self.portraitImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, image.size.width, image.size.height)];
        [self addSubview:self.portraitImageView];
        
    }
    
    return self;
}
@end
