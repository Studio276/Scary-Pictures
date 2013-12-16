//
//  CoreImageFunctions.h
//  ImageProcessingTest2
//


#import <Foundation/Foundation.h>

@interface CoreImageFunctions : UIImage
- (UIImage *) scaleToSize: (CGSize)size;
- (UIImage*)imageWithImage:(UIImage*)sourceImage scaledToSize:(CGSize)targetSize;
- (UIImage *) scaleProportionalToSize: (CGSize)size;
- (UIImage *)scaleAndRotateImage:(UIImage *)image;
- (UIImage*)imageByScalingToSize:(CGSize)targetSize;



@end
