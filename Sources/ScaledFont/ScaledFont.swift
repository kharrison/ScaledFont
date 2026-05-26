//  Copyright (c) 2017-2021 Keith Harrison. All rights reserved.
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

#if canImport(UIKit)
import UIKit
typealias PlatformFont = UIFont
typealias PlatformFontDescriptor = UIFontDescriptor
#elseif canImport(AppKit)
import AppKit
typealias PlatformFont = NSFont
typealias PlatformFontDescriptor = NSFontDescriptor
#endif

/// A utility type to help you use custom fonts with
/// dynamic type.
///
/// To use this type you must supply the name of a style
/// dictionary for the font when creating the `ScaledFont`.
/// The style dictionary should be stored as a property list
/// file in the main bundle.
///
/// The style dictionary contains an entry for each text
/// style. The available text styles are:
///
/// - `largeTitle`, `title`, `title2`, `title3`
/// -  `headline`, `subheadline`, `body`, `callout`
/// -  `footnote`, `caption`, `caption2`
///
/// For a custom font, the value of each entry is a dictionary
/// with two keys:
///
/// + `fontName`: A `String` which is the font name.
/// + `fontSize`: A number which is the point size to use
///             at the `.large` (base) content size.
///
/// For example to use a 17 pt Noteworthy-Bold font
/// for the `.headline` style at the `.large` content size:
///
///     <dict>
///         <key>headline</key>
///         <dict>
///             <key>fontName</key>
///             <string>Noteworthy-Bold</string>
///             <key>fontSize</key>
///             <integer>17</integer>
///         </dict>
///     </dict>
///
/// For a system font, omit `fontName` and use the optional
/// variant keys:
///
/// + `design`: `serif` or `monospaced`
/// + `weight`: `bold`
///
/// You can override the style dictionary at the call site:
///
///     Text("Metadata")
///     .scaledFont(.subheadline, design: .serif, weight: .bold)
///
/// You do not need to include an entry for every text style
/// but if you try to use a text style that is not included
/// in the dictionary it will fallback to the system preferred
/// font.
///
/// ## Using With UIKit
///
/// For `UIKit`, apply the scaled font to text labels, text fields or text
/// views:
///
/// ```swift
/// let scaledFont = ScaledFont(fontName: "Noteworthy")
/// label.font = scaledFont.font(forTextStyle: .headline)
/// label.adjustsFontForContentSizeCategory = true
/// ```
///
/// Remember to set the `adjustsFontFotContentSizeCategory` property
/// to have the font size adjust automatically when the user changes
/// their preferred content size.
///
/// ## Using With SwiftUI
///
/// For SwiftUI, add the scaled font to the environment of a view:
///
/// ```swift
/// ContentView()
/// .environment(\.scaledFont, scaledFont)
/// ```
///
/// Then apply the scaled font view modifier to any view containing
/// text in the view hierarchy:
///
/// ```swift
/// Text("Headline")
/// .scaledFont(.headline)
/// ```
///

@available(iOS 11.0, macOS 11.0, tvOS 11.0, watchOS 4.0, *)
public struct ScaledFont {
    internal enum StyleKey: String, Decodable {
        case largeTitle, title, title2, title3
        case headline, subheadline, body, callout
        case footnote, caption, caption2
    }

    internal struct FontDescription: Decodable {
        let fontSize: CGFloat?
        let fontName: String?
        let design: FontDesign?
        let weight: FontWeight?
    }

    public enum FontDesign: String {
        case serif, monospaced
    }

    public enum FontWeight: String {
        case bold
    }

    internal typealias StyleDictionary = [StyleKey.RawValue: FontDescription]
    internal var styleDictionary: StyleDictionary?

    /// Create a `ScaledFont`
    ///
    /// - Parameter fontName: Name of a plist file (without the extension)
    ///   that contains the style dictionary used to scale fonts for each
    ///   text style.
    /// - Parameter bundle: The `Bundle` that contains the style dictionary.
    ///   Default is the main bundle.

    public init(fontName: String, bundle: Bundle = .main) {
        if let url = bundle.url(forResource: fontName, withExtension: "plist"),
           let data = try? Data(contentsOf: url)
        {
            let decoder = PropertyListDecoder()
            styleDictionary = try? decoder.decode(StyleDictionary.self, from: data)
        }
    }

    /// Get the scaled font for the given text style using the
    /// style dictionary supplied at initialization.
    ///
    /// - Parameter textStyle: The `UIFont.TextStyle` for the
    ///   font.
    /// - Returns: A `UIFont` of the custom font that has been
    ///   scaled for the users currently selected preferred
    ///   text size.
    ///
    /// - Note: If the style dictionary does not have
    ///   a font for this text style the default preferred
    ///   font is returned.

    #if canImport(UIKit)
    public func font(
        forTextStyle textStyle: UIFont.TextStyle,
        design: FontDesign? = nil,
        weight: FontWeight? = nil
    ) -> UIFont {
        font(forPlatformTextStyle: textStyle, design: design, weight: weight)
    }
    #elseif canImport(AppKit)
    public func font(
        forTextStyle textStyle: NSFont.TextStyle,
        design: FontDesign? = nil,
        weight: FontWeight? = nil
    ) -> NSFont {
        font(forPlatformTextStyle: textStyle, design: design, weight: weight)
    }
    #endif

