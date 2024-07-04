#include "..\harbour-wordquiz\src\crosswordq.h"
#include "..\harbour-wordquiz\src\filehelpers.h"
#include "..\harbour-wordquiz\src\speechdownloader.h"
#include "..\harbour-wordquiz\src\svgdrawing.h"
#include <QDebug>
#include <QDir>
#include <QFile>
#include <QGuiApplication>
#include <QKeyEvent>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include <QQmlEngine>
#include <QQuickImageProvider>
#include <QStandardPaths>
#include <QWindow>
#include <QtCore/private/qandroidextras_p.h>
#include <QJniObject>

// elmal2024
// "sqlite3.exe .open
// c:/Users/fraxl/AppData/Local/glosquiz/QML/OfflineStorage/Databases/2db1346274c33ae632adc881bdcd2f8e.sqlite"

class LayoutSaver : public QObject
{
public:
  LayoutSaver(QWindow* p, const QString& sPath)
  {
    m_p = p;
    m_sPath = sPath ^ "WordQuiz.dat";
  }

  void aboutToQuit()
  {
    qDebug() << "end wordquiz";
#ifndef Q_OS_ANDROID
    QFile oGeometry(m_sPath);
    oGeometry.open(QIODevice::ReadWrite);
    QDataStream ss(&oGeometry);
    ss << m_p->geometry();
    oGeometry.close();
#endif
  }

  void LoadLast()
  {
#ifndef Q_OS_ANDROID
    QFile oGeometry(m_sPath);
    if (oGeometry.open(QIODevice::ReadOnly) == false)
    {
      return;
    }

    QDataStream ss(&oGeometry);
    QRect tGeometry;
    ss >> tGeometry;
    m_p->setGeometry(tGeometry);
#endif
  }

  QWindow* m_p;
  QString m_sPath;
};

class Engine : public QQmlApplicationEngine
{
public:
  Engine()
  {
    qmlRegisterType<SvgDrawing>("SvgDrawing", 1, 0, "SvgDrawing");

    m_p = new Speechdownloader(offlineStoragePath(), nullptr);
    rootContext()->setContextProperty("MyDownloader", m_p);
    rootContext()->setContextProperty("CrossWordQ", new CrossWordQ);

    connect(m_p, &Speechdownloader::downloadImage, m_p, &Speechdownloader::downloadImageSlot);
    connect(this, &Engine::objectCreated, [=](QObject* object, const QUrl&) {
      if (object != nullptr)
        object->installEventFilter(this);
    });
  }

  bool eventFilter(QObject*, QEvent* event) override
  {
    if (event->type() == QEvent::KeyPress)
    {
      QKeyEvent* keyEvent = static_cast<QKeyEvent*>(event);
      if (keyEvent->key() == Qt::Key_Back)
      {
        auto oo = rootObjects();
        auto o = oo.first();
        if (o->property("oPopDlg") != QVariant())
        {
          QMetaObject::invokeMethod(o, "onBackPressedDlg");
          return true;
        }
        else if (m_p->isStackEmpty() == false)
        {
          QMetaObject::invokeMethod(o, "onBackPressedTab");
          return true;
        }
        else if (m_p->isStackEmpty() == true)
          qDebug() << "StackEmpty ";
      }
    }
    return false;
  }
  Speechdownloader* m_p;
};

class DefImg : public QQuickImageProvider
{
public:
  DefImg() : QQuickImageProvider(QQuickImageProvider::Image) {}
  QImage requestImage(const QString&, QSize* size, const QSize&)
  {
    static QImage oImg(QStringLiteral(":/img.png"));
    *size = oImg.size();
    return oImg;
  }
};

int main(int argc, char* argv[])
{

  QGuiApplication app(argc, argv);

  Engine engine;
  engine.addImageProvider("theme", new DefImg());
  engine.load(QUrl(QStringLiteral("qrc:///qml/Main.qml")));

  // app.QGuiApplication::topLevelWindows().first();
  auto o = QGuiApplication::topLevelWindows();
  LayoutSaver oLS(o.first(), engine.offlineStoragePath());
  QObject::connect(&app, &QGuiApplication::aboutToQuit, &oLS, &LayoutSaver::aboutToQuit);

  qDebug() << "start wordquiz";

  app.setWindowIcon(QIcon("qrc:horn.png"));

  oLS.LoadLast();

#ifdef Q_OS_ANDROID

  auto oRunner = QNativeInterface::QAndroidApplication::runOnAndroidMainThread([&]() {
    QJniObject activity = QNativeInterface::QAndroidApplication::context();
    int const STREAM_MUSIC = 3;
    activity.callMethod<void>("setVolumeControlStream", "(I)V", STREAM_MUSIC);
  });

  oRunner.waitForFinished();

#endif
  return app.exec();
}
