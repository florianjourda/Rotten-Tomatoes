//
//  MoviesViewController.m
//  Rotten Tomatoes
//
//  Created by Florian Jourda on 2/3/15.
//  Copyright (c) 2015 Box. All rights reserved.
//

#import "MoviesViewController.h"
#import "MovieTableViewCell.h"
#import "MovieCollectionViewCell.h"
#import "UIImageView+AFNetworking.h"
#import "MovieDetailViewController.h"
#import "SVProgressHUD.h"
#import "ErrorBannerViewController.h"
#import "ImageLoaderHelper.h"

typedef enum ListToLoadFromAPI {
    ListToLoadFromAPIBoxOffice,
    ListToLoadFromAPIDVD,
    ListToLoadFromAPISearch
} ListToLoadFromAPI;

typedef enum ViewMode {
    ViewModeTable,
    ViewModeCollection,
} ViewMode;

@interface MoviesViewController ()
@property (weak, nonatomic) IBOutlet UICollectionView *moviesCollectionView;
@property (weak, nonatomic) IBOutlet UITableView *moviesTableView;
@property (strong, nonatomic) NSArray *movies;
@property (nonatomic, strong) UIRefreshControl *refreshControl;
@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentedControl;
@property (strong, nonatomic) UISearchBar *searchBar;
@property (nonatomic, assign) ListToLoadFromAPI listToLoadFromAPI;
@property (nonatomic, assign) ViewMode viewMode;
@property (strong, nonatomic) NSString *searchString;
@property (assign, nonatomic) NSInteger lastRequestIndex;
@property (weak, nonatomic) IBOutlet UIImageView *tableViewIcon;
@property (weak, nonatomic) IBOutlet UIImageView *collectionViewIcon;
@property (weak, nonatomic) IBOutlet UIView *viewModeIcon;
@property (strong, nonatomic) IBOutlet UIView *collectionViewIconSearchBarContainer;

@end

@implementation MoviesViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
  if (self) {
    self.title = @"Movies";
  }
  return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    [SVProgressHUD setBackgroundColor:[UIColor clearColor]];
    [SVProgressHUD setForegroundColor:[UIColor whiteColor]];
    [SVProgressHUD setRingThickness: 4.0];

    self.searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
    self.searchBar.delegate = self;
    self.searchBar.barTintColor = [UIColor colorWithRed:57/255 green:57/255 blue:57/255 alpha:1];

    [self setupMoviesTableView];
    [self setupMoviesCollectionView];
    [self setupRefreshControl];
    [self.segmentedControl addTarget:self
                              action:@selector(onSegmentedControlValueChanged)
                    forControlEvents:UIControlEventValueChanged];
    //[self.refreshControl beginRefreshing];
    //[self.moviesTableView setContentOffset:CGPointMake(0, -200) animated:YES];

    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];

    self.listToLoadFromAPI = ListToLoadFromAPIBoxOffice;

    [self setupViewMode];
    self.searchString = @"";
    self.lastRequestIndex = 0;
    [self loadMoviesWithHUDAndResetOffset];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

# pragma mark - Segmented Control

- (void)onSegmentedControlValueChanged{
    //NSLog(@"%i", self.segmentedControl.selectedSegmentIndex);
    switch (self.segmentedControl.selectedSegmentIndex) {
        case 0:
            self.listToLoadFromAPI = ListToLoadFromAPIBoxOffice;
            break;
        case 1:
            self.listToLoadFromAPI = ListToLoadFromAPIDVD;
            break;
    }
    [self loadMoviesWithHUDAndResetOffset];
}

#pragma mark - View Mode Switch

-(void)setupViewMode {
    //The setup code (in viewDidLoad in your view controller)
    UITapGestureRecognizer *singleFingerTap =
    [[UITapGestureRecognizer alloc] initWithTarget:self
                                            action:@selector(handleViewModeTap:)];
    //[self.tableViewIcon addGestureRecognizer:singleFingerTap];
    //[self.collectionViewIcon addGestureRecognizer:singleFingerTap];
    [self.viewModeIcon addGestureRecognizer:singleFingerTap];

    [self updateViewMode:ViewModeTable];
    //[self updateViewMode:ViewModeCollection];
}

