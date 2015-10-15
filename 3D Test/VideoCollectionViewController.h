//
//  VideoCollectionViewController.h
//  3D Test
//
//  Created by Daoyuan Zhai on 10/9/15.
//  Copyright © 2015 Daoyuan Zhai. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VideoCollectionViewController : UICollectionViewController

@property (strong, nonatomic) NSMutableArray* videoThumbs;
@property (strong, nonatomic) NSCache* thumbnailCache;

@end
