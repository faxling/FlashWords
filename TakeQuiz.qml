import QtQuick
import QtQuick.Controls
import "qrc:QuizFunctions.js" as QuizLib
import QtQuick.Window

Item {
  id: idRectTakeQuiz
  property bool bExtraInfoVisible: false
  property bool bTextMode: false
  property bool bImageMode: false
  property bool bCarMode: false
  property bool bCarModeSlider: false
  property real fCarModeSpeed1_10: 5.5
  property bool bVoiceMode: false
  property bool bTextAnswerOk: false

  Component.onCompleted: {
    idWindow.oTakeQuiz = idRectTakeQuiz;
  }

  Timer {
    id: idMoveTimer
    interval: 500
    repeat: false
    onTriggered: QuizLib.handleMovmentEnded()
  }

  Timer {
    id: idCarTimer
    interval: (10 - fCarModeSpeed1_10) * 900 + 2000
    repeat: true
    onTriggered: QuizLib.exeCarMode()
  }

  Keys.onLeftPressed: {
    if (bCarMode) {
      idCarTimer.stop();
    }

    QuizLib.incIndex();
  }

  Keys.onRightPressed: {
    if (bCarMode) {
      idCarTimer.stop();
    }

    QuizLib.decIndex();
  }
  Keys.onSpacePressed: {
    QuizLib.toggleAnswerVisible();
  }

  Keys.onUpPressed: {
    if (idQuizModel.get(nQuizIndex1_3).answerVisible)
      MyDownloader.playWord(idQuizModel.get(nQuizIndex1_3).answer, sAnswerLang);
    else
      MyDownloader.playWord(idQuizModel.get(nQuizIndex1_3).question, sQuestionLang);
  }

  Keys.onDownPressed: {
    QuizLib.toggleAnswerVisible();
  }
  PathView {
    id: idTakeQuizView
    clip: true

    // Making it lock if bTextMode and not correct answer
    interactive: (!bTextMode || bTextAnswerOk || moving) && (!bCarModeSlider)
    width: idRectTakeQuiz.width
    height: idRectTakeQuiz.height

    property int nLastIndex: 0

    highlightMoveDuration: 800
    onMovementStarted: {
      QuizLib.handleMovmentStarted();
    }
    onMovementEnded: {
      QuizLib.handleMovmentEnded();
    }

    model: idQuizModel
    delegate: QuestionPanel {}
    snapMode: ListView.SnapOneItem
    path: Path {
      startX: -(idTakeQuizView.width / 2 + 100)
      startY: idTakeQuizView.height / 2
      PathLine {
        relativeX: idTakeQuizView.width * 3 + 300
        relativeY: 0
      }
    }
  }
}
