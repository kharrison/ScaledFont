# ``ScaledFont``

A utility type to help you use custom fonts with dynamic type.

## Overview

Dynamic type is an **essential iOS feature** that allows the user to choose their preferred text size. Fully supporting dynamic type with a custom font requires two things:

1. Define a base font with a suitable font weight and size for each of the possible text styles at the Large (Default) content size.
2. Scale the base font across the range of dynamic type content sizes.

The problem, if you do this for every text style you use, is that you end up with those font metrics spread all over your app. That's both difficult to maintain and hard to keep consistent when you want to make design changes.

To make it easier to manage the base font metrics for all of the possible text styles the `ScaledFont` type collects them into a **style dictionary**. You store the style dictionary as a property list file that, by default, you include in the main bundle.

## Topics

### Getting Started

- <doc:StyleDictionary>