    private func font(
        forPlatformTextStyle textStyle: PlatformFont.TextStyle,
        design: FontDesign?,
        weight: FontWeight?
    ) -> PlatformFont {
        let styleKey = StyleKey(textStyle)
        let fontDescription = styleKey.flatMap { styleDictionary?[$0.rawValue] }
        let effectiveDesign = design ?? fontDescription?.design
        let effectiveWeight = weight ?? fontDescription?.weight

        if let fontName = fontDescription?.fontName,
           let fontSize = fontDescription?.fontSize,
           var font = PlatformFont(name: fontName, size: fontSize) {
            if effectiveWeight == .bold {
                font = boldFontIfAvailable(for: font)
            }

            #if canImport(UIKit)
            let fontMetrics = UIFontMetrics(forTextStyle: textStyle)
            return fontMetrics.scaledFont(for: font)
            #elseif canImport(AppKit)
            return font
            #endif
        }

        return systemFont(forTextStyle: textStyle, design: effectiveDesign, weight: effectiveWeight)
    }

    private func systemFont(
        forTextStyle textStyle: PlatformFont.TextStyle,
        design: FontDesign?,
        weight: FontWeight?
    ) -> PlatformFont {
        #if canImport(UIKit)
        let preferredFont = PlatformFont.preferredFont(forTextStyle: textStyle)
        let baseFont: PlatformFont
        if weight == .bold {
            baseFont = PlatformFont.systemFont(ofSize: preferredFont.pointSize, weight: .bold)
        } else {
            baseFont = preferredFont
        }

        let font: PlatformFont
        if #available(iOS 13.0, tvOS 13.0, watchOS 6.0, *),
           let design,
           let descriptor = baseFont.fontDescriptor.withDesign(design.systemDesign) {
            font = PlatformFont(descriptor: descriptor, size: baseFont.pointSize)
        } else {
            font = baseFont
        }

        let fontMetrics = UIFontMetrics(forTextStyle: textStyle)
        return fontMetrics.scaledFont(for: font)
        #elseif canImport(AppKit)
        let preferredFont = PlatformFont.preferredFont(forTextStyle: textStyle)
        var font = preferredFont

        if weight == .bold {
            font = PlatformFont.systemFont(ofSize: preferredFont.pointSize, weight: .bold)
        }

        if let design,
           let descriptor = font.fontDescriptor.withDesign(design.systemDesign),
           let designedFont = NSFont(descriptor: descriptor, size: font.pointSize) {
            font = designedFont
        }

        return font
        #endif
    }

    private func boldFontIfAvailable(for font: PlatformFont) -> PlatformFont {
        #if canImport(UIKit)
        guard let boldFontName = PlatformFont
            .fontNames(forFamilyName: font.familyName)
            .first(where: { fontName in
                guard fontName != font.fontName,
                      let candidate = PlatformFont(name: fontName, size: font.pointSize)
                else {
                    return false
                }

                return candidate.fontDescriptor.symbolicTraits.contains(.traitBold)
            }),
            let boldFont = PlatformFont(name: boldFontName, size: font.pointSize)
        else {
            return font
        }

        return boldFont
        #elseif canImport(AppKit)
        let boldFont = NSFontManager.shared.convert(font, toHaveTrait: .boldFontMask)
        guard boldFont.fontName != font.fontName,
              boldFont.fontDescriptor.symbolicTraits.contains(.bold)
        else {
            return font
        }

        return boldFont
        #endif
    }
}

extension ScaledFont.FontDescription {
    private enum CodingKeys: String, CodingKey {
        case fontSize, fontName, design, weight
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        fontSize = try container.decodeIfPresent(CGFloat.self, forKey: .fontSize)
        fontName = try container.decodeIfPresent(String.self, forKey: .fontName)

        if let rawDesign = try container.decodeIfPresent(String.self, forKey: .design) {
            design = ScaledFont.FontDesign(rawValue: rawDesign)
        } else {
            design = nil
        }

        if let rawWeight = try container.decodeIfPresent(String.self, forKey: .weight) {
            weight = ScaledFont.FontWeight(rawValue: rawWeight)
        } else {
            weight = nil
        }
    }
}

@available(iOS 13.0, macOS 11.0, tvOS 13.0, watchOS 6.0, *)
extension ScaledFont.FontDesign {
    var systemDesign: PlatformFontDescriptor.SystemDesign {
        switch self {
            case .serif: return .serif
            case .monospaced: return .monospaced
        }
    }
}

@available(iOS 11.0, macOS 11.0, tvOS 11.0, watchOS 4.0, *)
extension ScaledFont.StyleKey {
    init?(_ textStyle: PlatformFont.TextStyle) {
        #if canImport(UIKit)
        #if !os(tvOS)
        if #available(watchOS 5.0, *) {
            if textStyle == .largeTitle {
                self = .largeTitle
                return
            }
        }
        #endif
        #endif
        switch textStyle {
            #if canImport(AppKit)
            case .largeTitle: self = .largeTitle
            #endif
            case .title1: self = .title
            case .title2: self = .title2
            case .title3: self = .title3
            case .headline: self = .headline
            case .subheadline: self = .subheadline
            case .body: self = .body
            case .callout: self = .callout
            case .footnote: self = .footnote
            case .caption1: self = .caption
            case .caption2: self = .caption2
            default: return nil
        }
    }
}
