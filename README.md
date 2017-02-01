# DetectTapCharacterInUILabel
Detect the tapped character in UILabel using TextKit example

Note：

在 http://stackoverflow.com/a/26806991 有提到：

> In fact you need to adjust testStorage slightly in compare to original label size. It is empiric fact that for every additional line of UILabel you need to add about 1pt to height. So textStorage should be set dynamically depending on number of lines.

因此指定 `NSTextContainer` 的 size 時，其高度必須多加上 `number of lines x 1pt`；或是直接指定高度為 `CGFloat.greatestFiniteMagnitude`。

不過在此範例中，經過測試，直接指定 `NSTextContainer` 的 size 為 `UILabel` 的 size，並不會影響到其判斷。

因此在此範例中，`NSTextContainer` 的 size 仍是直接指定為 `UILabel` 的 size。
