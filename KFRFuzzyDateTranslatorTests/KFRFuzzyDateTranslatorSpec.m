//
//  KFRFuzzyDateTranslatorSpec.m
//  KFRFuzzyDateTranslator
//
//  Created by Kiara Robles on 11/10/15.
//  Copyright 2015 Kiara Robles. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Specta/Specta.h>
#define EXP_SHORTHAND
#import <Expecta.h>
#import "KFRFuzzyDateTranslator.h"


SpecBegin(KFRFuzzyDateTranslator)

describe(@"KFRFuzzyDateTranslator", ^{
    
    __block KFRFuzzyDateTranslator *instance;
    __block NSString *string;
    __block NSDateFormatter *dateFormatter;
    __block NSDate *expetedDate;
    __block NSString *expetedDateString;

    beforeEach(^{
        
        instance = [[KFRFuzzyDateTranslator alloc] initWithRelevantDate:@"29-FEB-16"];
        dateFormatter = [[NSDateFormatter alloc] init];
        dateFormatter.dateFormat = @"dd-MMM-yy";
        
    });
    
    describe(@"default initializer", ^{
        it(@"defalut calendar should be set to nil", ^{
            
            expect(instance.calendar).toNot.beNil();
        });
     });
    
    describe(@"testing -datesGeneral- properties translator for the February 29th, 2016 leap year", ^{
        it(@"should return torromorow", ^{
            string = @"I will do the thing torromorow!";
            //[instance dateFromString:string];
            expetedDateString = @"01-MAR-16";
            expetedDate = [dateFormatter dateFromString:expetedDateString];
            
            expect(instance.date).to.match(expetedDateString)
            ;
        });
        
//        it(@"should return yesterday", ^{
//            instance.string = @"I did the thing yesterday...";
//            [instance dateFromString:instance.string];
//            expetedDateString = @"28-FEB-16";
//            expetedDate = [dateFormatter dateFromString:expetedDateString];
//            
//            expect(instance.date).to.match(expetedDateString);
//        });
//        
//        it(@"should return today", ^{
//            instance.string = @"I'm doing that today?";
//            [instance dateFromString:instance.string];
//            expetedDateString = @"29-FEB-16";
//            expetedDate = [dateFormatter dateFromString:expetedDateString];
//            
//            expect(instance.date).to.match(expetedDateString);
//        });
//    });
//        
//    describe(@"testing -next datesSpecificWeek- properties translator for the February 29th, 2016 leap year", ^{
//        it(@"should return next week", ^{
//            instance.string = @"I should do the thing next week.";
//            [instance dateFromString:instance.string];
//            expetedDateString = @"7-MAR-16";
//            expetedDate = [dateFormatter dateFromString:expetedDateString];
//            
//            expect(instance.date).to.match(expetedDateString);
//        });
//        
//        it(@"should return next Monday", ^{
//            instance.string = @"I should do the thing next Monday.";
//            [instance dateFromString:instance.string];
//            expetedDateString = @"7-MAR-16";
//            expetedDate = [dateFormatter dateFromString:expetedDateString];
//            
//            expect(instance.date).to.match(expetedDateString);
//        });
//        
//        it(@"should return next Tuesday", ^{
//            instance.string = @"I should do the thing next Tuesday.";
//            [instance dateFromString:instance.string];
//            expetedDateString = @"01-MAR-16";
//            expetedDate = [dateFormatter dateFromString:expetedDateString];
//            
//            expect(instance.date).to.match(expetedDateString);
//        });
//
//        it(@"should return next Wednesday", ^{
//            instance.string = @"I should do the thing next Wednesday";
//            [instance dateFromString:instance.string];
//            expetedDateString = @"02-MAR-16";
//            expetedDate = [dateFormatter dateFromString:expetedDateString];
//            
//            expect(instance.date).to.match(expetedDateString);
//        });
//
//        it(@"should return next Thursday", ^{
//            instance.string = @"I should do the thing next Thursday.";
//            [instance dateFromString:instance.string];
//            expetedDateString = @"03-MAR-16";
//            expetedDate = [dateFormatter dateFromString:expetedDateString];
//            
//            expect(instance.date).to.match(expetedDateString);
//        });
//
//        it(@"should return next Friday", ^{
//            instance.string = @"I should do the thing next Friday.";
//            [instance dateFromString:instance.string];
//            expetedDateString = @"04-MAR-16";
//            expetedDate = [dateFormatter dateFromString:expetedDateString];
//            
//            expect(instance.date).to.match(expetedDateString);
//        });
//        
//        it(@"should return next Saturday", ^{
//            instance.string = @"I should do the thing next Saturday.";
//            [instance dateFromString:instance.string];
//            expetedDateString = @"05-MAR-16";
//            expetedDate = [dateFormatter dateFromString:expetedDateString];
//            
//            expect(instance.date).to.match(expetedDateString);
//        });
//        
//        it(@"should return next Sunday", ^{
//            instance.string = @"I should do the thing next Sunday.";
//            [instance dateFromString:instance.string];
//            expetedDateString = @"06-MAR-16";
//            expetedDate = [dateFormatter dateFromString:expetedDateString];
//            
//            expect(instance.date).to.match(expetedDateString);
//        });
//    });
//    
//    describe(@"testing -last datesSpecificWeek- properties translator for the February 29th, 2016 leap year", ^{
//        it(@"should return last week", ^{
//            instance.string = @"I should do the thing last week.";
//            expetedDateString = @"28-FEB-16";
//            expetedDate = [dateFormatter dateFromString:expetedDateString];
//            
//            expect(instance.date).to.match(expetedDateString);
//        });
//        
//        it(@"should return last Monday", ^{
//            instance.string = @"I did the thing last Monday.";
//            expetedDateString = @"22-FEB-16";
//            expetedDate = [dateFormatter dateFromString:expetedDateString];
//            
//            expect(instance.date).to.match(expetedDateString);
//        });
//        
//        it(@"should return last Tuesday", ^{
//            instance.string = @"I did the thing last Tuesday.";
//            expetedDateString = @"23-FEB-16";
//            expetedDate = [dateFormatter dateFromString:expetedDateString];
//            
//            expect(instance.date).to.match(expetedDateString);
//        });
//        
//        it(@"should return last Wednesday", ^{
//            instance.string = @"I did the thing last Wednesday";
//            expetedDateString = @"24-FEB-16";
//            expetedDate = [dateFormatter dateFromString:expetedDateString];
//            
//            expect(instance.date).to.match(expetedDateString);
//        });
//        
//        it(@"should return last Thursday", ^{
//            instance.string = @"I did the thing last Thursday.";
//            expetedDateString = @"25-FEB-16";
//            expetedDate = [dateFormatter dateFromString:expetedDateString];
//            
//            expect(instance.date).to.match(expetedDateString);
//        });
//        
//        it(@"should return last Friday", ^{
//            instance.string = @"I did the thing last Friday.";
//            expetedDateString = @"26-FEB-16";
//            expetedDate = [dateFormatter dateFromString:expetedDateString];
//            
//            expect(instance.date).to.match(expetedDateString);
//        });
//        
//        it(@"should return last Saturday", ^{
//            instance.string = @"I did the thing last Saturday.";
//            expetedDateString = @"27-FEB-16";
//            expetedDate = [dateFormatter dateFromString:expetedDateString];
//            
//            expect(instance.date).to.match(expetedDateString);
//        });
//        
//        it(@"should return last Sunday", ^{
//            instance.string = @"I did the thing last Sunday.";
//            expetedDateString = @"28-FEB-16";
//            expetedDate = [dateFormatter dateFromString:expetedDateString];
//            
//            expect(instance.date).to.match(expetedDateString);
//        });
//    });
//    
//    describe(@"testing -this datesSpecificWeek- properties translator for the February 29th, 2016 leap year", ^{
//        it(@"should return this week", ^{
//            instance.string = @"I should do the thing this week.";
//            expetedDateString = @"29-FEB-16";
//            expetedDate = [dateFormatter dateFromString:expetedDateString];
//            
//            expect(instance.date).to.match(expetedDateString);
//        });
//        
//        it(@"should return this Monday", ^{
//            instance.string = @"I did the thing this Monday.";
//            expetedDateString = @"29-FEB-16";
//            expetedDate = [dateFormatter dateFromString:expetedDateString];
//            
//            expect(instance.date).to.match(expetedDateString);
//        });
//        
//        it(@"should return this Tuesday", ^{
//            instance.string = @"I will do the thing this Tuesday.";
//            expetedDateString = @"01-MAR-16";
//            expetedDate = [dateFormatter dateFromString:expetedDateString];
//            
//            expect(instance.date).to.match(expetedDateString);
//        });
//        
//        it(@"should return this Wednesday", ^{
//            instance.string = @"I will do the thing this Wednesday";
//            expetedDateString = @"02-MAR-16";
//            expetedDate = [dateFormatter dateFromString:expetedDateString];
//            
//            expect(instance.date).to.match(expetedDateString);
//        });
//        
//        it(@"should return this Thursday", ^{
//            instance.string = @"I will do the thing this Thursday.";
//            expetedDateString = @"03-MAR-16";
//            expetedDate = [dateFormatter dateFromString:expetedDateString];
//            
//            expect(instance.date).to.match(expetedDateString);
//        });
//        
//        it(@"should return this Friday", ^{
//            instance.string = @"I will do the thing this Friday.";
//            expetedDateString = @"04-MAR-16";
//            expetedDate = [dateFormatter dateFromString:expetedDateString];
//            
//            expect(instance.date).to.match(expetedDateString);
//        });
//        
//        it(@"should return this Saturday", ^{
//            instance.string = @"I will do the thing this Saturday.";
//            expetedDateString = @"05-MAR-16";
//            expetedDate = [dateFormatter dateFromString:expetedDateString];
//            
//            expect(instance.date).to.match(expetedDateString);
//        });
//        
//        it(@"should return this Sunday", ^{
//            instance.string = @"I will do the thing this Sunday.";
//            expetedDateString = @"28-FEB-16";
//            expetedDate = [dateFormatter dateFromString:expetedDateString];
//            
//            expect(instance.date).to.match(expetedDateString);
//        });
    });
});

SpecEnd

