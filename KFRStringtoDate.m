//
//  KFRStringtoDate.m
//  KFRStringToDate
//
//  Created by Kiara Robles on 10/31/15.
//  Copyright © 2015 Kiara Robles. All rights reserved.
//

#import "KFRStringToDate.h"

typedef NS_ENUM(NSInteger, enumDay) {
    sunday = 1,
    monday,
    tuesday,
    wednesday,
    thursday,
    friday,
    saturday,
};

@interface KFRStringToDate ( )

@property (nonatomic, readwrite) NSDate *date;

// Settled in init method
@property (nonatomic, readwrite, copy) NSCalendar *calendar;
@property (nonatomic, readwrite, copy) NSDateComponents *comps;
@property (nonatomic, readwrite, copy) NSDateComponents *comps2;
@property (readwrite) NSUInteger weekday;
@property (readwrite) NSInteger month;
@property (nonatomic) NSSet *datesGeneral;
@property (nonatomic) NSSet *datesSpecificWeek;
@property (nonatomic) NSSet *datesSpecificMonth;

@property (nonatomic, strong) NSMutableArray *wordsArray;
@property (nonatomic, readwrite, copy) NSDateComponents *deltaComps;
@property (nonatomic) enumDay nextDay;

@property (nonatomic) NSString *wordIndex1;
@property (nonatomic) NSString *wordIndex2;

@property (nonatomic) bool isDatesGeneral;
@property (nonatomic) bool isDatesSpecificWeek;
@property (nonatomic) bool isDatesSpecificMonth;
@property (nonatomic) bool isBoolBust;
//@property (nonatomic) NSUInteger boolTotal;
@property bool isToday;
@property bool isTomorrow;
@property bool isYesterday;

@end

@implementation KFRStringToDate


- (instancetype)init {
    self = [super init];
    if (self) {
        _calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
        _comps = [self.calendar components:NSCalendarUnitWeekday fromDate:[NSDate date]];
        _comps2 = [self.calendar components:NSCalendarUnitMonth fromDate:[NSDate date]];
        _weekday = [self.comps weekday];
        _month = [self.comps2 month];
        [self setupSetsForComparison];
    }
    return self;
}
-(void) setupSetsForComparison {
    _datesGeneral = [NSSet setWithObjects: @"today", @"tomorrow", @"yesterday", nil];
    _datesSpecificWeek = [NSSet setWithObjects: @"monday", @"tuesday", @"wednesday", @"thursday", @"friday", @"saturday", @"sunday", @"week", nil];
}
- (instancetype)initWithString:(NSString *)string {
    self = [super init];
    if (self) {
        _string = string;
        _calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
        _comps = [self.calendar components:NSCalendarUnitWeekday fromDate:[NSDate date]];
        _weekday = [self.comps weekday];
    }
    return self;
}
- (NSArray *) stringToWordArray:(NSString *)string {
    
    NSCharacterSet *charactersToRemove = [[NSCharacterSet alphanumericCharacterSet] invertedSet];
    NSString *strippedReplacement = [[self.string componentsSeparatedByCharactersInSet:charactersToRemove] componentsJoinedByString:@" "];
    strippedReplacement = [strippedReplacement lowercaseString];
    NSArray *wordsArray = [strippedReplacement componentsSeparatedByString:@" "];
    self.wordsArray = [wordsArray mutableCopy];
    
    return self.wordsArray;
}
- (enumDay) createDayFromDateValue:(NSString *)dateValue {
    enumDay nextDay;
    
    if ([dateValue isEqualToString:@"monday"]) {
        nextDay = monday;
    } else if ([dateValue isEqualToString:@"tuesday"]) {
        nextDay = tuesday;
    } else if ([dateValue isEqualToString:@"wednesday"]) {
        nextDay = wednesday;
    } else if ([dateValue isEqualToString:@"thursday"]) {
        nextDay = thursday;
    } else if ([dateValue isEqualToString:@"friday"]) {
        nextDay = friday;
    } else if ([dateValue isEqualToString:@"saturday"]) {
        nextDay = saturday;
    } else if ([dateValue isEqualToString:@"sunday"]) {
        nextDay = sunday;
    }
    return nextDay;
}

// Helper methods
- (enumDay) assignEnumday:(NSString *)word2 {
    NSString *dateValue = [self.datesSpecificWeek member:word2];
    enumDay day = [self createDayFromDateValue:dateValue];
    
    return day;
}

//**//**||============================================================||**\\**\\
//                       TRANSLATE DATE FROM STRING
//**//**||============================================================||**\\**\\

