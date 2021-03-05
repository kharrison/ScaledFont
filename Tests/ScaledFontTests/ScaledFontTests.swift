//  Copyright © 2021 Keith Harrison. All rights reserved.
//
//  Redistribution and use in source and binary forms, with or without
//  modification, are permitted provided that the following conditions are met:
//
//  1. Redistributions of source code must retain the above copyright
//  notice, this list of conditions and the following disclaimer.
//
//  2. Redistributions in binary form must reproduce the above copyright
//  notice, this list of conditions and the following disclaimer in the
//  documentation and/or other materials provided with the distribution.
//
//  3. Neither the name of the copyright holder nor the names of its
//  contributors may be used to endorse or promote products derived from
//  this software without specific prior written permission.
//
//  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
//  AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
//  IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
//  ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE
//  LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
//  CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
//  SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
//  INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
//  CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
//  ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
//  POSSIBILITY OF SUCH DAMAGE.

@testable import ScaledFont
import XCTest

final class ScaledFontTests: XCTestCase {
    func testStyleDictionary() {
        let fontName = "Noteworthy"
        let scaledFont = ScaledFont(fontName: fontName, bundle: .module)
        XCTAssertNotNil(scaledFont.styleDictionary)
    }

    func testLargeTitleStyle() {
        let fontName = "Noteworthy"
        let scaledFont = ScaledFont(fontName: fontName, bundle: .module)
        let title = scaledFont.font(forTextStyle: .largeTitle)
        XCTAssertEqual(title.fontName, "Noteworthy-Light")
        XCTAssertEqual(title.pointSize, 34)
    }

    func testTitle1Style() {
        let fontName = "Noteworthy"
        let scaledFont = ScaledFont(fontName: fontName, bundle: .module)
        let title = scaledFont.font(forTextStyle: .title1)
        XCTAssertEqual(title.fontName, "Noteworthy-Light")
        XCTAssertEqual(title.pointSize, 28)
    }

    func testTitle2Style() {
        let fontName = "Noteworthy"
        let scaledFont = ScaledFont(fontName: fontName, bundle: .module)
        let title = scaledFont.font(forTextStyle: .title2)
        XCTAssertEqual(title.fontName, "Noteworthy-Light")
        XCTAssertEqual(title.pointSize, 22)
    }

    func testTitle3Style() {
        let fontName = "Noteworthy"
        let scaledFont = ScaledFont(fontName: fontName, bundle: .module)
        let title = scaledFont.font(forTextStyle: .title3)
        XCTAssertEqual(title.fontName, "Noteworthy-Light")
        XCTAssertEqual(title.pointSize, 20)
    }

    func testHeadlineStyle() {
        let fontName = "Noteworthy"
        let scaledFont = ScaledFont(fontName: fontName, bundle: .module)
        let title = scaledFont.font(forTextStyle: .headline)
        XCTAssertEqual(title.fontName, "Noteworthy-Bold")
        XCTAssertEqual(title.pointSize, 17)
    }

    func testSubheadlineStyle() {
        let fontName = "Noteworthy"
        let scaledFont = ScaledFont(fontName: fontName, bundle: .module)
        let title = scaledFont.font(forTextStyle: .subheadline)
        XCTAssertEqual(title.fontName, "Noteworthy-Light")
        XCTAssertEqual(title.pointSize, 15)
    }

    func testBodyStyle() {
        let fontName = "Noteworthy"
        let scaledFont = ScaledFont(fontName: fontName, bundle: .module)
        let title = scaledFont.font(forTextStyle: .body)
        XCTAssertEqual(title.fontName, "Noteworthy-Light")
        XCTAssertEqual(title.pointSize, 17)
    }

    func testCalloutStyle() {
        let fontName = "Noteworthy"
        let scaledFont = ScaledFont(fontName: fontName, bundle: .module)
        let title = scaledFont.font(forTextStyle: .callout)
        XCTAssertEqual(title.fontName, "Noteworthy-Light")
        XCTAssertEqual(title.pointSize, 16)
    }

    func testFootnoteStyle() {
        let fontName = "Noteworthy"
        let scaledFont = ScaledFont(fontName: fontName, bundle: .module)
        let title = scaledFont.font(forTextStyle: .footnote)
        XCTAssertEqual(title.fontName, "Noteworthy-Light")
        XCTAssertEqual(title.pointSize, 13)
    }

    func testCaption1Style() {
        let fontName = "Noteworthy"
        let scaledFont = ScaledFont(fontName: fontName, bundle: .module)
        let title = scaledFont.font(forTextStyle: .caption1)
        XCTAssertEqual(title.fontName, "Noteworthy-Light")
        XCTAssertEqual(title.pointSize, 12)
    }

    func testCaption2Style() {
        let fontName = "Noteworthy"
        let scaledFont = ScaledFont(fontName: fontName, bundle: .module)
        let title = scaledFont.font(forTextStyle: .caption2)
        XCTAssertEqual(title.fontName, "Noteworthy-Light")
        XCTAssertEqual(title.pointSize, 11)
    }

    func testFallbackWhenHeadlineStyleMissing() {
        let fontName = "Notworthy"
        let scaledFont = ScaledFont(fontName: fontName, bundle: .module)
        let title = scaledFont.font(forTextStyle: .headline)
        XCTAssertEqual(title.familyName, ".AppleSystemUIFont")
    }

    func testTitleStyleWhenHeadlineStyleMissing() {
        let fontName = "Notworthy"
        let scaledFont = ScaledFont(fontName: fontName, bundle: .module)
        let title = scaledFont.font(forTextStyle: .title1)
        XCTAssertEqual(title.fontName, "Noteworthy-Light")
        XCTAssertEqual(title.pointSize, 28)
    }

    func testFallbackWhenDictionaryInvalid() {
        let fontName = "InvalidBodyStyle"
        let scaledFont = ScaledFont(fontName: fontName, bundle: .module)
        let title = scaledFont.font(forTextStyle: .title1)
        XCTAssertEqual(title.familyName, ".AppleSystemUIFont")
    }
}
