import QtQuick
import QtQuick.Controls
import "../harbour-wordquiz/Qml/QuizFunctions.js" as QuizLib
import QtQuick.Window

Item {
  id: idRectTakeQuiz
  property bool bExtraInfoVisible: false
  property bool bTextMode: false
  property bool bTextAnswerOk: false
  property bool bImageMode: false
  property bool bVoiceMode: false
 //  property bool allok: idWindow.bAllok
  Component.onCompleted: {
    idWindow.oTakeQuiz = idRectTakeQuiz
  }
  function resetQuizView() {
    idView.currentIndex = 0
    idView.nLastIndex = 1
  }
  // May be the filler is calculated (PathLen - NoElem*sizeElem) /  (NoElem )
  Component {
    id: idQuestionComponent

    Rectangle {

      radius: 10
      width: idView.width
      height: idView.height - 20
      gradient: "NearMoon"

      ButtonQuizImg {
        id: idInfoBtn
        anchors.left: parent.left
        anchors.leftMargin: 20
        anchors.top: parent.top
        anchors.topMargin: 20
        source: "qrc:info.png"
        visible: extra.length > 0
        onClicked: bExtraInfoVisible = !bExtraInfoVisible
      }

      ButtonQuizImg {
        id: idTextBtn
        visible: !allOk1_3
        anchors.right: parent.right
        anchors.rightMargin: 20
        anchors.top: parent.top
        anchors.topMargin: 20
        source: "qrc:edit.png"
        bIsPushed: bTextMode
        onClicked: bTextMode = !bTextMode
      }
      ButtonQuizImg {
        id: idVoiceModeBtn
        visible: !allOk1_3
        anchors.left: parent.left
        anchors.leftMargin: 20
        anchors.top: idInfoBtn.bottom
        anchors.topMargin: 20
        bIsPushed: bVoiceMode
        source: "qrc:horn_small.png"
        onClicked: bVoiceMode = !bVoiceMode
      }

      ButtonQuizImg {
        id: idImgBtn
        visible: !allOk1_3
        anchors.right: parent.right
        anchors.rightMargin: 20
        anchors.top: idTextBtn.bottom
        anchors.topMargin: 20
        bIsPushed: bImageMode
        source: "qrc:img.png"
        onClicked: {
          bImageMode = !bImageMode
          idTextQuestion.forceLayout()
          idTextAnswer.forceLayout()
        }
        Rectangle {
          y: idImgBtn.height + 2
          width: idImgBtn.width
          height: 4
          color: "#009bff"
          visible: imgUrl !== sDEFAULT_IMG
        }
      }

      ButtonQuizImg {
        id: idSoundBtn
        visible: bTextAnswerOk && bTextMode && !allOk1_3
        anchors.right: parent.right
        anchors.rightMargin: 20
        anchors.top: idImgBtn.bottom
        anchors.topMargin: 20
        source: "qrc:horn_small.png"
        onClicked: MyDownloader.playWord(answer, sAnswerLang)
      }

      Text {
        id: idTextExtra
        anchors.left: idInfoBtn.right
        anchors.leftMargin: 20
        anchors.verticalCenter: idInfoBtn.verticalCenter
        visible: bExtraInfoVisible
        font.pointSize: 12
        text: extra
      }

      Image {
        anchors.left: parent.left
        anchors.leftMargin: 10
        anchors.top: idSoundBtn.bottom
        anchors.topMargin: 20
        visible: bTextAnswerOk && bTextMode && !allOk1_3
        source: "qrc:thumb_small.png"
      }

      InputTextQuiz {
        id: idTextEditYourAnswer
        enabled: !bTextAnswerOk
        Component.onCompleted: {
          MyDownloader.storeTextInputField(number, idTextEditYourAnswer)
        }
        y: 50
        z: 2
        anchors.horizontalCenter: parent.horizontalCenter
        visible: bTextMode && !allOk1_3
        width: parent.width - 150
        placeholderText: "your answer"
        onDisplayTextChanged: {
          bTextAnswerOk = QuizLib.isAnswerOk(displayText, answer)
        }
      }

      DropArea {
        anchors.fill: parent
        onDropped: {
          MyDownloader.downloadImage(drop.urls, question, sQuestionLang,
                                     answer, sAnswerLang)
        }
      }

      Column {
        id: idQuizColumn
        spacing: 20
        anchors.horizontalCenter: parent.horizontalCenter
        y: idWordImage.visible ? idInfoBtn.y : parent.height / 5
        visible: !allOk1_3

        Image {
          id: idWordImage
          cache: false
          height: idRectTakeQuiz.height / 3
          width: idRectTakeQuiz.height / 3
          fillMode: Image.PreserveAspectFit
          anchors.horizontalCenter: parent.horizontalCenter
          visible: !allOk1_3 && imgUrl !== sDEFAULT_IMG
                   && bImageMode
          source: imgUrl
        }

        Text {
          id: idTextQuestion
          horizontalAlignment: Text.AlignHCenter
          width: idView.width
          wrapMode: Text.WordWrap
          opacity: (bVoiceMode) ? 0 : 1
          font.pointSize: 30
          text: question
        }

        ButtonQuizImgLarge {
          height: nBtnHeight
          width: nBtnHeight
          anchors.horizontalCenter: parent.horizontalCenter
          source: "qrc:horn.png"
          onClicked: MyDownloader.playWord(question, sQuestionLang)
        }

        ButtonQuiz {
          id: idBtnAnswer
          width: n25BtnWidth
          anchors.horizontalCenter: parent.horizontalCenter
          text: "Show Answer"
          nButtonFontSize: 20
          onClicked: {
            answerVisible = !answerVisible
          }
        }

        Text {
          id: idTextAnswer
          horizontalAlignment: Text.AlignHCenter
          width: idView.width
          wrapMode: Text.WordWrap
          visible: answerVisible
          font.pointSize: 30
          text: answer
        }

        ButtonQuizImgLarge {
          anchors.horizontalCenter: parent.horizontalCenter
          visible: answerVisible
          source: "qrc:horn.png"
          onClicked: MyDownloader.playWord(answer, sAnswerLang)
        }
      }
      Image {
        id: idImageAllok
        visible: allOk1_3
        anchors.centerIn: parent
        source: "qrc:thumb.png"
      }

      ButtonQuiz {
        visible: allOk1_3
        text: "One more time?"
        width: nTextWidth + nTextWidth / 5
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: idImageAllok.bottom
        anchors.topMargin: 20
        nButtonFontSize: 20
        onClicked: {
          QuizLib.resetQuiz()
        }
      }

      ButtonQuizImgLarge {
        visible: !allOk1_3
        enabled: idView.interactive
        anchors.bottomMargin: 20
        anchors.bottom: parent.bottom
        anchors.right: parent.right
        anchors.rightMargin: 20
        source: "qrc:r.png"
        onClicked: {
          // bMoving = true
          idView.decIndex()
        }
      }
      ButtonQuizImgLarge {
        visible: !allOk1_3
        enabled: idView.interactive
        anchors.bottomMargin: 20
        anchors.bottom: parent.bottom
        anchors.left: parent.left
        anchors.leftMargin: 20
        source: "qrc:left.png"
        onClicked: {
          //bMoving = true
          idView.incIndex()
        }
      }
    }
  }

  Timer {
    id: idMoveTimer
    interval: 800
    repeat: false
    onTriggered: idView.movementEnded()
  }
  Keys.onLeftPressed: {
    // bMoving = true
    idView.incIndex()
  }

  Keys.onRightPressed: {
    idView.decIndex()
    // bMoving = true
  }
  Keys.onSpacePressed: {
    QuizLib.toggleAnswerVisible()
    //idQuizModel.get(nQuizIndex1_3).answerVisible = !idQuizModel.get(nQuizIndex1_3).answerVisible
  }

  Keys.onUpPressed: {
    MyDownloader.playWord(idQuizModel.get(nQuizIndex1_3).answer, sAnswerLang)
  }

  Keys.onDownPressed: {
    QuizLib.toggleAnswerVisible()
  }
  PathView {
    id: idView

    width: idRectTakeQuiz.width
    height: idRectTakeQuiz.height

    property int nLastIndex: 1

    function incIndex() {
      idMoveTimer.start()
      idView.incrementCurrentIndex()
    }

    function decIndex() {
      idMoveTimer.start()
      idView.decrementCurrentIndex()
    }

    interactive: ((glosModelWorking.count > 0 ) && (bTextAnswerOk || !bTextMode))

    highlightMoveDuration: 800

    onMovementEnded: {
      if (nLastIndex === currentIndex)
        return
      nLastIndex = currentIndex
      QuizLib.calcSwipeDirection(currentIndex)
      QuizLib.assigNextQuizWord()
    }

    clip: true
    model: idQuizModel
    delegate: idQuestionComponent
    snapMode: ListView.SnapOneItem
    path: Path {
      startX: -(idView.width / 2 + 100)
      startY: idView.height / 2
      PathLine {
        relativeX: idView.width * 3 + 300
        relativeY: 0
      }
    }
  }
}
