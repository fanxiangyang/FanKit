//
//  FanTestViewController.m
//  FanKit
//
//  Created by 向阳凡 on 2017/3/10.
//  Copyright © 2017年 凡向阳. All rights reserved.
//

#import "FanTestViewController.h"
#import "FanRSA.h"

@interface FanTestViewController ()

@end

@implementation FanTestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self testRSA];
}

-(void)testRSA{
    NSString *siyao = @"-----BEGIN PRIVATE KEY-----\nMIIBVgIBADANBgkqhkiG9w0BAQEFAASCAUAwggE8AgEAAkEA0YEsIeIpbyYhzWSf\npa1ZteoGFxJsH+VXc3HngEneK3PlSIj//Q39TAzQprIJtNoI6k7RDHOZggffZJ+v\njN41RwIDAQABAkANJEwvZ+9vcHXoW2qESwZ4mdB9/ALaUVmV/UwnSPrtwL8/jMgL\ndbaR4gYGqK0qlaKW89xizfnGAAdaNQYaCxoBAiEA96NTUnL/9mRQy2ui7Og22TwA\ncNDnQp00Xd7NoayHAQECIQDYlDUkhqUYzWsydbzctIzxvveMN6oxqB+UkDJOsn7u\nRwIhANjgXTS0Kp9rM6cz2TiKFp8iAXDMQ/z/GMGtQ4H4SzQBAiEAx14/QV11E0zd\ntjit35mQ+WTq6je/wzBZyd+nf8xOjjcCIQDzreOntgLL91+Pyea034PSgljOVIda\nlScgsEauudnJHg==\n-----END PRIVATE KEY-----";

    NSString *gongyao = @"-----BEGIN PUBLIC KEY-----\nMFwwDQYJKoZIhvcNAQEBBQADSwAwSAJBANGBLCHiKW8mIc1kn6WtWbXqBhcSbB/l V3Nx54BJ3itz5UiI//0N/UwM0KayCbTaCOpO0QxzmYIH32Sfr4zeNUcCAwEAAQ==\n-----END PUBLIC KEY-----";
    
    NSString *str=@"我看门狗的啥控件地方了啥控件法律手段";
    
    NSString *eStr=[FanRSA fan_encryptString:str publicKey:gongyao];
    
    FanPrintf(@"加密：%@",eStr);
//
//    eStr=@"K6y/zW4fKlmtfYkeOYtsbsoKmkuSdNXjLgW1GMTRUaAuSmerqFWrAVrf0A4+N+CvMBRUw4zcguRjAxYtXulHww==";
//
//    eStr=@"E0nEn3IcAORjoZJPQOuOw5lLPCqh6wjpS110z9HNTPmK3eMhfOX19U5VMm8lgri3nu07DTEXazgPHz743FJnpA==";
    NSString *dStr=[FanRSA fan_decryptString:eStr privateKey:siyao];
    
    FanPrintf(@"解密：%@",dStr);

    
    
}


//int (*orig_sysctlbyname)(const char *name, void *oldp, size_t *oldlenp, void *newp, size_t newlen);
//
//int mysysctlbyname(const char *name, void *oldp, size_t *oldlenp, void *newp, size_t newlen){
//    if (strcmp(name,"hw.machine") == 0) {
//        if (oldp != NULL) {
//            int ret = orig_sysctlbyname(name,oldp,oldlenp,newp,newlen);
//            const char* mechine = "iWatch Edition";
//            strncpy((char *)oldp,mechine,strlen(mechine));
//            return ret;
//        }else{
//            int ret = orig_sysctlbyname(name,oldp,oldlenp,newp,newlen);
//            return ret;
//        }
//    }else{
//        return orig_sysctlbyname(name,oldp,oldlenp,newp,newlen);
//    }
//}
//%ctor {
//    MSHookFunction((void *)MSFindSymbol(NULL,"_sysctlbyname"), (void *)mysysctlbyname, (void **)&orig_sysctlbyname);
//}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
