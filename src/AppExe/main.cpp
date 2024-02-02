#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include <QFont>
#include <QDir>
#include <QStandardPaths>
#include <QResource>
#include <QDebug>

//#include <QMovie>

#include "Modules/SwupdateWrapper/SwupdateWrapper.h"
#include "Modules/FileDirUtils/FileDirUtils.h"
#include "Modules/ExitCodeCustom/ExitCodeCustom.h"
#include "Modules/TranslatorText/TranslatorText.h"
#include "Modules/DataLog/DataLogQmlApp.h"
#include "Modules/ResourceMonitorLog/ResourceMonitorLogQmlApp.h"
#include "Modules/AlarmLog/AlarmLogQmlApp.h"
#include "Modules/EventLog/EventLogQmlApp.h"
#include "Modules/ReplaceableCompRecord/ReplaceableCompRecordQmlApp.h"
#include "Modules/UserManage/UserManageQmlApp.h"
#include "Modules/BookingSchedule/BookingScheduleQmlApp.h"
//#include "Modules/FtpServer/SimpleFtpServer.h"
#include "Modules/BluetoothFileTransfer/BluetoothFileTransfer.h"
#include "Modules/UsbCopier/UsbCopier.h"
#include "Modules/JsToText/JstoText.h"
#include "Modules/TestReportPdfGenerator/TestReportPdfGenerator.h"
#include "Modules/ELSgenerator/ELSgenerator.h"
#include "Modules/ImportExternalResources/RegisterExternalResources.h"
#include "Modules/NetworkManager/NetworkManagerQmlApp.h"
//#include "Modules/ImportExternalConfiguration/ImportExternalConfiguration.h"
#include "Modules/FileReader/FileReader.h"
#include "Modules/SettingsData/SettingsData.h"

#include "UI/CusCom/KeyboardOnScreen/KeyboardOnScreenAdapter.h"
#include "UI/CusCom/KeyboardOnScreen/KeyboardOnScreenCaller.h"
#include "UI/CusCom/HeaderApp/HeaderAppAdapter.h"

#include "MachineProxy.h"
#include "MachineData.h"

//#define APP_NAME  "SBC101"
#define APP_DOMAIN  "com"
#define APP_ORG     "escolifesciences"
//#define APP_LNAME   "sbc101"

#define COMPATIBLE_FOR "LA2-G4:VA2-G4"

#ifdef __linux__

///Unix signals in Qt applications
///
#include <initializer_list>
#include <signal.h>
#include <unistd.h>

void ignoreUnixSignals(std::initializer_list<int> ignoreSignals) {
    // all these signals will be ignored.
    for (int sig : ignoreSignals)
        signal(sig, SIG_IGN);
}

void catchUnixSignals(std::initializer_list<int> quitSignals) {
    auto handler = [](int sig) -> void {
        // blocking and not aysnc-signal-safe func are valid
        printf("\nquit the application by signal(%d).\n", sig);
        QCoreApplication::quit();
    };

    sigset_t blocking_mask;
    sigemptyset(&blocking_mask);
    for (auto sig : quitSignals)
        sigaddset(&blocking_mask, sig);

    struct sigaction sa;
    sa.sa_handler = handler;
    sa.sa_mask    = blocking_mask;
    sa.sa_flags   = 0;

    for (auto sig : quitSignals)
        sigaction(sig, &sa, nullptr);
}

short readHardwareInformation(){
    QStringList sysInfo;
    QString sysInfoStr;
    const QString rpizw = "BCM2835"; // RPI Zero W
    const QString bpim2z = "Allwinner sun8i Family"; // BPI M2 Zero
    QString hardwareInfoStr;
    short hardwareInfo = 0;
    QProcess process;

    process.start("cat", QStringList()<<"/proc/cpuinfo");
    process.waitForFinished();
    //usleep(1000);
    QString output(process.readAllStandardOutput());
    //    qDebug()<<output;
    QString err(process.readAllStandardError());
    qDebug()<<err;

    sysInfoStr = output.remove(QRegularExpression("[\t]+"));
    sysInfo = sysInfoStr.split("\n", Qt::SkipEmptyParts);

    qDebug() << sysInfo;
    for(short i=0; i<sysInfo.length(); i++){
        if(sysInfo.at(i).contains("Hardware")){
            qDebug() << sysInfo << i << sysInfo.at(i);
            if(sysInfo.at(i).split(":").length() > 1){
                hardwareInfoStr = sysInfo.at(i).split(":").at(1);
                qDebug() << "hardwareInfoStr" << hardwareInfoStr;
                hardwareInfoStr.replace("/n", "");
                hardwareInfoStr = hardwareInfoStr.trimmed();
                qDebug() << "hardwareInfoStr" << hardwareInfoStr;
            }
        }
    }

    if(hardwareInfoStr == rpizw){
        hardwareInfo = MachineEnums::HardwareInfo_RPI_ZW;
    }
    else if(hardwareInfoStr == bpim2z){
        hardwareInfo = MachineEnums::HardwareInfo_BPI_M2_Z;
    }
    return hardwareInfo;
}

