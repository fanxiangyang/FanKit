//
//  FanTestViewController.m
//  FanKit
//
//  Created by 向阳凡 on 2017/3/10.
//  Copyright © 2017年 凡向阳. All rights reserved.
//

#import "FanTestViewController.h"

@interface FanTestViewController ()

@end

@implementation FanTestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
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
