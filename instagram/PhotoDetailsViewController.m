//
//  PhotoDetailsViewController.m
//  instagram
//
//  Created by Naeim Semsarilar on 2/4/15.
//  Copyright (c) 2015 naeim. All rights reserved.
//

#import "PhotoDetailsViewController.h"
#import "PhotoTableViewCell.h"
#import "UIImageView+AFNetworking.h"

@interface PhotoDetailsViewController () <UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation PhotoDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    self.tableView.rowHeight = 200;
    
    
    UINib *photoCellNib = [UINib nibWithNibName:@"PhotoTableViewCell" bundle:nil];
    [self.tableView registerNib:photoCellNib forCellReuseIdentifier:@"PhotoTableViewCell"];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    PhotoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PhotoTableViewCell" forIndexPath:indexPath];
    
    
    NSString *url = [self.instagram valueForKeyPath:@"images.standard_resolution.url"];
    
    [cell.photoView setImageWithURL:[NSURL URLWithString:url]];
    
    return cell;
    
}

@end