#endif
///

int main(int argc, char *argv[])
{
    QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);
    QCoreApplication::setAttribute(Qt::AA_Use96Dpi, true);
    //    QCoreApplication::setAttribute(Qt::AA_SynthesizeMouseForUnhandledTouchEvents, false);
#ifdef __linux__
    catchUnixSignals({SIGQUIT, SIGINT, SIGTERM, SIGHUP});
#endif

    QString build = QString(APP_BUILD).toInt() ? (QString(".%1").arg(QString(APP_BUILD))) : "";

    /// REGISTER APPLICATION IDENTITY
    QCoreApplication::setApplicationName(APP_NAME);
    QCoreApplication::setApplicationVersion(QString(APP_VERSION) + build);
    QCoreApplication::setOrganizationDomain(APP_DOMAIN);
    QCoreApplication::setOrganizationName(APP_ORG);

    /// ENSURE TARGET LOCATION IS EXIST
    /// TO STORE DATABASE
    QString dataPath = QStandardPaths::writableLocation(QStandardPaths::DataLocation);
    if(!QDir(dataPath).exists()){
        QDir().mkpath(dataPath);
    }

    /// CREATE ROOT QT APPLICATION INSTANCE
    QGuiApplication app(argc, argv);

    /// SET DEFAULT FONT
#ifdef __WIN32__
    QFont font("FreeSans");
#elif __linux__
    QFont font("Noto Sans");
#endif
    //    font.setStyleHint(QFont::Monospace);
    QGuiApplication::setFont(font);

    /// CREATE USER INTEFACE QML ENGINE
    QQmlApplicationEngine engine;

    /// PREPARE TRANSLATOR TEXT
    TranslatorText translatorText(&engine);

    engine.rootContext()->setContextProperty("TranslatorText", &translatorText);

    /// enable import of qml component by dot
    /// (with: import UI.CusCom 1.1 vs wihout: import "../../UI/CusCom")
    engine.addImportPath("qrc:/");

#ifdef __arm__
    /// Path for usb mounting
    engine.rootContext()->setContextProperty("MediaUSBStoragePath", "/tmp/media");
    /// Path for update software
    engine.rootContext()->setContextProperty("SWUpdatePath", "/data/update");
    engine.rootContext()->setContextProperty("HWRevisionPath", "/etc/hwrevision");
    engine.rootContext()->setContextProperty("SWRevisionPath", "/etc/swrevision");
#else
    QString path = QString(QDir::homePath() + "/dev/usbstorage").replace("C:", "c:"); /// Folder list model, generate drive letter with lower case
    engine.rootContext()->setContextProperty("MediaUSBStoragePath", path);
    engine.rootContext()->setContextProperty("SWUpdatePath", QDir::homePath() + "/dev/update");
    engine.rootContext()->setContextProperty("HWRevisionPath", QDir::homePath() + "/dev/etc/hwrevision");
    engine.rootContext()->setContextProperty("SWRevisionPath", QDir::homePath() + "/dev/etc/swrevision");
