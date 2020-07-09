//
//  GeeCustomButton.m
//  gt-captcha3-ios-example
//
//  Created by NikoXu on 08/04/2017.
//  Copyright © 2017 Xniko. All rights reserved.
//

#import "GeeCustomButton.h"
#import "GeeTipsView.h"

//网站主部署的用于验证注册的接口 (api_1)
//#define api_1 @"http://www.geetest.com/demo/gt/register-slide"
//#define api_1 @"http://120.78.83.238:7072/gt/register"
//网站主部署的二次验证的接口 (api_2)
//#define api_2 @"http://www.geetest.com/demo/gt/validate-slide"
//#define api_2 @"http://120.78.83.238:7072/v3/login"

@interface GeeCustomButton () <GT3CaptchaManagerDelegate, GT3CaptchaManagerViewDelegate>
{
    NSString * _sign;
}

@property (nonatomic, strong) UIActivityIndicatorView *indicatorView;

@property (nonatomic, strong) GT3CaptchaManager *manager;

@property (nonatomic, strong) NSString *originalTitle;

@property (nonatomic, assign) BOOL titleFlag;

@property (nonatomic, copy, readwrite) NSDictionary<NSString*,NSString*>* allParams;
@property (nonatomic, copy) NSString * lang;

@property (nonatomic, assign) GT3CaptchaState state;

@end

@implementation GeeCustomButton
@synthesize state;
- (void)setTitle:(NSString *)title forState:(UIControlState)state {
    [super setTitle:title forState:state];
    
    if (!self.titleFlag) {
        self.originalTitle = title;
    }
}

- (GT3CaptchaManager *)manager {
    if (!_manager) {
        _manager = [[GT3CaptchaManager alloc] initWithAPI1:_api1 API2:_api2 timeout:5.0];
        _manager.delegate = self;
        _manager.viewDelegate = self;
        
        [_manager enableDebugMode:YES];
        [_manager useVisualViewWithEffect:[UIBlurEffect effectWithStyle:UIBlurEffectStyleDark]];
    }
    return _manager;
}

