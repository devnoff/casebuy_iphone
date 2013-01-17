//
//  NSMutableAttributedStringAdditions.h
//  travelog
//
//  Created by Cho, Young-Un on 12. 2. 17..
//  Copyright (c) 2012 CultStory Inc. All rights reserved.
//

#import <CoreText/CoreText.h>


@interface NSMutableAttributedString (Additions)

- (void)appendString:(NSString *)string fontName:(NSString *)fontName fontSize:(CGFloat)fontSize textColor:(UIColor *)textColor;

- (CGSize)suggestSizeConstrainedToSize:(CGSize)size;

- (void)clear;

@end
