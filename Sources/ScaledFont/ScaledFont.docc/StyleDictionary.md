# Creating A Style Dictionary

Create a style dictionary to control how a custom font scales with dynamic type content size.

## Overview

A style dictionary collects the base font metrics for each of the dynamic type text styles. You need to create a style dictionary for each custom font you want to use in your app.

A style dictionary is a property list file that you include with your app. Add an entry for each text style. The available text styles are:

- `largeTitle`, `title`, `title2`, `title3`
-  `headline`, `subheadline`, `body`, `callout`
-  `footnote`, `caption`, `caption2`

For a custom font, the value of each entry is a dictionary with two keys:

+ `fontName`: A `String` which is the font name.
+ `fontSize`: A number which is the point size to use at the `.large` (base) content size.

If you're not sure which font sizes to use for each style refer to the typography section of the [Apple Human Interface Guidelines for iOS](https://developer.apple.com/design/human-interface-guidelines/ios/visual-design/typography/). It lists the font metrics Apple uses for the default San Francisco font.

For example, to use a 17 pt Noteworthy-Bold font for the `.headline` style at the `.large` content size:

```
<dict>
  <key>headline</key>
  <dict>
    <key>fontName</key>
    <string>Noteworthy-Bold</string>
    <key>fontSize</key>
    <integer>17</integer>
  </dict>
</dict>
```

For a system font, omit `fontName` and use the optional variant keys:

+ `design`: `serif` or `monospaced`
+ `weight`: `bold`

For example, to use a serif system font for the `.subheadline` style:

```
<dict>
  <key>subheadline</key>
  <dict>
    <key>design</key>
    <string>serif</string>
  </dict>
</dict>
```

Unsupported variants are ignored. Custom font entries continue using
`fontName` and `fontSize`; system font entries fallback to the normal
system font.

You can also override the style dictionary at the call site:

```swift
Text("Metadata")
  .scaledFont(.subheadline, design: .serif, weight: .bold)
```

Call-site variants take precedence over the style dictionary. Supplying a
`design` uses the matching system font design for that view when the entry
does not specify `fontName`. Supplying `weight` applies that weight to the
system font when the entry does not specify `fontName`. For custom font
entries, `weight: .bold` uses a matching bold face from the same font family
when one is available; otherwise it keeps the configured `fontName`.

You do not need to include an entry for every text style but if you try to use a text style that is not included in the dictionary it will fallback to the system preferred font.

### Finding Font Names

If you are not sure what font names to use you can print all available names with this code snippet:

```swift
let families = UIFont.familyNames
families.sorted().forEach {
  print("\($0)")
  let names = UIFont.fontNames(forFamilyName: $0)
  print(names)
}
```

**Note that the system installed fonts are not the same for iOS, tvOS and watchOS platforms.**

## Example Style Dictionaries

See the `Examples` folder included in this package for some examples. The `Futura` font is available on iOS, tvOS and watchOS.

The `Noteworthy` style dictionary uses a built-in iOS font.

![Noteworthy font](noteworthy)

To use the `NotoSerif` example you'll need to download the font files from [Google fonts](https://fonts.google.com/specimen/Noto+Serif), add them to your application target, and list them under "Fonts provided by application" in the `Info.plist` file of the target.

![Noto Serif font](noto)

**Check the license for any fonts you plan on shipping with your application.**
