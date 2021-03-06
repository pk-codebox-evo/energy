#import <Foundation/Foundation.h>


@interface NSString (StringSize)

/// This is to emulate the old deprecated API for getting a string size using the
/// new API.

- (CGSize)ar_sizeWithFont:(UIFont *)font;

- (CGSize)ar_sizeWithFont:(UIFont *)font constrainedToSize:(CGSize)size;

- (CGSize)ar_sizeWithFont:(UIFont *)font forWidth:(CGFloat)width;

- (CGSize)ar_sizeWithFont:(UIFont *)font constrainedToSize:(CGSize)size lineBreakMode:(NSLineBreakMode)lineBreak;

@end
