import QtQuick

Text {
  id:idText
  signal click
  signal pressAndHold
  verticalAlignment: Text.AlignVCenter
  font.pixelSize:nFontSizeLarge
  MouseArea{
    anchors.fill: parent
    onClicked: idText.click()
    onPressAndHold:idText.pressAndHold()
  }
}

