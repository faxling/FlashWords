
#include "..\harbour-wordquiz\src\filehelpers.h"
#include "..\harbour-wordquiz\src\speechdownloader.h"
#include <QtDebug>
#ifdef Q_OS_ANDROID
#include "imagepickerandroid.h"
/// #include <QtAndroid>
#include <QJniEnvironment>
#include <QJniObject>
// #include <QActivityResultReceiver>

ImagePickerAndroid::ImagePickerAndroid(Speechdownloader* pS)
{
  m_pS = pS;
}

void ImagePickerAndroid::pickImage(QString sWord, QString sLang, QString sWord2, QString sLang2)
{
  m_sWord = sWord;
  m_sLang = sLang;
  m_sWord2 = sWord2;
  m_sLang2 = sLang2;

  static const QString ALARM_PERMISSION{QStringLiteral("android.permission.READ_EXTERNAL_STORAGE")};

  QStringList permissions{ALARM_PERMISSION};
  qDebug() << "requestPermissions";

  auto oRes = QtAndroidPrivate::requestPermission(ALARM_PERMISSION);

  oRes.waitForFinished();
  if (oRes.result() != QtAndroidPrivate::Authorized)
    return;

  auto ACTION_PICK = QJniObject::getStaticObjectField("android/content/Intent", "ACTION_PICK",
                                                      "Ljava/lang/String;");

  auto EXTERNAL_CONTENT_URI = QJniObject::getStaticObjectField(
      "android/provider/MediaStore$Images$Media", "EXTERNAL_CONTENT_URI", "Landroid/net/Uri;");

  intent = QJniObject(
      "android/content/Intent", "(Ljava/lang/String;Landroid/net/Uri;)V",
      ACTION_PICK.object<jstring>(), EXTERNAL_CONTENT_URI.object<jobject>());

  if (ACTION_PICK.isValid() && intent.isValid())
  {
      intent.callObjectMethod("setType", "(Ljava/lang/String;)Landroid/content/Intent;",
                              QJniObject::fromString("image/*").object<jstring>());

      QtAndroidPrivate::startActivity(intent, 101);
  }



  /*
  auto permissionCallback = [](const QtAndroid::PermissionResultMap & permissionResult)
  {
      for(const auto &key : permissionResult.keys())
      {
          // Permission 0 = granted, 1 = denied
          qDebug() << "Permission:" << key << "granted?" <<
  !static_cast<bool>(permissionResult.value(key));
      }
  };


  auto permissionCallback = [&](const QtAndroid::PermissionResultMap& permissionResult) {
    for (auto& i : IterRange(permissionResult))
    {
      qDebug() << i.iter().key() << " Permission:"
               << (i.val() == QtAndroid::PermissionResult::Denied ? "denied" : "granted");
      if (i.val() == QtAndroid::PermissionResult::Granted)
      {
        QAndroidJniObject ACTION_PICK = QAndroidJniObject::getStaticObjectField(
            "android/content/Intent", "ACTION_PICK", "Ljava/lang/String;");

        QAndroidJniObject EXTERNAL_CONTENT_URI =
            QAndroidJniObject::getStaticObjectField("android/provider/MediaStore$Images$Media",
                                                    "EXTERNAL_CONTENT_URI", "Landroid/net/Uri;");

        QAndroidJniObject intent = QAndroidJniObject(
            "android/content/Intent", "(Ljava/lang/String;Landroid/net/Uri;)V",
            ACTION_PICK.object<jstring>(), EXTERNAL_CONTENT_URI.object<jobject>());

        if (ACTION_PICK.isValid() && intent.isValid())
        {
          intent.callObjectMethod("setType", "(Ljava/lang/String;)Landroid/content/Intent;",
                                  QAndroidJniObject::fromString("image/*").object<jstring>());
          QtAndroid::startActivity(intent.object<jobject>(), 101, this);
        }
      }
    }

  };
*/
}

void ImagePickerAndroid::handleActivityResult(int receiverRequestCode, int resultCode,
                                              const QJniObject& data)
{
  jint RESULT_OK = QJniObject::getStaticField<jint>("android/app/Activity", "RESULT_OK");
  if (receiverRequestCode == 101 && resultCode == RESULT_OK)
  {
    QJniObject uri = data.callObjectMethod("getData", "()Landroid/net/Uri;");
    QJniObject oAndroidMediaStore = QJniObject::getStaticObjectField(
        "android/provider/MediaStore$MediaColumns", "DATA", "Ljava/lang/String;");
    QJniEnvironment env;
    QString sMS = oAndroidMediaStore.toString();
    jobjectArray oJavaArray =
        (jobjectArray)env->NewObjectArray(1, env->FindClass("java/lang/String"), NULL);
    jobject projacaoDadosAndroid = env->NewString(sMS.utf16(), sMS.length());
    env->SetObjectArrayElement(oJavaArray, 0, projacaoDadosAndroid);
    QJniObject result;

    QJniObject activity = QNativeInterface::QAndroidApplication::context();
    QJniObject contentResolver =
        activity.callObjectMethod("getContentResolver", "()Landroid/content/ContentResolver;");
    QJniObject cursor = contentResolver.callObjectMethod(
        "query",
        "(Landroid/net/Uri;[Ljava/lang/String;Ljava/lang/String;[Ljava/lang/String;Ljava/lang/"
        "String;)Landroid/database/Cursor;",
        uri.object<jobject>(), oJavaArray, NULL, NULL, NULL);

    jint columnIndex = cursor.callMethod<jint>("getColumnIndex", "(Ljava/lang/String;)I",
                                               oAndroidMediaStore.object<jstring>());

    cursor.callMethod<jboolean>("moveToFirst", "()Z");

    result = cursor.callObjectMethod("getString", "(I)Ljava/lang/String;", columnIndex);
/*
    auto oRunner = QNativeInterface::QAndroidApplication::runOnAndroidMainThread([&]() {
      QJniObject activity = QNativeInterface::QAndroidApplication::context();
      QJniObject contentResolver =
          activity.callObjectMethod("getContentResolver", "()Landroid/content/ContentResolver;");
      QJniObject cursor = contentResolver.callObjectMethod(
          "query",
          "(Landroid/net/Uri;[Ljava/lang/String;Ljava/lang/String;[Ljava/lang/String;Ljava/lang/"
          "String;)Landroid/database/Cursor;",
          uri.object<jobject>(), oJavaArray, NULL, NULL, NULL);

      jint columnIndex = cursor.callMethod<jint>("getColumnIndex", "(Ljava/lang/String;)I",
                                                 oAndroidMediaStore.object<jstring>());

      cursor.callMethod<jboolean>("moveToFirst", "()Z");

      result = cursor.callObjectMethod("getString", "(I)Ljava/lang/String;", columnIndex);
    });

    oRunner.waitForFinished();
*/
    QList<QUrl> oc;
    QString s = result.toString();
    oc.append(QUrl::fromLocalFile(s));
    emit m_pS->downloadImage(oc, m_sWord, m_sLang, m_sWord2, m_sLang2, true);
  }
  else
  {
    qDebug() << "downloadImage error";
  }
}
#endif
