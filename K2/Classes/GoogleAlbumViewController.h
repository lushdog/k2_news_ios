
#import <UIKit/UIKit.h>
#import "GDataPhotos.h"
#import "GooglePhotoViewController.h"


@interface GoogleAlbumViewController : UIViewController <UITableViewDelegate, UITableViewDataSource> {

	UITableView *tableView;
	NSMutableArray *albums;	
    NSInteger numAlbumsLeftToParse;
    UIView *loadingScreen;
    UIActivityIndicatorView *loadingSpinner;
    NSString *picasaUsername;
    NSString *picasaPassword;
}

@property (nonatomic, retain) GDataServiceGooglePhotos *photoService;
@property (nonatomic, retain) UITableView *tableView;
@property (nonatomic, retain) NSMutableArray *albums;
@property (nonatomic, retain) UIView *loadingScreen;
@property (nonatomic, retain) UIActivityIndicatorView *loadingSpinner;
@property (nonatomic, retain) NSString *picasaUsername;
@property (nonatomic, retain) NSString *picasaPassword;

- (void) fetchThumbnail:(NSString*)urlString loadThumbnailInView:(UIButton*)button;
- (void)imageFetcher:(GDataHTTPFetcher *)fetcher finishedWithData:(NSData *)data;
- (void)imageFetcher:(GDataHTTPFetcher *)fetcher failedWithError:(NSError *)error;
- (void)startLoadingTable;

@end

