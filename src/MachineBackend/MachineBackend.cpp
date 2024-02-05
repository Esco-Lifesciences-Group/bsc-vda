#include <QSerialPortInfo>
#include <QSerialPort>
#include <QTimer>
#include <QSettings>
#include <QThread>
#include <QProcess>
#include <QtConcurrent/QtConcurrent>
#include "QtNetwork/QNetworkInterface"
#include <QJsonObject>
#include <QJsonArray>

#include <QTcpSocket>
#include <QModbusTcpServer>
#include <QHostAddress>
#include "Implementations/Modbus/QModbusTcpConnObserverImp.h"

#include "MachineBackend.h"

#include "MachineData.h"
//#include "MachineEnums.h"
#include "MachineDefaultParameters.h"

#include "BoardIO/Drivers/QGpioSysfs/QGpioSysfs.h"
#include "BoardIO/Drivers/BlowerRegalECM/BlowerRegalECM.h"
#include "BoardIO/Drivers/RTCpcf8523/RTCpcf8523.h"
#include "BoardIO/Drivers/LEDpca9633/LEDpca9633.h"
#include "BoardIO/Drivers/AImcp3422x/AIManage.h"
#include "BoardIO/Drivers/PWMpca9685/PWMpca9685.h"
#include "BoardIO/Drivers/DIOpca9674/DIOpca9674.h"
#include "BoardIO/Drivers/AOmcp4725/AOmcp4725.h"
#include "BoardIO/Drivers/i2c/I2CPort.h"
#include "BoardIO/BoardIO.h"
#include "BoardIO/Drivers/SensirionSPD8xx/SensirionSPD8xx.h"
#include "BoardIO/Drivers/ParticleCounterZH03B/ParticleCounterZH03B.h"

#include "Implementations/BlowerRbm/BlowerRbmDsi.h"
#include "Implementations/DeviceAnalogCom/DeviceAnalogCom.h"
#include "Implementations/SashWindow/SashWindow.h"
#include "Implementations/DigitalOut/DeviceDigitalOut.h"
#include "Implementations/HydraulicOnRelay/HydraulicOnRelay.h"
#include "Implementations/AirflowVelocity/AirflowVelocity.h"
#include "Implementations/Temperature/Temperature.h"
#include "Implementations/PressureDiff/PressureDiff.h"
#include "Implementations/ParticleCounter/ParticleCounter.h"

#include "Implementations/DataLog/DataLogSql.h"
#include "Implementations/DataLog/DataLog.h"

#include "Implementations/AlarmLog/AlarmLogSql.h"
#include "Implementations/AlarmLog/AlarmLog.h"
#include "Implementations/AlarmLog/AlarmLogEnum.h"
#include "Implementations/AlarmLog/AlarmLogText.h"

#include "Implementations/EventLog/EventLogSql.h"
#include "Implementations/EventLog/EventLog.h"
#include "Implementations/EventLog/EventLogText.h"
#include "Implementations/ReplaceableCompRecord/ReplaceableCompRecord.h"
#include "Implementations/ReplaceableCompRecord/ReplaceableCompRecordSql.h"

#include "Implementations/ResourceMonitorLog/ResourceMonitorLogSql.h"
#include "Implementations/ResourceMonitorLog/ResourceMonitorLog.h"
#include "Implementations/BookingSchedule/BookingSchedule.h"
#include "Implementations/BookingSchedule/BookingScheduleSql.h"

#include "Implementations/SchedulerDayOutput/SchedulerDayOutput.h"
#include "Implementations/Modbus/QModbusTcpAddressEnum.h"

#include "Implementations/CheckSWUpdate/CheckSWUpdate.h"
#include "Implementations/USBAutoMount/USBAutoMount.h"

/// MODBUS REGISTER
struct modbusRegisterAddress
{
    struct OperationMode     {static const short addr = Addrs::OperationMode;       short rw = 0;} OperationMode;
    struct SashState         {static const short addr = Addrs::SashState;           short rw = 0;} SashState;
    struct FanState          {static const short addr = Addrs::FanState;            short rw = 0;} FanState;
    struct IfaFanState       {static const short addr = Addrs::IfaFanState;         short rw = 0;} IfaFanState;
    struct IfaFanDutyCycle   {static const short addr = Addrs::IfaFanDutyCycle;     short rw = 0;} IfaFanDutyCycle;
    struct IfaFanRpm         {static const short addr = Addrs::IfaFanRpm;           short rw = 0;} IfaFanRpm;
    struct IfaFanUsage       {static const short addr = Addrs::IfaFanUsage;         short rw = 0;} IfaFanUsage;
    struct LightState        {static const short addr = Addrs::LightState;          short rw = 0;} LightState;
    struct LightIntensity    {static const short addr = Addrs::LightIntensity;      short rw = 0;} LightIntensity;
    struct SocketState       {static const short addr = Addrs::SocketState;         short rw = 0;} SocketState;
    struct GasState          {static const short addr = Addrs::GasState;            short rw = 0;} GasState;
    struct UvState           {static const short addr = Addrs::UvState;             short rw = 0;} UvState;
    struct UvLifeLeft        {static const short addr = Addrs::UvLifeLeft;          short rw = 0;} UvLifeLeft;
    struct FilterLife        {static const short addr = Addrs::FilterLife;          short rw = 0;} FilterLife;

    struct SashMotorizeState {static const short addr = Addrs::SashMotorizeState;   short rw = 0;} SashMotorizeState;//Spare
    struct SashCycle         {static const short addr = Addrs::SashCycle;           short rw = 0;} SashCycle;//Spare
    struct MeaUnit           {static const short addr = Addrs::MeaUnit;             short rw = 0;} MeaUnit;
    struct Temperature       {static const short addr = Addrs::Temperature;         short rw = 0;} Temperature;
    struct AirflowInflow     {static const short addr = Addrs::AirflowInflow;       short rw = 0;} AirflowInflow;
    struct AirflowDownflow   {static const short addr = Addrs::AirflowDownflow;     short rw = 0;} AirflowDownflow;
    struct PressureExhaust   {static const short addr = Addrs::PressureExhaust;     short rw = 0;} PressureExhaust;//Spare
    struct AlarmSash         {static const short addr = Addrs::AlarmSash;           short rw = 0;} AlarmSash;
    struct AlarmInflowLow    {static const short addr = Addrs::AlarmInflowLow;      short rw = 0;} AlarmInflowLow;
    struct AlarmInflowHigh   {static const short addr = Addrs::AlarmInflowHigh;     short rw = 0;} AlarmInflowHigh;//Spare
    struct AlarmDownflowLow  {static const short addr = Addrs::AlarmDownflowLow;    short rw = 0;} AlarmDownflowLow;//Spare
    struct AlarmDownflowHigh {static const short addr = Addrs::AlarmDownflowHigh;   short rw = 0;} AlarmDownflowHigh;//Spare
    struct AlarmExhaustLow   {static const short addr = Addrs::AlarmExhaustLow;     short rw = 0;} AlarmExhaustLow;//Spare
    struct AlarmFlapExhaust  {static const short addr = Addrs::AlarmFlapExhaust;    short rw = 0;} AlarmFlapExhaust;//Spare
    struct AlarmBoardCom     {static const short addr = Addrs::AlarmBoardCom;       short rw = 0;} AlarmBoardCom;
    struct AlarmTempLow      {static const short addr = Addrs::AlarmTempLow;        short rw = 0;} AlarmTempLow;
    struct AlarmTempHigh     {static const short addr = Addrs::AlarmTempHigh;       short rw = 0;} AlarmTempHigh;
    struct AlarmSashCycleMotorLocked {static const short addr = Addrs::AlarmSashCycleMotorLocked;  short rw = 0; } AlarmSashCycleMotorLocked;//Spare
    struct AlarmStbFanOff     {static const short addr = Addrs::AlarmStbFanOff;     short rw = 0; } AlarmStbFanOff;
    /// Not used
    struct FanClosedLoopControl{static const short addr = Addrs::FanClosedLoopControl;  short rw = 0; /*uint16_t value;*/} FanClosedLoopControl;
} modbusRegisterAddress;

#define MODBUS_REGISTER_COUNT   Addrs::Total
#define ALLOW_ANY_IP            "0.0.0.0"
#define LOCALHOST_ONLY          "127.0.0.1"

MachineBackend::MachineBackend(QObject *parent) : QObject(parent)
{
}

MachineBackend::~MachineBackend()
{
    //    qDebug() << metaObject()->className() << __FUNCTION__<< thread();
}

void MachineBackend::routineTask()
{
    int value = pData->getMachineBackendState();
    switch (value) {
    case MachineEnums::MACHINE_STATE_SETUP:
        setup();
        break;
    case MachineEnums::MACHINE_STATE_LOOP:
        loop();
        break;
    case MachineEnums::MACHINE_STATE_STOP:
        deallocate();
        break;
    default:
        break;
    }//
}//

void MachineBackend::setup()
{
    qDebug() << metaObject()->className() << __FUNCTION__ << thread();

    /// initial
    pData->setHasStopped(false);

    /// Permanent settings storage
    //    m_settings.reset(new QSettings);
    //    qDebug() << m_settings->fileName();
    QScopedPointer<QSettings> m_settings(new QSettings);

    /// FAN SPEED CONTROLLER BOARD
    {
        short fanSpeedController = static_cast<short>(m_settings->value(SKEY_FAN_SPEED_CONTROLLER_BOARD,
                                                                        MachineEnums::FanSpeedController_RBM).toInt());
        pData->setFanSpeedControllerBoard(fanSpeedController);
    }//

    /// Language
    {
        QString language = m_settings->value(SKEY_LANGUAGE, "en#0#English").toString();
        pData->setLanguage(language);
        m_langCode = language.split('#')[0];


        m_translator.reset(new QTranslator);
        /*qDebug() << "Load succeed" <<*/
        m_translator->load(QString(":/i18n/translations_%1.qm").arg(m_langCode));

        QObject::connect(pData, &MachineData::languageChanged,
                         this, [&](const QString &value){
                             m_langCode = value.split('#')[0];
                             if(m_langCode == "en"){
                                 m_translator.reset(new QTranslator);
                             }else{
                                 m_translator.reset(new QTranslator);
                                 m_translator->load(QString(":/i18n/translations_%1.qm").arg(m_langCode));
                             }
                         });
    }//

    //qDebug() << _getTr(_TR(EVENT_STR_POWER_ON));

    /// USB Auto Mount
    {
        m_pUSBAutoMount.reset(new USBAutoMount);

        QObject::connect(m_pUSBAutoMount.data(), &USBAutoMount::usbDetectedListChanged,
                         this, [&](const QString &usbList){
                             //qDebug() << "USB List Changed " << usbList;
                             pData->setUsbDetectedList(usbList);

                             if(usbList != ""){
                                 QStringList nameList = usbList.split(",", Qt::SplitBehaviorFlags::SkipEmptyParts);
                                 pData->setLastUsbDetectedName(nameList[nameList.length() - 1]);
                             }
                             else pData->setLastUsbDetectedName("");
                         });

        QObject::connect(m_pUSBAutoMount.data(), &USBAutoMount::usbHasMounted,
                         this, [&](const QString &name){
                             //qDebug() << "USB Has Mounted " << name;
                             //pData->setLastUsbDetectedName(name);

                             emit pData->usbHasMounted(name);
                         });

        QObject::connect(m_pUSBAutoMount.data(), &USBAutoMount::usbHasEjected,
                         this, [&](const QString &name){
                             //qDebug() << "USB Has Ejected " << name;
                             emit pData->usbHasEjected(name);
                         });

        /// TIMER
        m_timerEventForUSBAutoMount.reset(new QTimer);
        m_timerEventForUSBAutoMount->setInterval(5000);

        QObject::connect(m_timerEventForUSBAutoMount.data(), &QTimer::timeout,
                         m_pUSBAutoMount.data(), [&](){
                             //qDebug() << "Check USB List";
                             m_pUSBAutoMount->routineTask();
                         });

        /// THREAD
        m_threadForUSBAutoMount.reset(new QThread);

        QObject::connect(m_threadForUSBAutoMount.data(), &QThread::started,
                         m_timerEventForUSBAutoMount.data(), [&](){
                             m_timerEventForUSBAutoMount->start();
                         });
        QObject::connect(m_threadForUSBAutoMount.data(), &QThread::finished,
                         m_timerEventForUSBAutoMount.data(), [&](){
                             m_timerEventForUSBAutoMount->stop();
                         });

        QObject::connect(this, &MachineBackend::loopStarted,
                         [&](){
                             m_threadForUSBAutoMount->start();
                         });

        /// move the object to extra thread, so every query will execute in the separated thread
        m_pUSBAutoMount->moveToThread(m_threadForUSBAutoMount.data());
        m_timerEventForUSBAutoMount->moveToThread(m_threadForUSBAutoMount.data());
    }//

    /// Read App Software version
    QString newAppName = (QFileInfo(QCoreApplication::applicationFilePath()).fileName()).replace(".exe", "");
    newAppName = newAppName.toUpper();
    qDebug() << "&&&&!!!!!" << newAppName;

    QString  appNameVersion = m_settings->value(SKEY_SBC_SOFTWARE_VERSION, "none").toString();
    if(appNameVersion == "none"){
        m_settings->setValue(SKEY_SBC_SOFTWARE_VERSION, newAppName);
    }
    if(appNameVersion != newAppName){
        m_settings->setValue(SKEY_SBC_SOFTWARE_VERSION, newAppName);
        appNameVersion = newAppName;
        ///event log
        qWarning() << QObject::tr("Software has been updated to") + QString(" %1").arg(newAppName);
        //_insertEventLog(QString(EVENT_STR_APP_UPDATED) + QString(" %1").arg(newAppName));
    }

    {
        bool extDbEn = m_settings->value(SKEY_RP_EXT_DB_ENABLE, false).toBool();
        pData->setRpExtDatabaseEnable(extDbEn);
    }//

    /// CHECK FOR SOFTWARE UPDATE
    {
        QString targetDir = QStandardPaths::writableLocation(QStandardPaths::AppLocalDataLocation);
        qDebug() << targetDir;
        QString targetLocation = targetDir + QString("/swupdate/");

        bool  swuAvailable = m_settings->value(SKEY_SBC_SWU_AVAILABLE, false).toBool();
        QString  swu = m_settings->value(SKEY_SBC_SWU_VERSION, appNameVersion.replace(" ", "")).toString();
        QString  path = m_settings->value(SKEY_SBC_SWU_PATH, targetLocation + swu + ".swu").toString();
        bool checkEn = m_settings->value(SKEY_SBC_SVN_UPDATE_EN, false).toBool(); //Enable manually from Software Update Page
        int checkPeriod = m_settings->value(SKEY_SBC_SVN_UPDATE_PRD, 1).toInt();

        pData->setSvnUpdateAvailable(swuAvailable);
        pData->setSvnUpdateSwuVersion(swu);
        pData->setSvnUpdatePath(path);
        pData->setSvnUpdateCheckForUpdateEnable(checkEn);
        pData->setSvnUpdateCheckForUpdatePeriod(checkPeriod);

        m_pCheckSwUpdate.reset(new CheckSWUpdate);
        m_pCheckSwUpdate->setCheckForSWUpdateEnable(checkEn);
        m_pCheckSwUpdate->setCurrentSoftwareVersion(appNameVersion);
        m_pCheckSwUpdate->setProductionLine(CheckSWUpdate::ProductionLine::One);
        /// Initialize history file
        m_pCheckSwUpdate->initSoftwareHistoryUrl();
        pData->setSvnUpdateHistory(m_pCheckSwUpdate->getSwUpdateHistory(checkEn));

        QObject::connect(m_pCheckSwUpdate.data(), &CheckSWUpdate::swUpdateAvailable,
                         this, [&](const QString &swu, const QString &path, QJsonObject history){
                             _setSoftwareUpdateAvailable(swu, path, history);
                         });
        QObject::connect(m_pCheckSwUpdate.data(), &CheckSWUpdate::swUpdateAvailableReset,
                         this, [&](){
                             _setSoftwareUpdateAvailableReset();
                         });
        QObject::connect(pData, &MachineData::svnUpdateCheckForUpdateEnableChanged,
                         m_pCheckSwUpdate.data(), &CheckSWUpdate::setCheckForSWUpdateEnable);

        /// Initialize the ext rp database
        QObject::connect(m_pCheckSwUpdate.data(), &CheckSWUpdate::rpExtDatabaseObtained,
                         this, [&](QJsonObject value){
                             pData->setRpExtDatabase(value);
                             emit pData->rpExtDatabaseChanged();
                         });
        QObject::connect(m_pCheckSwUpdate.data(), &CheckSWUpdate::rpExtDefaultObtained,
                         this, [&](QJsonObject value){
                             pData->setRpExtDefault(value);
                             emit pData->rpExtDefaultChanged();
                         });

        m_pCheckSwUpdate->getRpExtDatabase();
        m_pCheckSwUpdate->getRpExtDefault();

        /// TIMER
        m_timerEventForCheckSwUpdate.reset(new QTimer);
        m_timerEventForCheckSwUpdate->setInterval(checkPeriod * 60000);
        ///
        QObject::connect(m_timerEventForCheckSwUpdate.data(), &QTimer::timeout,
                         m_pCheckSwUpdate.data(), [&](){
                             if(!m_pCheckSwUpdate->getProcessRunning()){
                                 m_pCheckSwUpdate->routineTask();
                             }//
                         });

        /// THREAD
        m_threadForCheckSwUpdate.reset(new QThread);

        //
        QObject::connect(m_threadForCheckSwUpdate.data(), &QThread::started,
                         this, [&](){
                             if(pData->getSvnUpdateCheckForUpdateEnable()){
                                 QMetaObject::invokeMethod(m_timerEventForCheckSwUpdate.data(), [&](){
                                         m_timerEventForCheckSwUpdate->start();
                                     },
                                     Qt::QueuedConnection);
                             }
                         });
        QObject::connect(m_threadForCheckSwUpdate.data(), &QThread::finished,
                         m_timerEventForCheckSwUpdate.data(), [&](){
                             m_timerEventForCheckSwUpdate->stop();
                         });

        QObject::connect(this, &MachineBackend::loopStarted,
                         [&](){
                             m_threadForCheckSwUpdate->start();
                         });

        /// move the object to extra thread, so every query will execute in the separated thread
        m_pCheckSwUpdate->moveToThread(m_threadForCheckSwUpdate.data());
        m_timerEventForCheckSwUpdate->moveToThread(m_threadForCheckSwUpdate.data());
    }//


    /// READ SERIAL NUMBER
    {
        QString serialNumber = m_settings->value(SKEY_SBC_SERIAL_NUMBER, SDEF_SBC_SERIAL_NUMBER).toString();
        pData->setSbcSerialNumber(serialNumber);

        if(serialNumber == SDEF_SBC_SERIAL_NUMBER){
            serialNumber = _readSbcSerialNumber();
            _setSbcSerialNumber(serialNumber);
            pData->setSbcCurrentSerialNumber(serialNumber);
            pData->setSbcCurrentSerialNumberKnown(true);
        }else{
            pData->setSbcCurrentSerialNumber(_readSbcSerialNumber());
            if(serialNumber == pData->getSbcCurrentSerialNumber())
                pData->setSbcCurrentSerialNumberKnown(true);
            else
                pData->setSbcCurrentSerialNumberKnown(false);
        }
        //pData->setSbcCurrentSerialNumberKnown(false);
    }
    /// READ SYSTEM INFORMATION
    {
        QStringList sysInfoDefault = (QStringList() << SDEF_SBC_SYS_INFO);
        QStringList sysInfo = m_settings->value(SKEY_SBC_SYS_INFO, sysInfoDefault).toStringList();
        pData->setSbcSystemInformation(sysInfo);
        //        qDebug() << "------ SysInfo ------";
        //        qDebug() << sysInfo;

        if(sysInfo == sysInfoDefault){
            sysInfo = _readSbcSystemInformation();
            _setSbcSystemInformation(sysInfo);
            _setSbcCurrentSystemInformation(sysInfo);
        }else{
            sysInfo = _readSbcSystemInformation();
            _setSbcCurrentSystemInformation(sysInfo);
        }
    }
    {
        _setHardwareInformation(pData->getSbcCurrentSystemInformation());
    }

    ////GPIO Buzzer
    {
        short buzzerGpioPin = ((pData->getHardwareInformation() == MachineEnums::HardwareInfo_BPI_M2_Z) ? 0     /// IO-27 (CON2-P13 PA0-EINT0)
                                                                                                        : 27);  /// GPIO-20
        m_pBuzzer.reset(new QGpioSysfs);
        m_pBuzzer->setup(buzzerGpioPin);
    }

    /// TimeZone
    {
        QString tz = m_settings->value(SKEY_TZ, "Asia/Jakarta#7#UTC+07:00").toString();
        pData->setTimeZone(tz);

        //        QElapsedTimer elapsed;
        //        elapsed.start();

        QString location = tz.split("#").first();
        _setTimeZoneLinux(location);

        /// 12h or 24h
        int timeClockPeriod = m_settings->value(SKEY_CLOCK_PERIOD, 12).toInt();
        pData->setTimeClockPeriod(static_cast<short>(timeClockPeriod));

        //qDebug () << timeClockPeriod;
        //qDebug() << __func__ << elapsed.elapsed() << "ms";
    }//

    /// BoardIO
    {
        /// Board IO use i2c port for communication
        /// setup i2c port
        m_i2cPort.reset(new I2CPort);
        /// define which i2c port number want to use
        /// ESCO OS Y313 has allocated i2cport number 4 for board communication
        short portNumber = ((pData->getHardwareInformation() == MachineEnums::HardwareInfo_BPI_M2_Z) ? 1
                                                                                                     : 4);
        m_i2cPort->setPortNumber(portNumber);
        m_i2cPort->openPort();

        /// Initializing every required board
        {
            /// IO EXTENDER
            {
                m_boardCtpIO.reset(new LEDpca9633);
                m_boardCtpIO->setI2C(m_i2cPort.data());
                bool response = m_boardCtpIO->init();

                pData->setBoardStatusCtpIoe(!response);

                ///Pin 0 - PWM0 connect to LCD Brightness Control
                m_boardCtpIO->setOutputAsPWM(LEDpca9633_CHANNEL_BL);
                /// Pin 1 (active low) - PWM1 connect to Mosfet to controll watchdog gate (NPN)
                /// Now we need disabled first the pin because watchdown don't ready yet
                /// Disconnect watchdog bridge
                m_boardCtpIO->setOutputAsDigital(LEDpca9633_CHANNEL_WDG, MachineEnums::DIG_STATE_ONE);
                //// connect watchdog brigde, just for your information
                //m_boardCtpIO->setOutputAsDigital(LEDpca9633_CHANNEL_WDG, MachineEnums::DIG_STATE_ZERO);

                /// catch error status of the board
                QObject::connect(m_boardCtpIO.data(), &LEDpca9633::errorComToleranceReached,
                                 this, [&](int error){
                                     qDebug() << "LEDpca9633::errorComToleranceReached" << error << thread();
                                     pData->setBoardStatusCtpIoe(false);
                                 });
                QObject::connect(m_boardCtpIO.data(), &LEDpca9633::errorComToleranceCleared,
                                 this, [&](int error){
                                     qDebug() << "LEDpca9633::errorComToleranceCleared" << error << thread();
                                     pData->setBoardStatusCtpIoe(true);
                                 });
            }//

            //// RTC
            {
                m_boardCtpRTC.reset(new RTCpcf8523);
                m_boardCtpRTC->setI2C(m_i2cPort.data());
                //check status osilation of second
                short response = static_cast<short>(m_boardCtpRTC->init());

                pData->setBoardStatusCtpRtc(!response);
#ifdef __arm__

                /// get time from RTC then set to Linux system
                /// Then Linux system time will count indepedenlty affect from NTP
                int wday = 0, day = 0, month = 0, year = 0, hour = 0, minute = 0, second = 0;
                response = m_boardCtpRTC->getDateTime(wday, day, month, year, hour, minute, second);
                if(response != 0) qWarning() << metaObject()->className() << __func__ << "m_boardCtpRTC fail";

                pData->setBoardStatusCtpRtc(!response);

                qDebug() << metaObject()->className() << __func__ <<"RTC: "<< wday << "-" << day <<  "-" << month << year << hour << ":" << minute <<  ":" << second;

                /// set to linux system, it's require with following format
                /// 2015-11-20 15:58:30
                QString dateTimeFormat = QString().asprintf("%d-%02d-%02d %02d:%02d:%02d", year, month, day, hour, minute, second);
                qDebug() << metaObject()->className() << __func__ << "dateTimeFormat" << dateTimeFormat;
                QDateTime dateValidation = QDateTime::fromString(dateTimeFormat, "yyyy-MM-dd hh:mm:ss");
                if(response == 0) {
                    if(dateValidation.isValid()){
                        qDebug() << metaObject()->className() << __func__
                                 << "DateTimeRTC is valid! set linux system based on RTC" << dateTimeFormat;
                        _setDateTimeLinux(dateTimeFormat);
                    }
                    else {
                        QDateTime dateTimeLinux = QDateTime::currentDateTime();
                        qDebug() << metaObject()->className() << __func__
                                 << "DateTimeRTC is invalid! Force update time based on linux" << dateTimeLinux.toString("yyyy-MM-dd hh:mm:ss");
                        /// if RTC time not valid, set to 2000-01-01 00:00:00
                        m_boardCtpRTC->setDateTime(dateTimeLinux.date().weekNumber(),
                                                   dateTimeLinux.date().day(),
                                                   dateTimeLinux.date().month(),
                                                   dateTimeLinux.date().year(),
                                                   dateTimeLinux.time().hour(),
                                                   dateTimeLinux.time().minute(),
                                                   dateTimeLinux.time().second());
                    }
                }
#endif

                //DEFINE_GPIO_FOR_WATCHDOG_GATE
                {
#ifdef __arm__

                    /// SET_RTC_TIMER_AS_WATCHDOG
                    m_boardCtpRTC->setClearInterrupt();
                    m_boardCtpRTC->setClockOutCtrl(PCF8523_CLOCKOUT_CTRL_DISABLED);
                    m_boardCtpRTC->setTimerFreqCtrl(PCF8523_TIMER_SOURCE_FREQ_S);
                    m_boardCtpRTC->setTimerAModeInterrupt(PCF8523_TIMER_MODE_INT_PULSE);
                    m_boardCtpRTC->setTimerAInteruptEnable(MachineEnums::DIG_STATE_ONE);
#endif

                    ////EVENT TIMER TO RESET WATCHDOG COUNTER MONITOR
                    m_timerEventForRTCWatchdogCountMonitor.reset(new QTimer);
                    m_timerEventForRTCWatchdogCountMonitor->setInterval(TIMER_INTERVAL_5_SECOND);
                    connect(m_timerEventForRTCWatchdogCountMonitor.data(), &QTimer::timeout, this,
                            [&](){
#ifdef __arm__
                                if(pData->getWatchdogCounter() < 30){
                                    _insertEventLog(_tr(EVENT_STR_WATCHDOG_RESTART_FAIL) + QString(" (RTC: %1 - %2)").arg(pData->getBoardStatusCtpRtc() ? "1" : "0").arg(pData->getWatchdogCounter()));
                                    /// Write Direct Mode if Fail with Queue
                                    m_boardCtpRTC->setTimerACount(SDEF_WATCHDOG_PERIOD, I2CPort::I2C_SEND_MODE_QUEUE);
                                }else{
                                    _insertEventLog(_tr(EVENT_STR_WATCHDOG_RESTART_OK));
                                    //m_timerEventForRTCWatchdogCountMonitor->stop();
                                }
#endif
                            });

                    ////EVENT TIMER TO RESET WATCHDOG COUNTER
                    m_timerEventForRTCWatchdogReset.reset(new QTimer);
                    m_timerEventForRTCWatchdogReset->setInterval(TIMER_INTERVAL_30_SECOND);
                    connect(m_timerEventForRTCWatchdogReset.data(), &QTimer::timeout, this,
                            [&](){
#ifdef __arm__
                                m_boardCtpRTC->setTimerACount(SDEF_WATCHDOG_PERIOD, I2CPort::I2C_SEND_MODE_QUEUE);
                                m_timerEventForRTCWatchdogCountMonitor->start();
#endif
                            });
#ifdef __arm__
                    m_boardCtpRTC->setTimerAMode(PCF8523_TIMER_A_MODE_WATCHDOG, I2CPort::I2C_SEND_MODE_DIRECT);
                    m_boardCtpRTC->setTimerACount(SDEF_WATCHDOG_PERIOD, I2CPort::I2C_SEND_MODE_DIRECT);
#endif
                }

                /// catch error status of the board
                QObject::connect(m_boardCtpRTC.data(), &RTCpcf8523::errorComToleranceReached,
                                 this, [&](int error){
                                     qDebug() << "RTCpcf8523::errorComToleranceReached" << error << thread();
                                     pData->setBoardStatusCtpRtc(false);
                                 });
                QObject::connect(m_boardCtpRTC.data(), &RTCpcf8523::errorComToleranceCleared,
                                 this, [&](int error){
                                     qDebug() << "RTCpcf8523::errorComToleranceCleared" << error << thread();
                                     pData->setBoardStatusCtpRtc(true);
                                 });
            }

            //            abort();

            /// DIGITAL_INPUT
            {
                m_boardDigitalInput1.reset(new DIOpca9674);
                m_boardDigitalInput1->setI2C(m_i2cPort.data());

                bool response = m_boardDigitalInput1->init();
                m_boardDigitalInput1->polling();

                pData->setBoardStatusHybridDigitalInput(!response);

                /// catch error status of the board
                QObject::connect(m_boardDigitalInput1.data(), &DIOpca9674::errorComToleranceReached,
                                 this, [&](int error){
                                     qDebug() << "DIOpca9674::errorComToleranceReached" << error << thread();
                                     pData->setBoardStatusHybridDigitalInput(false);
                                 });
                QObject::connect(m_boardDigitalInput1.data(), &DIOpca9674::errorComToleranceCleared,
                                 this, [&](int error){
                                     qDebug() << "DIOpca9674::errorComToleranceCleared" << error << thread();
                                     pData->setBoardStatusHybridDigitalInput(true);
                                 });
            }//

            ////DIGITAL_OUTPUT/PWM
            {
                m_boardRelay1.reset(new PWMpca9685);
                m_boardRelay1->setI2C(m_i2cPort.data());
                m_boardRelay1->preInitCountChannelsToPool(8);
                m_boardRelay1->preInitFrequency(PCA9685_PWM_VAL_FREQ_100HZ);

                bool response = m_boardRelay1->init();
                m_boardRelay1->polling();
                /// Switch Off All Output
                m_boardRelay1->initState(8);

                pData->setBoardStatusHybridDigitalRelay(!response);

                ////MONITORING COMMUNICATION STATUS
                QObject::connect(m_boardRelay1.data(), &PWMpca9685::errorComToleranceReached,
                                 this, [&](int error){
                                     qDebug() << "m_boardRelay1::errorComToleranceReached" << error << thread();
                                     pData->setBoardStatusHybridDigitalRelay(false);
                                 });
                QObject::connect(m_boardRelay1.data(), &PWMpca9685::errorComToleranceCleared,
                                 this, [&](int error){
                                     qDebug() << "m_boardRelay1::errorComToleranceCleared" << error << thread();
                                     pData->setBoardStatusHybridDigitalRelay(true);
                                 });
            }//

            /// Analog Input
            {
                m_boardAnalogInput1.reset(new AIManage);
                m_boardAnalogInput1->setupAIModule();
                m_boardAnalogInput1->setI2C(m_i2cPort.data());
                m_boardAnalogInput1->setAddress(0x69);

                bool response = m_boardAnalogInput1->init();
                m_boardAnalogInput1->polling();

                pData->setBoardStatusHybridAnalogInput(!response);

                int sensorConst = m_settings->value(SKEY_IFA_SENSOR_CONST, 0).toInt();

                //DEFINE_CHANNEL_FOR_TEMPERATURE
                m_boardAnalogInput1->setChannelDoPoll(0, true);
                m_boardAnalogInput1->setChannelDoAverage(0, true);
                if(!sensorConst)
                    m_boardAnalogInput1->setChannelSamples(0, 30);
                else
                    m_boardAnalogInput1->setChannelSamples(0, 50);

                //DEFINE_CHANNEL_FOR_AIRFLOW
                m_boardAnalogInput1->setChannelDoPoll(1, true);
                m_boardAnalogInput1->setChannelDoAverage(1, true);

                if(!sensorConst)
                    m_boardAnalogInput1->setChannelSamples(1, 35);
                else
                    m_boardAnalogInput1->setChannelSamples(1, 100);

                ////MONITORING COMMUNICATION STATUS
                QObject::connect(m_boardAnalogInput1.data(), &AIManage::errorComToleranceReached,
                                 this, [&](int error){
                                     qDebug() << "m_boardAnalogInput1::errorComToleranceReached" << error << thread();
                                     pData->setBoardStatusHybridAnalogInput(false);
                                 });
                QObject::connect(m_boardAnalogInput1.data(), &AIManage::errorComToleranceCleared,
                                 this, [&](int error){
                                     qDebug() << "m_boardAnalogInput1::errorComToleranceCleared" << error << thread();
                                     pData->setBoardStatusHybridAnalogInput(true);
                                 });

                QObject::connect(pData, &MachineData::inflowSensorConstantChanged,
                                 this, [&](short value){
                                     if(!value){
                                         m_boardAnalogInput1->setChannelSamples(0, 30);
                                         m_boardAnalogInput1->setChannelSamples(1, 35);
                                     }else{
                                         m_boardAnalogInput1->setChannelSamples(0, 50);
                                         m_boardAnalogInput1->setChannelSamples(1, 100);
                                     }
                                 });
            }//

            /// Aanalog Out Board
            {
                m_boardAnalogOutput1.reset(new AOmcp4725);
                m_boardAnalogOutput1->setI2C(m_i2cPort.data());
                m_boardAnalogOutput1->setAddress(0x60);

                bool response = m_boardAnalogOutput1->init();
                m_boardAnalogOutput1->polling();

                pData->setBoardStatusHybridAnalogOutput(!response);

                /// catch error status of the board
                QObject::connect(m_boardAnalogOutput1.data(), &AOmcp4725::errorComToleranceReached,
                                 this, [&](int error){
                                     qDebug() << "AOmcp4725::errorComToleranceReached" << error << thread();
                                     pData->setBoardStatusHybridAnalogOutput(false);
                                 });
                QObject::connect(m_boardAnalogOutput1.data(), &AOmcp4725::errorComToleranceCleared,
                                 this, [&](int error){
                                     qDebug() << "AOmcp4725::errorComToleranceCleared" << error << thread();
                                     pData->setBoardStatusHybridAnalogOutput(true);
                                 });
            }//

            /// SEAS BOARD FLAP INTEGRATED
            {
                short installed = static_cast<short>(m_settings->value(SKEY_SEAS_BOARD_FLAP_INSTALLED, MachineEnums::DIG_STATE_ZERO).toInt());
                //installed = 1;
                pData->setSeasFlapInstalled(installed);
            }

            /// EXHAUST_PRESSURE_DIFF_SENSIRION_SPD8xx
            /// SEAS INTEGRATED
            {
                short installed = static_cast<short>(m_settings->value(SKEY_SEAS_INSTALLED, MachineEnums::DIG_STATE_ZERO).toInt());
                //installed = 1;
                pData->setSeasInstalled(installed);

                m_boardSensirionSPD8xx.reset(new SensirionSPD8xx);
                m_boardSensirionSPD8xx->setI2C(m_i2cPort.data());

                //        //CABINET TYPE B IS MANDATORY TO INSTALL EXHAUST PRESSURE SENSOR
                //        //THE PRESSURE RANGE TO BE MONITORING IS IN RANGE BETWEEN 0 TO 500 Pa
                //        //TYPICALLY FAIL POINT IS AT 200 Pa
                //        m_pSensirionSPD8xxExhaust->setSensorRangeType(SensirionSPD8xx::SPD_RANGE_TYPE_500Pa);
                //
                //CABINET TYPE A IS OPTIONAL TO INSTALL EXHAUST PRESSURE SENSOR
                //THE PRESSURE RANGE TO BE MONITORING IS IN RANGE BETWEEN -125 TO 125 Pa
                //TYPICALLY FAIL POINT IS AT -3 Pa
                m_boardSensirionSPD8xx->setSensorRangeType(SensirionSPD8xx::SPD_RANGE_TYPE_125Pa);

                /// MONITORING COMMUNICATION STATUS
                /// catch error status of the board
                QObject::connect(m_boardSensirionSPD8xx.data(), &SensirionSPD8xx::errorComToleranceReached,
                                 this, [&](int error){
                                     qDebug() << "SensirionSPD8xx::errorComToleranceReached" << error << thread();
                                     pData->setBoardStatusPressureDiff(false);
                                 });
                QObject::connect(m_boardSensirionSPD8xx.data(), &SensirionSPD8xx::errorComToleranceCleared,
                                 this, [&](int error){
                                     qDebug() << "SensirionSPD8xx::errorComToleranceCleared" << error << thread();
                                     pData->setBoardStatusPressureDiff(true);
                                 });

                if (installed) {
                    bool response = m_boardSensirionSPD8xx->init();
                    m_boardSensirionSPD8xx->polling();

                    pData->setBoardStatusPressureDiff(!response);

                    m_boardSensirionSPD8xx->setDataSampleMaxPressurePa(50);
                    m_boardSensirionSPD8xx->readDiffPressure();
                    int pressure = m_boardSensirionSPD8xx->diffPressurePa();
                    //            pressure = 5;//PLEASE REMOVE AFTER DEBUGGING
                    pData->setSeasPressureDiffPa(pressure);
                }
            }
        }//

        /// Required object to manage communication
        /// communication will use daisy chain mechanism
        /// in one port i2c will connect to many board
        /// will use short poling mechanism to synchronization the states between machine logic and actual board
        m_boardIO.reset(new BoardIO);
        m_boardIO->setI2C(m_i2cPort.data());
        /// add any board for short polling
        {
            m_boardIO->addSlave(m_boardDigitalInput1.data());
            m_boardIO->addSlave(m_boardRelay1.data());
            m_boardIO->addSlave(m_boardAnalogInput1.data());
            m_boardIO->addSlave(m_boardAnalogOutput1.data());
            if(pData->getSeasInstalled()){
                m_boardIO->addSlave(m_boardSensirionSPD8xx.data());
            }
            m_boardIO->addSlave(m_boardCtpIO.data());
            m_boardIO->addSlave(m_boardCtpRTC.data());
        }
        /// setup thread and timer interupt for board IO
        {
            /// create timer for triggering the loop (routine task) and execute any pending request
            /// routine task and any pending task will executed by FIFO mechanism
            m_timerEventForBoardIO.reset(new QTimer);
            m_timerEventForBoardIO->setInterval(TEI_FOR_BOARD_IO);

            /// create independent thread
            /// looping inside this thread will run parallel* beside machineState loop
            m_threadForBoardIO.reset(new QThread);

            /// Start timer event when thread was started
            QObject::connect(m_threadForBoardIO.data(), &QThread::started,
                             m_timerEventForBoardIO.data(), [&](){
                                 //                qDebug() << "m_timerInterruptForBoardIO::started" << thread();
                                 m_timerEventForBoardIO->start();
                             });

            /// Stop timer event when thread was finished
            QObject::connect(m_threadForBoardIO.data(), &QThread::finished,
                             m_timerEventForBoardIO.data(), [&](){
                                 //qDebug() << "m_timerInterruptForBoardIO::finished" << thread();
                                 m_timerEventForBoardIO->stop();
                             });

            /// Enable triggerOnStarted, calling the worker of FanRbmDsi when thread has started
            /// This is use lambda function, this symbol [&] for pass m_boardIO object
            QObject::connect(m_threadForBoardIO.data(), &QThread::started,
                             m_boardIO.data(), [&](){
                                 //qDebug() << "m_boardIO::started" << thread();
                                 m_boardIO->routineTask();
                             });

            /// Call routine task fan (syncronazation value)
            /// This method calling by timerEvent
            QObject::connect(m_timerEventForBoardIO.data(), &QTimer::timeout,
                             m_boardIO.data(), [&](){
                                 //                qDebug() << "m_boardIO::timeout" << thread();
                                 m_boardIO->routineTask();
                             });

            /// Run loop thread when Machine State goes to looping / routine task
            QObject::connect(this, &MachineBackend::loopStarted,
                             m_threadForBoardIO.data(), [&](){
                                 //                qDebug() << "m_threadForBoardIO::loopStarted" << thread();
                                 m_threadForBoardIO->start();
                             });

            /// Do move fan routine task / looping to independent thread
            m_boardIO->moveToThread(m_threadForBoardIO.data());
            /// Do move timer event for fan routine task to independent thread
            /// make the timer has prescission because independent from this Macine State looping
            m_timerEventForBoardIO->moveToThread(m_threadForBoardIO.data());
        }//
    }//

    /// MODBUS
    {
        QString allowedIP = m_settings->value(SKEY_MODBUS_ALLOW_IP, LOCALHOST_ONLY).toString();
        pData->setModbusAllowIpMaster(allowedIP);

        short slaveID = static_cast<short>(m_settings->value(SKEY_MODBUS_SLAVE_ID, 1).toInt());
        pData->setModbusSlaveID(slaveID);

        enum {REG_RO, REG_RW};
        modbusRegisterAddress.FanState.rw       = static_cast<short>(m_settings->value(SKEY_MODBUS_RW_FAN, REG_RO).toInt());
        modbusRegisterAddress.LightState.rw     = static_cast<short>(m_settings->value(SKEY_MODBUS_RW_LAMP, REG_RO).toInt());
        modbusRegisterAddress.LightIntensity.rw = static_cast<short>(m_settings->value(SKEY_MODBUS_RW_LAMP_DIMM, REG_RO).toInt());
        modbusRegisterAddress.SocketState.rw    = static_cast<short>(m_settings->value(SKEY_MODBUS_RW_SOCKET, REG_RO).toInt());
        modbusRegisterAddress.GasState.rw       = static_cast<short>(m_settings->value(SKEY_MODBUS_RW_GAS, REG_RO).toInt());
        modbusRegisterAddress.UvState.rw        = static_cast<short>(m_settings->value(SKEY_MODBUS_RW_UV, REG_RO).toInt());

        pData->setModbusAllowSetFan(modbusRegisterAddress.FanState.rw);
        pData->setModbusAllowSetLight(modbusRegisterAddress.LightState.rw);
        pData->setModbusAllowSetLightIntensity(modbusRegisterAddress.LightIntensity.rw);
        pData->setModbusAllowSetSocket(modbusRegisterAddress.SocketState.rw);
        pData->setModbusAllowSetGas(modbusRegisterAddress.GasState.rw);
        pData->setModbusAllowSetUvLight(modbusRegisterAddress.UvState.rw);

        /// Create main object for modbus
        m_pModbusServer = new QModbusTcpServer(this);
        /// Monitoring incomming connection
        m_pModbusTcpConnObserver = new QModbusTcpConnObserverImp(this);
        m_pModbusTcpConnObserver->setMachineBackend(this); /// see the callback -> _callbackOnModbusConnectionStatusChanged
        m_pModbusServer->installConnectionObserver(m_pModbusTcpConnObserver);
        /// Register Address
        QModbusDataUnitMap reg;
        reg.insert(QModbusDataUnit::HoldingRegisters,
                   {QModbusDataUnit::HoldingRegisters, 0, MODBUS_REGISTER_COUNT});
        /// Shadow of the modbus register
        m_modbusDataUnitBufferRegisterHolding.reset(new QVector<uint16_t>(MODBUS_REGISTER_COUNT));
        /// put the register map to modbus handler
        m_pModbusServer->setMap(reg);
        /// Common number port for modbus TCP
        m_pModbusServer->setConnectionParameter(QModbusDevice::NetworkPortParameter, "5502");
        /// Listen from all addresses request
        m_pModbusServer->setConnectionParameter(QModbusDevice::NetworkAddressParameter, "0.0.0.0");
        /// the address of this Mobus server instance, default 1
        m_pModbusServer->setServerAddress(slaveID);
        /// monitoring the request
        connect(m_pModbusServer, &QModbusTcpServer::dataWritten,
                this, &MachineBackend::_onModbusDataWritten, Qt::UniqueConnection);

        /// Start the modbus
        bool connected = m_pModbusServer->connectDevice();
        if (!connected) {
            qWarning() << m_pModbusServer->errorString();
        }

        //        QObject::connect(pData, &MachineData::alarmStandbyFanOffChanged,
        //                         this, [&](short value){
        //            _setModbusRegHoldingValue(modbusRegisterAddress.AlarmStbFanOff.addr, static_cast<ushort>(value));
        //        });

        /// SETUP CONNECTION TO KEEP THE REGISTER VALUES
        /// SYNCED WITH THE ACTUAL VALUE
        {
            //
            QObject::connect(pData, &MachineData::fanPrimaryStateChanged,
                             this, [&](short value){
                                 _setModbusRegHoldingValue(modbusRegisterAddress.FanState.addr, static_cast<ushort>(value));
                                 _setModbusRegHoldingValue(modbusRegisterAddress.IfaFanState.addr, static_cast<ushort>(value));
                             });
            //            QObject::connect(pData, &MachineData::fanPrimaryStateChanged,
            //                             this, [&](short value){
            //                _setModbusRegHoldingValue(modbusRegisterAddress.DfaFanState.addr, static_cast<ushort>(value));
            //            });
            QObject::connect(pData, &MachineData::fanPrimaryDutyCycleChanged,
                             this, [&](short value){
                                 _setModbusRegHoldingValue(modbusRegisterAddress.IfaFanDutyCycle.addr, static_cast<ushort>(value));
                             });
            QObject::connect(pData, &MachineData::fanPrimaryRpmChanged,
                             this, [&](short value){
                                 _setModbusRegHoldingValue(modbusRegisterAddress.IfaFanRpm.addr, static_cast<ushort>(value));
                             });
            //
            //            QObject::connect(pData, &MachineData::fanInflowStateChanged,
            //                             this, [&](short value){
            //                _setModbusRegHoldingValue(modbusRegisterAddress.IfaFanState.addr, static_cast<ushort>(value));
            //            });
            //            QObject::connect(pData, &MachineData::fanInflowDutyCycleChanged,
            //                             this, [&](short value){
            //                _setModbusRegHoldingValue(modbusRegisterAddress.IfaFanDutyCycle.addr, static_cast<ushort>(value));
            //            });
            //            QObject::connect(pData, &MachineData::fanInflowRpmChanged,
            //                             this, [&](short value){
            //                _setModbusRegHoldingValue(modbusRegisterAddress.IfaFanRpm.addr, static_cast<ushort>(value));
            //            });
            //
            QObject::connect(pData, &MachineData::lightStateChanged,
                             this, [&](short value){
                                 _setModbusRegHoldingValue(modbusRegisterAddress.LightState.addr, static_cast<ushort>(value));
                             });
            QObject::connect(pData, &MachineData::lightIntensityChanged,
                             this, [&](short value){
                                 _setModbusRegHoldingValue(modbusRegisterAddress.LightIntensity.addr, static_cast<ushort>(value));
                             });
            QObject::connect(pData, &MachineData::socketStateChanged,
                             this, [&](short value){
                                 _setModbusRegHoldingValue(modbusRegisterAddress.SocketState.addr, static_cast<ushort>(value));
                             });
            QObject::connect(pData, &MachineData::gasStateChanged,
                             this, [&](short value){
                                 _setModbusRegHoldingValue(modbusRegisterAddress.GasState.addr, static_cast<ushort>(value));
                             });
            QObject::connect(pData, &MachineData::uvStateChanged,
                             this, [&](short value){
                                 _setModbusRegHoldingValue(modbusRegisterAddress.UvState.addr, static_cast<ushort>(value));
                             });
        }//
    }//

    /// Fan Speed Maximum Limit
    {
        int fanMaxLim = m_settings->value(SKEY_FAN_SPEED_MAX_LIMIT, 80).toInt();
        pData->setFanSpeedMaxLimit(fanMaxLim);
        pData->setFanSpeedMaxLimitSaved(fanMaxLim);
    }

    /// Fan Primary
    {
        /// find and initializing serial port for fan
        m_serialPort1.reset(new QSerialPort());
        foreach(const QSerialPortInfo &info, QSerialPortInfo::availablePorts()){
            if((info.vendorIdentifier() == BLOWER_USB_SERIAL_VID) &&
                (info.productIdentifier() == BLOWER_USB_SERIAL_PID)){

                m_serialPort1->setPort(info);

                if(m_serialPort1->open(QIODevice::ReadWrite)){
                    m_serialPort1->setBaudRate(QSerialPort::BaudRate::Baud4800);
                    m_serialPort1->setDataBits(QSerialPort::DataBits::Data8);
                    m_serialPort1->setParity(QSerialPort::Parity::NoParity);
                    m_serialPort1->setStopBits(QSerialPort::StopBits::OneStop);
                }
                break;
            }//
        }//

        /// RBM COM Board is OK and ready to send fan paramaters
        if (!m_serialPort1->isOpen()) {
            qWarning() << __FUNCTION__ << thread() << "serial port for fan cannot be opened";
            pData->setBoardStatusRbmCom(false);
        }
        /// initializing the fan object
        m_boardRegalECM.reset(new BlowerRegalECM);
        /// set the serial port
        m_boardRegalECM->setSerialComm(m_serialPort1.data());
        /// we expect the first value of the the fan from not running
        /// now, we assume the response from the fan is always OK,
        //        /// so we dont care the return value of following API
        m_boardRegalECM->stop();
        int maxAirVolume;
        /// setup profile fan ecm
        {
            /// query profile from machine profile
            QJsonObject machineProfile = pData->getMachineProfile();
            QJsonObject fanProfile = machineProfile.value("fan").toObject();

            short direction = static_cast<short>(fanProfile.value("direction").toInt());
            int highSpeedLimit = fanProfile.value("highSpeedLimit").toInt();
            maxAirVolume = fanProfile.value("maxAirVolume").toInt();

            QJsonObject constantProfile = fanProfile.value("constant").toObject();

            double a1 = constantProfile.value("a1").toDouble();
            double a2 = constantProfile.value("a2").toDouble();
            double a3 = constantProfile.value("a3").toDouble();
            double a4 = constantProfile.value("a4").toDouble();

            m_boardRegalECM->setDirection(direction);
            m_boardRegalECM->setCutbackSpeed(highSpeedLimit);
            m_boardRegalECM->setAirflowScaling(maxAirVolume);
            short response = static_cast<short>(m_boardRegalECM->setBlowerContant(a1, a2, a3, a4));

            pData->setBoardStatusRbmCom(response == 0);
        }

        ////MONITORING COMMUNICATION STATUS
        QObject::connect(m_boardRegalECM.data(), &BlowerRegalECM::errorComToleranceReached,
                         this, [&](int error){
                             qDebug() << "BlowerRegalECM::errorComToleranceReached" << error << thread();
                             pData->setBoardStatusRbmCom(false);
                         });
        QObject::connect(m_boardRegalECM.data(), &BlowerRegalECM::errorComToleranceCleared,
                         this, [&](int error){
                             qDebug() << "BlowerRegalECM::errorComToleranceCleared" << error << thread();
                             pData->setBoardStatusRbmCom(true);
                         });

        /// create object for value keeper
        /// ensure actuator value is what machine value requested
        m_pFanPrimary.reset(new BlowerRbmDsi);

        /// pass the virtual object sub module board
        m_pFanPrimary->setSubModule(m_boardRegalECM.data());

        /// use air volume demand mode, blower will have auto compesate to achive the air volume demand
        m_pFanPrimary->setDemandMode(BlowerRbmDsi::AIRVOLUME_DEMMAND_BRDM);
        m_pFanPrimary->setAirVolumeScale(maxAirVolume);
        m_pFanPrimary->setDutyCycleLimit(pData->getFanSpeedMaxLimit());

        QObject::connect(pData, &MachineData::fanSpeedMaxLimitChanged,
                         m_pFanPrimary.data(), &BlowerRbmDsi::setDutyCycleLimit);

        /// create timer for triggering the loop (routine task) and execute any pending request
        /// routine task and any pending task will executed by FIFO mechanism
        m_timerEventForFanRbmDsi.reset(new QTimer);
        m_timerEventForFanRbmDsi->setInterval(TEI_FOR_BLOWER_RBMDSI);

        /// create independent thread
        /// looping inside this thread will run parallel* beside machineState loop
        m_threadForFanRbmDsi.reset(new QThread);

        /// Start timer event when thread was started
        QObject::connect(m_threadForFanRbmDsi.data(), &QThread::started,
                         m_timerEventForFanRbmDsi.data(), [&](){
                             //            qDebug() << "m_timerEventForFanRbmDsi::started" << thread();
                             m_timerEventForFanRbmDsi->start();
                         });

        /// Stop timer event when thread was finished
        QObject::connect(m_threadForFanRbmDsi.data(), &QThread::finished,
                         m_timerEventForFanRbmDsi.data(), [&](){
                             //            qDebug() << "m_timerEventForFanRbmDsi::finished" << thread();
                             m_timerEventForFanRbmDsi->stop();
                         });

        /// Enable triggerOnStarted, calling the worker of FanRbmDsi when thread has started
        /// This is use lambda function, this symbol [&] for pass m_fanRbmDsi object to can captured by lambda
        /// m_fanRbmDsi.data(), [&](){m_fanRbmDsi->worker();});
        QObject::connect(m_threadForFanRbmDsi.data(), &QThread::started,
                         m_pFanPrimary.data(), [&](){
                             m_pFanPrimary->routineTask();
                         });

        /// Call routine task fan (syncronazation value)
        /// This method calling by timerEvent
        QObject::connect(m_timerEventForFanRbmDsi.data(), &QTimer::timeout,
                         m_pFanPrimary.data(), [&](){
                             //            qDebug() << "m_fanRbmDsi::timeout" << thread();
                             m_pFanPrimary->routineTask();
                         });

        /// Run fan loop thread when Machine State goes to looping / routine task
        QObject::connect(this, &MachineBackend::loopStarted,
                         m_threadForFanRbmDsi.data(), [&](){
                             //            qDebug() << "m_threadForFanRbmDsi::loopStarted" << thread();
                             m_threadForFanRbmDsi->start();
                         });

        /// call this when actual blower duty cycle has changed
        QObject::connect(m_pFanPrimary.data(), &BlowerRbmDsi::dutyCycleChanged,
                         this, &MachineBackend::_onFanPrimaryActualDucyChanged);

        /// call this when actual blower rpm has changed
        QObject::connect(m_pFanPrimary.data(), &BlowerRbmDsi::rpmChanged,
                         this, &MachineBackend::_onFanPrimaryActualRpmChanged);

        /// call this when actual blower interloked
        QObject::connect(m_pFanPrimary.data(), &BlowerRbmDsi::interlockChanged,
                         pData, [&](short newVal){
                             pData->setFanPrimaryInterlocked(newVal);
                         });

        /// Do move fan routine task / looping to independent thread
        m_pFanPrimary->moveToThread(m_threadForFanRbmDsi.data());
        /// Do move timer event for fan routine task to independent thread
        /// make the timer has prescission because independent from this Macine State looping
        m_timerEventForFanRbmDsi->moveToThread(m_threadForFanRbmDsi.data());
        /// Also move all necesarry object to independent fan thread
        m_serialPort1->moveToThread(m_threadForFanRbmDsi.data());
        m_boardRegalECM->moveToThread(m_threadForFanRbmDsi.data());
    }//

    /// Sash Window Motorize
    {
        bool installed = m_settings->value(SKEY_SASH_MOTOR_INSTALLED, MachineEnums::DIG_STATE_ONE).toInt();
        //        installed = true;
        pData->setHydraulicMotorizedInstalled(installed);

        m_pHydraulicMotorize.reset(new HydraulicOnRelay);
        m_pHydraulicMotorize->setSubModule(m_boardRelay1.data());
        m_pHydraulicMotorize->setChannelDown(6);
        m_pHydraulicMotorize->setChannelUp(7);
        m_pHydraulicMotorize->setChannelEnable(4);

#ifdef QT_DEBUG
        /// allow up channel up and down channel active in one time
        /// this only for testing/debug
        m_pHydraulicMotorize->setProtectFromDualActive(true);
#endif

        connect(m_pHydraulicMotorize.data(), &HydraulicOnRelay::stateChanged,
                pData, [&](int newVal){
                    pData->setSashWindowMotorizeState(static_cast<short>(newVal));

                    /// MODBUS
                    _setModbusRegHoldingValue(modbusRegisterAddress.SashMotorizeState.addr, static_cast<ushort>(newVal));
                });

        connect(m_pHydraulicMotorize.data(), &HydraulicOnRelay::interlockUpChanged,
                pData, [&](short newVal){
                    pData->setSashWindowMotorizeUpInterlocked(newVal);
                });
        connect(m_pHydraulicMotorize.data(), &HydraulicOnRelay::interlockDownChanged,
                pData, [&](short newVal){
                    pData->setSashWindowMotorizeDownInterlocked(newVal);
                });
    }//

    /// SASH
    {
        m_pSashWindow.reset(new SashWindow);
        m_pSashWindow->setSubModule(m_boardDigitalInput1.data());

        /// early update sash state
        m_boardDigitalInput1->polling();
        m_pSashWindow->routineTask();
        int currentState = m_pSashWindow->sashState();
        pData->setSashWindowState(static_cast<short>(currentState));

        /// MODBUS
        _setModbusRegHoldingValue(modbusRegisterAddress.SashState.addr, static_cast<ushort>(currentState));

        QObject::connect(m_pSashWindow.data(), &SashWindow::mSwitchStateChanged,
                         pData, [&](int index, int newVal){
                             pData->setMagSWState(static_cast<short>(index), static_cast<bool>(newVal));
                             if(index == 5){
                                 //                qDebug() << "index:" << index << "value:" << newVal;
                                 //                /// Front Panel Switch Installed on Hybrid Digital Input 6
                                 //                if(pData->getFrontPanelSwitchInstalled()){
                                 //                    pData->setFrontPanelSwitchState(static_cast<bool>(newVal));
                                 //                }
                                 //                _checkFrontPanelAlarm();
                                 pData->setSashWindowSafeHeight2(static_cast<bool>(newVal));
                             }//
                         });

        QObject::connect(m_pSashWindow.data(), &SashWindow::sashStateChanged,
                         this, &MachineBackend::_onSashStateChanged);

        int timerMs = 250;
        if(pData->getHydraulicMotorizedInstalled())
            timerMs = 50;
        //// Create Independent Timer Event For Sash Motorize
        m_timerEventForSashWindowRoutine.reset(new QTimer);
        m_timerEventForSashWindowRoutine->setInterval(std::chrono::milliseconds(timerMs));

        QObject::connect(m_timerEventForSashWindowRoutine.data(), &QTimer::timeout,
                         this, &MachineBackend::_onTriggeredEventSashWindowRoutine);

        QObject::connect(this, &MachineBackend::loopStarted, [&](){
            m_timerEventForSashWindowRoutine->start();
        });
    }//
    /// Light
    {
        m_pLight.reset(new DeviceDigitalOut);
        m_pLight->setSubModule(m_boardRelay1.data());
        m_pLight->setChannelIO(0);
        m_pLight->setState(MachineEnums::DIG_STATE_ZERO); // Force Lamp to turn-off

        connect(m_pLight.data(), &DeviceDigitalOut::stateChanged,
                this, &MachineBackend::_onLightStateChanged);

        connect(m_pLight.data(), &DeviceDigitalOut::interlockChanged,
                pData, [&](int newVal){
                    pData->setLightInterlocked(newVal);
                });
    }

    /// Light Intensity
    {
        m_pLightIntensity.reset(new DeviceAnalogCom);
        m_pLightIntensity->setSubBoard(m_boardAnalogOutput1.data());
        //        m_pLightIntensity->setBoardAvailableStatus(pData->getBoardStatusHybridAnalogOutput());

        int min = m_settings->value(SKEY_LIGHT_INTENSITY_MIN, 30).toInt(); //percent

        int adcMin;
        m_boardAnalogOutput1->voltToInputcode((min / 10) * 1000 /*to miliVolt*/, &adcMin);

        //        qDebug() << "adcMin" << adcMin;

        m_pLightIntensity->setAdcMin(adcMin);
        m_pLightIntensity->setStateMin(min);

        short light = static_cast<short>(m_settings->value(SKEY_LIGHT_INTENSITY, 100).toInt());

        /// CAUSED BLINKING - NO IMPLEMENTED
        /// bacasue boardIo poilling not started yet, so we manually call
        /// the board instead m_lightIntensity object
        /// this i2c communication will used direct mode
        //        int inputCode = m_lightIntensity->stateToAdc(light);
        //        qDebug() << "m_lightIntensity" << inputCode;
        //        m_boardAnalogOutput1->setDAC(inputCode);

        m_pLightIntensity->setState(light);

        pData->setLightIntensity(light);
        connect(m_pLightIntensity.data(), &DeviceAnalogCom::stateChanged,
                pData, [&](int newVal){
                    pData->setLightIntensity(static_cast<short>(newVal));

                    /// MODBUS
                    _setModbusRegHoldingValue(modbusRegisterAddress.LightIntensity.addr, static_cast<ushort>(newVal));
                });

        //        QObject::connect(pData, &MachineData::boardStatusHybridAnalogOutputChanged,
        //                         m_pLightIntensity.data(), [&](bool value){
        //                             m_pLightIntensity->setBoardAvailableStatus(value);
        //                         });

    }//

    /// Socket
    {
        bool installed = m_settings->value(SKEY_SOCKET_INSTALLED, MachineEnums::DIG_STATE_ONE).toInt();
        pData->setSocketInstalled(installed);

        m_pSocket.reset(new DeviceDigitalOut);
        m_pSocket->setSubModule(m_boardRelay1.data());
        m_pSocket->setChannelIO(5);

        connect(m_pSocket.data(), &DeviceDigitalOut::stateChanged,
                this, &MachineBackend::_onSocketStateChanged);

        connect(m_pSocket.data(), &DeviceDigitalOut::interlockChanged,
                pData, [&](int newVal){
                    pData->setSocketInterlocked(newVal);
                });
    }

    /// Gas
    {
        bool installed = m_settings->value(SKEY_GAS_INSTALLED, false).toBool();
        pData->setGasInstalled(installed);

        m_pGas.reset(new DeviceDigitalOut);
        m_pGas->setSubModule(m_boardRelay1.data());
        m_pGas->setChannelIO(2);

        connect(m_pGas.data(), &DeviceDigitalOut::stateChanged,
                this, &MachineBackend::_onGasStateChanged);

        connect(m_pGas.data(), &DeviceDigitalOut::interlockChanged,
                pData, [&](int newVal){
                    pData->setGasInterlocked(newVal);
                });
    }

    /// UV
    {
        bool installed = m_settings->value(SKEY_UV_INSTALLED, MachineEnums::DIG_STATE_ONE).toInt();
        pData->setUvInstalled(installed);

        m_pUV.reset(new DeviceDigitalOut);
        m_pUV->setSubModule(m_boardRelay1.data());
        m_pUV->setChannelIO(1);

        connect(m_pUV.data(), &DeviceDigitalOut::stateChanged,
                this, &MachineBackend::_onUVStateChanged);

        connect(m_pUV.data(), &DeviceDigitalOut::interlockChanged,
                pData, [&](int newVal){
                    pData->setUvInterlocked(newVal);
                });

        /// UV Meter
        {
            QObject::connect(pData, &MachineData::uvLifePercentChanged, this, [&](short value){
                /// MODBUS
                _setModbusRegHoldingValue(modbusRegisterAddress.UvLifeLeft.addr, static_cast<ushort>(value));

                if(value < 10) // activate replacement reminder if life left less than 10%
                    pData->setUvReplacementReminder(true);
                else
                    pData->setUvReplacementReminder(false);
            });

            int minutes = m_settings->value(SKEY_UV_METER, SDEF_UV_MAXIMUM_TIME_LIFE).toInt();
            int minutesPercentLeft = __getPercentFrom(minutes, SDEF_UV_MAXIMUM_TIME_LIFE);
            /// event if in % value is zero but the minutes more then 0 minutes, then set % to 1
            if (minutesPercentLeft == 0 && minutes > 0) minutesPercentLeft = 1;

            QObject::connect(pData, &MachineData::uvLifePercentChanged,
                             this, [&](short value){
                                 if(value < 10){ //0-9
                                     pData->setUvLifeLevelColorStrf("#FE1003");
                                 }//
                                 else if(value < 20){ //10-19
                                     pData->setUvLifeLevelColorStrf("#EE6112");
                                 }//
                                 else if(value < 50){ //20-49
                                     pData->setUvLifeLevelColorStrf("#FEB803");
                                 }//
                                 else if(value < 75){ //50-74
                                     pData->setUvLifeLevelColorStrf("#DBFE03");
                                 }//
                                 else if(value < 90){ //75-89
                                     pData->setUvLifeLevelColorStrf("#75DE13");
                                 }//
                                 else {//90-100
                                     pData->setUvLifeLevelColorStrf("#05B837");
                                 }//
                             });

            //update to global observable variable
            pData->setUvLifeMinutes(minutes);
            pData->setUvLifePercent(static_cast<short>(minutesPercentLeft));



            /// MODBUS
            /// _setModbusRegHoldingValue(modbusRegisterAddress.UvLifeLeft.addr, static_cast<ushort>(minutesPercentLeft));
        }

        /// UV Timer
        {
            int minutes = m_settings->value(SKEY_UV_TIME, 60).toInt(); //60 minutes (as per Alex Atmadi)
            int countdown = m_settings->value(SKEY_UV_TIME_COUNTDOWN, 0).toInt(); //in seconds
            // minutes = 1;
            pData->setUvTime(minutes);
            if(!countdown)
                pData->setUvTimeCountdown(minutes * 60);
            else
                pData->setUvTimeCountdown(countdown);
        }
    }

    //    /// Exhaust Contact
    //    {
    //        m_pExhaustContact.reset(new DeviceDigitalOut);
    //        m_pExhaustContact->setSubModule(m_boardRelay1.data());
    //        m_pExhaustContact->setChannelIO(6);

    //        connect(m_pExhaustContact.data(), &DeviceDigitalOut::stateChanged,
    //                this, [&](int newVal){
    //                    setExhaustContactState(static_cast<short>(newVal));
    //                });
    //    }

    //    /// Alarm Contact
    //    {
    //        m_pAlarmContact.reset(new DeviceDigitalOut);
    //        m_pAlarmContact->setSubModule(m_boardRelay1.data());
    //        m_pAlarmContact->setChannelIO(7);

    //        connect(m_pAlarmContact.data(), &DeviceDigitalOut::stateChanged,
    //                this, [&](int newVal){
    //                    setAlarmContactState(static_cast<short>(newVal));
    //                });
    //    }

    /// Particle Counter
    {
        bool particleCounterSensorInstalled = m_settings->value(SKEY_PARTICLE_COUNTER_INST, MachineEnums::DIG_STATE_ZERO).toBool();
        pData->setParticleCounterSensorInstalled(particleCounterSensorInstalled);

        if(pData->getParticleCounterSensorInstalled()) {
            /// find and initializing serial port for fan
            m_serialPort2.reset(new QSerialPort());

#ifndef __linux__
            //// FOR TESTING IN DEVELOPER PC
            m_serialPort2->setPortName("COM9");
            m_serialPort2->setBaudRate(QSerialPort::BaudRate::Baud9600);
            m_serialPort2->setDataBits(QSerialPort::DataBits::Data8);
            m_serialPort2->setParity(QSerialPort::Parity::NoParity);
            m_serialPort2->setStopBits(QSerialPort::StopBits::OneStop);
#endif

#ifdef __arm__
            foreach(const QSerialPortInfo &info, QSerialPortInfo::availablePorts()){
                qDebug() << info.vendorIdentifier() << info.productIdentifier() << info.portName();
                if((info.vendorIdentifier() == PARTICLE_COUNTER_UART_VID) &&
                    (info.productIdentifier() == PARTICLE_COUNTER_UART_PID)){
                    qDebug() << "port name: " << info.portName();
                    m_serialPort2->setPortName(info.portName());
                    m_serialPort2->setBaudRate(QSerialPort::BaudRate::Baud9600);
                    m_serialPort2->setDataBits(QSerialPort::DataBits::Data8);
                    m_serialPort2->setParity(QSerialPort::Parity::NoParity);
                    m_serialPort2->setStopBits(QSerialPort::StopBits::OneStop);
                    break;
                }
            }
#endif

            //Open Here
            m_serialPort2->open(QIODevice::ReadWrite);

            /// Board is OK and ready to send fan paramaters
            if (!m_serialPort2->isOpen()) {
                qWarning() << metaObject()->className() << __FUNCTION__ << "PARTICLE_COUNTER" << "serial port 2 for particle counter cannot be opened";
                pData->setBoardStatusParticleCounter(false);
                //            pData->setBoardStatusRbmCom(false);
            }
            else {
                qDebug() << metaObject()->className() << "PARTICLE_COUNTER Port open at " << __func__ << m_serialPort2->portName();
                pData->setBoardStatusParticleCounter(true);
            }
            /// initializing the fan object
            m_boardParticleCounterZH03B.reset(new ParticleCounterZH03B);
            /// set the serial port
            m_boardParticleCounterZH03B->setSerialComm(m_serialPort2.data());

            ///set to Q&A Communication mode
            int resp = m_boardParticleCounterZH03B->setQA();
            if(resp != 0){
                qWarning() << metaObject()->className() << __FUNCTION__ << "PARTICLE_COUNTER" << "Failed to set to Q&A Communication Mode";
            }
            else {
                qDebug() << metaObject()->className() << "PARTICLE_COUNTER Q&A Communication Mode " << __func__ << m_serialPort2->portName();
            }

            ///initially turned off Fan
            m_boardParticleCounterZH03B->setDormantMode(MachineEnums::FAN_STATE_OFF);

            ////MONITORING COMMUNICATION STATUS
            QObject::connect(m_boardParticleCounterZH03B.data(), &ParticleCounterZH03B::errorComToleranceReached,
                             this, [&](int error){
                                 qDebug() << "ParticleCounterZH03B::errorComToleranceReached" << error << thread();
                                 pData->setBoardStatusParticleCounter(false);
                             });

            QObject::connect(m_boardParticleCounterZH03B.data(), &ParticleCounterZH03B::errorComToleranceCountChanged,
                             this, [&](int error){
                                 qDebug() << "ParticleCounterZH03B::errorComToleranceCountChanged: " << error;
                                 //pData->setBoardStatusParticleCounter(false);
                             });

            QObject::connect(m_boardParticleCounterZH03B.data(), &ParticleCounterZH03B::errorComToleranceCleared,
                             this, [&](int error){
                                 qDebug() << "ParticleCounterZH03B::errorComToleranceCleared" << error << thread();
                                 pData->setBoardStatusParticleCounter(true);
                             });

            /// create object for value keeper
            /// ensure actuator value is what machine value requested
            m_pParticleCounter.reset(new ParticleCounter);

            /// pass the virtual object sub module board
            m_pParticleCounter->setSubModule(m_boardParticleCounterZH03B.data());

            /// create timer for triggering the loop (routine task) and execute any pending request
            /// routine task and any pending task will executed by FIFO mechanism
            m_timerEventForParticleCounter.reset(new QTimer);
            m_timerEventForParticleCounter->setInterval(std::chrono::seconds(5));

            /// create independent thread
            /// looping inside this thread will run parallel* beside machineState loop
            m_threadForParticleCounter.reset(new QThread);

            /// Start timer event when thread was started
            QObject::connect(m_threadForParticleCounter.data(), &QThread::started,
                             m_timerEventForParticleCounter.data(), [&](){
                                 //            qDebug() << "m_timerEventForFanRbmDsi::started" << thread();
                                 m_timerEventForParticleCounter->start();
                             });

            /// Stop timer event when thread was finished
            QObject::connect(m_threadForParticleCounter.data(), &QThread::finished,
                             m_timerEventForParticleCounter.data(), [&](){
                                 //            qDebug() << "m_timerEventForFanRbmDsi::finished" << thread();
                                 m_timerEventForParticleCounter->stop();
                             });

            /// Enable triggerOnStarted, calling the worker of FanRbmDsi when thread has started
            /// This is use lambda function, this symbol [&] for pass m_fanRbmDsi object to can captured by lambda
            /// m_pParticleCounter.data(), [&](){m_pParticleCounter->routineTask();});
            QObject::connect(m_threadForParticleCounter.data(), &QThread::started,
                             m_pParticleCounter.data(), [&](){
                                 m_pParticleCounter->routineTask();
                             });

            /// Call routine task fan (syncronazation value)
            /// This method calling by timerEvent
            QObject::connect(m_timerEventForParticleCounter.data(), &QTimer::timeout,
                             m_pParticleCounter.data(), [&](){
                                 m_pParticleCounter->routineTask();
                             });

            /// Run fan loop thread when Machine State goes to looping / routine task
            QObject::connect(this, &MachineBackend::loopStarted,
                             m_threadForParticleCounter.data(), [&](){
                                 m_threadForParticleCounter->start();
                             });

            /// call this when actual blower duty cycle has changed
            QObject::connect(m_pParticleCounter.data(), &ParticleCounter::pm1_0Changed,
                             this, &MachineBackend::_onParticleCounterPM1_0Changed);
            QObject::connect(m_pParticleCounter.data(), &ParticleCounter::pm2_5Changed,
                             this, &MachineBackend::_onParticleCounterPM2_5Changed);
            QObject::connect(m_pParticleCounter.data(), &ParticleCounter::pm10Changed,
                             this, &MachineBackend::_onParticleCounterPM10Changed);
            QObject::connect(m_pParticleCounter.data(), &ParticleCounter::fanStatePaCoChanged,
                             this, &MachineBackend::_onParticleCounterSensorFanStateChanged);

            /// Do move fan routine task / looping to independent thread
            m_pParticleCounter->moveToThread(m_threadForParticleCounter.data());
            /// Do move timer event for fan routine task to independent thread
            /// make the timer has prescission because independent from this Macine State looping
            m_timerEventForParticleCounter->moveToThread(m_threadForParticleCounter.data());
            /// Also move all necesarry object to independent fan thread
            m_serialPort2->moveToThread(m_threadForParticleCounter.data());
            m_boardParticleCounterZH03B->moveToThread(m_threadForParticleCounter.data());
        }
    }//

    /// Measurement Unit
    {
        int meaUnit = m_settings->value(SKEY_MEASUREMENT_UNIT,
                                        MachineEnums::MEA_UNIT_METRIC).toInt();

        ///MODBUS
        QObject::connect(pData, &MachineData::measurementUnitChanged,
                         this, [&](short value){
                             _setModbusRegHoldingValue(modbusRegisterAddress.MeaUnit.addr, static_cast<ushort>(value));
                         });
        pData->setMeasurementUnit(static_cast<short>(meaUnit));
        //        qDebug() << "SKEY_MEASUREMENT_UNIT" << meaUnit;
    }

    /// Cabinet Display Name
    /// Also it's used as hostname in network
    {
        /// query profile from machine profile
        QJsonObject machineProfile = pData->getMachineProfile();
        //        QJsonObject modelProfile = machineProfile.value("modelStr").toObject();
        QString model = machineProfile.value("modelStr").toString();
        QString cabinetDisplayName = m_settings->value(SKEY_CAB_DISPLAY_NAME, "BSC-1").toString();
        QString nameNormalization = QString(cabinetDisplayName).replace("#~#", " ");

        pData->setCabinetDisplayName(nameNormalization);

#ifdef __linux__
        QString idStrCabDisplayName = "esco-centurion-" + cabinetDisplayName;
        /// Set to linux system
        QProcess::execute("hostnamectl", QStringList() << "set-hostname" << idStrCabDisplayName);
#endif

        /// qDebug() << "SKEY_CAB_DISPLAY_NAME" << displayName;
    }//

    /// TEMPERATURE
    {
        m_pTemperature.reset(new Temperature);
        m_pTemperature->setSubModule(m_boardAnalogInput1.data());
        m_pTemperature->setChannelIO(0);
        m_pTemperature->setPrecision(1);

        connect(m_pTemperature.data(), &Temperature::adcChanged,
                pData, &MachineData::setTemperatureAdc);
        //        connect(m_pTemperature.data(), &Temperature::celciusChanged,
        //                this, &MachineBackend::_onTemperatureActualChanged);
        connect(m_pTemperature.data(), &Temperature::celciusPrecisionChanged,
                this, &MachineBackend::_onTemperatureActualChanged);

        /// force update temperature string
        int temp = 0;
        pData->setTemperatureCelcius(static_cast<short>(temp));

        if (pData->getMeasurementUnit()) {
            pData->setTemperature(static_cast<short>(temp));
            QString valueStr = QString::asprintf("%d°F", temp);
                               pData->setTemperatureValueStrf(valueStr);
        }
        else {
            pData->setTemperature(static_cast<short>(temp));
            QString valueStr = QString::asprintf("%d°C", temp);
                               pData->setTemperatureValueStrf(valueStr);
        }
    }

    /// AIRFLOW OUT TEMP ENABLE
    {
        bool afOutTempEn = m_settings->value(SKEY_AF_OUT_TEMP_ENABLE, false).toBool();
        pData->setAirflowOutTempEnable(afOutTempEn);
    }
    /// FILTER LIFE DISPLAY
    {
        bool filterDisplay = m_settings->value(SKEY_FILTER_LIFE_DISPLAY_ENABLED, true).toBool();
        pData->setFilterLifeDisplayEnabled(filterDisplay);

        QObject::connect(pData, &MachineData::languageChanged,
                         this, [&](){
                             emit pData->filterLifePercentChanged(pData->getFilterLifePercent());
                         });
        QObject::connect(pData, &MachineData::filterLifePercentChanged,
                         this, [&](short value){
                             if(value < 10){ //0-9
                                 pData->setFilterLifeLevelStrf(_tr(QObject::tr("Very Bad")));
                                 pData->setFilterLifeLevelColorStrf("#FE1003");
                             }//
                             else if(value < 20){ //10-19
                                 pData->setFilterLifeLevelStrf(_tr(QObject::tr("Bad")));
                                 pData->setFilterLifeLevelColorStrf("#EE6112");
                             }//
                             else if(value < 50){ //20-49
                                 pData->setFilterLifeLevelStrf(_tr(QObject::tr("Fair")));
                                 pData->setFilterLifeLevelColorStrf("#FEB803");
                             }//
                             else if(value < 75){ //50-74
                                 pData->setFilterLifeLevelStrf(_tr(QObject::tr("Good")));
                                 pData->setFilterLifeLevelColorStrf("#DBFE03");
                             }//
                             else if(value < 90){ //75-89
                                 pData->setFilterLifeLevelStrf(_tr(QObject::tr("Great")));
                                 pData->setFilterLifeLevelColorStrf("#75DE13");
                             }//
                             else {
                                 pData->setFilterLifeLevelStrf(_tr(QObject::tr("Excellent")));
                                 pData->setFilterLifeLevelColorStrf("#05B837");
                             }//
                         });
    }//
    /// SENSOR CONSTANT CORRECTION
    {
        bool sensConstCorEn = m_settings->value(SKEY_SENSOR_CONST_CORR_ENABLE, false).toBool();
        int sensConstCorHigh = m_settings->value(SKEY_SENSOR_CONST_CORR_HIGH, 50).toInt();
        int sensConstCorLow = m_settings->value(SKEY_SENSOR_CONST_CORR_LOW, 50).toInt();
        pData->setSensorConstCorrEnable(sensConstCorEn);
        pData->setSensorConstCorrHighZone(sensConstCorHigh);
        pData->setSensorConstCorrLowZone(sensConstCorLow);
    }

    /// AIRFLOW_INFLOW
    {
        ////CREATE INFLOW OBJECT
        m_pAirflowInflow.reset(new AirflowVelocity());
        m_pAirflowInflow->setAIN(m_boardAnalogInput1.data());
        m_pAirflowInflow->setChannel(1);
        m_pAirflowInflow->setMeasurementUnit(static_cast<uchar>(pData->getMeasurementUnit()));
        m_pAirflowInflow->setSensorConstCorrEnable(pData->getSensorConstCorrEnable());
        m_pAirflowInflow->setSensorConstCorrHighZone(pData->getSensorConstCorrHighZone());
        m_pAirflowInflow->setSensorConstCorrLowZone(pData->getSensorConstCorrLowZone());

        int tempCalib = pData->getInflowTempCalib();
        if(pData->getMeasurementUnit())
            tempCalib = __convertFtoC(tempCalib);
        m_pAirflowInflow->setTemperatureCalib(tempCalib);

        /// CONNECTION
        QObject::connect(pData, &MachineData::sensorConstCorrEnableChanged,
                         m_pAirflowInflow.data(), &AirflowVelocity::setSensorConstCorrEnable);
        QObject::connect(pData, &MachineData::sensorConstCorrHighZoneChanged,
                         m_pAirflowInflow.data(), &AirflowVelocity::setSensorConstCorrHighZone);
        QObject::connect(pData, &MachineData::sensorConstCorrLowZoneChanged,
                         m_pAirflowInflow.data(), &AirflowVelocity::setSensorConstCorrLowZone);
        QObject::connect(pData, &MachineData::ifaTemperatureCalibChanged,
                         this, [&](int value){
                             int tempCalib = value;
                             if(pData->getMeasurementUnit())
                                 tempCalib = __convertFtoC(tempCalib);
                             m_pAirflowInflow->setTemperatureCalib(tempCalib);
                         });//

        QObject::connect(m_pAirflowInflow.data(), &AirflowVelocity::adcConpensationChanged,
                         pData, [&](int newVal){
                             //            qDebug() << newVal;
                             pData->setInflowAdcConpensation(newVal);
                         });//
        QObject::connect(m_pAirflowInflow.data(), &AirflowVelocity::adcPointCorrectionChanged,
                         this, [&](short point, int value){
                             qDebug() << "adc correction point" << point << "=" << value;
                             pData->setAdcInflowPointCorrection(point, value);
                         });//
        QObject::connect(m_pAirflowInflow.data(), &AirflowVelocity::mVoltChanged,
                         pData, [&](int newVal){
                             qDebug() << "setHaBoardInputCh2MVolt:" << newVal;
                             short offset = 10;//get from actual measurement
                             pData->setHaBoardInputCh2MVolt(newVal + offset);
                         });//

        QObject::connect(m_pAirflowInflow.data(), &AirflowVelocity::velocityChanged,
                         this, &MachineBackend::_onInflowVelocityActualChanged);
        QObject::connect(m_pAirflowInflow.data(), &AirflowVelocity::velocityChanged,
                         this, &MachineBackend::_calculteDownflowVelocity);

        /// Temperature has effecting to Airflow Reading
        /// so, need to update temperature value on the Airflow Calculation
        QObject::connect(m_pTemperature.data(), &Temperature::celciusPrecisionChanged,
                         m_pAirflowInflow.data(), &AirflowVelocity::setTemperature);
        //        connect(m_pTemperature.data(), &Temperature::celciusChanged,
        //                m_pAirflowInflow.data(), &AirflowVelocity::setTemperature);
    }//

    /// AIRFLOW MONITOR ENABLE
    {
        bool airflowMonitorEnable = m_settings->value(SKEY_AF_MONITOR_ENABLE, MachineEnums::DIG_STATE_ONE).toBool();
        pData->setAirflowMonitorEnable(airflowMonitorEnable);
    }//

    /// ADVANCED AIRFLOW ALARM
    {
        bool advAlarmEn = m_settings->value(SKEY_ADVANCED_AF_ALARM, false).toBool();
        pData->setAdvancedAirflowAlarmEnable(advAlarmEn);

        QObject::connect(pData, &MachineData::alarmDownflowHighChanged,
                         this, [&](short value){
                             _setModbusRegHoldingValue(modbusRegisterAddress.AlarmDownflowHigh.addr, static_cast<ushort>(value));
                         });
        QObject::connect(pData, &MachineData::alarmDownflowLowChanged,
                         this, [&](short value){
                             _setModbusRegHoldingValue(modbusRegisterAddress.AlarmDownflowLow.addr, static_cast<ushort>(value));
                         });
    }

    /// SEAS INTEGRATED
    {
        m_pSeas.reset(new PressureDiffManager);
        m_pSeas->setSubModule(m_boardSensirionSPD8xx.data());

        short installed = static_cast<short>(m_settings->value(SKEY_SEAS_INSTALLED, MachineEnums::DIG_STATE_ZERO).toInt());
        if(installed){
            short offset = static_cast<short>(m_settings->value(SKEY_SEAS_OFFSET_PA, 0).toInt());
            pData->setSeasPressureDiffPaOffset(offset);
            int lowLimit = m_settings->value(SKEY_SEAS_FAIL_POINT_PA, 1000).toInt();
            pData->setSeasPressureDiffPaLowLimit(lowLimit);

            m_pSeas->setOffsetPa(offset);
        }

        //// MONITORING EXHAUST PRESSURE ACTUAL VALUE
        QObject::connect(m_pSeas.data(), &PressureDiffManager::actualPaChanged,
                         this, &MachineBackend::_onSeasPressureDiffPaChanged);

        if(installed){
            /// force update pressure text value
            _onSeasPressureDiffPaChanged(0);
        }
    }

    /// LCD Brightness
    {
        int time          = m_settings->value(SKEY_LCD_DELAY_TO_DIMM, 5 /*minute*/).toInt();
        int brightness    = m_settings->value(SKEY_LCD_BL, 50).toInt();
        bool enLock       = m_settings->value(SKEY_LCD_EN_LOCK_SCREEN, true).toBool();

        /// SEND TO BOARD
        m_boardCtpIO->setOutputPWM(LEDpca9633_CHANNEL_BL, (brightness));

        /// UPDATE INFO
        pData->setLcdBrightnessLevel(static_cast<short>(brightness));
        pData->setLcdBrightnessLevelUser(static_cast<short>(brightness));
        pData->setLcdBrightnessDelayToDimm(static_cast<short>(time));
        pData->setLcdEnableLockScreen(enLock);

        /// SETUP TIMER EVENT
        m_timerEventForLcdToDimm.reset(new QTimer);
        m_timerEventForLcdToDimm->setInterval(std::chrono::minutes(time));

        /// CALL THIS FUNCTION WHEN TIMER WAS TRIGGERED
        QObject::connect(m_timerEventForLcdToDimm.data(), &QTimer::timeout,
                         this, &MachineBackend::_onTimerEventLcdDimm);
        ///
        QObject::connect(this, &MachineBackend::loopStarted,
                         [&](){
                             if(pData->getLcdBrightnessDelayToDimm() > 0)
                                 m_timerEventForLcdToDimm->start();
                         });
    }//

    /// Operation Mode
    {
        int value = m_settings->value(SKEY_OPERATION_MODE,
                                      MachineEnums::MODE_OPERATION_QUICKSTART).toInt();
        pData->setOperationMode(static_cast<short>(value));

        //        qDebug() << "SKEY_OPERATION_MODE" << value;
        /// MODBUS
        _setModbusRegHoldingValue(modbusRegisterAddress.OperationMode.addr, static_cast<ushort>(value));
    }//

    /// SENSOR TEMPERATURE ENVIRONTMENTAL LIMITATION
    {
        QJsonObject machineProfile = pData->getMachineProfile();
        QJsonObject envTempLimit = machineProfile.value("envTempLimit").toObject();

        int highLimit = envTempLimit.value("highest").toInt();
        int lowLimit  = envTempLimit.value("lowest").toInt();

        if(pData->getMeasurementUnit() == MachineEnums::MEA_UNIT_IMPERIAL){
            highLimit = __convertCtoF(highLimit);
            lowLimit = __convertCtoF(lowLimit);
        }//

        highLimit = m_settings->value(SKEY_ENV_TEMP_HIGH_LIMIT, highLimit).toInt();
        lowLimit = m_settings->value(SKEY_ENV_TEMP_LOW_LIMIT, lowLimit).toInt();

        pData->setEnvTempHighestLimit(highLimit);
        pData->setEnvTempLowestLimit(lowLimit);

        // qDebug() << "SKEY_ELS_ENABLE" << value;
    }//

    /// Fan PIN
    {
        /// 0000-md5
        QString value = m_settings->value(SKEY_FAN_PIN,
                                          "4a7d1ed414474e4033ac29ccb8653d9b").toString();
        pData->setFanPIN(value);
    }//

    /// Security Access Mode
    {
        int value = m_settings->value(SKEY_SECURITY_ACCESS_MODE,
                                      MachineEnums::MODE_SECURITY_ACCESS_LOW).toInt();
        pData->setSecurityAccessMode(static_cast<short>(value));

        //        qDebug() << "SKEY_SECURITY_ACCESS_MODE" << value;
    }//

    /// Esco Lock Service Enable/Disabled
    {
        /// By default is disabled
        int value = m_settings->value(SKEY_ELS_ENABLE,
                                      MachineEnums::DIG_STATE_ZERO).toInt();
        pData->setEscoLockServiceEnable(value);

        //        qDebug() << "SKEY_ELS_ENABLE" << value;
    }//

    /// Certification Expired
    {
        QDate currentDate = QDate::currentDate();
        QString dateText = currentDate.toString("dd-MM-yyyy");

        QString dateExpire = m_settings->value(SKEY_CALENDER_REMINDER_MODE,dateText).toString();

        pData->setDateCertificationReminder(dateExpire);

        _checkCertificationReminder();
    }//

    /// Airflow Calibration Load + FAN
    {
        QSettings settings;

        int fanNominalDutyCycleFactory  = settings.value(SKEY_FAN_PRI_NOM_DCY_FACTORY, 39).toInt();
        int fanNominalRpmFactory        = settings.value(SKEY_FAN_PRI_NOM_RPM_FACTORY, 0).toInt();

        int fanMinimumDutyCycleFactory  = settings.value(SKEY_FAN_PRI_MIN_DCY_FACTORY, 29).toInt();
        int fanMinimumRpmFactory        = settings.value(SKEY_FAN_PRI_MIN_RPM_FACTORY, 0).toInt();

        int fanStandbyDutyCycleFactory  = settings.value(SKEY_FAN_PRI_STB_DCY_FACTORY, 10).toInt();
        int fanStandbyRpmFactory        = settings.value(SKEY_FAN_PRI_STB_RPM_FACTORY, 0).toInt();

        int fanNominalDutyCycleField    = settings.value(SKEY_FAN_PRI_NOM_DCY_FIELD, 0).toInt();
        int fanNominalRpmField          = settings.value(SKEY_FAN_PRI_NOM_RPM_FIELD, 0).toInt();

        int fanMinimumDutyCycleField    = settings.value(SKEY_FAN_PRI_MIN_DCY_FIELD, 0).toInt();
        int fanMinimumRpmField          = settings.value(SKEY_FAN_PRI_MIN_RPM_FIELD, 0).toInt();

        int fanStandbyDutyCycleField    = settings.value(SKEY_FAN_PRI_STB_DCY_FIELD, 0).toInt();
        int fanStandbyRpmField          = settings.value(SKEY_FAN_PRI_STB_RPM_FIELD, 0).toInt();

        int sensorConstant  = settings.value(SKEY_IFA_SENSOR_CONST, 0).toInt();

        int tempCalib       = settings.value(SKEY_IFA_CAL_TEMP, 0).toInt();
        int tempCalibAdc    = settings.value(SKEY_IFA_CAL_TEMP_ADC, 0).toInt();

        int ifaAdcZeroFactory = settings.value(QString(SKEY_IFA_CAL_ADC_FACTORY) + "0", 0).toInt();
        int ifaAdcMinFactory  = settings.value(QString(SKEY_IFA_CAL_ADC_FACTORY) + "1", 0).toInt();
        int ifaAdcNomFactory  = settings.value(QString(SKEY_IFA_CAL_ADC_FACTORY) + "2", 0).toInt();

        int ifaVelMinFactory  = settings.value(QString(SKEY_IFA_CAL_VEL_FACTORY) + "1", 40).toInt();
        int ifaVelNomFactory  = settings.value(QString(SKEY_IFA_CAL_VEL_FACTORY) + "2", 53).toInt();

        int ifaVelLowAlarm    = settings.value(QString(SKEY_IFA_CAL_VEL_LOW_LIMIT), ifaVelMinFactory).toInt();

        int ifaAdcZeroField   = settings.value(QString(SKEY_IFA_CAL_ADC_FIELD) + "0", 0).toInt();
        int ifaAdcMinField    = settings.value(QString(SKEY_IFA_CAL_ADC_FIELD) + "1", 0).toInt();
        int ifaAdcNomField    = settings.value(QString(SKEY_IFA_CAL_ADC_FIELD) + "2", 0).toInt();

        int ifaVelMinField    = settings.value(QString(SKEY_IFA_CAL_VEL_FIELD) + "1", 0).toInt();
        int ifaVelNomField    = settings.value(QString(SKEY_IFA_CAL_VEL_FIELD) + "2", 0).toInt();

        int dfaVelNomFactory  = settings.value(QString(SKEY_DFA_CAL_VEL_FACTORY) + "2", 30).toInt();
        int dfaVelNomField    = settings.value(QString(SKEY_DFA_CAL_VEL_FIELD) + "2", 0).toInt();

        //        //CALIB PHASE; NONE, FACTORY, or FIELD
        //        //        int afCalibPhase      = settings.value(SKEY_AF_CALIB_PHASE, 0).toInt();
        //        qDebug() << ifaAdcZeroFactory << ifaAdcMinFactory << ifaAdcNomFactory;
        //        qDebug() << ifaVelMinFactory << ifaVelNomFactory;
        //        qDebug() << fanNominalDutyCycleFactory;
        bool calibPhaseFactory = (((ifaAdcZeroFactory + 80) <= ifaAdcMinFactory)
                                  && ((ifaAdcMinFactory + 80) <= ifaAdcNomFactory)
                                  && (ifaVelMinFactory > 0)
                                  && (ifaVelMinFactory < ifaVelNomFactory)
                                  && (fanStandbyDutyCycleFactory > 0)
                                  && (fanStandbyDutyCycleFactory < fanMinimumDutyCycleFactory)
                                  && (fanMinimumDutyCycleFactory < fanNominalDutyCycleFactory));

        //        qDebug() << ifaAdcZeroField << ifaAdcMinField << ifaAdcNomField;
        //        qDebug() << ifaVelMinField << ifaVelNomField;
        //        qDebug() << fanStandbyDutyCycleField;
        bool calibPhaseField = (((ifaAdcZeroField + 80) <= ifaAdcMinField)
                                && ((ifaAdcMinField + 80) <= ifaAdcNomField)
                                && (ifaVelMinField > 0)
                                && (ifaVelMinField < ifaVelNomField)
                                && (fanStandbyDutyCycleField > 0)
                                && (fanStandbyDutyCycleField < fanMinimumDutyCycleField)
                                && (fanMinimumDutyCycleField < fanNominalDutyCycleField));

        //        calibPhaseFactory = false;
        //        calibPhaseField = false;
        int calibPhase = calibPhaseField
                             ? MachineEnums::AF_CALIB_FIELD
                             : (calibPhaseFactory ? MachineEnums::AF_CALIB_FACTORY : MachineEnums::AF_CALIB_NONE);
        //        qDebug() << "calibPhase" << calibPhase;

#ifdef QT_DEBUG
        /// Testing purpose
        //        if (fanNominalDutyCycleFactory > 15) fanNominalDutyCycleFactory = 15;
        //        if (fanMinimumDutyCycleFactory > 10) fanMinimumDutyCycleFactory = 10;
        //        if (fanStandbyDutyCycleFactory > 5) fanStandbyDutyCycleFactory = 5;
        //        if (fanNominalDutyCycleField > 10) fanNominalDutyCycleField = 10;
        //        if (fanStandbyDutyCycleField > 5) fanStandbyDutyCycleField = 5;
#endif
        pData->setFanPrimaryNominalDutyCycleFactory(static_cast<short>(fanNominalDutyCycleFactory));
        pData->setFanPrimaryNominalRpmFactory(fanNominalRpmFactory);

        pData->setFanPrimaryMinimumDutyCycleFactory(static_cast<short>(fanMinimumDutyCycleFactory));
        pData->setFanPrimaryMinimumRpmFactory(fanMinimumRpmFactory);

        pData->setFanPrimaryStandbyDutyCycleFactory(static_cast<short>(fanStandbyDutyCycleFactory));
        pData->setFanPrimaryStandbyRpmFactory(fanStandbyRpmFactory);

        pData->setFanPrimaryNominalDutyCycleField(static_cast<short>(fanNominalDutyCycleField));
        pData->setFanPrimaryNominalRpmField(fanNominalRpmField);

        pData->setFanPrimaryMinimumDutyCycleField(static_cast<short>(fanMinimumDutyCycleField));
        pData->setFanPrimaryMinimumRpmField(fanMinimumRpmField);

        pData->setFanPrimaryStandbyDutyCycleField(static_cast<short>(fanStandbyDutyCycleField));
        pData->setFanPrimaryStandbyRpmField(fanStandbyRpmField);

        pData->setInflowSensorConstant(static_cast<short>(sensorConstant));
        pData->setInflowTempCalib(static_cast<short>(tempCalib));
        pData->setInflowTempCalibAdc(static_cast<short>(tempCalibAdc));

        pData->setInflowAdcPointFactory(0, ifaAdcZeroFactory);
        pData->setInflowAdcPointFactory(1, ifaAdcMinFactory);
        pData->setInflowAdcPointFactory(2, ifaAdcNomFactory);

        pData->setInflowVelocityPointFactory(1, ifaVelMinFactory);
        pData->setInflowVelocityPointFactory(2, ifaVelNomFactory);

        pData->setInflowLowLimitVelocity(ifaVelLowAlarm);

        pData->setInflowAdcPointField(0, ifaAdcZeroField);
        pData->setInflowAdcPointField(1, ifaAdcMinField);
        pData->setInflowAdcPointField(2, ifaAdcNomField);

        pData->setInflowVelocityPointField(1, ifaVelMinField);
        pData->setInflowVelocityPointField(2, ifaVelNomField);

        pData->setDownflowVelocityPointFactory(2, dfaVelNomFactory);
        pData->setDownflowVelocityPointField(2, dfaVelNomField);

        initAirflowCalibrationStatus(static_cast<short>(calibPhase));

        /// force generate velocity string
        _onInflowVelocityActualChanged(0);
        _calculteDownflowVelocity(0);

        for(int i = 0; i < MachineEnums::CalFactoryState_Total; i++){
            if( i == MachineEnums::CalFactoryState_InflowDimNominal || i == MachineEnums::CalFactoryState_DownflowNominal){
                if(!(fanMinimumDutyCycleFactory < fanNominalDutyCycleFactory)){
                    m_settings->setValue(SKEY_AIRFLOW_FACTORY_CALIB_STATE + QString::number(i), false);
                }
            }
            else if(i == MachineEnums::CalFactoryState_InflowDimMinimum){
                if(!(fanStandbyDutyCycleFactory < fanMinimumDutyCycleFactory)){
                    m_settings->setValue(SKEY_AIRFLOW_FACTORY_CALIB_STATE + QString::number(i), false);
                }
            }
            else if(i == MachineEnums::CalFactoryState_InflowDimStandby){
                if(!(fanStandbyDutyCycleFactory > 0)){
                    m_settings->setValue(SKEY_AIRFLOW_FACTORY_CALIB_STATE + QString::number(i), false);
                }
            }
            pData->setAirflowFactoryCalibrationState(i, m_settings->value(SKEY_AIRFLOW_FACTORY_CALIB_STATE + QString::number(i), false).toBool());
        }

        for(int i = 0; i < MachineEnums::CalFieldState_Total; i++){
            if( i == MachineEnums::CalFieldState_InflowDimNominal
                || i == MachineEnums::CalFieldState_InflowSecNominal
                || i == MachineEnums::CalFieldState_DownflowNominal){
                if(!(fanMinimumDutyCycleField < fanNominalDutyCycleField)){
                    m_settings->setValue(SKEY_AIRFLOW_FIELD_CALIB_STATE + QString::number(i), false);
                }
            }
            else if(i == MachineEnums::CalFieldState_AdcCalib){
                if(!(((ifaAdcZeroField + 80) <= ifaAdcMinField)
                      && ((ifaAdcMinField + 80) <= ifaAdcNomField))){
                    m_settings->setValue(SKEY_AIRFLOW_FIELD_CALIB_STATE + QString::number(i), false);
                }
            }
            pData->setAirflowFieldCalibrationState(i, m_settings->value(SKEY_AIRFLOW_FIELD_CALIB_STATE + QString::number(i), false).toBool());
        }
    }//

    ////// Output Auto Set
    /// UV SCHEDULER ON
    {
        m_uvSchedulerAutoSet.reset(new SchedulerDayOutput);

        bool enable    = m_settings->value(SKEY_SCHED_UV_ENABLE, false).toInt();
        int  time      = m_settings->value(SKEY_SCHED_UV_TIME, 480/*8:00 AM*/).toInt();
        int  repeat    = m_settings->value(SKEY_SCHED_UV_REPEAT, SchedulerDayOutput::DAYS_REPEAT_ONCE).toInt();
        int  repeatDay = m_settings->value(SKEY_SCHED_UV_REPEAT_DAY, SchedulerDayOutput::DAY_MONDAY).toInt();

        pData->setUVAutoEnabled(enable);
        pData->setUVAutoTime(time);
        pData->setUVAutoDayRepeat(repeat);
        pData->setUVAutoWeeklyDay(repeatDay);

        m_uvSchedulerAutoSet->setEnabled(enable);
        m_uvSchedulerAutoSet->setTime(time);
        m_uvSchedulerAutoSet->setDayRepeat(repeat);
        m_uvSchedulerAutoSet->setWeeklyDay(repeatDay);

        /// call this when schedulling spec is same
        QObject::connect(m_uvSchedulerAutoSet.data(), &SchedulerDayOutput::activated,
                         this, &MachineBackend::_onTriggeredUvSchedulerAutoSet);
    }//
    /// UV SCHEDULER OFF
    {
        m_uvSchedulerAutoSetOff.reset(new SchedulerDayOutput);

        bool enable    = m_settings->value(SKEY_SCHED_UV_ENABLE_OFF, false).toInt();
        int  time      = m_settings->value(SKEY_SCHED_UV_TIME_OFF, 490/*8:10 AM*/).toInt();
        int  repeat    = m_settings->value(SKEY_SCHED_UV_REPEAT_OFF, SchedulerDayOutput::DAYS_REPEAT_ONCE).toInt();
        int  repeatDay = m_settings->value(SKEY_SCHED_UV_REPEAT_DAY_OFF, SchedulerDayOutput::DAY_MONDAY).toInt();

        pData->setUVAutoEnabledOff(enable);
        pData->setUVAutoTimeOff(time);
        pData->setUVAutoDayRepeatOff(repeat);
        pData->setUVAutoWeeklyDayOff(repeatDay);

        m_uvSchedulerAutoSetOff->setEnabled(enable);
        m_uvSchedulerAutoSetOff->setTime(time);
        m_uvSchedulerAutoSetOff->setDayRepeat(repeat);
        m_uvSchedulerAutoSetOff->setWeeklyDay(repeatDay);

        /// call this when schedulling spec is same
        QObject::connect(m_uvSchedulerAutoSetOff.data(), &SchedulerDayOutput::activated,
                         this, &MachineBackend::_onTriggeredUvSchedulerAutoSetOff);
    }//

    /// LIGHT SCHEDULER ON
    {
        m_lightSchedulerAutoSet.reset(new SchedulerDayOutput);

        bool enable    = m_settings->value(SKEY_SCHED_LIGHT_ENABLE, false).toInt();
        int  time      = m_settings->value(SKEY_SCHED_LIGHT_TIME, 480/*8:00 AM*/).toInt();
        int  repeat    = m_settings->value(SKEY_SCHED_LIGHT_REPEAT, SchedulerDayOutput::DAYS_REPEAT_ONCE).toInt();
        int  repeatDay = m_settings->value(SKEY_SCHED_LIGHT_REPEAT_DAY, SchedulerDayOutput::DAY_MONDAY).toInt();

        pData->setLightAutoEnabled(enable);
        pData->setLightAutoTime(time);
        pData->setLightAutoDayRepeat(repeat);
        pData->setLightAutoWeeklyDay(repeatDay);

        m_lightSchedulerAutoSet->setEnabled(enable);
        m_lightSchedulerAutoSet->setTime(time);
        m_lightSchedulerAutoSet->setDayRepeat(repeat);
        m_lightSchedulerAutoSet->setWeeklyDay(repeatDay);

        /// call this when schedulling spec is the same
        QObject::connect(m_lightSchedulerAutoSet.data(), &SchedulerDayOutput::activated,
                         this, &MachineBackend::_onTriggeredLightSchedulerAutoSet);
    }//
    /// LIGHT SCHEDULER OFF
    {
        m_lightSchedulerAutoSetOff.reset(new SchedulerDayOutput);

        bool enable    = m_settings->value(SKEY_SCHED_LIGHT_ENABLE_OFF, false).toInt();
        int  time      = m_settings->value(SKEY_SCHED_LIGHT_TIME_OFF, 490/*8:10 AM*/).toInt();
        int  repeat    = m_settings->value(SKEY_SCHED_LIGHT_REPEAT_OFF, SchedulerDayOutput::DAYS_REPEAT_ONCE).toInt();
        int  repeatDay = m_settings->value(SKEY_SCHED_LIGHT_REPEAT_DAY_OFF, SchedulerDayOutput::DAY_MONDAY).toInt();

        pData->setLightAutoEnabledOff(enable);
        pData->setLightAutoTimeOff(time);
        pData->setLightAutoDayRepeatOff(repeat);
        pData->setLightAutoWeeklyDayOff(repeatDay);

        m_lightSchedulerAutoSetOff->setEnabled(enable);
        m_lightSchedulerAutoSetOff->setTime(time);
        m_lightSchedulerAutoSetOff->setDayRepeat(repeat);
        m_lightSchedulerAutoSetOff->setWeeklyDay(repeatDay);

        /// call this when schedulling spec is the same
        QObject::connect(m_lightSchedulerAutoSetOff.data(), &SchedulerDayOutput::activated,
                         this, &MachineBackend::_onTriggeredLightSchedulerAutoSetOff);
    }//
    /// SOCKET SCHEDULER ON
    {
        m_socketSchedulerAutoSet.reset(new SchedulerDayOutput);

        bool enable    = m_settings->value(SKEY_SCHED_SOCKET_ENABLE, false).toInt();
        int  time      = m_settings->value(SKEY_SCHED_SOCKET_TIME, 480/*8:00 AM*/).toInt();
        int  repeat    = m_settings->value(SKEY_SCHED_SOCKET_REPEAT, SchedulerDayOutput::DAYS_REPEAT_ONCE).toInt();
        int  repeatDay = m_settings->value(SKEY_SCHED_SOCKET_REPEAT_DAY, SchedulerDayOutput::DAY_MONDAY).toInt();

        pData->setSocketAutoEnabled(enable);
        pData->setSocketAutoTime(time);
        pData->setSocketAutoDayRepeat(repeat);
        pData->setSocketAutoWeeklyDay(repeatDay);

        m_socketSchedulerAutoSet->setEnabled(enable);
        m_socketSchedulerAutoSet->setTime(time);
        m_socketSchedulerAutoSet->setDayRepeat(repeat);
        m_socketSchedulerAutoSet->setWeeklyDay(repeatDay);

        /// call this when schedulling spec is the same
        QObject::connect(m_socketSchedulerAutoSet.data(), &SchedulerDayOutput::activated,
                         this, &MachineBackend::_onTriggeredSocketSchedulerAutoSet);
    }//
    /// SOCKET SCHEDULER OFF
    {
        m_socketSchedulerAutoSetOff.reset(new SchedulerDayOutput);

        bool enable    = m_settings->value(SKEY_SCHED_SOCKET_ENABLE_OFF, false).toInt();
        int  time      = m_settings->value(SKEY_SCHED_SOCKET_TIME_OFF, 490/*8:10 AM*/).toInt();
        int  repeat    = m_settings->value(SKEY_SCHED_SOCKET_REPEAT_OFF, SchedulerDayOutput::DAYS_REPEAT_ONCE).toInt();
        int  repeatDay = m_settings->value(SKEY_SCHED_SOCKET_REPEAT_DAY_OFF, SchedulerDayOutput::DAY_MONDAY).toInt();

        pData->setSocketAutoEnabledOff(enable);
        pData->setSocketAutoTimeOff(time);
        pData->setSocketAutoDayRepeatOff(repeat);
        pData->setSocketAutoWeeklyDayOff(repeatDay);

        m_socketSchedulerAutoSetOff->setEnabled(enable);
        m_socketSchedulerAutoSetOff->setTime(time);
        m_socketSchedulerAutoSetOff->setDayRepeat(repeat);
        m_socketSchedulerAutoSetOff->setWeeklyDay(repeatDay);

        /// call this when schedulling spec is the same
        QObject::connect(m_socketSchedulerAutoSetOff.data(), &SchedulerDayOutput::activated,
                         this, &MachineBackend::_onTriggeredSocketSchedulerAutoSetOff);
    }//
    /// FAN SCHEDULER ON
    {
        m_fanSchedulerAutoSet.reset(new SchedulerDayOutput);

        bool enable    = m_settings->value(SKEY_SCHED_FAN_ENABLE, false).toInt();
        int  time      = m_settings->value(SKEY_SCHED_FAN_TIME, 480/*8:00 AM*/).toInt();
        int  repeat    = m_settings->value(SKEY_SCHED_FAN_REPEAT, SchedulerDayOutput::DAYS_REPEAT_ONCE).toInt();
        int  repeatDay = m_settings->value(SKEY_SCHED_FAN_REPEAT_DAY, SchedulerDayOutput::DAY_MONDAY).toInt();

        pData->setFanAutoEnabled(enable);
        pData->setFanAutoTime(time);
        pData->setFanAutoDayRepeat(repeat);
        pData->setFanAutoWeeklyDay(repeatDay);

        m_fanSchedulerAutoSet->setEnabled(enable);
        m_fanSchedulerAutoSet->setTime(time);
        m_fanSchedulerAutoSet->setDayRepeat(repeat);
        m_fanSchedulerAutoSet->setWeeklyDay(repeatDay);

        /// call this when schedulling spec is the same
        QObject::connect(m_fanSchedulerAutoSet.data(), &SchedulerDayOutput::activated,
                         this, &MachineBackend::_onTriggeredFanSchedulerAutoSet);
    }//
    /// FAN SCHEDULER OFF
    {
        m_fanSchedulerAutoSetOff.reset(new SchedulerDayOutput);

        bool enable    = m_settings->value(SKEY_SCHED_FAN_ENABLE_OFF, false).toInt();
        int  time      = m_settings->value(SKEY_SCHED_FAN_TIME_OFF, 490/*8:10 AM*/).toInt();
        int  repeat    = m_settings->value(SKEY_SCHED_FAN_REPEAT_OFF, SchedulerDayOutput::DAYS_REPEAT_ONCE).toInt();
        int  repeatDay = m_settings->value(SKEY_SCHED_FAN_REPEAT_DAY_OFF, SchedulerDayOutput::DAY_MONDAY).toInt();

        pData->setFanAutoEnabledOff(enable);
        pData->setFanAutoTimeOff(time);
        pData->setFanAutoDayRepeatOff(repeat);
        pData->setFanAutoWeeklyDayOff(repeatDay);

        m_fanSchedulerAutoSetOff->setEnabled(enable);
        m_fanSchedulerAutoSetOff->setTime(time);
        m_fanSchedulerAutoSetOff->setDayRepeat(repeat);
        m_fanSchedulerAutoSetOff->setWeeklyDay(repeatDay);

        /// call this when schedulling spec is the same
        QObject::connect(m_fanSchedulerAutoSetOff.data(), &SchedulerDayOutput::activated,
                         this, &MachineBackend::_onTriggeredFanSchedulerAutoSetOff);
    }//

    /// DATA LOG
    {
        int enable = m_settings->value(SKEY_DATALOG_ENABLE, 1).toInt();
        int period = m_settings->value(SKEY_DATALOG_PERIOD, 10).toInt(); /// default every 10 minutes

        pData->setDataLogEnable(enable);
        pData->setDataLogPeriod(static_cast<short>(period));
        pData->setDataLogSpaceMaximum(DATALOG_MAX_ROW);

        m_timerEventForDataLog.reset(new QTimer);
        m_timerEventForDataLog->setInterval(period * 60 * 1000);
        ///
        QObject::connect(m_timerEventForDataLog.data(), &QTimer::timeout,
                         this, &MachineBackend::_insertDataLog);
        ///
        if(enable) {
            QObject::connect(this, &MachineBackend::loopStarted,
                             [&](){
                                 pData->setDataLogRunning(true);
                                 m_timerEventForDataLog->start();
                             });
        }//

        m_pDataLogSql.reset(new DataLogSql);
        m_pDataLog.reset(new DataLog);
        m_pDataLog->setPSqlInterface(m_pDataLogSql.data());

        QObject::connect(m_pDataLog.data(), &DataLog::rowCountChanged,
                         pData, &MachineData::setDataLogCount);
        QObject::connect(m_pDataLog.data(), &DataLog::setDataLogCount,
                         pData, &MachineData::setDataLogCount);
        QObject::connect(m_pDataLog.data(), &DataLog::setDataLogIsFull,
                         pData, &MachineData::setDataLogIsFull);

        m_threadForDatalog.reset(new QThread);
        /// move the object to extra thread, so every query will execute in the separated thread
        m_pDataLog->moveToThread(m_threadForDatalog.data());
        m_pDataLogSql->moveToThread(m_threadForDatalog.data());

        QObject::connect(m_threadForDatalog.data(), &QThread::started,
                         m_pDataLog.data(), [&](){
                             m_pDataLog->routineTask();
                         });
        QObject::connect(this, &MachineBackend::loopStarted,
                         [&](){
                             m_threadForDatalog->start();
                         });
    }

    /// ALARM LOG
    {
        m_pAlarmLogSql.reset(new AlarmLogSql);
        m_pAlarmLog.reset(new AlarmLog);
        m_pAlarmLog->setPSqlInterface(m_pAlarmLogSql.data());

        pData->setAlarmLogSpaceMaximum(ALARMEVENTLOG_MAX_ROW);

        QObject::connect(m_pAlarmLog.data(), &AlarmLog::rowCountChanged,
                         pData, &MachineData::setAlarmLogCount);
        QObject::connect(m_pAlarmLog.data(), &AlarmLog::setAlarmLogCount,
                         pData, &MachineData::setAlarmLogCount);
        QObject::connect(m_pAlarmLog.data(), &AlarmLog::setAlarmLogIsFull,
                         pData, &MachineData::setAlarmLogIsFull);

        m_threadForAlarmLog.reset(new QThread);
        /// move the object to extra thread, so every query will execute in the separated thread
        m_pAlarmLog->moveToThread(m_threadForAlarmLog.data());
        m_pAlarmLogSql->moveToThread(m_threadForAlarmLog.data());

        QObject::connect(m_threadForAlarmLog.data(), &QThread::started,
                         m_pAlarmLog.data(), [&](){
                             m_pAlarmLog->routineTask();
                         });
        QObject::connect(this, &MachineBackend::loopStarted,
                         [&](){
                             m_threadForAlarmLog->start();
                         });
    }

    /// EVENT LOG
    {
        m_pEventLogSql.reset(new EventLogSql);
        m_pEventLog.reset(new EventLog);
        m_pEventLog->setPSqlInterface(m_pEventLogSql.data());

        pData->setEventLogSpaceMaximum(ALARMEVENTLOG_MAX_ROW);

        QObject::connect(m_pEventLog.data(), &EventLog::rowCountChanged,
                         pData, &MachineData::setEventLogCount);
        QObject::connect(m_pEventLog.data(), &EventLog::setEventLogCount,
                         pData, &MachineData::setEventLogCount);
        QObject::connect(m_pEventLog.data(), &EventLog::setEventLogIsFull,
                         pData, &MachineData::setEventLogIsFull);

        m_threadForEventLog.reset(new QThread);
        /// move the object to extra thread, so every query will execute in the separated thread
        m_pEventLog->moveToThread(m_threadForEventLog.data());
        m_pEventLogSql->moveToThread(m_threadForEventLog.data());

        QObject::connect(m_threadForEventLog.data(), &QThread::started,
                         m_pEventLog.data(), [&](){
                             m_pEventLog->routineTask();
                         });
        QObject::connect(this, &MachineBackend::loopStarted,
                         [&](){
                             m_threadForEventLog->start();
                         });
    }

    /// REPLACEABLECOMPONENT LOG
    {
        m_pReplaceableCompRecordSql.reset(new ReplaceableCompRecordSql);
        m_pReplaceableCompRecord.reset(new ReplaceableCompRecord);
        m_pReplaceableCompRecord->setPSqlInterface(m_pReplaceableCompRecordSql.data());

        pData->setReplaceableCompRecordSpaceMaximum(ALARMREPLACEABLECOMPRECORD_MAX_ROW);


        QObject::connect(m_pReplaceableCompRecord.data(), &ReplaceableCompRecord::rowCountChanged,
                         pData, &MachineData::setReplaceableCompRecordCount);
        QObject::connect(m_pReplaceableCompRecord.data(), &ReplaceableCompRecord::setReplaceableCompRecordCount,
                         pData, &MachineData::setReplaceableCompRecordCount);
        QObject::connect(m_pReplaceableCompRecord.data(), &ReplaceableCompRecord::setReplaceableCompRecordIsFull,
                         pData, &MachineData::setReplaceableCompRecordIsFull);
        QObject::connect(m_pReplaceableCompRecord.data(), &ReplaceableCompRecord::rpListSelectedChanged,
                         this, [&](QVariantList value){
                             pData->setRpListSelected(value);
                         });

        m_threadForReplaceableCompRecord.reset(new QThread);
        /// move the object to extra thread, so every query will execute in the separated thread
        m_pReplaceableCompRecord->moveToThread(m_threadForReplaceableCompRecord.data());
        m_pReplaceableCompRecordSql->moveToThread(m_threadForReplaceableCompRecord.data());

        QObject::connect(m_threadForReplaceableCompRecord.data(), &QThread::started,
                         m_pReplaceableCompRecord.data(), [&](){
                             m_pReplaceableCompRecord->routineTask();
                         });
        QObject::connect(this, &MachineBackend::loopStarted,
                         [&](){
                             m_threadForReplaceableCompRecord->start();
                         });

        for(short i=0; i<MachineEnums::RPList_Total; i++)
            m_rpListSettings[i] =  m_pReplaceableCompRecordSql->getParameterStringFromIndex(i);


        const QJsonObject dbDefault = _getRpListDefaultJsonObj();

        m_settings->beginGroup("rplist");
        for(short i=1; i < MachineEnums::RPList_Total; i++){
            QString defaultValue = _getRpListDefaultValue(dbDefault, i);
            pData->setRpListLast(i, m_settings->value(m_rpListSettings[i], defaultValue).toString());
            pData->setRpListSelected(i, "");
            //            qDebug() << i << pData->getRpListLastAtIndex(i);
        }//
        m_settings->endGroup();

        //initReplaceablePartsSettings();
    }//

    /// RESOURCE MONITOR LOG
    {
        qDebug() << "@@@ RESOURCE MONITOR LOG!";
        bool enable = m_settings->value(SKEY_RESMONLOG_ENABLE, false).toBool();
        int period = m_settings->value(SKEY_RESMONLOG_PERIOD, 10).toInt(); /// default every 10 minutes

        pData->setResourceMonitorLogEnable(enable);
        pData->setResourceMonitorLogPeriod(static_cast<short>(period));
        pData->setResourceMonitorLogSpaceMaximum(RESMONLOG_MAX_ROW);

        m_timerEventForResourceMonitorLog.reset(new QTimer);
        m_timerEventForResourceMonitorLog->setInterval(period * 60 * 1000);
        ///
        QObject::connect(m_timerEventForResourceMonitorLog.data(), &QTimer::timeout,
                         this, &MachineBackend::_insertResourceMonitorLog);
        ///
        if(enable) {
            QObject::connect(this, &MachineBackend::loopStarted,
                             [&](){
                                 pData->setResourceMonitorLogRunning(true);
                                 m_timerEventForResourceMonitorLog->start();
                             });
        }//

        m_pResourceMonitorLogSql.reset(new ResourceMonitorLogSql);
        m_pResourceMonitorLog.reset(new ResourceMonitorLog);
        m_pResourceMonitorLog->setPSqlInterface(m_pResourceMonitorLogSql.data());

        QObject::connect(m_pResourceMonitorLog.data(), &ResourceMonitorLog::rowCountChanged,
                         pData, &MachineData::setResourceMonitorLogCount);
        QObject::connect(m_pResourceMonitorLog.data(), &ResourceMonitorLog::setResourceMonitorLogCount,
                         pData, &MachineData::setResourceMonitorLogCount);
        QObject::connect(m_pResourceMonitorLog.data(), &ResourceMonitorLog::setResourceMonitorLogIsFull,
                         pData, &MachineData::setResourceMonitorLogIsFull);

        m_threadForResourceMonitorLog.reset(new QThread);
        /// move the object to extra thread, so every query will execute in the separated thread
        m_pResourceMonitorLog->moveToThread(m_threadForResourceMonitorLog.data());
        m_pResourceMonitorLogSql->moveToThread(m_threadForResourceMonitorLog.data());

        QObject::connect(m_threadForResourceMonitorLog.data(), &QThread::started,
                         m_pResourceMonitorLog.data(), [&](){
                             qDebug() << "@@@ m_threadForResourceMonitorLog is started!";
                             m_pResourceMonitorLog->checkUSdCardIndustrialType();
                             m_pResourceMonitorLog->routineTask();
                         });
        QObject::connect(m_pResourceMonitorLog.data(), &ResourceMonitorLog::uSdCardIndustrialTypeChanged,
                         pData, &MachineData::setUSdCardIndustrial);

        QObject::connect(this, &MachineBackend::loopStarted,
                         [&](){
                             qDebug() << "@@@ m_threadForResourceMonitorLog->start()";
                             m_threadForResourceMonitorLog->start();
                         });
    }//

    /// BOOKING SCHEDULE
    {
        pData->setBookingScheduleNotifEnable(m_settings->value(SKEY_BOOKED_SCHEDULE_NOTIF_EN, false).toBool());
        pData->setBookingScheduleNotifTime(m_settings->value(SKEY_BOOKED_SCHEDULE_NOTIF_TM, 60).toInt());
        pData->setBookingScheduleNotifCollapse(m_settings->value(SKEY_BOOKED_SCHEDULE_NOTIF_COL, false).toBool());

        m_pBookingScheduleSql.reset(new BookingScheduleSql);
        m_pBookingSchedule.reset(new BookingSchedule);
        m_pBookingSchedule->setPSqlInterface(m_pBookingScheduleSql.data());

        m_threadForBookingSchedule.reset(new QThread);

        QObject::connect(m_threadForBookingSchedule.data(), &QThread::started,
                         m_pBookingSchedule.data(), [&](){
                             m_pBookingSchedule->routineTask();
                         });
        QObject::connect(m_pBookingSchedule.data(), &BookingSchedule::hasInitialized,
                         this, [&](){
                             QDate qDate = QDate().currentDate();
                             m_currentDateStr = qDate.toString("yyyy-MM-dd");
                             //qDebug() << "selectByDate" << m_currentDateStr;
                             m_pBookingSchedule->selectByDate(m_currentDateStr);
                         });

        QObject::connect(this, &MachineBackend::loopStarted,
                         [&](){
                             m_threadForBookingSchedule->start();
                         });

        QObject::connect(m_pBookingSchedule.data(), &BookingSchedule::selectHasDone,
                         this, [&](bool success, QVariantList logBuffer, int total){
                             Q_UNUSED(total)
                             Q_UNUSED(success)
                             Q_UNUSED(logBuffer)
                             // qDebug() << logBuffer/*.length()*/;

                             QVariantList itemTemp;

                             for(short i = 0; i< logBuffer.length(); i++){
                                 QVariantMap item;
                                 QString username = logBuffer.at(i).toMap().value("username").toString();

                                 if(!username.isEmpty()){
                                     item.insert("bookByUsername", username);
                                     item.insert("bookForName",    logBuffer.at(i).toMap().value("bookBy").toString());
                                     item.insert("bookTitle",      logBuffer.at(i).toMap().value("bookTitle").toString());
                                     item.insert("time",           logBuffer.at(i).toMap().value("time").toString());
                                     item.insert("notifActive",    false);
                                     item.insert("acknowledge",    false);
                                     itemTemp.append(item);
                                 }
                             }
                             /// Filter Database
                             /// Only take a booked schedule
                             //qDebug() << itemTemp;
                             pData->setBookingScheduleTodayVarList(itemTemp);

                             refreshBookScheduleNotifDisplay();
                         });

        QObject::connect(this, &MachineBackend::currentDateStrChanged,
                         m_pBookingSchedule.data(), [&](const QString &currDateStr){
                             //qDebug() << "currentDateStrChanged" << currDateStr;
                             m_pBookingSchedule->selectByDate(currDateStr);
                         });

        /// move the object to extra thread, so every query will execute in the separated thread
        m_pBookingSchedule->moveToThread(m_threadForBookingSchedule.data());
        m_pBookingScheduleSql->moveToThread(m_threadForBookingSchedule.data());
    }

    /// Sensor Warming up
    {
        int seconds = m_settings->value(SKEY_WARMUP_TIME, 180).toInt(); //3 minutes
        pData->setWarmingUpTime(seconds);
        pData->setWarmingUpCountdown(seconds);
    }

    /// Post purging
    {
        int seconds = m_settings->value(SKEY_POSTPURGE_TIME, 0).toInt(); //0 minutes, disabled
        pData->setPostPurgingTime(seconds);
        pData->setPostPurgingCountdown(seconds);
    }

    /// Filter Meter
    {
        int mode    = m_settings->value(SKEY_FILTER_METER_MODE,     MachineEnums::FilterLifeCalc_BlowerUsage).toInt();
        int minTime = m_settings->value(SKEY_FILTER_METER_MIN_TIME, SDEF_FILTER_MINIMUM_TIME_LIFE).toInt();
        int maxTime = m_settings->value(SKEY_FILTER_METER_MAX_TIME, SDEF_FILTER_MAXIMUM_TIME_LIFE).toInt();
        int minRpm  = m_settings->value(SKEY_FILTER_METER_MIN_RPM,  SDEF_FILTER_MINIMUM_RPM_LIFE).toInt();
        int maxRpm  = m_settings->value(SKEY_FILTER_METER_MAX_RPM,  SDEF_FILTER_MAXIMUM_RPM_LIFE).toInt();

        int lifeMinutes = m_settings->value(SKEY_FILTER_METER_MIN,  SDEF_FILTER_MAXIMUM_TIME_LIFE).toInt();
        int currentRpmNom = m_settings->value(SKEY_FILTER_METER_RPM, SDEF_FILTER_MINIMUM_RPM_LIFE).toInt(); ///Current Nominal RPM

        int percentLeft = 100;
        if(mode == MachineEnums::FilterLifeCalc_BlowerRpm){
            percentLeft = 100 - qRound(__map(currentRpmNom, minRpm, maxRpm, 0, 100));
        }
        else{
            percentLeft = __getPercentFrom(lifeMinutes, maxTime);
        }

        /// event if in % value is zero but the minutes more then 0 minutes, then set % to 1
        if (percentLeft == 0 && lifeMinutes > 0) percentLeft = 1;

        //update to global observable variable
        pData->setFilterLifeMinutes(lifeMinutes);
        pData->setFilterLifeRpm(currentRpmNom);
        if(percentLeft > 100){
            percentLeft = 100;
        }
        if(percentLeft < 0){
            percentLeft = 0;
        }

        QObject::connect(pData, &MachineData::filterLifePercentChanged,
                         this, [&](short value){
                             ///MODBUS
                             _setModbusRegHoldingValue(modbusRegisterAddress.FilterLife.addr, static_cast<ushort>(value));
                             if((value < 10) && pData->getFilterLifeDisplayEnabled())
                                 pData->setFilterLifeReminder(true);
                             else
                                 pData->setFilterLifeReminder(false);
                         });

        pData->setFilterLifePercent(static_cast<short>(percentLeft));

        pData->setFilterLifeCalculationMode(mode);
        pData->setFilterLifeMinimumBlowerUsageMode(minTime);
        pData->setFilterLifeMaximumBlowerUsageMode(maxTime);
        pData->setFilterLifeMinimumBlowerRpmMode(minRpm);
        pData->setFilterLifeMaximumBlowerRpmMode(maxRpm);        

        /// Setup variable buffer for fan rpm (moving average)
        {
            m_fanPrimaryRpmActualBuffer.reset(new QVector<uint16_t>);
            /// reset the buffer value
            m_fanPrimaryRpmActualBuffer->clear();
        }
    }//

    /// Sash Cycle Meter
    {
        /// the formula for the sash cycle value for tubular motor is
        /// Every attached break point if the previous sash state is safe height, will be increase 0.5 step
        /// in the program value will counting
        int cycle = m_settings->value(SKEY_SASH_CYCLE_METER, MachineEnums::DIG_STATE_ZERO).toInt();

        //update to global observable variable
        pData->setSashCycleMeter(cycle);

        ///MODBUS
        _setModbusRegHoldingValue(modbusRegisterAddress.SashCycle.addr, static_cast<ushort>(cycle/10));
    }

    /// FAN Usage Meter
    {
        int minutes = m_settings->value(SKEY_FAN_METER, MachineEnums::DIG_STATE_ZERO).toInt();
        //        minutes = 1000;

        //update to global observable variable
        pData->setFanUsageMeter(minutes);
    }

    /// Mute Audible Alarm (Default 5 Minutes by Alex Atmadji)
    {
        int seconds = m_settings->value(SKEY_MUTE_ALARM_TIME, 300).toInt(); //5 minutes
        int secondsFo = m_settings->value(SKEY_MUTE_ALARM_TIME_FO, 300).toInt(); //5 minutes
        //        minutes = 1;
        pData->setMuteAlarmTime(seconds);
        pData->setMuteAlarmTimeAtFullyOpened(secondsFo);
        pData->setMuteAlarmCountdown(seconds);
    }

    /// Serial Number
    {
        QString year_sn = QDate::currentDate().toString("yyyy-000000");
        QString sn = m_settings->value(SKEY_SERIAL_NUMMBER, year_sn).toString();
        pData->setSerialNumber(sn);
        qDebug() << "Serial Number: " << sn;
    }

    /// JUST TIMER for triggering action by time
    {
        if(pData->getHydraulicMotorizedInstalled()){
            m_timerEventEvery50MSecond.reset(new QTimer);
            m_timerEventEvery50MSecond->setInterval(std::chrono::milliseconds(50));

            QObject::connect(m_timerEventEvery50MSecond.data(), &QTimer::timeout,
                             this, &MachineBackend::_onTriggeredEventEvery50MSecond);
            QObject::connect(this, &MachineBackend::loopStarted, [&](){
                m_timerEventEvery50MSecond->start();
            });
        }
        m_timerEventEverySecond.reset(new QTimer);
        m_timerEventEverySecond->setInterval(std::chrono::seconds(1));

        QObject::connect(m_timerEventEverySecond.data(), &QTimer::timeout,
                         this, &MachineBackend::_onTriggeredEventEverySecond);
        QObject::connect(this, &MachineBackend::loopStarted, [&]{
            m_timerEventEverySecond->start();
        });

        m_timerEventEveryMinute.reset(new QTimer);
        m_timerEventEveryMinute->setInterval(std::chrono::minutes(1));

        QObject::connect(m_timerEventEveryMinute.data(), &QTimer::timeout,
                         this, &MachineBackend::_onTriggeredEventEveryMinute);
        //        QObject::connect(this, &MachineBackend::loopStarted, [&]{
        //            m_timerEventEveryMinute->start();
        //        });

        m_timerEventEveryHalfHour.reset(new QTimer);
        m_timerEventEveryHalfHour->setInterval(std::chrono::minutes(30));

        QObject::connect(m_timerEventEveryHalfHour.data(), &QTimer::timeout,
                         this, &MachineBackend::_onTriggeredEventEveryHalfHour);
        QObject::connect(this, &MachineBackend::loopStarted, [&]{
            m_timerEventEveryHalfHour->start();
        });

        m_timerEventEveryHour.reset(new QTimer);
        m_timerEventEveryHour->setInterval(std::chrono::hours(1));

        QObject::connect(m_timerEventEveryHour.data(), &QTimer::timeout,
                         this, &MachineBackend::_onTriggeredEventEveryHour);
        QObject::connect(this, &MachineBackend::loopStarted, [&]{
            m_timerEventEveryHour->start();
        });
    }//

    ///Shipping Mode
    {
        bool shippingMode = m_settings->value(SKEY_SHIPPING_MOD_ENABLE, MachineEnums::DIG_STATE_ZERO).toInt();
        pData->setShippingModeEnable(shippingMode);
        //if(shippingMode){
        //    pData->setOperationMode(MachineEnums::MODE_OPERATION_MAINTENANCE);
        //}//
    }//

    //// Don't care power outage while shipping mode active
    if(!pData->getShippingModeEnable()){
        /// Power outage
        {
            int poweroutage = m_settings->value(SKEY_POWER_OUTAGE, MachineEnums::DIG_STATE_ZERO).toInt();
            m_settings->setValue(SKEY_POWER_OUTAGE, MachineEnums::DIG_STATE_ZERO);
            //        qDebug() << __func__ << "poweroutage" << poweroutage;

            int uvState    = m_settings->value(SKEY_POWER_OUTAGE_UV, MachineEnums::DIG_STATE_ZERO).toInt();
            //        qDebug() << SKEY_POWER_OUTAGE_UV << uvState;
            /// clear the flag
            m_settings->setValue(SKEY_POWER_OUTAGE_UV, MachineEnums::DIG_STATE_ZERO);
            pData->setPowerOutageUvState(static_cast<short>(uvState));

            int fanState   = m_settings->value(SKEY_POWER_OUTAGE_FAN, MachineEnums::DIG_STATE_ZERO).toInt();
            //        qDebug() << SKEY_POWER_OUTAGE_FAN << uvState;
            /// clear the flag
            m_settings->setValue(SKEY_POWER_OUTAGE_FAN, MachineEnums::DIG_STATE_ZERO);
            pData->setPowerOutageFanState(static_cast<short>(fanState));


            //update to global observable variable
            if(poweroutage) {
                QString poweroutageTime = m_settings->value(SKEY_POWER_OUTAGE_TIME, "").toString();
                QString poweroutageRecoverTime = QDateTime().currentDateTime().toString("dd-MMM-yyyy hh:mm");
                //            qDebug() << "poweroutageTime:" << poweroutageTime << "poweroutageRecoverTime: " << poweroutageRecoverTime;

                ///event log
                QString failureMsg = _tr(EVENT_STR_POWER_FAILURE) + " " + poweroutageTime;
                _insertEventLog(failureMsg);
                _insertAlarmLog(ALARM_LOG_CODE::ALC_POWER_FAILURE_ALARM, _tr(ALARM_LOG_TEXT_POWER_FAILURE_ALARM));

                pData->setPowerOutage(poweroutage);
                pData->setPowerOutageTime(poweroutageTime);
                pData->setPowerOutageRecoverTime(poweroutageRecoverTime);

                if(pData->getSashWindowMotorizeUpInterlocked()){
                    m_pHydraulicMotorize->setInterlockUp(MachineEnums::DIG_STATE_ZERO);
                }

                if(pData->getSashWindowMotorizeDownInterlocked()){
                    m_pHydraulicMotorize->setInterlockDown(MachineEnums::DIG_STATE_ZERO);
                }

                switch (pData->getSashWindowState()) {
                case MachineEnums::SASH_STATE_ERROR_SENSOR_SSV:
                    /// NOTHING TODO
                    break;
                case MachineEnums::SASH_STATE_FULLY_CLOSE_SSV:
                {
                    m_pUV->setState(uvState);
                }
                break;
                default:
                {
                    if(fanState) {
                        short dutyCycle = pData->getFanPrimaryNominalDutyCycle();
                        switch (fanState) {
                        case MachineEnums::FAN_STATE_ON:
                            /// The Light is Off during Warming UP,
                            /// No need to turn on the light at this stage
                            /// Force turned on light if the blower is nominal
                            //m_pLight->setInterlock(MachineEnums::DIG_STATE_ZERO);
                            //m_pLight->setState(MachineEnums::DIG_STATE_ONE);
                            //m_pLight->routineTask();
                            //m_i2cPort->sendOutQueue();
                            break;
                        case MachineEnums::FAN_STATE_STANDBY:
                            dutyCycle = pData->getFanPrimaryStandbyDutyCycle();
                            break;
                        }

                        m_pFanPrimary->setDutyCycle(pData->getFanPrimaryNominalDutyCycle());
                        m_pFanPrimary->routineTask();
                        /// wait until fan actually turned on or exceed the time out (10 seconds)
                        for (int var = 0; var < 10; ++var) {
                            m_pFanPrimary->routineTask();
                            if(m_pFanPrimary->dutyCycle() == dutyCycle){
                                //                            qDebug() << __func__ << "Power outage - Fan State Changed" << var;
                                _onFanPrimaryActualDucyChanged(dutyCycle);
                                break;
                            }
                            QThread::sleep(1);
                        }
                    }
                }
                break;
                }
            }
            if(uvState && (pData->getSashWindowState() != MachineEnums::SASH_STATE_FULLY_CLOSE_SSV))
                _setUvTimeCountdown(pData->getUvTime() * 60);
        }//
    }//

    //    _initPreventMaintReminder();
    {
        QDateTime nowDateTime = QDateTime().currentDateTime();
        //        QString curDateTimeStr = nowDateTime.toString("dd-MM-yyyy hh:mm:ss");
        QString curDateTimeStr = "01-01-2000 00:00:00";

        QString daily       = m_settings->value(SKEY_PM_LAST_ACK_DAILY, curDateTimeStr).toString();
        QString weekly      = m_settings->value(SKEY_PM_LAST_ACK_WEEKLY, curDateTimeStr).toString();
        QString monthly     = m_settings->value(SKEY_PM_LAST_ACK_MONTHLY, curDateTimeStr).toString();
        QString quarterly   = m_settings->value(SKEY_PM_LAST_ACK_QUARTERLY, curDateTimeStr).toString();
        QString annually    = m_settings->value(SKEY_PM_LAST_ACK_ANNUALLY, curDateTimeStr).toString();
        QString biennially  = m_settings->value(SKEY_PM_LAST_ACK_BIENNIALLY, curDateTimeStr).toString();
        QString quinquennially = m_settings->value(SKEY_PM_LAST_ACK_QUINQUENNIALLY, curDateTimeStr).toString();
        QString canopy      = m_settings->value(SKEY_PM_LAST_ACK_CANOPY, curDateTimeStr).toString();

        int dailyRemindBefore       = m_settings->value(SKEY_PM_REMIND_BEFORE_DAILY, 82800).toInt();
        int weeklyRemindBefore      = m_settings->value(SKEY_PM_REMIND_BEFORE_WEEKLY, 2).toInt();
        int monthlyRemindBefore     = m_settings->value(SKEY_PM_REMIND_BEFORE_MONTHLY, 7).toInt();
        int quarterlyRemindBefore   = m_settings->value(SKEY_PM_REMIND_BEFORE_QUARTERLY, 14).toInt();
        int annuallyRemindBefore    = m_settings->value(SKEY_PM_REMIND_BEFORE_ANNUALLY, 30).toInt();
        int bienniallyRemindBefore  = m_settings->value(SKEY_PM_REMIND_BEFORE_BIENNIALLY, 30).toInt();
        int quinquenniallyRemindBefore = m_settings->value(SKEY_PM_REMIND_BEFORE_QUINQUENNIALLY, 30).toInt();
        int canopyRemindBefore      = m_settings->value(SKEY_PM_REMIND_BEFORE_CANOPY, 7).toInt();

        //        qDebug() << "Current Date:";
        //        qDebug() << curDateTimeStr;
        //        qDebug() << "Last PM Acknowledge:";
        //        qDebug() << daily;
        //        qDebug() << weekly;
        //        qDebug() << monthly;
        //        qDebug() << quarterly;
        //        qDebug() << annually;
        //        qDebug() << biennially;
        //        qDebug() << quinquennially;
        //        qDebug() << canopy;

        ushort dfault = (MachineEnums::PM_QUARTERLY_CODE |
                         MachineEnums::PM_ANNUALLY_CODE |
                         MachineEnums::PM_BIENNIALLY_CODE |
                         MachineEnums::PM_QUINQUENNIALLY_CODE /*|MachineEnums::PM_CANOPY_CODE*/);

        ushort alarmEn = static_cast<ushort>(m_settings->value(SKEY_PM_ALARM_EN, dfault).toInt());

        //        qDebug() << "Default & AlarmEnable:";
        //        qDebug() << dfault << alarmEn;

        pData->setAlarmPreventMaintStateEnable(alarmEn);

        pData->setDailyPreventMaintLastAckDate(daily);
        pData->setWeeklyPreventMaintLastAckDate(weekly);
        pData->setMonthlyPreventMaintLastAckDate(monthly);
        pData->setQuarterlyPreventMaintLastAckDate(quarterly);
        pData->setAnnuallyPreventMaintLastAckDate(annually);
        pData->setBienniallyPreventMaintLastAckDate(biennially);
        pData->setQuinquenniallyPreventMaintLastAckDate(quinquennially);
        pData->setCanopyPreventMaintLastAckDate(canopy);

        pData->setDailyPreventMaintRemindBefore(dailyRemindBefore);
        pData->setWeeklyPreventMaintRemindBefore(weeklyRemindBefore);
        pData->setMonthlyPreventMaintRemindBefore(monthlyRemindBefore);
        pData->setQuarterlyPreventMaintRemindBefore(quarterlyRemindBefore);
        pData->setAnnuallyPreventMaintRemindBefore(annuallyRemindBefore);
        pData->setBienniallyPreventMaintRemindBefore(bienniallyRemindBefore);
        pData->setQuinquenniallyPreventMaintRemindBefore(quinquenniallyRemindBefore);
        pData->setCanopyPreventMaintRemindBefore(canopyRemindBefore);
        ///////
        QDateTime lastAckDailyDateTime = QDateTime().fromString(daily, "dd-MM-yyyy hh:mm:ss");
        QDateTime lastAckWeeklyDateTime = QDateTime().fromString(weekly, "dd-MM-yyyy hh:mm:ss");
        QDateTime lastAckMonthlyDateTime = QDateTime().fromString(monthly, "dd-MM-yyyy hh:mm:ss");
        QDateTime lastAckQuarterlyDateTime = QDateTime().fromString(quarterly, "dd-MM-yyyy hh:mm:ss");
        QDateTime lastAckAnnuallyDateTime = QDateTime().fromString(annually, "dd-MM-yyyy hh:mm:ss");
        QDateTime lastAckBienniallyDateTime = QDateTime().fromString(biennially, "dd-MM-yyyy hh:mm:ss");
        QDateTime lastAckQuinquenniallyDateTime = QDateTime().fromString(quinquennially, "dd-MM-yyyy hh:mm:ss");
        QDateTime lastAckCanopyDateTime = QDateTime().fromString(canopy, "dd-MM-yyyy hh:mm:ss");

        QDateTime dueDateTimeDaily = lastAckDailyDateTime.addDays(1);
        QDateTime dueDateTimeWeekly = lastAckWeeklyDateTime.addDays(7);
        QDateTime dueDateTimeMonthly = lastAckMonthlyDateTime.addMonths(1);
        QDateTime dueDateTimeQuarterly = lastAckQuarterlyDateTime.addMonths(3);
        QDateTime dueDateTimeAnnually = lastAckAnnuallyDateTime.addYears(1);
        QDateTime dueDateTimeBiennially = lastAckBienniallyDateTime.addYears(2);
        QDateTime dueDateTimeQuinquennially = lastAckQuinquenniallyDateTime.addYears(5);
        QDateTime dueDateTimeCanopy = lastAckCanopyDateTime.addMonths(1);

        //        qDebug() << "Due date for acknowledging:";
        //        qDebug() << dueDateTimeDaily.toString("dd-MM-yyyy hh:mm:ss");
        //        qDebug() << dueDateTimeWeekly.toString("dd-MM-yyyy hh:mm:ss");
        //        qDebug() << dueDateTimeMonthly.toString("dd-MM-yyyy hh:mm:ss");
        //        qDebug() << dueDateTimeQuarterly.toString("dd-MM-yyyy hh:mm:ss");
        //        qDebug() << dueDateTimeAnnually.toString("dd-MM-yyyy hh:mm:ss");
        //        qDebug() << dueDateTimeBiennially.toString("dd-MM-yyyy hh:mm:ss");
        //        qDebug() << dueDateTimeQuinquennially.toString("dd-MM-yyyy hh:mm:ss");
        //        qDebug() << dueDateTimeCanopy.toString("dd-MM-yyyy hh:mm:ss");

        pData->setDailyPreventMaintAckDueDate(dueDateTimeDaily.toString("dd-MM-yyyy hh:mm:ss"));
        pData->setWeeklyPreventMaintAckDueDate(dueDateTimeWeekly.toString("dd-MM-yyyy hh:mm:ss"));
        pData->setMonthlyPreventMaintAckDueDate(dueDateTimeMonthly.toString("dd-MM-yyyy hh:mm:ss"));
        pData->setQuarterlyPreventMaintAckDueDate(dueDateTimeQuarterly.toString("dd-MM-yyyy hh:mm:ss"));
        pData->setAnnuallyPreventMaintAckDueDate(dueDateTimeAnnually.toString("dd-MM-yyyy hh:mm:ss"));
        pData->setBienniallyPreventMaintAckDueDate(dueDateTimeBiennially.toString("dd-MM-yyyy hh:mm:ss"));
        pData->setQuinquenniallyPreventMaintAckDueDate(dueDateTimeQuinquennially.toString("dd-MM-yyyy hh:mm:ss"));
        pData->setCanopyPreventMaintAckDueDate(dueDateTimeCanopy.toString("dd-MM-yyyy hh:mm:ss"));

        _refreshAlarmPreventMaint();
        //        ushort alarmPm = 0;
        //        qint64 dayLeft = 0;
        //        if(alarmEn & MachineEnums::PM_DAILY_CODE){
        //            dayLeft = nowDateTime.secsTo(dueDateTimeDaily);
        //            if(dayLeft <= dailyRemindBefore) alarmPm |= MachineEnums::PM_DAILY_CODE; /// Activate the alarm when time left less than 6 hours
        //            //            qDebug() << "secsLeft:" << dayLeft;
        //        }
        //        if(alarmEn & MachineEnums::PM_WEEKLY_CODE){
        //            dayLeft = nowDateTime.daysTo(dueDateTimeWeekly);
        //            if(dayLeft <= weeklyRemindBefore) alarmPm |= MachineEnums::PM_WEEKLY_CODE;
        //            //            qDebug() << "dayLeft:" << dayLeft;
        //        }
        //        if(alarmEn & MachineEnums::PM_MONTHLY_CODE){
        //            dayLeft = nowDateTime.daysTo(dueDateTimeMonthly);
        //            if(dayLeft < monthlyRemindBefore) alarmPm |= MachineEnums::PM_MONTHLY_CODE;
        //            //            qDebug() << "dayLeft:" << dayLeft;
        //        }
        //        if(alarmEn & MachineEnums::PM_QUARTERLY_CODE){
        //            dayLeft = nowDateTime.daysTo(dueDateTimeQuarterly);
        //            if(dayLeft < quarterlyRemindBefore) alarmPm |= MachineEnums::PM_QUARTERLY_CODE;
        //            //            qDebug() << "dayLeft:" << dayLeft;
        //        }
        //        if(alarmEn & MachineEnums::PM_ANNUALLY_CODE){
        //            dayLeft = nowDateTime.daysTo(dueDateTimeAnnually);
        //            if(dayLeft < annuallyRemindBefore) alarmPm |= MachineEnums::PM_ANNUALLY_CODE;
        //            //            qDebug() << "dayLeft:" << dayLeft;
        //        }
        //        if(alarmEn & MachineEnums::PM_BIENNIALLY_CODE){
        //            dayLeft = nowDateTime.daysTo(dueDateTimeBiennially);
        //            if(dayLeft < bienniallyRemindBefore) alarmPm |= MachineEnums::PM_BIENNIALLY_CODE;
        //            //            qDebug() << "dayLeft:" << dayLeft;
        //        }
        //        if(alarmEn & MachineEnums::PM_QUINQUENNIALLY_CODE){
        //            dayLeft = nowDateTime.daysTo(dueDateTimeQuinquennially);
        //            if(dayLeft < quinquenniallyRemindBefore) alarmPm |= MachineEnums::PM_QUINQUENNIALLY_CODE;
        //            //            qDebug() << "dayLeft:" << dayLeft;
        //        }
        //        if(alarmEn & MachineEnums::PM_CANOPY_CODE){
        //            dayLeft = nowDateTime.daysTo(dueDateTimeCanopy);
        //            if(dayLeft < canopyRemindBefore) alarmPm |= MachineEnums::PM_CANOPY_CODE;
        //            //            qDebug() << "dayLeft:" << dayLeft;
        //        }

        //        //        qDebug() << "Alarm PM:" << alarmPm;
        //        pData->setAlarmPreventMaintState(alarmPm);
    }

    /// User Last Login
    {
        QJsonArray userLastLoginArr = m_settings->value(SKEY_USER_LAST_LOGIN, QJsonArray()).toJsonArray();
        pData->setUserLasLogin(userLastLoginArr);
    }//

    {
        int logoutTime = m_settings->value(SKEY_LOGOUT_TIME, 0).toInt(); // default is disabled
        pData->setLogoutTime(logoutTime);
    }

    {
        bool enable = m_settings->value(SKEY_21_CFR_11_EN, false).toBool();
        pData->setCfr21Part11Enable(enable);
    }
    {
        bool enable = m_settings->value(SKEY_EXP_TIMER_ALWAYS_SHOW, false).toBool();
        pData->setExperimentTimerAlwaysShow(enable);

    }
    {
        QString eth0ConName = m_settings->value(SKEY_ETH_CON_NAME + QString("0"), "ESCO_BSC").toString();
        QString eth0Ipv4Address = m_settings->value(SKEY_ETH_CON_IPv4 + QString("0"), "192.168.2.10").toString();
        bool eth0ConEnabled = m_settings->value(SKEY_ETH_CON_ENABLE + QString("0"), false).toBool();
        //    QString gateway = QString("%1.%2.%3.1").arg(eth0Ipv4Address.split(".").at(0)).arg(eth0Ipv4Address.split(".").at(1)).arg(eth0Ipv4Address.split(".").at(2));
        //        qWarning() << "gateway:" << gateway;

        pData->setEth0ConName(eth0ConName);
        pData->setEth0Ipv4Address(eth0Ipv4Address);
        pData->setEth0ConEnabled(eth0ConEnabled);

#ifdef __linux__
        /// Execute later
        QTimer::singleShot(30000, this, [&](){
            initWiredConnectionStaticIP();
        });
#endif
    }//

    /// General connection for Debugging
    QObject::connect(pData, &MachineData::fanPrimaryStateChanged,
                     this, [&](short value){
                         //Q_UNUSED(value)
                         if(value == MachineEnums::FAN_STATE_OFF) qDebug() << "***** FAN OFF *****";
                         else if(value == MachineEnums::FAN_STATE_ON) qDebug() << "***** FAN ON *****";
                         else if(value == MachineEnums::FAN_STATE_STANDBY) qDebug() << "***** FAN STANDBY *****";
                     });
    QObject::connect(pData, &MachineData::sashCycleMeterChanged,
                     this, [&](int cycle){
                         ///MODBUS
                         _setModbusRegHoldingValue(modbusRegisterAddress.SashCycle.addr, static_cast<ushort>(cycle/10));
                     });


    /// Buzzer indication
    {
        /// give finished machine backend setup
        m_pBuzzer->setState(MachineEnums::DIG_STATE_ONE);
        sleep(1);
        m_pBuzzer->setState(MachineEnums::DIG_STATE_ZERO);
    }

    /// Initialize ResourceMonitorParams value
    {
        pData->setResourceMonitorParams(QStringList() << "00" << "00" << "00" << "00");
    }

    /// Initialize the Airflow Calibration Grid
    {
        refreshAirflowCalibrationGrid();
    }

    //Refresh Temp. Alarm
    {
        _onTemperatureActualChanged(m_pTemperature->celciusPrecision());
    }

    /// Initialize the Certification Parameters
    {
        _initCertificationParameters();
    }

    ///event log
    _insertEventLog(_tr(EVENT_STR_POWER_ON));

    /// WATCHDOG
    /// Activate Watchdog only when RTC Module was responding
    /// connect watchdog brigde, now watchdog event from RTC can reset the SBC if counter timeout
    //qDebug() << "RTC Response Status:" << pData->getBoardStatusCtpRtc();
    if(pData->getBoardStatusCtpRtc()){
        /// restart counter number
        m_boardCtpRTC->setTimerACount(SDEF_WATCHDOG_PERIOD, I2CPort::I2C_SEND_MODE_DIRECT);
        /// enable event to restart countdown wtachdog
        m_timerEventForRTCWatchdogReset->start();
        /// Give some times before activating the watchdog signal
        QTimer::singleShot(500, this, [&](){
            int batStatus = PCF8523_BATTERY::STATUS_OK;
            m_boardCtpRTC->getBatteryStatus(batStatus);
            pData->setRtcBatteryLowStatus(batStatus == PCF8523_BATTERY::STATUS_LOW);
            //qDebug() << "RTC Battery Low Status:" << pData->getRtcBatteryLowStatus() << "!";
            //for testing do not activate the wathcdog reset gate
            m_boardCtpIO->setOutputAsDigital(LEDpca9633_CHANNEL_WDG, MachineEnums::DIG_STATE_ZERO,
                                             I2CPort::I2C_SEND_MODE_DIRECT);
        });
    }//

    /// Change value to loop, routine task
    pData->setMachineBackendState(MachineEnums::MACHINE_STATE_LOOP);
    /// GIVE A SIGNAL
    emit loopStarted();

//qWarning() << "Setup done!";

#ifdef QT_DEBUG
    m_pWebSocketServerDummyState.reset(new QWebSocketServer(qAppName(), QWebSocketServer::NonSecureMode));
    bool ok = m_pWebSocketServerDummyState->listen(QHostAddress::Any, 8789);
    if (ok){
        connect(m_pWebSocketServerDummyState.data(), &QWebSocketServer::newConnection,
                this, &MachineBackend::onDummyStateNewConnection);
    }
#endif
}//

void MachineBackend::loop()
{
    // qDebug() << metaObject()->className() << __FUNCTION__ << thread();

    /// Just execute for the first cycle loop
    if (m_loopStarterTaskExecute) {
        m_loopStarterTaskExecute  = false;
        qInfo() << metaObject()->className() << __FUNCTION__ << "loopStarterTaskExecute";
    }

    /// READ_SENSOR
    /// put any read sensor routineTask in here
    //m_pSashWindow->routineTask();
    m_pTemperature->routineTask();
    m_pAirflowInflow->routineTask();
    if(pData->getSeasInstalled()) { m_pSeas->routineTask(); }

    /// PROCESSING
    /// put any processing/machine value condition in here
    //    pData->setCount(pData->getCount() + 1);
    //    _onInflowVelocityActualChanged(pData->getCount() + 100);
    _machineState();

    /// ACTUATOR
    /// put any actuator routine task in here
    m_pHydraulicMotorize->routineTask();
    m_pLight->routineTask();
    m_pLightIntensity->routineTask();
    if(pData->getSocketInstalled()) m_pSocket->routineTask();
    if(pData->getGasInstalled()) m_pGas->routineTask();
    if(pData->getUvInstalled()) m_pUV->routineTask();
//    m_pExhaustContact->routineTask();
//    m_pAlarmContact->routineTask();
    //    m_pExhaustPressure->routineTask();

    if(m_stop){
        pData->setMachineBackendState(MachineEnums::MACHINE_STATE_STOP);
    }
}

void MachineBackend::deallocate()
{
    ///Guard to ensure the followng function called once from event timer proxy
    if(m_deallocatting) return;
    m_deallocatting = true;

    ///event log
    _insertEventLog(_tr(EVENT_STR_POWER_OFF));

    qDebug() << metaObject()->className() << __FUNCTION__ << "phase-1";

    //// CLOSE WATCHDOG GATE
    //// THIS PIN CONNECTED TO MOSFET NPN
    //// DISCONNECT WATCHDOG EFFECT
    m_boardCtpIO->setOutputAsDigital(LEDpca9633_CHANNEL_WDG, MachineEnums::DIG_STATE_ONE);

    /// Shutting down modbus communication
    m_pModbusServer->disconnectDevice();
    m_timerEventForSashWindowRoutine->stop();
    m_timerEventEverySecond->stop();
    if(m_timerEventEveryMinute->isActive())
        m_timerEventEveryMinute->stop();
    m_timerEventEveryHalfHour->stop();
    m_timerEventEveryHour->stop();
    m_timerEventForDataLog->stop();
    m_timerEventForResourceMonitorLog->stop();
    if(m_timerEventForLcdToDimm->isActive())
        m_timerEventForLcdToDimm->stop();
    m_timerEventForRTCWatchdogReset->stop();
    if(m_timerEventForRTCWatchdogCountMonitor->isActive())
        m_timerEventForRTCWatchdogCountMonitor->stop();

    qDebug() << metaObject()->className() << __FUNCTION__ << "phase-2";
    /// turned off the blower
    if(pData->getFanPrimaryState()){
        qDebug() << metaObject()->className() << __FUNCTION__ << "phase-3";
        _setFanPrimaryStateOFF();
        QEventLoop waitLoop;
        /// https://www.kdab.com/nailing-13-signal-slot-mistakes-clazy-1-3/
        QObject::connect(m_pFanPrimary.data(), &BlowerRbmDsi::dutyCycleChanged,
                         &waitLoop, [this, &waitLoop] (int dutyCycle){
                             //            qDebug() << "waitLoop" << dutyCycle;
                             if (dutyCycle == 0){
                                 waitLoop.quit();
                             }
                             else {
                                 _setFanPrimaryStateOFF();
                             }
                         });
        waitLoop.exec();
    }

    QMetaObject::invokeMethod(m_pUSBAutoMount.data(), [&](){
            m_pUSBAutoMount->ejectAllUsb();
        },
        Qt::DirectConnection);

    if(m_threadForCheckSwUpdate){
        m_threadForCheckSwUpdate->quit();
        m_threadForCheckSwUpdate->wait();
    }

    qDebug() << metaObject()->className() << __FUNCTION__ << "phase-4";
    if(m_threadForBoardIO){
        m_threadForBoardIO->quit();
        m_threadForBoardIO->wait();
    }

    qDebug() << metaObject()->className() << __FUNCTION__ << "phase-5";

    if(m_threadForFanRbmDsi){
        m_threadForFanRbmDsi->quit();
        m_threadForFanRbmDsi->wait();
    }

    qDebug() << metaObject()->className() << __FUNCTION__ << "phase-6";

    if(m_threadForDatalog){
        m_threadForDatalog->quit();
        m_threadForDatalog->wait();
    }

    qDebug() << metaObject()->className() << __FUNCTION__ << "phase-7";

    if(m_threadForAlarmLog){
        m_threadForAlarmLog->quit();
        m_threadForAlarmLog->wait();
    }

    qDebug() << metaObject()->className() << __FUNCTION__ << "phase-8";

    if(m_threadForEventLog){
        m_threadForEventLog->quit();
        m_threadForEventLog->wait();
    }
    qDebug() << metaObject()->className() << __FUNCTION__ << "phase-9";
    if(m_threadForReplaceableCompRecord){
        m_threadForReplaceableCompRecord->quit();
        m_threadForReplaceableCompRecord->wait();
    }
    qDebug() << metaObject()->className() << __FUNCTION__ << "phase-10";

    if(m_threadForResourceMonitorLog){
        m_threadForResourceMonitorLog->quit();
        m_threadForResourceMonitorLog->wait();
    }
    qDebug() << metaObject()->className() << __FUNCTION__ << "phase-11";

    if(m_threadForParticleCounter){
        m_threadForParticleCounter->quit();
        m_threadForParticleCounter->wait();
    }

    qDebug() << metaObject()->className() << __FUNCTION__ << "phase-12";

    if(m_threadForUSBAutoMount){
        m_threadForUSBAutoMount->quit();
        m_threadForUSBAutoMount->wait();
    }

    qDebug() << metaObject()->className() << __FUNCTION__ << "phase-13";

    if(m_threadForBookingSchedule){
        m_threadForBookingSchedule->quit();
        m_threadForBookingSchedule->wait();
    }

    /// turned off all the relays
    m_boardRelay1->setAllPWM(MachineEnums::DIG_STATE_ZERO);
    qDebug() << metaObject()->className() << __FUNCTION__ << "phase-14";

    /// Increse brightness
    m_boardCtpIO->setOutputPWM(LEDpca9633_CHANNEL_BL, 70);
    pData->setLcdBrightnessLevel(70);

    /// Buzzer indication
    {
        /// give finished tone of machine backend setup
        m_pBuzzer->setState(MachineEnums::DIG_STATE_ONE);
        sleep(1);
        m_pBuzzer->setState(MachineEnums::DIG_STATE_ZERO);
    }

    qDebug() << metaObject()->className() << __FUNCTION__ << "will be stopped" << thread();
    emit hasStopped();
}//

const QString MachineBackend::_tr(const QString &source)
{
    if(m_langCode == "en")
        return source;
    else
        return m_translator->translate("QObject", source.toStdString().c_str(), "");
}

void MachineBackend::_onTriggeredEventSashWindowRoutine()
{
    //qDebug() << metaObject()->className() << __FUNCTION__ << thread();
    //m_pHydraulicMotorize->routineTask();
    m_pSashWindow->routineTask();

    short sashPrev = pData->getSashWindowPrevState();
    short sashState = pData->getSashWindowState();

    QString sashPrevStr = "";
    QString sashStr = "";
    Q_UNUSED(sashPrev)
    Q_UNUSED(sashPrevStr)

    //    switch(sashPrev){
    //    case MachineEnums::SASH_STATE_ERROR_SENSOR_SSV: sashPrevStr = "Error"; break;
    //    case MachineEnums::SASH_STATE_FULLY_CLOSE_SSV: sashPrevStr = "Closed"; break;
    //    case MachineEnums::SASH_STATE_UNSAFE_SSV: sashPrevStr = "Unsafe"; break;
    //    case MachineEnums::SASH_STATE_STANDBY_SSV: sashPrevStr = "Standby"; break;
    //    case MachineEnums::SASH_STATE_WORK_SSV: sashPrevStr = "Safe"; break;
    //    case MachineEnums::SASH_STATE_FULLY_OPEN_SSV: sashPrevStr = "Opened"; break;
    //    default: break;
    //    }
    switch(sashState){
    case MachineEnums::SASH_STATE_ERROR_SENSOR_SSV: sashStr = "Error"; break;
    case MachineEnums::SASH_STATE_FULLY_CLOSE_SSV: sashStr = "Closed"; break;
    case MachineEnums::SASH_STATE_UNSAFE_SSV: sashStr = "Unsafe"; break;
    case MachineEnums::SASH_STATE_STANDBY_SSV: sashStr = "Standby"; break;
    case MachineEnums::SASH_STATE_WORK_SSV: sashStr = "Safe"; break;
    case MachineEnums::SASH_STATE_FULLY_OPEN_SSV: sashStr = "Opened"; break;
    default: break;
    }

    //#ifndef QT_DEBUG
    //    qDebug() << "SashWindow :" << sashPrevStr << sashStr;
    //#endif
    //    for(short i=1; i>=0; i--){
    //        if(i>0)
    //            pData->setSashWindowStateSample(pData->getSashWindowStateSample(i-1), i);
    //        else
    //            pData->setSashWindowStateSample(sashState, i);
    //    }

    bool sashChangedValid = true;//(pData->getSashWindowStateSample(0) == pData->getSashWindowStateSample(1));
    //    sashChangedValid &= (pData->getSashWindowStateSample(1) == pData->getSashWindowStateSample(2));
    //    sashChangedValid &= (pData->getSashWindowStateSample(2) == pData->getSashWindowStateSample(3));
    //    sashChangedValid &= (pData->getSashWindowStateSample(3) == pData->getSashWindowStateSample(4));

    if(sashChangedValid)
        pData->setSashWindowStateChangedValid(true);
    else
        pData->setSashWindowStateChangedValid(false);
    //qDebug() << "SashSample :" << pData->getSashWindowStateSample(0) << pData->getSashWindowStateSample(1) << pData->getSashWindowStateSample(2)  << pData->getSashWindowStateSample(3) << pData->getSashWindowStateSample(4) << sashChangedValid;

    int modeOperation = pData->getOperationMode();

    switch(modeOperation){
    case MachineEnums::MODE_OPERATION_QUICKSTART:
    case MachineEnums::MODE_OPERATION_NORMAL:
        switch(sashState){
        case MachineEnums::SASH_STATE_ERROR_SENSOR_SSV:
            ////MOTORIZE SASH
            if(pData->getHydraulicMotorizedInstalled()){

                if(pData->getSashWindowMotorizeUpInterlocked()){
                    m_pHydraulicMotorize->setInterlockUp(MachineEnums::DIG_STATE_ZERO);
                }

                if(pData->getSashWindowMotorizeDownInterlocked()){
                    m_pHydraulicMotorize->setInterlockDown(MachineEnums::DIG_STATE_ZERO);
                }

                if(m_pSashWindow->isSashStateChanged() && sashChangedValid){
                    if(pData->getSashWindowMotorizeState()){
                        if(pData->getSashCycleCountValid()){
                            pData->setSashCycleCountValid(false);
                        }
                        qDebug() << "Sash Motor Off in Sash Error";
                        m_pHydraulicMotorize->setState(MachineEnums::MOTOR_SASH_STATE_OFF);
                        m_pHydraulicMotorize->routineTask();
                        if(m_sashMovedDown)m_sashMovedDown = false;
                    }//
                }//
            }//
            ///// CLEAR FLAG OF SASH STATE FLAG
            //    if(m_pSashWindow->isSashStateChanged() && sashChangedValid){
            //       m_pSashWindow->clearFlagSashStateChanged();
            //    }
            break;
        case MachineEnums::SASH_STATE_FULLY_CLOSE_SSV:
            ////MOTORIZE SASH
            if(pData->getHydraulicMotorizedInstalled()){

                if(pData->getSashWindowMotorizeUpInterlocked()){
                    m_pHydraulicMotorize->setInterlockUp(MachineEnums::DIG_STATE_ZERO);
                }

                if((pData->getSashWindowPrevState() == MachineEnums::SASH_STATE_FULLY_CLOSE_SSV)
                    && (pData->getSashWindowMotorizeState() == MachineEnums::MOTOR_SASH_STATE_DOWN)){
                    if(!pData->getSashWindowMotorizeDownInterlocked()){
                        m_pHydraulicMotorize->setInterlockDown(MachineEnums::DIG_STATE_ONE);
                    }
                }

                if(m_pSashWindow->isSashStateChanged() && sashChangedValid){
                    ///Ensure the Buzzer Alarm Off Once Sash Fully Closed
                    setBuzzerState(MachineEnums::DIG_STATE_ZERO);

                    //                    if(pData->getSashWindowMotorizeState()){
                    if(!pData->getSashCycleCountValid()){
                        pData->setSashCycleCountValid(true);
                    }
                    if(pData->getSashMotorOffDelayMsec()){
                        if(!eventTimerForDelayMotorizedOffAtFullyClosed){
                            m_delaySashMotorFullyClosedExecuted = false;
                            /// Give a delay for a moment for sash moving down after fully closed detected
                            eventTimerForDelayMotorizedOffAtFullyClosed = new QTimer();
                            eventTimerForDelayMotorizedOffAtFullyClosed->setInterval(pData->getSashMotorOffDelayMsec());
                            eventTimerForDelayMotorizedOffAtFullyClosed->setSingleShot(true);
                            ///Ececute this block after a certain time (pData->getSashMotorOffDelayMsec())
                            QObject::connect(eventTimerForDelayMotorizedOffAtFullyClosed, &QTimer::timeout,
                                             eventTimerForDelayMotorizedOffAtFullyClosed, [=](){
                                                 qDebug() << "Sash Motor Off in Sash Fully Closed With Delay";
                                                 m_pHydraulicMotorize->setState(MachineEnums::MOTOR_SASH_STATE_OFF);
                                                 m_pHydraulicMotorize->routineTask();
                                                 if(m_sashMovedDown)m_sashMovedDown = false;
                                                 m_delaySashMotorFullyClosedExecuted = true;
                                                 setBuzzerState(MachineEnums::DIG_STATE_ZERO);
                                             });
                            qDebug() << "Timer Sash Motor Off in Sash Fully Closed Start";
                            eventTimerForDelayMotorizedOffAtFullyClosed->start();
                        }
                    }else{
                        qDebug() << "Sash Motor Off in Sash Fully Closed";
                        m_pHydraulicMotorize->setState(MachineEnums::MOTOR_SASH_STATE_OFF);
                        m_pHydraulicMotorize->routineTask();
                        if(m_sashMovedDown)m_sashMovedDown = false;
                    }
                }
                if(m_delaySashMotorFullyClosedExecuted){
                    if(!pData->getSashWindowMotorizeDownInterlocked()){
                        m_pHydraulicMotorize->setInterlockDown(MachineEnums::DIG_STATE_ONE);
                    }
                    if (eventTimerForDelayMotorizedOffAtFullyClosed != nullptr) {
                        eventTimerForDelayMotorizedOffAtFullyClosed->stop();
                        delete eventTimerForDelayMotorizedOffAtFullyClosed;
                        eventTimerForDelayMotorizedOffAtFullyClosed = nullptr;
                    }
                }
            }
            //        /// CLEAR FLAG OF SASH STATE FLAG
            //        if(m_pSashWindow->isSashStateChanged() && sashChangedValid){
            //            m_pSashWindow->clearFlagSashStateChanged();
            //        }
            break;
        case MachineEnums::SASH_STATE_UNSAFE_SSV:
            ////MOTORIZE SASH
            if(pData->getHydraulicMotorizedInstalled()){

                if(pData->getSashWindowMotorizeUpInterlocked()){
                    m_pHydraulicMotorize->setInterlockUp(MachineEnums::DIG_STATE_ZERO);
                }

                if(pData->getSashWindowMotorizeDownInterlocked()){
                    m_pHydraulicMotorize->setInterlockDown(MachineEnums::DIG_STATE_ZERO);
                }
            }
            //        /// CLEAR FLAG OF SASH STATE FLAG
            //        if(m_pSashWindow->isSashStateChanged() && sashChangedValid){
            //            m_pSashWindow->clearFlagSashStateChanged();
            //        }
            break;
        case MachineEnums::SASH_STATE_STANDBY_SSV:
            ////MOTORIZE SASH
            if(pData->getHydraulicMotorizedInstalled()){
                if(pData->getSashWindowMotorizeUpInterlocked()){
                    m_pHydraulicMotorize->setInterlockUp(MachineEnums::DIG_STATE_ZERO);
                }

                if(pData->getSashWindowMotorizeDownInterlocked()){
                    m_pHydraulicMotorize->setInterlockDown(MachineEnums::DIG_STATE_ZERO);
                }

                if(m_pSashWindow->isSashStateChanged() && sashChangedValid && !m_eventLoopSashMotorActive){
                    if(pData->getSashWindowMotorizeState()){
                        if(!pData->getSashCycleCountValid()){
                            pData->setSashCycleCountValid(true);
                        }
                        /// Don't turnOff the sash if the previous State is the same
                        if(pData->getSashWindowPrevState() != MachineEnums::SASH_STATE_STANDBY_SSV){
                            /// Turned off mototrize in every defined magnetic switch
                            if(pData->getSashWindowMotorizeState() == MachineEnums::MOTOR_SASH_STATE_DOWN){
                                m_pHydraulicMotorize->setState(MachineEnums::MOTOR_SASH_STATE_OFF);
                                m_pHydraulicMotorize->routineTask();
                                if(m_sashMovedDown)m_sashMovedDown = false;
                                qDebug() << "Sash Motor Off in Sash Standby 1";
                                m_eventLoopCounter = 0;
                                m_eventLoopSashMotorActive = true;
                                QTimer::singleShot(200, this, [&](){
                                    QEventLoop waitLoop;
                                    QObject::connect(m_timerEventEvery50MSecond.data(), &QTimer::timeout,
                                                     &waitLoop, [this, &waitLoop] (){
                                                         short sashWindowState = pData->getSashWindowState();
                                                         m_eventLoopCounter++;
                                                         qDebug() << "waitLoop" << sashWindowState << m_eventLoopCounter;
                                                         if ((sashWindowState == MachineEnums::SASH_STATE_STANDBY_SSV) || (m_eventLoopCounter >= 20)){
                                                             m_pHydraulicMotorize->setState(MachineEnums::MOTOR_SASH_STATE_OFF);
                                                             m_pHydraulicMotorize->routineTask();
                                                             qDebug() << "Sash Motor Off in Sash Standby WaitLoop";
                                                             if(pData->getFanPrimaryState() == MachineEnums::FAN_STATE_ON){
                                                                 ///Ensure the Buzzer Alarm Off Once in Standby Mode and fan ON
                                                                 setBuzzerState(MachineEnums::DIG_STATE_ZERO);
                                                                 //Ensure to cancel warmingup
                                                                 if(pData->getWarmingUpActive()) _cancelWarmingUpTime();
                                                                 setFanState(MachineEnums::FAN_STATE_STANDBY);
                                                             }
                                                             m_eventLoopSashMotorActive = false;
                                                             waitLoop.quit();
                                                         }
                                                         else {
                                                             m_eventLoopSashMotorActive = true;
                                                             m_pSashWindow->setSafeSwitcher(SashWindow::SWITCHER_UP);
                                                             m_pHydraulicMotorize->setState(MachineEnums::MOTOR_SASH_STATE_UP);
                                                             m_pHydraulicMotorize->routineTask();
                                                             qDebug() << "Sash Motor Up in WaitLoop Standby";
                                                         }
                                                     });
                                    waitLoop.exec();
                                });
                            }else{
                                m_pHydraulicMotorize->setState(MachineEnums::MOTOR_SASH_STATE_OFF);
                                m_pHydraulicMotorize->routineTask();
                                if(m_sashMovedDown)m_sashMovedDown = false;
                                qDebug() << "Sash Motor Off in Sash Standby";
                            }//
                        }//
                    }//
                }//
            }//

            //AUTOMATIC IO STATE
            if(m_pSashWindow->isSashStateChanged() && sashChangedValid && !m_eventLoopSashMotorActive){
                bool autoOnBlower = false;
                autoOnBlower |= (modeOperation != MachineEnums::MODE_OPERATION_MAINTENANCE);
                autoOnBlower &= (pData->getFanPrimaryState() != MachineEnums::FAN_STATE_OFF);
                autoOnBlower &= (pData->getFanPrimaryState() != MachineEnums::FAN_STATE_STANDBY);

                if(autoOnBlower){
                    qDebug() << "eventTimerForDelaySafeHeightAction stb" << eventTimerForDelaySafeHeightAction;
                    if(!eventTimerForDelaySafeHeightAction){
                        /// delayQuickModeAutoOn oject will be destroyed when the sash state is changed
                        /// see also _onSashStateChanged()
                        /// Delay execution
                        eventTimerForDelaySafeHeightAction = new QTimer();
                        eventTimerForDelaySafeHeightAction->setInterval(m_sashSafeAutoOnOutputDelayTimeMsec);
                        eventTimerForDelaySafeHeightAction->setSingleShot(true);
                        ///Ececute this block after a certain time (m_sashSafeAutoOnOutputDelayTimeMsec)
                        QObject::connect(eventTimerForDelaySafeHeightAction, &QTimer::timeout, eventTimerForDelaySafeHeightAction,
                                         [=](){
                                             //qDebug() << "Sash Standby Height after delay turned on out put";
                                             if(pData->getWarmingUpActive()){
                                                 _cancelWarmingUpTime();
                                             }
                                             //TURN BLOWER TO STANDBY SPEED
                                             setFanState(MachineEnums::FAN_STATE_STANDBY);

                                             ///Ensure the Buzzer Alarm Off Once in Standby Mode and Fan ON
                                             setBuzzerState(MachineEnums::DIG_STATE_ZERO);
                                         });

                        eventTimerForDelaySafeHeightAction->start();
                    }
                }
            }
            //            /// CLEAR FLAG OF SASH STATE FLAG
            //            if(m_pSashWindow->isSashStateChanged() && pData->getSashWindowStateChangedValid()){
            //                m_pSashWindow->clearFlagSashStateChanged();
            //            }
            break;
        case MachineEnums::SASH_STATE_WORK_SSV:
            /////CLEAR INTERLOCK FAN
            if(pData->getFanPrimaryInterlocked()){
                _setFanPrimaryInterlocked(MachineEnums::DIG_STATE_ZERO);
            }//

            ////MOTORIZE SASH
            if(pData->getHydraulicMotorizedInstalled()){

                if(pData->getSashWindowMotorizeUpInterlocked()){
                    m_pHydraulicMotorize->setInterlockUp(MachineEnums::DIG_STATE_ZERO);
                }

                if(pData->getSashWindowMotorizeDownInterlocked()){
                    m_pHydraulicMotorize->setInterlockDown(MachineEnums::DIG_STATE_ZERO);
                }

                if(m_pSashWindow->isSashStateChanged() && sashChangedValid){
                    if(pData->getSashWindowMotorizeState()){
                        if(pData->getSashCycleCountValid()){
                            /// Count tubular motor cycle
                            int count = pData->getSashCycleMeter();
                            count = count + 5; /// the value deviced by 10
                            pData->setSashCycleMeter(count);
                            pData->setSashCycleCountValid(false);
                            ///qDebug() << metaObject()->className() << __func__ << "setSashCycleMeter: " << pData->getSashCycleMeter();
                            ///save permanently
                            QSettings settings;
                            settings.setValue(SKEY_SASH_CYCLE_METER, count);
                        }
                        /// Don't turnOff the sash if the previous State is the same
                        if(pData->getSashWindowPrevState() != MachineEnums::SASH_STATE_WORK_SSV){
                            /// Turned off mototrize in every defined magnetic switch

                            if(pData->getSashWindowMotorizeState() == MachineEnums::MOTOR_SASH_STATE_DOWN){
                                m_pHydraulicMotorize->setState(MachineEnums::MOTOR_SASH_STATE_OFF);
                                m_pHydraulicMotorize->routineTask();
                                if(m_sashMovedDown)m_sashMovedDown = false;
                                qDebug() << "Sash Motor Off in Sash Safe 1";

                            }else{
                                m_pHydraulicMotorize->setState(MachineEnums::MOTOR_SASH_STATE_OFF);
                                m_pHydraulicMotorize->routineTask();
                                if(m_sashMovedDown)m_sashMovedDown = false;
                                qDebug() << "Sash Motor Off in Sash Safe";
                            }
                        }
                    }//
                }//
            }//
            //AUTOMATIC IO STATE
            //IF SASH STATE JUST CHANGED
            if(m_pSashWindow->isSashStateChanged() && sashChangedValid
                && (m_pSashWindow->previousState() == MachineEnums::SASH_STATE_UNSAFE_SSV)
                && !eventTimerForDelaySafeHeightAction){

                /// delayQuickModeAutoOn object will be destroyed when the sash state is changed
                /// see also _onSashStateChanged()

                /// Delay execution
                eventTimerForDelaySafeHeightAction = new QTimer();
                eventTimerForDelaySafeHeightAction->setInterval(m_sashSafeAutoOnOutputDelayTimeMsec);
                eventTimerForDelaySafeHeightAction->setSingleShot(true);
                ///Ececute this block after a certain time (m_sashSafeAutoOnOutputDelayTimeMsec)
                QObject::connect(eventTimerForDelaySafeHeightAction, &QTimer::timeout, eventTimerForDelaySafeHeightAction,
                                 [=](){

                                     //qDebug() << "Sash Safe Height after delay turned on out put";
                                     ///Ensure the Buzzer Alarm Off Once Sahs Safe
                                     setBuzzerState(MachineEnums::DIG_STATE_ZERO);
                                     ///
                                     ////IF CURRENT MODE MOPERATION IS QUICK START OR
                                     ////IF CURRENT FAN STATE IS STANDBY SPEED; THEN
                                     ////SWITCH BLOWER SPEED TO NOMINAL SPEED
                                     bool autoOnBlower = false;
                                     autoOnBlower |= (modeOperation == MachineEnums::MODE_OPERATION_QUICKSTART);
                                     autoOnBlower |= (pData->getFanPrimaryState() == MachineEnums::FAN_STATE_STANDBY);
                                     autoOnBlower &= (pData->getFanPrimaryState() != MachineEnums::FAN_STATE_ON);

                                     if(autoOnBlower){
                                         //_setFanPrimaryStateNominal();
                                         setFanState(MachineEnums::FAN_STATE_ON);
                                         /// Tell every one if the fan state will be changing
                                         emit pData->fanPrimarySwithingStateTriggered(MachineEnums::DIG_STATE_ONE);
                                         ////
                                         _insertEventLog(_tr(EVENT_STR_FAN_ON));
                                     }
                                     else if(!pData->getWarmingUpActive()){
                                         ////TURN ON LAMP
                                         /// ONLY IF BLOWER IS'NT AT WARMING UP CONDITION
                                         /// AND NO EXHAUST ALARM
                                         qDebug() << "Turn on the lamp if no warming up at safe height";
                                         setLightState(MachineEnums::DIG_STATE_ONE);
                                         ///
                                         _insertEventLog(_tr(EVENT_STR_LIGHT_ON));
                                     }

                                     ///Ensure the Buzzer Alarm Off Once Sahs Safe
                                     setBuzzerState(MachineEnums::DIG_STATE_ZERO);

                                     /// clear vivarium mute state
                                     if(pData->getVivariumMuteState()){
                                         setMuteVivariumState(false);
                                     }
                                 });

                eventTimerForDelaySafeHeightAction->start();
            }
            //        /// CLEAR FLAG OF SASH STATE FLAG
            //        if(m_pSashWindow->isSashStateChanged() && sashChangedValid){
            //            m_pSashWindow->clearFlagSashStateChanged();
            //        }
            break;
        case MachineEnums::SASH_STATE_FULLY_OPEN_SSV:
            ////MOTORIZE SASH
            if(pData->getHydraulicMotorizedInstalled()){

                if(!pData->getSashWindowMotorizeUpInterlocked()){
                    m_pHydraulicMotorize->setInterlockUp(MachineEnums::DIG_STATE_ONE);
                }

                if(pData->getSashWindowMotorizeDownInterlocked()){
                    m_pHydraulicMotorize->setInterlockDown(MachineEnums::DIG_STATE_ZERO);
                }

                if(m_pSashWindow->isSashStateChanged() && sashChangedValid){
                    if(pData->getSashWindowMotorizeState()){
                        if(!pData->getSashCycleCountValid()){
                            pData->setSashCycleCountValid(true);
                        }
                        qDebug() << "Sash Motor Off in Sash Fully Open";
                        m_pHydraulicMotorize->setState(MachineEnums::MOTOR_SASH_STATE_OFF);
                        m_pHydraulicMotorize->routineTask();
                        if(m_sashMovedDown)m_sashMovedDown = false;
                    }
                }
            }
            //        /// CLEAR FLAG OF SASH STATE FLAG
            //        if(m_pSashWindow->isSashStateChanged() && sashChangedValid){
            //            m_pSashWindow->clearFlagSashStateChanged();
            //        }
            break;
        }//
        break;
    case MachineEnums::MODE_OPERATION_MAINTENANCE:
        ////MOTORIZE SASH
        if(pData->getHydraulicMotorizedInstalled()){

            if(pData->getSashWindowMotorizeUpInterlocked()){
                m_pHydraulicMotorize->setInterlockUp(MachineEnums::DIG_STATE_ZERO);
            }

            if(pData->getSashWindowMotorizeDownInterlocked()){
                m_pHydraulicMotorize->setInterlockDown(MachineEnums::DIG_STATE_ZERO);
            }

            if(m_pSashWindow->isSashStateChanged() && sashChangedValid){
                if(pData->getSashWindowMotorizeState()){
                    qDebug() << "Sash Motor Off in Mode Maintenance";
                    m_pHydraulicMotorize->setState(MachineEnums::MOTOR_SASH_STATE_OFF);
                    m_pHydraulicMotorize->routineTask();
                    if(m_sashMovedDown)m_sashMovedDown = false;
                }
            }
        }//
        break;
    }//

    /// CLEAR FLAG OF SASH STATE FLAG
    if(m_pSashWindow->isSashStateChanged() && sashChangedValid){
        m_pSashWindow->clearFlagSashStateChanged();
    }
}//

/////////////////////////////////////////////////// API Group for General Object Operation

void MachineBackend::setMachineData(MachineData *data)
{
    qDebug() << metaObject()->className() << __FUNCTION__ << data << thread();
    pData = data;
}

void MachineBackend::setMachineProfileID(const QString &value)
{
    qDebug() << metaObject()->className() << __FUNCTION__ << value << thread();

    QSettings settings;
    settings.setValue(SKEY_MACH_PROFILE_ID, value);
    pData->setMachineProfileID(value);
}

void MachineBackend::stop()
{
    qDebug() << metaObject()->className() << __FUNCTION__ << thread();
    m_stop = true;
}

void MachineBackend::setLcdTouched()
{
    //    qDebug() << metaObject()->className() << __FUNCTION__ << thread();

    /// Wake up LCD Brightness Level
    _wakeupLcdBrightnessLevel();

    if(m_signedUsername != ""){
        _resetLogoutTime();
    }
}

void MachineBackend::setLcdBrightnessLevel(short value)
{
    qDebug() << metaObject()->className() << __FUNCTION__ << value << thread();

    pData->setLcdBrightnessLevel(value);
    pData->setLcdBrightnessLevelUser(value);

    m_boardCtpIO->setOutputPWM(LEDpca9633_CHANNEL_BL, value, I2CPort::I2C_SEND_MODE_QUEUE);
}

void MachineBackend::setLcdBrightnessDelayToDimm(short value)
{
    qDebug() << metaObject()->className() << __FUNCTION__ << value << thread();

    QScopedPointer<QSettings> m_settings(new QSettings);
    m_settings->setValue(SKEY_LCD_DELAY_TO_DIMM, value);
    pData->setLcdBrightnessDelayToDimm(value);

    m_timerEventForLcdToDimm->setInterval(std::chrono::minutes(value));
    if(!m_timerEventForLcdToDimm->isActive()){
        if(value > 0)
            m_timerEventForLcdToDimm->start();
    }
    else{
        if(value == 0)
            m_timerEventForLcdToDimm->stop();
    }
}//

void MachineBackend::saveLcdBrightnessLevel(short value)
{
    qDebug() << metaObject()->className() << __FUNCTION__ << value << thread();
    QScopedPointer<QSettings> m_settings(new QSettings);
    m_settings->setValue(SKEY_LCD_BL, value);
}

void MachineBackend::setLcdEnableLockScreen(bool value)
{
    QScopedPointer<QSettings> m_settings(new QSettings);
    m_settings->setValue(SKEY_LCD_EN_LOCK_SCREEN, value);

    pData->setLcdEnableLockScreen(value);

}

void MachineBackend::saveLanguage(const QString &value)
{
    qDebug() << metaObject()->className() << __FUNCTION__ << value << thread();

    pData->setLanguage(value);
    QScopedPointer<QSettings> m_settings(new QSettings);
    m_settings->setValue(SKEY_LANGUAGE, value);
}

/**
 * @brief MachineBackend::setTimeZone
 * @param value
 * expected value: timezonelocation#offset#utcnotanion
 * example: Asia/Jakarta#7#UTC+07:00
 * this function took time about 800 ms, so need implementing on the Concurrent
 */
void MachineBackend::setTimeZone(const QString &value)
{
    qDebug() << metaObject()->className() << __FUNCTION__ << value << thread();

    QFuture<void> future = QtConcurrent::run([&, value](){

        QStringList data = value.split("#", Qt::SkipEmptyParts);

        if (data.length() == 3) {

            QString locationTimeZone = data[0];
            _setTimeZoneLinux(locationTimeZone);
        }
    });

    pData->setTimeZone(value);
    QScopedPointer<QSettings> m_settings(new QSettings);
    m_settings->setValue(SKEY_TZ, value);
}//

/**
 * @brief MachineBackend::setDateTime
 * @param value
 * To set date only, we can use a set-time switch along with the format of date in YY:MM:DD (Year, Month, Day).
 * example: timedatectl set-time 2015-11-20
 * To set time only, we can use a set-time switch along with the format of time in HH:MM:SS (Hour, Minute, and Seconds).
 * example: timedatectl set-time 15:58:30
 * This execution need about 9,6 seconds to finish. So, need run on other thread / Asyncronous
 */
void MachineBackend::setDateTime(const QString &value)
{
    qDebug() << metaObject()->className() << __FUNCTION__ << value << thread();

    QFuture<void> future = QtConcurrent::run([&, value]{
        _setDateTimeLinux(value);
    });

#ifdef __arm__
    QDateTime dateValidation = QDateTime::fromString(value, "yyyy-MM-dd hh:mm:ss");
    if(dateValidation.isValid()) {
        qDebug() << metaObject()->className() << __FUNCTION__ << "Set to RTC" << value;

        m_boardCtpRTC->setDateTime(dateValidation.date().weekNumber(),
                                   dateValidation.date().day(),
                                   dateValidation.date().month(),
                                   dateValidation.date().year(),
                                   dateValidation.time().hour(),
                                   dateValidation.time().minute(),
                                   dateValidation.time().second(),
                                   I2CPort::I2C_SEND_MODE_QUEUE);
    }
#endif

    QSettings settings;
    bool powerFailCapt = settings.value(SKEY_POWER_OUTAGE).toBool();
    if(powerFailCapt == true){
        _onTimerEventPowerOutageCaptureTime();
    }
}

void MachineBackend::saveTimeClockPeriod(short value)
{
    qDebug() << metaObject()->className() << __FUNCTION__ << value << thread();

    //    QElapsedTimer elapsed;
    //    elapsed.start();

    pData->setTimeClockPeriod(value);
    QScopedPointer<QSettings> m_settings(new QSettings);
    m_settings->setValue(SKEY_CLOCK_PERIOD, value);

    //    qDebug() << __func__ << elapsed.elapsed() << "ms";
}

void MachineBackend::deleteFileOnSystem(const QString &path)
{
    qDebug() << metaObject()->className() << __FUNCTION__ << path << thread();

    QString pathFilter = path;
#ifdef WIN32
    pathFilter.replace("file:///c", "c");
#elif __linux__
    pathFilter.replace("file://", "");
#endif

    if(QFile::exists(pathFilter)) {
        bool removed = QFile::remove(pathFilter);
        qInfo() << metaObject()->className() << __FUNCTION__ << pathFilter << removed;
    }
    else {
        qDebug() << metaObject()->className() << __FUNCTION__ << pathFilter << "does not exist!" << thread();
    }
}

void MachineBackend::setMuteVivariumState(short value)
{
    qDebug() << metaObject()->className() << __FUNCTION__ << value << thread();

    pData->setMuteAlarmState(value);
    if(value) {
        _startMuteAlarmTimer();
        pData->setVivariumMuteState(value);
    }
    else {
        _cancelMuteAlarmTimer();
    }

    m_pBuzzer->setState(MachineEnums::DIG_STATE_ZERO);
}

void MachineBackend::setMuteAlarmState(short value)
{
    qDebug() << metaObject()->className() << __FUNCTION__ << value << thread();

    pData->setMuteAlarmState(value);
    if(value) {
        _startMuteAlarmTimer();
    }
    else {
        _cancelMuteAlarmTimer();
    }

    m_pBuzzer->setState(MachineEnums::DIG_STATE_ZERO);
}

void MachineBackend::setMuteAlarmTime(short value)
{
    qDebug() << metaObject()->className() << __FUNCTION__ << value << thread();

    pData->setMuteAlarmTime(value);
    //int seconds = value * 60;
    pData->setMuteAlarmCountdown(value);

    QSettings settings;
    settings.setValue(SKEY_MUTE_ALARM_TIME, value);
}

void MachineBackend::setMuteAlarmTimeAtFullyOpened(int value)
{
    qDebug() << metaObject()->className() << __FUNCTION__ << value << thread();

    pData->setMuteAlarmTimeAtFullyOpened(value);

    QSettings settings;
    settings.setValue(SKEY_MUTE_ALARM_TIME_FO, value);
}

void MachineBackend::setBuzzerState(bool value)
{
    //    qDebug() << metaObject()->className() << __FUNCTION__ << value << thread();
    m_pBuzzer->setState(value);
}

void MachineBackend::setBuzzerBeep()
{
    qDebug() << metaObject()->className() << __FUNCTION__ << thread();

    m_pBuzzer->setState(MachineEnums::DIG_STATE_ONE);

    /// future auto turned off
    m_timerEventForBuzzerBeep.reset(new QTimer);
    m_timerEventForBuzzerBeep->setSingleShot(MachineEnums::DIG_STATE_ONE);
    m_timerEventForBuzzerBeep->start(100);
    QObject::connect(m_timerEventForBuzzerBeep.data(), &QTimer::timeout, this, [&](){
        m_pBuzzer->setState(MachineEnums::DIG_STATE_ZERO);
        //        qDebug() << "buzzer beep off";
    });
}

void MachineBackend::setSignedUser(const QString &username, const QString &fullname, short userLevel)
{
    qDebug() << metaObject()->className() << __FUNCTION__ << thread();
    qDebug() << username << fullname << userLevel;

    m_signedUsername = username;
    m_signedFullname = fullname;
    m_signedUserLevel = userLevel;

    if(m_signedUsername != ""){
        _startLogoutTime();
    }else{
        _cancelLogoutTime();
    }
}

void MachineBackend::setUserLastLogin(const QString &username, const QString &fullname)
{
    qDebug() << metaObject()->className() << __FUNCTION__ << username << fullname << thread();
    if(username == "" || fullname == "") return;

    QDateTime loginDateTime = QDateTime::currentDateTime();
    QString loginDateTimeText = loginDateTime.toString("yyyy-MM-dd hh:mm:ss");

    /// https://thecodeprogram.com/how-to-use-json-data-with-qt-c--
    QJsonArray userLastLoginArr = pData->getUserLastLogin();
    QJsonObject userLastLoginObjNew;

    //    qDebug() << "before:" << userLastLoginArr;

    /// Remember Only 10 user last login
    /// Remove the 10th data
    if(userLastLoginArr.size() >= 10)
        userLastLoginArr.pop_back();

    bool usernameOnList = false;
    short usernameOnListAtIndex = 0;

    for(short i=0; i<userLastLoginArr.count(); i++){
        QJsonObject userLastLoginObj = userLastLoginArr[i].toObject();
        if(userLastLoginObj.value("username").toString() == username){
            usernameOnList = true;
            usernameOnListAtIndex = i;
            //            qDebug() << "User exist at index:" << i;
            break;
        }//
    }//
    if(!usernameOnList){
        userLastLoginObjNew.insert("username", username);
        userLastLoginObjNew.insert("fullname", fullname);
        userLastLoginObjNew.insert("login", loginDateTimeText);
    }//
    else{
        // update the last login date and time
        userLastLoginObjNew = userLastLoginArr.at(usernameOnListAtIndex).toObject();
        userLastLoginObjNew.remove("fullname");
        userLastLoginObjNew.insert("fullname", fullname);//always update the fullname
        userLastLoginObjNew.remove("login");
        userLastLoginObjNew.insert("login", loginDateTimeText);

        // Remove the object at current index and append to front later
        userLastLoginArr.removeAt(usernameOnListAtIndex);
    }//

    //    qDebug() << "add:" << userLastLoginObjNew;

    userLastLoginArr.prepend(userLastLoginObjNew);

    //    qDebug() << "after:" << userLastLoginArr;

    QSettings settings;
    settings.setValue(SKEY_USER_LAST_LOGIN, userLastLoginArr);

    pData->setUserLasLogin(userLastLoginArr);
}

void MachineBackend::deleteUserLastLogin(const QString &username)
{
    QJsonArray userLastLoginArr = pData->getUserLastLogin();

    bool usernameOnList = false;
    short usernameOnListAtIndex = 0;

    for(short i=0; i<userLastLoginArr.count(); i++){
        QJsonObject userLastLoginObj = userLastLoginArr[i].toObject();
        if(userLastLoginObj.value("username").toString() == username){
            usernameOnList = true;
            usernameOnListAtIndex = i;
            //            qDebug() << "User exist at index:" << i;
            break;
        }//
    }//
    if(usernameOnList){
        userLastLoginArr.removeAt(usernameOnListAtIndex);
    }//

    QSettings settings;
    settings.setValue(SKEY_USER_LAST_LOGIN, userLastLoginArr);

    pData->setUserLasLogin(userLastLoginArr);
}//

void MachineBackend::setDataLogEnable(bool dataLogEnable)
{
    qDebug() << metaObject()->className() << __FUNCTION__ << thread();

    pData->setDataLogEnable(dataLogEnable);

    QScopedPointer<QSettings> m_settings(new QSettings);
    m_settings->setValue(SKEY_DATALOG_ENABLE, dataLogEnable ? 1 : 0);
}

void MachineBackend::setDataLogRunning(bool dataLogRunning)
{
    qDebug() << metaObject()->className() << __FUNCTION__ << thread();

    if(dataLogRunning) m_timerEventForDataLog->start();
    else m_timerEventForDataLog->stop();

    pData->setDataLogRunning(dataLogRunning);
}

void MachineBackend::setDataLogPeriod(short dataLogPeriod)
{
    qDebug() << metaObject()->className() << __FUNCTION__ << thread();
    qDebug() << dataLogPeriod;
    if(m_timerEventForDataLog->isActive())
        m_timerEventForDataLog->stop();
    m_timerEventForDataLog->setInterval(dataLogPeriod * 60 * 1000); /// convert minute to ms
    if(pData->getDataLogEnable()) m_timerEventForDataLog->start();

    pData->setDataLogPeriod(dataLogPeriod);

    QScopedPointer<QSettings> m_settings(new QSettings);
    m_settings->setValue(SKEY_DATALOG_PERIOD, dataLogPeriod);
}

void MachineBackend::setDataLogCount(int dataLogCount)
{
    qDebug() << metaObject()->className() << __FUNCTION__ << thread();

    pData->setDataLogCount(dataLogCount);
    pData->setDataLogIsFull(dataLogCount >= DATALOG_MAX_ROW);
}

void MachineBackend::setResourceMonitorLogEnable(bool value)
{
    qDebug() << metaObject()->className() << __FUNCTION__ << thread();

    pData->setResourceMonitorLogEnable(value);

    QScopedPointer<QSettings> m_settings(new QSettings);
    m_settings->setValue(SKEY_RESMONLOG_ENABLE, value ? 1 : 0);

    if(value)
        setResourceMonitorLogRunning(true);
    else
        setResourceMonitorLogRunning(false);
}

void MachineBackend::setResourceMonitorLogRunning(bool value)
{
    qDebug() << metaObject()->className() << __FUNCTION__ << thread();

    if(value) m_timerEventForResourceMonitorLog->start();
    else m_timerEventForResourceMonitorLog->stop();

    pData->setResourceMonitorLogRunning(value);
}

void MachineBackend::setResourceMonitorLogPeriod(short value)
{
    qDebug() << metaObject()->className() << __FUNCTION__ << thread();
    qDebug() << value;

    if(m_timerEventForResourceMonitorLog->isActive())
        m_timerEventForResourceMonitorLog->stop();
    m_timerEventForResourceMonitorLog->setInterval(value * 60 * 1000); /// convert minute to ms
    if(pData->getResourceMonitorLogEnable()) m_timerEventForResourceMonitorLog->start();

    pData->setResourceMonitorLogPeriod(value);

    QScopedPointer<QSettings> m_settings(new QSettings);
    m_settings->setValue(SKEY_RESMONLOG_PERIOD, value);
}

void MachineBackend::setResourceMonitorLogCount(int value)
{
    qDebug() << metaObject()->className() << __FUNCTION__ << thread();

    pData->setResourceMonitorLogCount(value);
    pData->setResourceMonitorLogIsFull(value >= RESMONLOG_MAX_ROW);
}

void MachineBackend::setModbusSlaveID(short slaveId)
{
    qDebug() << metaObject()->className() << __FUNCTION__ << thread();
    qDebug() << slaveId;

    pData->setModbusSlaveID(slaveId);
    m_pModbusServer->setServerAddress(slaveId);

    QSettings settings;
    settings.setValue(SKEY_MODBUS_SLAVE_ID, slaveId);
}

void MachineBackend::setModbusAllowingIpMaster(const QString &ipAddr)
{
    qDebug() << metaObject()->className() << __FUNCTION__ << thread();
    qDebug() << ipAddr;

    if(ipAddr == pData->getModbusAllowIpMaster()) return;

    pData->setModbusAllowIpMaster(ipAddr);
    QSettings settings;
    settings.setValue(SKEY_MODBUS_ALLOW_IP, ipAddr);

    m_pModbusServer->disconnectDevice();
    m_pModbusServer->connectDevice();
}

void MachineBackend::setModbusAllowSetFan(bool value)
{
    qDebug() << metaObject()->className() << __FUNCTION__ << thread();
    qDebug() << value;

    modbusRegisterAddress.FanState.rw = value;
    pData->setModbusAllowSetFan(value);
    QSettings settings;
    settings.setValue(SKEY_MODBUS_RW_FAN, value ? 1 : 0);
}

void MachineBackend::setModbusAllowSetLight(bool value)
{
    qDebug() << metaObject()->className() << __FUNCTION__ << thread();
    qDebug() << value;

    modbusRegisterAddress.LightState.rw = value;
    pData->setModbusAllowSetLight(value);
    QSettings settings;
    settings.setValue(SKEY_MODBUS_RW_LAMP, value ? 1 : 0);
}

void MachineBackend::setModbusAllowSetLightIntensity(bool value)
{
    qDebug() << metaObject()->className() << __FUNCTION__ << thread();
    qDebug() << value;

    modbusRegisterAddress.LightIntensity.rw = value;
    pData->setModbusAllowSetLightIntensity(value);
    QSettings settings;
    settings.setValue(SKEY_MODBUS_RW_LAMP_DIMM, value ? 1 : 0);
}

void MachineBackend::setModbusAllowSetSocket(bool value)
{
    qDebug() << metaObject()->className() << __FUNCTION__ << thread();
    qDebug() << value;

    modbusRegisterAddress.SocketState.rw = value;
    pData->setModbusAllowSetSocket(value);
    QSettings settings;
    settings.setValue(SKEY_MODBUS_RW_SOCKET, value ? 1 : 0);
}

void MachineBackend::setModbusAllowSetGas(bool value)
{
    qDebug() << metaObject()->className() << __FUNCTION__ << thread();
    qDebug() << value;

    modbusRegisterAddress.GasState.rw = value;
    pData->setModbusAllowSetGas(value);
    QSettings settings;
    settings.setValue(SKEY_MODBUS_RW_GAS, value ? 1 : 0);
}

void MachineBackend::setModbusAllowSetUvLight(bool value)
{
    qDebug() << metaObject()->className() << __FUNCTION__ << thread();
    qDebug() << value;

    modbusRegisterAddress.UvState.rw = value;
    pData->setModbusAllowSetUvLight(value);
    QSettings settings;
    settings.setValue(SKEY_MODBUS_RW_UV, value ? 1 : 0);
}

void MachineBackend::setOperationModeSave(short value)
{
    qDebug() << metaObject()->className() << __FUNCTION__ << thread();

    if(pData->getOperationMode() == value) return;

    if(m_operationPrevMode == MachineEnums::MODE_OPERATION_MAINTENANCE){
        //Also check if prev. fan condition is on(while maintenance), set warmingup executed as true
        //and start power outage capture, if not started yet
        if(pData->getFanPrimaryState() == MachineEnums::FAN_STATE_ON){
            if(!pData->getWarmingUpExecuted())
                pData->setWarmingUpExecuted(true);
            QSettings settings;
            bool powerFailCapt = settings.value(SKEY_POWER_OUTAGE).toBool();
            if(powerFailCapt != true){
                _startPowerOutageCapture();
            }
        }
    }

    m_operationPrevMode = value;
    pData->setOperationMode(value);

    if(value != MachineEnums::MODE_OPERATION_MAINTENANCE) {
        QScopedPointer<QSettings> m_settings(new QSettings);
        m_settings->setValue(SKEY_OPERATION_MODE, value);
    }

    ///MODBUS
    _setModbusRegHoldingValue(modbusRegisterAddress.OperationMode.addr, static_cast<ushort>(value));
}

void MachineBackend::setOperationMaintenanceMode()
{
    qDebug() << metaObject()->className() << __FUNCTION__ << thread();

    if(pData->getOperationMode() != MachineEnums::MODE_OPERATION_MAINTENANCE)
        m_operationPrevMode = pData->getOperationMode();
    pData->setOperationMode(MachineEnums::MODE_OPERATION_MAINTENANCE);

    ///MODBUS
    _setModbusRegHoldingValue(modbusRegisterAddress.OperationMode.addr, MachineEnums::MODE_OPERATION_MAINTENANCE);
}

void MachineBackend::setOperationPreviousMode()
{
    qDebug() << metaObject()->className() << __FUNCTION__ << m_operationPrevMode << thread();

    pData->setOperationMode(m_operationPrevMode);

    // To force triggered dutycycle changed
    if(m_operationPrevMode != MachineEnums::MODE_OPERATION_MAINTENANCE){
        //_onFanPrimaryActualDucyChanged(pData->getFanPrimaryDutyCycle());

        //Also check if prev. fan condition is on(while maintenance), set warmingup executed as true
        //and start power outage capture, if not started yet
        if(pData->getFanPrimaryState() == MachineEnums::FAN_STATE_ON){
            if(!pData->getWarmingUpExecuted())
                pData->setWarmingUpExecuted(true);
            QSettings settings;
            bool powerFailCapt = settings.value(SKEY_POWER_OUTAGE).toBool();
            if(powerFailCapt != true){
                _startPowerOutageCapture();
            }
        }
    }

    ///MODBUS
    _setModbusRegHoldingValue(modbusRegisterAddress.OperationMode.addr, static_cast<ushort>(m_operationPrevMode));
}

void MachineBackend::setSecurityAccessModeSave(short value)
{
    qDebug() << metaObject()->className() << __FUNCTION__ << thread();
    qDebug() << "securiy status check";
    pData->setSecurityAccessMode(value);

    QScopedPointer<QSettings> m_settings(new QSettings);
    m_settings->setValue(SKEY_SECURITY_ACCESS_MODE,value);
}

void MachineBackend::setDateCertificationReminder(const QString &reminder)
{
    qDebug() << metaObject()->className() << __FUNCTION__ << thread();
    pData->setDateCertificationReminder(reminder);

    QScopedPointer<QSettings> m_settings(new QSettings);
    m_settings->setValue(SKEY_CALENDER_REMINDER_MODE,reminder);

    qDebug() << "tanggal" << reminder;

    _checkCertificationReminder();
}

//void MachineBackend::setCertificationExpired(bool certificationExpired)
//{
//    qDebug() << metaObject()->className() << __FUNCTION__ << thread();

//    QDateTime dateTime = QDateTime::currentDateTime();
//    QString dateText = dateTime.toString("dd-MM-yyyy");
//    QString timeText = dateTime.toString("hh:mm:ss");

////    pData->setCertificationExpired(SKEY_CALENDER_REMINDER_MODE == dateText);
//}


//void MachineBackend::setSaveMachineProfileName(const QString value)
//{
//    qDebug() << metaObject()->className() << __FUNCTION__ << value << thread();

//    QSettings settings;
//    settings.setValue(SKEY_MACH_PROFILE, value);

//    pData->setMachineProfileName(value);
//}

///**
// * @brief MachineBackend::saveMachineProfile
// * @param value
// * consume about saveMachineProfile 8 ms
// */
//void MachineBackend::saveMachineProfile(const QJsonObject value)
//{
//    //    qDebug() << metaObject()->className() << __FUNCTION__ << value << thread();

//    //    QElapsedTimer elapsed;
//    //    elapsed.start();

//    QJsonDocument doc(value);
//    QByteArray docByteArray = doc.toJson(QJsonDocument::Compact);
//    QString strJson = QLatin1String(docByteArray);

//    QSettings settings;
//    settings.beginGroup(SKEY_MACH_PROFILE);
//    settings.setValue(SKEY_MACH_PROFILE, strJson);
//    settings.endGroup();

//    pData->setMachineProfileName(value.value("name").toString());

//    //    qDebug() << __func__ << elapsed.elapsed() << "ms";
//}

///**
// * @brief MachineBackend::readMachineProfile
// */
//void MachineBackend::readMachineProfile()
//{
//    qDebug() << metaObject()->className() << __FUNCTION__ << thread();

//    QElapsedTimer elapsed;
//    elapsed.start();

//    QSettings settings;
//    settings.beginGroup(SKEY_MACH_PROFILE);
//    QString profileStr = settings.value(SKEY_MACH_PROFILE, "{}").toString();
//    settings.endGroup();

//    //    qDebug() << "profileStr" << profileStr;

//    QJsonDocument jDoc = QJsonDocument::fromJson(profileStr.toLocal8Bit());

//    if(jDoc.isNull()) {
//        qWarning() << __func__ << "failed at jdoc";
//        return;
//    }

//    if(!jDoc.isObject()) {
//        qWarning() << __func__ << "failed at object";
//        return;
//    }

//    QJsonObject jObj = jDoc.object();

//    pData->setMachineProfile(jObj);

//    qDebug() << __func__ << elapsed.elapsed() << "ms";
//}

void MachineBackend::setMeasurementUnit(short value)
{
    qDebug() << metaObject()->className() << __FUNCTION__ << value << thread();

    if(value == pData->getMeasurementUnit()) return;

    pData->setMeasurementUnit(value);
    m_pAirflowInflow->setMeasurementUnit(static_cast<uchar>(value));

    {
        QSettings settings;
        settings.setValue(SKEY_MEASUREMENT_UNIT, value);
    }

    /// force update temperature value and temperature strf
    _onTemperatureActualChanged(pData->getTemperatureCelcius());

    /// Not calibrated yet
    //    qDebug() << __func__ << "getAirflowCalibrationStatus" << pData->getAirflowCalibrationStatus();
    //    if(pData->getAirflowCalibrationStatus() == MachineEnums::AF_CALIB_NONE){
    //        return;
    //    }

    /// convert calibration airflow value to target measurement unit
    int velPointMinFactory      = pData->getInflowVelocityPointFactory(1);
    int velPointNomFactory      = pData->getInflowVelocityPointFactory(2);
    int velPointMinField        = pData->getInflowVelocityPointField(1);
    int velPointNomField        = pData->getInflowVelocityPointField(2);
    int dfaVelPointNomFactory   = pData->getDownflowVelocityPointFactory(2);
    int dfaVelPointNomField     = pData->getDownflowVelocityPointField(2);
    int tempCalib               = pData->getInflowTempCalib();

    int velPointLowAlarm        = pData->getInflowLowLimitVelocity();

    int tempCelsius            = pData->getTemperatureCelcius();
    int tempLowestLimit         = pData->getEnvTempLowestLimit();
    int tempHighestLimit         = pData->getEnvTempHighestLimit();
    //    ///test
    //    velPointMinFactory  = !value ? 7900 : 40;
    //    velPointNomFactory  = !value ? 10500 : 53;
    //    velPointMinField    = !value ? 7900 : 40;
    //    velPointNomField    = !value ? 10500 : 53;
    //    tempCalib           = !value ? 7700 : 25;

    int _velPointLowAlarm;
    int _velPointMinFactory, _velPointNomFactory, _velPointMinField,_velPointNomField;
    int _dfaVelPointNomFactory, _dfaVelPointNomField;
    int _tempCalib;
    int _tempCelsius = tempCelsius;
    int _tempFahrenheit = __convertCtoF(tempCelsius);
    int _tempLowestLimit;
    int _tempHighestLimit;

    if (value) {
        //        qDebug() << "__convertMpsToFpm" ;
        /// Imperial
        _velPointMinFactory  = qCeil(__convertMpsToFpm(velPointMinFactory) / 100.0) * 100;
        _velPointNomFactory  = qCeil(__convertMpsToFpm(velPointNomFactory) / 100.0) * 100;
        _velPointMinField    = qCeil(__convertMpsToFpm(velPointMinField) / 100.0) * 100;
        _velPointNomField    = qCeil(__convertMpsToFpm(velPointNomField) / 100.0) * 100;

        _velPointLowAlarm    = qCeil(__convertMpsToFpm(velPointLowAlarm) / 100.0) * 100;

        _dfaVelPointNomFactory  = qCeil(__convertMpsToFpm(dfaVelPointNomFactory) / 100.0) * 100;
        _dfaVelPointNomField    = qCeil(__convertMpsToFpm(dfaVelPointNomField) / 100.0) * 100;

        _tempCalib = __convertCtoF(tempCalib);

        pData->setTemperature(static_cast<short>(_tempFahrenheit));
        QString valueStr = QString::asprintf("%d°F", _tempFahrenheit);
                           pData->setTemperatureValueStrf(valueStr);

        _tempLowestLimit = __convertCtoF(tempLowestLimit);
        _tempHighestLimit = __convertCtoF(tempHighestLimit);

    } else {
        //        qDebug() << "__convertFpmToMps" ;
        /// metric
        _velPointMinFactory  = qRound(__convertFpmToMps(velPointMinFactory / 100.0) * 100);
        _velPointNomFactory  = qRound(__convertFpmToMps(velPointNomFactory / 100.0) * 100);
        _velPointMinField    = qRound(__convertFpmToMps(velPointMinField  / 100.0) * 100);
        _velPointNomField    = qRound(__convertFpmToMps(velPointNomField  / 100.0) * 100);

        _velPointLowAlarm    = qRound(__convertFpmToMps(velPointLowAlarm  / 100.0) * 100);

        _dfaVelPointNomFactory  = qRound(__convertFpmToMps(dfaVelPointNomFactory / 100.0) * 100);
        _dfaVelPointNomField    = qRound(__convertFpmToMps(dfaVelPointNomField / 100.0) * 100);

        _tempCalib = __convertFtoC(tempCalib);

        pData->setTemperature(static_cast<short>(_tempCelsius));
        QString valueStr = QString::asprintf("%d°C", _tempCelsius);
                           pData->setTemperatureValueStrf(valueStr);

        _tempLowestLimit = __convertFtoC(tempLowestLimit);
        _tempHighestLimit = __convertFtoC(tempHighestLimit);
    }//

    /// set to data
    pData->setInflowVelocityPointFactory(1, _velPointMinFactory);
    pData->setInflowVelocityPointFactory(2, _velPointNomFactory);
    pData->setInflowVelocityPointField(1, _velPointMinField);
    pData->setInflowVelocityPointField(2, _velPointNomField);
    pData->setDownflowVelocityPointFactory(2, _dfaVelPointNomFactory);
    pData->setDownflowVelocityPointField(2, _dfaVelPointNomField);
    setInflowTemperatureCalib(static_cast<short>(_tempCalib), pData->getInflowTempCalibAdc());
    setEnvTempLowestLimit(_tempLowestLimit);
    setEnvTempHighestLimit(_tempHighestLimit);

    pData->setInflowLowLimitVelocity(_velPointLowAlarm);

    QSettings settings;
    settings.setValue(QString(SKEY_IFA_CAL_VEL_FACTORY) + "1", _velPointMinFactory);
    settings.setValue(QString(SKEY_IFA_CAL_VEL_FACTORY) + "2", _velPointNomFactory);
    settings.setValue(QString(SKEY_IFA_CAL_VEL_FIELD)   + "1", _velPointMinField);
    settings.setValue(QString(SKEY_IFA_CAL_VEL_FIELD)   + "2", _velPointNomField);
    settings.setValue(QString(SKEY_DFA_CAL_VEL_FACTORY) + "2", _dfaVelPointNomFactory);
    settings.setValue(QString(SKEY_DFA_CAL_VEL_FIELD)   + "2", _dfaVelPointNomField);
    settings.setValue(SKEY_IFA_CAL_VEL_LOW_LIMIT, _velPointLowAlarm);
    /// UPDATE PRESSURE VALAUE BASED ON CURRENT MEASUREMENT UNIT
    if(pData->getSeasInstalled()){
        int pa = pData->getSeasPressureDiffPa();
        _onSeasPressureDiffPaChanged(pa);
    }

    // If not calibrated yet, skip reinit
    if(pData->getAirflowCalibrationStatus() == MachineEnums::AF_CALIB_NONE){
        return;
    }

    /// reinit calibration point when
    initAirflowCalibrationStatus(pData->getAirflowCalibrationStatus());
    //    /// force recalculate velocity
    //    short forceRecalculateVelocity = 2;
    //    m_pAirflowInflow->routineTask(forceRecalculateVelocity);

    //    qDebug() << "getInflowVelocityPointFactory-1" << pData->getInflowVelocityPointFactory(1);
    //    qDebug() << "getInflowVelocityPointFactory-2" << pData->getInflowVelocityPointFactory(2);
    //    qDebug() << "getInflowVelocityPointField-1" << pData->getInflowVelocityPointField(1);
    //    qDebug() << "getInflowVelocityPointField-2" << pData->getInflowVelocityPointField(2);
    //    qDebug() << "getDownflowVelocityPointFactory-2" << pData->getDownflowVelocityPointFactory(2);
    //    qDebug() << "getDownflowVelocityPointField-2" << pData->getDownflowVelocityPointField(2);
    //    qDebug() << "getInflowTempCalib" << pData->getInflowTempCalib();
}

void MachineBackend::setSerialNumber(const QString &value)
{
    qDebug() << metaObject()->className() << __FUNCTION__ << thread();

    pData->setSerialNumber(value);
    QSettings m_settings;
    m_settings.setValue(SKEY_SERIAL_NUMMBER, value);
}

void MachineBackend::_wakeupLcdBrightnessLevel()
{
    short brightness = pData->getLcdBrightnessLevel();
    short brightnessUser = pData->getLcdBrightnessLevelUser();

    if (brightness != brightnessUser) {
        //qWarning() << "!!!!!!!&&&&& Wake Up LCD Brightness" << brightness << brightnessUser;

        /// Smooth the increasing of LCD Brightness
        m_boardCtpIO->setOutputPWM(LEDpca9633_CHANNEL_BL, brightnessUser, I2CPort::I2C_SEND_MODE_QUEUE);

        pData->setLcdBrightnessLevel(brightnessUser);
    }//

    pData->setLcdBrightnessLevelDimmed(false);

    if(pData->getLcdBrightnessDelayToDimm() > 0)
        /// If the timer is already running, it will be stopped and restarted.
        m_timerEventForLcdToDimm->start();
}//

/**
 * @brief MachineBackend::_setTimeZone
 * @param value; example: Asia/Jakarta
 */
void MachineBackend::_setTimeZoneLinux(const QString &value)
{
    Q_UNUSED(value)
#ifdef __linux__
    QProcess().execute("timedatectl", QStringList() << "set-timezone" << value);
#endif

#ifdef __arm__
    QTimer::singleShot(10000, this, [&](){
        _syncLinuxTimeToRtc();
    });
#endif
}
/**
 * @brief MachineBackend::_setDateTime
 * @param value; example 2015-11-20 15:58:30 yyyy-MM-dd hh-mm-ss
 * user subprocess date -s intead timedatectl,
 * because timedatectl not allowed if ntp sync active but date -s does
 */
void MachineBackend::_setDateTimeLinux(const QString &value)
{
    Q_UNUSED(value)
    //    QElapsedTimer elapsed;
    //    elapsed.start();
#ifdef __linux__

    QProcess().execute("date", QStringList() << "-s" << value);

#endif
    // qDebug() << __func__ << elapsed.elapsed() << "ms";
}

bool MachineBackend::_getSystemClockSynchronized()
{
#ifdef __linux__
    QProcess qprocess;
    qprocess.start("timedatectl");
    qprocess.waitForFinished();
    QString out = qprocess.readAllStandardOutput();
    QStringList outList = out.split("\n");
    for(short i=0; i<outList.length(); i++){
        if(outList.at(i).contains("synchronized")){
            out = outList.at(i);
            break;
        }
    }
    //qWarning() << out;
    if(out.contains("yes"))
        return true;
    else
        return false;
#else
    return true;
#endif
}

void MachineBackend::_syncLinuxTimeToRtc()
{
    //// SYNC LINUX TIME TO RTC

    QDateTime dateTimeLinux = QDateTime::currentDateTime();
    qDebug() << metaObject()->className() << __func__
             << "Sync linux time to RTC" << dateTimeLinux.toString("yyyy-MM-dd hh:mm:ss");
    /// if RTC time not valid, set to 2000-01-01 00:00:00
    m_boardCtpRTC->setDateTime(dateTimeLinux.date().weekNumber(),
                               dateTimeLinux.date().day(),
                               dateTimeLinux.date().month(),
                               dateTimeLinux.date().year(),
                               dateTimeLinux.time().hour(),
                               dateTimeLinux.time().minute(),
                               dateTimeLinux.time().second(),
                               I2CPort::I2C_SEND_MODE_QUEUE);
}


QString MachineBackend::_readMacAddress()
{
    qDebug() << metaObject()->className() << __FUNCTION__ << thread();
    QString text = "";

#ifdef __linux__
    foreach(QNetworkInterface interface, QNetworkInterface::allInterfaces())
    {
        text += interface.hardwareAddress()+"#";
    }
#else
    text = SDEF_FULL_MAC_ADDRESS;
#endif

    qDebug() << "MAC:" << text;
    return text;
}

QStringList MachineBackend::_readSbcSystemInformation()
{
    qDebug() << metaObject()->className() << __FUNCTION__ << thread();
    //    qDebug() << sysInfo;
    //    QStringList sysInfo;
    QStringList sysInfo;
    QString sysInfoStr;

    Q_UNUSED(sysInfoStr)
#ifdef __linux__
    QProcess process;

    process.start("cat", QStringList()<<"/proc/cpuinfo");
    process.waitForFinished();
    usleep(1000);
    QString output(process.readAllStandardOutput());
    //    qDebug()<<output;
    QString err(process.readAllStandardError());
    qDebug()<<err;

    sysInfoStr = output.remove(QRegularExpression("[\t]+"));
    sysInfo = sysInfoStr.split("\n", Qt::SkipEmptyParts);

    qDebug() << sysInfo;
#else
    sysInfo = QStringList() << "Unknown";
#endif
    return sysInfo;
}

//std::string trim(const std::string& str,
//                 const std::string& whitespace = " \t")
//{
//    const auto strBegin = str.find_first_not_of(whitespace);
//    if (strBegin == std::string::npos)
//        return ""; // no content

//    const auto strEnd = str.find_last_not_of(whitespace);
//    const auto strRange = strEnd - strBegin + 1;

//    return str.substr(strBegin, strRange);
//}

void MachineBackend::_setHardwareInformation(const QStringList &value)
{
    QStringList sysInfo = value;
    const QString rpizw = "BCM2835"; // RPI Zero W
    const QString bpim2z = "Allwinner sun8i Family"; // BPI M2 Zero
    QString hardwareInfoStr;
    short hardwareInfo = 0;

    for(short i=0; i<sysInfo.length(); i++){
        if(sysInfo.at(i).contains("Hardware")){
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

    pData->setHardwareInformation(hardwareInfo);
}

QString MachineBackend::_readSbcSerialNumber()
{
    qDebug() << metaObject()->className() << __FUNCTION__ << thread();
    //    qDebug() << sysInfo;
    //    QStringList sysInfo;
    QString serialNumber;

#ifdef __linux__
    QProcess process;

    process.start("cat", QStringList() << "/sys/firmware/devicetree/base/serial-number");
    process.waitForFinished();
    usleep(1000);
    QString output(process.readAllStandardOutput());
    qDebug()<<output;
    serialNumber = output;

    QString err(process.readAllStandardError());
    qDebug()<<err;
#else
    serialNumber = SDEF_SBC_SERIAL_NUMBER;
#endif
    qDebug() << "Serial Number:" << serialNumber;
    return serialNumber;
}

void MachineBackend::_setSbcSystemInformation(const QStringList &sysInfo)
{
    qDebug() << metaObject()->className() << __FUNCTION__ << thread();
    //    qDebug() << sysInfo;

    QSettings settings;
    settings.setValue(SKEY_SBC_SYS_INFO, sysInfo);

    pData->setSbcSystemInformation(sysInfo);
}

void MachineBackend::_setSbcCurrentSystemInformation(const QStringList &sysInfo)
{
    qDebug() << metaObject()->className() << __FUNCTION__ << thread();
    //    qDebug() << sysInfo;

    pData->setSbcCurrentSystemInformation(sysInfo);
}

void MachineBackend::_setSbcSerialNumber(const QString &value)
{
    qDebug() << metaObject()->className() << __FUNCTION__ << thread();
    //    qDebug() << sysInfo;

    QSettings settings;
    settings.setValue(SKEY_SBC_SERIAL_NUMBER, value);

    pData->setSbcSerialNumber(value);
}

////////////////////////////////////////////////// API Group for specific cabinet

void MachineBackend::setFanState(short value)
{
    qDebug() << metaObject()->className() << __FUNCTION__ << thread();
    qDebug() << value;

    switch (value) {
    case MachineEnums::FAN_STATE_ON:
    {
        _setFanPrimaryStateNominal();
        if(m_needToCalculateStbRpmField)
            m_needToCalculateStbRpmField = false;

        if((pData->getFilterLifePercent() < 10) && pData->getFilterLifeDisplayEnabled())
            pData->setFilterLifeReminder(true);
        else
            pData->setFilterLifeReminder(false);
    }
    break;
    case MachineEnums::FAN_STATE_STANDBY:
    {
        _setFanPrimaryStateStandby();
        if(pData->getFanPrimaryStandbyRpmField() == 0
            && pData->getAirflowCalibrationStatus() == MachineEnums::AF_CALIB_FIELD){
            m_needToCalculateStbRpmField = true;
            m_countDownTimerCalculateStbRpmField = 30;
        }//
    }//
    break;
    default:
    {
        if(m_needToCalculateStbRpmField) m_needToCalculateStbRpmField = false;
        /// Check if the cabinet want to post purging before actually turned off the blower
        /// Execute postpurging only when fan at nominal speed
        if (!isMaintenanceModeActive() && pData->getFanPrimaryState() == MachineEnums::FAN_STATE_ON) {
            /// IF NO IN PURGING CONDITION
            if(pData->getPostPurgingActive()){
                if(pData->getSashWindowState() == MachineEnums::SASH_STATE_FULLY_CLOSE_SSV){
                    _cancelPostPurgingTime();
                    _setFanPrimaryStateOFF();
                }//
                else{
                    return;
                }//
            }//
            /// IF PURGING TIME MORE THAN ZERO
            else if (pData->getPostPurgingTime()
                     && !pData->getWarmingUpActive()){
                /// NO PURGING WHILE WARMING UP
                /// NO PURGING WHILE ALARMS
                _startPostPurgingTime();
                return;
            }//
        }//
        /// ACTUALY TURNED OFF THE FAN
        _setFanPrimaryStateOFF();
    }//
    break;
    }//
}//

void MachineBackend::setFanPrimaryDutyCycle(short value)
{
    qDebug() << metaObject()->className() << __FUNCTION__ << thread();
    qDebug() << value;

    if(value < 0) return;
    if(value > 100) return;

    _setFanPrimaryDutyCycle(value);
}

void MachineBackend::setFanPrimaryNominalDutyCycleFactory(short value)
{
    qDebug() << metaObject()->className() << __FUNCTION__ << thread();
    qDebug() << value;

    QSettings settings;
    settings.setValue(SKEY_FAN_PRI_NOM_DCY_FACTORY, value);

    pData->setFanPrimaryNominalDutyCycleFactory(value);
}

void MachineBackend::setFanPrimaryNominalRpmFactory(int value)
{
    qDebug() << metaObject()->className() << __FUNCTION__ << thread();
    qDebug() << value;

    QSettings settings;
    settings.setValue(SKEY_FAN_PRI_NOM_RPM_FACTORY, value);

    pData->setFanPrimaryNominalRpmFactory(value);
}

void MachineBackend::setFanPrimaryMinimumDutyCycleFactory(short value)
{
    qDebug() << metaObject()->className() << __FUNCTION__ << thread();
    qDebug() << value;

    QSettings settings;
    settings.setValue(SKEY_FAN_PRI_MIN_DCY_FACTORY, value);

    pData->setFanPrimaryMinimumDutyCycleFactory(value);
}

void MachineBackend::setFanPrimaryMinimumRpmFactory(int value)
{
    qDebug() << metaObject()->className() << __FUNCTION__ << thread();
    qDebug() << value;

    QSettings settings;
    settings.setValue(SKEY_FAN_PRI_MIN_RPM_FACTORY, value);

    pData->setFanPrimaryMinimumRpmFactory(value);
}

void MachineBackend::setFanPrimaryStandbyDutyCycleFactory(short value)
{
    qDebug() << metaObject()->className() << __FUNCTION__ << thread();
    qDebug() << value;

    QSettings settings;
    settings.setValue(SKEY_FAN_PRI_STB_DCY_FACTORY, value);

    pData->setFanPrimaryStandbyDutyCycleFactory(value);
}

void MachineBackend::setFanPrimaryStandbyRpmFactory(int value)
{
    QSettings settings;
    settings.setValue(SKEY_FAN_PRI_STB_RPM_FACTORY, value);

    pData->setFanPrimaryStandbyRpmFactory(value);
}

void MachineBackend::setFanPrimaryNominalDutyCycleField(short value)
{
    qDebug() << metaObject()->className() << __FUNCTION__ << thread();
    qDebug() << value;

    QSettings settings;
    settings.setValue(SKEY_FAN_PRI_NOM_DCY_FIELD, value);

    pData->setFanPrimaryNominalDutyCycleField(value);
}

void MachineBackend::setFanPrimaryNominalRpmField(int value)
{
    qDebug() << metaObject()->className() << __FUNCTION__ << thread();
    qDebug() << value;

    QSettings settings;
    settings.setValue(SKEY_FAN_PRI_NOM_RPM_FIELD, value);

    pData->setFanPrimaryNominalRpmField(value);
}

void MachineBackend::setFanPrimaryMinimumDutyCycleField(short value)
{
    qDebug() << metaObject()->className() << __FUNCTION__ << thread();
    qDebug() << value;

    QSettings settings;
    settings.setValue(SKEY_FAN_PRI_MIN_DCY_FIELD, value);

    pData->setFanPrimaryMinimumDutyCycleField(value);
}

void MachineBackend::setFanPrimaryMinimumRpmField(int value)
{
    qDebug() << metaObject()->className() << __FUNCTION__ << thread();
    qDebug() << value;

    QSettings settings;
    settings.setValue(SKEY_FAN_PRI_MIN_RPM_FIELD, value);

    pData->setFanPrimaryMinimumRpmField(value);
}

void MachineBackend::setFanPrimaryStandbyDutyCycleField(short value)
{
    qDebug() << metaObject()->className() << __FUNCTION__ << thread();
    qDebug() << value;

    QSettings settings;
    settings.setValue(SKEY_FAN_PRI_STB_DCY_FIELD, value);

    pData->setFanPrimaryStandbyDutyCycleField(value);
}

void MachineBackend::setFanPrimaryStandbyRpmField(int value)
{
    QSettings settings;
    settings.setValue(SKEY_FAN_PRI_STB_RPM_FIELD, value);

    pData->setFanPrimaryStandbyRpmField(value);
}

void MachineBackend::setLightIntensity(short lightIntensity)
{
    qDebug() << metaObject()->className() << __FUNCTION__ << thread();
    qDebug() << lightIntensity;

    if(lightIntensity < 30) return;
    if(lightIntensity > 100) return;

    m_pLightIntensity->setState(lightIntensity);
}

void MachineBackend::saveLightIntensity(short lightIntensity)
{
    qDebug() << metaObject()->className() << __FUNCTION__ << thread();
    qDebug() << lightIntensity;

    if(lightIntensity < 30) return;
    if(lightIntensity > 100) return;

    QScopedPointer<QSettings> m_settings(new QSettings);
    m_settings->setValue(SKEY_LIGHT_INTENSITY, lightIntensity);
}

void MachineBackend::setLightState(short lightState)
{
    qDebug() << metaObject()->className() << __FUNCTION__ << thread();
    qDebug() << lightState;

    bool val = lightState;

    m_pLight->setState(val);
    if(val){
        m_pLightIntensity->setState(pData->getLightIntensity());
    }
}

void MachineBackend::setSocketInstalled(short value)
{
    qDebug() << metaObject()->className() << __FUNCTION__ << thread();
    qDebug() << value;

    QSettings m_settings;
    m_settings.setValue(SKEY_SOCKET_INSTALLED, value);
}

void MachineBackend::setSocketState(short socketState)
{
    qDebug() << metaObject()->className() << __FUNCTION__ << thread();
    qDebug() << socketState;

    bool val = socketState;

    m_pSocket->setState(val);
}

void MachineBackend::setGasInstalled(short value)
{
    qDebug() << metaObject()->className() << __FUNCTION__ << thread();
    qDebug() << value;

    QSettings m_settings;
    m_settings.setValue(SKEY_GAS_INSTALLED, value);
}

void MachineBackend::setGasState(short gasState)
{
    qDebug() << metaObject()->className() << __FUNCTION__ << thread();
    qDebug() << gasState;

    bool val = gasState;

    m_pGas->setState(val);
}

void MachineBackend::setUvInstalled(short value)
{
    qDebug() << metaObject()->className() << __FUNCTION__ << thread();
    qDebug() << value;

    QSettings m_settings;
    m_settings.setValue(SKEY_UV_INSTALLED, value);
}

void MachineBackend::setUvState(short uvState)
{
    qDebug() << metaObject()->className() << __FUNCTION__ << thread();
    qDebug() << uvState;

    bool val = uvState;

    m_pUV->setState(val);

    if(val){
        /// Reset UV Time CountDown if action is asked by user
        _setUvTimeCountdown(pData->getUvTime() * 60);
        if(pData->getUvLifePercent() < 10)
            pData->setUvReplacementReminder(true);
        else
            pData->setUvReplacementReminder(false);
    }
}

void MachineBackend::setUvTimeSave(int minutes)
{
    qDebug() << metaObject()->className() << __FUNCTION__ << thread();
    qDebug() << minutes;

    pData->setUvTime(minutes);
    _setUvTimeCountdown(minutes * 60);

    QSettings settings;
    settings.setValue(SKEY_UV_TIME, minutes);
}

void MachineBackend::setWarmingUpTimeSave(short seconds)
{
    qDebug() << metaObject()->className() << __FUNCTION__ << thread();
    qDebug() << seconds;

    pData->setWarmingUpTime(seconds);
    pData->setWarmingUpCountdown(seconds);

    QSettings settings;
    settings.setValue(SKEY_WARMUP_TIME, seconds);
}

void MachineBackend::setPostPurgeTimeSave(short seconds)
{
    qDebug() << metaObject()->className() << __FUNCTION__ << thread();
    qDebug() << seconds;

    pData->setPostPurgingTime(seconds);
    pData->setPostPurgingCountdown(seconds);

    QSettings settings;
    settings.setValue(SKEY_POSTPURGE_TIME, seconds);
}

void MachineBackend::setExhaustContactState(short exhaustContactState)
{
    //    qDebug() << metaObject()->className() << __FUNCTION__ << thread();
    //    qDebug() << exhaustContactState;

//    m_pExhaustContact->setState(exhaustContactState);
    pData->setExhaustContactState(exhaustContactState);
}

void MachineBackend::setAlarmContactState(short alarmContactState)
{
    //    qDebug() << metaObject()->className() << __FUNCTION__ << thread();
    //    qDebug() << alarmContactState;

//    m_pAlarmContact->setState(alarmContactState);
    pData->setAlarmContactState(alarmContactState);
}

void MachineBackend::setSashMotorizeInstalled(short value)
{
    qDebug() << metaObject()->className() << __FUNCTION__ << thread();
    qDebug() << value;

    QSettings m_settings;
    m_settings.setValue(SKEY_SASH_MOTOR_INSTALLED, value);
}

void MachineBackend::setSashMotorizeState(short value)
{
    qDebug() << metaObject()->className() << __FUNCTION__ << thread();
    qDebug() << value;

    int sashCycle = pData->getSashCycleMeter()/10;

    if(sashCycle <= 16000){
        /// Record Previous State of the Sash Window
        pData->setSashWindowPrevState(pData->getSashWindowState());

        m_pHydraulicMotorize->setState(value);
        m_pHydraulicMotorize->routineTask();
        if(!isAlarmNormal(pData->getSashCycleMotorLockedAlarm())){
            pData->setSashCycleMotorLockedAlarm(MachineEnums::ALARM_NORMAL_STATE);
            _insertAlarmLog(ALARM_LOG_CODE::ALC_SASH_MOTOR_OK, _tr(ALARM_LOG_TEXT_SASH_MOTOR_OK));
        }
    }//
    else{
        m_pHydraulicMotorize->setInterlockDown(1);
        m_pHydraulicMotorize->setInterlockUp(1);
        if(!isAlarmActive(pData->getSashCycleMotorLockedAlarm())){
            pData->setSashCycleMotorLockedAlarm(MachineEnums::ALARM_ACTIVE_STATE);
            _insertAlarmLog(ALARM_LOG_CODE::ALC_SASH_MOTOR_LOCKED, _tr(ALARM_LOG_TEXT_SASH_MOTOR_LOCKED));
        }
    }//
}//

void MachineBackend::setSeasFlapInstalled(short value)
{
    qDebug() << metaObject()->className() << __FUNCTION__ << value << thread() ;
    qDebug() << value;

    QSettings m_settings;
    m_settings.setValue(SKEY_SEAS_BOARD_FLAP_INSTALLED, value);
}

void MachineBackend::setSeasBuiltInInstalled(short value)
{
    qDebug() << metaObject()->className() << __FUNCTION__ << thread();
    qDebug() << value;

    QSettings m_settings;
    m_settings.setValue(SKEY_SEAS_INSTALLED, value);
}

void MachineBackend::setSeasPressureDiffPaLowLimit(int value)
{
    qDebug() << metaObject()->className() << __FUNCTION__ << thread();
    qDebug() << value;
    qDebug() << "low pressure set";

    pData-> setSeasPressureDiffPaLowLimit(value);
}

void MachineBackend::setSeasPressureDiffPaOffset(int value)
{
    qDebug() << metaObject()->className() << __FUNCTION__ << thread();
    qDebug() << value;
    qDebug() << "pressure Off set";

    pData->setSeasPressureDiffPaOffset(static_cast<short>(value));
    m_pSeas->setOffsetPa(value);
}

void MachineBackend::setAirflowMonitorEnable(bool airflowMonitorEnable)
{
    qDebug() << metaObject()->className() << __FUNCTION__ << thread();
    qDebug() << airflowMonitorEnable;

    pData->setAirflowMonitorEnable(airflowMonitorEnable);

    QSettings m_settings;
    m_settings.setValue(SKEY_AF_MONITOR_ENABLE, airflowMonitorEnable);

    if(airflowMonitorEnable && (!pData->getWarmingUpTime())){
        /// Set back the warm up timer to 3 minutes
        if(pData->getInflowSensorConstant() != 0)
            setWarmingUpTimeSave(3 * 60);
        else setWarmingUpTimeSave(60);
    }//
}//

void MachineBackend::saveInflowMeaDimNominalGrid(QJsonArray grid, int total,
                                                 int average, int volume,
                                                 int velocity,
                                                 int ducy, int rpm,
                                                 int calibMode)
{
    qDebug() << metaObject()->className() << __FUNCTION__ << thread();

    if(calibMode != MachineEnums::CALIB_MODE_FULL
        && calibMode != MachineEnums::CALIB_MODE_FIELD) return;

    QJsonDocument doc(grid);
    QByteArray docByteArray = doc.toJson(QJsonDocument::Compact);
    QString strJson = QLatin1String(docByteArray);

    //    qDebug() << strJson;

    QString group = calibMode == MachineEnums::CALIB_MODE_FULL ? SKEY_AIRFLOW_MEA_FULL
                                                               : SKEY_AIRFLOW_MEA_FIELD;

    QSettings settings;
    settings.beginGroup(group);

    settings.setValue(SKEY_IFA_CAL_GRID_NOM, strJson);
    if(pData->getMeasurementUnit()){//Imperial
        settings.setValue(SKEY_IFA_CAL_GRID_NOM_VOL_IMP, volume);
        settings.setValue(SKEY_IFA_CAL_GRID_NOM_VEL_IMP, velocity);
        settings.setValue(SKEY_IFA_CAL_GRID_NOM_AVG_IMP, average);
        settings.setValue(SKEY_IFA_CAL_GRID_NOM_TOT_IMP, total);
        //convert to metric
        settings.setValue(SKEY_IFA_CAL_GRID_NOM_VOL, __convertCfmToLs(volume));
        settings.setValue(SKEY_IFA_CAL_GRID_NOM_VEL, __convertFpmToMps(velocity));
        settings.setValue(SKEY_IFA_CAL_GRID_NOM_AVG, __convertCfmToLs(average));
        settings.setValue(SKEY_IFA_CAL_GRID_NOM_TOT, __convertCfmToLs(total));
    }
    else{
        settings.setValue(SKEY_IFA_CAL_GRID_NOM_VOL, volume);
        settings.setValue(SKEY_IFA_CAL_GRID_NOM_VEL, velocity);
        settings.setValue(SKEY_IFA_CAL_GRID_NOM_AVG, average);
        settings.setValue(SKEY_IFA_CAL_GRID_NOM_TOT, total);
        //convert to Imperial
        settings.setValue(SKEY_IFA_CAL_GRID_NOM_VOL_IMP, __convertLsToCfm(volume));
        settings.setValue(SKEY_IFA_CAL_GRID_NOM_VEL_IMP, __convertMpsToFpm(velocity));
        settings.setValue(SKEY_IFA_CAL_GRID_NOM_AVG_IMP, __convertLsToCfm(average));
        settings.setValue(SKEY_IFA_CAL_GRID_NOM_TOT_IMP, __convertLsToCfm(total));
    }
    settings.setValue(SKEY_IFA_CAL_GRID_NOM_DCY, ducy);
    settings.setValue(SKEY_IFA_CAL_GRID_NOM_RPM, rpm);

    settings.endGroup();


    /// Remove Field grid if Calibration Mode is Full Calibration (Factory)
    if(calibMode == MachineEnums::CALIB_MODE_FULL){
        settings.beginGroup(SKEY_AIRFLOW_MEA_FIELD);

        /// DIM METHOD
        settings.remove(SKEY_IFA_CAL_GRID_NOM);
        settings.remove(SKEY_IFA_CAL_GRID_NOM_VOL);
        settings.remove(SKEY_IFA_CAL_GRID_NOM_VEL);
        settings.remove(SKEY_IFA_CAL_GRID_NOM_AVG);
        settings.remove(SKEY_IFA_CAL_GRID_NOM_TOT);
        settings.remove(SKEY_IFA_CAL_GRID_NOM_VOL_IMP);
        settings.remove(SKEY_IFA_CAL_GRID_NOM_VEL_IMP);
        settings.remove(SKEY_IFA_CAL_GRID_NOM_AVG_IMP);
        settings.remove(SKEY_IFA_CAL_GRID_NOM_TOT_IMP);
        settings.remove(SKEY_IFA_CAL_GRID_NOM_DCY);
        settings.remove(SKEY_IFA_CAL_GRID_NOM_RPM);
        /// SECONDARY METHOD
        settings.remove(SKEY_IFA_CAL_GRID_NOM_SEC);
        settings.remove(SKEY_IFA_CAL_GRID_NOM_SEC_TOT);
        settings.remove(SKEY_IFA_CAL_GRID_NOM_SEC_AVG);
        settings.remove(SKEY_IFA_CAL_GRID_NOM_SEC_VEL);
        settings.remove(SKEY_IFA_CAL_GRID_NOM_SEC_TOT_IMP);
        settings.remove(SKEY_IFA_CAL_GRID_NOM_SEC_AVG_IMP);
        settings.remove(SKEY_IFA_CAL_GRID_NOM_SEC_VEL_IMP);
        settings.remove(SKEY_IFA_CAL_GRID_NOM_SEC_DCY);
        settings.remove(SKEY_IFA_CAL_GRID_NOM_SEC_RPM);

        settings.endGroup();
    }//

    //    /// remove the draf
    //    settings.beginGroup("meaifanomDraft");
    //    settings.remove("drafAirflowGridStr");
    //    settings.endGroup();
    //    settings.beginGroup("meaifanomdimfieldDraft");
    //    settings.remove("drafAirflowGridStr");
    //    settings.endGroup();
}//

void MachineBackend::saveInflowMeaDimMinimumGrid(QJsonArray grid,
                                                 int total, int average,
                                                 int volume, int velocity,
                                                 int ducy, int rpm,
                                                 int calibMode)
{
    qDebug() << metaObject()->className() << __FUNCTION__ << thread();

    if(calibMode != MachineEnums::CALIB_MODE_FULL
        && calibMode != MachineEnums::CALIB_MODE_FIELD) return;

    QJsonDocument doc(grid);
    QByteArray docByteArray = doc.toJson(QJsonDocument::Compact);
    QString strJson = QLatin1String(docByteArray);

    QString group = calibMode == MachineEnums::CALIB_MODE_FULL ? SKEY_AIRFLOW_MEA_FULL
                                                               : SKEY_AIRFLOW_MEA_FIELD;
    QSettings settings;
    settings.beginGroup(group);

    settings.setValue(SKEY_IFA_CAL_GRID_MIN, strJson);
    if(pData->getMeasurementUnit()){//Imperial
        settings.setValue(SKEY_IFA_CAL_GRID_MIN_VOL_IMP, volume);
        settings.setValue(SKEY_IFA_CAL_GRID_MIN_VEL_IMP, velocity);
        settings.setValue(SKEY_IFA_CAL_GRID_MIN_AVG_IMP, average);
        settings.setValue(SKEY_IFA_CAL_GRID_MIN_TOT_IMP, total);
        //convert to metric
        settings.setValue(SKEY_IFA_CAL_GRID_MIN_VOL, __convertCfmToLs(volume));
        settings.setValue(SKEY_IFA_CAL_GRID_MIN_VEL, __convertFpmToMps(velocity));
        settings.setValue(SKEY_IFA_CAL_GRID_MIN_AVG, __convertCfmToLs(average));
        settings.setValue(SKEY_IFA_CAL_GRID_MIN_TOT, __convertCfmToLs(total));
    }else{
        settings.setValue(SKEY_IFA_CAL_GRID_MIN_VOL, volume);
        settings.setValue(SKEY_IFA_CAL_GRID_MIN_VEL, velocity);
        settings.setValue(SKEY_IFA_CAL_GRID_MIN_AVG, average);
        settings.setValue(SKEY_IFA_CAL_GRID_MIN_TOT, total);
        //convert to imperial
        settings.setValue(SKEY_IFA_CAL_GRID_MIN_VOL_IMP, __convertLsToCfm(volume));
        settings.setValue(SKEY_IFA_CAL_GRID_MIN_VEL_IMP, __convertMpsToFpm(velocity));
        settings.setValue(SKEY_IFA_CAL_GRID_MIN_AVG_IMP, __convertLsToCfm(average));
        settings.setValue(SKEY_IFA_CAL_GRID_MIN_TOT_IMP, __convertLsToCfm(total));
    }
    settings.setValue(SKEY_IFA_CAL_GRID_MIN_DCY, ducy);
    settings.setValue(SKEY_IFA_CAL_GRID_MIN_RPM, rpm);

    settings.endGroup();

    /// Remove Field grid if Calibration Mode is Full Calibration (Factory)
    if(calibMode == MachineEnums::CALIB_MODE_FULL){
        settings.beginGroup(SKEY_AIRFLOW_MEA_FIELD);

        /// DIM METHOD
        settings.remove(SKEY_IFA_CAL_GRID_MIN);
        settings.remove(SKEY_IFA_CAL_GRID_MIN_VOL);
        settings.remove(SKEY_IFA_CAL_GRID_MIN_VEL);
        settings.remove(SKEY_IFA_CAL_GRID_MIN_AVG);
        settings.remove(SKEY_IFA_CAL_GRID_MIN_TOT);
        settings.remove(SKEY_IFA_CAL_GRID_MIN_VOL_IMP);
        settings.remove(SKEY_IFA_CAL_GRID_MIN_VEL_IMP);
        settings.remove(SKEY_IFA_CAL_GRID_MIN_AVG_IMP);
        settings.remove(SKEY_IFA_CAL_GRID_MIN_TOT_IMP);
        settings.remove(SKEY_IFA_CAL_GRID_MIN_DCY);
        settings.remove(SKEY_IFA_CAL_GRID_MIN_RPM);
        /// SECONDARY METHOD
        settings.remove(SKEY_IFA_CAL_GRID_MIN_SEC);
        settings.remove(SKEY_IFA_CAL_GRID_MIN_SEC_TOT);
        settings.remove(SKEY_IFA_CAL_GRID_MIN_SEC_AVG);
        settings.remove(SKEY_IFA_CAL_GRID_MIN_SEC_VEL);
        settings.remove(SKEY_IFA_CAL_GRID_MIN_SEC_TOT_IMP);
        settings.remove(SKEY_IFA_CAL_GRID_MIN_SEC_AVG_IMP);
        settings.remove(SKEY_IFA_CAL_GRID_MIN_SEC_VEL_IMP);
        settings.remove(SKEY_IFA_CAL_GRID_MIN_SEC_DCY);
        settings.remove(SKEY_IFA_CAL_GRID_MIN_SEC_RPM);

        settings.endGroup();
    }//

    //    settings.beginGroup("meaifaminDraft");
    //    settings.remove("drafAirflowGridStr");
    //    settings.endGroup();
}

void MachineBackend::saveInflowMeaDimStandbyGrid(QJsonArray grid, int total,
                                                 int average, int volume,
                                                 int velocity,
                                                 int ducy, int rpm,
                                                 int calibMode)
{
    qDebug() << metaObject()->className() << __FUNCTION__ << thread();

    if(calibMode != MachineEnums::CALIB_MODE_FULL
        && calibMode != MachineEnums::CALIB_MODE_FIELD) return;

    QJsonDocument doc(grid);
    QByteArray docByteArray = doc.toJson(QJsonDocument::Compact);
    QString strJson = QLatin1String(docByteArray);

    QString group = calibMode == MachineEnums::CALIB_MODE_FULL ? SKEY_AIRFLOW_MEA_FULL
                                                               : SKEY_AIRFLOW_MEA_FIELD;
    //    qDebug() << strJson;

    QSettings settings;
    settings.beginGroup(group);

    settings.setValue(SKEY_IFA_CAL_GRID_STB, strJson);
    if(pData->getMeasurementUnit()){//Imperial
        settings.setValue(SKEY_IFA_CAL_GRID_STB_VOL_IMP, volume);
        settings.setValue(SKEY_IFA_CAL_GRID_STB_VEL_IMP, velocity);
        settings.setValue(SKEY_IFA_CAL_GRID_STB_AVG_IMP, average);
        settings.setValue(SKEY_IFA_CAL_GRID_STB_TOT_IMP, total);

        settings.setValue(SKEY_IFA_CAL_GRID_STB_VOL, __convertCfmToLs(volume));
        settings.setValue(SKEY_IFA_CAL_GRID_STB_VEL, __convertFpmToMps(velocity));
        settings.setValue(SKEY_IFA_CAL_GRID_STB_AVG, __convertCfmToLs(average));
        settings.setValue(SKEY_IFA_CAL_GRID_STB_TOT, __convertCfmToLs(total));
    }else{
        settings.setValue(SKEY_IFA_CAL_GRID_STB_VOL, volume);
        settings.setValue(SKEY_IFA_CAL_GRID_STB_VEL, velocity);
        settings.setValue(SKEY_IFA_CAL_GRID_STB_AVG, average);
        settings.setValue(SKEY_IFA_CAL_GRID_STB_TOT, total);

        settings.setValue(SKEY_IFA_CAL_GRID_STB_VOL_IMP, __convertLsToCfm(volume));
        settings.setValue(SKEY_IFA_CAL_GRID_STB_VEL_IMP, __convertMpsToFpm(velocity));
        settings.setValue(SKEY_IFA_CAL_GRID_STB_AVG_IMP, __convertLsToCfm(average));
        settings.setValue(SKEY_IFA_CAL_GRID_STB_TOT_IMP, __convertLsToCfm(total));
    }
    settings.setValue(SKEY_IFA_CAL_GRID_STB_DCY, ducy);
    settings.setValue(SKEY_IFA_CAL_GRID_STB_RPM, rpm);

    settings.endGroup();

    /// Remove Field grid if Calibration Mode is Full Calibration (Factory)
    if(calibMode == MachineEnums::CALIB_MODE_FULL){
        settings.beginGroup(SKEY_AIRFLOW_MEA_FIELD);

        /// DIM METHOD
        settings.remove(SKEY_IFA_CAL_GRID_STB);
        settings.remove(SKEY_IFA_CAL_GRID_STB_VOL);
        settings.remove(SKEY_IFA_CAL_GRID_STB_VEL);
        settings.remove(SKEY_IFA_CAL_GRID_STB_AVG);
        settings.remove(SKEY_IFA_CAL_GRID_STB_TOT);
        settings.remove(SKEY_IFA_CAL_GRID_STB_VOL_IMP);
        settings.remove(SKEY_IFA_CAL_GRID_STB_VEL_IMP);
        settings.remove(SKEY_IFA_CAL_GRID_STB_AVG_IMP);
        settings.remove(SKEY_IFA_CAL_GRID_STB_TOT_IMP);
        settings.remove(SKEY_IFA_CAL_GRID_STB_DCY);
        settings.remove(SKEY_IFA_CAL_GRID_STB_RPM);
        /// SECONDARY METHOD
        settings.remove(SKEY_IFA_CAL_GRID_STB_SEC);
        settings.remove(SKEY_IFA_CAL_GRID_STB_SEC_TOT);
        settings.remove(SKEY_IFA_CAL_GRID_STB_SEC_AVG);
        settings.remove(SKEY_IFA_CAL_GRID_STB_SEC_VEL);
        settings.remove(SKEY_IFA_CAL_GRID_STB_SEC_TOT_IMP);
        settings.remove(SKEY_IFA_CAL_GRID_STB_SEC_AVG_IMP);
        settings.remove(SKEY_IFA_CAL_GRID_STB_SEC_VEL_IMP);
        settings.remove(SKEY_IFA_CAL_GRID_STB_SEC_DCY);
        settings.remove(SKEY_IFA_CAL_GRID_STB_SEC_RPM);

        settings.endGroup();
    }//

    //    settings.beginGroup("meaifastbDraft");
    //    settings.remove("drafAirflowGridStr");
    //    settings.endGroup();

    //    qDebug() << "StandBy Value Cal " << volume << velocity << average << total << ducy;
}

void MachineBackend::saveInflowMeaSecNominalGrid(const QJsonArray grid,
                                                 int total, int average,
                                                 int velocity,
                                                 int ducy, int rpm,
                                                 int calibMode)
{
    qDebug() << metaObject()->className() << __FUNCTION__ << thread();

    if(calibMode != MachineEnums::CALIB_MODE_FULL
        && calibMode != MachineEnums::CALIB_MODE_FIELD) return;

    QJsonDocument doc(grid);
    QByteArray docByteArray = doc.toJson(QJsonDocument::Compact);
    QString strJson = QLatin1String(docByteArray);

    QString group = calibMode == MachineEnums::CALIB_MODE_FULL ? SKEY_AIRFLOW_MEA_FULL
                                                               : SKEY_AIRFLOW_MEA_FIELD;
    //    qDebug() << strJson;

    QSettings settings;
    settings.beginGroup(group);

    //    switch (calibMode) {
    //    case MachineEnums::CALIB_MODE_FULL:
    settings.setValue(SKEY_IFA_CAL_GRID_NOM_SEC, strJson);
    if(pData->getMeasurementUnit()){//Imperial
        settings.setValue(SKEY_IFA_CAL_GRID_NOM_SEC_TOT_IMP, total);
        settings.setValue(SKEY_IFA_CAL_GRID_NOM_SEC_AVG_IMP, average);
        settings.setValue(SKEY_IFA_CAL_GRID_NOM_SEC_VEL_IMP, velocity);
        //convert to metric
        settings.setValue(SKEY_IFA_CAL_GRID_NOM_SEC_TOT, __convertCfmToLs(total));
        settings.setValue(SKEY_IFA_CAL_GRID_NOM_SEC_AVG, __convertCfmToLs(average));
        settings.setValue(SKEY_IFA_CAL_GRID_NOM_SEC_VEL, __convertFpmToMps(velocity));
    }else{
        settings.setValue(SKEY_IFA_CAL_GRID_NOM_SEC_TOT, total);
        settings.setValue(SKEY_IFA_CAL_GRID_NOM_SEC_AVG, average);
        settings.setValue(SKEY_IFA_CAL_GRID_NOM_SEC_VEL, velocity);
        //convert to imperial
        settings.setValue(SKEY_IFA_CAL_GRID_NOM_SEC_TOT_IMP, __convertLsToCfm(total));
        settings.setValue(SKEY_IFA_CAL_GRID_NOM_SEC_AVG_IMP, __convertLsToCfm(average));
        settings.setValue(SKEY_IFA_CAL_GRID_NOM_SEC_VEL_IMP, __convertMpsToFpm(velocity));
    }
    settings.setValue(SKEY_IFA_CAL_GRID_NOM_SEC_DCY, ducy);
    settings.setValue(SKEY_IFA_CAL_GRID_NOM_SEC_RPM, rpm);

    settings.endGroup();

    /// Remove Field grid if Calibration Mode is Full Calibration (Factory)
    if(calibMode == MachineEnums::CALIB_MODE_FULL){
        settings.beginGroup(SKEY_AIRFLOW_MEA_FIELD);

        /// DIM METHOD
        settings.remove(SKEY_IFA_CAL_GRID_NOM);
        settings.remove(SKEY_IFA_CAL_GRID_NOM_VOL);
        settings.remove(SKEY_IFA_CAL_GRID_NOM_VEL);
        settings.remove(SKEY_IFA_CAL_GRID_NOM_AVG);
        settings.remove(SKEY_IFA_CAL_GRID_NOM_TOT);
        settings.remove(SKEY_IFA_CAL_GRID_NOM_VOL_IMP);
        settings.remove(SKEY_IFA_CAL_GRID_NOM_VEL_IMP);
        settings.remove(SKEY_IFA_CAL_GRID_NOM_AVG_IMP);
        settings.remove(SKEY_IFA_CAL_GRID_NOM_TOT_IMP);
        settings.remove(SKEY_IFA_CAL_GRID_NOM_DCY);
        settings.remove(SKEY_IFA_CAL_GRID_NOM_RPM);
        /// SECONDARY METHOD
        settings.remove(SKEY_IFA_CAL_GRID_NOM_SEC);
        settings.remove(SKEY_IFA_CAL_GRID_NOM_SEC_TOT);
        settings.remove(SKEY_IFA_CAL_GRID_NOM_SEC_AVG);
        settings.remove(SKEY_IFA_CAL_GRID_NOM_SEC_VEL);
        settings.remove(SKEY_IFA_CAL_GRID_NOM_SEC_TOT_IMP);
        settings.remove(SKEY_IFA_CAL_GRID_NOM_SEC_AVG_IMP);
        settings.remove(SKEY_IFA_CAL_GRID_NOM_SEC_VEL_IMP);
        settings.remove(SKEY_IFA_CAL_GRID_NOM_SEC_DCY);
        settings.remove(SKEY_IFA_CAL_GRID_NOM_SEC_RPM);

        settings.endGroup();
    }//

    //    settings.beginGroup("meaifanomsecDraft");
    //    settings.remove("drafAirflowGridStr");
    //    settings.endGroup();

    //    settings.beginGroup("meaifanomsecfieldDraft");
    //    settings.remove("drafAirflowGridStr");
    //    settings.endGroup();
}

void MachineBackend::saveInflowMeaSecMinimumGrid(const QJsonArray grid,
                                                 int total, int average,
                                                 int velocity,
                                                 int ducy, int rpm,
                                                 int calibMode)
{
    qDebug() << metaObject()->className() << __FUNCTION__ << thread();

    if(calibMode != MachineEnums::CALIB_MODE_FULL
        && calibMode != MachineEnums::CALIB_MODE_FIELD) return;

    QJsonDocument doc(grid);
    QByteArray docByteArray = doc.toJson(QJsonDocument::Compact);
    QString strJson = QLatin1String(docByteArray);

    QString group = calibMode == MachineEnums::CALIB_MODE_FULL ? SKEY_AIRFLOW_MEA_FULL
                                                               : SKEY_AIRFLOW_MEA_FIELD;

    //    qDebug() << strJson;

    QSettings settings;
    settings.beginGroup(group);

    settings.setValue(SKEY_IFA_CAL_GRID_MIN_SEC, strJson);
    if(pData->getMeasurementUnit()){//Imperial
        settings.setValue(SKEY_IFA_CAL_GRID_MIN_SEC_TOT_IMP, total);
        settings.setValue(SKEY_IFA_CAL_GRID_MIN_SEC_AVG_IMP, average);
        settings.setValue(SKEY_IFA_CAL_GRID_MIN_SEC_VEL_IMP, velocity);
        //convert to metric
        settings.setValue(SKEY_IFA_CAL_GRID_MIN_SEC_TOT, __convertCfmToLs(total));
        settings.setValue(SKEY_IFA_CAL_GRID_MIN_SEC_AVG, __convertCfmToLs(average));
        settings.setValue(SKEY_IFA_CAL_GRID_MIN_SEC_VEL, __convertFpmToMps(velocity));
    }else{
        settings.setValue(SKEY_IFA_CAL_GRID_MIN_SEC_TOT, total);
        settings.setValue(SKEY_IFA_CAL_GRID_MIN_SEC_AVG, average);
        settings.setValue(SKEY_IFA_CAL_GRID_MIN_SEC_VEL, velocity);
        //convert to imperial
        settings.setValue(SKEY_IFA_CAL_GRID_MIN_SEC_TOT_IMP, __convertLsToCfm(total));
        settings.setValue(SKEY_IFA_CAL_GRID_MIN_SEC_AVG_IMP, __convertLsToCfm(average));
        settings.setValue(SKEY_IFA_CAL_GRID_MIN_SEC_VEL_IMP, __convertMpsToFpm(velocity));
    }
    settings.setValue(SKEY_IFA_CAL_GRID_MIN_SEC_DCY, ducy);
    settings.setValue(SKEY_IFA_CAL_GRID_MIN_SEC_RPM, rpm);

    settings.endGroup();

    /// Remove Field grid if Calibration Mode is Full Calibration (Factory)
    if(calibMode == MachineEnums::CALIB_MODE_FULL){
        settings.beginGroup(SKEY_AIRFLOW_MEA_FIELD);

        /// DIM METHOD
        settings.remove(SKEY_IFA_CAL_GRID_MIN);
        settings.remove(SKEY_IFA_CAL_GRID_MIN_VOL);
        settings.remove(SKEY_IFA_CAL_GRID_MIN_VEL);
        settings.remove(SKEY_IFA_CAL_GRID_MIN_AVG);
        settings.remove(SKEY_IFA_CAL_GRID_MIN_TOT);
        settings.remove(SKEY_IFA_CAL_GRID_MIN_VOL_IMP);
        settings.remove(SKEY_IFA_CAL_GRID_MIN_VEL_IMP);
        settings.remove(SKEY_IFA_CAL_GRID_MIN_AVG_IMP);
        settings.remove(SKEY_IFA_CAL_GRID_MIN_TOT_IMP);
        settings.remove(SKEY_IFA_CAL_GRID_MIN_DCY);
        settings.remove(SKEY_IFA_CAL_GRID_MIN_RPM);
        /// SECONDARY METHOD
        settings.remove(SKEY_IFA_CAL_GRID_MIN_SEC);
        settings.remove(SKEY_IFA_CAL_GRID_MIN_SEC_TOT);
        settings.remove(SKEY_IFA_CAL_GRID_MIN_SEC_AVG);
        settings.remove(SKEY_IFA_CAL_GRID_MIN_SEC_VEL);
        settings.remove(SKEY_IFA_CAL_GRID_MIN_SEC_TOT_IMP);
        settings.remove(SKEY_IFA_CAL_GRID_MIN_SEC_AVG_IMP);
        settings.remove(SKEY_IFA_CAL_GRID_MIN_SEC_VEL_IMP);
        settings.remove(SKEY_IFA_CAL_GRID_MIN_SEC_DCY);
        settings.remove(SKEY_IFA_CAL_GRID_MIN_SEC_RPM);

        settings.endGroup();
    }//
}

void MachineBackend::saveInflowMeaSecStandbyGrid(const QJsonArray grid,
                                                 int total, int average,
                                                 int velocity,
                                                 int ducy, int rpm,
                                                 int calibMode)
{
    qDebug() << metaObject()->className() << __FUNCTION__ << thread();

    if(calibMode != MachineEnums::CALIB_MODE_FULL
        && calibMode != MachineEnums::CALIB_MODE_FIELD) return;

    QJsonDocument doc(grid);
    QByteArray docByteArray = doc.toJson(QJsonDocument::Compact);
    QString strJson = QLatin1String(docByteArray);

    QString group = calibMode == MachineEnums::CALIB_MODE_FULL ? SKEY_AIRFLOW_MEA_FULL
                                                               : SKEY_AIRFLOW_MEA_FIELD;

    //    qDebug() << strJson;

    QSettings settings;
    settings.beginGroup(group);

    settings.setValue(SKEY_IFA_CAL_GRID_STB_SEC, strJson);
    if(pData->getMeasurementUnit()){//Imperial
        settings.setValue(SKEY_IFA_CAL_GRID_STB_SEC_TOT_IMP, total);
        settings.setValue(SKEY_IFA_CAL_GRID_STB_SEC_AVG_IMP, average);
        settings.setValue(SKEY_IFA_CAL_GRID_STB_SEC_VEL_IMP, velocity);
        //convert to metric
        settings.setValue(SKEY_IFA_CAL_GRID_STB_SEC_TOT, __convertCfmToLs(total));
        settings.setValue(SKEY_IFA_CAL_GRID_STB_SEC_AVG, __convertCfmToLs(average));
        settings.setValue(SKEY_IFA_CAL_GRID_STB_SEC_VEL, __convertFpmToMps(velocity));
    }else{
        settings.setValue(SKEY_IFA_CAL_GRID_STB_SEC_TOT, total);
        settings.setValue(SKEY_IFA_CAL_GRID_STB_SEC_AVG, average);
        settings.setValue(SKEY_IFA_CAL_GRID_STB_SEC_VEL, velocity);
        //convert to imperial
        settings.setValue(SKEY_IFA_CAL_GRID_STB_SEC_TOT_IMP, __convertLsToCfm(total));
        settings.setValue(SKEY_IFA_CAL_GRID_STB_SEC_AVG_IMP, __convertLsToCfm(average));
        settings.setValue(SKEY_IFA_CAL_GRID_STB_SEC_VEL_IMP, __convertMpsToFpm(velocity));
    }
    settings.setValue(SKEY_IFA_CAL_GRID_STB_SEC_DCY, ducy);
    settings.setValue(SKEY_IFA_CAL_GRID_STB_SEC_RPM, rpm);

    settings.endGroup();

    /// Remove Field grid if Calibration Mode is Full Calibration (Factory)
    if(calibMode == MachineEnums::CALIB_MODE_FULL){
        settings.beginGroup(SKEY_AIRFLOW_MEA_FIELD);

        /// DIM METHOD
        settings.remove(SKEY_IFA_CAL_GRID_STB);
        settings.remove(SKEY_IFA_CAL_GRID_STB_VOL);
        settings.remove(SKEY_IFA_CAL_GRID_STB_VEL);
        settings.remove(SKEY_IFA_CAL_GRID_STB_AVG);
        settings.remove(SKEY_IFA_CAL_GRID_STB_TOT);
        settings.remove(SKEY_IFA_CAL_GRID_STB_VOL_IMP);
        settings.remove(SKEY_IFA_CAL_GRID_STB_VEL_IMP);
        settings.remove(SKEY_IFA_CAL_GRID_STB_AVG_IMP);
        settings.remove(SKEY_IFA_CAL_GRID_STB_TOT_IMP);
        settings.remove(SKEY_IFA_CAL_GRID_STB_DCY);
        settings.remove(SKEY_IFA_CAL_GRID_STB_RPM);
        /// SECONDARY METHOD
        settings.remove(SKEY_IFA_CAL_GRID_STB_SEC);
        settings.remove(SKEY_IFA_CAL_GRID_STB_SEC_TOT);
        settings.remove(SKEY_IFA_CAL_GRID_STB_SEC_AVG);
        settings.remove(SKEY_IFA_CAL_GRID_STB_SEC_VEL);
        settings.remove(SKEY_IFA_CAL_GRID_STB_SEC_TOT_IMP);
        settings.remove(SKEY_IFA_CAL_GRID_STB_SEC_AVG_IMP);
        settings.remove(SKEY_IFA_CAL_GRID_STB_SEC_VEL_IMP);
        settings.remove(SKEY_IFA_CAL_GRID_STB_SEC_DCY);
        settings.remove(SKEY_IFA_CAL_GRID_STB_SEC_RPM);

        settings.endGroup();
    }//
}//

/**
 * @brief MachineBackend::setInflowSensorConstant
 * @param value
 * This only set the sensor inflow contant for temporary
 * after system restarting,
 */
void MachineBackend::setInflowSensorConstantTemporary(short value)
{
    qDebug() << metaObject()->className() << __FUNCTION__ << thread();
    qDebug() << value;

    m_pAirflowInflow->setConstant(value);
    // force calling airflow routine task
    m_pAirflowInflow->routineTask();
}

void MachineBackend::_setFanPrimaryDutyCycle(short dutyCycle)
{
    qDebug() << metaObject()->className() << __FUNCTION__ << thread();
    qDebug() << "Set fan duty" << dutyCycle << "%";
    /// talk to another thread
    /// append pending task to target object and target thread
    QMetaObject::invokeMethod(m_pFanPrimary.data(),[&, dutyCycle]{
            m_pFanPrimary->setDutyCycle(dutyCycle);
        },
        Qt::QueuedConnection);
}

void MachineBackend::_setFanPrimaryInterlocked(bool interlocked)
{
    /// talk to another thread
    /// append pending task to target object and target thread
    QMetaObject::invokeMethod(m_pFanPrimary.data(),[&, interlocked]{
            m_pFanPrimary->setInterlock(interlocked);
        },
        Qt::QueuedConnection);
    //    pData->setFanPrimaryInterlocked(interlocked);
}

void MachineBackend::setInflowAdcPointField(int pointZero, int pointMin, int pointNom)
{
    qDebug() << metaObject()->className() << __FUNCTION__ << pointZero << pointMin << pointNom << thread();

    QSettings settings;
    settings.setValue(QString(SKEY_IFA_CAL_ADC_FIELD) + "0", pointZero);
    settings.setValue(QString(SKEY_IFA_CAL_ADC_FIELD) + "1", pointMin);
    settings.setValue(QString(SKEY_IFA_CAL_ADC_FIELD) + "2", pointNom);

    pData->setInflowAdcPointField(0, pointZero);
    pData->setInflowAdcPointField(1, pointMin);
    pData->setInflowAdcPointField(2, pointNom);
}

void MachineBackend::setInflowAdcPointField(int point, int value)
{
    qDebug() << metaObject()->className() << __FUNCTION__ << point << value << thread();
    QSettings settings;
    settings.setValue(QString(SKEY_IFA_CAL_ADC_FIELD) + QString::number(point), value);

    pData->setInflowAdcPointField(static_cast<short>(point), value);
}

void MachineBackend::setInflowVelocityPointField(int pointZero, int pointMin, int pointNom)
{
    qDebug() << metaObject()->className() << __FUNCTION__ << pointZero << pointMin << pointNom << thread();
    Q_UNUSED(pointZero)
    QSettings settings;
    settings.setValue(QString(SKEY_IFA_CAL_VEL_FIELD) + "1", pointMin);
    settings.setValue(QString(SKEY_IFA_CAL_VEL_FIELD) + "2", pointNom);

    pData->setInflowVelocityPointField(1, pointMin);
    pData->setInflowVelocityPointField(2, pointNom);
}

void MachineBackend::setInflowVelocityPointField(int point, int value)
{
    qDebug() << metaObject()->className() << __FUNCTION__ << point << value << thread();
    QSettings settings;
    settings.setValue(QString(SKEY_IFA_CAL_VEL_FIELD) + QString::number(point), value);

    pData->setInflowVelocityPointField(static_cast<short>(point), value);
}

void MachineBackend::setInflowSensorConstant(short value)
{
    qDebug() << metaObject()->className() << __FUNCTION__ << value << thread();

    QSettings settings;
    settings.setValue(SKEY_IFA_SENSOR_CONST, value);

    pData->setInflowSensorConstant(value);

    int botLim = pData->getMeasurementUnit() ? 64 : 18;
    int topLim = pData->getMeasurementUnit() ? 86 : 30;
    //Adjust the temp limit
    if(!value)//5-35C
    {
        botLim = pData->getMeasurementUnit() ? 41 : 5;
        topLim = pData->getMeasurementUnit() ? 95 : 35;
    }

    setEnvTempLowestLimit(botLim);
    setEnvTempHighestLimit(topLim);
}

void MachineBackend::setInflowTemperatureCalib(short value, int adc)
{
    qDebug() << metaObject()->className() << __FUNCTION__ << value << adc << thread();

    QSettings settings;

    settings.setValue(SKEY_IFA_CAL_TEMP, value);
    settings.setValue(SKEY_IFA_CAL_TEMP_ADC, adc);

    pData->setInflowTempCalib(value);
    pData->setInflowTempCalibAdc(static_cast<short>(adc));
}

void MachineBackend::setInflowAdcPointFactory(int pointZero, int pointMin, int pointNom)
{
    qDebug() << metaObject()->className() << __FUNCTION__ << thread();

    QSettings settings;
    settings.setValue(QString(SKEY_IFA_CAL_ADC_FACTORY) + "0", pointZero);
    settings.setValue(QString(SKEY_IFA_CAL_ADC_FACTORY) + "1", pointMin);
    settings.setValue(QString(SKEY_IFA_CAL_ADC_FACTORY) + "2", pointNom);

    pData->setInflowAdcPointFactory(0, pointZero);
    pData->setInflowAdcPointFactory(1, pointMin);
    pData->setInflowAdcPointFactory(2, pointNom);
}

void MachineBackend::setInflowAdcPointFactory(int point, int value)
{
    qDebug() << metaObject()->className() << __FUNCTION__ << point << value << thread();

    QSettings settings;
    settings.setValue(QString(SKEY_IFA_CAL_ADC_FACTORY) + QString::number(point), value);

    pData->setInflowAdcPointFactory(static_cast<short>(point), value);
}

void MachineBackend::setInflowVelocityPointFactory(int pointZero, int pointMin, int pointNom)
{
    qDebug() << metaObject()->className() << __FUNCTION__ << pointZero << pointMin << thread();
    QSettings settings;
    settings.setValue(QString(SKEY_IFA_CAL_VEL_FACTORY) + "1", pointMin);
    settings.setValue(QString(SKEY_IFA_CAL_VEL_FACTORY) + "2", pointNom);

    pData->setInflowVelocityPointFactory(1, pointMin);
    pData->setInflowVelocityPointFactory(2, pointNom);
}

void MachineBackend::setInflowVelocityPointFactory(int point, int value)
{
    qDebug() << metaObject()->className() << __FUNCTION__ << point << value << thread();
    QSettings settings;
    settings.setValue(QString(SKEY_IFA_CAL_VEL_FACTORY) + QString::number(point), value);

    pData->setInflowVelocityPointFactory(static_cast<short>(point), value);
}

void MachineBackend::setInflowLowLimitVelocity(short value)
{
    qDebug() << metaObject()->className() << __FUNCTION__ << value << thread();
    QSettings settings;
    settings.setValue(SKEY_IFA_CAL_VEL_LOW_LIMIT, value);

    pData->setInflowLowLimitVelocity(value);
}

void MachineBackend::saveDownflowMeaNominalGrid(const QJsonArray grid, int total,
                                                int velocity,
                                                int velocityLowest, int velocityHighest,
                                                int deviation, int deviationp,
                                                int calibMode)
{
    qDebug() << metaObject()->className() << __FUNCTION__ << thread();

    if(calibMode != MachineEnums::CALIB_MODE_FULL
        && calibMode != MachineEnums::CALIB_MODE_FIELD) return;

    QJsonDocument doc(grid);
    QByteArray docByteArray = doc.toJson(QJsonDocument::Compact);
    QString strJson = QLatin1String(docByteArray);

    QString group = calibMode == MachineEnums::CALIB_MODE_FULL ? SKEY_AIRFLOW_MEA_FULL
                                                               : SKEY_AIRFLOW_MEA_FIELD;

    //    qDebug() << strJson;

    QSettings settings;
    settings.beginGroup(group);

    //    switch (fullField) {
    //    case MachineEnums::CALIB_MODE_FULL:
    settings.setValue(SKEY_DFA_CAL_GRID_NOM, strJson);
    if(pData->getMeasurementUnit())//Imperial
    {
        settings.setValue(SKEY_DFA_CAL_GRID_NOM_VEL_IMP, velocity);
        settings.setValue(SKEY_DFA_CAL_GRID_NOM_VEL_TOT_IMP, total);
        settings.setValue(SKEY_DFA_CAL_GRID_NOM_VEL_LOW_IMP, velocityLowest);
        settings.setValue(SKEY_DFA_CAL_GRID_NOM_VEL_HIGH_IMP, velocityHighest);
        settings.setValue(SKEY_DFA_CAL_GRID_NOM_VEL_DEV_IMP, deviation);
        settings.setValue(SKEY_DFA_CAL_GRID_NOM_VEL_DEVP_IMP, deviationp);
        //convert to metric
        settings.setValue(SKEY_DFA_CAL_GRID_NOM_VEL, __convertFpmToMps(velocity));
        settings.setValue(SKEY_DFA_CAL_GRID_NOM_VEL_TOT, __convertFpmToMps(total));
        settings.setValue(SKEY_DFA_CAL_GRID_NOM_VEL_LOW, __convertFpmToMps(velocityLowest));
        settings.setValue(SKEY_DFA_CAL_GRID_NOM_VEL_HIGH, __convertFpmToMps(velocityHighest));
        settings.setValue(SKEY_DFA_CAL_GRID_NOM_VEL_DEV, __convertFpmToMps(deviation));
        settings.setValue(SKEY_DFA_CAL_GRID_NOM_VEL_DEVP, (deviationp));
    }else{
        settings.setValue(SKEY_DFA_CAL_GRID_NOM_VEL, velocity);
        settings.setValue(SKEY_DFA_CAL_GRID_NOM_VEL_TOT, total);
        settings.setValue(SKEY_DFA_CAL_GRID_NOM_VEL_LOW, velocityLowest);
        settings.setValue(SKEY_DFA_CAL_GRID_NOM_VEL_HIGH, velocityHighest);
        settings.setValue(SKEY_DFA_CAL_GRID_NOM_VEL_DEV, deviation);
        settings.setValue(SKEY_DFA_CAL_GRID_NOM_VEL_DEVP, deviationp);
        //convert to imperial
        settings.setValue(SKEY_DFA_CAL_GRID_NOM_VEL_IMP, __convertMpsToFpm(velocity));
        settings.setValue(SKEY_DFA_CAL_GRID_NOM_VEL_TOT_IMP, __convertMpsToFpm(total));
        settings.setValue(SKEY_DFA_CAL_GRID_NOM_VEL_LOW_IMP, __convertMpsToFpm(velocityLowest));
        settings.setValue(SKEY_DFA_CAL_GRID_NOM_VEL_HIGH_IMP, __convertMpsToFpm(velocityHighest));
        settings.setValue(SKEY_DFA_CAL_GRID_NOM_VEL_DEV_IMP, __convertMpsToFpm(deviation));
        settings.setValue(SKEY_DFA_CAL_GRID_NOM_VEL_DEVP_IMP, (deviationp));
    }//

    //        qDebug() << "CALIB_MODE_FULL_DOWNFLOW_BACKEND" << strJson;

    settings.endGroup();

    if(calibMode == MachineEnums::CALIB_MODE_FULL){
        /// If performed factory/full calibration
        /// it's necessary to remove field calibration value
        settings.beginGroup(SKEY_AIRFLOW_MEA_FIELD);

        settings.remove(SKEY_DFA_CAL_GRID_NOM);
        settings.remove(SKEY_DFA_CAL_GRID_NOM_VEL);
        settings.remove(SKEY_DFA_CAL_GRID_NOM_VEL_TOT);
        settings.remove(SKEY_DFA_CAL_GRID_NOM_VEL_LOW);
        settings.remove(SKEY_DFA_CAL_GRID_NOM_VEL_HIGH);
        settings.remove(SKEY_DFA_CAL_GRID_NOM_VEL_DEV);
        settings.remove(SKEY_DFA_CAL_GRID_NOM_VEL_DEVP);

        settings.remove(SKEY_DFA_CAL_GRID_NOM_VEL_IMP);
        settings.remove(SKEY_DFA_CAL_GRID_NOM_VEL_TOT_IMP);
        settings.remove(SKEY_DFA_CAL_GRID_NOM_VEL_LOW_IMP);
        settings.remove(SKEY_DFA_CAL_GRID_NOM_VEL_HIGH_IMP);
        settings.remove(SKEY_DFA_CAL_GRID_NOM_VEL_DEV_IMP);
        settings.remove(SKEY_DFA_CAL_GRID_NOM_VEL_DEVP_IMP);

        settings.endGroup();
    }//

    //    settings.beginGroup("meadfanomDraft");
    //    settings.remove("drafAirflowGridStr");
    //    settings.endGroup();
    //    settings.beginGroup("meadfanomfieldDraft");
    //    settings.remove("drafAirflowGridStr");
    //    settings.endGroup();
}

void MachineBackend::setDownflowVelocityPointFactory(int pointZero, int pointMin, int pointNom)
{
    qDebug() << metaObject()->className() << __FUNCTION__ << pointZero << pointMin << pointNom << thread();
    QSettings settings;
    settings.setValue(QString(SKEY_DFA_CAL_VEL_FACTORY) + "1", pointMin);
    settings.setValue(QString(SKEY_DFA_CAL_VEL_FACTORY) + "2", pointNom);

    pData->setDownflowVelocityPointFactory(1, pointMin);
    pData->setDownflowVelocityPointFactory(2, pointNom);
}

void MachineBackend::setDownflowVelocityPointFactory(int point, int value)
{
    qDebug() << metaObject()->className() << __FUNCTION__ << point << value << thread();
    QSettings settings;
    settings.setValue(QString(SKEY_DFA_CAL_VEL_FACTORY) + QString::number(point), value);

    pData->setDownflowVelocityPointFactory(static_cast<short>(point), value);
}

void MachineBackend::setDownflowVelocityPointField(int pointZero, int pointMin, int pointNom)
{
    qDebug() << metaObject()->className() << __FUNCTION__ << pointZero << pointMin << pointNom << thread();
    QSettings settings;
    settings.setValue(QString(SKEY_DFA_CAL_VEL_FIELD) + "1", pointMin);
    settings.setValue(QString(SKEY_DFA_CAL_VEL_FIELD) + "2", pointNom);

    pData->setDownflowVelocityPointField(1, pointMin);
    pData->setDownflowVelocityPointField(2, pointNom);
}

void MachineBackend::setDownflowVelocityPointField(int point, int value)
{
    qDebug() << metaObject()->className() << __FUNCTION__ << point << value << thread();
    QSettings settings;
    settings.setValue(QString(SKEY_DFA_CAL_VEL_FIELD) + QString::number(point), value);

    pData->setDownflowVelocityPointField(static_cast<short>(point), value);
}

void MachineBackend::initAirflowCalibrationStatus(short value)
{
    switch (value) {
    case MachineEnums::AF_CALIB_FIELD:
        _initAirflowCalibartionField();
        break;
    case MachineEnums::AF_CALIB_FACTORY:
    default:
        _initAirflowCalibartionFactory();
        break;
    }

    pData->setAirflowCalibrationStatus(value);
}

void MachineBackend::initFanConfigurationStatus(short value)
{
    switch (value) {
    case MachineEnums::AF_CALIB_FIELD:
    {
        short fanNomDutyCycle   = pData->getFanPrimaryNominalDutyCycleField();
        int   fanNomRpm         = pData->getFanPrimaryNominalRpmField();
        short fanMinDutyCycle   = pData->getFanPrimaryMinimumDutyCycleField();
        int   fanMinRpm         = pData->getFanPrimaryMinimumRpmField();
        short fanStbDutyCycle   = pData->getFanPrimaryStandbyDutyCycleField();
        int   fanStbRpm         = pData->getFanPrimaryStandbyRpmField();

        pData->setFanPrimaryNominalDutyCycle(fanNomDutyCycle);
        pData->setFanPrimaryNominalRpm(static_cast<short>(fanNomRpm));
        pData->setFanPrimaryMinimumDutyCycle(fanMinDutyCycle);
        pData->setFanPrimaryMinimumRpm(static_cast<short>(fanMinRpm));
        pData->setFanPrimaryStandbyDutyCycle(fanStbDutyCycle);
        pData->setFanPrimaryStandbyRpm(fanStbRpm);
    }
    break;
    case MachineEnums::AF_CALIB_FACTORY:
    default:
    {
        short fanNomDutyCycle   = pData->getFanPrimaryNominalDutyCycleFactory();
        int   fanNomRpm         = pData->getFanPrimaryNominalRpmFactory();
        short fanMinDutyCycle   = pData->getFanPrimaryMinimumDutyCycleFactory();
        int   fanMinRpm         = pData->getFanPrimaryMinimumRpmFactory();
        short fanStbDutyCycle   = pData->getFanPrimaryStandbyDutyCycleFactory();
        int   fanStbRpm         = pData->getFanPrimaryStandbyRpmFactory();

        pData->setFanPrimaryNominalDutyCycle(fanNomDutyCycle);
        pData->setFanPrimaryNominalRpm(static_cast<short>(fanNomRpm));
        pData->setFanPrimaryMinimumDutyCycle(fanMinDutyCycle);
        pData->setFanPrimaryMinimumRpm(static_cast<short>(fanMinRpm));
        pData->setFanPrimaryStandbyDutyCycle(fanStbDutyCycle);
        pData->setFanPrimaryStandbyRpm(fanStbRpm);
    }
    break;
    }
}

void MachineBackend::setAirflowFactoryCalibrationState(int index, bool state)
{
    qDebug() << __func__ << index << state;

    if(index < 0 || index >= MachineEnums::CalFactoryState_Total) return;

    QSettings settings;

    pData->setAirflowFactoryCalibrationState(index, state);
    settings.setValue(SKEY_AIRFLOW_FACTORY_CALIB_STATE + QString::number(index), state);
}

void MachineBackend::setAirflowFieldCalibrationState(int index, bool value)
{
    qDebug() << __func__ << index << value;

    if(index < 0 || index >= MachineEnums::CalFieldState_Total) return;

    QSettings settings;

    pData->setAirflowFieldCalibrationState(index, value);
    settings.setValue(SKEY_AIRFLOW_FIELD_CALIB_STATE + QString::number(index), value);
}//

void MachineBackend::_initAirflowCalibartionFactory()
{
    short fanNomDutyCycle   = pData->getFanPrimaryNominalDutyCycleFactory();
    int   fanNomRpm         = pData->getFanPrimaryNominalRpmFactory();
    short fanMinDutyCycle   = pData->getFanPrimaryMinimumDutyCycleFactory();
    int   fanMinRpm         = pData->getFanPrimaryMinimumRpmFactory();
    short fanStbDutyCycle   = pData->getFanPrimaryStandbyDutyCycleFactory();
    int   fanStbRpm         = pData->getFanPrimaryStandbyRpmFactory();

    pData->setFanPrimaryNominalDutyCycle(fanNomDutyCycle);
    pData->setFanPrimaryNominalRpm(static_cast<short>(fanNomRpm));
    pData->setFanPrimaryMinimumDutyCycle(fanMinDutyCycle);
    pData->setFanPrimaryMinimumRpm(static_cast<short>(fanMinRpm));
    pData->setFanPrimaryStandbyDutyCycle(fanStbDutyCycle);
    pData->setFanPrimaryStandbyRpm(fanStbRpm);

    int sensorConstant = pData->getInflowSensorConstant();

    int adcPointZero   = pData->getInflowAdcPointFactory(0);
    int adcPointMin    = pData->getInflowAdcPointFactory(1);
    int adcPointNom    = pData->getInflowAdcPointFactory(2);

    int velPointMin    = pData->getInflowVelocityPointFactory(1);
    int velPointNom    = pData->getInflowVelocityPointFactory(2);

    int velLowAlarm    = pData->getInflowLowLimitVelocity();

    /// LOW LIMIT VELOCITY ALARM
    pData->setInflowLowLimitVelocity(velLowAlarm);

    m_pAirflowInflow->setConstant(sensorConstant);

    m_pAirflowInflow->setAdcPoint(0, adcPointZero);
    m_pAirflowInflow->setAdcPoint(1, adcPointMin);
    m_pAirflowInflow->setAdcPoint(2, adcPointNom);

    m_pAirflowInflow->setVelocityPoint(1, velPointMin);
    m_pAirflowInflow->setVelocityPoint(2, velPointNom);

    m_pAirflowInflow->initScope();
}

void MachineBackend::_initAirflowCalibartionField()
{
    //    //Get delta value between Factory Nominal Duty cycle and Factory Standby Duty Cycle
    //    short fanNomDutyCycleFact   = pData->getFanPrimaryNominalDutyCycleFactory();
    //    short fanMinDutyCycleFact   = pData->getFanPrimaryMinimumDutyCycleFactory();Q_UNUSED(fanMinDutyCycleFact)
    //    short fanStbDutyCycleFact   = pData->getFanPrimaryStandbyDutyCycleFactory();
    //    short deltaValue = static_cast<short>(qAbs(fanNomDutyCycleFact - fanStbDutyCycleFact));

    short fanNomDutyCycle   = pData->getFanPrimaryNominalDutyCycleField();
    int   fanNomRpm         = pData->getFanPrimaryNominalRpmField();
    short fanMinDutyCycle   = pData->getFanPrimaryMinimumDutyCycleField();
    int   fanMinRpm         = pData->getFanPrimaryMinimumRpmField();
    short fanStbDutyCycle   = pData->getFanPrimaryStandbyDutyCycleField();
    int   fanStbRpm         = pData->getFanPrimaryStandbyRpmField(); /// the value will be zero and will be calculated when standby is running

    pData->setFanPrimaryNominalDutyCycle(fanNomDutyCycle);
    pData->setFanPrimaryNominalRpm(static_cast<short>(fanNomRpm));
    pData->setFanPrimaryMinimumDutyCycle(fanMinDutyCycle);
    pData->setFanPrimaryMinimumRpm(static_cast<short>(fanMinRpm));
    pData->setFanPrimaryStandbyDutyCycle(fanStbDutyCycle);
    pData->setFanPrimaryStandbyRpm(fanStbRpm);

    int sensorConstant = pData->getInflowSensorConstant();

    int adcPointZero   = pData->getInflowAdcPointField(0);
    int adcPointMin    = pData->getInflowAdcPointField(1);
    int adcPointNom    = pData->getInflowAdcPointField(2);

    int velPointMin    = pData->getInflowVelocityPointField(1);
    int velPointNom    = pData->getInflowVelocityPointField(2);

    int velLowAlarm    = pData->getInflowLowLimitVelocity();

    /// LOW LIMIT VELOCITY ALARM
    pData->setInflowLowLimitVelocity(velLowAlarm);

    m_pAirflowInflow->setConstant(sensorConstant);

    m_pAirflowInflow->setAdcPoint(0, adcPointZero);
    m_pAirflowInflow->setAdcPoint(1, adcPointMin);
    m_pAirflowInflow->setAdcPoint(2, adcPointNom);

    m_pAirflowInflow->setVelocityPoint(1, velPointMin);
    m_pAirflowInflow->setVelocityPoint(2, velPointNom);

    m_pAirflowInflow->initScope();
}

void MachineBackend::_onFanPrimaryActualDucyChanged(short value)
{
    qDebug() << metaObject()->className() << __FUNCTION__ << value << thread();

    pData->setFanPrimaryDutyCycle(value);

    //// translate duty cycle to fan state
    if (value == MachineEnums::DIG_STATE_ZERO) {
        pData->setFanPrimaryState(MachineEnums::FAN_STATE_OFF);
        pData->setWarmingUpExecuted(false); //reset Warming up executed

        _cancelWarmingUpTime();
        _cancelPostPurgingTime();
        _stopFanFilterLifeMeter();
        _cancelPowerOutageCapture();

        /// PARTICLE COUNTER
        /// do not counting when internal blower is off
        if (pData->getParticleCounterSensorInstalled()) {
            if (pData->getParticleCounterSensorFanState()){
                m_pParticleCounter->setFanStatePaCo(MachineEnums::DIG_STATE_ZERO);
            }
        }
    }
    else if (value == pData->getFanPrimaryStandbyDutyCycle()) {
        pData->setFanPrimaryState(MachineEnums::FAN_STATE_STANDBY);
        pData->setWarmingUpExecuted(false); //reset Warming up executed
        /// Power Failure at Standby Speed
        _startPowerOutageCapture();
    }
    else {
        pData->setFanPrimaryState(MachineEnums::FAN_STATE_ON);

        _startFanFilterLifeMeter();

        if(!isMaintenanceModeActive()) {
            if(isAirflowHasCalibrated()) {
                if(!pData->getWarmingUpActive() && !pData->getWarmingUpExecuted())
                {
                    _startWarmingUpTime();
                    _startPowerOutageCapture();
                }
            }
        }

        /// PARTICLE COUNTER
        /// only counting when internal blower is on
        if (pData->getParticleCounterSensorInstalled()) {
            if (!pData->getParticleCounterSensorFanState()){
                m_pParticleCounter->setFanStatePaCo(MachineEnums::DIG_STATE_ONE);
            }
        }
    }

    /// MODBUS
    _setModbusRegHoldingValue(modbusRegisterAddress.FanState.addr, static_cast<ushort>(pData->getFanPrimaryState()));
    _setModbusRegHoldingValue(modbusRegisterAddress.IfaFanDutyCycle.addr, static_cast<ushort>(value));
}

void MachineBackend::_onFanPrimaryActualRpmChanged(int value)
{
    pData->setFanPrimaryRpm(value);

    /// MODBUS
    _setModbusRegHoldingValue(modbusRegisterAddress.IfaFanRpm.addr, static_cast<ushort>(value));
}

void MachineBackend::_onSashStateChanged(short state, short prevState)
{
    Q_UNUSED(prevState)
    pData->setSashWindowState(state);

    /// if there is delay execute action for turned on blower and lamp caused sash safe height
    /// since the sash is change, so cancel the delay execution
    if (eventTimerForDelaySafeHeightAction != nullptr) {
        eventTimerForDelaySafeHeightAction->stop();
        delete eventTimerForDelaySafeHeightAction;
        eventTimerForDelaySafeHeightAction = nullptr;
    }

    /// cleared mute audible alarm
    /// if it active and vivarium mute is not active
    if (pData->getMuteAlarmState() && !pData->getVivariumMuteState()){
        pData->setMuteAlarmState(MachineEnums::DIG_STATE_ZERO);
        _cancelMuteAlarmTimer();
    }//

    /// MODBUS
    _setModbusRegHoldingValue(modbusRegisterAddress.SashState.addr, static_cast<ushort>(state));

    /// Event Log
    switch (state) {
    case SashWindow::SASH_STATE_WORK_SSV:
        _insertEventLog(_tr(EVENT_STR_SASH_SAFE));
        break;
    case SashWindow::SASH_STATE_UNSAFE_SSV:
        _insertEventLog(_tr(EVENT_STR_SASH_UNSAFE));
        break;
    case SashWindow::SASH_STATE_FULLY_CLOSE_SSV:
        _insertEventLog(_tr(EVENT_STR_SASH_FC));
        break;
    case SashWindow::SASH_STATE_FULLY_OPEN_SSV:
        _insertEventLog(_tr(EVENT_STR_SASH_FO));
        break;
    case SashWindow::SASH_STATE_STANDBY_SSV:
        _insertEventLog(_tr(EVENT_STR_SASH_STB));
        break;
    case SashWindow::SASH_STATE_ERROR_SENSOR_SSV:
        _insertEventLog(_tr(EVENT_STR_SASH_ERROR));
        break;
    default:
        break;
    }

}

void MachineBackend::_onLightStateChanged(short state)
{
    qDebug() << metaObject()->className() << __FUNCTION__ << state << thread();

    pData->setLightState(state);

    /// MODBUS
    _setModbusRegHoldingValue(modbusRegisterAddress.LightState.addr, static_cast<ushort>(state));

    //    /// EVENT LOG
    //    QString event = state ? _tr(EVENT_STR_LIGHT_ON) : EVENT_STR_LIGHT_OFF;
    //    _insertEventLog(event);

}

void MachineBackend::_onSocketStateChanged(short state)
{
    qDebug() << metaObject()->className() << __FUNCTION__ << state << thread();

    pData->setSocketState(state);

    /// MEDIUM
    _setModbusRegHoldingValue(modbusRegisterAddress.SocketState.addr, static_cast<ushort>(state));

    //    /// EVENT LOG
    //    QString event = state ? EVENT_STR_SOCKET_ON : EVENT_STR_SOCKET_OFF;
    //    _insertEventLog(event);
}

void MachineBackend::_onGasStateChanged(short state)
{
    qDebug() << metaObject()->className() << __FUNCTION__ << state << thread();

    pData->setGasState(state);

    /// MODBUS
    _setModbusRegHoldingValue(modbusRegisterAddress.GasState.addr, static_cast<ushort>(state));

    //    /// EVENT LOG
    //    QString event = state ? EVENT_STR_GAS_ON : EVENT_STR_GAS_OFF;
    //    _insertEventLog(event);
}

void MachineBackend::_onUVStateChanged(short state)
{
    qDebug() << metaObject()->className() << __FUNCTION__ << state << thread();

    pData->setUvState(state);

    /// TRIGGERING UV TIME AND FRIENDS
    if(state) {
        if(pData->getUvTime()){
            _startUVTime();
        }
        _startPowerOutageCapture();
        //_startUVLifeMeter();
    }
    else {
        if(pData->getUvTime()){
            _cancelUVTime();
        }
        //_stopUVLifeMeter();
        _cancelPowerOutageCapture();
    }

    /// MODBUS
    _setModbusRegHoldingValue(modbusRegisterAddress.UvState.addr, static_cast<ushort>(state));

    //    /// EVENT LOG
    //    QString event = state ? EVENT_STR_UV_ON : EVENT_STR_UV_OFF;
    //    _insertEventLog(event);
}

void MachineBackend::_onTemperatureActualChanged(double value)
{
    qDebug() << metaObject()->className() << __func__ << value;

    pData->setTemperatureCelcius(static_cast<short>(value));
    /// Temperature is effecting the airflow reading
    m_pAirflowInflow->setTemperature(value);

    QString valueStr;
    if (pData->getMeasurementUnit()) {
        int fahrenheit = __convertCtoF(static_cast<int>(value));
        pData->setTemperature(static_cast<short>(fahrenheit));

        valueStr = QString::asprintf("%d°F", fahrenheit);
                   pData->setTemperatureValueStrf(valueStr);

        // tempBasedOnMeaUnit = static_cast<short>(fahrenheit);
    }
    else {
        pData->setTemperature(static_cast<short>(value));

        valueStr = QString::asprintf("%d°C", static_cast<int>(value));
                   pData->setTemperatureValueStrf(valueStr);
        // tempBasedOnMeaUnit = value;
    }

    //    /// CHANGE TO ANOTHER IMPLEMENTATION
    //    /// IF USED AIRFLOW DEGREEC SENSOR
    //    /// https://degreec.com/pages/f-series-probe
    //    /// https://kl801.ilearning.me/2015/05/21/penjelasan-tentang-lm35
    //    short lowest = 2;
    //    short highest = 60;
    //    /// IF CONTANT NOT ZERO, THIS SYSTEM USED
    //    /// ESCO AIRFLOW SENSOR, WHICH ONLY CAN WORK IN
    //    /// TEMPERATURE RANGE BETWEEN 18 to 30 Deggree C
    //    if(pData->getInflowSensorConstant()){
    //        lowest  = 15;
    //        highest = 35;
    //    }
    if(pData->getMachineBackendState() == MachineEnums::MACHINE_STATE_SETUP)
        return;

    /// ENV TEMPERATURE SET POINT GETTING FROM CABINET PROFILE
    /// BUT ALSO ADJUSTABLE
    short lowest = static_cast<short>(pData->getEnvTempLowestLimit());
    short highest = static_cast<short>(pData->getEnvTempHighestLimit());

    if ((pData->getTemperature() < lowest)
        && !pData->getAirflowOutTempEnable()
        && pData->getOperationMode() != MachineEnums::MODE_OPERATION_MAINTENANCE){
        if(!isTempAmbLow(pData->getTempAmbientStatus())){
            pData->setTempAmbientStatus(MachineEnums::TEMP_AMB_LOW);

            /// EVENT LOG
            _insertEventLog(_tr(EVENT_STR_TEMP_AMB_LOW) + " (" + valueStr + ")");

            //            /// ALARM LOG
            //            QString text = QString("%1 (%2)")
            //                    .arg(_tr(ALARM_LOG_TEXT_ENV_TEMP_TOO_LOW), pData->getTemperatureValueStrf());
            //            _insertAlarmLog(ALARM_LOG_CODE::ALC_ENV_TEMP_LOW, text);
        }
    }
    else if ((pData->getTemperature() > highest)
             && !pData->getAirflowOutTempEnable()
             && pData->getOperationMode() != MachineEnums::MODE_OPERATION_MAINTENANCE){
        if(!isTempAmbHigh(pData->getTempAmbientStatus())){
            pData->setTempAmbientStatus(MachineEnums::TEMP_AMB_HIGH);

            ///EVENT LOG
            _insertEventLog(_tr(EVENT_STR_TEMP_AMB_HIGH) + " (" + valueStr + ")");

            //            /// ALARM LOG
            //            QString text = QString("%1 (%2)")
            //                    .arg(_tr(ALARM_LOG_TEXT_ENV_TEMP_TOO_HIGH), pData->getTemperatureValueStrf());
            //            _insertAlarmLog(ALARM_LOG_CODE::ALC_ENV_TEMP_HIGH, text);
        }
    }
    else {
        if(!isTempAmbNormal(pData->getTempAmbientStatus())){
            pData->setTempAmbientStatus(MachineEnums::TEMP_AMB_NORMAL);

            ///EVENT LOG
            _insertEventLog(_tr(EVENT_STR_TEMP_AMB_NORM) + " (" + valueStr + ")");

            //            /// ALARM LOG
            //            QString text = QString("%1 (%2)")
            //                    .arg(_tr(ALARM_LOG_TEXT_ENV_TEMP_OK), pData->getTemperatureValueStrf());
            //            _insertAlarmLog(ALARM_LOG_CODE::ALC_ENV_TEMP_OK, text);
        }
    }

    /// MODBUS
    _setModbusRegHoldingValue(modbusRegisterAddress.Temperature.addr, static_cast<ushort>(pData->getTemperature()));

    //    qDebug() << value << pData->getTempAmbientStatus();
}

void MachineBackend::_onInflowVelocityActualChanged(int value)
{
    pData->setInflowVelocity(value);

    if (pData->getMeasurementUnit()) {
        int valueVel = qRound(value / 100.0);
        QString valueStr = QString::asprintf("%d fpm", valueVel);
        pData->setInflowVelocityStr(valueStr);
    }
    else {
        double valueVel = value / 100.0;
        QString valueStr = QString::asprintf("%.2f m/s", valueVel);
        pData->setInflowVelocityStr(valueStr);
    }

    /// MODBUS
    _setModbusRegHoldingValue(modbusRegisterAddress.AirflowInflow.addr, static_cast<ushort>(value));

    //    qDebug() << "Inflow" << pData->getInflowVelocityStr();
}

void MachineBackend::_calculteDownflowVelocity(int value)
{
    /// Calculate Downflow based on inflow
    /// DOWNFLOW SENSOR NOT PHYSICALLY INSTALLED
    /// CALCULATE DOWNFLOW VALUE BY PROPORTIONAL METHOD
    /// CALCULATE DOWNFLOW FROM INFLOW PROPORTIONAL
    int velRefActual, velRefPoportional;
    switch (pData->getAirflowCalibrationStatus()) {
    case MachineEnums::AF_CALIB_FIELD:
        velRefActual         = pData->getInflowVelocityPointField(2);
        velRefPoportional    = pData->getDownflowVelocityPointField(2);
        break;
    default:
        velRefActual         = pData->getInflowVelocityPointFactory(2);
        velRefPoportional    = pData->getDownflowVelocityPointFactory(2);
        break;
    }

    int dfVelocity = 0;
    if (velRefActual > 0) {
        dfVelocity = value * velRefPoportional / velRefActual;
    }

    pData->setDownflowVelocity(dfVelocity);

    if (pData->getMeasurementUnit()) {
        int valueVel = qRound(dfVelocity / 100.0);
        QString valueStr = QString::asprintf("%d fpm", valueVel);
        pData->setDownflowVelocityStr(valueStr);
    }
    else {
        double valueVel = dfVelocity / 100.0;
        QString valueStr = QString::asprintf("%.2f m/s", valueVel);
        pData->setDownflowVelocityStr(valueStr);
    }

    /// MODBUS
    _setModbusRegHoldingValue(modbusRegisterAddress.AirflowDownflow.addr, static_cast<ushort>(dfVelocity));

    //    qDebug() << "Downflow" << pData->getDownflowVelocityStr();
    //    qDebug() << value << velRefActual << velRefPoportional;
}

void MachineBackend::_onSeasPressureDiffPaChanged(int value)
{
    qDebug() << __FUNCTION__ ;
    qDebug() << value ;

    pData->setSeasPressureDiffPa(value);

    if (pData->getMeasurementUnit()) {
        double iwg = __toFixedDecPoint(__convertPa2inWG(value), 3);
        pData->setSeasPressureDiff(qRound(iwg * 1000));

        QString valueStr = QString::asprintf("%.3f iwg", iwg);
        pData->setSeasPressureDiffStrf(valueStr);
    }
    else {
        pData->setSeasPressureDiff(value * 1000);

        QString valueStr = QString::asprintf("%d Pa", value);
        pData->setSeasPressureDiffStrf(valueStr);
    }

    /// MODBUS
    _setModbusRegHoldingValue(modbusRegisterAddress.PressureExhaust.addr, static_cast<ushort>(value));
}

void MachineBackend::_onParticleCounterPM1_0Changed(int pm1_0)
{
    qDebug() << metaObject()->className() << __FUNCTION__ << pm1_0;

    pData->setParticleCounterPM1_0(pm1_0);
}

void MachineBackend::_onParticleCounterPM2_5Changed(int pm2_5)
{
    qDebug() << metaObject()->className() << __FUNCTION__ << pm2_5;

    pData->setParticleCounterPM2_5(pm2_5);
}

void MachineBackend::_onParticleCounterPM10Changed(int pm10)
{
    qDebug() << metaObject()->className() << __FUNCTION__ << pm10;

    pData->setParticleCounterPM10(pm10);
}

void MachineBackend::_onParticleCounterSensorFanStateChanged(int state)
{
    qDebug() << metaObject()->className() << __FUNCTION__ << state;

    pData->setParticleCounterSensorFanState(static_cast<short>(state));
}

void MachineBackend::_onTimerEventLcdDimm()
{
    if(pData->getLcdBrightnessDelayToDimm() > 0){
        m_boardCtpIO->setOutputPWM(LEDpca9633_CHANNEL_BL,
                                   LCD_DIMM_LEVEL,
                                   I2CPort::I2C_SEND_MODE_QUEUE);

        pData->setLcdBrightnessLevel(LCD_DIMM_LEVEL);
        pData->setLcdBrightnessLevelDimmed(true);
    }
}

void MachineBackend::_startLogoutTime()
{
    qDebug() << metaObject()->className() << __FUNCTION__ << thread();
    int seconds = pData->getLogoutTime();
    if(!seconds) return;
    m_logoutTimeCountdown = seconds;

    /// double ensure this slot not connected to this warming up event
    disconnect(m_timerEventEverySecond.data(), &QTimer::timeout,
               this, &MachineBackend::_onTimerEventLogout);
    /// connect uniqly timer event for warming up count down
    connect(m_timerEventEverySecond.data(), &QTimer::timeout,
            this, &MachineBackend::_onTimerEventLogout,
            Qt::UniqueConnection);
}

void MachineBackend::_resetLogoutTime()
{
    //    qDebug() << metaObject()->className() << __FUNCTION__ << thread();
    int seconds = pData->getLogoutTime();
    if(!seconds) return;
    m_logoutTimeCountdown = seconds;

    /// double ensure this slot not connected to this warming up event
    disconnect(m_timerEventEverySecond.data(), &QTimer::timeout,
               this, &MachineBackend::_onTimerEventLogout);
    /// connect uniqly timer event for warming up count down
    connect(m_timerEventEverySecond.data(), &QTimer::timeout,
            this, &MachineBackend::_onTimerEventLogout,
            Qt::UniqueConnection);
}

void MachineBackend::_cancelLogoutTime()
{
    qDebug() << metaObject()->className() << __FUNCTION__ << thread();
    disconnect(m_timerEventEverySecond.data(), &QTimer::timeout,
               this, &MachineBackend::_onTimerEventLogout);

    int seconds = pData->getLogoutTime();
    m_logoutTimeCountdown = seconds;
}

void MachineBackend::_onTimerEventLogout()
{
    //    qDebug() << metaObject()->className() << __FUNCTION__ << m_logoutTimeCountdown << thread();

    if(pData->getFrontEndScreenState() == MachineEnums::ScreenState_Calibration) return;

    if(m_logoutTimeCountdown <= 0){
        disconnect(m_timerEventEverySecond.data(), &QTimer::timeout,
                   this, &MachineBackend::_onTimerEventLogout);

        int seconds = pData->getLogoutTime();
        m_logoutTimeCountdown = seconds;

        /// Turned bright LED
        _wakeupLcdBrightnessLevel();

        emit pData->timerEventLogout();
    }
    else {
        m_logoutTimeCountdown--;
    }
}

void MachineBackend::_startWarmingUpTime()
{
    qDebug() << __FUNCTION__ ;

    int seconds = pData->getWarmingUpTime();
    Q_UNUSED(seconds)
#ifndef __arm__
//    seconds = 30;
#endif
    pData->setWarmingUpCountdown(seconds);
    pData->setWarmingUpActive(MachineEnums::DIG_STATE_ONE);

    /// double ensure this slot not connected to this warming up event
    disconnect(m_timerEventEverySecond.data(), &QTimer::timeout,
               this, &MachineBackend::_onTimerEventWarmingUp);
    /// connect uniqly timer event for warming up count down
    connect(m_timerEventEverySecond.data(), &QTimer::timeout,
            this, &MachineBackend::_onTimerEventWarmingUp,
            Qt::UniqueConnection);
    /// IF IN NORMAL MODE, AFTER WARMING UP COMPLETE, TURN ON LAMP AUTOMATICALLY
    bool normalMode = pData->getOperationMode() == MachineEnums::MODE_OPERATION_NORMAL;
    bool quickMode = pData->getOperationMode() == MachineEnums::MODE_OPERATION_QUICKSTART;

    if(normalMode || quickMode) {
        setLightState(MachineEnums::DIG_STATE_ZERO);
    }
}

void MachineBackend::_cancelWarmingUpTime()
{
    disconnect(m_timerEventEverySecond.data(), &QTimer::timeout,
               this, &MachineBackend::_onTimerEventWarmingUp);

    if(!pData->getWarmingUpActive()) return;

    int seconds = pData->getWarmingUpTime();
    pData->setWarmingUpCountdown(seconds);
    pData->setWarmingUpActive(MachineEnums::DIG_STATE_ZERO);
}

void MachineBackend::_onTimerEventWarmingUp()
{
    //    qDebug() << __FUNCTION__ ;

    int count = pData->getWarmingUpCountdown();
    if(count <= 0){
        disconnect(m_timerEventEverySecond.data(), &QTimer::timeout,
                   this, &MachineBackend::_onTimerEventWarmingUp);

        int seconds = pData->getWarmingUpTime();
        pData->setWarmingUpCountdown(seconds);
        pData->setWarmingUpActive(MachineEnums::DIG_STATE_ZERO);
        pData->setWarmingUpExecuted(true);

        /// IF IN NORMAL MODE, AFTER WARMING UP COMPLETE, TURN ON LAMP AUTOMATICALLY
        bool normalMode = pData->getOperationMode() == MachineEnums::MODE_OPERATION_NORMAL;
        bool quickMode = pData->getOperationMode() == MachineEnums::MODE_OPERATION_QUICKSTART;

        if(normalMode || quickMode) {
            setLightState(MachineEnums::DIG_STATE_ONE);
        }
        /// Ensure The Data Log timer is Active Data Log Once WarmingUp Time finished
        if(pData->getDataLogEnable()){
            if(!m_timerEventForDataLog->isActive()){
                m_timerEventForDataLog->start();
            }//
        }//

        /// Turned bright LED
        _wakeupLcdBrightnessLevel();
    }
    else {
        count--;
        pData->setWarmingUpCountdown(count);
    }
}

void MachineBackend::_startPostPurgingTime()
{
    qDebug() << metaObject()->className() << __func__  << thread();

    int seconds = pData->getPostPurgingTime();
    pData->setPostPurgingCountdown(seconds);
    pData->setPostPurgingActive(MachineEnums::DIG_STATE_ONE);

    /// double ensure this slot not connected to this warming up event
    disconnect(m_timerEventEverySecond.data(), &QTimer::timeout,
               this, &MachineBackend::_onTimerEventPostPurging);
    /// connect uniqly timer event for warming up count down
    connect(m_timerEventEverySecond.data(), &QTimer::timeout,
            this, &MachineBackend::_onTimerEventPostPurging,
            Qt::UniqueConnection);
}

void MachineBackend::_cancelPostPurgingTime()
{
    qDebug() << metaObject()->className() << __func__  << thread();

    disconnect(m_timerEventEverySecond.data(), &QTimer::timeout,
               this, &MachineBackend::_onTimerEventPostPurging);

    if(!pData->getPostPurgingActive()) return;

    int seconds = pData->getPostPurgingTime();
    pData->setPostPurgingCountdown(seconds);
    pData->setPostPurgingActive(MachineEnums::DIG_STATE_ZERO);
}

void MachineBackend::_onTimerEventPostPurging()
{
    qDebug() << metaObject()->className() << __func__  << thread();

    int count = pData->getPostPurgingCountdown();
    if(count <= 0){
        disconnect(m_timerEventEverySecond.data(), &QTimer::timeout,
                   this, &MachineBackend::_onTimerEventPostPurging);

        int seconds = pData->getPostPurgingTime();
        pData->setPostPurgingCountdown(seconds);
        pData->setPostPurgingActive(MachineEnums::DIG_STATE_ZERO);

        /// ACTUALLY TURNING OFF THE FAN
        _setFanPrimaryStateOFF();

        /// Light up LCD Backlight
        _wakeupLcdBrightnessLevel();
    }
    else {
        count--;
        pData->setPostPurgingCountdown(count);
        if(pData->getSashWindowState() == MachineEnums::SASH_STATE_FULLY_CLOSE_SSV){
            _cancelPostPurgingTime();
            /// ACTUALLY TURNING OFF THE FAN
            emit pData->fanPrimarySwithingStateTriggered(MachineEnums::DIG_STATE_ZERO);
            _setFanPrimaryStateOFF();
        }
    }
}

void MachineBackend::_startUVTime()
{
    //qDebug() << metaObject()->className() << __func__  << thread();

    int seconds = pData->getUvTime() * 60;
    int countdown = pData->getUvTimeCountdown();
    if(!countdown){
        _setUvTimeCountdown(seconds);
        pData->setUvTimeCountdown(seconds);
    }
    pData->setUvTimeActive(MachineEnums::DIG_STATE_ONE);

    /// double ensure this slot not connected yet, minimize chance to double connect the signal
    disconnect(m_timerEventEverySecond.data(), &QTimer::timeout,
               this, &MachineBackend::_onTimerEventUVTimeCountdown);
    /// connect uniqly timer event for warming up count down
    connect(m_timerEventEverySecond.data(), &QTimer::timeout,
            this, &MachineBackend::_onTimerEventUVTimeCountdown,
            Qt::UniqueConnection);
}

void MachineBackend::_cancelUVTime()
{
    //qDebug() << metaObject()->className() << __func__  << thread();

    disconnect(m_timerEventEverySecond.data(), &QTimer::timeout,
               this, &MachineBackend::_onTimerEventUVTimeCountdown);

    if(!pData->getUvTimeActive()) return;

    int seconds = pData->getUvTime() * 60;

    _setUvTimeCountdown(seconds);
    pData->setUvTimeActive(MachineEnums::DIG_STATE_ZERO);
}

void MachineBackend::_onTimerEventUVTimeCountdown()
{
    //    qDebug() << metaObject()->className() << __func__  << thread();

    int count = pData->getUvTimeCountdown();
    if(count <= 0){
        disconnect(m_timerEventEverySecond.data(), &QTimer::timeout,
                   this, &MachineBackend::_onTimerEventUVTimeCountdown);

        int seconds = pData->getUvTime() * 60;
        _setUvTimeCountdown(seconds);
        pData->setUvTimeActive(MachineEnums::DIG_STATE_ZERO);

        /// TURN OFF UV LAMP AUTOMATICALLY
        if(pData->getUvState()){
            m_pUV->setState(MachineEnums::DIG_STATE_ZERO);
        }

        /// Light up LCD Backlight
        _wakeupLcdBrightnessLevel();
    }
    else {
        count--;
        if(count%60 == 0){
            _setUvTimeCountdown(count);
            _onTimerEventUVLifeCalculate();
        }
        else
            pData->setUvTimeCountdown(count);
    }
}

void MachineBackend::_setUvTimeCountdown(int value)
{
    //qDebug() << metaObject()->className() << __func__  << thread();
    QSettings setting;
    setting.setValue(SKEY_UV_TIME_COUNTDOWN, value);
    pData->setUvTimeCountdown(value);
}

void MachineBackend::_startUVLifeMeter()
{
    //    qDebug() << __FUNCTION__ ;

    //    /// double ensure this slot not connected yet, minimize chance to double connect the signal
    //    disconnect(m_timerEventEveryMinute.data(), &QTimer::timeout,
    //               this, &MachineBackend::_onTimerEventUVLifeCalculate);
    //    /// connect uniqly timer event for warming up count down
    //    connect(m_timerEventEveryMinute.data(), &QTimer::timeout,
    //            this, &MachineBackend::_onTimerEventUVLifeCalculate,
    //            Qt::UniqueConnection);
}

void MachineBackend::_stopUVLifeMeter()
{
    //    qDebug() << __FUNCTION__ ;

    //    /// double ensure this slot not connected yet, minimize chance to double connect the signal
    //    disconnect(m_timerEventEveryMinute.data(), &QTimer::timeout,
    //               this, &MachineBackend::_onTimerEventUVLifeCalculate);
}

void MachineBackend::_onTimerEventUVLifeCalculate()
{
    qDebug() << metaObject()->className() << __func__  << thread();

    int minutes = pData->getUvLifeMinutes();
    if(minutes > 0){
        minutes--;
        //        minutes = minutes - 1000;
        int minutesPercentLeft = __getPercentFrom(minutes, SDEF_UV_MAXIMUM_TIME_LIFE);

        /// event if in % value is zero but the minutes more then 0 minutes, then set % to 1
        if (minutesPercentLeft == 0 && minutes > 0) minutesPercentLeft = 1;

        //update to global observable variable
        pData->setUvLifeMinutes(minutes);
        pData->setUvLifePercent(static_cast<short>(minutesPercentLeft));

        //save to sattings
        QSettings settings;
        settings.setValue(SKEY_UV_METER, minutes);

        //        qDebug() << __FUNCTION__  << minutes;
        /// MODBUS
        _setModbusRegHoldingValue(modbusRegisterAddress.UvLifeLeft.addr, static_cast<ushort>(minutesPercentLeft));
    }
}

void MachineBackend::_startFanFilterLifeMeter()
{
    qDebug() << metaObject()->className() << __func__  << thread();

    /// double ensure this slot not connected yet, minimize chance to double connect the signal
    disconnect(m_timerEventEveryMinute.data(), &QTimer::timeout,
               this, &MachineBackend::_onTimerEventFanFilterUsageMeterCalculate);

    {
        /// reset the buffer value
        m_fanPrimaryRpmActualBuffer->clear();
        //        m_fanPrimaryRpmIndexMovAvg = 0;
    }

    /// connect uniqly timer event for warming up count down
    connect(m_timerEventEveryMinute.data(), &QTimer::timeout,
            this, &MachineBackend::_onTimerEventFanFilterUsageMeterCalculate,
            Qt::UniqueConnection);
}

void MachineBackend::_stopFanFilterLifeMeter()
{
    qDebug() << metaObject()->className() << __func__  << thread();

    /// double ensure this slot not connected yet, minimize chance to double connect the signal
    disconnect(m_timerEventEveryMinute.data(), &QTimer::timeout,
               this, &MachineBackend::_onTimerEventFanFilterUsageMeterCalculate);
}

void MachineBackend::_onTimerEventFanFilterUsageMeterCalculate()
{
    qDebug() << metaObject()->className() << __func__  << thread();

    QSettings settings;
    ///FILTER LIFE
    {
        int minutes = pData->getFilterLifeMinutes();
        if(minutes > 0){
            minutes--;
            //            minutes = minutes - 1000;
            int percentLife = __getPercentFrom(minutes, pData->getFilterLifeMaximumBlowerUsageMode());

            /// event if in % value is zero but the minutes more then 0 minutes, then set % to 1
            if (percentLife == 0 && minutes > 0) percentLife = 1;

            //update to global observable variable
            pData->setFilterLifeMinutes(minutes);

            //save to sattings
            settings.setValue(SKEY_FILTER_METER_MIN, minutes);

            if(pData->getFilterLifeCalculationMode() == MachineEnums::FilterLifeCalc_BlowerUsage){
                if(percentLife > 100){
                    percentLife = 100;
                }
                if(percentLife < 0){
                    percentLife = 0;
                }
                pData->setFilterLifePercent(static_cast<short>(percentLife));
            }
        }
    }//

    /// FAN METER
    {
        int count = pData->getFanUsageMeter();
        count = count + 1;
        pData->setFanUsageMeter(count);

        settings.setValue(SKEY_FAN_METER, count);

        //        qDebug() << __func__ << "getFanInflowUsageMeter"  << count;
        ///MODBUS
        _setModbusRegHoldingValue(modbusRegisterAddress.IfaFanUsage.addr, static_cast<ushort>(count));
    }
}

void MachineBackend::_startPowerOutageCapture()
{
    qDebug() << __func__;

    /// double ensure this slot not connected yet, minimize chance to double connect the signal
    disconnect(m_timerEventEveryMinute.data(), &QTimer::timeout,
               this, &MachineBackend::_onTimerEventPowerOutageCaptureTime);
    /// connect uniqly timer event for warming up count down
    connect(m_timerEventEveryMinute.data(), &QTimer::timeout,
            this, &MachineBackend::_onTimerEventPowerOutageCaptureTime,
            Qt::UniqueConnection);

    QSettings settings;
    settings.setValue(SKEY_POWER_OUTAGE, MachineEnums::DIG_STATE_ONE);
    settings.setValue(SKEY_POWER_OUTAGE_FAN, MachineEnums::DIG_STATE_ZERO);
    settings.setValue(SKEY_POWER_OUTAGE_UV, MachineEnums::DIG_STATE_ZERO);

    if(pData->getFanPrimaryState()){
        settings.setValue(SKEY_POWER_OUTAGE_FAN, pData->getFanPrimaryState());
    }
    else if(pData->getUvState()){
        settings.setValue(SKEY_POWER_OUTAGE_UV, pData->getUvState());
    }

    /// TRIGERED ON START
    _onTimerEventPowerOutageCaptureTime();
}

void MachineBackend::_cancelPowerOutageCapture()
{
    /// double ensure this slot not connected yet, minimize chance to double connect the signal
    disconnect(m_timerEventEveryMinute.data(), &QTimer::timeout,
               this, &MachineBackend::_onTimerEventPowerOutageCaptureTime);

    QSettings settings;
    settings.setValue(SKEY_POWER_OUTAGE, MachineEnums::DIG_STATE_ZERO);
}

void MachineBackend::_onTimerEventPowerOutageCaptureTime()
{
    //    qDebug() << __FUNCTION__ ;

    QDateTime dateTime;
    QString dateTimeStrf = dateTime.currentDateTime().toString("dd-MMM-yyyy hh:mm");
    //    qDebug() << __FUNCTION__ << dateTimeStrf;

    //save to sattings
    QSettings settings;
    settings.setValue(SKEY_POWER_OUTAGE_TIME, dateTimeStrf);
}

void MachineBackend::_startMuteAlarmTimer()
{
    qDebug() << metaObject()->className() << __FUNCTION__ << thread();

    bool sashFullyOpened = pData->getSashWindowState() == MachineEnums::SASH_STATE_FULLY_OPEN_SSV;

    int seconds = (sashFullyOpened ? pData->getMuteAlarmTimeAtFullyOpened()
                                   : pData->getMuteAlarmTime());
    pData->setMuteAlarmCountdown(seconds);

    /// double ensure this slot not connected yet, minimize chance to double connect the signal
    disconnect(m_timerEventEverySecond.data(), &QTimer::timeout,
               this, &MachineBackend::_onTimerEventMuteAlarmTimer);
    /// connect uniqly timer event for warming up count down
    connect(m_timerEventEverySecond.data(), &QTimer::timeout,
            this, &MachineBackend::_onTimerEventMuteAlarmTimer,
            Qt::UniqueConnection);
}

void MachineBackend::_cancelMuteAlarmTimer()
{
    qDebug() << metaObject()->className() << __FUNCTION__ << thread();

    /// double ensure this slot not connected yet, minimize chance to double connect the signal
    disconnect(m_timerEventEverySecond.data(), &QTimer::timeout,
               this, &MachineBackend::_onTimerEventMuteAlarmTimer);

    bool sashFullyOpened = pData->getSashWindowState() == MachineEnums::SASH_STATE_FULLY_OPEN_SSV;

    int seconds = (sashFullyOpened ? pData->getMuteAlarmTimeAtFullyOpened()
                                   : pData->getMuteAlarmTime());
    pData->setMuteAlarmCountdown(seconds);

    /// clear vivarium mute state
    if (pData->getVivariumMuteState()){
        pData->setVivariumMuteState(false);
    }
}

void MachineBackend::_onTimerEventMuteAlarmTimer()
{
    qDebug() << metaObject()->className() << __FUNCTION__ << thread();

    int count = pData->getMuteAlarmCountdown();
    if(count <= 0){
        disconnect(m_timerEventEverySecond.data(), &QTimer::timeout,
                   this, &MachineBackend::_onTimerEventMuteAlarmTimer);

        bool sashFullyOpened = pData->getSashWindowState() == MachineEnums::SASH_STATE_FULLY_OPEN_SSV;

        int seconds = (sashFullyOpened ? pData->getMuteAlarmTimeAtFullyOpened()
                                       : pData->getMuteAlarmTime());
        pData->setMuteAlarmCountdown(seconds);
        pData->setMuteAlarmState(MachineEnums::DIG_STATE_ZERO);

        /// TURN AUTOMATICALLY
    }
    else {
        count--;
        pData->setMuteAlarmCountdown(count);
    }
}

void MachineBackend::_readRTCActualTime()
{
    //    qDebug() << metaObject()->className() << __FUNCTION__ << thread();

    int countdown = 0;
    m_boardCtpRTC->getRegBuffer_TimerACount(countdown);
    int wday = 0, day = 0, month = 0, year = 0;
    m_boardCtpRTC->getRegBuffer_Date(wday, day, month, year);
    int hour = 0, minute = 0, second = 0;
    m_boardCtpRTC->getRegBuffer_Clock(hour, minute, second);

    /// set to linux system, it's require with following format
    /// 2015-11-20 15:58:30
    QString dateTimeFormat = QString().asprintf("%d-%02d-%02d %02d:%02d:%02d", year, month, day, hour, minute, second);
    //    qDebug() << metaObject()->className() << __func__ << "dateTimeFormat" << dateTimeFormat << "countdown" << countdown;
    QDateTime dateValidation = QDateTime::fromString(dateTimeFormat, "yyyy-MM-dd hh:mm:ss");

    //    QLocale locale;

    //    QString langCode = pData->getLanguage().split("#")[0];
    //    if(langCode == "en")
    //        locale.setDefault(QLocale(QLocale::English, QLocale::UnitedStates));
    //    else if(langCode == "zh")
    //        locale.setDefault(QLocale(QLocale::Chinese, QLocale::China));
    //    else if(langCode == "fi")
    //        locale.setDefault(QLocale(QLocale::Finnish, QLocale::Finland));
    //    else if(langCode == "fr")
    //        locale.setDefault(QLocale(QLocale::French, QLocale::France));
    //    else if(langCode == "de")
    //        locale.setDefault(QLocale(QLocale::German, QLocale::Germany));
    //    else if(langCode == "it")
    //        locale.setDefault(QLocale(QLocale::Italian, QLocale::Italy));
    //    else if(langCode == "ja")
    //        locale.setDefault(QLocale(QLocale::Japanese, QLocale::Japan));
    //    else if(langCode == "ko")
    //        locale.setDefault(QLocale(QLocale::Korean));
    //    else if(langCode == "es")
    //        locale.setDefault(QLocale(QLocale::Spanish, QLocale::Spain));


    //    QString dateFormatShortStr = locale.dateFormat(QLocale::ShortFormat);
    //    QString timeFormatShortStr = locale.timeFormat(QLocale::ShortFormat);
    //    QString dateTimeFormatShortStr = locale.dateTimeFormat(QLocale::ShortFormat);
    //    qDebug() << dateFormatShortStr << timeFormatShortStr << dateTimeFormatShortStr;
    //    QString dateFormatLongStr = locale.dateFormat(QLocale::LongFormat);
    //    QString timeFormatLongStr = locale.timeFormat(QLocale::LongFormat);
    //    QString dateTimeFormatLongStr = locale.dateTimeFormat(QLocale::LongFormat);
    //    qDebug() << dateFormatLongStr << timeFormatLongStr << dateTimeFormatLongStr;

    pData->setWatchdogCounter(countdown);

    QDateTime currentDateTime = QDateTime().currentDateTime();
#ifdef __arm__
    pData->setRtcActualDate(dateValidation.date().toString("yyyy-MM-dd"));
    pData->setRtcActualTime(dateValidation.time().toString("hh:mm:ss"));
#else
    pData->setRtcActualDate(currentDateTime.date().toString("yyyy-MM-dd"));
    pData->setRtcActualTime(currentDateTime.time().toString("hh:mm:ss"));
#endif
    QString tmFormat = pData->getTimeClockPeriod() == 24 ? "hh:mm" : "h:mm AP";
    pData->setSystemActualDate(currentDateTime.date().toString("MMM dd yyyy"));
    pData->setSystemActualTime(currentDateTime.time().toString(tmFormat));
}

void MachineBackend::_insertDataLog()
{
    qDebug() << metaObject()->className() << __FUNCTION__ << thread();

    //    int currentRowCount = pData->getDataLogCount();

    //    /// This system has limited the datalog count only up to DATALOG_MAX_ROW
    //    if (currentRowCount >= DATALOG_MAX_ROW){
    //        return;
    //    }
    /// Only record the log when blower in nominal condition
    if (pData->getFanPrimaryState() != MachineEnums::FAN_STATE_ON){
        /// if timer event for this task still running, do stop it
        if(m_timerEventForDataLog->isActive()){
            m_timerEventForDataLog->stop();
        }
        return;
    }
    /// Only record the log when airflow has calibrated
    if (!pData->getAirflowCalibrationStatus()){
        /// if timer event for this task still running, do stop it
        if(m_timerEventForDataLog->isActive()){
            m_timerEventForDataLog->stop();
        }
        return;
    }
    QDateTime dateTime = QDateTime::currentDateTime();
    QString dateText = dateTime.toString("yyyy-MM-dd");
    QString timeText = dateTime.toString("hh:mm:ss");
    QString usernameSigned     = m_signedUsername;
    QString userfullnameSigned = m_signedFullname;
    if(usernameSigned == "")     usernameSigned = "guest";
    if(userfullnameSigned == "") userfullnameSigned = "Guest";

    QString tempStr = pData->getTemperatureValueStrf();
    QString ifaStr = pData->getInflowVelocityStr();
    QString dfaStr = pData->getDownflowVelocityStr();
    int adcIfa = pData->getInflowAdcConpensation();
    QString presStr = pData->getSeasPressureDiffStr();
    int fanRpm = pData->getFanPrimaryRpm();
    int fanDcy = pData->getFanPrimaryDutyCycle();

    short fanSpeedController = pData->getFanSpeedControllerBoard();
    bool seasInstalled = pData->getSeasInstalled();

    /// execute this function in where thread the m_pDataLog live at
    QMetaObject::invokeMethod(m_pDataLog.data(), [&,
                            dateText,
                            timeText,
                            tempStr,
                            ifaStr,
                            dfaStr,
                            adcIfa,
                            presStr,
                            fanRpm,
                            fanDcy,
                            usernameSigned,
                            userfullnameSigned,
                            fanSpeedController,
                            seasInstalled](){
            QVariantMap dataMap;
            dataMap.insert("date", dateText);
            dataMap.insert("time", timeText);
            dataMap.insert("temp", tempStr);
            dataMap.insert("ifa",  ifaStr);
            dataMap.insert("dfa",  dfaStr);
            dataMap.insert("adcIfa",  adcIfa);
            if(seasInstalled)
                dataMap.insert("pressure", presStr);
            else
                dataMap.insert("pressure",  "N/A");
            if(fanSpeedController == MachineEnums::FanSpeedController_RBM)
                dataMap.insert("fanRPM",  fanRpm);
            else
                dataMap.insert("fanRPM",  "N/A");
            dataMap.insert("fanDcy", fanDcy);
            dataMap.insert("username",  usernameSigned);
            dataMap.insert("userfullname",  userfullnameSigned);

            DataLogSql *sql = m_pDataLog->getPSqlInterface();
            bool success = sql->queryInsert(dataMap);

            /// check how many data log has stored now
            int count;
            success = sql->queryCount(&count);
            //        qDebug() << "success: " << success ;
            if(success){
                m_pDataLog->emitSetDataLogCount(count);
                //pData->setDataLogCount(count);
                //            qDebug() << count << maximumRowCount;
                bool logHasFull = count >= DATALOG_MAX_ROW;
                m_pDataLog->emitSetDataLogIsFull(logHasFull);
                //pData->setDataLogIsFull(logHasFull);
                if(count > DATALOG_MAX_ROW)
                    /// delete the last row from table
                    success = sql->queryDeleteOldestRowId();
            }//
        },
        Qt::QueuedConnection);
}

void MachineBackend::_insertAlarmLog(int alarmCode, const QString &alarmText)
{
    QDateTime dateTime = QDateTime::currentDateTime();
    QString dateText = dateTime.toString("yyyy-MM-dd");
    QString timeText = dateTime.toString("hh:mm:ss"); /// fix to 24H

    QString usernameSigned     = m_signedUsername;
    QString userfullnameSigned = m_signedFullname;
    if(usernameSigned == "")     usernameSigned = "guest";
    if(userfullnameSigned == "") userfullnameSigned = "Guest";

    QMetaObject::invokeMethod(m_pAlarmLog.data(),
        [&,
         dateText,
         timeText,
         alarmCode,
         alarmText,
         usernameSigned,
         userfullnameSigned](){

            QVariantMap dataMap;
            dataMap.insert("date",          dateText);
            dataMap.insert("time",          timeText);
            dataMap.insert("alarmCode",     alarmCode);
            dataMap.insert("alarmText",     alarmText);
            dataMap.insert("username",      usernameSigned);
            dataMap.insert("userfullname",  userfullnameSigned);

            AlarmLogSql *sql = m_pAlarmLog->getPSqlInterface();
            bool success = sql->queryInsert(dataMap);

            /// check how many data log has stored now
            int count;
            success = sql->queryCount(&count);
            //        qDebug() << __FUNCTION__ << "success: " << success << count;
            if(success){
                m_pAlarmLog->emitSetAlarmLogCount(count);
                //            qDebug() << count << maximumRowCount;
                bool logHasFull = count >= ALARMEVENTLOG_MAX_ROW;
                m_pAlarmLog->emitSetAlarmLogIsFull(logHasFull);
                if(count > ALARMEVENTLOG_MAX_ROW)
                    /// delete the last row from table
                    success = sql->queryDeleteOldestRowId();
            }//
        },
        Qt::QueuedConnection);
}

void MachineBackend::_insertEventLog(const QString &logText)
{
    //    if(pData->getEventLogIsFull()){
    //        return;
    //    }

    QDateTime dateTime = QDateTime::currentDateTime();
    QString dateText = dateTime.toString("yyyy-MM-dd");
    QString timeText = dateTime.toString("hh:mm:ss");

    QString usernameSigned     = m_signedUsername;
    QString userfullnameSigned = m_signedFullname;
    if(usernameSigned == "")     usernameSigned = "guest";
    if(userfullnameSigned == "") userfullnameSigned = "Guest";

    QMetaObject::invokeMethod(m_pEventLog.data(),
                              [&,
                               dateText,
                               timeText,
                               logText,
                               usernameSigned,
                               userfullnameSigned](){

                                  QVariantMap dataMap;
                                  dataMap.insert("date",          dateText);
                                  dataMap.insert("time",          timeText);
                                  dataMap.insert("logText",       logText);
                                  dataMap.insert("username",      usernameSigned);
                                  dataMap.insert("userfullname",  userfullnameSigned);

                                  EventLogSql *sql = m_pEventLog->getPSqlInterface();
                                  bool success = sql->queryInsert(dataMap);

                                  /// check how many data log has stored now
                                  int count;
                                  success = sql->queryCount(&count);
                                  //        qDebug() << __FUNCTION__ << "success: " << success << count;
                                  if(success){
                                      m_pEventLog->emitSetEventLogCount(count);
                                      //            qDebug() << count << maximumRowCount;
                                      bool logHasFull = count >= ALARMEVENTLOG_MAX_ROW;
                                      m_pEventLog->emitSetEventLogIsFull(logHasFull);
                                      if(count > ALARMEVENTLOG_MAX_ROW)
                                          /// delete the last row from table
                                          success = sql->queryDeleteOldestRowId();
                                  }//
                              });
}//

void MachineBackend::_insertResourceMonitorLog()
{
    qDebug() << metaObject()->className() << __FUNCTION__ << thread();

    QDateTime dateTime = QDateTime::currentDateTime();
    QString dateText = dateTime.toString("yyyy-MM-dd");
    QString timeText = dateTime.toString("hh:mm:ss");
    QString usernameSigned     = m_signedUsername;
    QString userfullnameSigned = m_signedFullname;
    if(usernameSigned == "")     usernameSigned = "guest";
    if(userfullnameSigned == "") userfullnameSigned = "Guest";

    if(pData->getFrontEndScreenState() != MachineEnums::ScreenState_ResourceMonitor)
        _readResourceMonitorParams();

    QString cpuUsage = pData->getResourceMonitorParams().at(MachineEnums::ResMon_CPU_Usage);
    QString memUsage = pData->getResourceMonitorParams().at(MachineEnums::ResMon_Memory_Usage);
    QString cpuTemp = pData->getResourceMonitorParams().at(MachineEnums::ResMon_CPU_Temp);
    QString sdCardLife = pData->getResourceMonitorParams().at(MachineEnums::ResMon_SD_Card_Life);

    /// execute this function in where thread the m_pResourceMonitorLog live at
    QMetaObject::invokeMethod(m_pResourceMonitorLog.data(), [&,
                                       dateText, timeText,
                                       cpuUsage, memUsage, cpuTemp, sdCardLife,
                                       usernameSigned, userfullnameSigned](){
            QVariantMap dataMap;
            dataMap.insert("date", dateText);
            dataMap.insert("time", timeText);
            dataMap.insert("cpuUsage", cpuUsage);
            dataMap.insert("memUsage", memUsage);
            dataMap.insert("cpuTemp",  cpuTemp);
            dataMap.insert("sdCardLife", sdCardLife);
            dataMap.insert("username", usernameSigned);
            dataMap.insert("userfullname", userfullnameSigned);

            ResourceMonitorLogSql *sql = m_pResourceMonitorLog->getPSqlInterface();
            bool success = sql->queryInsert(dataMap);

            /// check how many data log has stored now
            int count;
            success = sql->queryCount(&count);
            //        qDebug() << "success: " << success ;
            if(success){
                m_pResourceMonitorLog->emitSetResourceMonitorLogCount(count);
                //            qDebug() << count << maximumRowCount;
                bool logHasFull = count >= RESMONLOG_MAX_ROW;
                m_pResourceMonitorLog->emitSetResourceMonitorLogIsFull(logHasFull);
                if(count > RESMONLOG_MAX_ROW)
                    /// delete the last row from table
                    success = sql->queryDeleteOldestRowId();
            }//
        },
        Qt::QueuedConnection);
}

void MachineBackend::_setFanPrimaryStateNominal()
{
    short dutyCycle = pData->getFanPrimaryNominalDutyCycle();
    _setFanPrimaryDutyCycle(dutyCycle);
}

void MachineBackend::_setFanPrimaryStateMinimum()
{
    short dutyCycle = pData->getFanPrimaryMinimumDutyCycle();
    _setFanPrimaryDutyCycle(dutyCycle);
}

void MachineBackend::_setFanPrimaryStateStandby()
{
    short dutyCycle = pData->getFanPrimaryStandbyDutyCycle();
    _setFanPrimaryDutyCycle(dutyCycle);
}

void MachineBackend::_setFanPrimaryStateOFF()
{
    short dutyCycle = MachineEnums::DIG_STATE_ZERO;
    _setFanPrimaryDutyCycle(dutyCycle);
}

double MachineBackend::__convertCfmToLs(double value)
{
    return static_cast<double>(qRound(static_cast<double>(value) * 0.4719));
}

double MachineBackend::__convertLsToCfm(double value)
{
    return static_cast<double>(qRound(static_cast<double>(value) * 2.11888));
}

double MachineBackend::__convertFpmToMps(double value)
{
    if(value <= 0) return value;
    return value / 197.0;
}

double MachineBackend::__convertMpsToFpm(double value)
{
    return value * 197.0;
}

double MachineBackend::__toFixedDecPoint(double value, short point)
{
    double dec = static_cast<double>(qPow(10.0, point));
    //    qDebug() << "dec" << dec;
    if(dec != 0)
        return qRound(value * dec) / dec;
    return 0;
}

int MachineBackend::__convertCtoF(int c)
{
    return qRound((static_cast<double>(c) * 9.0/5.0) + 32.0);
}

int MachineBackend::__convertFtoC(int f)
{
    return qRound(static_cast<double>(f - 32) * 5.0/9.0);
}

double MachineBackend::__convertPa2inWG(int pa)
{
    return pa / 249.0;
}

int MachineBackend::__getPercentFrom(int val, int ref)
{
    if(ref != 0)
        return qRound((static_cast<double>(val)/ static_cast<double>(ref)) * 100.0);
    return 0;
}

double MachineBackend::__map(double x, double in_min, double in_max, double out_min, double out_max) const
{
    if((in_max - in_min) != 0)
        return (x - in_min) * (out_max - out_min) / (in_max - in_min) + out_min;
    return 0.0;
}

bool MachineBackend::isMaintenanceModeActive() const
{
    return pData->getOperationMode() == MachineEnums::MODE_OPERATION_MAINTENANCE;
}

bool MachineBackend::isAirflowHasCalibrated() const
{
    return pData->getAirflowCalibrationStatus() >= MachineEnums::AF_CALIB_FACTORY;
}

bool MachineBackend::isTempAmbientNormal() const
{
    return pData->getTempAmbientStatus() == MachineEnums::TEMP_AMB_NORMAL;
}

bool MachineBackend::isTempAmbientLow() const
{
    return pData->getTempAmbientStatus() == MachineEnums::TEMP_AMB_LOW;
}

bool MachineBackend::isTempAmbientHigh() const
{
    return pData->getTempAmbientStatus() == MachineEnums::TEMP_AMB_HIGH;
}

bool MachineBackend::isFanStateNominal() const
{
    return pData->getFanPrimaryState() == MachineEnums::FAN_STATE_ON;
}

bool MachineBackend::isFanStateStandby() const
{
    return pData->getFanPrimaryState() == MachineEnums::FAN_STATE_STANDBY;
}

bool MachineBackend::isAlarmActive(short alarm) const
{
    return alarm >= MachineEnums::ALARM_ACTIVE_STATE;
}

bool MachineBackend::isAlarmNormal(short alarm) const
{
    return alarm == MachineEnums::ALARM_NORMAL_STATE;
}

bool MachineBackend::isAlarmNA(short alarm) const
{
    return alarm == MachineEnums::ALARM_NA_STATE;
}

bool MachineBackend::isTempAmbNormal(short value) const
{
    return value == MachineEnums::TEMP_AMB_NORMAL;
}

bool MachineBackend::isTempAmbLow(short value) const
{
    return value == MachineEnums::TEMP_AMB_LOW;
}

bool MachineBackend::isTempAmbHigh(short value) const
{
    return value == MachineEnums::TEMP_AMB_HIGH;
}

void MachineBackend::_checkCertificationReminder()
{
    qDebug() << metaObject()->className() << __FUNCTION__ << thread();

    QString strDate = pData->getDateCertificationReminder();
    QDate acDate = QDate::fromString(strDate,"yyyy-MM-dd");

    if(acDate.isValid()){
        QDate currentDate = QDate::currentDate();
        //     QString dateText = dateTime.toString("dd-MM-yyyy");
        //     QString timeText = dateTime.toString("hh:mm:ss");

        qDebug() << "actual date " << acDate;
        qDebug() << "str date " << strDate;

        //    pData->setCertificationExpired(acDate == currentDate);

        qint64 span = currentDate.daysTo(acDate);

        qDebug() << "span days" << span;

        pData->setCertificationExpiredValid(true);
        pData->setCertificationExpired(span == 0);
        pData->setCertificationExpiredCount(static_cast<int>(span));
    }
    else {
        pData->setCertificationExpiredValid(false);
        pData->setCertificationExpired(false);
        pData->setCertificationExpiredCount(0);
    }
}

/*!
 * \class
 * \brief MachineBackend::_onModbusDataWritten
 * \param table
 * \param address
 * \param size
 */
void MachineBackend::_onModbusDataWritten(QModbusDataUnit::RegisterType table, int address, int size)
{
    m_pModbusServer->setValue(QModbusServer::DeviceBusy, true);
    m_pModbusServer->blockSignals(true);

    for (int i=0; i < size; ++i) {
        quint16 value;
        switch (table) {
        case QModbusDataUnit::RegisterType::HoldingRegisters:
            /// take lates data from modbus device was written
            m_pModbusServer->data(QModbusDataUnit::HoldingRegisters, quint16(address + i), &value);
            qDebug() << __func__ << address + i << value;
            _modbusCommandHandler(address + i, value);
            break;
        default:
            break;
        }
    }

    m_pModbusServer->blockSignals(false);
    m_pModbusServer->setValue(QModbusServer::DeviceBusy, false);
}

/*!
 * \brief MachineBackend::_modbusCommandHandler
 * \param address
 * \param value
 */
void MachineBackend::_modbusCommandHandler(int address, uint16_t value)
{
    qDebug() << __func__ << address << value;

    bool revertData = true;

    if(m_signedUserLevel >= MachineEnums::USER_LEVEL_OPERATOR){
        switch (address) {
        case modbusRegisterAddress.FanState.addr:
            if (modbusRegisterAddress.FanState.rw){
                if(!pData->getFanPrimaryInterlocked() && !pData->getPostPurgingActive())
                {
                    setFanState(static_cast<short>(value));
                    revertData = false;
                }//
            }
            break;
        case modbusRegisterAddress.LightState.addr:
            if (modbusRegisterAddress.LightState.rw){
                if(!pData->getLightInterlocked()){
                    setLightState(static_cast<short>(value));
                    revertData = false;
                }
            }
            break;
        case modbusRegisterAddress.LightIntensity.addr:
            if (modbusRegisterAddress.LightIntensity.rw){
                if(!pData->getLightInterlocked()){
                    setLightIntensity(static_cast<short>(value));
                    revertData = false;
                }//
            }
            break;
        case modbusRegisterAddress.SocketState.addr:
            if (modbusRegisterAddress.SocketState.rw){
                if(!pData->getSocketInterlocked()){
                    setSocketState(static_cast<short>(value));
                    revertData = false;
                }//
            }
            break;
        case modbusRegisterAddress.GasState.addr:
            if (modbusRegisterAddress.GasState.rw){
                if(!pData->getGasInterlocked()){
                    setGasState(static_cast<short>(value));
                    revertData = false;
                }//
            }
            break;
        case modbusRegisterAddress.UvState.addr:
            if (modbusRegisterAddress.UvState.rw){
                if(!pData->getUvInterlocked()){
                    setUvState(static_cast<short>(value));
                    revertData = false;
                }//
            }
            break;
        }//
    }//

    if(revertData){
        /// if the register is read-only
        /// revert the value to the actual value from buffer
        uint16_t data = m_modbusDataUnitBufferRegisterHolding->at(address);
        m_pModbusServer->setData(QModbusDataUnit::HoldingRegisters, static_cast<ushort>(address), data);
    }
}

void MachineBackend::_setModbusRegHoldingValue(int addr, uint16_t value)
{
    /// Dont continue if the value already same, no more wasting time bro! ^_^
    uint16_t valuePrev;
    m_pModbusServer->data(QModbusDataUnit::HoldingRegisters, quint16(addr), &valuePrev);
    if(value == valuePrev) return;

    /// Dont trigered signal onDataWritten from this action
    m_pModbusServer->blockSignals(true);

    m_pModbusServer->setData(QModbusDataUnit::HoldingRegisters, static_cast<ushort>(addr), value);
    m_modbusDataUnitBufferRegisterHolding->replace(addr, value);

    /// Get back trigered signal onDataWritten when master write to register
    m_pModbusServer->blockSignals(false);
}

/*!
 * \brief MachineBackend::_onModbusConnectionStatusChanged
 */
bool MachineBackend::_callbackOnModbusConnectionStatusChanged(QTcpSocket* newClient)
{
    qDebug() << __func__  << thread();

    QString newConnectedClientIPv4 = newClient->peerAddress().toString();
    qDebug() << __func__ << newConnectedClientIPv4;

    if ((pData->getModbusAllowIpMaster() == ALLOW_ANY_IP)
        || pData->getModbusAllowIpMaster() == newConnectedClientIPv4) {

        QString message = "1@" + newConnectedClientIPv4;
        pData->setModbusLatestStatus(message);

        QObject::connect(newClient, &QTcpSocket::disconnected, newClient, [&](){
            qDebug() << "Bye bye!" << pData->getModbusLatestStatus().replace("1@", "");

            QString message = pData->getModbusLatestStatus().replace("1@", "0@");
            pData->setModbusLatestStatus(message);

            /// RECORD IN EVENT LOG
            QString msg = QString("%1 (%2)").arg(_tr(EVENT_STR_MODBUS_DIS), message.remove("0@"));
            _insertEventLog(msg);
        });

        /// RECORD IN EVENT LOG
        QString msg = QString("%1 (%2)").arg(_tr(EVENT_STR_MODBUS_CON), newConnectedClientIPv4);
        _insertEventLog(msg);

        return true;
    }

    QString msg = QString("%1 (%2)").arg(_tr(EVENT_STR_MODBUS_REJECT), newConnectedClientIPv4);
    _insertEventLog(msg);

    qWarning() << __func__ << "Warning! Got requested from not allowable client/master." << newConnectedClientIPv4;
    return false;
}

void MachineBackend::insertEventLog(const QString &eventText)
{
    qDebug() << metaObject()->className() << __func__  << thread();

    _insertEventLog(eventText);
}

void MachineBackend::refreshLogRowsCount(const QString &table)
{
    qDebug() << metaObject()->className() << __FUNCTION__  << table << thread();

    //const QString dbConName = QString("%1%2").arg(__FUNCTION__, table);

    if (table == QLatin1String("datalog")){

        QMetaObject::invokeMethod(m_pDataLog.data(), [&](){
                DataLogSql *sql = m_pDataLog->getPSqlInterface();

                /// check how many data log has stored now
                int count;
                bool success = sql->queryCount(&count);
                //qWarning() << __FUNCTION__ << "success: " << success << count;
                if(success){
                    m_pDataLog->emitSetDataLogCount(count);
                    //qDebug() << count << maximumRowCount;
                    m_pDataLog->emitSetDataLogIsFull(count >= DATALOG_MAX_ROW);
                }//
            }, Qt::QueuedConnection);
    }
    else if (table == QLatin1String("alarmlog")){
        QMetaObject::invokeMethod(m_pAlarmLog.data(), [&](){
                AlarmLogSql *sql = m_pAlarmLog->getPSqlInterface();

                /// check how many data log has stored now
                int count;
                bool success = sql->queryCount(&count);
                //qWarning() << __FUNCTION__ << "success: " << success << count;
                if(success){
                    m_pAlarmLog->emitSetAlarmLogCount(count);
                    //            qDebug() << count << maximumRowCount;
                    m_pAlarmLog->emitSetAlarmLogIsFull(count >= ALARMEVENTLOG_MAX_ROW);
                }//
            }, Qt::QueuedConnection);
    }
    else if (table == QLatin1String("eventlog")){

        QMetaObject::invokeMethod(m_pEventLog.data(), [&](){
                EventLogSql *sql = m_pEventLog->getPSqlInterface();

                /// check how many data log has stored now
                int count;
                bool success = sql->queryCount(&count);
                //qWarning() << __FUNCTION__ << "success: " << success << count;
                if(success){
                    m_pEventLog->emitSetEventLogCount(count);
                    //            qDebug() << count << maximumRowCount;
                    m_pEventLog->emitSetEventLogIsFull(count >= ALARMEVENTLOG_MAX_ROW);
                }//
            }, Qt::QueuedConnection);
    }//
    else if (table == QLatin1String("replaceablecomprecord")){

        QMetaObject::invokeMethod(m_pReplaceableCompRecord.data(), [&](){
                ReplaceableCompRecordSql *sql = m_pReplaceableCompRecord->getPSqlInterface();

                /// check how many data log has stored now
                int count;
                bool success = sql->queryCount(&count);
                //qWarning() << __FUNCTION__ << "success: " << success << count;
                if(success){
                    m_pReplaceableCompRecord->emitSetReplaceableCompRecordCount(count);
                    //            qDebug() << count << maximumRowCount;
                    m_pReplaceableCompRecord->emitSetReplaceableCompRecordIsFull(count >= ALARMREPLACEABLECOMPRECORD_MAX_ROW);
                }//
            }, Qt::QueuedConnection);
    }//
    else if (table == QLatin1String("systemmonitorlog")){

        QMetaObject::invokeMethod(m_pResourceMonitorLog.data(), [&](){
                ResourceMonitorLogSql *sql = m_pResourceMonitorLog->getPSqlInterface();

                /// check how many data log has stored now
                int count;
                bool success = sql->queryCount(&count);
                //qWarning() << __FUNCTION__ << "success: " << success << count;
                if(success){
                    m_pResourceMonitorLog->emitSetResourceMonitorLogCount(count);
                    //            qDebug() << count << maximumRowCount;
                    m_pResourceMonitorLog->emitSetResourceMonitorLogIsFull(count >= RESMONLOG_MAX_ROW);
                }//
            }, Qt::QueuedConnection);
    }//
}

void MachineBackend::reInitializeLogger(const QString &table)
{
    qDebug() << metaObject()->className() << __FUNCTION__  << table << thread();

    //const QString dbConName = QString("%1%2").arg(__FUNCTION__, table);

    if (table == QLatin1String("datalog")){
        QMetaObject::invokeMethod(m_pDataLog.data(), [&](){
                m_pDataLog->reInitialize();
            }, Qt::QueuedConnection);
    }
    else if (table == QLatin1String("alarmlog")){
        QMetaObject::invokeMethod(m_pAlarmLog.data(), [&](){
                m_pAlarmLog->reInitialize();
            }, Qt::QueuedConnection);
    }
    else if (table == QLatin1String("eventlog")){
        QMetaObject::invokeMethod(m_pEventLog.data(), [&](){
                m_pEventLog->reInitialize();
            }, Qt::QueuedConnection);
    }//
    else if (table == QLatin1String("replaceablecomprecord")){
        QMetaObject::invokeMethod(m_pReplaceableCompRecord.data(), [&](){
                m_pReplaceableCompRecord->reInitialize();
            }, Qt::QueuedConnection);
    }//
    else if (table == QLatin1String("systemmonitorlog")){
        QMetaObject::invokeMethod(m_pResourceMonitorLog.data(), [&](){
                m_pResourceMonitorLog->reInitialize();
            }, Qt::QueuedConnection);
    }//
}//

void MachineBackend::_onTriggeredEventEverySecond()
{
    //    qDebug() << metaObject()->className() << __func__  << thread();

    //qDebug() << "m_operationPrevMode:" << m_operationPrevMode << "operationMode:" << pData->getOperationMode();

    _readRTCActualTime();
    /// Start the eventTimerEveryMinute when current time second value is 0
    if(!m_timerEventEveryMinute->isActive()){
        int currentTimeSecond = QTime::currentTime().second();
        //qDebug() << currentTimeSecond;
        if(currentTimeSecond == 5){ /// tolerance +5 seconds
            m_timerEventEveryMinute->start();
        }
    }//

    /// Cabinet Up Time
    pData->setCabinetUpTime(pData->getCabinetUpTime()+1);

    /// Resource Monitor
    if(pData->getFrontEndScreenState() == MachineEnums::ScreenState_ResourceMonitor)
        _readResourceMonitorParams();
    //    /// LOCAL OBJECT
    //    QLocale m_locale;
    //    {
    //        QString langCode = pData->getLanguage().split("#")[0];
    //        if(langCode == "en")
    //            m_locale.setDefault(QLocale(QLocale::English, QLocale::UnitedStates));
    //        else if(langCode == "zh")
    //            m_locale.setDefault(QLocale(QLocale::Chinese, QLocale::China));
    //        else if(langCode == "fi")
    //            m_locale.setDefault(QLocale(QLocale::Finnish, QLocale::Finland));
    //        else if(langCode == "fr")
    //            m_locale.setDefault(QLocale(QLocale::French, QLocale::France));
    //        else if(langCode == "de")
    //            m_locale.setDefault(QLocale(QLocale::German, QLocale::Germany));
    //        else if(langCode == "it")
    //            m_locale.setDefault(QLocale(QLocale::Italian, QLocale::Italy));
    //        else if(langCode == "ja")
    //            m_locale.setDefault(QLocale(QLocale::Japanese, QLocale::Japan));
    //        else if(langCode == "ko")
    //            m_locale.setDefault(QLocale(QLocale::Korean));
    //        else if(langCode == "es")
    //            m_locale.setDefault(QLocale(QLocale::Spanish, QLocale::Spain));
    //    }//

    //    qDebug() << m_locale.nativeCountryName() << m_locale.dateTimeFormat(QLocale::ShortFormat);

    if(pData->getFanPrimaryState() == MachineEnums::FAN_STATE_ON){
        if(pData->getFanPrimaryDutyCycle()
            && pData->getFanPrimaryRpm()
            && !pData->getWarmingUpActive()
            && pData->getOperationMode() != MachineEnums::MODE_OPERATION_MAINTENANCE
            && (pData->getFrontEndScreenState() != MachineEnums::ScreenState_Calibration)
            && (pData->getFrontEndScreenState() != MachineEnums::ScreenState_FanSpeed)){
            //for(short i=0; i<60; i++)
            if(m_fanPrimaryRpmActualBuffer->length() >= SDEF_FILTER_RPM_MOV_AVG){
                m_fanPrimaryRpmMovAvgTotal = m_fanPrimaryRpmMovAvgTotal - m_fanPrimaryRpmActualBuffer->front();
                m_fanPrimaryRpmActualBuffer->pop_front();
            }//

            int rpm = pData->getFanPrimaryRpm();

            /// Consider as stable if the fluctuation is less than +- 10
            //            qDebug() << "m_fanPrimaryRpmActualBuffer" << m_fanPrimaryRpmActualBuffer;
            //            qDebug() << "rpm" << rpm;
            bool isStable = false;
            if(m_fanPrimaryRpmActualBuffer->length()){
                isStable = qAbs(m_fanPrimaryRpmActualBuffer->back() - rpm) <= 5;
            }//
            //            qDebug() << "isStable" << isStable;
            m_fanPrimaryRpmActualBuffer->push_back(rpm);
            m_fanPrimaryRpmMovAvgTotal  = m_fanPrimaryRpmMovAvgTotal + rpm;

            if(m_fanPrimaryRpmActualBuffer->length() != 0)
                m_fanPrimaryRpmMovAvg = m_fanPrimaryRpmMovAvgTotal / m_fanPrimaryRpmActualBuffer->length();

            if(isStable){
                if(++m_fanPrimaryRpmMovAvgCountStable >= 60){
                    m_fanPrimaryRpmMovAvgCountStable = 60;
                    /// Save the new stable rpm as a new nominal rpm
                    if(pData->getFilterLifeRpm() != m_fanPrimaryRpmMovAvg){
                        pData->setFilterLifeRpm(m_fanPrimaryRpmMovAvg);
                        QSettings settings;
                        settings.setValue(SKEY_FILTER_METER_RPM, m_fanPrimaryRpmMovAvg);
                    }//
                }//
            }//
            else {
                m_fanPrimaryRpmMovAvgCountStable = 0;
            }//

            //            qDebug() << "m_fanPrimaryRpmMovAvgCountStable" << m_fanPrimaryRpmMovAvgCountStable;
            //            qDebug() << "m_fanPrimaryRpmMovAvgTotal" << m_fanPrimaryRpmMovAvgTotal;
            //            qDebug() << "m_fanPrimaryRpmMovAvg" << m_fanPrimaryRpmMovAvg;
            //            qDebug() << "m_fanPrimaryRpmActualBuffer" << m_fanPrimaryRpmActualBuffer;

            int percentLife = 100;

            int minRpm  = pData->getFilterLifeMinimumBlowerRpmMode();
            int maxRpm  = pData->getFilterLifeMaximumBlowerRpmMode();

            percentLife = 100 - qRound(__map(pData->getFilterLifeRpm(), minRpm, maxRpm, 0, 100));

            if(pData->getFilterLifeCalculationMode() == MachineEnums::FilterLifeCalc_BlowerRpm){
                //                qDebug() << "CalculateByRPM";
                if(percentLife > 100){
                    percentLife = 100;
                }//
                if(percentLife < 0){
                    percentLife = 0;
                }//
                pData->setFilterLifePercent(static_cast<short>(percentLife));
            }//
            //            qDebug() << "filter %" << percentLife << "filter Rpm" << pData->getFilterLifeRpm();

            //            qDebug() << "rpm" << rpm << "m_fanPrimaryRpmMovAvg"
            //                     << m_fanPrimaryRpmMovAvg << "percentLife"
            //                     << percentLife << "m_fanPrimaryRpmMovAvgCountStable"
            //                     << m_fanPrimaryRpmMovAvgCountStable;
        }//
        else{
            if(m_fanPrimaryRpmActualBuffer->length())
                m_fanPrimaryRpmActualBuffer->clear();
            if(m_fanPrimaryRpmMovAvgTotal)
                m_fanPrimaryRpmMovAvgTotal = 0;
            if(m_fanPrimaryRpmMovAvgCountStable)
                m_fanPrimaryRpmMovAvgCountStable = 0;
        }//
    }//

    if(pData->getFanPrimaryState() == MachineEnums::FAN_STATE_STANDBY){
        if(m_needToCalculateStbRpmField){
            if(m_countDownTimerCalculateStbRpmField){
                m_countDownTimerCalculateStbRpmField--;
            }else{
                setFanPrimaryStandbyRpmField(pData->getFanPrimaryRpm());
                m_needToCalculateStbRpmField = false;
            }//
        }//
    }//

    if(!pData->getAlarmsState()){
        if(m_pBuzzer->getStateActual())
            m_pBuzzer->setState(false);
    }//

    //    qDebug() << pData->getBookingScheduleNotifEnable() << pData->getBookingScheduleTodayDispNotif();

    /// Stop Timer m_timerEventForRTCWatchdogCountMonitor
    if(m_timerEventForRTCWatchdogCountMonitor->isActive()){
        if(pData->getWatchdogCounter() > 30){
            m_timerEventForRTCWatchdogCountMonitor->stop();
        }
    }//

    //    qDebug() << "Screen state" << pData->getFrontEndScreenState();
    //    _getSystemClockSynchronized();

    //    qDebug() << "Network:" << m_networkConnectedStatus;

}//

void MachineBackend::_onTriggeredEventEvery50MSecond()
{

}

void MachineBackend::_onTriggeredEventEveryMinute()
{
    qDebug() << __func__  << thread();

    m_uvSchedulerAutoSet->routineTask();
    m_lightSchedulerAutoSet->routineTask();
    m_socketSchedulerAutoSet->routineTask();
    m_fanSchedulerAutoSet->routineTask();
    m_uvSchedulerAutoSetOff->routineTask();
    m_lightSchedulerAutoSetOff->routineTask();
    m_socketSchedulerAutoSetOff->routineTask();
    m_fanSchedulerAutoSetOff->routineTask();

    QDate qDate = QDate().currentDate();
    QString currentDateStr = qDate.toString("yyyy-MM-dd");
    if(m_currentDateStr != currentDateStr){
        m_currentDateStr = currentDateStr;
        emit currentDateStrChanged(m_currentDateStr);
    }//

    refreshBookScheduleNotifDisplay();
}//

void MachineBackend::_onTriggeredEventEveryHalfHour()
{
#ifdef __arm__
    _syncLinuxTimeToRtc();
#endif
}//

void MachineBackend::_onTriggeredEventEveryHour()
{
    qDebug() << __func__  << thread();

    //    _checkCertificationReminder();
    _refreshAlarmPreventMaint();
}

/**
 * @brief MachineBackend::_onTriggeredUvSchedulerAutoSet
 *
 * It's ca
 */
void MachineBackend::_onTriggeredUvSchedulerAutoSet()
{
    qDebug() << metaObject()->className() <<  __func__  << thread();

    m_pUV->setState(MachineEnums::DIG_STATE_ONE);
    if(!m_pUV->interlock()){
        setBuzzerBeep();
    }

    _insertEventLog(_tr(EVENT_STR_UV_ON_SCH));
    /// Disable Scheduler if the repeat just once
    if(pData->getUVAutoDayRepeat() == 0){
        setUVAutoEnabled(MachineEnums::DIG_STATE_ZERO);
    }
}

void MachineBackend::_onTriggeredUvSchedulerAutoSetOff()
{
    qDebug() << metaObject()->className() <<  __func__  << thread();

    m_pUV->setState(MachineEnums::DIG_STATE_ZERO);
    if(!m_pUV->interlock()){
        setBuzzerBeep();
    }

    _insertEventLog(_tr(EVENT_STR_UV_OFF_SCH));
    /// Disable Scheduler if the repeat just once
    if(pData->getUVAutoDayRepeatOff() == 0){
        setUVAutoEnabledOff(MachineEnums::DIG_STATE_ZERO);
    }
}

void MachineBackend::_onTriggeredLightSchedulerAutoSet()
{
    qDebug() << metaObject()->className() <<  __func__  << thread();

    m_pLight->setState(MachineEnums::DIG_STATE_ONE);
    if(!m_pLight->interlock()){
        setBuzzerBeep();
    }

    _insertEventLog(_tr(EVENT_STR_LIGHT_ON_SCH));
    /// Disable Scheduler if the repeat just once
    if(pData->getLightAutoDayRepeat() == 0){
        setLightAutoEnabled(MachineEnums::DIG_STATE_ZERO);
    }
}

void MachineBackend::_onTriggeredLightSchedulerAutoSetOff()
{
    qDebug() << metaObject()->className() <<  __func__  << thread();

    m_pLight->setState(MachineEnums::DIG_STATE_ZERO);
    if(!m_pLight->interlock()){
        setBuzzerBeep();
    }

    _insertEventLog(_tr(EVENT_STR_LIGHT_OFF_SCH));
    /// Disable Scheduler if the repeat just once
    if(pData->getLightAutoDayRepeatOff() == 0){
        setLightAutoEnabledOff(MachineEnums::DIG_STATE_ZERO);
    }
}

void MachineBackend::_onTriggeredSocketSchedulerAutoSet()
{
    qDebug() << metaObject()->className() <<  __func__  << thread();

    m_pSocket->setState(MachineEnums::DIG_STATE_ONE);
    if(!m_pSocket->interlock()){
        setBuzzerBeep();
    }

    _insertEventLog(_tr(EVENT_STR_SOCKET_ON_SCH));
    /// Disable Scheduler if the repeat just once
    if(pData->getSocketAutoDayRepeat() == 0){
        setSocketAutoEnabled(MachineEnums::DIG_STATE_ZERO);
    }
}

void MachineBackend::_onTriggeredSocketSchedulerAutoSetOff()
{
    qDebug() << metaObject()->className() <<  __func__  << thread();

    m_pSocket->setState(MachineEnums::DIG_STATE_ZERO);
    if(!m_pSocket->interlock()){
        setBuzzerBeep();
    }

    _insertEventLog(_tr(EVENT_STR_SOCKET_OFF_SCH));
    /// Disable Scheduler if the repeat just once
    if(pData->getSocketAutoDayRepeatOff() == 0){
        setSocketAutoEnabledOff(MachineEnums::DIG_STATE_ZERO);
    }
}

void MachineBackend::_onTriggeredFanSchedulerAutoSet()
{
    qDebug() << metaObject()->className() << __func__  << thread();


    if(!m_pFanPrimary->getInterlock()){
        setBuzzerBeep();
        setFanState(MachineEnums::FAN_STATE_ON);
    }
    //    _setFanPrimaryStateNominal();

    _insertEventLog(_tr(EVENT_STR_FAN_ON_SCH));
    /// Disable Scheduler if the repeat just once
    if(pData->getFanAutoDayRepeat() == 0){
        setFanAutoEnabled(MachineEnums::DIG_STATE_ZERO);
    }
}

void MachineBackend::_onTriggeredFanSchedulerAutoSetOff()
{
    qDebug() << metaObject()->className() << __func__  << thread();


    //if(!m_pFanPrimary->getInterlock()){
    setBuzzerBeep();
    setFanState(MachineEnums::FAN_STATE_OFF);
    //}
    //    _setFanPrimaryStateNominal();

    _insertEventLog(_tr(EVENT_STR_FAN_OFF_SCH));
    /// Disable Scheduler if the repeat just once
    if(pData->getFanAutoDayRepeatOff() == 0){
        setFanAutoEnabledOff(MachineEnums::DIG_STATE_ZERO);
    }
}

void MachineBackend::setUVAutoEnabled(int uvAutoSetEnabled)
{
    qDebug() << __func__  << thread();
    m_uvSchedulerAutoSet->setEnabled(uvAutoSetEnabled);

    pData->setUVAutoEnabled(uvAutoSetEnabled);

    QSettings settings;
    settings.setValue(SKEY_SCHED_UV_ENABLE, uvAutoSetEnabled);
}

void MachineBackend::setUVAutoTime(int uvAutoSetTime)
{
    qDebug() << __func__  << thread();
    m_uvSchedulerAutoSet->setTime(uvAutoSetTime);

    pData->setUVAutoTime(uvAutoSetTime);

    QSettings settings;
    settings.setValue(SKEY_SCHED_UV_TIME, uvAutoSetTime);
}

void MachineBackend::setUVAutoDayRepeat(int uvAutoSetDayRepeat)
{
    qDebug() << __func__  << thread();
    m_uvSchedulerAutoSet->setDayRepeat(uvAutoSetDayRepeat);

    pData->setUVAutoDayRepeat(uvAutoSetDayRepeat);

    QSettings settings;
    settings.setValue(SKEY_SCHED_UV_REPEAT, uvAutoSetDayRepeat);
}

void MachineBackend::setUVAutoWeeklyDay(int uvAutoSetWeeklyDay)
{
    qDebug() << __func__  << thread();
    m_uvSchedulerAutoSet->setWeeklyDay(uvAutoSetWeeklyDay);

    pData->setUVAutoWeeklyDay(uvAutoSetWeeklyDay);

    QSettings settings;
    settings.setValue(SKEY_SCHED_UV_REPEAT_DAY, uvAutoSetWeeklyDay);
}

void MachineBackend::setUVAutoEnabledOff(int uvAutoSetEnabledOff)
{
    qDebug() << __func__  << thread();
    m_uvSchedulerAutoSetOff->setEnabled(uvAutoSetEnabledOff);

    pData->setUVAutoEnabledOff(uvAutoSetEnabledOff);

    QSettings settings;
    settings.setValue(SKEY_SCHED_UV_ENABLE_OFF, uvAutoSetEnabledOff);
}

void MachineBackend::setUVAutoTimeOff(int uvAutoSetTimeOff)
{
    qDebug() << __func__  << thread();
    m_uvSchedulerAutoSetOff->setTime(uvAutoSetTimeOff);

    pData->setUVAutoTimeOff(uvAutoSetTimeOff);

    QSettings settings;
    settings.setValue(SKEY_SCHED_UV_TIME_OFF, uvAutoSetTimeOff);
}

void MachineBackend::setUVAutoDayRepeatOff(int uvAutoSetDayRepeatOff)
{
    qDebug() << __func__  << thread();
    m_uvSchedulerAutoSetOff->setDayRepeat(uvAutoSetDayRepeatOff);

    pData->setUVAutoDayRepeatOff(uvAutoSetDayRepeatOff);

    QSettings settings;
    settings.setValue(SKEY_SCHED_UV_REPEAT_OFF, uvAutoSetDayRepeatOff);
}

void MachineBackend::setUVAutoWeeklyDayOff(int uvAutoSetWeeklyDayOff)
{
    qDebug() << __func__  << thread();
    m_uvSchedulerAutoSetOff->setWeeklyDay(uvAutoSetWeeklyDayOff);

    pData->setUVAutoWeeklyDayOff(uvAutoSetWeeklyDayOff);

    QSettings settings;
    settings.setValue(SKEY_SCHED_UV_REPEAT_DAY_OFF, uvAutoSetWeeklyDayOff);
}

void MachineBackend::setLightAutoEnabled(int value)
{
    qDebug() << __func__  << thread();
    m_lightSchedulerAutoSet->setEnabled(value);

    pData->setLightAutoEnabled(value);

    QSettings settings;
    settings.setValue(SKEY_SCHED_LIGHT_ENABLE, value);
}

void MachineBackend::setLightAutoTime(int value)
{
    qDebug() << metaObject()->className() << __func__  << thread();
    qDebug() << __func__  << thread();
    m_lightSchedulerAutoSet->setTime(value);

    pData->setLightAutoTime(value);

    QSettings settings;
    settings.setValue(SKEY_SCHED_LIGHT_TIME, value);
}

void MachineBackend::setLightAutoDayRepeat(int value)
{
    qDebug() << metaObject()->className() << __func__  << thread();
    m_lightSchedulerAutoSet->setDayRepeat(value);

    pData->setLightAutoDayRepeat(value);

    QSettings settings;
    settings.setValue(SKEY_SCHED_LIGHT_REPEAT, value);
}

void MachineBackend::setLightAutoWeeklyDay(int value)
{
    qDebug() << metaObject()->className() << __func__  << thread();
    m_lightSchedulerAutoSet->setWeeklyDay(value);

    pData->setLightAutoWeeklyDay(value);

    QSettings settings;
    settings.setValue(SKEY_SCHED_LIGHT_REPEAT_DAY, value);
}

void MachineBackend::setLightAutoEnabledOff(int value)
{
    qDebug() << metaObject()->className() << __func__  << thread();
    m_lightSchedulerAutoSetOff->setEnabled(value);

    pData->setLightAutoEnabledOff(value);

    QSettings settings;
    settings.setValue(SKEY_SCHED_LIGHT_ENABLE_OFF, value);
}

void MachineBackend::setLightAutoTimeOff(int value)
{
    qDebug() << metaObject()->className() << __func__  << thread();
    m_lightSchedulerAutoSetOff->setTime(value);

    pData->setLightAutoTimeOff(value);

    QSettings settings;
    settings.setValue(SKEY_SCHED_LIGHT_TIME_OFF, value);
}

void MachineBackend::setLightAutoDayRepeatOff(int value)
{
    qDebug() << metaObject()->className() << __func__  << thread();
    m_lightSchedulerAutoSetOff->setDayRepeat(value);

    pData->setLightAutoDayRepeatOff(value);

    QSettings settings;
    settings.setValue(SKEY_SCHED_LIGHT_REPEAT_OFF, value);
}

void MachineBackend::setLightAutoWeeklyDayOff(int value)
{
    qDebug() << metaObject()->className() << __func__  << thread();
    m_lightSchedulerAutoSetOff->setWeeklyDay(value);

    pData->setLightAutoWeeklyDayOff(value);

    QSettings settings;
    settings.setValue(SKEY_SCHED_LIGHT_REPEAT_DAY_OFF, value);
}

void MachineBackend::setSocketAutoEnabled(int value)
{
    qDebug() << metaObject()->className() << __func__  << thread();
    m_socketSchedulerAutoSet->setEnabled(value);

    pData->setSocketAutoEnabled(value);

    QSettings settings;
    settings.setValue(SKEY_SCHED_SOCKET_ENABLE, value);
}

void MachineBackend::setSocketAutoTime(int value)
{
    qDebug() << metaObject()->className() << __func__  << thread();
    qDebug() << __func__  << thread();
    m_socketSchedulerAutoSet->setTime(value);

    pData->setSocketAutoTime(value);

    QSettings settings;
    settings.setValue(SKEY_SCHED_SOCKET_TIME, value);
}

void MachineBackend::setSocketAutoDayRepeat(int value)
{
    qDebug() << metaObject()->className() << __func__  << thread();
    m_socketSchedulerAutoSet->setDayRepeat(value);

    pData->setSocketAutoDayRepeat(value);

    QSettings settings;
    settings.setValue(SKEY_SCHED_SOCKET_REPEAT, value);
}

void MachineBackend::setSocketAutoWeeklyDay(int value)
{
    qDebug() << metaObject()->className() << __func__  << thread();
    m_socketSchedulerAutoSet->setWeeklyDay(value);

    pData->setSocketAutoWeeklyDay(value);

    QSettings settings;
    settings.setValue(SKEY_SCHED_SOCKET_REPEAT_DAY, value);
}

void MachineBackend::setSocketAutoEnabledOff(int value)
{
    qDebug() << metaObject()->className() << __func__  << thread();
    m_socketSchedulerAutoSetOff->setEnabled(value);

    pData->setSocketAutoEnabledOff(value);

    QSettings settings;
    settings.setValue(SKEY_SCHED_SOCKET_ENABLE_OFF, value);
}

void MachineBackend::setSocketAutoTimeOff(int value)
{
    qDebug() << metaObject()->className() << __func__  << thread();
    m_socketSchedulerAutoSetOff->setTime(value);

    pData->setSocketAutoTimeOff(value);

    QSettings settings;
    settings.setValue(SKEY_SCHED_SOCKET_TIME_OFF, value);
}

void MachineBackend::setSocketAutoDayRepeatOff(int value)
{
    qDebug() << metaObject()->className() << __func__  << thread();
    m_socketSchedulerAutoSetOff->setDayRepeat(value);

    pData->setSocketAutoDayRepeatOff(value);

    QSettings settings;
    settings.setValue(SKEY_SCHED_SOCKET_REPEAT_OFF, value);
}

void MachineBackend::setSocketAutoWeeklyDayOff(int value)
{
    qDebug() << metaObject()->className() << __func__  << thread();
    m_socketSchedulerAutoSetOff->setWeeklyDay(value);

    pData->setSocketAutoWeeklyDayOff(value);

    QSettings settings;
    settings.setValue(SKEY_SCHED_SOCKET_REPEAT_DAY_OFF, value);
}

/// FAN ON SCHEDULER
void MachineBackend::setFanAutoEnabled(int fanAutoSetEnabled)
{
    qDebug() << __func__  << thread();
    m_fanSchedulerAutoSet->setEnabled(fanAutoSetEnabled);

    pData->setFanAutoEnabled(fanAutoSetEnabled);

    QSettings settings;
    settings.setValue(SKEY_SCHED_FAN_ENABLE, fanAutoSetEnabled);
}

void MachineBackend::setFanAutoTime(int fanAutoSetTime)
{
    qDebug() << __func__  << thread();
    m_fanSchedulerAutoSet->setTime(fanAutoSetTime);

    pData->setFanAutoTime(fanAutoSetTime);

    QSettings settings;
    settings.setValue(SKEY_SCHED_FAN_TIME, fanAutoSetTime);
}

void MachineBackend::setFanAutoDayRepeat(int fanAutoSetDayRepeat)
{
    qDebug() << __func__  << thread();
    m_fanSchedulerAutoSet->setDayRepeat(fanAutoSetDayRepeat);

    pData->setFanAutoDayRepeat(fanAutoSetDayRepeat);

    QSettings settings;
    settings.setValue(SKEY_SCHED_FAN_REPEAT, fanAutoSetDayRepeat);
}

void MachineBackend::setFanAutoWeeklyDay(int fanAutoSetWeeklyDay)
{
    qDebug() << __func__  << thread();
    m_fanSchedulerAutoSet->setWeeklyDay(fanAutoSetWeeklyDay);

    pData->setFanAutoWeeklyDay(fanAutoSetWeeklyDay);

    QSettings settings;
    settings.setValue(SKEY_SCHED_FAN_REPEAT_DAY, fanAutoSetWeeklyDay);
}
/// FAN OFF SCHEDULER
void MachineBackend::setFanAutoEnabledOff(int fanAutoSetEnabledOff)
{
    qDebug() << __func__  << thread();
    m_fanSchedulerAutoSetOff->setEnabled(fanAutoSetEnabledOff);

    pData->setFanAutoEnabledOff(fanAutoSetEnabledOff);

    QSettings settings;
    settings.setValue(SKEY_SCHED_FAN_ENABLE_OFF, fanAutoSetEnabledOff);
}

void MachineBackend::setFanAutoTimeOff(int fanAutoSetTimeOff)
{
    qDebug() << __func__  << thread();
    m_fanSchedulerAutoSetOff->setTime(fanAutoSetTimeOff);

    pData->setFanAutoTimeOff(fanAutoSetTimeOff);

    QSettings settings;
    settings.setValue(SKEY_SCHED_FAN_TIME_OFF, fanAutoSetTimeOff);
}

void MachineBackend::setFanAutoDayRepeatOff(int fanAutoSetDayRepeatOff)
{
    qDebug() << __func__  << thread();
    m_fanSchedulerAutoSetOff->setDayRepeat(fanAutoSetDayRepeatOff);

    pData->setFanAutoDayRepeatOff(fanAutoSetDayRepeatOff);

    QSettings settings;
    settings.setValue(SKEY_SCHED_FAN_REPEAT_OFF, fanAutoSetDayRepeatOff);
}

void MachineBackend::setFanAutoWeeklyDayOff(int fanAutoSetWeeklyDayOff)
{
    qDebug() << __func__  << thread();
    m_fanSchedulerAutoSetOff->setWeeklyDay(fanAutoSetWeeklyDayOff);

    pData->setFanAutoWeeklyDayOff(fanAutoSetWeeklyDayOff);

    QSettings settings;
    settings.setValue(SKEY_SCHED_FAN_REPEAT_DAY_OFF, fanAutoSetWeeklyDayOff);
}


void MachineBackend::setEscoLockServiceEnable(int escoLockServiceEnable)
{
    qDebug() << metaObject()->className() << __func__  << thread();

    pData->setEscoLockServiceEnable(escoLockServiceEnable);

    QSettings settings;
    settings.setValue(SKEY_ELS_ENABLE, escoLockServiceEnable);
}

void MachineBackend::setCabinetDisplayName(const QString &cabinetDisplayName)
{
    qDebug() << metaObject()->className() << __func__  << thread();

    QString nameNormalization = QString(cabinetDisplayName).replace(" ", "#~#");
    QString idStrCabDisplayName = "esco-centurion-" + nameNormalization;

#ifdef __linux__
    QtConcurrent::run([&, idStrCabDisplayName]{
        QProcess::execute("hostnamectl", QStringList() << "set-hostname" << idStrCabDisplayName);
    });
#endif

    pData->setCabinetDisplayName(cabinetDisplayName);

    QSettings settings;
    settings.setValue(SKEY_CAB_DISPLAY_NAME, nameNormalization);
}

void MachineBackend::setFanPIN(const QString &fanPIN)
{
    qDebug() << metaObject()->className() << __func__  << thread();

    QString fanPinEncode = QCryptographicHash::hash(fanPIN.toLocal8Bit(), QCryptographicHash::Md5).toHex();

    pData->setFanPIN(fanPinEncode);

    QSettings settings;
    settings.setValue(SKEY_FAN_PIN, fanPinEncode);
}

void MachineBackend::setFanUsageMeter(int minutes)
{
    qDebug() << metaObject()->className() << __func__  << thread();

    pData->setFanUsageMeter(minutes);

    QSettings settings;
    settings.setValue(SKEY_FAN_METER, minutes);

    //        qDebug() << __func__ << "getFanInflowUsageMeter"  << count;
    /// MODBUS
    _setModbusRegHoldingValue(modbusRegisterAddress.IfaFanUsage.addr, static_cast<ushort>(minutes));
}

void MachineBackend::setUvUsageMeter(int minutes)
{
    qDebug() << metaObject()->className() << __func__  << thread();

    int minutesPercentLeft = __getPercentFrom(minutes, SDEF_UV_MAXIMUM_TIME_LIFE);

    /// event if in % value is zero but the minutes more then 0 minutes, then set % to 1
    if (minutesPercentLeft == 0 && minutes > 0) minutesPercentLeft = 1;

    //update to global observable variable
    pData->setUvLifeMinutes(minutes);
    pData->setUvLifePercent(static_cast<short>(minutesPercentLeft));

    //save to sattings
    QSettings settings;
    settings.setValue(SKEY_UV_METER, minutes);
    /// MODBUS
    _setModbusRegHoldingValue(modbusRegisterAddress.UvLifeLeft.addr, static_cast<ushort>(minutesPercentLeft));
}

void MachineBackend::setFilterUsageMeter(int percent)
{
    qDebug() << metaObject()->className() << __func__ << percent << thread();

    if(percent > 100){
        percent = 100;
    }
    if(percent < 0){
        percent = 0;
    }

    int maxMinsUsage = pData->getFilterLifeMaximumBlowerUsageMode();
    int maxRpmUsage = pData->getFilterLifeMaximumBlowerRpmMode();
    int minRpmUsage = pData->getFilterLifeMinimumBlowerRpmMode();
    int rangeRpm = maxRpmUsage - minRpmUsage;

    int minutesLeft = qRound((double)maxMinsUsage - (((100.0-(double)percent)/100.0)*(double)maxMinsUsage));
    int currRpmNom = maxRpmUsage - qRound(__map(percent, 0, 100, minRpmUsage, maxRpmUsage));
    currRpmNom = minRpmUsage + qRound(static_cast<double>(100-percent)/100.0 * static_cast<double>(rangeRpm));

    qDebug() << "minutesLeft" << minutesLeft;
    qDebug() << "currRpmNom" << currRpmNom;

    /// event if in % value is zero but the minutes more then 0 minutes, then set % to 1
    if (percent == 0 && (minutesLeft > 0 || (currRpmNom < maxRpmUsage))) percent = 1;

    //update to global observable variable
    pData->setFilterLifeMinutes(minutesLeft);
    pData->setFilterLifeRpm(currRpmNom);
    pData->setFilterLifePercent(static_cast<short>(percent));

    // Reset the stable counter
    m_fanPrimaryRpmMovAvgCountStable = 0;

    //save to sattings
    QSettings settings;
    settings.setValue(SKEY_FILTER_METER_MIN, minutesLeft);
    settings.setValue(SKEY_FILTER_METER_RPM, currRpmNom);
}

void MachineBackend::setFilterLifeCalculationMode(int value)
{
    QSettings settings;
    settings.setValue(SKEY_FILTER_METER_MODE, value);
    pData->setFilterLifeCalculationMode(value);
}

void MachineBackend::setFilterLifeMinimumBlowerUsageMode(int value)
{
    QSettings settings;
    settings.setValue(SKEY_FILTER_METER_MIN_TIME, value*60);
    pData->setFilterLifeMinimumBlowerUsageMode(value*60);
    setFilterUsageMeter(pData->getFilterLifePercent());
}

void MachineBackend::setFilterLifeMaximumBlowerUsageMode(int value)
{
    QSettings settings;
    settings.setValue(SKEY_FILTER_METER_MAX_TIME, value*60);
    pData->setFilterLifeMaximumBlowerUsageMode(value*60);
    setFilterUsageMeter(pData->getFilterLifePercent());
}

void MachineBackend::setFilterLifeMinimumBlowerRpmMode(int value)
{
    QSettings settings;
    settings.setValue(SKEY_FILTER_METER_MIN_RPM, value);
    pData->setFilterLifeMinimumBlowerRpmMode(value);
    setFilterUsageMeter(pData->getFilterLifePercent());
}

void MachineBackend::setFilterLifeMaximumBlowerRpmMode(int value)
{
    QSettings settings;
    settings.setValue(SKEY_FILTER_METER_MAX_RPM, value);
    pData->setFilterLifeMaximumBlowerRpmMode(value);
    setFilterUsageMeter(pData->getFilterLifePercent());
}

void MachineBackend::setSashCycleMeter(int sashCycleMeter)
{
    qDebug() << metaObject()->className() << __func__  << thread();

    int prevSashCycle = pData->getSashCycleMeter()/10;
    if(prevSashCycle >= 16000 && sashCycleMeter < 16000){
        m_pHydraulicMotorize->setInterlockDown(0);
        m_pHydraulicMotorize->setInterlockUp(0);
        if(!isAlarmNormal(pData->getSashCycleMotorLockedAlarm())){
            pData->setSashCycleMotorLockedAlarm(MachineEnums::ALARM_NORMAL_STATE);
            _insertAlarmLog(ALARM_LOG_CODE::ALC_SASH_MOTOR_OK, _tr(ALARM_LOG_TEXT_SASH_MOTOR_OK));
        }
    }//

    pData->setSashCycleMeter(sashCycleMeter);

    QSettings settings;
    settings.setValue(SKEY_SASH_CYCLE_METER, sashCycleMeter);
    /// MODBUS
    _setModbusRegHoldingValue(modbusRegisterAddress.SashCycle.addr, static_cast<ushort>(sashCycleMeter));
}

void MachineBackend::setEnvTempHighestLimit(int envTempHighestLimit)
{
    qDebug() << metaObject()->className() << __func__  << thread();

    pData->setEnvTempHighestLimit(envTempHighestLimit);

    QSettings settings;
    settings.setValue(SKEY_ENV_TEMP_HIGH_LIMIT, envTempHighestLimit);

    /// force update temperature value and temperature strf
    _onTemperatureActualChanged(pData->getTemperatureCelcius());
}

void MachineBackend::setEnvTempLowestLimit(int envTempLowestLimit)
{
    qDebug() << metaObject()->className() << __func__  << thread();

    pData->setEnvTempLowestLimit(envTempLowestLimit);

    QSettings settings;
    settings.setValue(SKEY_ENV_TEMP_LOW_LIMIT, envTempLowestLimit);

    /// force update temperature value and temperature strf
    _onTemperatureActualChanged(pData->getTemperatureCelcius());
}

void MachineBackend::setParticleCounterSensorInstalled(bool particleCounterSensorInstalled)
{
    qDebug() << metaObject()->className() << __func__  << thread();

    pData->setParticleCounterSensorInstalled(particleCounterSensorInstalled);

    QSettings settings;
    settings.setValue(SKEY_PARTICLE_COUNTER_INST, particleCounterSensorInstalled ? 1 : 0);
}

void MachineBackend::setWatchdogResetterState(bool state)
{
    qDebug() << metaObject()->className() << __func__  << thread();

    if(state)  m_timerEventForRTCWatchdogReset->start();
    else m_timerEventForRTCWatchdogReset->stop();
}

void MachineBackend::setShippingModeEnable(bool shippingModeEnable)
{
    qDebug() << metaObject()->className() << __func__  << thread();

    QSettings setting;
    setting.setValue(SKEY_SHIPPING_MOD_ENABLE, shippingModeEnable? 1 : 0);

    /// clear the necesarry data
    if(shippingModeEnable) {
        /// clear all the database
        m_threadForAlarmLog->quit();
        m_threadForAlarmLog->wait();
        m_threadForEventLog->quit();
        m_threadForEventLog->wait();
        m_threadForDatalog->quit();
        m_threadForDatalog->wait();
        m_threadForResourceMonitorLog->quit();
        m_threadForResourceMonitorLog->wait();

        /// DATA LOG
        {
            m_pDataLogSql.reset(new DataLogSql);
            m_pDataLogSql->init("m_pDataLogSqlqueryDelete");
            m_pDataLogSql->queryDelete();
        }

        /// ALARM LOG
        {
            m_pAlarmLogSql.reset(new AlarmLogSql);
            m_pAlarmLogSql->init("m_pAlarmLogSqlqueryDelete");
            m_pAlarmLogSql->queryDelete();
        }

        /// EVENT LOG
        {
            m_pEventLogSql.reset(new EventLogSql);
            m_pEventLogSql->init("m_pEventLogSqlqueryDelete");
            m_pEventLogSql->queryDelete();
        }

        /// RESOURCE MONITOR
        {
            m_pResourceMonitorLogSql.reset(new ResourceMonitorLogSql);
            m_pResourceMonitorLogSql->init("m_pResourceMonitorLogSqlqueryDelete");
            m_pResourceMonitorLogSql->queryDelete();
        }

        /// reset boys
        setting.setValue(SKEY_FILTER_METER_MIN, pData->getFilterLifeMaximumBlowerUsageMode());
        setting.setValue(SKEY_FILTER_METER_RPM, pData->getFilterLifeMinimumBlowerRpmMode());

        setting.setValue(SKEY_FAN_METER, 0);
        setting.setValue(SKEY_SASH_CYCLE_METER, 0);
        setting.setValue(SKEY_UV_METER, SDEF_UV_MAXIMUM_TIME_LIFE);

        /// Disable Software SVN Check for Update
        setting.setValue(SKEY_SBC_SVN_UPDATE_EN, false);

        /// Clear User Login History
        setting.setValue(SKEY_USER_LAST_LOGIN, QJsonArray());

        setSpecialSettingForCustomer(pData->getCertificationParametersStr(MachineEnums::CertifParamStr_customer));
    }

    pData->setShippingModeEnable(shippingModeEnable);
}

void MachineBackend::setCurrentSystemAsKnown(bool value)
{
    if(value){
        QString serialNumber = pData->getSbcCurrentSerialNumber();
        QStringList sysInfo = pData->getSbcCurrentSystemInformation();

        _setSbcSerialNumber(serialNumber);
        pData->setSbcSystemInformation(sysInfo);
        pData->setSbcCurrentSerialNumberKnown(true);
    }else return;
}

void MachineBackend::readSbcCurrentFullMacAddress()
{
    qDebug() << metaObject()->className() << __func__  << thread();
    pData->setSbcCurrentFullMacAddress(_readMacAddress());
    qDebug() << pData->getSbcCurrentFullMacAddress();
}

void MachineBackend::setAlarmPreventMaintStateEnable(ushort pmCode, bool value)
{
    ushort alarmEn = pData->getAlarmPreventMaintStateEnable();
    if(value){
        alarmEn |= pmCode;
    }else{
        alarmEn &= ~pmCode;
    }

    QSettings setting;
    setting.setValue(SKEY_PM_ALARM_EN, alarmEn);
    pData->setAlarmPreventMaintStateEnable(alarmEn);

    _refreshAlarmPreventMaint();
}

void MachineBackend::setAlarmPreventMaintStateAck(ushort pmCode, bool value, bool snooze)
{
    qDebug() << metaObject()->className() << __func__  << pmCode << value << snooze << thread();

    QDateTime nowDateTime = QDateTime().currentDateTime();
    QDateTime dueDateTime;
    QString curDateTimeStr = nowDateTime.toString("dd-MM-yyyy hh:mm:ss");
    QString dueDateTimeStr;

    QSettings setting;

    ushort alarmAck = pData->getAlarmPreventMaintStateAck();

    if(value){
        alarmAck |= pmCode;
    }else{
        alarmAck &= ~pmCode;
    }

    pData->setAlarmPreventMaintStateAck(alarmAck);

    switch(pmCode){
    case MachineEnums::PM_DAILY_CODE:
        if(value && !snooze){
            dueDateTime = QDateTime().fromString(curDateTimeStr, "dd-MM-yyyy hh:mm:ss").addDays(1);
            dueDateTimeStr = dueDateTime.toString("dd-MM-yyyy hh:mm:ss");
            pData->setDailyPreventMaintAckDueDate(dueDateTimeStr);
            setting.setValue(SKEY_PM_LAST_ACK_DAILY, curDateTimeStr);
            pData->setDailyPreventMaintLastAckDate(curDateTimeStr);
        }
        break;
    case MachineEnums::PM_WEEKLY_CODE:
        if(value && !snooze){
            dueDateTime = QDateTime().fromString(curDateTimeStr, "dd-MM-yyyy hh:mm:ss").addDays(7);
            dueDateTimeStr = dueDateTime.toString("dd-MM-yyyy hh:mm:ss");
            pData->setWeeklyPreventMaintAckDueDate(dueDateTimeStr);
            setting.setValue(SKEY_PM_LAST_ACK_WEEKLY, curDateTimeStr);
            pData->setWeeklyPreventMaintLastAckDate(curDateTimeStr);
        }
        break;
    case MachineEnums::PM_MONTHLY_CODE:
        if(value && !snooze){
            dueDateTime = QDateTime().fromString(curDateTimeStr, "dd-MM-yyyy hh:mm:ss").addMonths(1);
            dueDateTimeStr = dueDateTime.toString("dd-MM-yyyy hh:mm:ss");
            pData->setMonthlyPreventMaintAckDueDate(dueDateTimeStr);
            setting.setValue(SKEY_PM_LAST_ACK_MONTHLY, curDateTimeStr);
            pData->setMonthlyPreventMaintLastAckDate(curDateTimeStr);
        }
        break;
    case MachineEnums::PM_QUARTERLY_CODE:
        if(value && !snooze){
            dueDateTime = QDateTime().fromString(curDateTimeStr, "dd-MM-yyyy hh:mm:ss").addMonths(3);
            dueDateTimeStr = dueDateTime.toString("dd-MM-yyyy hh:mm:ss");
            pData->setQuarterlyPreventMaintAckDueDate(dueDateTimeStr);
            setting.setValue(SKEY_PM_LAST_ACK_QUARTERLY, curDateTimeStr);
            pData->setQuarterlyPreventMaintLastAckDate(curDateTimeStr);
        }
        break;
    case MachineEnums::PM_ANNUALLY_CODE:
        if(value && !snooze){
            dueDateTime = QDateTime().fromString(curDateTimeStr, "dd-MM-yyyy hh:mm:ss").addYears(1);
            dueDateTimeStr = dueDateTime.toString("dd-MM-yyyy hh:mm:ss");
            pData->setAnnuallyPreventMaintAckDueDate(dueDateTimeStr);
            setting.setValue(SKEY_PM_LAST_ACK_ANNUALLY, curDateTimeStr);
            pData->setAnnuallyPreventMaintLastAckDate(curDateTimeStr);
        }
        break;
    case MachineEnums::PM_BIENNIALLY_CODE:
        if(value && !snooze){
            dueDateTime = QDateTime().fromString(curDateTimeStr, "dd-MM-yyyy hh:mm:ss").addYears(2);
            dueDateTimeStr = dueDateTime.toString("dd-MM-yyyy hh:mm:ss");
            pData->setBienniallyPreventMaintAckDueDate(dueDateTimeStr);
            setting.setValue(SKEY_PM_LAST_ACK_BIENNIALLY, curDateTimeStr);
            pData->setBienniallyPreventMaintLastAckDate(curDateTimeStr);
        }
        break;
    case MachineEnums::PM_QUINQUENNIALLY_CODE:
        if(value && !snooze){
            dueDateTime = QDateTime().fromString(curDateTimeStr, "dd-MM-yyyy hh:mm:ss").addYears(5);
            dueDateTimeStr = dueDateTime.toString("dd-MM-yyyy hh:mm:ss");
            pData->setQuinquenniallyPreventMaintAckDueDate(dueDateTimeStr);
            setting.setValue(SKEY_PM_LAST_ACK_QUINQUENNIALLY, curDateTimeStr);
            pData->setQuinquenniallyPreventMaintLastAckDate(curDateTimeStr);
        }
        break;
    case MachineEnums::PM_CANOPY_CODE:
        if(value && !snooze){
            dueDateTime = QDateTime().fromString(curDateTimeStr, "dd-MM-yyyy hh:mm:ss").addMonths(1);
            dueDateTimeStr = dueDateTime.toString("dd-MM-yyyy hh:mm:ss");
            pData->setCanopyPreventMaintAckDueDate(dueDateTimeStr);
            setting.setValue(SKEY_PM_LAST_ACK_CANOPY, curDateTimeStr);
            pData->setCanopyPreventMaintLastAckDate(curDateTimeStr);
        }
        break;
    default: break;
    }
}

void MachineBackend::resetPreventMaintAckDate(ushort pmCode)
{
    QSettings setting;
    QString resetDateTime = "01-01-2000 00:00:00";
    QDateTime nowDateTime = QDateTime().fromString(resetDateTime, "dd-MM-yyyy hh:mm:ss");
    QDateTime dueDateTime;
    QString dueDateTimeStr;

    bool pmCodeValid = true;

    switch(pmCode){
    case MachineEnums::PM_DAILY_CODE:
        dueDateTime = nowDateTime.addDays(1);
        dueDateTimeStr = dueDateTime.toString("dd-MM-yyyy hh:mm:ss");
        pData->setDailyPreventMaintAckDueDate(dueDateTimeStr);
        setting.setValue(SKEY_PM_LAST_ACK_DAILY, resetDateTime);
        pData->setDailyPreventMaintLastAckDate(resetDateTime);
        break;
    case MachineEnums::PM_WEEKLY_CODE:
        dueDateTime = nowDateTime.addDays(7);
        dueDateTimeStr = dueDateTime.toString("dd-MM-yyyy hh:mm:ss");
        pData->setWeeklyPreventMaintAckDueDate(dueDateTimeStr);
        setting.setValue(SKEY_PM_LAST_ACK_WEEKLY, resetDateTime);
        pData->setWeeklyPreventMaintLastAckDate(resetDateTime);
        break;
    case MachineEnums::PM_MONTHLY_CODE:
        dueDateTime = nowDateTime.addMonths(1);
        dueDateTimeStr = dueDateTime.toString("dd-MM-yyyy hh:mm:ss");
        pData->setMonthlyPreventMaintAckDueDate(dueDateTimeStr);
        setting.setValue(SKEY_PM_LAST_ACK_MONTHLY, resetDateTime);
        pData->setMonthlyPreventMaintLastAckDate(resetDateTime);
        break;
    case MachineEnums::PM_QUARTERLY_CODE:
        dueDateTime = nowDateTime.addMonths(3);
        dueDateTimeStr = dueDateTime.toString("dd-MM-yyyy hh:mm:ss");
        pData->setQuarterlyPreventMaintAckDueDate(dueDateTimeStr);
        setting.setValue(SKEY_PM_LAST_ACK_QUARTERLY, resetDateTime);
        pData->setQuarterlyPreventMaintLastAckDate(resetDateTime);
        break;
    case MachineEnums::PM_ANNUALLY_CODE:
        dueDateTime = nowDateTime.addYears(1);
        dueDateTimeStr = dueDateTime.toString("dd-MM-yyyy hh:mm:ss");
        pData->setAnnuallyPreventMaintAckDueDate(dueDateTimeStr);
        setting.setValue(SKEY_PM_LAST_ACK_ANNUALLY, resetDateTime);
        pData->setAnnuallyPreventMaintLastAckDate(resetDateTime);
        break;
    case MachineEnums::PM_BIENNIALLY_CODE:
        dueDateTime = nowDateTime.addYears(2);
        dueDateTimeStr = dueDateTime.toString("dd-MM-yyyy hh:mm:ss");
        pData->setBienniallyPreventMaintAckDueDate(dueDateTimeStr);
        setting.setValue(SKEY_PM_LAST_ACK_BIENNIALLY, resetDateTime);
        pData->setBienniallyPreventMaintLastAckDate(resetDateTime);
        break;
    case MachineEnums::PM_QUINQUENNIALLY_CODE:
        dueDateTime = nowDateTime.addYears(5);
        dueDateTimeStr = dueDateTime.toString("dd-MM-yyyy hh:mm:ss");
        pData->setQuinquenniallyPreventMaintAckDueDate(dueDateTimeStr);
        setting.setValue(SKEY_PM_LAST_ACK_QUINQUENNIALLY, resetDateTime);
        pData->setQuinquenniallyPreventMaintLastAckDate(resetDateTime);
        break;
    case MachineEnums::PM_CANOPY_CODE:
        dueDateTime = nowDateTime.addMonths(1);
        dueDateTimeStr = dueDateTime.toString("dd-MM-yyyy hh:mm:ss");
        pData->setCanopyPreventMaintAckDueDate(dueDateTimeStr);
        setting.setValue(SKEY_PM_LAST_ACK_CANOPY, resetDateTime);
        pData->setCanopyPreventMaintLastAckDate(resetDateTime);
        break;
    default:
        pmCodeValid = false;
        break;
    }
    _refreshAlarmPreventMaint();

    if(pmCodeValid){
        ushort alarmAck = pData->getAlarmPreventMaintStateAck();
        alarmAck &= ~pmCode;
        pData->setAlarmPreventMaintStateAck(alarmAck);
        emit pData->preventMaintDateHasBeenReset();
    }
}//

void MachineBackend::setAlarmPreventMaintStateRemindBefore(ushort pmCode, int value)
{
    QSettings setting;
    bool pmCodeValid = true;

    switch(pmCode){
    case MachineEnums::PM_DAILY_CODE:
        setting.setValue(SKEY_PM_REMIND_BEFORE_DAILY, value);
        pData->setDailyPreventMaintRemindBefore(value);
        break;
    case MachineEnums::PM_WEEKLY_CODE:
        setting.setValue(SKEY_PM_REMIND_BEFORE_WEEKLY, value);
        pData->setWeeklyPreventMaintRemindBefore(value);
        break;
    case MachineEnums::PM_MONTHLY_CODE:
        setting.setValue(SKEY_PM_REMIND_BEFORE_MONTHLY, value);
        pData->setMonthlyPreventMaintRemindBefore(value);
        break;
    case MachineEnums::PM_QUARTERLY_CODE:
        setting.setValue(SKEY_PM_REMIND_BEFORE_QUARTERLY, value);
        pData->setQuarterlyPreventMaintRemindBefore(value);
        break;
    case MachineEnums::PM_ANNUALLY_CODE:
        setting.setValue(SKEY_PM_REMIND_BEFORE_ANNUALLY, value);
        pData->setAnnuallyPreventMaintRemindBefore(value);
        break;
    case MachineEnums::PM_BIENNIALLY_CODE:
        setting.setValue(SKEY_PM_REMIND_BEFORE_BIENNIALLY, value);
        pData->setBienniallyPreventMaintRemindBefore(value);
        break;
    case MachineEnums::PM_QUINQUENNIALLY_CODE:
        setting.setValue(SKEY_PM_REMIND_BEFORE_QUINQUENNIALLY, value);
        pData->setQuinquenniallyPreventMaintRemindBefore(value);
        break;
    case MachineEnums::PM_CANOPY_CODE:
        setting.setValue(SKEY_PM_REMIND_BEFORE_CANOPY, value);
        pData->setCanopyPreventMaintRemindBefore(value);
        break;
    default:
        pmCodeValid = false;
        break;
    }

    if(pmCodeValid){
        _refreshAlarmPreventMaint();
    }
}

void MachineBackend::_refreshAlarmPreventMaint()
{
    /// Update the active alarm
    QDateTime nowDateTime = QDateTime().currentDateTime();
    QDateTime dueDateTimeDaily = QDateTime().fromString(pData->getDailyPreventMaintAckDueDate(), "dd-MM-yyyy hh:mm:ss");
    QDateTime dueDateTimeWeekly = QDateTime().fromString(pData->getWeeklyPreventMaintAckDueDate(), "dd-MM-yyyy hh:mm:ss");
    QDateTime dueDateTimeMonthly = QDateTime().fromString(pData->getMonthlyPreventMaintAckDueDate(), "dd-MM-yyyy hh:mm:ss");
    QDateTime dueDateTimeQuarterly = QDateTime().fromString(pData->getQuarterlyPreventMaintAckDueDate(), "dd-MM-yyyy hh:mm:ss");
    QDateTime dueDateTimeAnnually = QDateTime().fromString(pData->getAnnuallyPreventMaintAckDueDate(), "dd-MM-yyyy hh:mm:ss");
    QDateTime dueDateTimeBiennially = QDateTime().fromString(pData->getBienniallyPreventMaintAckDueDate(), "dd-MM-yyyy hh:mm:ss");
    QDateTime dueDateTimeQuinquennially = QDateTime().fromString(pData->getQuinquenniallyPreventMaintAckDueDate(), "dd-MM-yyyy hh:mm:ss");
    QDateTime dueDateTimeCanopy = QDateTime().fromString(pData->getCanopyPreventMaintAckDueDate(), "dd-MM-yyyy hh:mm:ss");

    int remindBeforeDaily = pData->getDailyPreventMaintRemindBefore();
    int remindBeforeWeekly = pData->getWeeklyPreventMaintRemindBefore();
    int remindBeforeMonthly = pData->getMonthlyPreventMaintRemindBefore();
    int remindBeforeQuarterly = pData->getQuarterlyPreventMaintRemindBefore();
    int remindBeforeAnnually = pData->getAnnuallyPreventMaintRemindBefore();
    int remindBeforeBiennially = pData->getBienniallyPreventMaintRemindBefore();
    int remindBeforeQuinquennially = pData->getQuinquenniallyPreventMaintRemindBefore();
    int remindBeforeCanopy = pData->getCanopyPreventMaintRemindBefore();

    ushort alarmEn = pData->getAlarmPreventMaintStateEnable();
    ushort alarmPm = 0;
    qint64 dayLeft;
    if(alarmEn & MachineEnums::PM_DAILY_CODE){
        dayLeft = nowDateTime.secsTo(dueDateTimeDaily);
        if(dayLeft <= remindBeforeDaily) alarmPm |= MachineEnums::PM_DAILY_CODE; /// Activate the alarm when time left less than 6 hours
        qDebug() << "secsLeft:" << dayLeft;
    }
    if(alarmEn & MachineEnums::PM_WEEKLY_CODE){
        dayLeft = nowDateTime.daysTo(dueDateTimeWeekly);
        if(dayLeft <= remindBeforeWeekly) alarmPm |= MachineEnums::PM_WEEKLY_CODE;
        qDebug() << "dayLeft:" << dayLeft;
    }
    if(alarmEn & MachineEnums::PM_MONTHLY_CODE){
        dayLeft = nowDateTime.daysTo(dueDateTimeMonthly);
        if(dayLeft < remindBeforeMonthly) alarmPm |= MachineEnums::PM_MONTHLY_CODE;
        qDebug() << "dayLeft:" << dayLeft;
    }
    if(alarmEn & MachineEnums::PM_QUARTERLY_CODE){
        dayLeft = nowDateTime.daysTo(dueDateTimeQuarterly);
        if(dayLeft < remindBeforeQuarterly) alarmPm |= MachineEnums::PM_QUARTERLY_CODE;
        qDebug() << "dayLeft:" << dayLeft;
    }
    if(alarmEn & MachineEnums::PM_ANNUALLY_CODE){
        dayLeft = nowDateTime.daysTo(dueDateTimeAnnually);
        if(dayLeft < remindBeforeAnnually) alarmPm |= MachineEnums::PM_ANNUALLY_CODE;
        qDebug() << "dayLeft:" << dayLeft;
    }
    if(alarmEn & MachineEnums::PM_BIENNIALLY_CODE){
        dayLeft = nowDateTime.daysTo(dueDateTimeBiennially);
        if(dayLeft < remindBeforeBiennially) alarmPm |= MachineEnums::PM_BIENNIALLY_CODE;
        qDebug() << "dayLeft:" << dayLeft;
    }
    if(alarmEn & MachineEnums::PM_QUINQUENNIALLY_CODE){
        dayLeft = nowDateTime.daysTo(dueDateTimeQuinquennially);
        if(dayLeft < remindBeforeQuinquennially) alarmPm |= MachineEnums::PM_QUINQUENNIALLY_CODE;
        qDebug() << "dayLeft:" << dayLeft;
    }
    if(alarmEn & MachineEnums::PM_CANOPY_CODE){
        dayLeft = nowDateTime.daysTo(dueDateTimeCanopy);
        if(dayLeft < remindBeforeCanopy) alarmPm |= MachineEnums::PM_CANOPY_CODE;
        qDebug() << "dayLeft:" << dayLeft;
    }

    qDebug() << "Alarm PM:" << alarmPm;
    pData->setAlarmPreventMaintState(alarmPm);

    ////// alarmPrevMaintActive
    bool alarmStatus = false;
    ushort stateEn = pData->getAlarmPreventMaintStateEnable();
    ushort stateAck = pData->getAlarmPreventMaintStateAck();
    QJsonObject checklist = pData->getMaintenanceChecklist();
    checklist.value("daily").toArray().size();
    const QVector<bool> notEmpty = {
        (checklist.value("daily").toArray().size() > 0),
        (checklist.value("weekly").toArray().size() > 0),
        (checklist.value("monthly").toArray().size() > 0),
        (checklist.value("quarterly").toArray().size() > 0),
        (checklist.value("annually").toArray().size() > 0),
        (checklist.value("biennially").toArray().size() > 0),
        (checklist.value("quinquennially").toArray().size() > 0),
        (checklist.value("canopy").toArray().size() > 0)
    };//
    ushort state = pData->getAlarmPreventMaintState();
    const QVector<ushort> pmCode = {
        MachineEnums::PM_DAILY_CODE,
        MachineEnums::PM_WEEKLY_CODE,
        MachineEnums::PM_MONTHLY_CODE,
        MachineEnums::PM_QUARTERLY_CODE,
        MachineEnums::PM_ANNUALLY_CODE,
        MachineEnums::PM_BIENNIALLY_CODE,
        MachineEnums::PM_QUINQUENNIALLY_CODE,
        MachineEnums::PM_CANOPY_CODE
    };

    for(ushort i=0; i<pmCode.length(); i++){
        if((stateEn & pmCode[i]) && (state & pmCode[i]) && !(stateAck & pmCode[i]) && (notEmpty[i])){
            //console.debug(i)
            pData->setAlarmPreventMaintActiveCode(pmCode[i]);
            alarmStatus = true;
            break;
        }
    }
    //console.debug("alarmStatus:", alarmStatus)
    pData->setAlarmPreventMaintActive(alarmStatus);
}//

void MachineBackend::setEth0ConName(const QString &value)
{
    qDebug() << metaObject()->className() << __func__ << value << thread();

    QSettings settings;
    settings.setValue(SKEY_ETH_CON_NAME + QString("0"), value);
    pData->setEth0ConName(value);
}

void MachineBackend::setEth0Ipv4Address(const QString &value)
{
    qDebug() << metaObject()->className() << __func__ << value << thread() ;

    QSettings settings;
    settings.setValue(SKEY_ETH_CON_IPv4 + QString("0"), value);
    pData->setEth0Ipv4Address(value);
}

void MachineBackend::setEth0ConEnabled(bool value)
{
    qDebug() << metaObject()->className() << __func__ << value << thread() ;

    QSettings settings;
    settings.setValue(SKEY_ETH_CON_ENABLE + QString("0"), value);
    pData->setEth0ConEnabled(value);
#ifdef __linux__
    if(!value){
        QProcess qprocess;
        QString command = QString("nmcli connection delete id %1").arg(pData->getEth0ConName());
        qWarning() << command;
        qprocess.start(command);
        qprocess.waitForFinished();
        if (qprocess.exitCode()) {
            qWarning() << "Failed while trying to delete connection" << pData->getEth0ConName();
        }
    }
#endif
}

void MachineBackend::setWiredNetworkHasbeenConfigured(bool value)
{
    pData->setWiredNetworkHasbeenConfigured(value);
}

void MachineBackend::initWiredConnectionStaticIP()
{
    qDebug() << metaObject()->className() << __func__ << thread() ;

    //    QScopedPointer<QSettings> m_settings(new QSettings);
    /// Init Wired Connection Static IP Address

    QString eth0ConName = pData->getEth0ConName();
    QString eth0Ipv4Address = pData->getEth0Ipv4Address();
    bool eth0ConEnabled = pData->getEth0ConEnabled();
    //    QString gateway = QString("%1.%2.%3.1").arg(eth0Ipv4Address.split(".").at(0)).arg(eth0Ipv4Address.split(".").at(1)).arg(eth0Ipv4Address.split(".").at(2));
    //        qWarning() << "gateway:" << gateway;

    if(eth0ConEnabled){
        QProcess qprocess;
        QString gateway = "192.168.2.1";

        if(eth0Ipv4Address.length() >= 4){
            gateway = QString("%1.%2.").arg(eth0Ipv4Address.split(".").at(0), eth0Ipv4Address.split(".").at(1));
            gateway += QString("%3.1").arg(eth0Ipv4Address.split(".").at(2));
            qDebug() << "Gateway:" << gateway;
        }//

        QStringList commandStrList;
        commandStrList.clear();
        commandStrList.append("eth0");
        commandStrList.append(eth0ConName);
        commandStrList.append(QString("%1/24").arg(eth0Ipv4Address));
        commandStrList.append(gateway);
        qWarning() << commandStrList;

        qprocess.start("wiredconinitstatic", commandStrList);
        qprocess.waitForFinished(); /// wait about maximum 30 seconds
        QString output(qprocess.readAllStandardOutput());
        int exitCode = qprocess.exitCode();
        qWarning() << output;
        qWarning() << "Exit Code:" << exitCode;

        /// Check eth0 Metric, it must be greater than 600 (wlan0 default)
        commandStrList.clear();
        commandStrList.append("eth0");
        commandStrList.append(eth0ConName);
        commandStrList.append(eth0Ipv4Address);
        commandStrList.append("800");/// set the metric to 800
        qWarning() << commandStrList;

        qprocess.start("wiredconsetmetric", commandStrList);
        qprocess.waitForFinished(); /// wait about maximum 30 seconds
        output = qprocess.readAllStandardOutput();
        exitCode = qprocess.exitCode();
        qWarning() << output;
        qWarning() << "Exit Code:" << exitCode;
        if(exitCode == 5){
            /// If the metric was successfully set, then need to Reboot the system
            pData->setWiredNetworkHasbeenConfigured(true);
        }
    }
}

void MachineBackend::setSvnUpdateHasBeenApplied()
{
    qDebug() << metaObject()->className() << __FUNCTION__ << thread();
    QSettings settings;
    settings.setValue(SKEY_SBC_SWU_AVAILABLE, false);

    pData->setSvnUpdateAvailable(false);
}

void MachineBackend::setSvnUpdateCheckEnable(bool value)
{
    qDebug() << metaObject()->className() << __FUNCTION__ << thread();
    QSettings settings;
    settings.setValue(SKEY_SBC_SVN_UPDATE_EN, value);

    pData->setSvnUpdateCheckForUpdateEnable(value);
    int period = pData->getSvnUpdateCheckForUpdatePeriod() * 60000;

    QMetaObject::invokeMethod(m_timerEventForCheckSwUpdate.data(), [&, value, period](){
            if(!value){
                if(m_timerEventForCheckSwUpdate->isActive())
                    m_timerEventForCheckSwUpdate->stop();
            }else{
                m_timerEventForCheckSwUpdate->setInterval(period);
                if(!m_timerEventForCheckSwUpdate->isActive())
                    m_timerEventForCheckSwUpdate->start();
            }
        },
        Qt::QueuedConnection);
}

void MachineBackend::setSvnUpdateCheckPeriod(int value)
{
    qDebug() << metaObject()->className() << __FUNCTION__ << thread();

    if(pData->getSvnUpdateCheckForUpdatePeriod() == value)return;

    QSettings settings;
    settings.setValue(SKEY_SBC_SVN_UPDATE_PRD, value);

    pData->setSvnUpdateCheckForUpdatePeriod(value);
    bool enable = pData->getSvnUpdateCheckForUpdateEnable();

    QMetaObject::invokeMethod(m_timerEventForCheckSwUpdate.data(), [&, enable, value](){
            m_timerEventForCheckSwUpdate->setInterval(value * 60000);
            if(!enable){
                if(m_timerEventForCheckSwUpdate->isActive())
                    m_timerEventForCheckSwUpdate->stop();
            }else{
                if(!m_timerEventForCheckSwUpdate->isActive())
                    m_timerEventForCheckSwUpdate->start();
            }
        },
        Qt::QueuedConnection);
}

void MachineBackend::checkSoftwareVersionHistory()
{
    if(m_signedUserLevel == MachineEnums::USER_LEVEL_FACTORY){
        pData->setSvnUpdateHistory(m_pCheckSwUpdate->getSwUpdateHistory(pData->getSvnUpdateCheckForUpdateEnable()));
    }
}

void MachineBackend::setAlarmExperimentTimerIsOver(short value)
{
    qDebug() << metaObject()->className() << __FUNCTION__ << value << thread();
    pData->setAlarmExperimentTimerIsOver(value);

    if(isAlarmActive(value)){
        _insertAlarmLog(ALARM_LOG_CODE::ALC_EXP_TIMER_OVER_ALARM, _tr(ALARM_LOG_TEXT_EXP_TIMER_OVER_OK));
    }//
    else if(isAlarmNormal(value)){
        _insertAlarmLog(ALARM_LOG_CODE::ALC_EXP_TIMER_OVER_OK, _tr(ALARM_LOG_TEXT_EXP_TIMER_OVER_ALARM));
    }//
}//

//void MachineBackend::initReplaceablePartsSettings()
//{
//    qDebug() << metaObject()->className() << __FUNCTION__ << thread();

//    QSettings settings;
//    settings.beginGroup("rplist");

//    for(short i=1; i < MachineEnums::RPList_Total; i++){
//        pData->setRpListLast(i, settings.value(m_rpListSettings[i], "").toString());
//    }

//    settings.endGroup();
//}

void MachineBackend::setReplaceablePartsSettings(short index, const QString &value)
{
    qDebug() << metaObject()->className() << __FUNCTION__ << m_rpListSettings[index] << value << thread();

    QSettings settings;

    settings.beginGroup("rplist");
    settings.setValue(m_rpListSettings[index], value);
    settings.endGroup();

    pData->setRpListLast(index, value);
}

void MachineBackend::setReplaceablePartsSelected(short descRowId)
{
    qDebug() << metaObject()->className() << __FUNCTION__ <<  descRowId << thread();

    QMetaObject::invokeMethod(m_pReplaceableCompRecord.data(), [&, descRowId](){
        QStringList strList;
        ReplaceableCompRecordSql *sql = m_pReplaceableCompRecord->getPSqlInterface();
        int count;
        bool success = sql->queryCount(&count);
        qDebug() << "Total row:" << count;
        short indexRowId = descRowId-1;//index start from 0
        qDebug() << "indexRowId:" << indexRowId;
        //        short rowId = indexRowId + 1;
        //        qDebug() << "Actual row ID" << rowId;

        if(success){
            success = m_pReplaceableCompRecord->getDataFromTableAtRowId(&strList, indexRowId);
            if(success){
                //qDebug() << strList;
                if(strList.length() != MachineEnums::RPList_Total){
                    qWarning() << "Data length invalid!" << strList.length() << "should be" << MachineEnums::RPList_Total;
                    return;
                }//
                for(short i=1; i < MachineEnums::RPList_Total; i++){
                    //pData->setRpListLast(i, m_settings->value(m_rpListSettings[i], "").toString());
                    //if(i==1) qDebug() << strList.at(i);
                    m_pReplaceableCompRecord->setRpListSelected(i, strList.at(i));
                    //qDebug() << i << pData->getRpListLastAtIndex(i);
                }//
            }//
        }//
    });

    //QJsonDocument doc = value.toJsonDocument();
    //qDebug() << doc;
    //pData->setRpListSelected();
}//

void MachineBackend::setKeyboardStringOnAcceptedEvent(const QString &value)
{
    qDebug() << metaObject()->className() << __FUNCTION__ << value << thread();

    pData->setKeyboardStringOnAcceptedEvent(value);
}

void MachineBackend::insertReplaceableComponentsForm()
{
    qDebug() << metaObject()->className() << __FUNCTION__ << thread();
    //    int currentRowCount = pData->getReplaceableCompRecordCount();
    //    /// This system has limited the datalog count only up to DATALOG_MAX_ROW
    //    if (currentRowCount >= ALARMREPLACEABLECOMPRECORD_MAX_ROW){
    //        return;
    //    }

    //    QDateTime dateTime = QDateTime::currentDateTime();
    //    QString dateTimeText = dateTime.toString("yyyy-MM-dd hh:mm:ss");

    QVariantMap dataMap;
    for(short i=MachineEnums::RPList_UnitModel; i<MachineEnums::RPList_Total; i++){
        if(i == MachineEnums::RPList_UserName){
            dataMap.insert(m_rpListSettings[i], m_signedUsername);
            qDebug() << i << m_rpListSettings[i] << m_signedUsername;
        }
        else if(i == MachineEnums::RPList_UserFullName){
            dataMap.insert(m_rpListSettings[i], m_signedFullname);
            qDebug() << i << m_rpListSettings[i] << m_signedFullname;
        }
        else{
            dataMap.insert(m_rpListSettings[i], pData->getRpListLastAtIndex(i));
            qDebug() << i << m_rpListSettings[i] << pData->getRpListLastAtIndex(i);
        }//
    }//

    /// execute this function in where thread the m_pReplaceableCompRecord live at
    QMetaObject::invokeMethod(m_pReplaceableCompRecord.data(),
        [&,
         dataMap](){
            ReplaceableCompRecordSql *sql = m_pReplaceableCompRecord->getPSqlInterface();
            bool success = sql->queryInsert(dataMap);

            /// check how many data log has stored now
            int count;
            success = sql->queryCount(&count);
            //        qDebug() << "success: " << success ;
            if(success){
                m_pReplaceableCompRecord->emitSetReplaceableCompRecordCount(count);
                //            qDebug() << count << maximumRowCount;
                bool logHasFull = count >= ALARMREPLACEABLECOMPRECORD_MAX_ROW;
                m_pReplaceableCompRecord->emitSetReplaceableCompRecordIsFull(logHasFull);
                if(count > ALARMREPLACEABLECOMPRECORD_MAX_ROW)
                    /// delete the last row from table
                    success = sql->queryDeleteOldestRowId();
            }//
        },
        Qt::QueuedConnection);
}

void MachineBackend::resetReplaceablePartsSettings()
{
    QSettings settings;

    const QJsonObject dbDefault = _getRpListDefaultJsonObj();

    settings.beginGroup("rplist");
    for(short i=1; i < MachineEnums::RPList_Total; i++){
        QString defaultValue = _getRpListDefaultValue(dbDefault, i);
        settings.setValue(m_rpListSettings[i], defaultValue);
        pData->setRpListLast(i, defaultValue);
        pData->setRpListSelected(i, "");
        //            qDebug() << i << pData->getRpListLastAtIndex(i);
    }//
    settings.endGroup();
}

void MachineBackend::setReplaceablePartsSettingsFromSelectedRecord()
{
    QSettings settings;

    settings.beginGroup("rplist");
    for(short i=1; i < MachineEnums::RPList_Total; i++){
        QString defaultValue = pData->getRpListSelectedAtIndex(i);
        settings.setValue(m_rpListSettings[i], defaultValue);
        pData->setRpListLast(i, defaultValue);
    }//
    settings.endGroup();
}

void MachineBackend::requestEjectUsb(const QString &usbName)
{
    /**
     * The reason to use QMetaObject::invokeMethod if the recipient object might be in another thread
     * is that attempting to call a slot directly on an object in another thread can lead to corruption
     * or worse if it accesses or modifies non-thread-safe data **/
    QMetaObject::invokeMethod(m_pUSBAutoMount.data(), [&, usbName](){
            m_pUSBAutoMount->requestEjectUsb(usbName);
        },
        Qt::QueuedConnection);
}

void MachineBackend::setFrontEndScreenState(short value)
{
    qDebug() << metaObject()->className() << __FUNCTION__ << value << thread();
    //    if()
    pData->setFrontEndScreenStatePrev(pData->getFrontEndScreenState());
    pData->setFrontEndScreenState(value);
}

void MachineBackend::setInstallationWizardActive(bool value)
{
    pData->setInstallationWizardActive(value);
}

void MachineBackend::setSomeSettingsAfterExtConfigImported()
{
    qDebug() << metaObject()->className() << __FUNCTION__ << thread();
#ifdef __linux__
    QSettings settings;
    QString year_sn = QDate::currentDate().toString("yyyy-000000");

    settings.setValue(SKEY_SBC_SERIAL_NUMBER, "0000000000000001");
    settings.setValue(SKEY_SBC_SYS_INFO, "sysInfo:sbc");
    settings.setValue(SKEY_SERIAL_NUMMBER, year_sn);
#endif
}

void MachineBackend::setAllOutputShutdown()
{
    qDebug() << metaObject()->className() << __FUNCTION__ << thread();
    setFanState(MachineEnums::FAN_STATE_OFF);
    setLightState(MachineEnums::DIG_STATE_ZERO);
    setUvState(MachineEnums::DIG_STATE_ZERO);
    setGasState(MachineEnums::DIG_STATE_ZERO);
    setSocketState(MachineEnums::DIG_STATE_ZERO);
    setBuzzerState(MachineEnums::DIG_STATE_ZERO);

#ifdef __linux__
    QProcess qprocess;
    qprocess.start("boardinit", QStringList());
    qprocess.waitForFinished();
    qDebug() << qprocess.readAllStandardOutput();
#endif
}

void MachineBackend::setFilterLifeDisplayEnabled(bool value)
{
    QSettings settings;
    settings.setValue(SKEY_FILTER_LIFE_DISPLAY_ENABLED, value);

    pData->setFilterLifeDisplayEnabled(value);

    if((value == false) && pData->getFilterLifeReminder()){
        pData->setFilterLifeReminder(false);
    }
    else{
        if(pData->getFilterLifePercent() < 10)
            pData->setFilterLifeReminder(true);
    }
}

void MachineBackend::setAirflowOutTempEnable(bool value)
{
    QSettings settings;
    settings.setValue(SKEY_AF_OUT_TEMP_ENABLE, value);

    pData->setAirflowOutTempEnable(value);

    _onTemperatureActualChanged(pData->getTemperatureCelcius());
}

void MachineBackend::setSensorConstCorrEnable(bool value)
{
    QSettings settings;
    settings.setValue(SKEY_SENSOR_CONST_CORR_ENABLE, value);
    pData->setSensorConstCorrEnable(value);
}

void MachineBackend::setSensorConstCorrHighZone(int value)
{
    QSettings settings;
    settings.setValue(SKEY_SENSOR_CONST_CORR_HIGH, value);
    pData->setSensorConstCorrHighZone(value);
}

void MachineBackend::setSensorConstCorrLowZone(int value)
{
    QSettings settings;
    settings.setValue(SKEY_SENSOR_CONST_CORR_LOW, value);
    pData->setSensorConstCorrLowZone(value);
}

void MachineBackend::setLogoutTime(int value)
{
    qDebug() << metaObject()->className() << __FUNCTION__ << value << thread();

    QSettings settings;
    settings.setValue(SKEY_LOGOUT_TIME, value);
    pData->setLogoutTime(value);

    if(!value){
        _cancelLogoutTime();
    }else{
        _resetLogoutTime();
    }
}

void MachineBackend::setCFR21Part11Enable(bool value)
{
    qDebug() << metaObject()->className() << __FUNCTION__ << value << thread();
    QSettings settings;
    settings.setValue(SKEY_21_CFR_11_EN, value);
    pData->setCfr21Part11Enable(value);
}

void MachineBackend::resetPowerFailureNotification()
{
    _insertAlarmLog(ALARM_LOG_CODE::ALC_POWER_FAILURE_OK, _tr(ALARM_LOG_TEXT_POWER_FAILURE_OK));
}

void MachineBackend::setFanSpeedControllerBoard(short value)
{
    qDebug() << metaObject()->className() << __FUNCTION__ << value << thread();
    QSettings settings;
    settings.setValue(SKEY_FAN_SPEED_CONTROLLER_BOARD, value);
    pData->setFanSpeedControllerBoard(value);
}

void MachineBackend::setPropogateComposeEventGesture(bool value)
{
    qDebug() << metaObject()->className() << __FUNCTION__ << value << thread();
    pData->setPropogateComposeEventGesture(value);
}

void MachineBackend::resetFieldSensorCalibration()
{
    QString group = SKEY_AIRFLOW_MEA_FIELD;
    QSettings settings;
    settings.beginGroup(group);

    ////// Nominal
    /// DIM METHOD
    settings.remove(SKEY_IFA_CAL_GRID_NOM);
    settings.remove(SKEY_IFA_CAL_GRID_NOM_VOL);
    settings.remove(SKEY_IFA_CAL_GRID_NOM_VEL);
    settings.remove(SKEY_IFA_CAL_GRID_NOM_AVG);
    settings.remove(SKEY_IFA_CAL_GRID_NOM_TOT);
    settings.remove(SKEY_IFA_CAL_GRID_NOM_VOL_IMP);
    settings.remove(SKEY_IFA_CAL_GRID_NOM_VEL_IMP);
    settings.remove(SKEY_IFA_CAL_GRID_NOM_AVG_IMP);
    settings.remove(SKEY_IFA_CAL_GRID_NOM_TOT_IMP);
    settings.remove(SKEY_IFA_CAL_GRID_NOM_DCY);
    settings.remove(SKEY_IFA_CAL_GRID_NOM_RPM);
    /// SECONDARY METHOD
    settings.remove(SKEY_IFA_CAL_GRID_NOM_SEC);
    settings.remove(SKEY_IFA_CAL_GRID_NOM_SEC_TOT);
    settings.remove(SKEY_IFA_CAL_GRID_NOM_SEC_AVG);
    settings.remove(SKEY_IFA_CAL_GRID_NOM_SEC_VEL);
    settings.remove(SKEY_IFA_CAL_GRID_NOM_SEC_TOT_IMP);
    settings.remove(SKEY_IFA_CAL_GRID_NOM_SEC_AVG_IMP);
    settings.remove(SKEY_IFA_CAL_GRID_NOM_SEC_VEL_IMP);
    settings.remove(SKEY_IFA_CAL_GRID_NOM_SEC_DCY);
    settings.remove(SKEY_IFA_CAL_GRID_NOM_SEC_RPM);

    ////// Minimum
    /// DIM METHOD
    settings.remove(SKEY_IFA_CAL_GRID_MIN);
    settings.remove(SKEY_IFA_CAL_GRID_MIN_VOL);
    settings.remove(SKEY_IFA_CAL_GRID_MIN_VEL);
    settings.remove(SKEY_IFA_CAL_GRID_MIN_AVG);
    settings.remove(SKEY_IFA_CAL_GRID_MIN_TOT);
    settings.remove(SKEY_IFA_CAL_GRID_MIN_VOL_IMP);
    settings.remove(SKEY_IFA_CAL_GRID_MIN_VEL_IMP);
    settings.remove(SKEY_IFA_CAL_GRID_MIN_AVG_IMP);
    settings.remove(SKEY_IFA_CAL_GRID_MIN_TOT_IMP);
    settings.remove(SKEY_IFA_CAL_GRID_MIN_DCY);
    settings.remove(SKEY_IFA_CAL_GRID_MIN_RPM);
    /// SECONDARY METHOD
    settings.remove(SKEY_IFA_CAL_GRID_MIN_SEC);
    settings.remove(SKEY_IFA_CAL_GRID_MIN_SEC_TOT);
    settings.remove(SKEY_IFA_CAL_GRID_MIN_SEC_AVG);
    settings.remove(SKEY_IFA_CAL_GRID_MIN_SEC_VEL);
    settings.remove(SKEY_IFA_CAL_GRID_MIN_SEC_TOT_IMP);
    settings.remove(SKEY_IFA_CAL_GRID_MIN_SEC_AVG_IMP);
    settings.remove(SKEY_IFA_CAL_GRID_MIN_SEC_VEL_IMP);
    settings.remove(SKEY_IFA_CAL_GRID_MIN_SEC_DCY);
    settings.remove(SKEY_IFA_CAL_GRID_MIN_SEC_RPM);

    ////// Standby
    /// DIM METHOD
    settings.remove(SKEY_IFA_CAL_GRID_STB);
    settings.remove(SKEY_IFA_CAL_GRID_STB_VOL);
    settings.remove(SKEY_IFA_CAL_GRID_STB_VEL);
    settings.remove(SKEY_IFA_CAL_GRID_STB_AVG);
    settings.remove(SKEY_IFA_CAL_GRID_STB_TOT);
    settings.remove(SKEY_IFA_CAL_GRID_STB_VOL_IMP);
    settings.remove(SKEY_IFA_CAL_GRID_STB_VEL_IMP);
    settings.remove(SKEY_IFA_CAL_GRID_STB_AVG_IMP);
    settings.remove(SKEY_IFA_CAL_GRID_STB_TOT_IMP);
    settings.remove(SKEY_IFA_CAL_GRID_STB_DCY);
    settings.remove(SKEY_IFA_CAL_GRID_STB_RPM);
    /// SECONDARY METHOD
    settings.remove(SKEY_IFA_CAL_GRID_STB_SEC);
    settings.remove(SKEY_IFA_CAL_GRID_STB_SEC_TOT);
    settings.remove(SKEY_IFA_CAL_GRID_STB_SEC_AVG);
    settings.remove(SKEY_IFA_CAL_GRID_STB_SEC_VEL);
    settings.remove(SKEY_IFA_CAL_GRID_STB_SEC_TOT_IMP);
    settings.remove(SKEY_IFA_CAL_GRID_STB_SEC_AVG_IMP);
    settings.remove(SKEY_IFA_CAL_GRID_STB_SEC_VEL_IMP);
    settings.remove(SKEY_IFA_CAL_GRID_STB_SEC_DCY);
    settings.remove(SKEY_IFA_CAL_GRID_STB_SEC_RPM);

    ////// Downflow
    settings.remove(SKEY_DFA_CAL_GRID_NOM);
    settings.remove(SKEY_DFA_CAL_GRID_NOM_VEL);
    settings.remove(SKEY_DFA_CAL_GRID_NOM_VEL_TOT);
    settings.remove(SKEY_DFA_CAL_GRID_NOM_VEL_LOW);
    settings.remove(SKEY_DFA_CAL_GRID_NOM_VEL_HIGH);
    settings.remove(SKEY_DFA_CAL_GRID_NOM_VEL_DEV);
    settings.remove(SKEY_DFA_CAL_GRID_NOM_VEL_DEVP);

    settings.remove(SKEY_DFA_CAL_GRID_NOM_VEL_IMP);
    settings.remove(SKEY_DFA_CAL_GRID_NOM_VEL_TOT_IMP);
    settings.remove(SKEY_DFA_CAL_GRID_NOM_VEL_LOW_IMP);
    settings.remove(SKEY_DFA_CAL_GRID_NOM_VEL_HIGH_IMP);
    settings.remove(SKEY_DFA_CAL_GRID_NOM_VEL_DEV_IMP);
    settings.remove(SKEY_DFA_CAL_GRID_NOM_VEL_DEVP_IMP);

    settings.endGroup();
}

void MachineBackend::setFilterLifeReminderSnoozed(bool value)
{
    pData->setFilterLifeReminderSnoozed(value);
}

void MachineBackend::setUvReplacementReminderSnoozed(bool value)
{
    pData->setUvReplacementReminderSnoozed(value);
}

void MachineBackend::setAdvancedAirflowAlarmEnable(bool value)
{
    QSettings settings;
    settings.setValue(SKEY_ADVANCED_AF_ALARM, value);
    pData->setAdvancedAirflowAlarmEnable(value);
}

void MachineBackend::refreshAirflowCalibrationGrid()
{
    for(short calibMode = 0; calibMode<MachineEnums::CALIB_MODE_TOTAL; calibMode++){
        QSettings setting;
        if(calibMode == MachineEnums::CALIB_MODE_FIELD)
            setting.beginGroup(SKEY_AIRFLOW_MEA_FIELD);
        else
            setting.beginGroup(SKEY_AIRFLOW_MEA_FULL);

        for(short inflowGridPoint=0; inflowGridPoint<MachineEnums::INFLOW_GRID_TOTAL; inflowGridPoint++){
            QString pointString[MachineEnums::INFLOW_GRID_TOTAL] = {"Stb","Min","Nom"};
            /// INFLOW DIM GRID
            pData->setIfaCalGrid(calibMode, inflowGridPoint, setting.value(QString("ifaCalGrid%1").arg(pointString[inflowGridPoint]), "").toString());
            pData->setIfaCalGridTot(calibMode, inflowGridPoint, setting.value(QString("ifaCalGrid%1Tot").arg(pointString[inflowGridPoint]), 0).toInt());
            pData->setIfaCalGridAvg(calibMode, inflowGridPoint, setting.value(QString("ifaCalGrid%1Avg").arg(pointString[inflowGridPoint]), 0).toInt());
            pData->setIfaCalGridVol(calibMode, inflowGridPoint, setting.value(QString("ifaCalGrid%1Vol").arg(pointString[inflowGridPoint]), 0).toInt());
            pData->setIfaCalGridVel(calibMode, inflowGridPoint, setting.value(QString("ifaCalGrid%1Vel").arg(pointString[inflowGridPoint]), 0).toInt());
            pData->setIfaCalGridTotImp(calibMode, inflowGridPoint, setting.value(QString("ifaCalGrid%1TotImp").arg(pointString[inflowGridPoint]), 0).toInt());
            pData->setIfaCalGridAvgImp(calibMode, inflowGridPoint, setting.value(QString("ifaCalGrid%1AvgImp").arg(pointString[inflowGridPoint]), 0).toInt());
            pData->setIfaCalGridVolImp(calibMode, inflowGridPoint, setting.value(QString("ifaCalGrid%1VolImp").arg(pointString[inflowGridPoint]), 0).toInt());
            pData->setIfaCalGridVelImp(calibMode, inflowGridPoint, setting.value(QString("ifaCalGrid%1VelImp").arg(pointString[inflowGridPoint]), 0).toInt());
            pData->setIfaCalGridDcy(calibMode, inflowGridPoint, setting.value(QString("ifaCalGrid%1Dcy").arg(pointString[inflowGridPoint]), 0).toInt());
            pData->setIfaCalGridRpm(calibMode, inflowGridPoint, setting.value(QString("ifaCalGrid%1Rpm").arg(pointString[inflowGridPoint]), 0).toInt());

            /// INFLOW SEC GRID
            pData->setIfaCalGridSec(calibMode, inflowGridPoint, setting.value(QString("ifaCalGrid%1Sec").arg(pointString[inflowGridPoint]), "").toString());
            pData->setIfaCalGridTotSec(calibMode, inflowGridPoint, setting.value(QString("ifaCalGrid%1TotSec").arg(pointString[inflowGridPoint]), 0).toInt());
            pData->setIfaCalGridAvgSec(calibMode, inflowGridPoint, setting.value(QString("ifaCalGrid%1AvgSec").arg(pointString[inflowGridPoint]), 0).toInt());
            pData->setIfaCalGridVelSec(calibMode, inflowGridPoint, setting.value(QString("ifaCalGrid%1VelSec").arg(pointString[inflowGridPoint]), 0).toInt());
            pData->setIfaCalGridTotSecImp(calibMode, inflowGridPoint, setting.value(QString("ifaCalGrid%1TotSecImp").arg(pointString[inflowGridPoint]), 0).toInt());
            pData->setIfaCalGridAvgSecImp(calibMode, inflowGridPoint, setting.value(QString("ifaCalGrid%1AvgSecImp").arg(pointString[inflowGridPoint]), 0).toInt());
            pData->setIfaCalGridVelSecImp(calibMode, inflowGridPoint, setting.value(QString("ifaCalGrid%1VelSecImp").arg(pointString[inflowGridPoint]), 0).toInt());
            pData->setIfaCalGridDcySec(calibMode, inflowGridPoint, setting.value(QString("ifaCalGrid%1DcySec").arg(pointString[inflowGridPoint]), 0).toInt());
            pData->setIfaCalGridRpmSec(calibMode, inflowGridPoint, setting.value(QString("ifaCalGrid%1RpmSec").arg(pointString[inflowGridPoint]), 0).toInt());
        }


        for(short downflowGridPoint=0; downflowGridPoint<MachineEnums::DOWNFLOW_GRID_TOTAL; downflowGridPoint++){
            QString pointString[MachineEnums::DOWNFLOW_GRID_TOTAL] = {"Min","Nom","Max"};
            /// DOWNFLOW GRID
            pData->setDfaCalGrid(calibMode, downflowGridPoint, setting.value(QString("dfaCalGrid%1").arg(pointString[downflowGridPoint]), "").toString());
            pData->setDfaCalGridVel(calibMode, downflowGridPoint, setting.value(QString("dfaCalGrid%1Vel").arg(pointString[downflowGridPoint]), 0).toInt());
            pData->setDfaCalGridVelTot(calibMode, downflowGridPoint, setting.value(QString("dfaCalGrid%1VelTot").arg(pointString[downflowGridPoint]), 0).toInt());
            pData->setDfaCalGridVelDev(calibMode, downflowGridPoint, setting.value(QString("dfaCalGrid%1VelDev").arg(pointString[downflowGridPoint]), 0).toInt());
            pData->setDfaCalGridVelDevp(calibMode, downflowGridPoint, setting.value(QString("dfaCalGrid%1VelDevp").arg(pointString[downflowGridPoint]), 0).toInt());
            pData->setDfaCalGridVelHigh(calibMode, downflowGridPoint, setting.value(QString("dfaCalGrid%1VelHigh").arg(pointString[downflowGridPoint]), 0).toInt());
            pData->setDfaCalGridVelLow(calibMode, downflowGridPoint, setting.value(QString("dfaCalGrid%1VelLow").arg(pointString[downflowGridPoint]), 0).toInt());
            pData->setDfaCalGridVelImp(calibMode, downflowGridPoint, setting.value(QString("dfaCalGrid%1VelImp").arg(pointString[downflowGridPoint]), 0).toInt());
            pData->setDfaCalGridVelTotImp(calibMode, downflowGridPoint, setting.value(QString("dfaCalGrid%1VelTotImp").arg(pointString[downflowGridPoint]), 0).toInt());
            pData->setDfaCalGridVelDevImp(calibMode, downflowGridPoint, setting.value(QString("dfaCalGrid%1VelDevImp").arg(pointString[downflowGridPoint]), 0).toInt());
            pData->setDfaCalGridVelDevpImp(calibMode, downflowGridPoint, setting.value(QString("dfaCalGrid%1VelDevpImp").arg(pointString[downflowGridPoint]), 0).toInt());
            pData->setDfaCalGridVelHighImp(calibMode, downflowGridPoint, setting.value(QString("dfaCalGrid%1VelHighImp").arg(pointString[downflowGridPoint]), 0).toInt());
            pData->setDfaCalGridVelLowImp(calibMode, downflowGridPoint, setting.value(QString("dfaCalGrid%1VelLowImp").arg(pointString[downflowGridPoint]), 0).toInt());
        }
    }
}

void MachineBackend::setCertificationParametersInt(short index, int value)
{
    QSettings setting;

    setting.beginGroup("certification");

    setting.setValue(m_keyCertifParamInt[index], value);
    pData->setCertificationParametersInt(index, value);

    setting.endGroup();
}

void MachineBackend::setCertificationParametersStr(short index, const QString &value)
{
    QSettings setting;

    setting.beginGroup("certification");

    setting.setValue(m_keyCertifParamStr[index], value);
    pData->setCertificationParametersStr(index, value);

    setting.endGroup();
}

void MachineBackend::refreshTodayBookingSchedule()
{
    QDate qDate = QDate().currentDate();
    m_currentDateStr = qDate.toString("yyyy-MM-dd");
    //qDebug() << "selectByDate" << m_currentDateStr;
    QString dateStr = m_currentDateStr;
    QMetaObject::invokeMethod(m_pBookingSchedule.data(), [&, dateStr](){
            m_pBookingSchedule->selectByDate(dateStr);
        },
        Qt::QueuedConnection);
}

void MachineBackend::setBookedScheduleNotifEnable(bool value)
{
    if(value != pData->getBookingScheduleNotifEnable()){
        QSettings setting;
        setting.setValue(SKEY_BOOKED_SCHEDULE_NOTIF_EN, value);
        pData->setBookingScheduleNotifEnable(value);

        refreshBookScheduleNotifDisplay();
    }
}

void MachineBackend::setBookedScheduleNotifTime(int value)
{    
    if(value != pData->getBookingScheduleNotifTime()){
        QSettings setting;
        setting.setValue(SKEY_BOOKED_SCHEDULE_NOTIF_TM, value);
        pData->setBookingScheduleNotifTime(value);

        refreshBookScheduleNotifDisplay();
    }
}

void MachineBackend::setBookedScheduleNotifCollapse(bool value)
{
    QSettings setting;
    setting.setValue(SKEY_BOOKED_SCHEDULE_NOTIF_COL, value);
    pData->setBookingScheduleNotifCollapse(value);
}

void MachineBackend::setBookedScheduleAcknowledge(const QString &time, bool value)
{
    qDebug() << metaObject()->className() << __FUNCTION__ << value << thread();

    QVariantList todaySchedule = pData->getBookingScheduleTodayVarList();

    /// Check if need to show the notification
    if(todaySchedule.length() > 0){
        QVariantList itemTemp;

        for(short i=0; i<todaySchedule.length(); i++){
            QVariantMap item;

            item.insert("bookByUsername", todaySchedule.at(i).toMap().value("bookByUsername").toString());
            item.insert("bookForName",    todaySchedule.at(i).toMap().value("bookForName").toString());
            item.insert("bookTitle",      todaySchedule.at(i).toMap().value("bookTitle").toString());
            item.insert("time",           todaySchedule.at(i).toMap().value("time").toString());
            item.insert("notifActive",    todaySchedule.at(i).toMap().value("notifActive").toBool());

            qDebug() << todaySchedule.at(i).toMap().value("time").toString() << time;

            if(todaySchedule.at(i).toMap().value("time").toString() == time)
                item.insert("acknowledge", value);
            else
                item.insert("acknowledge", todaySchedule.at(i).toMap().value("acknowledge").toBool());

            itemTemp.append(item);
        }//

        pData->setBookingScheduleTodayVarList(itemTemp);

        refreshBookScheduleNotifDisplay();
    }//
}

void MachineBackend::refreshBookScheduleNotifDisplay()
{
    //qDebug() << metaObject()->className() << __FUNCTION__ << thread();

    QVariantList todaySchedule = pData->getBookingScheduleTodayVarList();

    //qDebug() << todaySchedule.length() << todaySchedule;

    /// Check if need to show the notification
    if(todaySchedule.length() > 0){
        QTime qTimeCurrent = QTime::currentTime();
        //QString currTimeStr = qTimeCurrent.toString("HH:mm");
        int notifyBeforeMin = pData->getBookingScheduleNotifTime();

        QVariantList itemTemp;

        for(short i=0; i<todaySchedule.length(); i++){
            bool notifActive = false;
            QTime qTimeSched = QTime::fromString(todaySchedule.at(i).toMap().value("time").toString(), "HH:mm");
            int notifMinToGo = qTimeCurrent.secsTo(qTimeSched) / 60;

            //            qDebug() << i << "#@##@!!!" << notifMinToGo << notifyBeforeMin << notifMinToGo+60;

            /// Display Notification before notifTime
            /// and during the schedule
            if((notifMinToGo >= 0 && notifMinToGo <= notifyBeforeMin)
                || ((notifMinToGo < 0) && ((notifMinToGo+60) > 0))){
                notifActive = true;
            }
            //            qDebug() << "notifActive" << notifActive;
            //            qDebug() << i << "!!!!" << notifActive << todaySchedule.at(i);
            //            qDebug() << notifActive << todaySchedule.at(i);
            //            todaySchedule.at(i).toMap().take("notifActive");
            //            qDebug() << i << "###";
            //            qDebug() << notifActive << todaySchedule.at(i);
            //            todaySchedule.at(i).toMap().insert("notifActive", notifActive);
            //            qDebug() << i << "---";
            //            qDebug() << notifActive << todaySchedule.at(i);

            QVariantMap item;
            item.insert("bookByUsername", todaySchedule.at(i).toMap().value("bookByUsername").toString());
            item.insert("bookForName",    todaySchedule.at(i).toMap().value("bookForName").toString());
            item.insert("bookTitle",      todaySchedule.at(i).toMap().value("bookTitle").toString());
            item.insert("time",           todaySchedule.at(i).toMap().value("time").toString());
            item.insert("notifActive",    notifActive);
            item.insert("acknowledge",    todaySchedule.at(i).toMap().value("acknowledge").toBool());
            itemTemp.append(item);

            //            qDebug() << i << "----" << notifActive << itemTemp.at(i);
        }//

        //        if(itemTemp.length() > 0){
        //qDebug() << itemTemp;
        pData->setBookingScheduleTodayVarList(itemTemp);
        //        }//

        itemTemp.clear();
        todaySchedule = pData->getBookingScheduleTodayVarList();
        bool displayNotif = false;

        for(short i=0; i<todaySchedule.length(); i++){
            bool notifActive = false;
            bool acknowledge = false;
            notifActive = todaySchedule.at(i).toMap().value("notifActive").toBool();
            acknowledge = todaySchedule.at(i).toMap().value("acknowledge").toBool();
            if(notifActive && !acknowledge){
                qDebug() << i << todaySchedule.at(i);
                itemTemp.append(todaySchedule.at(i));
                displayNotif = true;
            }
        }

        //        if(itemTemp.length() > 0){
        //qDebug() << itemTemp;
        pData->setBookingScheduleTodayVarListToShow(itemTemp);
        //        }//

        /// Display if notifActive is true and hasn't been acknowledged
        pData->setBookingScheduleTodayDispNotif(displayNotif);
        //        qDebug() << "Display Notif" << displayNotif;
        //        qDebug() << itemTemp;
    }//
    else{
        pData->setBookingScheduleTodayDispNotif(false);
    }
}

void MachineBackend::setExperimentTimerAlwaysShow(bool value)
{
    QSettings settings;
    settings.setValue(SKEY_EXP_TIMER_ALWAYS_SHOW, value);

    pData->setExperimentTimerAlwaysShow(value);
}

void MachineBackend::setNetworkConnectedStatus(short value)
{
    m_networkConnectedStatus = value;

#ifdef __arm__
    if(value){
        QTimer::singleShot(10000, this, [&](){
            bool sync = _getSystemClockSynchronized();
            if(sync != m_systemClockSync){
                m_systemClockSync = sync;
                if(sync){
                    _syncLinuxTimeToRtc();
                }//
            }//
        });
    }//
#endif
}//


void MachineBackend::setFanSpeedMaximumLimit(int value)
{
    qDebug() << metaObject()->className() << __func__  << thread();

    pData->setFanSpeedMaxLimit(value);
    pData->setFanSpeedMaxLimitSaved(value);

    QSettings settings;
    settings.setValue(SKEY_FAN_SPEED_MAX_LIMIT, value);
}

void MachineBackend::setFanSpeedFullEnable(bool value)
{
    qDebug() << metaObject()->className() << __func__  << thread();

    pData->setFanSpeedFullEnable(value);

    if(!value){
        pData->setFanSpeedMaxLimit(pData->getFanSpeedMaxLimitSaved());
    }else{
        pData->setFanSpeedMaxLimit(99);
    }
}

/// Call this function after shipping mode just activated
void MachineBackend::setSpecialSettingForCustomer(const QString &customer)
{
    qDebug() << metaObject()->className() << __func__  << customer << thread();
    /// General
    // Acknowledge the preventive maintenance reminder
    // QuickStart Mode is active
    setAlarmPreventMaintStateAck(MachineEnums::PM_QUARTERLY_CODE, true, false);
    setAlarmPreventMaintStateAck(MachineEnums::PM_ANNUALLY_CODE, true, false);
    setAlarmPreventMaintStateAck(MachineEnums::PM_QUINQUENNIALLY_CODE, true, false);
    setAlarmPreventMaintStateEnable(MachineEnums::PM_QUARTERLY_CODE, true);
    setAlarmPreventMaintStateEnable(MachineEnums::PM_ANNUALLY_CODE, true);
    setAlarmPreventMaintStateEnable(MachineEnums::PM_QUINQUENNIALLY_CODE, true);

    setOperationModeSave(MachineEnums::MODE_OPERATION_QUICKSTART);
    setUvTimeSave(60);
    /// ETI
    // Logout time disable
    // Security access level to low
    // Screen auto dim is disable
    // Timezone is US Eastern Time Zone (New York)
    // enable lock screen to false
    // UV Timer 1 hour
    // First time only, Menu -> Do you want to setup the cabinet now? Yes and No button (Remove the installation wizard)
    if(customer == "ETI"){
        setLogoutTime(0);
        setSecurityAccessModeSave(MachineEnums::MODE_SECURITY_ACCESS_LOW);
        setLcdBrightnessDelayToDimm(0);
        setTimeZone("America/New_York#-4#UTC-05:00");
        setLcdEnableLockScreen(false);
        setUVAutoEnabledOff(false);
    }//
}//

void MachineBackend::setRpExternalDatabaseEnable(bool value)
{
    qDebug() << metaObject()->className() << __func__  << value << thread();
    pData->setRpExtDatabaseEnable(value);
    QSettings settings;
    settings.setValue(SKEY_RP_EXT_DB_ENABLE, value);
}

void MachineBackend::refreshRpExternalDatabase()
{
    qDebug() << metaObject()->className() << __func__ << thread();
    QMetaObject::invokeMethod(m_pCheckSwUpdate.data(), [&](){
            m_pCheckSwUpdate->refreshRpExternalDatabase();
        },
        Qt::QueuedConnection);
}

void MachineBackend::refreshRpExternalDefault()
{
    qDebug() << metaObject()->className() << __func__ << thread();
    QMetaObject::invokeMethod(m_pCheckSwUpdate.data(), [&](){
            m_pCheckSwUpdate->refreshRpExternalDefault();
        },
        Qt::QueuedConnection);
}

void MachineBackend::checkValidityOfRpList()
{
    bool valid = true;

    int startEnums[10] = {
        MachineEnums::RPList_SBCSet1Name,
        MachineEnums::RPList_Sensor1Name,
        MachineEnums::RPList_UVLED1Name,
        MachineEnums::RPList_PSU1Name,
        MachineEnums::RPList_MCBEMI1Name,
        MachineEnums::RPList_ContactSw1Name,
        MachineEnums::RPList_BMotor1Name,
        MachineEnums::RPList_CapInd1Name,
        MachineEnums::RPList_Custom1Name,
        MachineEnums::RPList_Filter1Name
    };//

    //    QString getGroupFromIndex[10] = {
    //        "sbcSet",
    //        "sensors",
    //        "uvLed",
    //        "psu",
    //        "mcbEmi",
    //        "contactSw",
    //        "bMotor",
    //        "capInd",
    //        "custom",
    //        "filter"
    //    };//

    int maxRowInTable[10] = { 15, 5, 6, 5, 5, 5, 5, 5, 8, 5 };//
    int maxColumnInTable[10] = { 6, 6, 5, 5, 5, 5, 7, 5, 5, 8 };//

    if(pData->getRpListLastAtIndex(MachineEnums::RPList_UnitModel).isEmpty()
        || pData->getRpListLastAtIndex(MachineEnums::RPList_UnitSerialNumber).isEmpty()
        || pData->getRpListLastAtIndex(MachineEnums::RPList_CheckedBy).isEmpty()
        || pData->getRpListLastAtIndex(MachineEnums::RPList_ElectricalPanel).isEmpty()
        || pData->getRpListLastAtIndex(MachineEnums::RPList_ElectricalPanelSerialNumber).isEmpty()
        || pData->getRpListLastAtIndex(MachineEnums::RPList_ElectricalTester).isEmpty()){
        valid = false;
    }
    else{
        /// Unit Model Name checking
        /// LA2-5S9 G4 10"
        /// check only LA2-5S9
        bool unitModelValid = true;
        QString unitModelName = pData->getRpListLastAtIndex(MachineEnums::RPList_UnitModel);
        if(unitModelName.split(" ").length() >= 2){
            QString modelSize = unitModelName.split(" ")[0];
            if(modelSize.split("-").length() == 2){
                QString sizeStr = modelSize.split("-")[1];
                if(sizeStr.length() == 3){
                    QString ft = sizeStr.at(0);
                    QString material = sizeStr.at(1);
                    QString pwr = sizeStr.at(2);
                    //console.debug(ft, material, pwr)
                    unitModelValid = ((ft.toInt() >= 2 && ft.toInt() < 10)
                                      && ((pwr.toInt() == 7) || (pwr.toInt() == 8) || (pwr.toInt() == 9)));
                }
                else
                    unitModelValid = false;
            }
            else
                unitModelValid = false;
        }
        else{
            unitModelValid = false;
        }
        if(unitModelValid){
            for(short i=0; i<10; i++){
                //QString group = getGroupFromIndex[i];
                short startEnum = startEnums[i];
                short maxRow = maxRowInTable[i];
                short maxCol = maxColumnInTable[i];
                QString partname = "", itemcode = "", qty = "", checked = "";
                bool uncheckedFileExist = false;
                for(short i=0; i<maxRow; i++){
                    partname = pData->getRpListLastAtIndex(((startEnum+i) + (0*maxRow)));
                    itemcode = pData->getRpListLastAtIndex(((startEnum+i) + (1*maxRow)));
                    qty = pData->getRpListLastAtIndex(((startEnum+i) + (2*maxRow)));
                    checked = pData->getRpListLastAtIndex(((startEnum+i) + ((maxCol-1)*maxRow)));
                    uncheckedFileExist = ((partname != "")
                                          && (itemcode != "")
                                          && (qty != "")
                                          && (checked != "1"));
                    if(uncheckedFileExist) break;
                }//
                valid = !uncheckedFileExist;
            }
        }else{
            valid = false;
        }
    }//

    emit pData->checkValidityOfRpListFinised(valid);
}//

//void MachineBackend::setResourceMonitorParamsActive(bool value)
//{
//    pData->setResourceMonitorParamsActive(value);
//}//

void MachineBackend::_machineState()
{
    //qDebug() << __func__;
    ///ALARM BOARD
    bool alarmsBoards = false;
    alarmsBoards |= !pData->getBoardStatusHybridDigitalInput();
    alarmsBoards |= !pData->getBoardStatusHybridDigitalRelay();
    alarmsBoards |= !pData->getBoardStatusHybridAnalogInput();
    alarmsBoards |= !pData->getBoardStatusHybridAnalogOutput();
    alarmsBoards |= !pData->getBoardStatusRbmCom();
    alarmsBoards |= !pData->getBoardStatusCtpRtc();
    alarmsBoards |= !pData->getBoardStatusCtpIoe();
    if(pData->getSeasInstalled()){
        alarmsBoards |= !pData->getBoardStatusPressureDiff();
    }
    Q_UNUSED(alarmsBoards)

///demo
#ifdef QT_DEBUG
    alarmsBoards = false;
#endif

    if(alarmsBoards){
        if(!isAlarmActive(pData->getAlarmBoardComError())){
            pData->setAlarmBoardComError(MachineEnums::ALARM_ACTIVE_STATE);
            _insertAlarmLog(ALARM_LOG_CODE::ALC_MODULE_ALARM, _tr(ALARM_LOG_TEXT_BOARD_ERROR_ALARM));
        }
    }
    else {
        if(!isAlarmNormal(pData->getAlarmBoardComError())){
            pData->setAlarmBoardComError(MachineEnums::ALARM_NORMAL_STATE);
            _insertAlarmLog(ALARM_LOG_CODE::ALC_MODULE_OK, _tr(ALARM_LOG_TEXT_BOARD_ERROR_OK));
        }
    }

    /// STATE MACINE BASED ON OPERATION MODE AND SASH STATE
    int modeOperation = pData->getOperationMode();
    //    modeOperation = MachineEnums::MODE_OPERATION_NORMAL;

    switch (modeOperation) {
    case MachineEnums::MODE_OPERATION_QUICKSTART:
    case MachineEnums::MODE_OPERATION_NORMAL:
        //CONDITION BY MODE NORMAL OR QUICKSTART
        {
            ////CABINET WITH SEAS SIGNAL ALARM BOARD FOR COLLAR WITH FLAP
            if(pData->getSeasFlapInstalled()){
                //DEPENDING_TO_BLOWER_STATE
                //DEPENDING_TO_AF_CALIBRATION_STATUS
                //ONLY_IF_BLOWER_IS_ON
                short alarm = pData->getSeasFlapAlarmPressure();

                // if((isFanStateNominal() && isAirflowHasCalibrated())){
                //     int actual  = pData->getSeasPressureDiffPa();
                //     int fail    = pData->getSeasPressureDiffPaLowLimit();

                // printf("%d %d %s", actual, fail, (actual >= fail) ? "Bigger" : "Less");
                // fflush(stdout);

                if(pData->getMagSW6State()){
                    //SEAS BOARD FLAP IS ALARM
                    if(!isAlarmActive(alarm)){
                        /// SET ALARM EXHAUST
                        pData->setSeasFlapAlarmPressure(MachineEnums::ALARM_ACTIVE_STATE);

                        /// INSERT ALARM LOG
                        QString text = QString("%1")
                                           .arg(_tr(ALARM_LOG_TEXT_SEAS_FLAP_LOW));
                        _insertAlarmLog(ALARM_LOG_CODE::ALC_SEAS_FLAP_LOW, text);
                    }
                }
                else {
                    //EXHAUST IS NORMAL
                    if(!isAlarmNormal(alarm)){
                        //UNSET ALARM EXHAUST
                        pData->setSeasFlapAlarmPressure(MachineEnums::ALARM_NORMAL_STATE);

                        /// INSERT ALARM LOG
                        QString text = QString("%1")
                                           .arg(_tr(ALARM_LOG_TEXT_SEAS_FLAP_OK));
                        _insertAlarmLog(ALARM_LOG_CODE::ALC_SEAS_FLAP_OK, text);
                    }
                }
                // }
                // else {
                //     if (!isAlarmNA(alarm)) {
                //         //NOT APPLICABLE ALARM EXHAUST
                //         pData->setSeasAlarmPressureLow(MachineEnums::ALARM_NA_STATE);
                //     }
                // }
            }

            //CONDITION BY SASH
            switch (pData->getSashWindowState()) {
            case MachineEnums::SASH_STATE_WORK_SSV:
            {
                ////INTERLOCK UV IF DEVICE INSTALLED
                if(pData->getUvInstalled()){
                    if(!pData->getUvInterlocked()){
                        m_pUV->setInterlock(MachineEnums::DIG_STATE_ONE);
                    }//
                }//

                /////CLEAR INTERLOCK FAN
                if(pData->getFanPrimaryInterlocked()){
                    _setFanPrimaryInterlocked(MachineEnums::DIG_STATE_ZERO);
                }

                /// CLEAR LAMP INTERLOCK
                if(pData->getLightInterlocked()){
                    m_pLight->setInterlock(MachineEnums::DIG_STATE_ZERO);
                }

                ///////////////INTERLOCK GAS IF DEVICE INSTALLED AND WARMUP IS NOT ACTIVE
                if(pData->getGasInstalled()){
                    if(isFanStateNominal()
                        && !pData->getPostPurgingActive()
                        && !pData->getWarmingUpActive() && !pData->getAlarmsState()){
                        if (pData->getGasInterlocked()){
                            m_pGas->setInterlock(MachineEnums::DIG_STATE_ZERO);
                        }
                    }
                    else{
                        if (!pData->getGasInterlocked()){
                            m_pGas->setInterlock(MachineEnums::DIG_STATE_ONE);
                        }
                    }
                }

                //// NA ALARM STANDBY FAN OFF
                if(!isAlarmNA(pData->getAlarmStandbyFanOff())){
                    pData->setAlarmStandbyFanOff(MachineEnums::ALARM_NA_STATE);
                }

                /// ALARM
                if(isAlarmActive(pData->getAlarmBoardComError())){
                    /// THERE IS COMMUNICATION ERROR BETWEEN BOARD
                    /// IN THIS SITUATION, AIRFLOW ALARM AND SASH ALARM NOT APPLICABLE (NA)

                    if(!isAlarmNA(pData->getAlarmSash())){
                        pData->setAlarmSash(MachineEnums::ALARM_SASH_NA_STATE);
                    }
                    if(!isAlarmNA(pData->getAlarmInflowLow())) {
                        pData->setAlarmInflowLow(MachineEnums::ALARM_NA_STATE);
                    }
                }
                else {
                    if(!isAlarmNormal(pData->getAlarmSash())){
                        short prevState = pData->getAlarmSash();
                        pData->setAlarmSash(MachineEnums::ALARM_SASH_NORMAL_STATE);

                        if (isAlarmActive(prevState)){
                            _insertAlarmLog(ALARM_LOG_CODE::ALC_SASH_WINDOW_OK,
                                            _tr(ALARM_LOG_TEXT_SASH_OK));
                        }
                    }

                    /// ENVIRONMENTAL TEMPERATURE ALARM
                    /// ONLY WHEN SENSOR ALREADY CALIBRATED
                    /// IF NOT, NO ALARM, AND NO MAINTENANCE
                    if(isFanStateNominal()
                        && !pData->getWarmingUpActive()
                        && !pData->getPostPurgingActive()
                        && isAirflowHasCalibrated()){

                        if (isTempAmbientHigh()) {
                            if(!isAlarmActive(pData->getAlarmTempHigh())){
                                pData->setAlarmTempHigh(MachineEnums::ALARM_ACTIVE_STATE);
                                /// ALARM LOG
                                QString text = QString("%1 (%2)")
                                                   .arg(_tr(ALARM_LOG_TEXT_ENV_TEMP_TOO_HIGH), pData->getTemperatureValueStrf());
                                _insertAlarmLog(ALARM_LOG_CODE::ALC_ENV_TEMP_HIGH, text);
                            }
                        }
                        else {
                            if (!isAlarmNormal(pData->getAlarmTempHigh())
                                && !isAlarmNA(pData->getAlarmTempHigh())) {
                                pData->setAlarmTempHigh(MachineEnums::ALARM_NORMAL_STATE);
                                /// ALARM LOG
                                QString text = QString("%1 (%2)")
                                                   .arg(_tr(ALARM_LOG_TEXT_ENV_TEMP_OK), pData->getTemperatureValueStrf());
                                _insertAlarmLog(ALARM_LOG_CODE::ALC_ENV_TEMP_OK, text);
                            }
                        }//

                        if (isTempAmbientLow()) {
                            if(!isAlarmActive(pData->getAlarmTempLow())){
                                pData->setAlarmTempLow(MachineEnums::ALARM_ACTIVE_STATE);
                                /// ALARM LOG
                                QString text = QString("%1 (%2)")
                                                   .arg(_tr(ALARM_LOG_TEXT_ENV_TEMP_TOO_LOW), pData->getTemperatureValueStrf());
                                _insertAlarmLog(ALARM_LOG_CODE::ALC_ENV_TEMP_LOW, text);
                            }
                        }
                        else {
                            if (!isAlarmNormal(pData->getAlarmTempLow())
                                && !isAlarmNA(pData->getAlarmTempLow())) {
                                pData->setAlarmTempLow(MachineEnums::ALARM_NORMAL_STATE);
                                /// ALARM LOG
                                QString text = QString("%1 (%2)")
                                                   .arg(_tr(ALARM_LOG_TEXT_ENV_TEMP_OK), pData->getTemperatureValueStrf());
                                _insertAlarmLog(ALARM_LOG_CODE::ALC_ENV_TEMP_OK, text);
                            }
                        }
                    }
                    else {
                        if (!isAlarmNA(pData->getAlarmTempHigh())) {
                            pData->setAlarmTempHigh(MachineEnums::ALARM_NA_STATE);
                        }
                        if (!isAlarmNA(pData->getAlarmTempLow())) {
                            pData->setAlarmTempLow(MachineEnums::ALARM_NA_STATE);
                        }
                    }

                    //ALARM AIRFLOW FLAG
                    //IF FAN STATE IS NOMINAL
                    //IF AIFLOW CALIBRATED IN FACTORY OR FIELD
                    //OTHERWISE UNSET
                    {
                        bool alarmInflowAvailable = false;
                        if(isFanStateNominal() && pData->getAirflowMonitorEnable()){
                            if (isAirflowHasCalibrated()){
                                if (isTempAmbientNormal()){
                                    if (!pData->getWarmingUpActive()){
                                        alarmInflowAvailable = true;
                                        //                                if(!pData->dataPostpurgeState()){

                                        //SET IF ACTUAL AF IS LOWER THAN MINIMUM, OTHERWISE UNSET
                                        bool tooLowIfa = false;
                                        tooLowIfa = pData->getInflowVelocity() <= pData->getInflowLowLimitVelocity();
                                        //qDebug() << "tooLow: " << tooLow << pData->getInflowVelocity() << pData->getInflowLowLimitVelocity();

                                        bool tooLowDfa = false;
                                        bool tooHighDfa = false;
                                        if(pData->getAdvancedAirflowAlarmEnable()){
                                            int actualDfa = pData->getDownflowVelocity();
                                            int nominalDfa = pData->getDownflowVelocityPointFactory(MachineEnums::POINT_NOMINAL);
                                            int tolerance = 1000; // Downflow alarm +/- 10 fpm
                                            if(!pData->getMeasurementUnit()){
                                                tolerance = 5; // Downflow alarm +/- 0.0508 m/s
                                            }
                                            if(pData->getAirflowCalibrationStatus() == MachineEnums::AF_CALIB_FIELD)
                                                nominalDfa = pData->getDownflowVelocityPointField(MachineEnums::POINT_NOMINAL);

                                            tooLowDfa = (nominalDfa - actualDfa) >= tolerance;
                                            tooHighDfa = (actualDfa - nominalDfa) >= tolerance;

                                            qDebug() << actualDfa << nominalDfa << tolerance;
                                            qDebug() << "tooLowDfa" << tooLowDfa;
                                            qDebug() << "tooHighDfa" << tooHighDfa;
                                        }//

                                        if(tooLowIfa){
                                            if(!isAlarmActive(pData->getAlarmInflowLow())){

                                                pData->setAlarmInflowLow(MachineEnums::ALARM_ACTIVE_STATE);

                                                QString text = QString("%1 (%2)")
                                                                   .arg(_tr(ALARM_LOG_TEXT_INFLOW_ALARM_TOO_LOW), pData->getInflowVelocityStr());
                                                _insertAlarmLog(ALARM_LOG_CODE::ALC_INFLOW_ALARM_LOW, text);
                                            }
                                        }
                                        else {
                                            if(!isAlarmNormal(pData->getAlarmInflowLow())){
                                                short prevState = pData->getAlarmInflowLow();
                                                pData->setAlarmInflowLow(MachineEnums::ALARM_NORMAL_STATE);

                                                if(isAlarmActive(prevState)) {
                                                    QString text = QString("%1 (%2)")
                                                                       .arg(_tr(ALARM_LOG_TEXT_INFLOW_ALARM_OK), pData->getInflowVelocityStr());
                                                    _insertAlarmLog(ALARM_LOG_CODE::ALC_INFLOW_ALARM_OK, text);
                                                }//
                                            }//
                                        }//

                                        /// DOWNFLOW ALARM
                                        if(tooLowDfa){
                                            if(!isAlarmActive(pData->getAlarmDownflowLow())){

                                                pData->setAlarmDownflowLow(MachineEnums::ALARM_ACTIVE_STATE);

                                                QString text = QString("%1 (%2)")
                                                                   .arg(_tr(ALARM_LOG_TEXT_DOWNFLOW_ALARM_TOO_LOW), pData->getDownflowVelocityStr());
                                                _insertAlarmLog(ALARM_LOG_CODE::ALC_DOWNFLOW_ALARM_LOW, text);
                                            }
                                        }
                                        else{
                                            if(!isAlarmNormal(pData->getAlarmDownflowLow())){
                                                short prevState = pData->getAlarmDownflowLow();
                                                pData->setAlarmDownflowLow(MachineEnums::ALARM_NORMAL_STATE);

                                                if(isAlarmActive(prevState)) {
                                                    QString text = QString("%1 (%2)")
                                                                       .arg(_tr(ALARM_LOG_TEXT_DOWNFLOW_ALARM_OK), pData->getDownflowVelocityStr());
                                                    _insertAlarmLog(ALARM_LOG_CODE::ALC_DOWNFLOW_ALARM_OK, text);
                                                }//
                                            }//
                                        }//

                                        if(tooHighDfa){
                                            if(!isAlarmActive(pData->getAlarmDownflowHigh())){

                                                pData->setAlarmDownflowHigh(MachineEnums::ALARM_ACTIVE_STATE);

                                                QString text = QString("%1 (%2)")
                                                                   .arg(_tr(ALARM_LOG_TEXT_DOWNFLOW_ALARM_TOO_HIGH), pData->getDownflowVelocityStr());
                                                _insertAlarmLog(ALARM_LOG_CODE::ALC_DOWNFLOW_ALARM_HIGH, text);
                                            }
                                        }
                                        else {
                                            if(!isAlarmNormal(pData->getAlarmDownflowHigh())){
                                                short prevState = pData->getAlarmDownflowHigh();
                                                pData->setAlarmDownflowHigh(MachineEnums::ALARM_NORMAL_STATE);

                                                if(isAlarmActive(prevState)) {
                                                    QString text = QString("%1 (%2)")
                                                                       .arg(_tr(ALARM_LOG_TEXT_DOWNFLOW_ALARM_OK), pData->getDownflowVelocityStr());
                                                    _insertAlarmLog(ALARM_LOG_CODE::ALC_DOWNFLOW_ALARM_OK, text);
                                                }//
                                            }//
                                        }//
                                    }//
                                }//
                                //                    }
                            }//
                        }//
                        if(!alarmInflowAvailable){
                            if(!isAlarmNA(pData->getAlarmInflowLow())) {
                                pData->setAlarmInflowLow(MachineEnums::ALARM_NA_STATE);
                            }//
                            if(!isAlarmNA(pData->getAlarmDownflowLow())) {
                                pData->setAlarmDownflowLow(MachineEnums::ALARM_NA_STATE);
                            }//
                            if(!isAlarmNA(pData->getAlarmDownflowHigh())) {
                                pData->setAlarmDownflowHigh(MachineEnums::ALARM_NA_STATE);
                            }//
                        }//
                    }//

                    ////CABINET TYPE A, EXAMPLE LA2
                    if(pData->getSeasInstalled()){
                        //DEPENDING_TO_BLOWER_STATE
                        //DEPENDING_TO_AF_CALIBRATION_STATUS
                        //ONLY_IF_BLOWER_IS_ON
                        short alarm = pData->getAlarmSeasPressureLow();
                        if((isFanStateNominal() && isAirflowHasCalibrated()) && pData->getAirflowMonitorEnable()){
                            int actual  = pData->getSeasPressureDiffPa();
                            int fail    = pData->getSeasPressureDiffPaLowLimit();

                            //                    printf("%d %d %s", actual, fail, (actual >= fail) ? "Bigger" : "Less");
                            //                    fflush(stdout);

                            if(actual >= fail){
                                //EXHAUST IS FAIL
                                if(!isAlarmActive(alarm)){
                                    /// SET ALARM EXHAUST
                                    pData->setSeasAlarmPressureLow(MachineEnums::ALARM_ACTIVE_STATE);

                                    /// INSERT ALARM LOG
                                    QString text = QString("%1 (%2)")
                                                       .arg(_tr(ALARM_LOG_TEXT_SEAS_TOO_HIGH), pData->getSeasPressureDiffStr());
                                    _insertAlarmLog(ALARM_LOG_CODE::ALC_SEAS_HIGH, text);
                                }
                            }
                            else {
                                //EXHAUST IS NORMAL
                                if(!isAlarmNormal(alarm)){
                                    //UNSET ALARM EXHAUST
                                    pData->setSeasAlarmPressureLow(MachineEnums::ALARM_NORMAL_STATE);

                                    /// INSERT ALARM LOG
                                    QString text = QString("%1 (%2)")
                                                       .arg(_tr(ALARM_LOG_TEXT_SEAS_OK), pData->getSeasPressureDiffStr());
                                    _insertAlarmLog(ALARM_LOG_CODE::ALC_SEAS_OK, text);
                                }
                            }
                        }
                        else {
                            if (!isAlarmNA(alarm)) {
                                //NOT APPLICABLE ALARM EXHAUST
                                pData->setSeasAlarmPressureLow(MachineEnums::ALARM_NA_STATE);
                            }
                        }
                    }
                }
            }
            break;
            case MachineEnums::SASH_STATE_UNSAFE_SSV:
            {
                //            ////MOTORIZE SASH
                //            if(pData->getHydraulicMotorizedInstalled()){

                //                if(pData->getSashWindowMotorizeUpInterlocked()){
                //                    m_pHydraulicMotorize->setInterlockUp(MachineEnums::DIG_STATE_ZERO);
                //                }

                //                if(pData->getSashWindowMotorizeDownInterlocked()){
                //                    m_pHydraulicMotorize->setInterlockDown(MachineEnums::DIG_STATE_ZERO);
                //                }
                //            }

                ///LOCK FAN IF CURRENT STATE OFF
                if(!pData->getFanPrimaryState()){
                    if(!pData->getFanPrimaryInterlocked()){
                        _setFanPrimaryInterlocked(MachineEnums::DIG_STATE_ONE);
                    }
                }//

                /// MakeSure The Lam in Off state while in Unsafe Sash
                if(pData->getLightState() != MachineEnums::FAN_STATE_OFF){
                    if(pData->getLightInterlocked())
                        m_pLight->setInterlock(MachineEnums::DIG_STATE_ZERO);
                    setLightState(MachineEnums::FAN_STATE_OFF);
                }//
                /// LOCK LAMP after it's turned OFF
                if(!pData->getLightInterlocked() && pData->getLightState() == MachineEnums::FAN_STATE_OFF){
                    m_pLight->setInterlock(MachineEnums::DIG_STATE_ONE);
                }//

                //LOCK UV IF DEVICE INSTALLED
                if(pData->getUvInstalled()){
                    if(!pData->getUvInterlocked()){
                        m_pUV->setInterlock(MachineEnums::DIG_STATE_ONE);
                    }
                }

                //LOCK GAS IF DEVICE INSTALLED
                if(pData->getGasInstalled()){
                    if(!pData->getGasInterlocked()){
                        m_pGas->setInterlock(MachineEnums::DIG_STATE_ONE);
                    }
                }

                ////ALARM
                if(isAlarmActive(pData->getAlarmBoardComError())){
                    /// THERE IS COMMUNICATION ERROR BETWEEN BOARD
                    /// IN THIS SITUATION, AIRFLOW ALARM AND SASH ALARM NOT APPLICABLE (NA)

                    if(!isAlarmNA(pData->getAlarmSash())){
                        pData->setAlarmSash(MachineEnums::ALARM_SASH_NA_STATE);
                    }
                }
                else {
                    ////SET ALARM SASH
                    if(pData->getAlarmSash() != MachineEnums::ALARM_SASH_ACTIVE_UNSAFE_STATE){
                        pData->setAlarmSash(MachineEnums::ALARM_SASH_ACTIVE_UNSAFE_STATE);

                        ///update to alarm log
                        _insertAlarmLog(ALARM_LOG_CODE::ALC_SASH_WINDOW_UNSAFE,
                                        _tr(ALARM_LOG_TEXT_SASH_UNSAFE));
                    }
                }

                //// NA ALARM STANDBY FAN OFF
                if(!isAlarmNA(pData->getAlarmStandbyFanOff())){
                    pData->setAlarmStandbyFanOff(MachineEnums::ALARM_NA_STATE);
                }//

                ////NA ALARM AIRFLOW
                if(!isAlarmNA(pData->getAlarmInflowLow())){
                    pData->setAlarmInflowLow(MachineEnums::ALARM_NA_STATE);
                }//

                if (!isAlarmNA(pData->getAlarmTempHigh())) {
                    pData->setAlarmTempHigh(MachineEnums::ALARM_NA_STATE);
                }//
                if (isAlarmNA(pData->getAlarmTempLow())) {
                    pData->setAlarmTempLow(MachineEnums::ALARM_NA_STATE);
                }//
                //            /// CLEAR FLAG OF SASH STATE FLAG
                //            if(m_pSashWindow->isSashStateChanged() && pData->getSashWindowStateChangedValid()){
                //                m_pSashWindow->clearFlagSashStateChanged();
                //            }
            }//
            break;
            case MachineEnums::SASH_STATE_FULLY_CLOSE_SSV:
            {
                /// MakeSure The Fan in Off state while in FullyClosed Sash
                if(pData->getFanPrimaryState() != MachineEnums::FAN_STATE_OFF){
                    if(pData->getFanPrimaryInterlocked())
                        _setFanPrimaryInterlocked(MachineEnums::DIG_STATE_ZERO);
                    emit pData->fanPrimarySwithingStateTriggered(MachineEnums::DIG_STATE_ZERO);
                    setFanState(MachineEnums::FAN_STATE_OFF);
                }

                //LOCK FAN after it's turned OFF
                if(!pData->getFanPrimaryInterlocked() && pData->getFanPrimaryState() == MachineEnums::FAN_STATE_OFF){
                    _setFanPrimaryInterlocked(MachineEnums::DIG_STATE_ONE);
                }//

                //LOCK LAMP
                if(!pData->getLightInterlocked()){
                    m_pLight->setInterlock(MachineEnums::DIG_STATE_ONE);
                }

                //UNLOCK UV IF DEVICE INSTALLED
                if(pData->getUvInstalled()){
                    if(pData->getUvInterlocked()){
                        m_pUV->setInterlock(MachineEnums::DIG_STATE_ZERO);
                    }
                }

                //LOCK GAS IF DEVICE INSTALLED
                if(pData->getGasInstalled()){
                    if(!pData->getUvInterlocked()){
                        m_pGas->setInterlock(MachineEnums::DIG_STATE_ONE);
                    }
                }

                ////NO APPLICABLE
                if(!isAlarmNA(pData->getAlarmSash())){
                    setBuzzerState(MachineEnums::DIG_STATE_ZERO);
                    pData->setAlarmSash(MachineEnums::ALARM_SASH_NA_STATE);
                }
                //// NA ALARM STANDBY FAN OFF
                if(!isAlarmNA(pData->getAlarmStandbyFanOff())){
                    pData->setAlarmStandbyFanOff(MachineEnums::ALARM_NA_STATE);
                }
                ///NO APPLICABLE AIRFLOW ALARM IF THE SASH NOT IN WORKING HEIGHT
                if(!isAlarmNA(pData->getAlarmInflowLow())){
                    pData->setAlarmInflowLow(MachineEnums::ALARM_NA_STATE);
                }
                //            //UNSET EXHAUST ALARM IF EXIST
                //            if(pData->dataExhPressureInstalled()){
                //                if(pData->dataExhPressureAlarm()){
                //                    pData->setDataExhPressureAlarm(MachineEnums::DIG_STATE_ZERO);
                //                }
                //            }
                if (!isAlarmNA(pData->getAlarmTempHigh())) {
                    pData->setAlarmTempHigh(MachineEnums::ALARM_NA_STATE);
                }
                if (isAlarmNA(pData->getAlarmTempLow())) {
                    pData->setAlarmTempLow(MachineEnums::ALARM_NA_STATE);
                }
                //            /// CLEAR FLAG OF SASH STATE FLAG
                //            if(m_pSashWindow->isSashStateChanged() && pData->getSashWindowStateChangedValid()){
                //                m_pSashWindow->clearFlagSashStateChanged();
                //            }
            }
            break;
            case MachineEnums::SASH_STATE_STANDBY_SSV:
            {
                ////LOCK LAMP
                if(!pData->getLightInterlocked()){
                    m_pLight->setInterlock(MachineEnums::DIG_STATE_ONE);
                }

                ////LOCK UV IF DEVICE INSTALLED
                if(pData->getUvInstalled()){
                    if(!pData->getUvInterlocked()){
                        m_pUV->setInterlock(MachineEnums::DIG_STATE_ONE);
                    }
                }

                //LOCK GAS IF DEVICE INSTALLED
                if(pData->getGasInstalled()){
                    if(!pData->getGasInterlocked()){
                        m_pGas->setInterlock(MachineEnums::DIG_STATE_ONE);
                    }
                }

                //UNLOCK FAN
                if(pData->getFanPrimaryInterlocked()){
                    _setFanPrimaryInterlocked(MachineEnums::DIG_STATE_ZERO);
                }

                /// ALARM STANDBY FAN OFF
                if(!isFanStateStandby()) {
                    if(!isAlarmActive(pData->getAlarmStandbyFanOff())){
                        pData->setAlarmStandbyFanOff(MachineEnums::ALARM_ACTIVE_STATE);
                        /// INSERT ALARM LOG
                        QString text = QString("%1").arg(_tr(ALARM_LOG_TEXT_FAN_STB_OFF_ACTIVE));
                        _insertAlarmLog(ALARM_LOG_CODE::ALC_STB_FAN_OFF_ACTIVE, text);
                    }
                }else{
                    if(isAlarmActive(pData->getAlarmStandbyFanOff())){
                        pData->setAlarmStandbyFanOff(MachineEnums::ALARM_NORMAL_STATE);
                        /// INSERT ALARM LOG
                        QString text = QString("%1").arg(_tr(ALARM_LOG_TEXT_FAN_STB_OFF_OK));
                        _insertAlarmLog(ALARM_LOG_CODE::ALC_STB_FAN_OFF_INACTIVE, text);
                    }
                }//

                ///ALARM
                if(isAlarmActive(pData->getAlarmBoardComError())){
                    /// THERE IS COMMUNICATION ERROR BETWEEN BOARD
                    /// IN THIS SITUATION, AIRFLOW ALARM AND SASH ALARM NOT APPLICABLE (NA)
                    if(!isAlarmNA(pData->getAlarmSash())){
                        pData->setAlarmSash(MachineEnums::ALARM_SASH_NA_STATE);
                    }
                }
                else {
                    /// FAN IS IN STANDBY SPEED
                    //if(isFanStateStandby()){
                    ////UNSET ALARM SASH
                    if(!isAlarmNA(pData->getAlarmSash())){
                        pData->setAlarmSash(MachineEnums::ALARM_SASH_NA_STATE);
                    }
                    //}
                    //                else {
                    //                    if (!isAlarmActive(pData->getAlarmSash())){
                    //                        pData->setAlarmSash(MachineEnums::ALARM_SASH_ACTIVE_UNSAFE_STATE);

                    //                _insertAlarmLog(ALARM_LOG_CODE::ALC_SASH_WINDOW_UNSAFE,
                    //                                _tr(ALARM_LOG_TEXT_SASH_UNSAFE));
                    //            }
                    // }
                }

                ///NO AVAILABLE AIRFLOW ALARM IF THE SASH NOT IN WORKING HEIGHT
                if(!isAlarmNA(pData->getAlarmInflowLow())){
                    pData->setAlarmInflowLow(MachineEnums::ALARM_NA_STATE);
                }

                //            //UNSET EXHAUST ALARM IF EXIST
                //            if(pData->dataExhPressureInstalled()){
                //                if(pData->dataExhPressureAlarm()){
                //                    pData->setDataExhPressureAlarm(MachineEnums::DIG_STATE_ZERO);
                //                }
                //            }

                if (!isAlarmNA(pData->getAlarmTempHigh())) {
                    pData->setAlarmTempHigh(MachineEnums::ALARM_NA_STATE);
                }
                if (!isAlarmNA(pData->getAlarmTempLow())) {
                    pData->setAlarmTempLow(MachineEnums::ALARM_NA_STATE);
                }

                //            /// CLEAR FLAG OF SASH STATE FLAG
                //            if(m_pSashWindow->isSashStateChanged() && pData->getSashWindowStateChangedValid()){
                //                m_pSashWindow->clearFlagSashStateChanged();
                //            }
                break;
            }
            case MachineEnums::SASH_STATE_FULLY_OPEN_SSV:
            {
                ///LOCK FAN IF CURRENT STATE OFF
                if(!pData->getFanPrimaryDutyCycle()){
                    if(pData->getFanPrimaryInterlocked()){
                        _setFanPrimaryInterlocked(MachineEnums::DIG_STATE_ZERO);
                    }
                }

                //UNLOCK LAMP
                if(pData->getLightInterlocked()){
                    m_pLight->setInterlock(MachineEnums::DIG_STATE_ZERO);
                }

                //LOCK UV IF DEVICE INSTALLED
                if(pData->getUvInstalled()){
                    if(!pData->getUvInterlocked()){
                        m_pUV->setInterlock(MachineEnums::DIG_STATE_ONE);
                    }
                }

                //LOCK GAS IF DEVICE INSTALLED
                if(pData->getGasInstalled()){
                    if(!pData->getGasInterlocked()){
                        m_pGas->setInterlock(MachineEnums::DIG_STATE_ONE);
                    }
                }

                ///ALARMs
                if(isAlarmActive(pData->getAlarmBoardComError())){
                    /// THERE IS COMMUNICATION ERROR BETWEEN BOARD
                    /// IN THIS SITUATION, AIRFLOW ALARM AND SASH ALARM IS NOT APPLICABLE (NA)

                    if(!isAlarmNA(pData->getAlarmSash())){
                        pData->setAlarmSash(MachineEnums::ALARM_SASH_NA_STATE);
                    }
                }
                else {
                    ////SET ALARM SASH
                    if(pData->getAlarmSash() != MachineEnums::ALARM_SASH_ACTIVE_FO_STATE){
                        pData->setAlarmSash(MachineEnums::ALARM_SASH_ACTIVE_FO_STATE);

                        _insertAlarmLog(ALARM_LOG_CODE::ALC_SASH_WINDOW_FULLY_OPEN,
                                        _tr(ALARM_LOG_TEXT_SASH_FO));
                    }
                }
                //// NA ALARM STANDBY FAN OFF
                if(!isAlarmNA(pData->getAlarmStandbyFanOff())){
                    pData->setAlarmStandbyFanOff(MachineEnums::ALARM_NA_STATE);
                }
                ///NO APPLICABLE AIRFLOW ALARM IF THE SASH NOT IN WORKING HEIGHT
                if(!isAlarmNA(pData->getAlarmInflowLow())){
                    pData->setAlarmInflowLow(MachineEnums::ALARM_NA_STATE);
                }

                //            //UNSET EXHAUST ALARM IF EXIST
                //            if(pData->dataExhPressureInstalled()){
                //                if(pData->dataExhPressureAlarm()){
                //                    pData->setDataExhPressureAlarm(MachineEnums::DIG_STATE_ZERO);
                //                }
                //            }

                if (!isAlarmNA(pData->getAlarmTempHigh())) {
                    pData->setAlarmTempHigh(MachineEnums::ALARM_NA_STATE);
                }
                if (isAlarmNA(pData->getAlarmTempLow())) {
                    pData->setAlarmTempLow(MachineEnums::ALARM_NA_STATE);
                }
                //            /// CLEAR FLAG OF SASH STATE FLAG
                //            if(m_pSashWindow->isSashStateChanged() && pData->getSashWindowStateChangedValid()){
                //                m_pSashWindow->clearFlagSashStateChanged();
                //            }
                break;
            }
            default:
                //SASH SENSOR ERROR
                {
                    //LOCK FAN
                    if(!pData->getFanPrimaryInterlocked()){
                        if(!pData->getFanPrimaryState()){
                            _setFanPrimaryInterlocked(MachineEnums::DIG_STATE_ONE);
                        }
                    }

                    //LOCK LAMP
                    if(!pData->getLightInterlocked()){
                        m_pLight->setInterlock(MachineEnums::DIG_STATE_ONE);
                    }

                    //LOCK UV IF DEVICE INSTALLED
                    if(pData->getUvInstalled()){
                        if(!pData->getUvInterlocked()){
                            m_pUV->setInterlock(MachineEnums::DIG_STATE_ONE);
                        }
                    }

                    //LOCK GAS IF DEVICE INSTALLED
                    if(pData->getGasInstalled()){
                        if(!pData->getGasInterlocked()){
                            m_pGas->setInterlock(MachineEnums::DIG_STATE_ONE);
                        }
                    }

                    ///ALARMS
                    if(isAlarmActive(pData->getAlarmBoardComError())){
                        /// THERE IS COMMUNICATION ERROR BETWEEN BOARD
                        /// IN THIS SITUATION, AIRFLOW ALARM AND SASH ALARM NOT APPLICABLE (NA)

                        if(!isAlarmNA(pData->getAlarmSash())){
                            pData->setAlarmSash(MachineEnums::ALARM_SASH_NA_STATE);
                        }
                    }
                    else {
                        ////SET ALARM SASH
                        if(pData->getAlarmSash() != MachineEnums::ALARM_SASH_ACTIVE_ERROR_STATE){
                            pData->setAlarmSash(MachineEnums::ALARM_SASH_ACTIVE_ERROR_STATE);

                            _insertAlarmLog(ALARM_LOG_CODE::ALC_SASH_WINDOW_ERROR,
                                            _tr(ALARM_LOG_TEXT_SASH_ERROR));
                        }
                    }

                    //// NA ALARM STANDBY FAN OFF
                    if(!isAlarmNA(pData->getAlarmStandbyFanOff())){
                        pData->setAlarmStandbyFanOff(MachineEnums::ALARM_NA_STATE);
                    }

                    ///NO APPLICABLE AIRFLOW ALARM IF THE SASH NOT IN WORKING HEIGHT
                    if(!isAlarmNA(pData->getAlarmInflowLow())){
                        pData->setAlarmInflowLow(MachineEnums::ALARM_NA_STATE);
                    }

                    //            //UNSET EXHAUST ALARM IF EXIST
                    //            if(pData->dataExhPressureInstalled()){
                    //                if(pData->dataExhPressureAlarm()){
                    //                    pData->setDataExhPressureAlarm(MachineEnums::DIG_STATE_ZERO);
                    //                }
                    //            }

                    if (!isAlarmNA(pData->getAlarmTempHigh())) {
                        pData->setAlarmTempHigh(MachineEnums::ALARM_NA_STATE);
                    }
                    if (!isAlarmNA(pData->getAlarmTempLow())) {
                        pData->setAlarmTempLow(MachineEnums::ALARM_NA_STATE);
                    }
                    //            /// CLEAR FLAG OF SASH STATE FLAG
                    //            if(m_pSashWindow->isSashStateChanged() && pData->getSashWindowStateChangedValid()){
                    //                m_pSashWindow->clearFlagSashStateChanged();
                    //            }
                }
                break;
            }
            //////////////////////////////////////////////CONDITION BY SASH - END
        }
        //////////////////////////////CONDITION BY MODE NORMAL OR QUICKSTART - END
        break;
    case MachineEnums::MODE_OPERATION_MAINTENANCE:
    {
        /////CLEAR INTERLOCK FAN
        if(pData->getFanPrimaryInterlocked()){
            _setFanPrimaryInterlocked(MachineEnums::DIG_STATE_ZERO);
        }

        ////CLEAR LIGHT GAS
        if(pData->getLightInterlocked()){
            m_pLight->setInterlock(MachineEnums::DIG_STATE_ZERO);
        }

        ////CLEAR INTERLOCK GAS IF DEVICE INSTALLED
        if(pData->getGasInstalled()){
            if (pData->getGasInterlocked()){
                m_pGas->setInterlock(MachineEnums::DIG_STATE_ZERO);
            }
        }

        ////CLEAR INTERLOCK UV IF DEVICE INSTALLED
        if(pData->getUvInstalled()){
            if(pData->getUvInterlocked()){
                m_pUV->setInterlock(MachineEnums::DIG_STATE_ZERO);
            }
        }

        /// CLEAR ALARM
        if(!isAlarmNA(pData->getAlarmSash())){
            pData->setAlarmSash(MachineEnums::ALARM_SASH_NA_STATE);
        }
        if(!isAlarmNA(pData->getAlarmInflowLow())){
            pData->setAlarmInflowLow(MachineEnums::ALARM_NA_STATE);
        }
        if(!isAlarmNA(pData->getAlarmSeasPressureLow())){
            pData->setSeasAlarmPressureLow(MachineEnums::ALARM_NA_STATE);
        }
        if(!isAlarmNA(pData->getSeasFlapAlarmPressure())){
            pData->setSeasFlapAlarmPressure(MachineEnums::ALARM_NA_STATE);
        }
        if (!isAlarmNA(pData->getAlarmTempHigh())) {
            pData->setAlarmTempHigh(MachineEnums::ALARM_NA_STATE);
        }
        if (!isAlarmNA(pData->getAlarmTempLow())) {
            pData->setAlarmTempLow(MachineEnums::ALARM_NA_STATE);
        }
        //// NA ALARM STANDBY FAN OFF
        if(!isAlarmNA(pData->getAlarmStandbyFanOff())){
            pData->setAlarmStandbyFanOff(MachineEnums::ALARM_NA_STATE);
        }
        /// cleared mute audible alarm
        if (pData->getMuteAlarmState()){
            pData->setMuteAlarmState(MachineEnums::DIG_STATE_ZERO);
            _cancelMuteAlarmTimer();
        }

        /// clearm warming up state
        if (pData->getWarmingUpActive()){
            _cancelWarmingUpTime();
        }

        /// clearm post purge up state
        if (pData->getPostPurgingActive()){
            _cancelPostPurgingTime();
        }

        //        /// CLEAR FLAG OF SASH STATE FLAG
        //        if(m_pSashWindow->isSashStateChanged()){
        //            m_pSashWindow->clearFlagSashStateChanged();
        //        }
    }
    break;
    }


    bool alarms = false;
    //Check The Alarms Only when SBC used is the registered SBC
    if(pData->getSbcCurrentSerialNumberKnown())
    {
        alarms |= isAlarmActive(pData->getAlarmBoardComError());
        alarms |= isAlarmActive(pData->getAlarmInflowLow());
        alarms |= isAlarmActive(pData->getAlarmDownflowLow());
        alarms |= isAlarmActive(pData->getAlarmDownflowHigh());
        alarms |= isAlarmActive(pData->getAlarmSeasPressureLow());
        alarms |= isAlarmActive(pData->getSeasFlapAlarmPressure());
        alarms |= isAlarmActive(pData->getAlarmSash());
        alarms |= isAlarmActive(pData->getAlarmTempHigh());
        alarms |= isAlarmActive(pData->getAlarmTempLow());
        alarms |= isAlarmActive(pData->getAlarmStandbyFanOff());
        alarms |= isAlarmActive(pData->getSashCycleMotorLockedAlarm());
        alarms |= isAlarmActive(pData->getAlarmExperimentTimerIsOver());
        //    alarms = false;
        //    qDebug() << "alarms" << alarms;
        {
            int currentAlarm = pData->getAlarmsState();
            if (currentAlarm != alarms) {
                pData->setAlarmsState(alarms);

                //            qDebug() << "Audible Alarm" << pData->getMuteAlarmState() << pData->getVivariumMuteState();

                /// clear the mute of audible alarm
                if (pData->getMuteAlarmState()  && !pData->getVivariumMuteState()){
                    pData->setMuteAlarmState(MachineEnums::DIG_STATE_ZERO);
                    _cancelMuteAlarmTimer();
                }

                /// open the eyes, bolototkeun!
                _wakeupLcdBrightnessLevel();
            }
        }
    }else{
        pData->setAlarmsState(alarms);
    }

    //RELAY CONTACT STATE FOR BLOWER INDICATION
    //SET RELAY CONTACT ALARM IF INTERNAL BLOWER ON/STANDBY
    //OTHERWISE UNSET
    if(pData->getFanPrimaryState()){
        if(!pData->getExhaustContactState())
            setExhaustContactState(MachineEnums::DIG_STATE_ONE);
    }else{
        if(pData->getExhaustContactState())
            setExhaustContactState(MachineEnums::DIG_STATE_ZERO);
    }

    //RELAY CONTACT STATE FOR BLOWER INDICATION
    //SET RELAY CONTACT ALARM IF INTERNAL BLOWER ON/STANDBY
    //OTHERWISE UNSET
    if(pData->getAlarmsState()){
        if(!pData->getAlarmContactState())
            setAlarmContactState(MachineEnums::DIG_STATE_ONE);
    }else{
        if(pData->getAlarmContactState())
            setAlarmContactState(MachineEnums::DIG_STATE_ZERO);
        if(m_pBuzzer->getState()){
            setBuzzerState(false);
        }
    }//

    /// MODBUS ALARM STATUS
    _setModbusRegHoldingValue(modbusRegisterAddress.AlarmBoardCom.addr, static_cast<ushort>(pData->getAlarmBoardComError()));
    _setModbusRegHoldingValue(modbusRegisterAddress.AlarmSash.addr, static_cast<ushort>(pData->getAlarmSash()));
    _setModbusRegHoldingValue(modbusRegisterAddress.AlarmInflowLow.addr, static_cast<ushort>(pData->getAlarmInflowLow()));
    _setModbusRegHoldingValue(modbusRegisterAddress.AlarmTempLow.addr, static_cast<ushort>(pData->getAlarmTempLow()));
    _setModbusRegHoldingValue(modbusRegisterAddress.AlarmTempHigh.addr, static_cast<ushort>(pData->getAlarmTempHigh()));
    _setModbusRegHoldingValue(modbusRegisterAddress.AlarmSashCycleMotorLocked.addr, static_cast<ushort>(pData->getSashCycleMotorLockedAlarm()));
    _setModbusRegHoldingValue(modbusRegisterAddress.AlarmStbFanOff.addr, static_cast<ushort>(pData->getAlarmStandbyFanOff()));
    if(pData->getSeasInstalled()){
        _setModbusRegHoldingValue(modbusRegisterAddress.AlarmExhaustLow.addr, static_cast<ushort>(pData->getAlarmSeasPressureLow()));
    }
    if(pData->getSeasFlapInstalled()){
        _setModbusRegHoldingValue(modbusRegisterAddress.AlarmFlapExhaust.addr, static_cast<ushort>(pData->getSeasFlapAlarmPressure()));
    }

    //    /// CLEAR FLAG OF SASH STATE FLAG
    //    if(m_pSashWindow->isSashStateChanged()){
    //        m_pSashWindow->clearFlagSashStateChanged();
    //    }
}

void MachineBackend::_setSoftwareUpdateAvailable(const QString &swu, const QString &path, QJsonObject history)
{
    qDebug() << metaObject()->className() << __FUNCTION__ << thread();
    //    qDebug() << sysInfo;

    QSettings settings;
    settings.setValue(SKEY_SBC_SWU_AVAILABLE, true);
    settings.setValue(SKEY_SBC_SWU_VERSION, swu);
    settings.setValue(SKEY_SBC_SWU_PATH, path);

    pData->setSvnUpdateAvailable(true);
    pData->setSvnUpdateSwuVersion(swu);
    pData->setSvnUpdatePath(path);
    pData->setSvnUpdateHistory(history);

    qWarning() << "Software Update available:" << swu << path;
    qWarning() << history;
}

void MachineBackend::_setSoftwareUpdateAvailableReset()
{
    qDebug() << metaObject()->className() << __FUNCTION__ << thread();
    //    qDebug() << sysInfo;
    if(!pData->getSvnUpdateAvailable())return;

    QSettings settings;
    settings.setValue(SKEY_SBC_SWU_AVAILABLE, false);

    pData->setSvnUpdateAvailable(false);
}

void MachineBackend::_readResourceMonitorParams()
{
    ///$CPUUSAGE $CPUTEMP $MEMUSAGE
    QString resMonOut = "00#00#00#{\"healthStatusPercentUsed\":2}";
    QStringList resMonParams;

#ifdef __linux__
    QProcess qprocess;
    qprocess.start("resmon", QStringList() << "all");
    qprocess.waitForFinished();
    if(!qprocess.exitCode()){
        resMonOut = qprocess.readAllStandardOutput();
    }
#endif
    resMonOut.replace("\n", "");
    for(short i=0; i<resMonOut.split("#").length(); i++){
        if(i == MachineEnums::ResMon_SD_Card_Life){
            QString healtStr = "";
            QByteArray jsonData = resMonOut.split("#")[i].toLocal8Bit();
            if(jsonData.isEmpty() == true) qDebug() << "Need to fill JSON data";
            QJsonDocument sdCardInfoJsDoc = QJsonDocument::fromJson(jsonData);
            if(sdCardInfoJsDoc.isObject() == false){
                qDebug() << "It is not a JSON Object";
                qDebug() << jsonData;
                healtStr = "99";
            }//
            else{
                QJsonObject jsonDataObject = sdCardInfoJsDoc.toVariant().toJsonObject();
                short health = 100;
                if(jsonDataObject["healthStatusPercentUsed"].isUndefined())
                    health -= 1;
                else
                    health -= (jsonDataObject["healthStatusPercentUsed"].toInt());
                healtStr = QString::number(health);
            }
            resMonParams.append(healtStr);
        }
        else
            resMonParams.append(resMonOut.split("#")[i]);
    }//

    qDebug() << resMonParams;
    pData->setResourceMonitorParams(resMonParams);
}

QJsonObject MachineBackend::_getRpListDefaultJsonObj() const
{
    // Determine the dbDefault QJsonObject
    QJsonObject dbDefault = pData->getRpListDefault();

    bool advDbEnabled = pData->getRpExtDatabaseEnable() && !pData->getRpExtDefault().isEmpty();
    QString unitModel = pData->getRpListLastAtIndex(MachineEnums::RPList_UnitModel);

    QJsonObject jsObj = pData->getMachineProfile();
    QJsonObject cabinetWidth = jsObj.value("width").toObject();
    int cabinetSize = cabinetWidth.value("feet").toInt();
    QString cabSize = QString("%1ft").arg(cabinetSize);

    QString ratPower = "230v";
    char unitModelChar[20];
    strcpy(unitModelChar, unitModel.toStdString().c_str());
    if(unitModelChar[6] == '7' || unitModelChar[6] == '9'){
        ratPower = "115v";
    }else if(unitModelChar[6] == '8'){
        ratPower = "230v";
    }else{
        qWarning() << "Unit Model format is not correct!" << unitModel;
    }

    if(advDbEnabled && !pData->getRpExtDefault().value("LA2").toObject().value(cabSize).toObject().value(ratPower).isUndefined()){
        QJsonObject jsObj = pData->getRpExtDefault().value("LA2").toObject().value(cabSize).toObject().value(ratPower).toObject();
        dbDefault = jsObj;
        qDebug() << "Advanced Database Default is successfully loaded";
    }

    return dbDefault;
}

QString MachineBackend::_getRpListDefaultValue(const QJsonObject dbDefault, short index)
{
    //qDebug() << metaObject()->className() << __FUNCTION__ << thread();

    QString retStr = "";

    if(index < MachineEnums::RPList_SBCSet1Name){
        switch(index){
        case MachineEnums::RPList_UnitModel: retStr = pData->getRpListLastAtIndex(MachineEnums::RPList_UnitModel); break; // don't reset the Model
        case MachineEnums::RPList_UnitSerialNumber: retStr = pData->getSerialNumber(); break;
        case MachineEnums::RPList_Date: break;
        case MachineEnums::RPList_Time: break;
        case MachineEnums::RPList_UserManualCode: break;
        case MachineEnums::RPList_UserManualVersion: break;
        case MachineEnums::RPList_ElectricalPanel: break;
        case MachineEnums::RPList_ElectricalPanelSerialNumber: break;
        case MachineEnums::RPList_ElectricalTester: break;
        }
    }
    else if((index >= MachineEnums::RPList_SBCSet1Name)
             && (index <= MachineEnums::RPList_SBCSet15Qty)){
        bool isName = index < MachineEnums::RPList_SBCSet1Code;
        bool isCode = !isName && (index < MachineEnums::RPList_SBCSet1Qty);
        //bool isQty = !isName && !isCode;
        short startIndex = isName ? MachineEnums::RPList_SBCSet1Name
                                  : (isCode ? MachineEnums::RPList_SBCSet1Code
                                            : MachineEnums::RPList_SBCSet1Qty);
        QString key = isName ? "desc" : (isCode ? "id" : "qty");
        QJsonArray defArray = dbDefault["sbcSet"].toArray();
        if(!defArray[index-startIndex].isUndefined()){
            QJsonObject defObj = defArray[index-startIndex].toObject();
            retStr = defObj[key].toString();
        }//
    }//
    else if(index == MachineEnums::RPList_SBCSet1SN){
        retStr = pData->getSbcSerialNumber();
    }
    else if(index == MachineEnums::RPList_SBCSet2SN || index == MachineEnums::RPList_SBCSet2SW){
        if(index == MachineEnums::RPList_SBCSet2SW){
            QSettings settings;
            retStr = settings.value(SKEY_SBC_SOFTWARE_VERSION, "").toString();
        }
        else{
#ifdef __arm__
            QProcess qProcess;
            qProcess.start("cat", QStringList() << "/sys/block/mmcblk0/device/serial");
            qProcess.waitForFinished();
            retStr = qProcess.readAllStandardOutput();
#else
            retStr = "0x16cb20ed";
#endif
        }//
    }//
    else if(index >= MachineEnums::RPList_Sensor1Name && index <= MachineEnums::RPList_Sensor5Qty){
        bool isName = index < MachineEnums::RPList_Sensor1Code;
        bool isCode = !isName && (index < MachineEnums::RPList_Sensor1Qty);
        //bool isQty = !isName && !isCode;
        short startIndex = isName ? MachineEnums::RPList_Sensor1Name
                                  : (isCode ? MachineEnums::RPList_Sensor1Code
                                            : MachineEnums::RPList_Sensor1Qty);
        QString key = isName ? "desc" : (isCode ? "id" : "qty");
        QJsonArray defArray = dbDefault["sensors"].toArray();
        if(!defArray[index-startIndex].isUndefined()){
            QJsonObject defObj = defArray[index-startIndex].toObject();
            retStr = defObj[key].toString();
        }
    }
    else if(index >= MachineEnums::RPList_UVLED1Name && index <= MachineEnums::RPList_UVLED6Qty){
        bool isName = index < MachineEnums::RPList_UVLED1Code;
        bool isCode = !isName && (index < MachineEnums::RPList_UVLED1Qty);
        //bool isQty = !isName && !isCode;
        short startIndex = isName ? MachineEnums::RPList_UVLED1Name
                                  : (isCode ? MachineEnums::RPList_UVLED1Code
                                            : MachineEnums::RPList_UVLED1Qty);
        QString key = isName ? "desc" : (isCode ? "id" : "qty");

        QJsonArray defArray = dbDefault["uvLed"].toArray();
        if(!defArray[index-startIndex].isUndefined()){
            QJsonObject defObj = defArray[index-startIndex].toObject();
            retStr = defObj[key].toString();
        }
    }
    else if(index >= MachineEnums::RPList_PSU1Name && index <= MachineEnums::RPList_PSU5Qty){
        bool isName = index < MachineEnums::RPList_PSU1Code;
        bool isCode = !isName && (index < MachineEnums::RPList_PSU1Qty);
        //bool isQty = !isName && !isCode;
        short startIndex = isName ? MachineEnums::RPList_PSU1Name
                                  : (isCode ? MachineEnums::RPList_PSU1Code
                                            : MachineEnums::RPList_PSU1Qty);
        QString key = isName ? "desc" : (isCode ? "id" : "qty");

        QJsonArray defArray = dbDefault["psu"].toArray();
        if(!defArray[index-startIndex].isUndefined()){
            QJsonObject defObj = defArray[index-startIndex].toObject();
            retStr = defObj[key].toString();
        }
    }
    else if(index >= MachineEnums::RPList_MCBEMI1Name && index <= MachineEnums::RPList_MCBEMI5Qty){
        bool isName = index < MachineEnums::RPList_MCBEMI1Code;
        bool isCode = !isName && (index < MachineEnums::RPList_MCBEMI1Qty);
        //bool isQty = !isName && !isCode;
        short startIndex = isName ? MachineEnums::RPList_MCBEMI1Name
                                  : (isCode ? MachineEnums::RPList_MCBEMI1Code
                                            : MachineEnums::RPList_MCBEMI1Qty);
        QString key = isName ? "desc" : (isCode ? "id" : "qty");

        QJsonArray defArray = dbDefault["mcbEmi"].toArray();
        if(!defArray[index-startIndex].isUndefined()){
            QJsonObject defObj = defArray[index-startIndex].toObject();
            retStr = defObj[key].toString();
        }
    }
    else if(index >= MachineEnums::RPList_ContactSw1Name && index <= MachineEnums::RPList_ContactSw5Qty){
        bool isName = index < MachineEnums::RPList_ContactSw1Code;
        bool isCode = !isName && (index < MachineEnums::RPList_ContactSw1Qty);
        //bool isQty = !isName && !isCode;
        short startIndex = isName ? MachineEnums::RPList_ContactSw1Name
                                  : (isCode ? MachineEnums::RPList_ContactSw1Code
                                            : MachineEnums::RPList_ContactSw1Qty);
        QString key = isName ? "desc" : (isCode ? "id" : "qty");

        QJsonArray defArray = dbDefault["contactSw"].toArray();
        if(!defArray[index-startIndex].isUndefined()){
            QJsonObject defObj = defArray[index-startIndex].toObject();
            retStr = defObj[key].toString();
        }
    }
    else if(index >= MachineEnums::RPList_BMotor1Name && index <= MachineEnums::RPList_BMotor5Qty){
        bool isName = index < MachineEnums::RPList_BMotor1Code;
        bool isCode = !isName && (index < MachineEnums::RPList_BMotor1Qty);
        //bool isQty = !isName && !isCode;
        short startIndex = isName ? MachineEnums::RPList_BMotor1Name
                                  : (isCode ? MachineEnums::RPList_BMotor1Code
                                            : MachineEnums::RPList_BMotor1Qty);
        QString key = isName ? "desc" : (isCode ? "id" : "qty");

        QJsonArray defArray = dbDefault["bMotor"].toArray();
        if(!defArray[index-startIndex].isUndefined()){
            QJsonObject defObj = defArray[index-startIndex].toObject();
            retStr = defObj[key].toString();
        }
    }
    else if(index >= MachineEnums::RPList_CapInd1Name && index <= MachineEnums::RPList_CapInd5Qty){
        bool isName = index < MachineEnums::RPList_CapInd1Code;
        bool isCode = !isName && (index < MachineEnums::RPList_CapInd1Qty);
        //bool isQty = !isName && !isCode;
        short startIndex = isName ? MachineEnums::RPList_CapInd1Name
                                  : (isCode ? MachineEnums::RPList_CapInd1Code
                                            : MachineEnums::RPList_CapInd1Qty);
        QString key = isName ? "desc" : (isCode ? "id" : "qty");

        QJsonArray defArray = dbDefault["capInd"].toArray();
        if(!defArray[index-startIndex].isUndefined()){
            QJsonObject defObj = defArray[index-startIndex].toObject();
            retStr = defObj[key].toString();
        }
    }
    else if(index >= MachineEnums::RPList_Custom1Name && index <= MachineEnums::RPList_Custom8Qty){
        bool isName = index < MachineEnums::RPList_Custom1Code;
        bool isCode = !isName && (index < MachineEnums::RPList_Custom1Qty);
        //bool isQty = !isName && !isCode;
        short startIndex = isName ? MachineEnums::RPList_Custom1Name
                                  : (isCode ? MachineEnums::RPList_Custom1Code
                                            : MachineEnums::RPList_Custom1Qty);
        QString key = isName ? "desc" : (isCode ? "id" : "qty");
        QJsonArray defArray = dbDefault["custom"].toArray();
        if(!defArray[index-startIndex].isUndefined()){
            QJsonObject defObj = defArray[index-startIndex].toObject();
            retStr = defObj[key].toString();
        }
    }
    else if(index >= MachineEnums::RPList_Filter1Name && index <= MachineEnums::RPList_Filter5Qty){
        bool isName = index < MachineEnums::RPList_Filter1Code;
        bool isCode = !isName && (index < MachineEnums::RPList_Filter1Qty);
        //bool isQty = !isName && !isCode;
        short startIndex = isName ? MachineEnums::RPList_Filter1Name
                                  : (isCode ? MachineEnums::RPList_Filter1Code
                                            : MachineEnums::RPList_Filter1Qty);
        QString key = isName ? "desc" : (isCode ? "id" : "qty");

        QJsonArray defArray = dbDefault["filter"].toArray();
        if(!defArray[index-startIndex].isUndefined()){
            QJsonObject defObj = defArray[index-startIndex].toObject();
            retStr = defObj[key].toString();
        }
    }
    return retStr;
}

void MachineBackend::_initCertificationParameters()
{
    QSettings setting;

    //    QString category = "certification";
    const QString keyCertifParamStr[MachineEnums::CertifParamStr_Total] = {
        "serverIPv4",
        "cabinetModel",
        "woNumber",
        "calibProc",
        "calibProcField",
        "testReportNo",
        "certifNo",
        "serialNumber",
        "powerRating",
        "pressRoom",
        "paoCons",
        "dfParPenet",
        "ifParPenet",
        "damperOpen",
        "damperOpenImp",
        "mvInitialDfa",
        "mvInitialIfa",
        "mvInitialDfaImp",
        "mvInitialIfaImp",
        "mvInitialPower",
        "mvBlockDfa",
        "mvBlockIfa",
        "mvBlockDfaImp",
        "mvBlockIfaImp",
        "mvBlockPower",
        "mvFinalDfa",
        "mvFinalIfa",
        "mvFinalDfaImp",
        "mvFinalIfaImp",
        "sensorVdc",
        "testerName",
        "testerSignature",
        "checkerName",
        "checkerSignature",
        "customer",
        "country",
        "dateTest",
        "swVersion",
        //field
        "testerNameField",
        "testerSignatureField",
        "checkerNameField",
        "checkerSignatureField",
        "testReportNoFieldA",
        "testReportNoFieldB"
    };
    const QString certifParamStrDefault[MachineEnums::CertifParamStr_Total] = {
        "192.168.0.18:8000",  //"serverIPv4",
        pData->getMachineModelName(),  //"cabinetModel",
        "",  //"woNumber",
        "FM-TST-BSC-78-D",  //"calibProc",
        "FM-TST-BSC-91-B",  //"calibProcField",
        "FM-TST-TR-A2-01-G",//"testReportNo",
        "FM-TST-CRT-04-B",  //"certifNo",
        pData->getSerialNumber(),  //"serialNumber",
        "220 VAC / 50Hz",  //"powerRating",
        "1.005",  //"pressRoom",
        "0.0005",  //"paoCons",
        "0.0000",  //"dfParPenet",
        "0.0000",  //"ifParPenet",
        "10",  //"damperOpen",
        "2/5",  //"damperOpenImp",
        "0",  //"mvInitialDfa",
        "0",  //"mvInitialIfa",
        "0",  //"mvInitialDfaImp",
        "0",  //"mvInitialIfaImp",
        "0",  //"mvInitialPower",
        "0",  //"mvBlockDfa",
        "0",  //"mvBlockIfa",
        "0",  //"mvBlockDfaImp",
        "0",  //"mvBlockIfaImp",
        "0",  //"mvBlockPower",
        "0",  //"mvFinalDfa",
        "0",  //"mvFinalIfa",
        "0",  //"mvFinalDfaImp",
        "0",  //"mvFinalIfaImp",
        QString::asprintf("%.2f m/s", (pData->getHaBoardInputCh2MVolt()/1000.0)),  //"sensorVdc",
        "",  //"testerName",
        "",  //"testerSignature",
        "",  //"checkerName",
        "",  //"checkerSignature",
        "WORLD",  //"customer",
        "SINGAPORE",  //"country",
        QDateTime().currentDateTime().fromString("dd-MMM-yyyy").toString(),  //"dateTest",
        setting.value(SKEY_SBC_SOFTWARE_VERSION, "").toString(),  //"swVersion"
        //Field
        "", //"testerNameField",
        "", //"testerSignatureField",
        "", //"checkerNameField",
        "",  //"checkerSignatureField",
        "FM-TST-TR-A2-XX-A",//"testReportNoFieldA",
        "FM-TST-TR-A2-XX-A"//"testReportNoFieldB",
    };
    const QString keyCertifParamInt[MachineEnums::CertifParamInt_Total] = {
        "cabinetSize",
        "tempRoom",
        "tempRoomImp",
        "noLaskin",
        "mvInitialFanDucy",
        "mvInitialFanRpm",
        "mvBlockFanDucy",
        "mvBlockFanRpm",
        "mvFinalFanDucy",
        "mvFinalFanRpm",
        "adcActual"
    };

    QJsonObject jsObj = pData->getMachineProfile();
    QJsonObject cabinetWidth = jsObj.value("width").toObject();
    int cabinetSize = cabinetWidth.value("feet").toInt();

    const int certifParamIntDefault[MachineEnums::CertifParamInt_Total] = {
        cabinetSize,  //"cabinetSize",
        pData->getTemperatureCelcius(),  //"tempRoom",
        __convertCtoF(pData->getTemperatureCelcius()),  //"tempRoomImp",
        2,  //"noLaskin",
        0,  //"mvInitialFanDucy",
        0,  //"mvInitialFanRpm",
        0,  //"mvBlockFanDucy",
        0,  //"mvBlockFanRpm",
        0,  //"mvFinalFanDucy",
        0,  //"mvFinalFanRpm",
        pData->getInflowAdcConpensation()   //"adcActual"
    };


    std::copy(keyCertifParamInt, keyCertifParamInt+MachineEnums::CertifParamInt_Total, m_keyCertifParamInt);
    std::copy(keyCertifParamStr, keyCertifParamStr+MachineEnums::CertifParamStr_Total, m_keyCertifParamStr);

    setting.beginGroup("certification");

    //    qDebug() << "After Copy!";
    for(short i=0; i<MachineEnums::CertifParamInt_Total; i++){
        //        qDebug() << m_keyCertifParamInt[i];
        pData->setCertificationParametersInt(i, setting.value(m_keyCertifParamInt[i], certifParamIntDefault[i]).toInt());
    }
    for(short i=0; i<MachineEnums::CertifParamStr_Total; i++){
        //        qDebug() << m_keyCertifParamStr[i];
        pData->setCertificationParametersStr(i, setting.value(m_keyCertifParamStr[i], certifParamStrDefault[i]).toString());
    }

    setting.endGroup();
}//

//void MachineBackend::_initPreventMaintReminder()
//{
//    QScopedPointer<QSettings> m_settings(new QSettings);
//}//

#ifdef QT_DEBUG
void MachineBackend::onDummyStateNewConnection()
{
    QWebSocket *pSocket = m_pWebSocketServerDummyState->nextPendingConnection();

    qDebug() << "Client connected:" << pSocket->peerAddress();

    connect(pSocket, &QWebSocket::textMessageReceived, pSocket, [&](const QString &message){

        qDebug() << "Client textMessageReceived:" << message;

        if(message == QLatin1String("#sash#dummy#1")){
            m_pSashWindow->setDummyStateEnable(1);
        }
        else if(message == QLatin1String("#sash#dummy#0")){
            m_pSashWindow->setDummyStateEnable(0);
        }
        else if(message == QLatin1String("#sash#state#fc")){
            m_pSashWindow->setDummyState(SashWindow::SASH_STATE_FULLY_CLOSE_SSV);
        }
        else if(message == QLatin1String("#sash#state#uh")){
            m_pSashWindow->setDummyState(SashWindow::SASH_STATE_UNSAFE_SSV);
        }
        else if(message == QLatin1String("#sash#state#sh")){
            m_pSashWindow->setDummyState(SashWindow::SASH_STATE_WORK_SSV);
        }
        else if(message == QLatin1String("#sash#state#sb")){
            m_pSashWindow->setDummyState(SashWindow::SASH_STATE_STANDBY_SSV);
        }
        else if(message == QLatin1String("#sash#state#fo")){
            m_pSashWindow->setDummyState(SashWindow::SASH_STATE_FULLY_OPEN_SSV);
        }
        else if(message == QLatin1String("#sash#state#er")){
            m_pSashWindow->setDummyState(SashWindow::SASH_STATE_ERROR_SENSOR_SSV);
        }

        if(message == QLatin1String("#hdi6#dummy#1")){
            m_pSashWindow->setDummy6StateEnable(true);
        }
        else if(message == QLatin1String("#hdi6#dummy#0")){
            m_pSashWindow->setDummy6StateEnable(false);
        }
        else if(message == QLatin1String("#hdi6#state#0")){
            m_pSashWindow->setDummy6State(0);
        }
        else if(message == QLatin1String("#hdi6#state#1")){
            m_pSashWindow->setDummy6State(1);
        }

        if(message == QLatin1String("#fan#dummy#1")){
            QMetaObject::invokeMethod(m_pFanPrimary.data(),[&]{
                    m_pFanPrimary->setDummyStateEnable(1);
                },
                Qt::QueuedConnection);
        }
        else if(message == QLatin1String("#fan#dummy#0")){
            QMetaObject::invokeMethod(m_pFanPrimary.data(),[&]{
                    m_pFanPrimary->setDummyStateEnable(0);
                },
                Qt::QueuedConnection);
        }
        else if(message.contains("#fan#state#")){
            QString adcStr = message.split("#", Qt::SkipEmptyParts)[2];
            int value = std::atoi(adcStr.toStdString().c_str());
            QMetaObject::invokeMethod(m_pFanPrimary.data(),[&, value]{
                    m_pFanPrimary->setDummyState(static_cast<short>(value));
                },
                Qt::QueuedConnection);
        }
        else if(message.contains("#fan#rpm#")){
            QString adcStr = message.split("#", Qt::SkipEmptyParts)[2];
            int value = std::atoi(adcStr.toStdString().c_str());
            QMetaObject::invokeMethod(m_pFanPrimary.data(),[&, value]{
                    m_pFanPrimary->setDummyRpm(value);
                },
                Qt::QueuedConnection);
        }

        if(message == QLatin1String("#lamp#dummy#1")){
            m_pLight->setDummyStateEnable(1);
        }
        else if(message == QLatin1String("#lamp#dummy#0")){
            m_pLight->setDummyStateEnable(0);
        }
        else if(message == QLatin1String("#lamp#state#1")){
            m_pLight->setDummyState(1);
        }
        else if(message == QLatin1String("#lamp#state#0")){
            m_pLight->setDummyState(0);
        }

        if(message == QLatin1String("#socket#dummy#1")){
            m_pSocket->setDummyStateEnable(1);
        }
        else if(message == QLatin1String("#socket#dummy#0")){
            m_pSocket->setDummyStateEnable(0);
        }
        else if(message == QLatin1String("#socket#state#1")){
            m_pSocket->setDummyState(1);
        }
        else if(message == QLatin1String("#socket#state#0")){
            m_pSocket->setDummyState(0);
        }

        if(message == QLatin1String("#gas#dummy#1")){
            m_pGas->setDummyStateEnable(1);
        }
        else if(message == QLatin1String("#gas#dummy#0")){
            m_pGas->setDummyStateEnable(0);
        }
        else if(message == QLatin1String("#gas#state#1")){
            m_pGas->setDummyState(1);
        }
        else if(message == QLatin1String("#gas#state#0")){
            m_pGas->setDummyState(0);
        }

        if(message == QLatin1String("#lampdim#dummy#1")){
            m_pLightIntensity->setDummyStateEnable(1);
        }
        else if(message == QLatin1String("#lampdim#dummy#0")){
            m_pLightIntensity->setDummyStateEnable(0);
        }
        else if(message.contains("#lampdim#state#")){
            QString state = message.split("#", Qt::SkipEmptyParts)[2];
            int dim = std::atoi(state.toStdString().c_str());
            m_pLightIntensity->setDummyState(static_cast<short>(dim));
        }

        if(message == QLatin1String("#uv#dummy#1")){
            m_pUV->setDummyStateEnable(1);
        }
        else if(message == QLatin1String("#uv#dummy#0")){
            m_pUV->setDummyStateEnable(0);
        }
        else if(message == QLatin1String("#uv#state#1")){
            m_pUV->setDummyState(1);
        }
        else if(message == QLatin1String("#uv#state#0")){
            m_pUV->setDummyState(0);
        }

        if(message == QLatin1String("#ifadc#dummy#1")){
            m_pAirflowInflow->setDummyStateEnable(1);
        }
        else if(message == QLatin1String("#ifadc#dummy#0")){
            m_pAirflowInflow->setDummyStateEnable(0);
        }
        else if(message.contains("#ifadc#state#")){
            QString adcStr = message.split("#", Qt::SkipEmptyParts)[2];
            int adc = std::atoi(adcStr.toStdString().c_str());
            m_pAirflowInflow->setDummyState(adc);
        }

        if(message == QLatin1String("#sashmotor#dummy#1")){
            m_pHydraulicMotorize->setDummyStateEnable(1);
        }
        else if(message == QLatin1String("#sashmotor#dummy#0")){
            m_pHydraulicMotorize->setDummyStateEnable(0);
        }
        else if(message == QLatin1String("#sashmotor#state#0")){
            m_pHydraulicMotorize->setDummyState(MachineEnums::MOTOR_SASH_STATE_OFF);
        }
        else if(message == QLatin1String("#sashmotor#state#1")){
            m_pHydraulicMotorize->setDummyState(MachineEnums::MOTOR_SASH_STATE_UP);
        }
        else if(message == QLatin1String("#sashmotor#state#2")){
            m_pHydraulicMotorize->setDummyState(MachineEnums::MOTOR_SASH_STATE_DOWN);
        }

        if(message == QLatin1String("#temp#dummy#1")){
            m_pTemperature->setDummyStateEnable(1);
        }
        else if(message == QLatin1String("#temp#dummy#0")){
            m_pTemperature->setDummyStateEnable(0);
        }
        else if(message.contains("#temp#adc#")){
            QString adcStr = message.split("#", Qt::SkipEmptyParts)[2];
            int value = std::atoi(adcStr.toStdString().c_str());
            m_pTemperature->setDummyAdcState(static_cast<short>(value));
        }
        else if(message.contains("#temp#volt#")){
            QString adcStr = message.split("#", Qt::SkipEmptyParts)[2];
            int value = std::atoi(adcStr.toStdString().c_str());
            m_pTemperature->setDummyMVoltState(value);
        }

        if(message == QLatin1String("#seas#dummy#1")){
            m_pSeas->setDummyStateEnable(1);
        }
        else if(message == QLatin1String("#seas#dummy#0")){
            m_pSeas->setDummyStateEnable(0);
        }
        else if(message.contains("#seas#state#")){
            QString adcStr = message.split("#", Qt::SkipEmptyParts)[2];
            int value = std::atoi(adcStr.toStdString().c_str());
            //            qDebug() << message << value;
            m_pSeas->setDummyState(static_cast<short>(value));
        }
    });
    connect(pSocket, &QWebSocket::disconnected, [=]{
        qDebug() << "Someone disconnected!";
    });

    m_clientsDummyState << pSocket;
}

#endif

//void MachineBackend::_onExhPressureActualPaChanged(int newVal)
//{
//    pData->setDataExhPressureActualPa(newVal);
//}
