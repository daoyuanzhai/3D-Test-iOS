//
//  VideoCollectionViewController.m
//  3D Test
//
//  Created by Daoyuan Zhai on 10/9/15.
//  Copyright © 2015 Daoyuan Zhai. All rights reserved.
//

#import "VideoCollectionViewController.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import <AVFoundation/AVFoundation.h>

@interface VideoCollectionViewController ()<UICollectionViewDelegateFlowLayout>

@property (nonatomic) NSInteger cellSize;

@end

@implementation VideoCollectionViewController

static NSString * const reuseIdentifier = @"Cell";

- (void)viewDidLoad {
    [super viewDidLoad];

    self.cellSize = (NSInteger)self.collectionView.frame.size.width/3 - 10;
    [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(orientationChanged:) name:UIDeviceOrientationDidChangeNotification object:[UIDevice currentDevice]];
    
    self.videoThumbs = [NSMutableArray arrayWithObjects:@"https://s3-ap-northeast-1.amazonaws.com/hellocafe/profile/Lisa_Keighery.png",
                        @"https://s3-ap-northeast-1.amazonaws.com/hellocafe/profile/insu_Park.jpg",
                        @"https://s3-ap-northeast-1.amazonaws.com/hellocafe/profile/Jawon_Lee.jpg",
                        @"https://s3-ap-northeast-1.amazonaws.com/hellocafe/profile/Joshua_Glandorf.jpg",
                        @"https://s3-ap-northeast-1.amazonaws.com/hellocafe/profile/Christina_Lee.jpg",
                        @"https://s3-ap-northeast-1.amazonaws.com/hellocafe/profile/bw2_360.png",
                        @"https://s3-ap-northeast-1.amazonaws.com/hellocafe/profile/Luis_Mora.jpg",
                        @"https://s3-ap-northeast-1.amazonaws.com/hellocafe/profile/Arthur_Kim.jpg",
                        @"https://s3-ap-northeast-1.amazonaws.com/hellocafe/profile/Jooyoung_Lee.jpg",
                        @"https://s3-ap-northeast-1.amazonaws.com/hellocafe/profile/Joshua_Lee.jpg",
                        @"https://s3-ap-northeast-1.amazonaws.com/hellocafe/profile/Maria_Loureiro.jpg", nil];
    self.thumbnailCache = [[NSCache alloc] init];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) orientationChanged:(NSNotification*) note {
    self.cellSize = (NSInteger)self.collectionView.frame.size.width/3 - 10;
    [self.collectionView reloadData];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
#warning Incomplete implementation, return the number of sections
    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
#warning Incomplete implementation, return the number of items
    return [self.videoThumbs count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"cellForRowAtIndexPath %ld", (long)indexPath.row);

    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    
    // Configure the cell
    UIImageView *collectionImageView = (UIImageView *)[cell viewWithTag:100];

    NSData* imageData = [self.thumbnailCache objectForKey:[NSString stringWithFormat:@"%ld", (long)indexPath.row]];
    if (nil != imageData) {
        collectionImageView.image = [UIImage imageWithData:imageData];
        
    } else {
        collectionImageView.image = [UIImage imageNamed:@"videoplayer_placeholder.png"];
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, (unsigned long) NULL), ^(void){
            UIImage* image = [self thumbnailImageFromURL:[NSURL URLWithString:@"http://ac-rsbspggr.clouddn.com/T2KpNCNZHuh5UIhBOrf9LHA.MOV"]];
            if (nil != image) {
                NSData* tmpImageData = UIImagePNGRepresentation(image);
                [self.thumbnailCache setObject:tmpImageData forKey:[NSString stringWithFormat:@"%ld", (long)indexPath.row]];
                NSLog(@"download image for %ld", (long)indexPath.row);
                [self performSelectorOnMainThread:@selector(reloadTableViewDataAtIndexPath:) withObject:indexPath waitUntilDone:NO];
            } else {
                // do nothing...
            }
        });
    }
//    [collectionImageView sd_setImageWithURL:[NSURL URLWithString:@"http://ac-rsbspggr.clouddn.com/S6nufdJ82ECktHx1ZquzK9D.jpg"] placeholderImage:[UIImage imageNamed:@"image2.png"]];
    
    return cell;
}

- (void) reloadTableViewDataAtIndexPath: (NSIndexPath *)indexPath{
    NSLog(@"MyWineViewController: in reload collection view data for index: %ld", (long)indexPath.row);
    
    [self.collectionView reloadItemsAtIndexPaths: @[indexPath]];
}

- (UIImage *) thumbnailImageFromURL:(NSURL *)videoURL{
    
    AVURLAsset *asset = [[AVURLAsset alloc] initWithURL: videoURL options:nil];
    AVAssetImageGenerator *generator = [[AVAssetImageGenerator alloc] initWithAsset:asset];
    NSError *err = NULL;
    CMTime requestedTime = CMTimeMake(1, 60);     // To create thumbnail image
    CGImageRef imgRef = [generator copyCGImageAtTime:requestedTime actualTime:NULL error:&err];
    NSLog(@"err = %@, imageRef = %@", err, imgRef);
    
    UIImage *thumbnailImage = [[UIImage alloc] initWithCGImage:imgRef];
    CGImageRelease(imgRef);    // MUST release explicitly to avoid memory leak
    
    return thumbnailImage;
}

#pragma mark <UICollectionViewDelegate>

-(void) collectionView:(UICollectionView*) collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    // TODO: Select Item
}

-(void) collectionView:(UICollectionView*) collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath {
    // TODO: Deselect Item
}

-(CGSize) collectionView:(UICollectionView*) collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(self.cellSize, self.cellSize);
}

/*
// Uncomment this method to specify if the specified item should be highlighted during tracking
- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath {
	return YES;
}
*/

/*
// Uncomment this method to specify if the specified item should be selected
- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}
*/

/*
// Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
- (BOOL)collectionView:(UICollectionView *)collectionView shouldShowMenuForItemAtIndexPath:(NSIndexPath *)indexPath {
	return NO;
}

- (BOOL)collectionView:(UICollectionView *)collectionView canPerformAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	return NO;
}

- (void)collectionView:(UICollectionView *)collectionView performAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	
}
*/

@end
