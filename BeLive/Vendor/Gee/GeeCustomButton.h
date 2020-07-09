//
//  GeeCustomButton.h
//  gt-captcha3-ios-example
//
//  Created by NikoXu on 08/04/2017.
//  Copyright © 2017 Xniko. All rights reserved.
//

#import <UIKit/UIKit.h>

@import GT3Captcha;

@protocol CaptchaButtonDelegate;

/**
 demo场景: 仅自定按钮与验证事件绑定
 */
@interface GeeCustomButton : UIButton

@property (nonatomic, weak) id<CaptchaButtonDelegate> delegate;
@property (nonatomic, copy) NSDictionary<NSString*,NSString*>*  secValiParams;
@property (nonatomic, copy) NSDictionary<NSString*,NSString*>*  httpHeaders;
@property (nonatomic, copy, readonly) NSDictionary<NSString*,NSString*>* allParams;
@property (nonatomic, copy, readonly) NSDictionary<NSString*,NSString*>* geeParams;
@property (nonatomic, copy) NSString * api1;
@property (nonatomic, copy) NSString * api2;
@property (nonatomic, copy) NSString *identify;

- (instancetype)initWithFrame:(CGRect)frame api1:(NSString*)api_1 api2:(NSString*)api_2 lang:(NSString*)lang;

- (void)startCaptcha;
- (void)stopCaptcha;
- (void)updateUseLanguage:(NSString*)lang;

- (void)clearGeeParams;
-(void)setLang:(NSString *)lang;
@end

@protocol CaptchaButtonDelegate <NSObject>

@optional
- (BOOL)captchaButtonShouldBeginTapAction:(GeeCustomButton *)button;
- (void)captcha:(GT3CaptchaManager *)manager didReceiveSecondaryCaptchaData:(NSData *)data response:(NSURLResponse *)response error:(GT3Error *)error;
- (void)captcha:(GT3CaptchaManager *)manager errorHandler:(GT3Error *)error;


- (void)startSecondaryCaptcha:(GeeCustomButton*)geeButton code:(NSString *)code firstResult:(NSDictionary *)firstResult message:(NSString *)message;

-(void)geeWillAppear:(GeeCustomButton *)gee;

-(void)geeDidCancel:(GeeCustomButton *)gee;

@end
