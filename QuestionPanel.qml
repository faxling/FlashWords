import QtQuick 2.0
import "qrc:QuizFunctions.js" as QuizLib

Flipable {
  id: flipable

  width: idTakeQuizView.width
  height: idRectTakeQuiz.height

  front: QuestionPanelRect {

    Image {
      id:idImageAllok
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

    Item {
      id:idFrontItem
      visible: !allOk1_3
      anchors.fill: parent
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
        anchors.right: parent.right
        anchors.rightMargin: 20
        anchors.top: parent.top
        anchors.topMargin: 20
        bIsPushed: bTextMode
        source: "qrc:edit.png"
        onClicked: {
          bTextMode = !bTextMode
          if (bTextMode) {
            MyDownloader.focusOnQuizText(nQuizIndex1_3)
          }
        }
      }

      ButtonQuizImg {
        id: idVoiceModeBtn
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
        anchors.right: parent.right
        anchors.rightMargin: 20
        anchors.top: idTextBtn.bottom
        anchors.topMargin: 20
        source: "qrc:img.png"
        onClicked: bImageMode = !bImageMode
      }

      Text {
        id: idTextExtra
        font.pointSize: 12
        anchors.left: idInfoBtn.right
        anchors.leftMargin: 20
        anchors.verticalCenter: idInfoBtn.verticalCenter
        visible: bExtraInfoVisible
        text: extra
      }

      InputTextQuiz {
        id: idTextEditYourAnswer
        focus: true

        Component.onCompleted: MyDownloader.storeTextInputField(
                                 number, idTextEditYourAnswer)

        y: 50
        anchors.horizontalCenter: parent.horizontalCenter
        visible: bTextMode
        width: parent.width - 150
        placeholderText: "your answer"
        onDisplayTextChanged: {
          bTextAnswerOk = QuizLib.isAnswerOk(text, answer)
          if (bTextAnswerOk)
            QuizLib.setAnswerVisible()
        }
      }

      ButtonQuizImgLarge {
        anchors.right: parent.right
        anchors.rightMargin: 20
        y: idBtnAnswer.y + idQuizColumn.y
        source: "qrc:horn.png"
        onClicked: MyDownloader.playWord(question,
                                         bIsReverse ? sToLang : sFromLang)
      }

      Column {
        id: idQuizColumn
        visible: !allOk1_3
        spacing: 20
        anchors.horizontalCenter: parent.horizontalCenter
        y: parent.height / 4.5

        // && (idWindow.nQuizIndex === index)
        Image {
          id: idWordImage
          height: 350
          width: 500
          fillMode: Image.PreserveAspectFit
          anchors.horizontalCenter: parent.horizontalCenter
          visible: bImageMode && imgUrl !== sDEFAULT_IMG
          // && MyDownloader.hasImg
          source: imgUrl
        }

        Text {
          id: idTextQuestion
          width: idTakeQuizView.width
          opacity: bVoiceMode ? 0 : 1
          font.pointSize: 30
          font.bold: true
           horizontalAlignment: Text.AlignHCenter
          anchors.horizontalCenter: parent.horizontalCenter
          text: question
        }

        ButtonQuizImgLarge {
          id: idBtnAnswer
          focus: false
  //        fillMode: Image.Pad
          source:"qrc:flip.png"
          anchors.horizontalCenter: parent.horizontalCenter
          onClicked: {
            QuizLib.toggleAnswerVisible()
          }
        }
      }
    }
  }
  back: QuestionPanelRect {
    Column {
      visible: !allOk1_3
      y: parent.height / 4.5
      spacing: 20
      anchors.horizontalCenter: parent.horizontalCenter
      Text {
        id: idTextAnswer
        anchors.horizontalCenter: parent.horizontalCenter
        font.pointSize: 30
        font.bold: true
        horizontalAlignment: Text.AlignHCenter
        text: answer
      }

      ButtonQuizImgLarge {
        anchors.horizontalCenter: parent.horizontalCenter
        source:"qrc:flip.png"
        // text: "Show Answer"
        onClicked: QuizLib.toggleAnswerVisible()
      }

      ButtonQuizImgLarge {
        anchors.horizontalCenter: parent.horizontalCenter
        source: "qrc:horn.png"
        onClicked: MyDownloader.playWord(idTextAnswer.text, sAnswerLang)
      }
    }
  }

  transform: Rotation {
    id: rotation
    origin.x: flipable.width / 2
    origin.y: flipable.height / 2
    axis.x: 0
    axis.y: 1
    axis.z: 0 // set axis.y to 1 to rotate around y-axis
    angle: 0 // the default angle
  }

  states: State {
    name: "back"
    PropertyChanges {
      target: rotation
      angle: 180
    }
    when: answerVisible
  }

  transitions: Transition {
    NumberAnimation {
      target: rotation
      property: "angle"
      duration: 1000
    }
  }
}
