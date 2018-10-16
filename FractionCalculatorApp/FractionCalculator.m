//
//  FractionCalculator.m
//  FractionCalculator
//
//  Created by jfang19 on 9/21/18.
//  Copyright © 2018 joshuafang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FractionCalculator.h"
#import "Fraction.h"

@implementation FractionCalculator

-(id) init {
  self.isOn = FALSE;
  self.displayFirstFraction = TRUE;
  self.focusedNumerator = TRUE;
  self.fraction1 = [[Fraction alloc] initWithNumerator:0 andDenominator:0];
  self.fraction2 = [[Fraction alloc] initWithNumerator:0 andDenominator:0];
  self.history = [[NSMutableArray alloc] init];
  return self;
}

-(Fraction *) addFraction: (Fraction *) fraction1 toFraction: (Fraction *) fraction2 {
  Fraction *newFraction = [[Fraction alloc] init];
  newFraction.numerator = fraction1.numerator * fraction2.denominator + fraction1.denominator * fraction2.numerator;
  newFraction.denominator = fraction1.denominator * fraction2.denominator;
  [newFraction simplify];
  return newFraction;
}

-(Fraction *) subtractFraction: (Fraction *) fraction1 fromFraction: (Fraction *) fraction2 {
  return [self addFraction:fraction1 toFraction:[fraction2 opposite]];
}

-(Fraction *) multiplyFraction: (Fraction *) fraction1 byFraction: (Fraction *) fraction2 {
  Fraction *newFraction = [[Fraction alloc] init];
  newFraction.numerator = fraction1.numerator * fraction2.numerator;
  newFraction.denominator = fraction1.denominator * fraction2.denominator;
  [newFraction simplify];
  return newFraction;
}

-(Fraction *) divideFraction: (Fraction *) fraction1 byFraction: (Fraction *) fraction2 {
  return [self multiplyFraction:fraction1 byFraction:[fraction2 reciprocal]];
}

-(NSString *) display {
  if (!self.isOn) return @"";
  else if (!self.fraction1.numerator && !self.fraction2.numerator) return @"0";
  if (self.displayFirstFraction) {
    return self.fraction1.display;
  } else {
    if (self.fraction2.numerator || self.fraction2.denominator) {
      return self.fraction2.display;
    } else {
      return self.fraction1.display;
    }
  }
  return @"ERROR";
}

-(NSString *) historyDisplay {
  if (!self.isOn) return @"";
  else if (!self.fraction1.numerator && !self.fraction2.numerator) return @"0";
  return [NSString stringWithFormat:@"%@ %@ %@", [self.fraction1 display],  [self stringFromOperation:[self operation]], [self.fraction2 display]];
}

-(void) inputNumber: (int) number {
  if (self.focusedNumerator) {
    if (self.displayFirstFraction) {
      self.fraction1.numerator *= 10;
      self.fraction1.numerator += number;
    } else {
      self.fraction2.numerator *= 10;
      self.fraction2.numerator += number;
    }
  } else {
    if (self.displayFirstFraction) {
      self.fraction1.denominator *= 10;
      self.fraction1.denominator += number;
    } else {
      self.fraction2.denominator *= 10;
      self.fraction2.denominator += number;
    }
  }
}

-(void) reset {
  [self.fraction1 clear];
  [self.fraction2 clear];
  self.displayFirstFraction = TRUE;
  self.focusedNumerator = TRUE;
}

-(void) performOperation {
  if (!self.fraction1.isValid || !self.fraction2.isValid) return;
  NSString *operationString = [self historyDisplay];
  switch (self.operation) {
    case Add:
      self.fraction1 = [self addFraction:self.fraction1 toFraction:self.fraction2];
      break;
    case Subtract:
      self.fraction1 = [self subtractFraction:self.fraction1 fromFraction:self.fraction2];
      break;
    case Multiply:
      self.fraction1 = [self multiplyFraction:self.fraction1 byFraction:self.fraction2];
      break;
    case Divide:
      self.fraction1 = [self divideFraction:self.fraction1 byFraction:self.fraction2];
      break;
  }
  self.displayFirstFraction = TRUE;
  self.operation = 0;
  [self.fraction2 clear];
  [self.history insertObject:[NSString stringWithFormat:@"%@ = %@", operationString, [self.fraction1 display]] atIndex:0];
}

-(void) changeSign {
  if (self.displayFirstFraction) {
    self.fraction1.numerator *= -1;
  } else {
    self.fraction2.numerator *= -1;
  }
}

-(void) reciprocate {
  if (self.displayFirstFraction) {
    if (!self.fraction1.denominator) {
      self.fraction1.denominator = 1;
    }
    [self.fraction1 reciprocate];
  } else {
    if (!self.fraction2.denominator) {
      self.fraction2.denominator = 1;
    }
    [self.fraction2 reciprocate];
  }
  self.focusedNumerator = !self.focusedNumerator;
}

-(void) backspace {
  if (self.focusedNumerator) {
    if (self.displayFirstFraction) {
      self.fraction1.numerator /= 10;
    } else {
      self.fraction2.numerator /= 10;
    }
  } else {
    if (self.displayFirstFraction) {
      self.fraction1.denominator /= 10;
    } else {
      self.fraction2.denominator /= 10;
    }
  }
}

-(NSString *) stringFromOperation: (enum Operation) o {
  switch (o) {
    case Add: return @"+";
    case Subtract: return @"–";
    case Multiply: return @"×";
    case Divide: return @"÷";
    default: return @"";
  }
}

@end
