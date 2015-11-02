//
//  KFRStringtoDate.h
//  KFRStringToDate
//
//  Created by Kiara Robles on 10/31/15.
//  Copyright © 2015 Kiara Robles. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KFRStringToDate : NSObject

@property (nonatomic, strong) NSString *string;
@property (nonatomic, readonly) NSDate *date;
@property (readonly) NSInteger month;
@property (readonly) NSUInteger weekday;

- (instancetype)initWithString:(NSString *)string;
- (id) dateFromString:(NSString *)string;

@end

