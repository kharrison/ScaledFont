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

import ScaledFont
import XCTest

@available(iOS 11.0, tvOS 11.0, watchOS 4.0, *)
final class ScaledFontTests: XCTestCase {
    private let testFont = "Futura"
    private let defaultFontName = "Futura-Medium"
    private let boldFontName = "Futura-Bold"
    private let italicFontName = "Futura-MediumItalic"
    
    #if !os(tvOS)
    func testLargeTitleStyle() {
        let scaledFont = ScaledFont(fontName: testFont, bundle: .module)
        let font = scaledFont.font(forTextStyle: .largeTitle)
        XCTAssertEqual(font.fontName, defaultFontName)
    }
    #endif

    func testTitle1Style() {
        let scaledFont = ScaledFont(fontName: testFont, bundle: .module)
        let font = scaledFont.font(forTextStyle: .title1)
        XCTAssertEqual(font.fontName, defaultFontName)
    }

    func testTitle2Style() {
        let scaledFont = ScaledFont(fontName: testFont, bundle: .module)
        let font = scaledFont.font(forTextStyle: .title2)
        XCTAssertEqual(font.fontName, defaultFontName)
    }

    func testTitle3Style() {
        let scaledFont = ScaledFont(fontName: testFont, bundle: .module)
        let font = scaledFont.font(forTextStyle: .title3)
        XCTAssertEqual(font.fontName, defaultFontName)
    }

    func testHeadlineStyle() {
        let scaledFont = ScaledFont(fontName: testFont, bundle: .module)
        let font = scaledFont.font(forTextStyle: .headline)
        XCTAssertEqual(font.fontName, boldFontName)
    }

    func testSubheadlineStyle() {
        let scaledFont = ScaledFont(fontName: testFont, bundle: .module)
        let font = scaledFont.font(forTextStyle: .subheadline)
        XCTAssertEqual(font.fontName, italicFontName)
    }

    func testBodyStyle() {
        let scaledFont = ScaledFont(fontName: testFont, bundle: .module)
        let font = scaledFont.font(forTextStyle: .body)
        XCTAssertEqual(font.fontName, defaultFontName)
    }

    func testCalloutStyle() {
        let scaledFont = ScaledFont(fontName: testFont, bundle: .module)
        let font = scaledFont.font(forTextStyle: .callout)
        XCTAssertEqual(font.fontName, defaultFontName)
    }

    func testFootnoteStyle() {
        let scaledFont = ScaledFont(fontName: testFont, bundle: .module)
        let font = scaledFont.font(forTextStyle: .footnote)
        XCTAssertEqual(font.fontName, defaultFontName)
    }

    func testCaption1Style() {
        let scaledFont = ScaledFont(fontName: testFont, bundle: .module)
        let font = scaledFont.font(forTextStyle: .caption1)
        XCTAssertEqual(font.fontName, italicFontName)
    }

    func testCaption2Style() {
        let scaledFont = ScaledFont(fontName: testFont, bundle: .module)
        let font = scaledFont.font(forTextStyle: .caption2)
        XCTAssertEqual(font.fontName, italicFontName)
    }

    func testFallbackWhenHeadlineStyleMissing() {
        let scaledFont = ScaledFont(fontName: "MissingHeadline", bundle: .module)
        let font = scaledFont.font(forTextStyle: .headline)
        XCTAssertEqual(font.familyName, ".AppleSystemUIFont")
    }

    func testTitleStyleWhenHeadlineStyleMissing() {
        let scaledFont = ScaledFont(fontName: "MissingHeadline", bundle: .module)
        let font = scaledFont.font(forTextStyle: .title1)
        XCTAssertEqual(font.fontName, defaultFontName)
    }

    func testFallbackWhenDictionaryInvalid() {
        let fontName = "InvalidBodyStyle"
        let scaledFont = ScaledFont(fontName: fontName, bundle: .module)
        let font = scaledFont.font(forTextStyle: .body)
        XCTAssertEqual(font.familyName, ".AppleSystemUIFont")
    }
}
