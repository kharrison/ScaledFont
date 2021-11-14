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

import SwiftUI

@available(iOS 13.0, tvOS 13.0, watchOS 6.0, *)
extension ScaledFont.StyleKey {
    init?(_ textStyle: Font.TextStyle) {
        switch textStyle {
        case .largeTitle: self = .largeTitle
        case .title: self = .title
        case .title2: self = .title2
        case .title3: self = .title3
        case .headline: self = .headline
        case .subheadline: self = .subheadline
        case .body: self = .body
        case .callout: self = .callout
        case .footnote: self = .footnote
        case .caption: self = .caption
        case .caption2: self = .caption2
        @unknown default: return nil
        }
    }
}

@available(iOS 13.0, tvOS 13.0, watchOS 6.0, *)
extension ScaledFont {
    /// Get the scaled font for the given text style using the
    /// style dictionary supplied at initialization.
    ///
    /// - Parameter textStyle: The `Font.TextStyle` for the
    ///   font.
    /// - Returns: A `Font` of the custom font that has been
    ///   scaled for the users currently selected preferred
    ///   text size.
    ///
    /// - Note: If the style dictionary does not have
    ///   a font for this text style the default system
    ///   font is returned.

    internal func font(forTextStyle textStyle: Font.TextStyle) -> Font {
        if #available(iOS 14.0, tvOS 14.0, watchOS 7.0, *) {
            guard let styleKey = StyleKey(textStyle),
                  let fontDescription = styleDictionary?[styleKey.rawValue]
            else {
                return Font.system(textStyle)
            }

            return Font.custom(fontDescription.fontName, size: fontDescription.fontSize, relativeTo: textStyle)
        } else {
            // Falback to UIKit methods for iOS 13
            return Font(font(forTextStyle: uiTextStyle(textStyle)))
        }
    }

    private func uiTextStyle(_ textStyle: Font.TextStyle) -> UIFont.TextStyle {
        switch textStyle {
        case .largeTitle: return largeTitle()
        case .title: return .title1
        case .title2: return .title2
        case .title3: return .title3
        case .headline: return .headline
        case .subheadline: return .subheadline
        case .body: return .body
        case .callout: return .callout
        case .footnote: return .footnote
        case .caption: return .caption1
        case .caption2: return .caption2
        @unknown default: return .body
        }
    }

    // On tvOS fallback to .title1 text style as
    // UIKit (but not SwiftUI) is missing .largeTitle.
    private func largeTitle() -> UIFont.TextStyle {
        #if os(tvOS)
            return .title1
        #else
            return .largeTitle
        #endif
    }
}

@available(iOS 13.0, tvOS 13.0, watchOS 6.0, *)
private struct ScaledFontModifier: ViewModifier {
    @Environment(\.scaledFont) var scaledFont
    let textStyle: Font.TextStyle

    func body(content: Content) -> some View {
        content
            .font(scaledFont.font(forTextStyle: textStyle))
    }
}

@available(iOS 13.0, tvOS 13.0, watchOS 6.0, *)
public extension View {
    /// Sets the text style of the scaled font for text
    /// in the view.
    /// - Parameter textStyle: A dynamic type text styles
    /// - Returns: A View that uses the scaled font with the
    ///   specified dynamic type text style.
    func scaledFont(_ textStyle: Font.TextStyle = .body) -> some View {
        return modifier(ScaledFontModifier(textStyle: textStyle))
    }
}

private struct ScaledFontKey: EnvironmentKey {
    static var defaultValue = ScaledFont(fontName: "Default")
}

@available(iOS 13.0, tvOS 13.0, watchOS 6.0, *)
public extension EnvironmentValues {
    /// A custom font that supports dynamic type
    /// text styles.
    var scaledFont: ScaledFont {
        get { self[ScaledFontKey.self] }
        set { self[ScaledFontKey.self] = newValue }
    }
}

@available(iOS 13.0, tvOS 13.0, watchOS 6.0, *)
public extension View {
    /// Set the scaledFont environment property
    /// - Parameter scaledFont: A ScaledFont to use
    func scaledFont(_ scaledFont: ScaledFont) -> some View {
        environment(\.scaledFont, scaledFont)
    }
}

#if swift(>=5.3)
    @available(iOS 14.0, tvOS 14.0, watchOS 7.0, *)
    struct ModifierLibrary: LibraryContentProvider {
        @LibraryContentBuilder
        func modifiers(base: Text) -> [LibraryItem] {
            LibraryItem(base.scaledFont(.headline), category: .effect)
        }
    }
#endif
