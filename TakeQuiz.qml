import QtQuick
import QtQuick.Controls
import "qrc:QuizFunctions.js" as QuizLib
import QtQuick.Window

Item {
  id: idRectTakeQuiz
  property bool bExtraInfoVisible: false
  property bool bTextMode: false
  property bool bImageMode: false
  property bool bVoiceMode: false
  property bool bTextAnswerOk: false

  Component.onCompleted: {
    idWindow.oTakeQuiz = idRectTakeQuiz
  }

  Timer {
    id: idMoveTimer
    interval: 800
    repeat: false
    onTriggered: idTakeQuizView.movementEnded()
  }
  Keys.onLeftPressed: {
    // bMoving = true
    idTakeQuizView.incIndex()
  }

  Keys.onRightPressed: {
    idTakeQuizView.decIndex()
    // bMoving = true
  }
  Keys.onSpacePressed: {
    QuizLib.toggleAnswerVisible()
    //idQuizModel.get(nQuizIndex1_3).answerVisible = !idQuizModel.get(nQuizIndex1_3).answerVisible
  }

  Keys.onUpPressed: {
    if (idQuizModel.get(nQuizIndex1_3).answerVisible)
      MyDownloader.playWord(idQuizModel.get(nQuizIndex1_3).answer, sAnswerLang)
    else
      MyDownloader.playWord(idQuizModel.get(nQuizIndex1_3).question,
                            sQuestionLang)
  }

  Keys.onDownPressed: {
    QuizLib.toggleAnswerVisible()
  }
  PathView {
    id: idTakeQuizView
    clip: true

    // Making it lock if bTextMode and not correct answer
    interactive: (!bTextMode || bTextAnswerOk || moving)
    width: idRectTakeQuiz.width
    height: idRectTakeQuiz.height

    property int nLastIndex: 1

    function incIndex() {
      idMoveTimer.start()
      idTakeQuizView.incrementCurrentIndex()
    }

    function decIndex() {
      idMoveTimer.start()
      idTakeQuizView.decrementCurrentIndex()
    }

    // interactive: ((glosModelWorking.count > 0 ) && (bTextAnswerOk || !bTextMode))
    highlightMoveDuration: 800

    onMovementEnded: {
      if (nLastIndex === currentIndex)
        return
      nLastIndex = currentIndex
      QuizLib.calcSwipeDirection(currentIndex)
      QuizLib.assigNextQuizWord()
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
