//
//  PhotosViewController.m
//  instagram
//
//  Created by Naeim Semsarilar on 2/4/15.
//  Copyright (c) 2015 naeim. All rights reserved.
//

#import "PhotosViewController.h"
#import "PhotoTableViewCell.h"
#import "UIImageView+AFNetworking.h"
#import "PhotoDetailsViewController.h"

@interface PhotosViewController () <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSArray *instagrams;
@property (nonatomic, strong) UIRefreshControl *refreshControl;
@end

@implementation PhotosViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSURL *url = [NSURL URLWithString:@"https://api.instagram.com/v1/media/popular?client_id=73ea406dbe0749058a96709ab8ab25a4"];
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url];
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        NSDictionary *responseDictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        self.instagrams = responseDictionary[@"data"];
        [self.tableView reloadData];
    }];
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    self.tableView.rowHeight = 200;

    
    UINib *photoCellNib = [UINib nibWithNibName:@"PhotoTableViewCell" bundle:nil];
    [self.tableView registerNib:photoCellNib forCellReuseIdentifier:@"PhotoTableViewCell"];
    
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(onRefresh) forControlEvents:UIControlEventValueChanged];
    [self.tableView insertSubview:self.refreshControl atIndex:0];
    
    
    
    UIView *tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 50)];
    UIActivityIndicatorView *loadingView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [loadingView startAnimating];
    loadingView.center = tableFooterView.center;
    [tableFooterView addSubview:loadingView];
    self.tableView.tableFooterView = tableFooterView;

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - Table view methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.instagrams.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSDictionary *instagram = self.instagrams[indexPath.row];
    PhotoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PhotoTableViewCell" forIndexPath:indexPath];
    
    
    NSString *url = [instagram valueForKeyPath:@"images.thumbnail.url"];

    [cell.photoView setImageWithURL:[NSURL URLWithString:url]];
    
    
    // load more?
    
    if (indexPath.row == self.instagrams.count - 1) {
        NSURL *url = [NSURL URLWithString:@"https://api.instagram.com/v1/media/popular?client_id=73ea406dbe0749058a96709ab8ab25a4"];
        NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url];
        [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
            
            NSDictionary *responseDictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
            
            NSMutableArray *newArray = [NSMutableArray arrayWithArray:self.instagrams];
            [newArray addObjectsFromArray:responseDictionary[@"data"]];
            
            self.instagrams = [NSArray arrayWithArray:newArray];
            [self.tableView reloadData];
        }];
    }
    
    
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    PhotoDetailsViewController *vc = [[PhotoDetailsViewController alloc] init];
    
    vc.instagram = self.instagrams[indexPath.row];
    
    [self.navigationController pushViewController:vc animated:YES];
}



- (void)onRefresh {
    NSURL *url = [NSURL URLWithString:@"https://api.instagram.com/v1/media/popular?client_id=73ea406dbe0749058a96709ab8ab25a4"];
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url];
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        NSDictionary *responseDictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        self.instagrams = responseDictionary[@"data"];
        [self.refreshControl endRefreshing];
        [self.tableView reloadData];
    }];
}


@end
