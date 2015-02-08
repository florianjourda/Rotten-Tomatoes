//
//  MoviesViewController.m
//  Rotten Tomatoes
//
//  Created by Florian Jourda on 2/3/15.
//  Copyright (c) 2015 Box. All rights reserved.
//

#import "MoviesViewController.h"
#import "MovieCell.h"
#import "UIImageView+AFNetworking.h"
#import "MovieDetailViewController.h"
#import "SVProgressHUD.h"
#import "ErrorBannerViewController.h"

@interface MoviesViewController ()
@property (weak, nonatomic) IBOutlet UITableView *moviesTableView;
@property (strong, nonatomic) NSArray *movies;
@property (nonatomic, strong) UIRefreshControl *refreshControl;

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
  [self setupMoviesTableView];
  [self setupRefreshControl];
  //[self.refreshControl beginRefreshing];
  //[self.moviesTableView setContentOffset:CGPointMake(0, -200) animated:YES];

  [self loadMovies:nil withHUD:TRUE];
}

- (void)setupMoviesTableView {
  self.moviesTableView.dataSource = self;
  self.moviesTableView.delegate = self;

  [self.moviesTableView registerNib:[UINib nibWithNibName:@"MovieCell" bundle:nil] forCellReuseIdentifier:@"MovieCell"];

  self.moviesTableView.rowHeight = 115;

  self.moviesTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
  self.moviesTableView.backgroundColor = [UIColor blackColor];

  // Hide before first laod
  [self.moviesTableView setHidden:YES];

  [SVProgressHUD setBackgroundColor:[UIColor clearColor]];
  [SVProgressHUD setForegroundColor:[UIColor whiteColor]];
}

- (void)setupRefreshControl {
  self.refreshControl = [[UIRefreshControl alloc] init];
  [self.refreshControl addTarget:self action:@selector(onRefresh) forControlEvents:UIControlEventValueChanged];
  [self.moviesTableView insertSubview:self.refreshControl atIndex:0];
}

- (void)onRefresh {
  [self loadMovies:^{
      [self.refreshControl endRefreshing];
    }
    withHUD:FALSE
  ];
}

- (void)loadMovies: (void ( ^ )())callback withHUD:(BOOL)showHUD{
  if (showHUD) {
    [SVProgressHUD show];
  }
  NSURL *url = [NSURL URLWithString:@"http://api.rottentomatoes.com/api/public/v1.0/lists/movies/box_office.json?apikey=4jynwmgmv8ftwnjnfakq7adh"];
  NSURLRequest *urlRequest = [NSURLRequest requestWithURL:url];
  [NSURLConnection sendAsynchronousRequest:urlRequest queue:[NSOperationQueue mainQueue]
      completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
          [SVProgressHUD dismiss];
          if (connectionError) {
            ErrorBannerViewController *errorBanner = [[ErrorBannerViewController alloc] init];
            [self.view addSubview:errorBanner.view];
            return;
          }
          NSDictionary *responseDictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
          //NSLog(@"%@", responseDictionary);
          self.movies = responseDictionary[@"movies"];
          [self.moviesTableView reloadData];
          [self.moviesTableView setHidden:NO];
          [callback invoke];
      }
  ];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - TableView methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  return self.movies.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  MovieCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MovieCell"];

  NSDictionary *movie = self.movies[indexPath.row];
  cell.titleLabel.text = movie[@"title"];
  cell.synopsisLabel.text = movie[@"synopsis"];

  NSString *urlString = [[movie valueForKeyPath:@"posters.thumbnail"] stringByReplacingOccurrencesOfString: @"_tmb.jpg" withString:@"_pro.jpg"];
  NSURL *url = [NSURL URLWithString:urlString];
  [cell.posterView setImageWithURL:url];

  return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  [tableView deselectRowAtIndexPath:indexPath animated:true];

  MovieDetailViewController *viewController = [[MovieDetailViewController alloc] init];
  viewController.movie = self.movies[indexPath.row];
  viewController.lowResImage = ((MovieCell *)[tableView cellForRowAtIndexPath:indexPath]).posterView.image;
  [self.navigationController pushViewController:viewController animated:true];
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
