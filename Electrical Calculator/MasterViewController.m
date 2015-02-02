//
//  MasterViewController.m
//  test
//
//  Created by Paul Marney on 1/26/15.
//  Copyright (c) 2015 Paul Marney. All rights reserved.
//

#import "MasterViewController.h"
#import "DetailViewController.h"

@interface MasterViewController (){
    
    DetailViewController *controller;
    int _trans;
    int _preTrans;
}
@property NSMutableArray *objects;
@end

@implementation MasterViewController

- (void)awakeFromNib {
    [super awakeFromNib];
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        self.clearsSelectionOnViewWillAppear = NO;
        self.preferredContentSize = CGSizeMake(320.0, 600.0);
    }
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.detailViewController = (DetailViewController *)[[self.splitViewController.viewControllers
                                                          lastObject] topViewController];
    self.detailViewController = [self.detailViewController init];
    if (!_objects){
        _objects = [[NSMutableArray alloc]init];
    }
    
    [self.objects addObject:@"SubdivisionLoadFormula"];
    [self.objects addObject:@"TransformerCalcFormula"];
    _trans = 0;
    _preTrans = 0;
    [self.tableView reloadData];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Segues

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"showDetail"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        NSDate *object = self.objects[indexPath.row];
        controller = (DetailViewController *)[[segue destinationViewController] topViewController];
        [controller setDetailItem:object];
        if (_trans > _preTrans)
            [controller setTransition:0];
        else
            [controller setTransition:1];
        controller.navigationItem.leftBarButtonItem = self.splitViewController.displayModeButtonItem;
        controller.navigationItem.leftItemsSupplementBackButton = YES;
    }

}

#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.objects.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    
    NSDate *object = self.objects[indexPath.row];
    cell.textLabel.text = [object description];
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath   {
    // Return NO if you do not want the specified item to be editable.
    return NO;
}

-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDate *object = self.objects[indexPath.row];
    if (_trans != indexPath.row) {
        _trans = (int)indexPath.row;
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad){
            [self.detailViewController setDetailItem:object];
            if (_trans > _preTrans)
                [self.detailViewController setTransition:1];
            else
                [self.detailViewController setTransition:0];
            _preTrans = _trans;
        }else {
            [self performSegueWithIdentifier:@"showDetail" sender:self];
        }
    }
}

@end
