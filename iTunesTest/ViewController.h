//
//  ViewController.h
//  iTunesTest
//
//  Created by Colin on 14-6-8.
//  Copyright (c) 2014年 icephone. All rights reserved.
//

#import <UIKit/UIKit.h>

//step1. 导入QuickLook库和头文件
#import <QuickLook/QuickLook.h>

//step2. 继承协议
@interface ViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,QLPreviewControllerDataSource,QLPreviewControllerDelegate,UIDocumentInteractionControllerDelegate>
{
    //step3. 声明显示列表
    IBOutlet UITableView *readTable;
}

//setp4. 声明变量
//UIDocumentInteractionController : 一个文件交互控制器,提供应用程序管理与本地系统中的文件的用户交互的支持
//dirArray : 存储沙盒子里面的所有文件
@property(nonatomic,retain) NSMutableArray *dirArray;
@property (nonatomic, strong) UIDocumentInteractionController *docInteractionController;
@end
