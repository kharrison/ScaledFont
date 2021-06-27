# Creating A Style Dictionary

Create a style dictionary to control how a custom font scales with dynamic type content size.

## Overview

A style dictionary collects the base font metrics for each of the dynamic type text styles. You need to create a style dictionary for each custom font you want to use in your app.

A style dictionary is a property list file that you include with your app. Add an entry for each text style. The available text styles are:

- `largeTitle`, `title`, `title2`, `title3`
-  `headline`, `subheadline`, `body`, `callout`
-  `footnote`, `caption`, `caption2`

The value of each entry is a dictionary with two keys:

+ `fontName`: A `String` which is the font name.
+ `fontSize`: A number which is the point size to use at the `.large` (base) content size.

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

## Example Style Dictionaries

See the `Examples` folder included in this package for some examples. The `Noteworthy` style dictionary uses a built-in iOS font.

![Noteworthy font](noteworthy)

To use the `NotoSerif` example you'll need to download the font files from [Google fonts](https://fonts.google.com/specimen/Noto+Serif), add them to your application target, and list them under "Fonts provided by application" in the `Info.plist` file of the target.

![Noto Serif font](noto)

**Check the license for any fonts you plan on shipping with your application.**
