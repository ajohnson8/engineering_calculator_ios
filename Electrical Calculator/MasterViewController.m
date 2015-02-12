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
    
    [self addViews];
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
        Forumal *object = self.objects[indexPath.row];
        
        controller = (DetailViewController *)[[segue destinationViewController] topViewController];
        [controller setDetailItem:object.storyboardName];

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
    ForumalCell *cell = (ForumalCell *) [_table dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    if (cell == nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"Cell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    Forumal *object = self.objects[indexPath.row];
    cell.name.text = object.name;
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath   {
    // Return NO if you do not want the specified item to be editable.
    return NO;
}

-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    Forumal *object = self.objects[indexPath.row];

        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad && _trans != indexPath.row){
            NSLog(@"%ld > %ld",(long)indexPath.row ,(long)_trans);
            if (indexPath.row > _trans)
                [self.detailViewController setTransition:1];
            else
                [self.detailViewController setTransition:0];
            _trans = (int)indexPath.row;
            _preTrans = (int)indexPath.row;
            
            [self.detailViewController setDetailItem:object.storyboardName];
            
        }else if (UI_USER_INTERFACE_IDIOM() != UIUserInterfaceIdiomPad) {
            NSLog(@"Show %@",object.name);
            _trans = (int)indexPath.row;
            [self performSegueWithIdentifier:@"showDetail" sender:self];
        }
}

-(void)addViews{
    
    Forumal *Forumal1 = [[Forumal alloc]init];
    [Forumal1 setStoryboardName:@"SubdivisionLoadFormula"];
    [Forumal1 setName:@"Subdivision Load"];
    [self.objects addObject:Forumal1];
    
    Forumal *Forumal2 = [[Forumal alloc]init];
    [Forumal2 setStoryboardName:@"TransformerCalcFormula"];
    [Forumal2 setName:@"Transformer"];
    [self.objects addObject:Forumal2];
    
    Forumal *Forumal3 = [[Forumal alloc]init];
    [Forumal3 setStoryboardName:@"TransformerRatingCalcFormula"];
    [Forumal3 setName:@"Transformer Rating"];
    [self.objects addObject:Forumal3];
    
    Forumal *Forumal4 = [[Forumal alloc]init];
    [Forumal4 setStoryboardName:@"TransformerFuseCalcFormula"];
    [Forumal4 setName:@"Transformer Fuse"];
    [self.objects addObject:Forumal4];
    
    Forumal *Forumal5 = [[Forumal alloc]init];
    [Forumal5 setStoryboardName:@"AluminumACVoltDropFormula"];
    [Forumal5 setName:@"Aluminum AC Volt Drop"];
    [self.objects addObject:Forumal5];
    
    Forumal *Forumal6 = [[Forumal alloc]init];
    [Forumal6 setStoryboardName:@"WireSizeVoltageDropFormula"];
    [Forumal6 setName:@"Wire Size Voltage Drop"];
    [self.objects addObject:Forumal6];
    //Fuse
}

@end

@implementation Forumal

-(id)init{
    self = [super init];
    if (self) {
    }
    return self;
}
@end

@implementation ForumalCell

@end