- (instancetype)init {
    self = [super init];
    
    if (self) {
        [self _init];
        
        [self addTarget:self action:@selector(startCaptcha) forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    
    if (self) {
        [self _init];
        
        [self addTarget:self action:@selector(startCaptcha) forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame api1:(NSString*)api_1 api2:(NSString*)api_2 lang:(NSString*)lang {
    self = [super initWithFrame:frame];
    
    if (self) {
        self.api1 = api_1;
        self.api2 = api_2;
        self.lang = lang;
        [self _init];
        
        [self addTarget:self action:@selector(startCaptcha) forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}

- (void)_init {
    self.indicatorView = [self createActivityIndicator];
    [self updateUseLanguage:self.lang];
    
    // 必须调用, 用于注册获取验证初始化数据
    [self.manager registerCaptcha:nil];
    
    _geeParams = @{};
}

-(void)setLang:(NSString *)lang{
    _lang = lang;
}

- (UIActivityIndicatorView *)createActivityIndicator {
    UIActivityIndicatorView *indicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [indicatorView setHidesWhenStopped:YES];
    [indicatorView stopAnimating];
    
    return indicatorView;
}

- (void)startCaptcha {
    [self updateUseLanguage:self.lang];
    if (_delegate && [_delegate respondsToSelector:@selector(captchaButtonShouldBeginTapAction:)]) {
        if (![_delegate captchaButtonShouldBeginTapAction:self]) {
            return;
        }
    }
    
    if (self.state == GT3CaptchaStateSuccess || self.state == GT3CaptchaStateFail || self.state == GT3CaptchaStateCancel || self.state == GT3CaptchaStateError) {
//        [self.manager resetGTCaptcha];
        [self.manager stopGTCaptcha];
        [self.manager performSelector:@selector(startGTCaptchaWithAnimated:) withObject:@NO afterDelay:0.45];
    } else {
        [self.manager startGTCaptchaWithAnimated:YES];
    }
    
    
}


- (void)stopCaptcha {
    [self.manager stopGTCaptcha];
}

- (void)showIndicator {
    dispatch_async(dispatch_get_main_queue(), ^{
        self.originalTitle = self.titleLabel.text;
        self.titleFlag = YES;
        [self setTitle:@"" forState:UIControlStateNormal];
        self.titleFlag = NO;
        [self setUserInteractionEnabled:NO];
        self.indicatorView.translatesAutoresizingMaskIntoConstraints = NO;
        [self addSubview:self.indicatorView];
        [self centerActivityIndicatorInButton];
        [self.indicatorView startAnimating];
    });
}

- (void)removeIndicator {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self setTitle:self.originalTitle forState:UIControlStateNormal];
        [self setUserInteractionEnabled:YES];
        [self.indicatorView removeFromSuperview];
        if ([self.delegate respondsToSelector:@selector(geeDidCancel:)]) {
            [self.delegate geeDidCancel:self];
        }
    });
}

- (void)centerActivityIndicatorInButton {
    NSLayoutConstraint *constraintX = [NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.indicatorView attribute:NSLayoutAttributeCenterX multiplier:1 constant:0];
    
    NSLayoutConstraint *constraintY = [NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.indicatorView attribute:NSLayoutAttributeCenterY multiplier:1 constant:0];
    
    [self addConstraints:@[constraintX, constraintY]];
}

#pragma mark GT3CaptchaManagerDelegate

- (void)gtCaptcha:(GT3CaptchaManager *)manager errorHandler:(GT3Error *)error {
    //处理验证中返回的错误
    if (error.code == -999) {
        // 请求被意外中断, 一般由用户进行取消操作导致, 可忽略错误
    }
    else if (error.code == -10) {
        // 预判断时被封禁, 不会再进行图形验证
    }
    else if (error.code == -20) {
        // 尝试过多
    }
    else {
        // 网络问题或解析失败, 更多错误码参考开发文档
    }
    if (!self.isHidden) {
//        [GeeTipsView showTipOnKeyWindow:error.localizedDescription fontSize:12.0];
    }
    NSLog(@"%@", error);
}

- (void)gtCaptchaUserDidCloseGTView:(GT3CaptchaManager *)manager {
    //[GeeTipsView showTipOnKeyWindow:@"验证已被取消"];
    NSLog(@"User Did Close GTView.");
    [manager cancelRequest];
    [manager closeGTViewIfIsOpen];
    [self removeIndicator];

    if ([self.delegate respondsToSelector:@selector(geeDidCancel:)]) {
        [self.delegate geeDidCancel:self];
    }
}

/**
 *  @abstract 通知将要显示图形验证
 *
 *  @param manager 验证管理器
 */
- (void)gtCaptchaWillShowGTView:(GT3CaptchaManager *)manager{
    if ([self.delegate respondsToSelector:@selector(geeWillAppear:)]) {
        [self.delegate geeWillAppear:self];
    }
}

- (void)gtCaptcha:(GT3CaptchaManager *)manager didReceiveSecondaryCaptchaData:(NSData *)data response:(NSURLResponse *)response error:(GT3Error *)error decisionHandler:(void (^)(GT3SecondaryCaptchaPolicy))decisionHandler {
    if (!error) {
        //处理你的验证结果
        NSLog(@"\ndata: %@", [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
        //成功请调用decisionHandler(GT3SecondaryCaptchaPolicyAllow)
        decisionHandler(GT3SecondaryCaptchaPolicyAllow);
        //失败请调用decisionHandler(GT3SecondaryCaptchaPolicyForbidden)
        //decisionHandler(GT3SecondaryCaptchaPolicyForbidden);
        
    }
    else {
        //二次验证发生错误
        decisionHandler(GT3SecondaryCaptchaPolicyForbidden);
        [GeeTipsView showTipOnKeyWindow:error.error_code fontSize:12.0];
    }
    if (_delegate && [_delegate respondsToSelector:@selector(captcha:didReceiveSecondaryCaptchaData:response:error:)]) {
        [_delegate captcha:manager didReceiveSecondaryCaptchaData:data response:response error:error];
    }
    [self removeIndicator];
}




/** 修改API2的请求*/
- (void)gtCaptcha:(GT3CaptchaManager *)manager willSendSecondaryCaptchaRequest:(NSURLRequest *)originalRequest withReplacedRequest:(void (^)(NSMutableURLRequest *))replacedRequest {
    
    NSMutableURLRequest *mRequest = [originalRequest mutableCopy];
    NSMutableString * paramsString = [[NSMutableString alloc] initWithData:mRequest.HTTPBody encoding:NSUTF8StringEncoding];
    NSArray<NSString*> * tParams = [paramsString componentsSeparatedByString:@"&"];
    NSMutableDictionary * allParams = @{}.mutableCopy;
    for (NSString * elem in tParams) {
        if (elem.length > 0) {
            NSArray<NSString*> * arr = [elem componentsSeparatedByString:@"="];
            if (arr.count == 2) {
                if (![arr[0] isEqualToString:@"geetest_challenge"] && ![arr[0] isEqualToString:@"geetest_validate"] && ![arr[0] isEqualToString:@"geetest_seccode"]) {
                    allParams[arr[0]] = arr[1];
                }
                [mRequest setValue:arr[1] forHTTPHeaderField:arr[0]];
            }
        }
    }
    [allParams addEntriesFromDictionary:self.secValiParams];
    self.allParams = allParams;
    
    NSMutableDictionary * httpHearder = mRequest.allHTTPHeaderFields.mutableCopy;
    httpHearder[@"Content-Type"] = @"application/json";
    if (self.httpHeaders.count > 0) {
        for (NSString * key in self.httpHeaders.allKeys) {
            httpHearder[key] = self.httpHeaders[key];
        }
    }
    if (_sign.length > 0) {
        httpHearder[@"sign"] = _sign;
//        allParams[@"sign"] = _sign;
    }
    if ((self.lang.length != 0) && httpHearder[@"lang"] == nil) {
        httpHearder[@"lang"] = self.lang;
    }
    mRequest.allHTTPHeaderFields = httpHearder;
    mRequest.HTTPBody = [NSJSONSerialization dataWithJSONObject:allParams options:0 error:nil];
    NSMutableString * paramsString2 = [[NSMutableString alloc] initWithData:mRequest.HTTPBody encoding:NSUTF8StringEncoding];
    NSLog(@"%@",paramsString2);
        
    replacedRequest(mRequest);
}



/** 不使用默认的二次验证接口*/
- (void)gtCaptcha:(GT3CaptchaManager *)manager didReceiveCaptchaCode:(NSString *)code result:(NSDictionary *)result message:(NSString *)message {
    
    NSMutableDictionary * dic = @{}.mutableCopy;
    [dic addEntriesFromDictionary:result];
    [dic setObject:_sign forKey:@"sign"];
    _geeParams = [NSDictionary dictionaryWithDictionary:dic];
    [_delegate startSecondaryCaptcha:self code:code firstResult:result message:message];
    
    /*
    NSMutableDictionary * allParams = @{}.mutableCopy;
    [allParams addEntriesFromDictionary:_secValiParams];
    //[allParams addEntriesFromDictionary:result];
    
    NSMutableDictionary *headerFields = result.mutableCopy;
    headerFields[@"Content-Type"] = @"application/json";
    if (self.httpHeaders.count > 0) {
        for (NSString * key in self.httpHeaders.allKeys) {
            headerFields[key] = self.httpHeaders[key];
        }
    }
    if (_sign.length > 0) {
        headerFields[@"sign"] = _sign;
//        allParams[@"sign"] = _sign;
    }
    NSMutableURLRequest *secondaryRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:_api2] cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:15.0];
    secondaryRequest.HTTPMethod = @"POST";
    secondaryRequest.allHTTPHeaderFields = headerFields;
    secondaryRequest.HTTPBody = [NSJSONSerialization dataWithJSONObject:allParams options:0 error:nil];
    
    NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:config];
    NSURLSessionDataTask *task = [session dataTaskWithRequest:secondaryRequest completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        [manager closeGTViewIfIsOpen];
        
        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
        if (!error && httpResponse.statusCode == 200) {
            NSError *err;
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:&err];
            if (!err) {
                NSString *status = [dict objectForKey:@"status"];
                if ([status isEqualToString:@"success"]) {
                    NSLog(@"通过业务流程");
                }
                else {
                    NSLog(@"无法通过业务流程");
                }
            }
        }
    }];
    
    [task resume];
    */
}

- (BOOL)shouldUseDefaultSecondaryValidate:(GT3CaptchaManager *)manager {
    return NO;
}


/** 自定义处理API1返回的数据并将验证初始化数据解析给管理器*/
 - (NSDictionary *)gtCaptcha:(GT3CaptchaManager *)manager didReceiveDataFromAPI1:(NSDictionary *)dictionary withError:(GT3Error *)error {
     NSDictionary * data = dictionary[@"data"];
     if (data == nil || [data isEqual:[NSNull null]]) {
         return nil;
     }
     BOOL enable = [data[@"enable"] boolValue];
     if (!enable) {
         [self setHidden:true];
         if (_geeParams.count == 0) {
             _geeParams = @{@"enable" : @"false"};
         }
         [_delegate startSecondaryCaptcha:self code:@"1" firstResult:@{} message:@""];
     }else{
         _sign = data[@"sign"];
     }
//     NSDictionary * result = @{
//                               @"challenge" : data[@"challenge"],
//                               @"gt" : data[@"gt"],
//                               @"success" : data[@"success"],
//                               };
//     return result;
     return data;
 }
 

/** 修改API1的请求 */
- (void)gtCaptcha:(GT3CaptchaManager *)manager willSendRequestAPI1:(NSURLRequest *)originalRequest withReplacedHandler:(void (^)(NSURLRequest *))replacedHandler {
    NSMutableURLRequest *mRequest = [originalRequest mutableCopy];
    NSString * newURL = originalRequest.URL.absoluteString;
    if ([newURL containsString:@"?t="]) {//去除上次的时间戳
        newURL = [newURL componentsSeparatedByString:@"?t="].firstObject;
    }
    newURL = [NSString stringWithFormat:@"%@?t=%.0f", newURL, [[[NSDate alloc] init]timeIntervalSince1970]];
    
//    NSString *newURL = [NSString stringWithFormat:@"%@", originalRequest.URL.absoluteString];
    mRequest.URL = [NSURL URLWithString:newURL];
    if (self.lang.length != 0) {
        [mRequest setValue:self.lang forHTTPHeaderField:@"lang"];
    }
    
    replacedHandler(mRequest);
}

#pragma mark GT3CaptchaManagerViewDelegate

- (void)gtCaptcha:(GT3CaptchaManager *)manager updateCaptchaStatus:(GT3CaptchaState)state error:(GT3Error *)error {
    self.state = state;
    switch (state) {
        case GT3CaptchaStateInactive:
        case GT3CaptchaStateActive:
        case GT3CaptchaStateComputing: {
            [self showIndicator];
            break;
        }
        case GT3CaptchaStateInitial:
        case GT3CaptchaStateFail:
        case GT3CaptchaStateError:
        case GT3CaptchaStateSuccess:
        case GT3CaptchaStateCancel: {
            [self removeIndicator];
            break;
        }
        case GT3CaptchaStateWaiting:
        case GT3CaptchaStateCollecting:
        default: {
            break;
        }
    }
}




- (void)updateUseLanguage:(NSString*)lang {
    self.lang = lang;
    if (self.lang.length > 0) {
        /*
         // Simplified Chinese
        GT3LANGTYPE_ZH_CN = 0,
        // Traditional Chinese
        GT3LANGTYPE_ZH_TW,
        // Traditional Chinese
        GT3LANGTYPE_ZH_HK,
        // Korean
        GT3LANGTYPE_KO_KR,// 暂不支持
        // Japenese
        GT3LANGTYPE_JA_JP,
        // English
        GT3LANGTYPE_EN_US,
        // Indonesian
        GT3LANGTYPE_ID,
        // System language
        GT3LANGTYPE_AUTO
         */
        
        //let langs = ["en" : "en_US", "zh-Hans" : "zh_CN", "zh-Hant" : "zh_TW", "ja" : "ja_JP", "ko" : "ko_KR"]
        GT3LanguageType type = GT3LANGTYPE_EN;
        if ([self.lang isEqualToString:@"en_US"]) {
            type = GT3LANGTYPE_EN;
        }else if ([self.lang isEqualToString:@"zh_CN"]) {
            type = GT3LANGTYPE_ZH_CN;
        }else if ([self.lang isEqualToString:@"zh_TW"]) {
            type = GT3LANGTYPE_ZH_TW;
        } else if ([self.lang isEqualToString:@"ja_JP"]) {
            type = GT3LANGTYPE_JA_JP;
        }else if ([self.lang isEqualToString:@"ko_KR"]) {
            type = GT3LANGTYPE_KO_KR;
        }
        
        [self.manager useLanguage:type];
    }
}


- (void)clearGeeParams {
    _geeParams = @{};
}



@end
