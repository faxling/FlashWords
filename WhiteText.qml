import QtQuick

Text {
  id:idText
  signal click
  font.pointSize: nFontSize
  color: "white"
  MouseArea{
    anchors.fill: parent
    onClicked: idText.click()
  }
}


