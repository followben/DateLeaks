//
//  Entity+CoreDataProperties.h
//  DateLeaks
//
//  Created by Ben Stovold on 8/10/2015.
//  Copyright © 2015 Thoughtful Pixel. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "Entity.h"

NS_ASSUME_NONNULL_BEGIN

@interface Entity (CoreDataProperties)

@property (nullable, nonatomic, retain) NSDate *date;
@property (nullable, nonatomic, retain) NSString *string;

@end

NS_ASSUME_NONNULL_END