- (void)updateViewMode:(ViewMode)viewMode {
    self.viewMode = viewMode;

    Boolean showCollectionView = (self.viewMode == ViewModeCollection);
    self.moviesCollectionView.hidden = !showCollectionView;
    self.collectionViewIcon.hidden = showCollectionView;

    Boolean showTableView = (self.viewMode == ViewModeTable);
    self.moviesTableView.hidden = !showTableView;
    self.tableViewIcon.hidden = showTableView;

    if (showCollectionView) {
        [self.collectionViewIconSearchBarContainer addSubview: self.searchBar];
    } else {
        self.moviesTableView.tableHeaderView = nil;
        self.moviesTableView.tableHeaderView = self.searchBar;
    }
}

- (void)handleViewModeTap:(UITapGestureRecognizer *)recognizer {
    NSLog(@"TAP");
    //CGPoint location = [recognizer locationInView:[recognizer.view superview]];
    // Toggle View:
    ViewMode newViewMode;
    if (self.viewMode == ViewModeCollection) {
        newViewMode = ViewModeTable;
    } else {
        newViewMode = ViewModeCollection;
    }
    [self updateViewMode:newViewMode];
}

#pragma mark - CollectionView

- (void)setupMoviesCollectionView {
    self.moviesCollectionView.dataSource = self;
    self.moviesCollectionView.delegate = self;

    [self.moviesCollectionView registerNib:[UINib nibWithNibName:@"MovieCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"MovieCollectionViewCell"];

    // Add searchBar to the collectionView.
    // NOTE(florian) 2015-02-08: Needed to but the searchBar inside a view to correctly place it
    NSLog(@"self.searchBar.frame.size.height: %f", self.searchBar.frame.size.height);
    self.moviesCollectionView.contentInset = UIEdgeInsetsMake(95, 0, 0, 0);
    self.collectionViewIconSearchBarContainer = [[UIView alloc] initWithFrame:CGRectMake(0, -95, self.searchBar.frame.size.width, self.searchBar.frame.size.height)];
    [self.moviesCollectionView addSubview: self.collectionViewIconSearchBarContainer];

    // Hide before first load
    [self.moviesCollectionView setHidden:YES];
}

- (UIEdgeInsets)collectionView:(UICollectionView*)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(-50, 0, -50, 0); // top, left, bottom, right
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 0;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 0;
}

//- (CGFloat)collectionView:

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(160, 188);
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.movies.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *movie = self.movies[indexPath.row];
    MovieCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"MovieCollectionViewCell" forIndexPath:indexPath];
    cell.titleLabel.text = movie[@"title"];
    //cell.synopsisLabel.text = movie[@"synopsis"];

    NSString *urlString = [[movie valueForKeyPath:@"posters.thumbnail"] stringByReplacingOccurrencesOfString: @"_tmb.jpg" withString:@"_pro.jpg"];
    [ImageLoaderHelper setImage:cell.posterView withUrlString:urlString];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    //NSLog(@"Selected %i %i", indexPath.section, indexPath.row);
    [collectionView deselectItemAtIndexPath:indexPath animated:true];
    NSDictionary *movie = self.movies[indexPath.row];
    UIImage *lowResImage = ((MovieCollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath]).posterView.image;
    [self showMovieDetails:movie lowResImage:lowResImage];
}

#pragma mark - TableView

- (void)setupMoviesTableView {
    self.moviesTableView.dataSource = self;
    self.moviesTableView.delegate = self;

    [self.moviesTableView registerNib:[UINib nibWithNibName:@"MovieTableViewCell" bundle:nil] forCellReuseIdentifier:@"MovieTableViewCell"];

    self.moviesTableView.rowHeight = 115;

    self.moviesTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.moviesTableView.backgroundColor = [UIColor blackColor];

    // Hide before first load
    self.moviesTableView.hidden = YES;
    self.moviesTableView.tableHeaderView = self.searchBar;
    [self resetViewOffsetToHideSearchBar];
}

