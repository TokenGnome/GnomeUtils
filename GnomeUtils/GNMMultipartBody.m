//
//  GNMMultipartBody.m
//  GrowApp
//
//  Created by Brandon Smith on 6/23/13.
//  Copyright (c) 2013 Brandon Smith. All rights reserved.
//

#import "GNMMultipartBody.h"

@implementation GNMMultipartBody

static NSString * const kBoundary = @"Boundary+0xAeIoU";

static NSString * const kCRLF = @"\r\n";

static inline NSString * InitialBoundary()
{
    return [NSString stringWithFormat:@"--%@%@", kBoundary, kCRLF];
}

static inline NSString * EncapsulationBoundary()
{
    return [NSString stringWithFormat:@"%@--%@%@", kCRLF, kBoundary, kCRLF];
}

static inline NSString * FinalBoundary()
{
    return [NSString stringWithFormat:@"%@--%@--%@", kCRLF, kBoundary, kCRLF];
}

static inline NSString * FileKey(NSString *name, NSString *fileName)
{
    return [NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"; filename=\"%@\"%@", name, fileName, kCRLF];
}

static inline NSString * FileContentType(NSString *mimeType)
{
    return [NSString stringWithFormat:@"Content-Type: %@%@%@", mimeType, kCRLF, kCRLF];
}

static inline NSString * PartKey(NSString *key)
{
    return [NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"%@%@", key, kCRLF, kCRLF];
}

static inline NSString *PartValue(NSString *value)
{
    return [NSString stringWithFormat:@"%@%@", value, kCRLF];
}

static inline NSString * MIMETypeForPathExtension(NSString *extension)
{
    NSString *contentType = [NSString stringWithFormat:@"image/%@", extension];
    
    // If the Mobile.CoreServices frame work is available
#ifdef __UTTYPE__
    CFStringRef ext = (__bridge CFStringRef)extension;
    CFStringRef UTI = UTTypeCreatePreferredIdentifierForTag(kUTTagClassFilenameExtension, ext, NULL);
    contentType = (__bridge_transfer NSString *)UTTypeCopyPreferredTagWithClass(UTI, kUTTagClassMIMEType);
#else
#endif
    return contentType;
}

+ (NSString *)boundary
{
    return kBoundary;
}

+ (instancetype)bodyWithFileURL:(NSURL *)fileURL
{
    return [self bodyWithFileURL:fileURL parts:nil];
}

+ (instancetype)bodyWithFileURL:(NSURL *)fileURL parts:(NSDictionary *)parts
{
    GNMMultipartBody *body = [GNMMultipartBody new];
    body.fileName = [fileURL lastPathComponent];
    body.MIMEType = MIMETypeForPathExtension([fileURL pathExtension]);
    body.fileURL = fileURL;
    body.parts = parts;
    body.stringEncoding = NSUTF8StringEncoding;
    
    return body;
}

- (NSData *)dataForHTTPPOST
{
    NSMutableData *bodyData = [NSMutableData data];
    
    for (NSString *key in self.parts.allKeys) {
        [bodyData appendData:[InitialBoundary() dataUsingEncoding:self.stringEncoding]];
        [bodyData appendData:[PartKey(key) dataUsingEncoding:self.stringEncoding]];
        [bodyData appendData:[PartValue(self.parts[key]) dataUsingEncoding:self.stringEncoding]];
    }
    
    [bodyData appendData:[InitialBoundary() dataUsingEncoding:self.stringEncoding]];
    [bodyData appendData:[FileKey(@"image", self.fileName) dataUsingEncoding:self.stringEncoding]];
    [bodyData appendData:[FileContentType(self.MIMEType) dataUsingEncoding:self.stringEncoding]];
    [bodyData appendData:[NSData dataWithContentsOfURL:self.fileURL]];
    [bodyData appendData:[EncapsulationBoundary() dataUsingEncoding:NSUTF8StringEncoding]];
    
    return bodyData;
}

@end
