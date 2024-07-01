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
  property int nTextWidth

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
/*
  contentItem: Text {
    id: idTextLabel
    renderType: Text.NativeRendering
    verticalAlignment: Text.AlignVCenter
    horizontalAlignment: Text.AlignHCenter
    font.pointSize: nButtonFontSize
    text: control.text
    TextMetrics {
      id: t_metrics
      font: idTextLabel.font
      text: idTextLabel.text
      onWidthChanged: idButtonQuiz.nTextWidth = width
    }
  }
  */
}
