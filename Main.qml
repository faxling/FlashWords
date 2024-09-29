import QtQuick
import QtQuick.Window
import QtQuick.Controls.Basic
import QtQuick.Dialogs
import QtQuick.LocalStorage as Sql
import "qrc:QuizFunctions.js" as QuizLib
import "qrc:CrossWordFunctions.js" as CWLib
import QtWebView
import QtCore

Window {

  id: idWindow
  property int nLastIndexMain
  // init in initUrls
  property string sReqDictUrlBase
  property string sReqDictUrl
  property string sReqDictUrlRev
  property string sReqDictUrlEn
  property string sReqUrlBase
  property string sDEFAULT_IMG

  property string sReqUrl
  property string sReqUrlRev
  property string sReqUrlEn

  property variant oHang
  property variant db
  property string sLangLangSelected
  property string sLangLang
  property string sLangLangRev
  property string sToLang
  property string sFromLang
  property string sQuestionLang: bIsReverse ? sToLang : sFromLang
  property string sAnswerLang: bIsReverse ? sFromLang : sToLang
  property bool bIsReverse
  property bool bHasDictTo: sToLang === "ru" || sToLang === "en"
  property bool bHasDictFrom: sFromLang === "ru" || sFromLang === "en"
  property string sLangLangEn
  property string sQuizName: "-"
  property string sQuizDate: "-"
  property string sQuizDesc: "-"
  property string sImportDesc1 : "-"
  property string sImportDescDate : "-"
  property string sScoreText: "-"
  property string sWebViewTitle
  property int nDbNumber: 0
  // or 0-2
  property int nQuizIndex1_3: 1
  property int nLastQuizIndex1_3: -1
  property int nFontSize: 17
  property int nDlgHeight: idWindow.height / 5 + 80
  property int nDlgHeightLarge: idWindow.height / 2.5
  property int nBtnHeight: idWindow.height / 15
  property int n3BtnWidth: idTabMain.width / 3 - 8
  property int n4BtnWidth: idTabMain.width / 4 - 7
  property int n5BtnWidth: idTabMain.width / 6
  property int n25BtnWidth: idTabMain.width / 2.4 - 7
  property int n2BtnWidth: idTabMain.width / 2 - 10
  property int nMainWidth: idTabMain.width

  // 0 Question 1 Answer
  property int nQuizSortRole: 0
  property bool bDESC: true
  property string sQSort: nQuizSortRole === 0 ? "UPPER(quizword)" : "UPPER(answer)"
  property string sDESCASC: bDESC ? " DESC " : " ASC "

  property variant glosListView
  property variant quizListView
  property variant oTakeQuiz
  property variant oPopDlg
  property bool bAllok: false
  property bool bDownloadNotVisible: true
  property bool bCWBusy: false

  property var glosModelIndex
  // property int nGlosaDbLastIndex:  -1
  //  color: "#E5E7E9"
  property int nGlosaTakeQuizIndex: -1
  property int nLastIndexMainX: 0
  FontLoader {
    id: webFont
    source: "qrc:ITCKRIST.TTF"
  }
  property int nLastIndex

  function loadInView(sTitle, sUrl) {
    idWebEngineView.url = sUrl
    sWebViewTitle = sTitle
    // idWebEngineView.title = sTitle
    if (idSwipeView.currentIndex !== 5) {
      nLastIndex = idSwipeView.currentIndex
      idSwipeView.currentIndex = 5
    } else {
      idSwipeView.currentIndex = nLastIndex
    }
  }

  // Called from c++ event loop
  function onBackPressedTab() {

    var n = MyDownloader.popIndex()
    if (n < 0)
      return

    switch (n) {
    case 0:
      idTabMain.currentIndex = 0
      idSwipeView.currentIndex = 0
      break
    case 1:
      idTabMain.currentIndex = 1
      idSwipeView.currentIndex = 1
      break
    case 2:
      idTabMain.currentIndex = 2
      idSwipeView.currentIndex = 2
      break
    case 3:
      idTabMain.currentIndex = 2
      idSwipeView.currentIndex = 3
      break
    default:
      idTabMain.currentIndex = 2
      idSwipeView.currentIndex = 4
      break
    }
  }

  function onBackPressedDlg() {
    idWindow.oPopDlg.closeThisDlg()
  }

  onSScoreTextChanged: {

    db.transaction(function (tx) {
      tx.executeSql('UPDATE GlosaDbIndex SET state1=? WHERE dbnumber=?',
                    [sScoreText, nDbNumber])
      var i = MyDownloader.indexFromGlosNr(idGlosModelIndex, nDbNumber)
      idGlosModelIndex.setProperty(i, "state1", sScoreText)
    })
  }

  Settings {
    id: idSettings
    property string imgDir
  }

  ListModel {
    id: glosModel
  }

  ListModel {
    id: glosModelWorkingRev
  }

  ListModel {
    id: glosModelWorking
  }

  ListModel {
    id: idGlosModelIndex
  }

  ListModel {
    id: idLangModel
  }

  // Used by idTakeQuizView in TakeQuiz
  ListModel {
    id: idQuizModel
    property int bDir

    ListElement {
      number: 0
      numberDb: 0
      question: ""
      extra: ""
      imgUrl: ""
      answer: ""
      answerVisible: false
      allOk1_3: false
    }
    ListElement {
      number: 1
      numberDb: 0
      question: ""
      extra: ""
      answer: ""
      imgUrl: ""
      answerVisible: false
      allOk1_3: false
    }
    ListElement {
      number: 2
      numberDb: 0
      question: ""
      extra: ""
      answer: ""
      imgUrl: ""
      answerVisible: false
      allOk1_3: false
    }
  }

  width: 570
  height: 730
  visible: true
  Item {
    id: idMainTitle
    z: 3
    width: parent.width
    height: idBtnHelp.height
    TextList {
      id: idTitle
      font.italic: idGlosModelIndex.count === 0
     // y: idBtnHelp.y
      anchors.horizontalCenter: parent.horizontalCenter
     // verticalAlignment :Text.AlignTop
      text: {
        if (idSwipeView.currentIndex === 5)
          return sWebViewTitle

        if (idGlosModelIndex.count === 0)
          return "No Quiz create one or download"


        return sQuizName + " " + sFromLang + (bIsReverse ? "<-" : "->") + sToLang + " " + sScoreText
      }
    }

    ButtonQuizImg {
      id: idBtnBack
      visible: idSwipeView.currentIndex === 5
      anchors.right: idBtnHelp.left
      anchors.rightMargin: 5
      anchors.top: parent.top
      anchors.topMargin: 5
      source: "qrc:back.png"
      onClicked: {
        idWebEngineView.goBack()
      }
    }

    ButtonQuizImg {
      id: idBtnHelp
      anchors.right: parent.right
      anchors.rightMargin: 5
      anchors.top: parent.top
      anchors.topMargin: 5
      source: idSwipeView.currentIndex === 5 ? "qrc:quit.png" : "qrc:help.png"
      onClicked: {
        // Special tool to get html !
        loadInView("Instructions",
                   "https://htmlpreview.github.io/?https://github.com/faxling/FlashWords/blob/main/doc/doc.html")
      }

    }


    Rectangle {
      opacity: 0.5
      // visible: idWebEngineView.loading
      height: parent.height
      width: parent.width * ((idWebEngineView.loadProgress === 100 ? 0 : idWebEngineView.loadProgress )/ 100.0)
      color: "orange"
    }

  }


  /*
  TextList
  {
    text: sQuizName + " " + sLangLang + " " + sScoreText
    anchors.horizontalCenter: parent.horizontalCenter
  }
  */
  TabBar {
    id: idTabMain
    clip: true
    anchors.fill: parent
    anchors.leftMargin: 10
    anchors.rightMargin: 10
    //  anchors.bottomMargin: nBtnHeight / 2
    anchors.topMargin: idMainTitle.height + 10
    implicitWidth: 200
    contentHeight: idWindow.height / 20
    background: Item {}
    ButtonTab {
      id: control1
      text: "Home"
      onPressed: {
        checked = true
        idSwipeView.currentIndex = 0
      }
    }
    ButtonTab {
      id: control2
      text: "Edit"
      onPressed: {
        checked = true
        idSwipeView.currentIndex = 1
      }
    }
    ButtonTab {
      id: control3
      text: idComboBox.currentText
      contentItem: ComboBox {
        id: idComboBox

        delegate: ItemDelegate {
          width: idComboBox.width
          contentItem: Text {
            text: modelData
            // color: "#21be2b"
            font.pixelSize: control3.nFontPixSize
            verticalAlignment: Text.AlignVCenter
          }

          highlighted: idComboBox.highlightedIndex === index
        }
        background: Item {}
        contentItem: Item {
          Text {
            text: control3.text
            font.pixelSize: control3.nFontPixSize
            anchors.fill: parent
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            color: control3.checked ? "white" : "black"
          }
          MouseArea {
            anchors.fill: parent
            onPressed: {
              control3.checked = true
              idSwipeView.currentIndex = idComboBox.currentIndex + 2
            }
          }
        }

        onPressedChanged: {
          if (pressed) {
            control3.checked = true
            idSwipeView.currentIndex = idComboBox.currentIndex + 2
          }
        }
        onCurrentIndexChanged: idSwipeView.currentIndex = idComboBox.currentIndex + 2
        currentIndex: 0
        model: ["Flash Cards", "Hang Man", "Cross Word"]
      }

      onPressed: {
        // checked = true
        idSwipeView.currentIndex = idComboBox.currentIndex + 2
      }
    }
  }

  SwipeView {
    id: idSwipeView
    clip: true
    x: idTabMain.x
    y: idTabMain.y + idTabMain.contentHeight
    height: idTabMain.height - idTabMain.contentHeight
    width: idTabMain.width
    interactive: false

    CreateNewQuiz {
      id: idTab1
    }
    EditQuiz {
      id: idTab2
      enabled: idGlosModelIndex.count > 0 && bDownloadNotVisible
    }
    TakeQuiz {
      id: idTab3
    }
    HangMan {
      id: idTab4
      Component.onCompleted: {
        oHang = idTab4
      }
    }

    CrossWord {
      id: idTab5
    }

    WebView {
      id: idWebEngineView
      url: "https://htmlpreview.github.io/?https://github.com/faxling/FlashWords/blob/main/doc/doc.html"
    }


    onCurrentIndexChanged: {

      MyDownloader.pushIndex(nLastIndexMain)

      if (currentIndex === 3)
        oHang.newQ()
      else if (currentIndex === 2)
        idTab3.forceActiveFocus()
      else if (currentIndex === 4)
        idTab5.loadCW()
      else if (currentIndex === 1) {

        // Highlight the word currenly displayed on Quiz pane
        glosListView.currentIndex = idWindow.nGlosaTakeQuizIndex
        glosListView.positionViewAtIndex(idWindow.nGlosaTakeQuizIndex,
                                         ListView.Center)
      }

      nLastIndexMain = currentIndex
    }
  }
}
