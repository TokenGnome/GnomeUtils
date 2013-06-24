//
//  GNMMultipartBodyTests.m
//  GrowApp
//
//  Created by Brandon Smith on 6/23/13.
//  Copyright (c) 2013 Brandon Smith. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "GNMMultipartBody.h"

@interface GNMMultipartBodyTests : XCTestCase
@property (nonatomic, strong) NSDictionary *fileURLs;
@end

@implementation GNMMultipartBodyTests

- (void)setUp
{
    [super setUp];
    
    NSBundle *testBundle = [NSBundle bundleForClass:[self class]];    
    self.fileURLs =
    @{@"png": [testBundle URLForResource:@"testImage" withExtension:@"png"],
      @"jpg": [testBundle URLForResource:@"testImage" withExtension:@"jpg"]};
    
}

- (void)tearDown
{
    [super tearDown];
}



- (void)testBodyWithPNGImage
{
    GNMMultipartBody *body = [GNMMultipartBody bodyWithFileURL:self.fileURLs[@"png"]];
    
    XCTAssertEqualObjects(body.MIMEType, @"image/png", @"Wrong MIMEType for %s", __PRETTY_FUNCTION__);
    XCTAssertEqualObjects(body.fileURL, self.fileURLs[@"png"], @"Wrong fileURL for %s", __PRETTY_FUNCTION__);
    XCTAssertEqualObjects(body.fileName, @"testImage.png", @"Wrong fileName for %s", __PRETTY_FUNCTION__);
}

- (void)testBodyWithImageAndParts
{
    GNMMultipartBody *body = [GNMMultipartBody bodyWithFileURL:self.fileURLs[@"jpg"]];
    
    XCTAssertEqualObjects(body.MIMEType, @"image/jpg", @"Wrong MIMEType for %s", __PRETTY_FUNCTION__);
    XCTAssertEqualObjects(body.fileURL, self.fileURLs[@"jpg"], @"Wrong fileURL for %s", __PRETTY_FUNCTION__);
    XCTAssertEqualObjects(body.fileName, @"testImage.jpg", @"Wrong fileName for %s", __PRETTY_FUNCTION__);
}

@end
