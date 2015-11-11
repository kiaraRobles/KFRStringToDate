//
//  KFRFuzzyDateTranslator.m
//  KFRFuzzyDateTranslator
//
//  Created by Kiara Robles on 10/31/15.
//  Copyright © 2015 Kiara Robles. All rights reserved.
//

#import "KFRFuzzyDateTranslator.h"

typedef NS_ENUM(NSInteger, enumDay) {
    sunday = 1,
    monday,
    tuesday,
    wednesday,
    thursday,
    friday,
    saturday,
};

@interface KFRFuzzyDateTranslator ( )

@property (nonatomic, readwrite) NSDate *date;

@property (nonatomic, readwrite, copy) NSCalendar *calendar;
@property (nonatomic, readwrite, copy) NSDateComponents *comps;
@property (readwrite) NSUInteger weekday;
@property (nonatomic) NSSet *datesGeneral;
@property (nonatomic) NSSet *datesSpecificWeek;

@property (nonatomic, strong) NSMutableArray *wordsArray;
@property (nonatomic, readwrite, copy) NSDateComponents *deltaComps;
@property (nonatomic) enumDay nextDay;

@property (nonatomic) NSString *wordIndex1;
@property (nonatomic) NSString *wordIndex2;

@property (nonatomic) bool isDatesGeneral;
@property (nonatomic) bool isDatesSpecificWeek;
@property (nonatomic) bool isBoolBust;
@property bool isToday;
@property bool isTomorrow;
@property bool isYesterday;


@end

@implementation KFRFuzzyDateTranslator

- (instancetype)init {
    self = [super init];
    if (self) {
        _calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
        _comps = [self.calendar components:NSCalendarUnitWeekday fromDate:[NSDate date]];
        _weekday = [self.comps weekday];
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
- (instancetype)initWithRelevantDate:(NSString *)dateString {
    self = [super init];
    if (self) {
        _calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
        _dateString = dateString;
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        dateFormatter.dateFormat = @"dd-MMM-yy";
        NSDate *relevantDate = [dateFormatter dateFromString:dateString];
        _comps = [self.calendar components:NSCalendarUnitWeekday fromDate:relevantDate];
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
    for (NSUInteger i = 0; i < self.wordsArray.count -1; i++) {
        NSString *wordIndex1 = [self.wordsArray objectAtIndex:i];
        NSString *wordIndex2 = [self.wordsArray objectAtIndex:i+1];
        
        self.isDatesGeneral = [self.datesGeneral containsObject:wordIndex2];
        self.isDatesSpecificWeek = [self.datesSpecificWeek containsObject:wordIndex2];
        
        int intDatesGeneral = (self.isDatesGeneral ? 1 : 0);
        int intDatesSpecificWeek = (self.isDatesSpecificWeek ? 1 : 0);
        
        if (self.isDatesGeneral == YES) {
            self.isToday = [wordIndex2 isEqualToString:@"today"];
            self.isYesterday = [wordIndex2 isEqualToString:@"yesterday"];
            self.isTomorrow = [wordIndex2 isEqualToString:@"tomorrow"];
        }
        
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
    
    if (self.isToday || self.isTomorrow || self.isYesterday) {
        
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
        
        // Define next week as == "next monday"
        if ([self.wordIndex2 isEqualToString:@"week"]) {
            day = 2;
        }
        
        // Calulate the value of the next week day based on the current day
        NSInteger delta = [self nextWeekDeltaFromCurrentDay:day];
        
        // Add delta to the current day
        NSDateComponents* deltaComps = [[NSDateComponents alloc] init];
        [deltaComps setDay:delta];
        self.date = [self.calendar dateByAddingComponents:deltaComps toDate:[NSDate date] options:0];
    }
    else if ([self.wordIndex1 isEqualToString:@"last"] && self.isDatesSpecificWeek == YES) {
        
        enumDay day = [self assignEnumday:self.wordIndex2];
        
        // Define next week as == "last sunday"
        if ([self.wordIndex2 isEqualToString:@"week"]) {
            day = 1;
        }
        
        NSInteger delta = [self lastWeekDeltaFromCurrentDay:day];
        delta = -delta;
        
        NSDateComponents* deltaComps = [[NSDateComponents alloc] init];
        [deltaComps setDay:delta];
        self.date = [self.calendar dateByAddingComponents:deltaComps toDate:[NSDate date] options:0];
    }
    else if ([self.wordIndex1 isEqualToString:@"this"] && self.isDatesSpecificWeek == YES) {
        
        NSInteger delta = 0;
        enumDay day = [self assignEnumday:self.wordIndex2];
        NSDateComponents* deltaComps = [[NSDateComponents alloc] init];
        
        // Define this week as == "Tomorrow"
        if ([self.wordIndex2 isEqualToString:@"week"]) {
            delta = 1;
            [deltaComps setDay:delta];
        }
        else {
            delta = [self thisWeekDeltaFromCurrentDay:day];
            [deltaComps setDay:delta];
        }
        
        self.date = [self.calendar dateByAddingComponents:deltaComps toDate:[NSDate date] options:0];
    }
    
    return self.date;
}

//**//**||============================================================||**\\**\\
//                             CORE METHODS
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