//
//  SupportTypeListViewController.m
//  ImageIODemo
//
//  Created by Tian on 2021/6/2.
//

#import "SupportTypeListViewController.h"

@interface SupportTypeListViewController ()

@property (nonatomic, copy) NSArray *types;
@end

@implementation SupportTypeListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Support Types";
    self.types = [self getSupportTypeItems];
    self.tableView.tableFooterView = [UIView new];
}

- (NSArray *)getSupportTypeItems {
    CFArrayRef mySourceTypes = CGImageSourceCopyTypeIdentifiers();
    CFShow(mySourceTypes);
    CFArrayRef myDestinationTypes = CGImageDestinationCopyTypeIdentifiers();
    CFShow(myDestinationTypes);
    NSArray *sourcetype = (__bridge NSArray *)mySourceTypes;
    CFRelease(mySourceTypes);
    CFRelease(myDestinationTypes);
    return sourcetype;
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.types.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *typeCellIdentifier = @"typeCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:typeCellIdentifier];
    cell.textLabel.text = [self.types objectAtIndex:indexPath.row];
    return cell;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 50;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

#pragma mark - UITableViewDataSourcePrefetching

- (void)tableView:(nonnull UITableView *)tableView prefetchRowsAtIndexPaths:(nonnull NSArray<NSIndexPath *> *)indexPaths
{
    
}

@end