#endif

    qmlRegisterUncreatableType<ExitCodeCustom>("ModulesCpp.Utils", 1, 0, "ExitCode", "Cannot implemented ExitCode");
    qmlRegisterSingletonType<NetworkManagerQmlApp>("ModulesCpp.Connectify", 1, 0, "NetworkService", NetworkManagerQmlApp::singletonProvider);

    qmlRegisterType<FileDirUtils>("ModulesCpp.Utils", 1, 0, "FileDirUtils");
    qmlRegisterType<DataLogQmlApp>("DataLogQmlApp", 1, 0, "DataLogQmlApp");
    qmlRegisterType<AlarmLogQmlApp>("AlarmLogQmlApp", 1, 0, "AlarmLogQmlApp");
    qmlRegisterType<EventLogQmlApp>("EventLogQmlApp", 1, 0, "EventLogQmlApp");
    qmlRegisterType<ReplaceableCompRecordQmlApp>("ReplaceableCompRecordQmlApp", 1, 0, "ReplaceableCompRecordQmlApp");
    qmlRegisterType<ResourceMonitorLogQmlApp>("ResourceMonitorLogQmlApp", 1, 0, "ResourceMonitorLogQmlApp");
    qmlRegisterType<UserManageQmlApp>("UserManageQmlApp", 1, 0, "UserManageQmlApp");
    qmlRegisterType<BookingScheduleQmlApp>("BookingScheduleQmlApp", 1, 0, "BookingScheduleQmlApp");
    qmlRegisterType<UsbCopier>("ModulesCpp.UsbCopier", 1, 0, "USBCopier");
    qmlRegisterType<BluetoothFileTransfer>("ModulesCpp.BluetoothTransfer", 1, 0, "BluetoothTransfer");
    qmlRegisterType<JstoText>("ModulesCpp.JstoText", 1, 0, "JstoText");
    qmlRegisterType<TestReportPdfGenerator>("ModulesCpp.TestReportPdfGenerator", 1, 0, "TestReportPdfGenerator");
    qmlRegisterType<ELSgenerator>("ModulesCpp.ELSkeygen", 1, 0, "ELSkeygen");
    qmlRegisterType<RegisterExternalResources>("ModulesCpp.RegisterExternalResources", 1, 0, "RegisterExResources");
    qmlRegisterType<SwupdateWrapper>("ModulesCpp.Swupdate", 1, 0, "SWUpdate");
    //qmlRegisterType<ImportExternalConfiguration>("ModulesCpp.ImportExternalConfiguration", 1, 0, "ImportExternalConfiguration");
    qmlRegisterType<FileReader>("ModulesCpp.FileReader", 1, 0, "FileReader");

    qmlRegisterSingletonType<MachineProxy>("ModulesCpp.Machine", 1, 0, "MachineAPI", MachineProxy::singletonProvider);
    qmlRegisterSingletonType<MachineData>("ModulesCpp.Machine", 1, 0, "MachineData", MachineData::singletonProvider);
    qmlRegisterSingletonType<SettingsData>("ModulesCpp.Settings", 1, 0, "SettingsData", SettingsData::singletonProvider);

    qmlRegisterType<KeyboardOnScreenAdapter>("UI.CusCom.KeyboardOnScreen.Adapter", 1, 0, "KeyboardOnScreenAdapter");
    KeyboardOnScreenCaller keyboardOnScreenCaller;
    engine.rootContext()->setContextProperty("KeyboardOnScreenCaller", &keyboardOnScreenCaller);

    qmlRegisterSingletonType<HeaderAppAdapter>("UI.CusCom.HeaderApp.Adapter", 1, 0, "HeaderAppAdapter", HeaderAppAdapter::singletonProvider);

    QString osRevision;
    {
        QString osRevisionPath, swRevisionPath;

#ifdef __arm__
        osRevisionPath = "/usr/local/etc/osrevision";
#else
        osRevisionPath = QDir::homePath() + "/dev/etc/osrevision";
#endif
        qDebug() << "osRevisionPath" << osRevisionPath;

        QFile file;
        file.setFileName(osRevisionPath);
        if(file.open(QIODevice::ReadOnly)){
            osRevision = file.readLine().trimmed();
        }
        file.close();
    }
    engine.rootContext()->setContextProperty("OSRevision", osRevision);

#ifdef QT_RELEASE
    engine.rootContext()->setContextProperty("__release__", 1);
#else
    engine.rootContext()->setContextProperty("__release__", 0);
#endif

#ifdef __WIN32__
    engine.rootContext()->setContextProperty("__osplatform__", 0/*Windows*/);
    engine.rootContext()->setContextProperty("__hwInfo__", MachineEnums::HardwareInfo_Unknown);
#elif __linux__
    engine.rootContext()->setContextProperty("__osplatform__", 1/*Linux*/);
    short hwInfo = readHardwareInformation();
    engine.rootContext()->setContextProperty("__hwInfo__", hwInfo);
#endif

    /// CRATE VIEW ENGINE
    const QUrl url(QStringLiteral("qrc:/main.qml"));
    QObject::connect(&engine, &QQmlApplicationEngine::objectCreated,
                     &app, [url](QObject *obj, const QUrl &objUrl) {
        if (!obj && url == objUrl)
            QCoreApplication::exit(-1);
    }, Qt::QueuedConnection);
    engine.load(url);

    return app.exec();
}
