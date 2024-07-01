import QtQuick 2.5
import QtQuick.Controls 2.2


TabButton {
  id: control2

  property int nFontPixSize : idWindow.width / 25

  background: Rectangle {
    color: control2.checked ?"#626567" :"#BDC3C7"
    opacity: control2.down ? 1 :0.9
  }
  contentItem: Text {
    text: control2.text
    font.pixelSize:  nFontPixSize
    horizontalAlignment: Text.AlignHCenter
    verticalAlignment: Text.AlignVCenter
    color: control2.checked ? "white" : "black"
  }
}
