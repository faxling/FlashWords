import QtQuick
import QtQuick.Controls

ListView
{
  id:idListView
  clip:true
  highlightMoveDuration :500
  highlight: Rectangle {
    opacity:0.5
    color: "#009bff"
  }
  ScrollBar.vertical: ScrollBar {}
}
