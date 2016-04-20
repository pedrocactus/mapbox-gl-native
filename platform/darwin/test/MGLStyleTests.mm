#import "MGLStyle.h"

#import <mbgl/util/default_styles.hpp>

#import <XCTest/XCTest.h>
#import <objc/runtime.h>

@interface MGLStyleTests : XCTestCase
@end

@implementation MGLStyleTests

- (void)testUnversionedStyleURLs {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
    XCTAssertEqualObjects([MGLStyle streetsStyleURL].absoluteString, @(mbgl::util::default_styles::streets.url));
    XCTAssertEqualObjects([MGLStyle emeraldStyleURL].absoluteString, @"mapbox://styles/mapbox/emerald-v8");
    XCTAssertEqualObjects([MGLStyle lightStyleURL].absoluteString, @(mbgl::util::default_styles::light.url));
    XCTAssertEqualObjects([MGLStyle darkStyleURL].absoluteString, @(mbgl::util::default_styles::dark.url));
    XCTAssertEqualObjects([MGLStyle satelliteStyleURL].absoluteString, @(mbgl::util::default_styles::satellite.url));
    XCTAssertEqualObjects([MGLStyle hybridStyleURL].absoluteString, @(mbgl::util::default_styles::hybrid.url));
#pragma clang diagnostic pop
}

- (void)testVersionedStyleURLs {
    // Test that all the default styles have publicly-declared MGLStyle class
    // methods and that the URLs all have the right values.
    XCTAssertEqualObjects([MGLStyle streetsStyleURLWithVersion:MGLStyleCurrentVersion].absoluteString, @(mbgl::util::default_styles::streets.url));
    XCTAssertEqualObjects([MGLStyle outdoorsStyleURLWithVersion:MGLStyleCurrentVersion].absoluteString, @(mbgl::util::default_styles::outdoors.url));
    XCTAssertEqualObjects([MGLStyle lightStyleURLWithVersion:MGLStyleCurrentVersion].absoluteString, @(mbgl::util::default_styles::light.url));
    XCTAssertEqualObjects([MGLStyle darkStyleURLWithVersion:MGLStyleCurrentVersion].absoluteString, @(mbgl::util::default_styles::dark.url));
    XCTAssertEqualObjects([MGLStyle satelliteStyleURLWithVersion:MGLStyleCurrentVersion].absoluteString, @(mbgl::util::default_styles::satellite.url));
    XCTAssertEqualObjects([MGLStyle hybridStyleURLWithVersion:MGLStyleCurrentVersion].absoluteString, @(mbgl::util::default_styles::hybrid.url));
    
    static_assert(6 == mbgl::util::default_styles::numOrderedStyles,
                  "MGLStyleTests isn’t testing all the styles in mbgl::util::default_styles.");
}

- (void)testStyleURLComprehensiveness {
    // Make sure this test is comprehensive.
    const unsigned numImplicitArgs = 2 /* _cmd, self */;
    unsigned numMethods = 0;
    Method *methods = class_copyMethodList(object_getClass([MGLStyle class]), &numMethods);
    unsigned numVersionedStyleURLMethods = 0;
    for (NSUInteger i = 0; i < numMethods; i++) {
        Method method = methods[i];
        SEL selector = method_getName(method);
        NSString *name = @(sel_getName(selector));
        unsigned numArgs = method_getNumberOfArguments(method);
        if ([name hasSuffix:@"StyleURL"]) {
            XCTAssertEqual(numArgs, numImplicitArgs, @"Unversioned style URL method should have no parameters, but it has %u.", numArgs - numImplicitArgs);
        } else if ([name hasSuffix:@"StyleURLWithVersion:"]) {
            XCTAssertEqual(numArgs, numImplicitArgs + 1, @"Versioned style URL method should have one parameter, but it has %u.", numArgs - numImplicitArgs);
            numVersionedStyleURLMethods++;
        } else {
            XCTAssertEqual([name rangeOfString:@"URL"].location, NSNotFound, @"MGLStyle style URL method %@ is malformed.", name);
        }
    }
    XCTAssertEqual(mbgl::util::default_styles::numOrderedStyles, numVersionedStyleURLMethods,
                   @"There are %lu default styles but MGLStyleTests only provides versioned style URL methods for %u of them.",
                   mbgl::util::default_styles::numOrderedStyles, numVersionedStyleURLMethods);
}

@end
