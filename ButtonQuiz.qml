import QtQuick
import QtQuick.Controls

Button {
  id: idButtonQuiz
  width: n4BtnWidth
  height: nBtnHeight
  property bool bProgVisible
  property bool bIsPressedIn: false
  property int nButtonFontSize: nFontSize
  property int nTextWidth

  BusyIndicator {
    anchors.centerIn: parent
    running: bProgVisible
  }

  background: Rectangle {
    border.width: control.activeFocus ? 2 : 1
    border.color: "#888"
    radius: 4
    color: {
      if (control.pressed)
        return "steelblue"

      if (bProgVisible)
        return "orange"

      if (bIsPressedIn)
        return "#009bff"

      return "lightsteelblue"
    }
  }

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
}
