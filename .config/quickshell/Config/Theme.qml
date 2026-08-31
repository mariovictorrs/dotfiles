pragma Singleton
import QtQml

QtObject {
  // Bar
  readonly property real barHeightRatio: 0.04
  readonly property int  barMargin:      12
  readonly property int  widgetSpacing:  16

  // Popup
  readonly property int popupPadding:      14
  readonly property int popupSpacing:      12
  readonly property int popupWidthNarrow:  220
  readonly property int popupWidthNormal:  320
  readonly property int popupWidthWide:    360

  // Shape
  readonly property int buttonRadius: 10
  readonly property int popupRadius:  16
  readonly property int itemRadius:   11
  readonly property int buttonHeight: 28
  readonly property int buttonPadding: 18

  // Pill
  readonly property int pillHeight:    32
  readonly property int pillPaddingH:  14
  readonly property int pillSpacing:   16

  // Font sizes
  readonly property int fontSizeSmall:  12
  readonly property int fontSizeNormal: 13
  readonly property int fontSizeMedium: 15
  readonly property int fontSizeLarge:  28
  readonly property int fontSizeHero:   36
}
