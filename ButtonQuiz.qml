import QtQuick
// import QtQuick.Controls
import QtQuick.Controls.Basic

Button {
  id: idButtonQuiz
  width: n4BtnWidth
  height: nBtnHeight
  property bool bProgVisible
  property bool bIsPressedIn: false
  property int nButtonFontSize: idWindow.width / 30

  BusyIndicator {
    anchors.centerIn: parent
    running: bProgVisible
  }

  background: Rectangle {
    border.width: activeFocus ? 2 : 1
    border.color: "#888"
    radius: 4
    color: {
      if (idButtonQuiz.down)
        return "steelblue"

      if (bProgVisible)
        return "orange"

      if (bIsPressedIn)
        return "#009bff"

      return "lightsteelblue"
    }
  }



  font.pixelSize: nButtonFontSize
  text: control.text

}