- (id) dateFromString:(NSString *)string {
    [self stringToWordArray:self.string];
    
    // Match the words in the input array to the values in NSSet
    NSInteger boolTotal = -1;
    for (NSUInteger i = 0; i < self.wordsArray.count - 1; i++) {
        NSString *wordIndex1 = [self.wordsArray objectAtIndex:i];
        NSString *wordIndex2 = [self.wordsArray objectAtIndex:i+1];
        
        self.isDatesGeneral = [self.datesGeneral containsObject:wordIndex2];
        self.isDatesSpecificWeek = [self.datesSpecificWeek containsObject:wordIndex2];
        
        int intDatesGeneral = (self.isDatesGeneral ? 1 : 0);
        int intDatesSpecificWeek = (self.isDatesSpecificWeek ? 1 : 0);
        
        if (boolTotal ==  -1) {
            boolTotal = 0;
        }
        else {
            boolTotal = intDatesGeneral + intDatesSpecificWeek;
        }
        if (boolTotal == 1) {
            self.wordIndex1 = wordIndex1;
            self.wordIndex2 = wordIndex2;
        }
    }
    if (boolTotal == 1) {
        return [self returnDate];
    }
    else {
        return @"Not a valid entry.";
    }
    
    return nil;
}
- (NSDate *) returnDate {
//**//**||============================================================||**\\**\\
//                              General Day
//**//**||============================================================||**\\**\\
    
    if (self.isToday || self.isYesterday || self.isTomorrow) {
        
        NSInteger delta = 0;
        if (self.isYesterday) {
            delta = -1;
        }
        else if (self.isTomorrow) {
            delta = 1;
        }
        
        NSDateComponents* deltaComps = [[NSDateComponents alloc] init];
        [deltaComps setDay:delta];
        self.date = [self.calendar dateByAddingComponents:deltaComps toDate:[NSDate date] options:0];
    }
    
    //**//**||============================================================||**\\**\\
    //                               DAY OF WEEK
    //**//**||============================================================||**\\**\\
    
    else if ([self.wordIndex1 isEqualToString:@"next"] && self.isDatesSpecificWeek == YES) {
        
        // Define the matching word and assign it to a NSUInteger enum
        enumDay day = [self assignEnumday:self.wordIndex2];
        
        // Calulate the value of the next week day based on the current day
        NSUInteger delta = [self nextWeekDeltaFromCurrentDay:day];
        
        // Add delta to the current day
        NSDateComponents* deltaComps = [[NSDateComponents alloc] init];
        [deltaComps setDay:delta];
        self.date = [self.calendar dateByAddingComponents:deltaComps toDate:[NSDate date] options:0];
    }
    else if ([self.wordIndex1 isEqualToString:@"last"] && self.isDatesSpecificWeek == YES) {
        
        enumDay day = [self assignEnumday:self.wordIndex2];
        NSInteger today = 1;
        NSInteger delta = [self lastWeekDeltaFromCurrentDay:day] + today;
        delta = -delta;
        
        NSDateComponents* deltaComps = [[NSDateComponents alloc] init];
        [deltaComps setDay:delta];
        self.date = [self.calendar dateByAddingComponents:deltaComps toDate:[NSDate date] options:0];
    }
    else if ([self.wordIndex1 isEqualToString:@"this"] && self.isDatesSpecificWeek == YES) {
        
        enumDay day = [self assignEnumday:self.wordIndex2];
        NSInteger delta = [self thisWeekDeltaFromCurrentDay:day];
        NSDateComponents* deltaComps = [[NSDateComponents alloc] init];
        [deltaComps setDay:delta];
        self.date = [self.calendar dateByAddingComponents:deltaComps toDate:[NSDate date] options:0];
    }
    
    return self.date;
}

//**//**||============================================================||**\\**\\
//                             CORE ALGORITHMS
//**//**||============================================================||**\\**\\

- (NSUInteger) nextWeekDeltaFromCurrentDay:(enumDay)day {
    NSInteger delta = 0;
    NSUInteger week = 7;
    
    delta = (week + day - self.weekday) % week;
    
    if (delta == 0) {
        delta = 7;
    }
    
    return delta;
}
- (NSUInteger) lastWeekDeltaFromCurrentDay:(enumDay)day {
    NSInteger delta = 0;
    NSUInteger week = 7;
    
    delta = (week + self.weekday - day) % week;
    
    if (delta == 0) {
        delta = 7;
    }
    
    return delta;
}

- (NSUInteger) thisWeekDeltaFromCurrentDay:(enumDay)day {
    NSInteger delta = 0;
    
    if (day == self.weekday) {
        delta = 0;
    }
    else if (day < self.weekday) {
        delta = self.weekday - day;
        delta = -delta;
    }
    else if (day > self.weekday) {
        delta = day - self.weekday;
    }
    
    return delta;
}

@end