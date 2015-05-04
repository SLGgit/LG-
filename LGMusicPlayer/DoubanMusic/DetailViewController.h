
#import <UIKit/UIKit.h>
#import "CustomButton.h"
@class HotArtistItem;

@interface DetailViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>
{

    IBOutlet UIImageView *headImageView;
    IBOutlet UILabel *nameLabel;
    IBOutlet UILabel *styleLabel;
    IBOutletCollection(CustomButton) NSArray *buttonArray;

    IBOutlet UIScrollView *upScrollView;
    IBOutlet UITableView *musicTableView;
    
    NSArray *dataArray;
}

- (IBAction)musicLibraryClick:(id)sender;

@property (nonatomic,copy) NSString *artist_id;
@property (nonatomic,retain) HotArtistItem *haItem;


@end








