import QtQuick
import QtQuick.Window
import QtQuick.Controls
import QtQuick.Dialogs
import QtCore
import "qrc:QuizFunctions.js" as QuizLib

Item {
  id: idEditQuiz
  property bool bDoLookUppText1: true

  Rectangle {
    anchors.fill: parent
    gradient: Gradient {
      GradientStop {
        position: 1.0
        color: "#93a5cf"
      }
      GradientStop {
        position: 0.0
        color: "#e4efe9"
      }
    }
  }

  property int nLastSearch: 0

  Column {
    id: idGlosListMainColumn
    spacing: 10
    anchors.topMargin: 20
    anchors.bottomMargin: 50
    anchors.fill: parent

    Row {

      Item {
        height: idTextInput.height
        width: idEditQuiz.width / 2

        TextListLarge {
          id: idTextTrans
          Component.onCompleted: MyDownloader.storeTransText(idTextTrans,
                                                             idErrorText,
                                                             idDicList)

          text: "-"
          onTextChanged: QuizLib.assignTextInputField(idTextTrans.text)
          onClick: {
            QuizLib.assignTextInputField(idTextTrans.text)
          }
        }

        ButtonQuizImg {
          id: idBtnClear
          anchors.right: parent.right
          anchors.rightMargin: 10
          height: nBtnHeight / 2
          width: nBtnHeight / 2
          source: "qrc:quit.png"
          onClicked: {
            idTextInput.text = "-"
            idTextInput.text = ""
          }
        }
      }
      Item {
        height: idTextInput.height
        width: idEditQuiz.width / 2

        ButtonQuizImg {
          id: idShiftBtn
          x: 10
          height: nBtnHeight / 2
          width: nBtnHeight / 2
          source: "qrc:lr_svg.svg"
          onClicked: {
            var sT = idTextInput.displayText
            idTextInput.text = idTextInput2.displayText
            idTextInput2.text = sT
          }
        }

        ButtonQuizImg {
          id: idBtnClear2
          anchors.right: parent.right
          anchors.rightMargin: 5
          height: nBtnHeight / 2
          width: nBtnHeight / 2
          source: "qrc:quit.png"

          onClicked: {
            idTextInput2.text = "-"
            idTextInput2.text = ""
          }
        }
      }
    }
    TextMetrics {
      id: t_metrics
      font: idTextTrans.font
      text: "-"
    }

    Row {
      id: idIextInputToDictRow
      spacing: 20
      x: 5
      InputTextQuiz {
        id: idTextInput
        cursorVisible: true
        onCursorVisibleChanged: {
          if (cursorVisible)
            bDoLookUppText1 = true
        }
        width: idEditQuiz.width / 2 - 15
        placeholderText: "text to translate"
      }

      InputTextQuiz {
        id: idTextInput2
        onCursorVisibleChanged: {
          if (cursorVisible)
            bDoLookUppText1 = false
        }
        width: idEditQuiz.width / 2 - 15
        placeholderText: "translation"
      }
    }

    Row {
      id: idDictBtnRow
      spacing: 9

      ButtonQuiz {
        id: idBtn1
        text: "Find " + sLangLang
        onClicked: {
          QuizLib.reqTranslation(idBtn1, false)
        }
      }

      ButtonQuiz {
        id: idBtn2
        text: "Find " + sLangLangRev
        onClicked: {
          QuizLib.reqTranslation(idBtn2, true)
        }
      }

      ButtonQuiz {
        id: idBtn3
        text: (bDoLookUppText1 ? sFromLang : sToLang) + " Wiktionary"
        onClicked: {
          QuizLib.lookUppInWiki()
        }
      }

      ButtonQuiz {
        text: "Add"
        onClicked: QuizLib.getTextInputAndAdd()
      }
    }
    TextList {
      id: idErrorText
      visible: false
      font.pointSize: 16
      color: "red"
      onClick: visible = false
    }

    TextList {
      id: idErrorText2
      visible: false
      font.pointSize: 16
      color: "red"
      onClick: visible = false
    }

    Row {
      id: idDictionaryResultRow
      height: t_metrics.boundingRect.height * 3
      width: parent.width - 100

      ListViewHi {
        id: idDicList
        width: parent.width / 2
        height: parent.height
        highlightFollowsCurrentItem: true

        delegate: Row {

          TextListLarge {
            id: idSearchItem
            width: idDicList.width
            text: modelData

            MouseArea {
              anchors.fill: parent
              onClicked: {
                idDicList.currentIndex = index
                var sText = idSearchItem.text
                QuizLib.assignTextInputField(sText)
                idSynListView.model = MyDownloader.synListFromWord(sText)
                idMeanListView.model = MyDownloader.meanListFromWord(sText)

                //idTrSynModel.query = "/DicResult/def/tr[" + (index + 1) + "]/syn"
                // idTrMeanModel.query = "/DicResult/def/tr[" + (index + 1) + "]/mean"
              }
            }
          }
        }
      }

      ListView {
        //model: idTrSynModel
        id: idSynListView
        width: parent.width / 3
        height: parent.height
        clip: true
        delegate: TextListLarge {
          id: idSynText
          text: modelData
          MouseArea {
            anchors.fill: parent
            onClicked: QuizLib.assignTextInputField(idSynText.text)
          }
        }
        ScrollBar.vertical: ScrollBar {}
      }
      ListView {
        id: idMeanListView
        // model: idTrMeanModel
        width: parent.width / 3
        height: parent.height
        clip: true
        delegate: TextListLarge {
          id: idMeanText
          text: modelData
        }
      }
    }

    //  height : idHeader1Text.height
    Row {
      x: 10
      id: idHeaderRow
      height: idHeader1Text.height
      TextList {
        id: idHeader1Text
        color: "steelblue"
        font.bold: nQuizSortRole === 0
        text: "Question"
        property bool bSortAsc: true
        onClick: {
          QuizLib.sortQuestionModel(0, this)
        }
      }

      TextList {
        id: idHeader2Text
        color: "steelblue"
        font.bold: nQuizSortRole === 1
        width: n25BtnWidth
        text: "Answer"
        property bool bSortAsc: true
        onClick: {
          QuizLib.sortQuestionModel(1, this)
        }
      }
    }

    ListViewHi {
      id: idGlosList
      x: 10
      width: idEditQuiz.width
      height: parent.height - idHeaderRow.y - nBtnHeight
      spacing: 3
      Component.onCompleted: {
        idWindow.glosListView = idGlosList
      }

      model: glosModel
      delegate: Row {
        property int nNumber: number
        id: idRowRow
        spacing: 5

        TextList {
          id: idQuestion
          width: (idGlosList.width / 2) - (idEditBtn.width * 1.5) - 20
          text: question
          color: state1 === 0 ? "black" : "green"
          onClick: {
            idTextInput.text = question + " "
            bDoLookUppText1 = true
          }
        }

        TextList {
          id: idAnswer
          onXChanged: idHeader1Text.width = x
          width: idQuestion.width
          text: answer
          font.bold: extra.length > 0
          color: state1 === 0 ? "black" : "green"
          onClick: {
            idTextInput2.text = answer + " "
            bDoLookUppText1 = false
          }
        }

        ButtonQuizImg {
          id: idEditBtn
          height: idAnswer.height
          width: idAnswer.height
          //    y:-5
          source: "qrc:edit.png"
          onClicked: {
            idEditDlg.visible = true
            idTextEdit1.text = question
            idTextEdit2.text = answer
            idTextEdit3.text = extra
            // idEditWordImage.visible = MyDownloader.hasImage(idTextEdit1.text,
            //                                                 sLangLang)
            idEditWordImage.source =  MyDownloader.imageSrc(
                                                                 idTextEdit1.text,
                                                                 sLangLang)
            idGlosState.checked = state1 !== 0
            idGlosList.currentIndex = index
          }
        }

        ButtonQuizImg {
          height: idAnswer.height
          width: idAnswer.height
          source: "qrc:horn.png"
          onClicked: MyDownloader.playWord(question, sFromLang)
        }

        ButtonQuizImg {
          height: idAnswer.height
          width: idAnswer.height
          source: "qrc:horn.png"
          onClicked: MyDownloader.playWord(answer, sToLang)
        }
      }
    }
  }

  Row {
    id: idLowerBtnRow
    x: 5
    anchors.bottom: parent.bottom
    anchors.bottomMargin: 10
    spacing: 10
    ButtonQuiz {
      width: n2BtnWidth
      text: "Reset"
      onClicked: {
        QuizLib.resetQuiz()
      }
    }

    ButtonQuiz {
      text: "Reverse"
      width: n2BtnWidth
      onClicked: {
        QuizLib.reverseQuiz()
      }
    }
  }

  RectRounded {
    id: idEditDlg
    visible: false
    width: parent.width
    height: nDlgHeight
    onCloseClicked: idEditDlg.visible = false

    Column {
      x: 20
      anchors.top: idEditDlg.bottomClose
      anchors.topMargin: 10
      spacing: 10
      Row {
        spacing: 20
        width: idEditDlg.width - 40
        height: idTextEdit3.height

        Label {
          color: "white"
          id: idAddInfo
          text: "Additional Info"
        }

        InputTextQuiz {
          id: idTextEdit3
          width: parent.width - idAddInfo.width - 20
        }
      }

      InputTextQuiz {
        id: idTextEdit1
        x: 0
        width: idEditDlg.width - parent.x * 2
      }

      InputTextQuiz {
        id: idTextEdit2
        x: 0
        width: idEditDlg.width - parent.x * 2
      }
    }

    Image {
      id: idEditWordImage
      cache: false
      fillMode: Image.PreserveAspectFit
      anchors.verticalCenter: idBtnUpdate.verticalCenter
      anchors.left: parent.left
      anchors.leftMargin: 5
      height: 64
      width: 64
    }
    Label {
      id: idGlosStateLabel
      anchors.verticalCenter: idBtnUpdate.verticalCenter
      anchors.left: idEditWordImage.right
      anchors.leftMargin: 20
      color: "white"
      text: "Done:"
    }

    CheckBox {
      id: idGlosState
      anchors.verticalCenter: idBtnUpdate.verticalCenter
      anchors.left: idGlosStateLabel.right
      anchors.rightMargin: 20
    }

    FolderDialog {
      id: folderDialog
      currentFolder: StandardPaths.standardLocations(
                       StandardPaths.DownloadLocation)[0]
      //    selectedFolder: idSettings.imgDir
      onSelectedFolderChanged: idSettings.imgDir = selectedFolder
    }

    FileDialog {
      id: fileDialog
      nameFilters: ["Images (* *.png *.jpg *.jpeg)"]
      Component.onCompleted: console.log(StandardPaths.standardLocations(
                                           StandardPaths.PicturesLocation))

      //  options: FileDialog.DontUseNativeDialog
      options: FileDialog.ReadOnly
      onCurrentFileChanged: {
        idEditWordImage.visible = true
        idEditWordImage.source = currentFile
        console.log("file image dialog " + currentFiles)
      }

      // "file:///storage/emulated/0/Download"
      currentFolder: idSettings.imgDir

      onCurrentFolderChanged: {
        idSettings.imgDir = currentFolder
      }
      acceptLabel: "Use this Image"
      rejectLabel: "Cancel"

      onAccepted: {

        MyDownloader.downloadImageSlot(currentFiles, idTextEdit1.text,
                                       sFromLang, idTextEdit2.text,
                                       sToLang, true)
      }
    }

    ButtonQuiz {
      id: idBtnImg
      width: n5BtnWidth
      anchors.bottom: parent.bottom
      anchors.bottomMargin: 5
      anchors.right: idBtnUpdate.left
      anchors.rightMargin: 20
      text: "Image"
      onClicked: {
        MyDownloader.requestPerm()

        //  folderDialog.open()
        fileDialog.open()

        /*
        MyImagePicker.pickImage(idTextEdit1.text, sFromLang,
                                idTextEdit2.text, sToLang)

                                */
      }
    }

    ButtonQuiz {
      id: idBtnUpdate
      width: n5BtnWidth
      anchors.bottom: parent.bottom
      anchors.bottomMargin: 5
      anchors.right: idBtnDelete.left
      anchors.rightMargin: 20
      text: "Update"
      onClicked: {
        QuizLib.updateQuiz()
        idGlosList.positionViewAtIndex(idGlosList.currentIndex, ListView.Center)
      }
    }
    ButtonQuiz {
      id: idBtnDelete
      anchors.bottom: parent.bottom
      anchors.bottomMargin: 5
      anchors.right: parent.right
      anchors.rightMargin: 20
      width: n5BtnWidth
      text: "Delete"
      onClicked: {
        QuizLib.deleteWordInQuiz()
      }
    }

    function imgDownloaded() {
      idEditWordImage.visible = true
      idEditWordImage.source = ""
      idEditWordImage.source = MyDownloader.imageSrc(idTextEdit1.text,
                                                     sFromLang)
    }

    DropArea {
      Component.onCompleted: {
        MyDownloader.downloadedImgSignal.connect(idEditDlg.imgDownloaded)
      }
      anchors.fill: parent
      onDropped: {
        MyDownloader.downloadImage(drop.urls, idTextEdit1.text, sFromLang,
                                   idTextEdit2.text, sToLang, true)
      }
    }
  }

  RectRounded {
    id: idImagePick
    visible: false
    color: "#303030"
    anchors.horizontalCenter: parent.horizontalCenter
    y: 40
    height: nDlgHeight / 2
    radius: 7
    width: parent.width / 2

    WhiteText {
      id: idWhiteText
      text: "Use Drag and Drop for images"
      x: 20
      // anchors.top: idImagePick.bottom
    }
    onCloseClicked: {
      idImagePick.visible = false
    }
  }
}
