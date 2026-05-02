import QtQuick
import QtQuick.Controls
import "qrc:QuizFunctions.js" as QuizLib

Flipable {
  id: flipable

  width: idTakeQuizView.width
  height: idRectTakeQuiz.height

  front: QuestionPanelRect {

    Image {
      id: idImageAllok
      visible: allOk1_3
      anchors.centerIn: parent
      source: "qrc:thumb.png"
    }

    TextMetrics {
      id: t_metrics
      font: idTextOneMoreTime.font
      text: idTextOneMoreTime.text + "XXX"
    }

    ButtonQuiz {
      id: idTextOneMoreTime
      visible: allOk1_3
      text: "One more time?"
      width: t_metrics.width
      anchors.horizontalCenter: parent.horizontalCenter
      anchors.top: idImageAllok.bottom
      anchors.topMargin: 20
      onClicked: {
        QuizLib.resetQuiz();
      }
    }

    Item {
      id: idFrontItem
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
          bTextMode = !bTextMode;
          if (bTextMode) {
            MyDownloader.focusOnQuizText(nQuizIndex1_3);
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
        bIsPushed: bImageMode
        source: "qrc:img.png"
        onClicked: bImageMode = !bImageMode
      }
      ButtonQuizImg {
        id: idCarBtn
        anchors.right: parent.right
        anchors.rightMargin: 20
        anchors.top: idImgBtn.bottom
        anchors.topMargin: 20
        bIsPushed: bCarMode
        source: "qrc:car.svg"
        onClicked: QuizLib.handleClickCarMode()
      }
      Slider {
        id: idCarSpeedSlider
        handle: Rectangle {
          x: idCarSpeedSlider.leftPadding + idCarSpeedSlider.visualPosition * (idCarSpeedSlider.availableWidth - width)
          y: idCarSpeedSlider.topPadding + idCarSpeedSlider.availableHeight / 2 - height / 2
          implicitWidth: 40
          implicitHeight: 40
          radius: 20
          color: idCarSpeedSlider.pressed ? "#f0f0f0" : "#f6f6f6"
          border.color: "#bdbebf"
        }
        stepSize: 1

        visible: bCarMode
        anchors.top: idImgBtn.bottom
        anchors.topMargin: 20
        anchors.right: idCarBtn.left
        anchors.left: parent.left
        onPressedChanged: {
          bCarModeSlider = pressed;
        }
        from: 3
        to: 10
        onValueChanged: QuizLib.handleCarSlider(value)
        // Trick to update 3 sliders from one value
        property int nCarModeSpeed2: nCarModeSpeed
        onNCarModeSpeed2Changed: value = nCarModeSpeed
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

        Component.onCompleted: MyDownloader.storeTextInputField(number, idTextEditYourAnswer)

        y: 50
        anchors.horizontalCenter: parent.horizontalCenter
        visible: bTextMode

        width: parent.width - 150
        placeholderText: "your answer"
        onDisplayTextChanged: {
          bTextAnswerOk = QuizLib.isAnswerOk(displayText, answer);
          if (bTextAnswerOk)
            QuizLib.setAnswerVisible();
        }
      }

      ButtonQuizImgLarge {
        anchors.right: parent.right
        anchors.rightMargin: 20
        y: idBtnAnswer.y + idQuizColumn.y
        source: "qrc:horn.png"
        onClicked: MyDownloader.playWord(question, bIsReverse ? sToLang : sFromLang)
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
          source: "qrc:flip.png"
          anchors.horizontalCenter: parent.horizontalCenter
          onClicked: {
            QuizLib.toggleAnswerVisible();
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
        source: "qrc:flip.png"
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
