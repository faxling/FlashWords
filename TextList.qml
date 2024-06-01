import QtQuick

Text {
  id:idText
  signal click
  signal pressAndHold
  verticalAlignment: Text.AlignVCenter
  font.pointSize:nFontSize
  MouseArea{
    anchors.fill: parent
    onClicked: idText.click()
    onPressAndHold:idText.pressAndHold()
  }
}

