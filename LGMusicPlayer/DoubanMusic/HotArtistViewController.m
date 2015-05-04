
#import "HotArtistViewController.h"
#import "DownloadManager.h"
#import "HotArtistItem.h"
#import "HotArtistCell.h"
#import "UIImageView+WebCache.h"
#import "DetailViewController.h"


@interface HotArtistViewController ()

@end

@implementation HotArtistViewController

- (void)dealloc
{
    self.urlDict = nil;
    [dataArray release];
    [super dealloc];
}

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {

    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    if (isExistLoadMoreButton) {
        UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        backBtn.frame = CGRectMake(0.0, 0.0, 40.0, 27.0);
        [backBtn setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
        [backBtn addTarget:self action:@selector(backClick) forControlEvents:UIControlEventTouchUpInside];
        self.navigationItem.leftBarButtonItem = [[[UIBarButtonItem alloc] initWithCustomView:backBtn] autorelease];
    }
}

- (void)backClick
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    dataArray = [[NSArray alloc] init];
    currPage = 1;
    total_page = 100;
}

- (void)startDownload
{
    DownloadManager *dm = [DownloadManager sharedManager];
    [dm addDownloadToQueue:Hot_Artist_Url APIType:Hot_Artist_Type];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(downloadFinish:) name:Hot_Artist_Url object:nil];
}

- (void)downlaodPage:(NSInteger)page
{
    isLoading = YES;
    isExistLoadMoreButton = YES;
    DownloadManager *dm = [DownloadManager sharedManager];
    NSString *myTitle = [self.urlDict objectForKey:@"title"];
    self.title = myTitle;
    
    NSString *category = [self.urlDict objectForKey:@"category"];
    NSString *subCategory = [self.urlDict objectForKey:@"subCategory"];
    NSString *subCategoryValue = [self.urlDict objectForKey:@"subCategoryValue"];
    NSString *type = [self.urlDict objectForKey:@"type"];
    NSString *url = [NSString stringWithFormat:@"http://music.douban.com/api/artist/%@?%@=%@&type=%@&sortby=hot&page=%ld",category,subCategory,subCategoryValue,type,(long)page];
    url  = [url stringByAppendingString:@"&cb=%24.setp(0.5083166616968811)&app_name=music_artist&version=50"];
    [dm addDownloadToQueue:url APIType:Hot_Artist_Type];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(downloadFinish:) name:url object:nil];
}

- (void)downloadFinish:(NSNotification *)notification
{
    isLoading = NO;
    DownloadManager *dm = [DownloadManager sharedManager];
    NSDictionary *dict = [dm.resultDict objectForKey:notification.object];
    NSInteger totalPage = [[dict objectForKey:@"total_page"] integerValue];
    if (totalPage > 0) {
        total_page = totalPage;
    }
    NSArray *array = [dict objectForKey:@"artists"];
    if (array == nil) {
        isLoading = YES;
    }
    dataArray = [[[dataArray autorelease] arrayByAddingObjectsFromArray:array] retain];
    [self.tableView reloadData];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
   
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    if (isExistLoadMoreButton) {
        return dataArray.count+1;
    }
    return dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    static NSString *loadMoreCell = @"loadMoreCell";

    if (indexPath.row == dataArray.count) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:loadMoreCell];
        if (cell == nil) {
            cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue2 reuseIdentifier:loadMoreCell] autorelease];
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 40)];
            label.center = cell.center;
            label.text = @"加载更多...";
            [cell.contentView addSubview:label];
            [label release];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        return cell;
    } else {
        HotArtistCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"HotArtistCell" owner:self options:nil] lastObject];
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        }
        
        HotArtistItem *item = [dataArray objectAtIndex:indexPath.row];
        [cell.imageView setImageWithURL:[NSURL URLWithString:item.picture]];
        cell.nameLabel.text = item.name;
        cell.styleLabel.text = item.style;
        cell.followerLabel.text = [NSString stringWithFormat:@"%@人关注",item.follower];
        return cell;
    }
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == dataArray.count) {
        return 44.0f;
    }
    return 60.0f;
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    if (indexPath.row == dataArray.count && !isLoading) {
        currPage++;
        if (currPage >= total_page) {
            currPage = total_page;
        }
        [self downlaodPage:currPage];
    }
    if (indexPath.row < dataArray.count) {
        DetailViewController *detailViewController = [[DetailViewController alloc] initWithNibName:@"DetailViewController" bundle:nil];
        HotArtistItem *item = [dataArray objectAtIndex:indexPath.row];
        detailViewController.artist_id = item.uid;
        [self.navigationController pushViewController:detailViewController animated:YES];
        [detailViewController release];
    }
     
    
}

@end
