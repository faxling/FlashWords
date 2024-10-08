import QtQuick

Rectangle
{
  function forceActiveFocus()
  {
    idTextInput.forceActiveFocus()
  }

  onVisibleChanged: {
    if (!visible)
      idMouse.forceActiveFocus()
  }
  MouseArea {
    id:idMouse
     anchors.fill: parent
     enabled: false
     cursorShape: Qt.BlankCursor
   }
  property alias echoMode : idTextInput.echoMode
  property string placeholderText
  Text
  {
    opacity: 0.5
    x: 5
    font.italic: true
    visible : displayText.length === 0 && !idTextInput.activeFocus
    font.pixelSize: nBtnHeight / 2.5
    text : placeholderText
  }
  property alias cursorVisible : idTextInput.cursorVisible
  property alias displayText : idTextInput.displayText
  property alias text : idTextInput.text
  color:"grey"
  width: parent.width -10
  x:5
  height:   nBtnHeight / 2
  TextInput
  {
    id:idTextInput 
   //  selectByMouse : true 
    anchors.leftMargin: 5
    font.pixelSize: nBtnHeight / 2.5
    anchors.fill: parent
  }
}
