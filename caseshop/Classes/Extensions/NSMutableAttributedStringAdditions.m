//
//  NSMutableAttributedStringAdditions.m
//  travelog
//
//  Created by Cho, Young-Un on 12. 2. 17..
//  Copyright (c) 2012 CultStory Inc. All rights reserved.
//

#import "NSMutableAttributedStringAdditions.h"


@implementation NSMutableAttributedString (Additions)

- (void)appendString:(NSString *)string fontName:(NSString *)fontName fontSize:(CGFloat)fontSize textColor:(UIColor *)textColor {
    CTFontRef font = CTFontCreateWithName((CFStringRef)fontName, fontSize, NULL);
    if (!font) {
        return;
    }
    CGColorRef color = textColor.CGColor;

    NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:
                                (id)font, (id)kCTFontAttributeName, 
                                color, (id)kCTForegroundColorAttributeName, 
                                NULL];
    NSAttributedString *attributedString = [[[NSAttributedString alloc] initWithString:string attributes:attributes] autorelease];
    [self appendAttributedString:attributedString];
    CFRelease(font);
}


- (CGSize)suggestSizeConstrainedToSize:(CGSize)size {
//    CTFramesetterRef framesetter = CTFramesetterCreateWithAttributedString((CFMutableAttributedStringRef)self); 
//    CGSize suggestSize = CTFramesetterSuggestFrameSizeWithConstraints(framesetter, CFRangeMake(0, 0), NULL, size, NULL);
//    return suggestSize;

    // CTFramesetterSuggestFrameSizeWithConstraints 높이가 제대로 안나오기 때문에 직접 계산해야 합니다.
    CTTypesetterRef typesetter = CTTypesetterCreateWithAttributedString((CFAttributedStringRef)self);
    CGFloat width = size.width;
    
    NSUInteger total = [self length];
    CFIndex offset = 0, length;
    CGFloat height = 0;
    do {
        length = CTTypesetterSuggestLineBreak(typesetter, offset, width);
        CTLineRef line = CTTypesetterCreateLine(typesetter, CFRangeMake(offset, length));
        
        CGFloat ascent, descent, leading;
        CTLineGetTypographicBounds(line, &ascent, &descent, &leading);
        
        CFRelease(line);
        
        offset += length;
        height += ascent + descent + leading;
    } while (offset < total);
    
    return CGSizeMake(width, height);
}


- (void)clear {
    [self setAttributedString:[[[NSAttributedString alloc] initWithString:@""] autorelease]];
}

@end
