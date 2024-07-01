import QtQuick

Rectangle {
  radius: 10
  anchors.fill: parent
  anchors.topMargin: 10

  gradient: "NearMoon"

  ButtonQuizImgLarge {
    enabled: idTakeQuizView.interactive
    anchors.bottomMargin: 20
    anchors.bottom: parent.bottom
    anchors.right: parent.right
    anchors.rightMargin: 20
    source: "qrc:r.png"
    onClicked: {
      // bMoving = true
      idTakeQuizView.decIndex()
    }
  }

  ButtonQuizImgLarge {
    enabled: idTakeQuizView.interactive
    anchors.bottomMargin: 20
    anchors.bottom: parent.bottom
    anchors.left: parent.left
    anchors.leftMargin: 20
    source: "qrc:left.png"
    onClicked: {
      //bMoving = true
      idTakeQuizView.incIndex()
    }
  }
}
