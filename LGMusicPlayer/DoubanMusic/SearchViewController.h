

#import <UIKit/UIKit.h>
#import "TagsViewController.h"

@interface SearchViewController : UITableViewController<UISearchDisplayDelegate>
{
    NSArray *dataArray;
    NSArray *tagArray;
    UISearchDisplayController *searchDC;
    
    TagsViewController *tagsVC;
}

@end
