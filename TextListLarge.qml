import QtQuick

Text {
  id:idText
  signal click
  signal pressAndHold
  verticalAlignment: Text.AlignVCenter
  font.pointSize:nFontSize * 1.4
 // height:23
  MouseArea{
    anchors.fill: parent
    onClicked: idText.click()
    onPressAndHold:idText.pressAndHold()
  }
}

