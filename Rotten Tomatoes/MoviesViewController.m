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

@interface MoviesViewController ()
@property (weak, nonatomic) IBOutlet UITableView *moviesTableView;
@property (strong, nonatomic) NSArray *movies;

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

  self.moviesTableView.dataSource = self;
  self.moviesTableView.delegate = self;

  [self.moviesTableView registerNib:[UINib nibWithNibName:@"MovieCell" bundle:nil] forCellReuseIdentifier:@"MovieCell"];

  self.moviesTableView.rowHeight = 115;

  NSURL *url = [NSURL URLWithString:@"http://api.rottentomatoes.com/api/public/v1.0/lists/movies/box_office.json?apikey=4jynwmgmv8ftwnjnfakq7adh"];
  NSURLRequest *urlRequest = [NSURLRequest requestWithURL:url];
  [NSURLConnection sendAsynchronousRequest:urlRequest queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
      NSDictionary *responseDictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
      NSLog(@"%@", responseDictionary);
      self.movies = responseDictionary[@"movies"];
      [self.moviesTableView reloadData];
   }];
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

  NSString *urlString = [movie valueForKeyPath:@"posters.thumbnail"];
  NSURL *url = [NSURL URLWithString:urlString];
  [cell.posterView setImageWithURL:url];

  return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  [tableView deselectRowAtIndexPath:indexPath animated:true];

  MovieDetailViewController *viewController = [[MovieDetailViewController alloc] init];
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
