//
//  AGSSUIShareActionSheetController.m
//  AGSharedSDK
//
//  Created by 覃凤姣 on 16/5/5.
//  Copyright © 2016年 覃凤姣. All rights reserved.
//

#import "AGSSUIShareActionSheetController.h"
#import "AGSSUIShareActionSheetItem.h"
#import "UIView+BlocksKit.h"
#import "UIColor+AGExtension.h"
#define kIconWidth 58
#define kContainerViewWidth     [UIScreen mainScreen].bounds.size.width * 0.25
#define kContainerViewHeight kIconWidth + 21 +10
#define kShareControllerViewWidth [UIScreen mainScreen].bounds.size.width
@interface AGSSUIShareActionSheetController()
@property (nonatomic,strong)UIView *shareControllerView;
@property (nonatomic,strong)UIView *shadowView;
@property (nonatomic,strong)UIButton *cancelButton;
@property (nonatomic,assign)CGFloat shareControllerViewHeight;
@property (nonatomic,copy)SSUIShareActionSheetItemClickHandler shareActionSheetItemClickHandler;
@property (nonatomic,copy)SSUIShareActionSheetCancelHandler shareActionSheetCancelHandler;
@property (nonatomic,strong) NSArray *items;
@end
@implementation AGSSUIShareActionSheetController

- (instancetype)initWithItems:(NSArray *)items{
    AGSSUIShareActionSheetController *shareController = [[AGSSUIShareActionSheetController alloc] init];
    shareController.items = items;
    shareController.shadowView = [[UIView alloc]initWithFrame:[UIScreen mainScreen].bounds];
    [shareController.shadowView bk_whenTapped:^{
        [shareController dismiss];
    }];
    [shareController.shadowView setBackgroundColor:[UIColor colorWithHex:0x000000 andAlpha:0.3]];
    shareController.shareControllerView = [[UIView alloc] init];
    [shareController.shadowView addSubview:shareController.shareControllerView];
    [shareController.shareControllerView setBackgroundColor:[UIColor whiteColor]];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 44)];
    [titleLabel setTextAlignment:NSTextAlignmentCenter];
    [titleLabel setText:@"分享"];
    [shareController.shareControllerView addSubview:titleLabel];
    CGFloat px = 0;
    CGFloat py = 44;
    shareController.shareControllerViewHeight = 88 + kContainerViewHeight + 10;
    int i = 0;
    for (AGSSUIShareActionSheetItem *item in items) {
        UIView *containerView = [[UIView alloc] init];
        containerView.frame = CGRectMake(px, py, kContainerViewWidth, kContainerViewHeight);
        UIImageView *iconImageView = [[UIImageView alloc] initWithImage:item.icon];
        iconImageView.tag = 1000 + i;
        iconImageView.frame = CGRectMake(kContainerViewWidth * 0.25,0, kIconWidth, kIconWidth);
        [iconImageView setUserInteractionEnabled:YES];
        [iconImageView bk_whenTapped:^{
//            if (shareController.shareActionSheetItemClickHandler) {
                shareController.shareActionSheetItemClickHandler(i,item);

//            }
        }];
        UILabel *labelLabel = [[UILabel alloc] init];
        labelLabel.frame = CGRectMake(0,kContainerViewHeight - 21, kContainerViewWidth, 21);
        [labelLabel setTextAlignment:NSTextAlignmentCenter];
        [labelLabel setText:item.label];
        [containerView addSubview:iconImageView];
        [containerView addSubview:labelLabel];
        [shareController.shareControllerView addSubview:containerView];
        px += kContainerViewWidth;
        if (px > [UIScreen mainScreen].bounds.size.width - kContainerViewWidth) {
            px = 0;
            py += kContainerViewHeight + 10;
            shareController.shareControllerViewHeight += kContainerViewHeight + 10;
        }
        i++;
    }
    UIView *separateView = [[UIView alloc] initWithFrame:CGRectMake(0, shareController.shareControllerViewHeight - 45, [UIScreen mainScreen].bounds.size.width, 1)];
    [separateView setBackgroundColor:[UIColor colorWithHex:0x000000 andAlpha:0.1]];
    [shareController.shareControllerView addSubview:separateView];
    UIButton *cancelButton = [[UIButton alloc] initWithFrame:CGRectMake(0, shareController.shareControllerViewHeight - 44, kShareControllerViewWidth, 44)];
    [cancelButton.titleLabel setTextAlignment:NSTextAlignmentCenter];
    [cancelButton setTitle:@"取消" forState:UIControlStateNormal];
    [cancelButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [cancelButton.titleLabel setTextAlignment:NSTextAlignmentCenter];
    [shareController.shareControllerView addSubview:cancelButton];
    [cancelButton bk_whenTapped:^{
        if (shareController.shareActionSheetCancelHandler) {
            shareController.shareActionSheetCancelHandler();
        }
        [shareController dismiss];
    }];
    return shareController;
}

- (void)showInView:(UIView *)view{
    [view addSubview:self.shadowView];
    self.shareControllerView.frame = CGRectMake(0, self.shadowView.frame.size.height, kShareControllerViewWidth, self.shareControllerViewHeight);
    [UIView animateWithDuration:0.3 animations:^{
        self.shareControllerView.frame = CGRectMake(0, self.shadowView.frame.size.height - self.shareControllerViewHeight, kShareControllerViewWidth, self.shareControllerViewHeight);
    } completion:^(BOOL finished) {
        
    }];
}

- (void)dismiss{
       [UIView animateWithDuration:0.3 animations:^{
        self.shareControllerView.frame = CGRectMake(0, self.shadowView.frame.size.height, kShareControllerViewWidth, self.shareControllerViewHeight);
    } completion:^(BOOL finished) {
        [self.shadowView removeFromSuperview];
    }];

}

- (void)onItemClick:(SSUIShareActionSheetItemClickHandler)itemClickHandler{
    self.shareActionSheetItemClickHandler = itemClickHandler;
}

- (void)onCancel:(SSUIShareActionSheetCancelHandler)cancelHandler{
    self.shareActionSheetCancelHandler = cancelHandler;
    [self dismiss];
}


@end
