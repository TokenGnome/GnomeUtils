//
//  GNMMultipartBody.h
//  GrowApp
//
//  Created by Brandon Smith on 6/23/13.
//  Copyright (c) 2013 Brandon Smith. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GNMMultipartBody : NSObject

@property (nonatomic, strong) NSURL *fileURL;
@property (nonatomic, copy) NSString *fileName;
@property (nonatomic, copy) NSString *MIMEType;
@property (nonatomic, strong) NSDictionary *parts;
@property (nonatomic, assign) NSStringEncoding stringEncoding;

+ (NSString *)boundary;

+ (instancetype)bodyWithFileURL:(NSURL *)fileURL;

+ (instancetype)bodyWithFileURL:(NSURL *)fileURL parts:(NSDictionary *)parts;

- (NSData *)dataForHTTPPOST;

@end
