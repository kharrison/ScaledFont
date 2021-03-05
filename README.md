# ScaledFont - Custom Fonts With Dynamic Type

**A utility type to help you use custom fonts with dynamic type.**

Dynamic type is an **essential iOS feature** that allows the user to choose their preferred text size. Fully supporting dynamic type with a custom font requires two things:

1. Define a base font with a suitable font weight and size for each of the possible text styles at the Large (Default) content size.
2. Scale the base font across the range of dynamic type content sizes.

For the first step, you might want to start with the typography section of the [Apple Human Interface Guidelines for iOS](https://developer.apple.com/design/human-interface-guidelines/ios/visual-design/typography/) which list the font metrics Apple uses for the default San Francisco font.

For example, here I'm creating a bold Noteworthy font at 17 points as the base headline font and a light version of the font for the base body font:

```swift
let headlineFont = UIFont(name: "Noteworthy-Bold", size: 17)
let bodyFont = UIFont(name: "Noteworthy-Light", size: 17)
```

For the second step, it's been possible since iOS 11 to scale a base font for the user's chosen dynamic type size using font metrics:

```swift
let headMetrics = UIFontMetrics(forTextStyle: .headline)
headlineLabel.font = headMetrics.scaledFont(for: headlineFont)

let bodyMetrics = UIFontMetrics(forTextStyle: .body)
bodyLabel.font = bodyMetrics.scaledFont(for: bodyFont)
```

The problem, if you do this for every text style you use, is that you end up with those font metrics spread all over your app. That's both difficult to maintain and hard to keep consistent when you want to make design changes.

**TIP: Don't forget when using UIKit labels, text fields and text views to enable automatic adjustments when the user changes their preferred content size:**

```swift
label.adjustsFontForContentSizeCategory = true
```

## Style Dictionary

To make it easier to manage the base font metrics for all of the possible text styles the `ScaledFont` type collects them into a style dictionary. You store the style dictionary as a property list file that, by default, you include in the main bundle.

The style dictionary contains an entry for each text style. The available text styles are:

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

To use the `NotoSerif` example you'll need to download the font files from [Google fonts](https://fonts.google.com/specimen/Noto+Serif), add them to your application target, and list them under "Fonts provided by application" in the `Info.plist` file of the target.

**Check the license for any fonts you plan on shipping with your application.**

## Using A ScaledFont - UIKit

When using `UIKit` you apply the scaled font to the text label, text field or text view in code. You need a minimum deployment target of iOS 11 or later. 

1. Create the `ScaledFont` by specifying the name of the style dictionary. Add the style dictionary to the main bundle along with any custom fonts you are using:

    ```swift
    let scaledFont = ScaledFont(fontName: "Noteworthy")
    ```

2. Use the `font(forTextStyle:)` method of the scaled font when setting the font of any text labels, fields or views: 

    ```swift
    let label = UILabel()
    label.font = scaledFont.font(forTextStyle: .headline)
    ```

3. Remember to set the `adjustsFontFotContentSizeCategory` property to have the font size adjust automatically when the user changes their preferred content size:

    ```swift
    label.adjustsFontForContentSizeCategory = true
    ```

## Using A ScaledFont - SwiftUI

When using SwiftUI you create the scaled font and add it to the environment of a view. You then apply the scaled font using a view modifier to any view in the view hierarchy. You need a minimum deployment target of iOS 13 or later to use SwiftUI. 

1. Create the `ScaledFont` by specifying the name of the style dictionary. Add the style dictionary to the main bundle along with any custom fonts you are using:

    ```swift
    let scaledFont = ScaledFont(fontName: "Noteworthy")
    ```

2. Apply the scaled font to the environment of a view. This might typically be the root view of your view hierarchy:

    ```swift
    ContentView()
    .environment(\.scaledFont, scaledFont)
    ```

3. Apply the scaled font view modifier to a view containing text in the view hierarchy:

    ```swift
    Text("Headline")
    .scaledFont(.headline)
    ```

## Further Reading

The following blog post on [useyourloaf.com](https://useyourloaf.com) provide more details:

+ [Using A Custom Font With Dynamic Type](https://useyourloaf.com/blog/using-a-custom-font-with-dynamic-type/)