- (void)resetViewOffsetToHideSearchBar {
    [self.moviesTableView setContentOffset:CGPointMake(0, self.searchBar.frame.size.height)];
    [self.moviesCollectionView setContentOffset:CGPointMake(0, -self.searchBar.frame.size.height)];

}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  return self.movies.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  MovieTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MovieTableViewCell"];

  NSDictionary *movie = self.movies[indexPath.row];
  cell.titleLabel.text = movie[@"title"];
  cell.synopsisLabel.text = movie[@"synopsis"];

  NSString *urlString = [[movie valueForKeyPath:@"posters.thumbnail"] stringByReplacingOccurrencesOfString: @"_tmb.jpg" withString:@"_pro.jpg"];
  [ImageLoaderHelper setImage:cell.posterView withUrlString:urlString];
  return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    //NSLog(@"Selected %@", indexPath);
    [tableView deselectRowAtIndexPath:indexPath animated:true];

    NSDictionary *movie = self.movies[indexPath.row];
    UIImage *lowResImage = ((MovieTableViewCell *)[tableView cellForRowAtIndexPath:indexPath]).posterView.image;

    [self showMovieDetails:movie lowResImage:lowResImage];
}

- (void)showMovieDetails:(NSDictionary *)movie lowResImage:(UIImage *)lowResImage {
    [self.searchBar resignFirstResponder];
    MovieDetailViewController *viewController = [[MovieDetailViewController alloc] init];
    viewController.movie = movie;
    viewController.lowResImage = lowResImage;
    [self.navigationController pushViewController:viewController animated:true];
}

#pragma mark - Searchbar

//search button was tapped
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [self handleSearch:searchBar];
}

//user finished editing the search text
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    [self handleSearch:searchBar];
}

- (void)handleSearch:(UISearchBar *)searchBar {
    self.listToLoadFromAPI = ListToLoadFromAPISearch;
    self.searchString = searchBar.text;
    [self loadMoviesWithHUD];
}

# pragma mark - Refresh Control

- (void)setupRefreshControl {
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(onRefresh) forControlEvents:UIControlEventValueChanged];
    [self.moviesTableView insertSubview:self.refreshControl atIndex:0];
}

- (void)onRefresh {
    [self loadMovies:^{
        [self.refreshControl endRefreshing];
    }];
}

# pragma mark - Loading Movies

- (void)loadMoviesWithHUDAndResetOffset {
    [SVProgressHUD show];
    [self loadMovies:^{
        [SVProgressHUD dismiss];
        [self resetViewOffsetToHideSearchBar];
    }];
}

- (void)loadMoviesWithHUD {
    [SVProgressHUD show];
    [self loadMovies:^{
        [SVProgressHUD dismiss];
    }];
}

- (void)loadMovies: (void ( ^ )())callback{
    self.lastRequestIndex += 1;
    NSInteger requestIndex = self.lastRequestIndex;
    NSString *urlString;
    switch (self.listToLoadFromAPI) {
        case ListToLoadFromAPIBoxOffice:
            urlString = @"http://api.rottentomatoes.com/api/public/v1.0/lists/movies/box_office.json?apikey=4jynwmgmv8ftwnjnfakq7adh";
             break;
        case ListToLoadFromAPIDVD:
            urlString = @"http://api.rottentomatoes.com/api/public/v1.0/lists/dvds/top_rentals.json?apikey=4jynwmgmv8ftwnjnfakq7adh";
            break;
        case ListToLoadFromAPISearch:
            urlString = [NSString stringWithFormat:@"http://api.rottentomatoes.com/api/public/v1.0/movies.json?apikey=4jynwmgmv8ftwnjnfakq7adh&q=%@", self.searchString];
    }
    NSURL *url = [NSURL URLWithString:urlString];
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:url];
    [NSURLConnection sendAsynchronousRequest:urlRequest queue:[NSOperationQueue mainQueue]
       completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
           // Since it seems we cannot cancel request, let's ignore response that are not from the last request
           if (requestIndex < self.lastRequestIndex) {
               return;
           }
           if (connectionError) {
               ErrorBannerViewController *errorBanner = [[ErrorBannerViewController alloc] init];
               [self.view addSubview:errorBanner.view];
               CGRect frame = errorBanner.view.frame;
               frame.origin.y = self.moviesTableView.frame.origin.y;
               errorBanner.view.frame = frame;
           } else {
               NSDictionary *responseDictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
               //NSLog(@"%@", responseDictionary);
               self.movies = responseDictionary[@"movies"];
               [self.moviesTableView reloadData];
               [self.moviesCollectionView reloadData];
           }
           [callback invoke];
       }
     ];
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
