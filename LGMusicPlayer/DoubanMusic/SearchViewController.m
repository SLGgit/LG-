
#import "SearchViewController.h"
#import "DownloadManager.h"
#import "SearchItem.h"
#import "HotArtistViewController.h"

@interface SearchViewController ()

@end

@implementation SearchViewController

- (void)dealloc
{
    [tagsVC release];
    [searchDC release];
    [tagArray release];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [dataArray release];
    [super dealloc];
}
- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        self.title = @"分类浏览";
    }
    return self;
}
- (void) searchDisplayControllerDidBeginSearch:(UISearchDisplayController *)controller
{
    if (tagsVC.tagsArray.count == 0 ) {
        return;
    }
    CGRect frame = self.tableView.frame;
    frame.origin.y += 44+20;
    frame.size.height -= 44;
    tagsVC.view.frame = frame;
    [ShareApp addSubView:tagsVC.view];
}
- (void) searchDisplayControllerWillEndSearch:(UISearchDisplayController *)controller;
{
    [tagsVC.view removeFromSuperview];
}
- (void)viewWillDisappear:(BOOL)animated
{
    searchDC.active = NO;
    [tagsVC.view removeFromSuperview];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    tagsVC = [[TagsViewController alloc] init];
    tagsVC.delegate = self;
    UIToolbar *toolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, 320, 35)];
    toolBar.barStyle = UIBarStyleBlackTranslucent;
    UIBarButtonItem *spaceItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    UIBarButtonItem *finishItem = [[UIBarButtonItem alloc] initWithTitle:@"完成" style:UIBarButtonItemStyleDone target:self action:@selector(finishItemClick)];
    toolBar.items = [NSArray arrayWithObjects:spaceItem,finishItem, nil];
    [spaceItem release];
    [finishItem release];
    searchDC.delegate = self;
    DownloadManager *dm = [DownloadManager sharedManager];
    [dm addDownloadToQueue:Search_Url APIType:Search_Type];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(downloadFinish:) name:Search_Url object:nil];
}
- (void)downloadFinish:(NSNotification *)notification
{
    DownloadManager *dm = [DownloadManager sharedManager];
    NSDictionary *dict = [dm.resultDict objectForKey:notification.object];
    dataArray = [[dict objectForKey:@"genrelist"] retain];
    tagArray = [[dict objectForKey:@"tags"] retain];
    tagsVC.tagsArray = tagArray;
    [self.tableView reloadData];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}
#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return dataArray.count;
    }
    return 2;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    if (indexPath.section == 1) {
        NSString *name = indexPath.row ? @"厂牌" : @"DJ";
        cell.textLabel.text = name;
    } else {
        SearchItem *item = [dataArray objectAtIndex:indexPath.row];
        cell.textLabel.text = item.name;
    }
    cell.textLabel.font = [UIFont systemFontOfSize:17];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 320, 30)];
    NSString *str = section == 0 ? @"  流派" : @"  类别";
    label.text = str;
    label.backgroundColor = [UIColor grayColor];
    return [label autorelease];
}

#pragma mark - Table view delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setObject:@"genre" forKey:@"category"];
    [dict setObject:@"gid" forKey:@"subCategory"];
    if (indexPath.section == 0) {
        SearchItem *item = [dataArray objectAtIndex:indexPath.row];
        [dict setObject:item.gid forKey:@"subCategoryValue"];
        [dict setObject:@"artist" forKey:@"type"];
        [dict setObject:item.name forKey:@"title"];
    } else {
        [dict setObject:@"*" forKey:@"subCategoryValue"];
        if (indexPath.row == 0) {
            [dict setObject:@"dj" forKey:@"type"];
            [dict setObject:@"DJ" forKey:@"title"];
        } else if (indexPath.row == 1) {
            [dict setObject:@"label" forKey:@"type"];
            [dict setObject:@"厂牌" forKey:@"title"];
        }
    }
     HotArtistViewController *hotAVC = [[HotArtistViewController alloc] init];
    hotAVC.urlDict = dict;
    [hotAVC downlaodPage:1];
     [self.navigationController pushViewController:hotAVC animated:YES];
     [hotAVC release];
}

@end
