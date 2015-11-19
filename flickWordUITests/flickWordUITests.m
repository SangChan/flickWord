//
//  flickWordUITests.m
//  flickWordUITests
//
//  Created by SangChan Lee on 11/19/15.
//  Copyright © 2015 sangchan. All rights reserved.
//

#import <XCTest/XCTest.h>

@interface flickWordUITests : XCTestCase

@end

@implementation flickWordUITests

- (void)setUp {
    [super setUp];
    
    // Put setup code here. This method is called before the invocation of each test method in the class.
    
    // In UI tests it is usually best to stop immediately when a failure occurs.
    self.continueAfterFailure = NO;
    // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
    [[[XCUIApplication alloc] init] launch];
    
    // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testExample {
    // Use recording to get started writing UI tests.
    // Use XCTAssert and related functions to verify your tests produce the correct results.
    // Failed to find matching element please file bug (bugreport.apple.com) and provide output from Console.app
    // Failed to find matching element please file bug (bugreport.apple.com) and provide output from Console.app
    
    XCUIApplication *app = [[XCUIApplication alloc] init];
    XCUIElement *element = [[[[app childrenMatchingType:XCUIElementTypeWindow] elementBoundByIndex:0] childrenMatchingType:XCUIElementTypeOther].element childrenMatchingType:XCUIElementTypeOther].element;
    [element tap];
    [element tap];
    [element tap];
    [element tap];
    [element tap];
    [app.buttons[@"\Uf053"] tap];
}

@end
