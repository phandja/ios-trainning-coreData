//
//  PlaceTableViewCell.h
//  CoreData
//
//  Created by Treinamento Mobile on 10/27/15.
//  Copyright © 2015 Treinamento Mobile. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PlaceTableViewCell : UITableViewCell

@property (nonatomic,weak) IBOutlet UILabel *placeName;
@property (nonatomic,weak) IBOutlet UIImageView *placeImage;

@end
