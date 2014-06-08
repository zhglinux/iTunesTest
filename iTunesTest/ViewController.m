//
//  ViewController.m
//  iTunesTest
//
//  Created by Colin on 14-6-8.
//  Copyright (c) 2014年 icephone. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController
@synthesize dirArray;
@synthesize docInteractionController;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    //step5. 保存一张图片到设备document文件夹中(为了测试方便)
    UIImage *image = [UIImage imageNamed:@"testPic.jpg"];
    NSData *jpgData = UIImageJPEGRepresentation(image, 0.8);
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsPath = [paths objectAtIndex:0]; //Get the docs directory
    NSString *filePath = [documentsPath stringByAppendingPathComponent:@"testPic.jpg"]; //Add the file name
    [jpgData writeToFile:filePath atomically:YES]; //Write the file
    
    
    //step5. 保存一份txt文件到设备document文件夹中(为了测试方便)
    char *saves = "Colin_csdn";
    NSData *data = [[NSData alloc] initWithBytes:saves length:10];
    filePath = [documentsPath stringByAppendingPathComponent:@"colin.txt"];
    [data writeToFile:filePath atomically:YES];
    
    
    //step6. 获取沙盒里所有文件
	NSFileManager *fileManager = [NSFileManager defaultManager];
	//在这里获取应用程序Documents文件夹里的文件及文件夹列表
	NSArray *documentPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentDir = [documentPaths objectAtIndex:0];
	NSError *error = nil;
	NSArray *fileList = [[NSArray alloc] init];
	//fileList便是包含有该文件夹下所有文件的文件名及文件夹名的数组
	fileList = [fileManager contentsOfDirectoryAtPath:documentDir error:&error];
	
	self.dirArray = [[NSMutableArray alloc] init];
	for (NSString *file in fileList)
	{
		[self.dirArray addObject:file];
	}
	
	//step6. 刷新列表, 显示数据
	[readTable reloadData];
}

//step7. 利用url路径打开UIDocumentInteractionController
- (void)setupDocumentControllerWithURL:(NSURL *)url
{
    if (self.docInteractionController == nil)
    {
        self.docInteractionController = [UIDocumentInteractionController interactionControllerWithURL:url];
        self.docInteractionController.delegate = self;
    }
    else
    {
        self.docInteractionController.URL = url;
    }
}

#pragma mark- 列表操作
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	return 1;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	static NSString *CellName = @"CellName";
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellName];
	if (cell == nil)
	{
		cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellName];
		cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
	}
	
	NSURL *fileURL= nil;
	NSArray *documentPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentDir = [documentPaths objectAtIndex:0];
	NSString *path = [documentDir stringByAppendingPathComponent:[self.dirArray objectAtIndex:indexPath.row]];
	fileURL = [NSURL fileURLWithPath:path];
	
	[self setupDocumentControllerWithURL:fileURL];
	cell.textLabel.text = [self.dirArray objectAtIndex:indexPath.row];
	NSInteger iconCount = [self.docInteractionController.icons count];
    if (iconCount > 0)
    {
        cell.imageView.image = [self.docInteractionController.icons objectAtIndex:iconCount - 1];
    }
    
	return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return [self.dirArray count];
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	QLPreviewController *previewController = [[QLPreviewController alloc] init];
    previewController.dataSource = self;
    previewController.delegate = self;
    
    // start previewing the document at the current section index
    previewController.currentPreviewItemIndex = indexPath.row;
    [[self navigationController] pushViewController:previewController animated:YES];
    //	[self presentViewController:previewController animated:YES completion:nil];
}



#pragma mark - UIDocumentInteractionControllerDelegate

- (NSString *)applicationDocumentsDirectory
{
	return [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
}

- (UIViewController *)documentInteractionControllerViewControllerForPreview:(UIDocumentInteractionController *)interactionController
{
    return self;
}


#pragma mark - QLPreviewControllerDataSource

// Returns the number of items that the preview controller should preview
- (NSInteger)numberOfPreviewItemsInPreviewController:(QLPreviewController *)previewController
{
	return 1;
}

- (void)previewControllerDidDismiss:(QLPreviewController *)controller
{
    // if the preview dismissed (done button touched), use this method to post-process previews
}

// returns the item that the preview controller should preview
- (id)previewController:(QLPreviewController *)previewController previewItemAtIndex:(NSInteger)idx
{
    NSURL *fileURL = nil;
    NSIndexPath *selectedIndexPath = [readTable indexPathForSelectedRow];
	NSArray *documentPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentDir = [documentPaths objectAtIndex:0];
	NSString *path = [documentDir stringByAppendingPathComponent:[self.dirArray objectAtIndex:selectedIndexPath.row]];
	fileURL = [NSURL fileURLWithPath:path];
    return fileURL;
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
