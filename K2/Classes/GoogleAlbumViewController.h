
#import <UIKit/UIKit.h>
#import "GDataPhotos.h"


@interface GoogleAlbumViewController : UIViewController <UITableViewDelegate, UITableViewDataSource> {

	UITableView *tableView;
	NSMutableArray *albums;	
    NSInteger numAlbumsLeftToParse;
}

@property (nonatomic, retain) GDataServiceGooglePhotos *photoService;
@property (nonatomic, retain) UITableView *tableView;
@property (nonatomic, retain) NSMutableArray *albums;

- (void) fetchThumbnail:(NSString*)urlString loadThumbnailInView:(UIButton*)button;
- (void)imageFetcher:(GDataHTTPFetcher *)fetcher finishedWithData:(NSData *)data;
- (void)imageFetcher:(GDataHTTPFetcher *)fetcher failedWithError:(NSError *)error;
- (void)startLoadingTable;

@end

