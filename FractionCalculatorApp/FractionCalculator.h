//
//  FractionCalculator.h
//  FractionCalculator
//
//  Created by jfang19 on 9/21/18.
//  Copyright © 2018 joshuafang. All rights reserved.
//

#ifndef FractionCalculator_h
#define FractionCalculator_h
#import "Fraction.h"

enum Operation {Add = 43, Subtract = 45, Multiply = 42, Divide = 47};

@interface FractionCalculator: NSObject

@property Fraction *fraction1;
@property Fraction *fraction2;
@property BOOL isOn;
@property enum Operation operation;
@property BOOL displayFirstFraction;
@property BOOL focusedNumerator;
@property NSMutableArray *history;

-(Fraction *) addFraction: (Fraction *) fraction1 toFraction: (Fraction *) fraction2;
-(Fraction *) subtractFraction: (Fraction *) fraction1 fromFraction: (Fraction *) fraction2;
-(Fraction *) multiplyFraction: (Fraction *) fraction1 byFraction: (Fraction *) fraction2;
-(Fraction *) divideFraction: (Fraction *) fraction1 byFraction: (Fraction *) fraction2;

-(void) reset;
-(void) performOperation;
-(void) changeSign;
-(void) reciprocate;
-(void) backspace;
-(NSString *) display;
-(NSString *) historyDisplay;
-(void) inputNumber: (int) number;

@end


#endif /* FractionCalculator_h */
