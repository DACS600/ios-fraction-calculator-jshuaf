//
//  Fraction.m
//  FractionCalculator
//
//  Created by jfang19 on 9/21/18.
//  Copyright © 2018 joshuafang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Fraction.h"

@implementation Fraction

-(id) initWithNumerator: (int) numerator andDenominator: (int) denominator {
  self.numerator = numerator;
  self.denominator = denominator;
  return self;
}

-(Fraction *) opposite {
  self.numerator = -self.numerator;
  [self simplify];
  return self;
}

-(Fraction *) reciprocal {
  int temp = self.numerator;
  self.numerator = self.denominator;
  self.denominator = temp;
  return self;
}

-(void) print {
  NSLog(@"%d/%d", self.numerator, self.denominator);
}

-(void) simplify {
  if (self.numerator == 0 || self.denominator == 0) return;
  if (self.denominator < 0) {
    self.numerator *= -1;
    self.denominator *= -1;
  }
  // Simple GCD algorithm
  int workingNum1 = self.numerator;
  int workingNum2 = self.denominator;
  int temp;
  while (workingNum2 != 0) {
    temp = workingNum1 % workingNum2;
    workingNum1 = workingNum2;
    workingNum2 = temp;
  }
  self.numerator /= workingNum1;
  self.denominator /= workingNum1;
}

-(double) value {
  return (double) self.numerator / (double) self.denominator;
}

-(NSString *) display {
  if (!self.numerator && !self.denominator) {
    return @"";
  } else if (self.numerator && !self.denominator) {
    return [NSString stringWithFormat:@"%d", self.numerator];
  } else {
    NSArray *superscripts = @[@"\u2070", @"\u00B9", @"\u00B2", @"\u00B3", @"\u2074", @"\u2075", @"\u2076", @"\u2077", @"\u2078", @"\u2079"];
    NSArray *subscripts = @[@"\u2080", @"\u2081", @"\u2082",@"\u2083",  @"\u2084", @"\u2085", @"\u2086", @"\u2087", @"\u2088", @"\u2089"];
    NSMutableString *result = [NSMutableString string];

    NSString *numeratorString = [NSString stringWithFormat:@"%i", self.numerator];
    NSString *denominatorString = [NSString stringWithFormat:@"%i", self.denominator];
    for (int i = 0; i < numeratorString.length; i++) {
      NSString *currentDigitString = [numeratorString substringWithRange:NSMakeRange(i, 1)];
      if ([currentDigitString isEqual:@"-"]) {
        [result appendString: currentDigitString];
        continue;
      }
      int currentDigit = currentDigitString.intValue;
      [result appendString: [superscripts objectAtIndex:currentDigit]];
    }
    [result appendString:@"/"];
    for (int i = 0; i < denominatorString.length; i++) {
      NSString *currentDigitString = [denominatorString substringWithRange:NSMakeRange(i, 1)];
      if ([currentDigitString isEqual:@"-"]) {
        [result appendString: currentDigitString];
        continue;
      }
      int currentDigit = currentDigitString.intValue;
      [result appendString: [subscripts objectAtIndex:currentDigit]];
    }
    return result;
  }
}

-(void) clear {
  self.numerator = 0;
  self.denominator = 0;
}

-(void) reciprocate {
  Fraction *reciprocal = [self reciprocal];
  self.numerator = reciprocal.numerator;
  self.denominator = reciprocal.denominator;
}

-(BOOL) isValid {
  return ((self.numerator == 0 || self.numerator) && self.denominator);
}

@end

