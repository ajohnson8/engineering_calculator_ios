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

-(void)viewDidAppear:(BOOL)animated{
    [self setNavbarImage];
    
    [self.navigationController setToolbarHidden:NO];
    UIBarButtonItem *temp = [[UIBarButtonItem alloc]initWithTitle:@"E-mail" style:UIBarButtonItemStylePlain target:self action:@selector(sendEmail:)];
    [self.navigationController.toolbar setItems:[ NSArray arrayWithObject: temp ]];
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


#pragma mark - MFMailComposeViewControllerDelegate
- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error
{
    switch (result)
    {
        case MFMailComposeResultCancelled:
            NSLog(@"Result: canceled");
            break;
        case MFMailComposeResultSaved:
            NSLog(@"Result: saved");
            break;
        case MFMailComposeResultSent:
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Result" message:@"Mail Sent Successfully" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alert show];
        }
            break;
        case MFMailComposeResultFailed:
            NSLog(@"Result: failed");
            break;
        default:
            NSLog(@"Result: not sent");
            break;
    }
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - UIImagePickerControllerDelegate
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)img editingInfo:(NSDictionary *)editInfo {
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *savedImagePath = [documentsDirectory stringByAppendingPathComponent:@"image.png"];
    NSData *imageData = UIImagePNGRepresentation(img);
    [imageData writeToFile:savedImagePath atomically:NO];
    
    [self setNavbarImage];
    [picker dismissModalViewControllerAnimated:YES];
}

#pragma mark - private methods
-(void)addViews{
    
    Forumal *Forumal1 = [[Forumal alloc]init];
    [Forumal1 setStoryboardName:@"SubdivisionLoadFormula"];
    [Forumal1 setName:@"Subdivision Load"];
    [self.objects addObject:Forumal1];
    
    Forumal *Forumal2 = [[Forumal alloc]init];
    [Forumal2 setStoryboardName:@"TransformerCalcFormula"];
    [Forumal2 setName:@"Transformer Load"];
    [self.objects addObject:Forumal2];
    
    Forumal *Forumal3 = [[Forumal alloc]init];
    [Forumal3 setStoryboardName:@"TransformerRatingCalcFormula"];
    [Forumal3 setName:@"Transformer Rating"];
    [self.objects addObject:Forumal3];
    
    Forumal *Forumal4 = [[Forumal alloc]init];
    [Forumal4 setStoryboardName:@"TransformerFuseCalcFormula"];
    [Forumal4 setName:@"Fuse Wizard"];
    [self.objects addObject:Forumal4];
    
    Forumal *Forumal5 = [[Forumal alloc]init];
    [Forumal5 setStoryboardName:@"AluminumACVoltDropFormula"];
    [Forumal5 setName:@"Main Service Voltage Drop"];
    [self.objects addObject:Forumal5];
    
    Forumal *Forumal6 = [[Forumal alloc]init];
    [Forumal6 setStoryboardName:@"WireSizeVoltageDropFormula"];
    [Forumal6 setName:@"Branch Circut Voltage Drop"];
    [self.objects addObject:Forumal6];
    //Fuse
}

-(void)setNavbarImage{
    
    UIImageView *imgView = [self returnStoredImage];
    UIView *headerView = [[UIView alloc] init];
    headerView.frame = CGRectMake(0, 0, 320, 44);
    imgView.frame = CGRectMake(75, 0, 150, 44);
    imgView.contentMode = UIViewContentModeScaleAspectFit;
    [headerView addSubview:imgView];
    self.navigationController.navigationBar.topItem.titleView = headerView;
    UITapGestureRecognizer *tapGesture1 = [[UITapGestureRecognizer alloc] initWithTarget:self  action:@selector(tapGesture:)];
    tapGesture1.numberOfTapsRequired = 1;
    [tapGesture1 setDelegate:self];
    [self.navigationController.navigationBar.topItem.titleView addGestureRecognizer:tapGesture1];
}

-(UIImageView *) returnStoredImage{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsPath = [paths objectAtIndex:0];
    NSString *filePath = [documentsPath stringByAppendingPathComponent:@"image.png"];
    NSData *pngData = [NSData dataWithContentsOfFile:filePath];
    
    UIImageView *imgView;
    if (pngData.length == 0)
        imgView = [[UIImageView alloc] initWithImage:[self imageWithImage:[UIImage imageNamed:@"image.png"] scaledToSize:CGSizeMake(200, 100)]];
    else
        imgView = [[UIImageView alloc] initWithImage:[self imageWithImage:[UIImage imageWithData:pngData] scaledToSize:CGSizeMake(200, 100)]];
    return imgView;
}

- (UIImage *)imageWithImage:(UIImage *)image scaledToSize:(CGSize)newSize {
    if ([[UIScreen mainScreen] respondsToSelector:@selector(scale)]) {
        if ([[UIScreen mainScreen] scale] == 2.0) {
            UIGraphicsBeginImageContextWithOptions(newSize, YES, 2.0);
        } else {
            UIGraphicsBeginImageContext(newSize);
        }
    } else {
        UIGraphicsBeginImageContext(newSize);
    }
    [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

#pragma marks - Sender
- (void) tapGesture: (id)sender
{
    UIImagePickerController *cardPicker = [[UIImagePickerController alloc]init];
    cardPicker.allowsEditing=YES;
    cardPicker.delegate=self;
    cardPicker.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
        [cardPicker setModalPresentationStyle:UIModalPresentationFormSheet];
    else
        [cardPicker setModalPresentationStyle:UIModalPresentationCurrentContext];
    
    [self presentViewController:cardPicker animated:YES completion:nil];
}

- (void) sendEmail: (id)sender
{
    [_detailViewController setupEmail];
    if ([MFMailComposeViewController canSendMail]) {
        MFMailComposeViewController *composeViewController = [[MFMailComposeViewController alloc] initWithNibName:nil bundle:nil];
        [composeViewController setMailComposeDelegate:self];
        [composeViewController setToRecipients:@[@"marneypt@guc.com"]];
        [composeViewController setSubject:[NSString stringWithFormat:@"%@-%@",@"EngineeringCalculator",[_detailViewController emailTitle]]];
        
        UIImageView *imgView = [self returnStoredImage];
        [imgView setFrame:CGRectMake(0, 0, 200, 100)];
        UIImage * myImage = imgView.image;
        NSData *imageData = [NSData dataWithData:UIImagePNGRepresentation(myImage)];
        NSString *title = @"EngineeringCalculator";
        NSString *formal = [_detailViewController emailTitle];
        NSString *decs = [_detailViewController emailInfromation];
        NSString *formalDecs = [_detailViewController emailDetails];
        
        NSString *emailBody = [NSString stringWithFormat:@"<!DOCTYPE html><html><head><h1 class=\"title\">%@</h1></head><body style=\"  max-width: 300px; margin: 0 auto; \"><div class=\"normalize\"><p>%@</p></div><div><h2>%@</h2><p>%@</p></div></body></html>",title,decs,formal,formalDecs];
        [composeViewController addAttachmentData:imageData mimeType:@"image/png" fileName:@"image.png"];
        [composeViewController setMessageBody:emailBody isHTML:YES];
        
        [self presentViewController:composeViewController animated:YES completion:nil];
    }
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
