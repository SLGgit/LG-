#import "CustomButton.h"

@implementation CustomButton

- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder]) {
        [self configAttribute];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame title:(NSString *)title
{
    if (self = [super initWithFrame:frame]) {
        [self setTitle:title forState:UIControlStateNormal];
        [self configAttribute];
    }
    return self;
}

- (void)configAttribute
{    
    UIImage *image = [UIImage imageNamed:@"player_current"];
    CGRect frame = CGRectMake(self.bounds.size.width/2.0-image.size.width/2.0, self.bounds.size.height-image.size.height, 0, 0);
    frame.size = image.size;
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:frame];
    imageView.image = image;
    imageView.tag = 520;
    imageView.hidden = YES;
    [self addSubview:imageView];
    [imageView release];

}

- (void)showCurrentLabel
{
    UIImageView *view = (UIImageView *)[self viewWithTag:520];
    view.hidden = NO;
}

- (void)hiddenCurrentLabel
{
    UIImageView *view = (UIImageView *)[self viewWithTag:520];
    view.hidden = YES;
}

@end











