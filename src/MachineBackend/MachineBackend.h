#pragma once

#include <QObject>
#include <QScopedPointer>
#include <QJsonArray>
#include <QtDebug>

#ifdef QT_DEBUG
#include <QtWebSockets/QWebSocketServer>
#include <QtWebSockets/QWebSocket>
#endif

#include "MachineEnums.h"

class QSettings;
class QThread;
class QTimer;

class QSerialPort;
class QModbusTcpServer;
class QTcpSocket;
class QModbusTcpConnObserverImp;
#include <QModbusDataUnit>
#include <QTranslator>
#include <QVector>

class SchedulerDayOutput;

class DataLogSql;
class DataLog;
class AlarmLogSql;
class AlarmLog;
class EventLogSql;
class EventLog;
class ReplaceableCompRecordSql;
class ReplaceableCompRecord;
class ResourceMonitorLogSql;
class ResourceMonitorLog;
class BookingScheduleSql;
class BookingSchedule;

class ParticleCounter;
class PressureDiffManager;
class BlowerRbmDsi;
class DeviceAnalogCom;
class SashWindow;
class DeviceDigitalOut;
class MotorizeOnRelay;
class AirflowVelocity;
class Temperature;
class ClassManager;

class BlowerRegalECM;
class RTCpcf8523;
class LEDpca9633;
class AIManage;
class PWMpca9685;
class DIOpca9674;
class AOmcp4725;
class I2CPort;
class BoardIO;
class QGpioSysfs;
class SensirionSPD8xx;
class ParticleCounterZH03B;
class USBAutoMount;

class CheckSWUpdate;

class MachineData;


class MachineBackend : public QObject
{
    Q_OBJECT
public:
    explicit MachineBackend(QObject *parent = nullptr);
    ~MachineBackend() override;

public slots:
    void routineTask();

    void stop();

    void setMachineData(MachineData* data);

    void setMachineProfileID(const QString &value);

    /// API for general
    void setLcdTouched();

    void setLcdBrightnessLevel(short value);
    void setLcdBrightnessDelayToDimm(short value);
    void saveLcdBrightnessLevel(short value);
    void setLcdEnableLockScreen(bool value);

    void saveLanguage(const QString &value);

    void setTimeZone(const QString &value);
    void setDateTime(const QString &value);

    void saveTimeClockPeriod(short value);

    void deleteFileOnSystem(const QString &path);

    void setMuteVivariumState(short value);
    void setMuteAlarmState(short value);
    void setMuteAlarmTime(short value);
    void setMuteAlarmTimeAtFullyOpened(int value);

    void setBuzzerState(bool value);
    void setBuzzerBeep();

    void setSignedUser(const QString &username, const QString &fullname, short userLevel);
    void setUserLastLogin(const QString &username, const QString &fullname);
    void deleteUserLastLogin(const QString &username);

    /// API for Cabinet operational
    void setOperationModeSave(short value);
    void setOperationMaintenanceMode();
    void setOperationPreviousMode();

    /// API for Security Access
    void setSecurityAccessModeSave(short value);

    /// API for Certification reminder
    void setDateCertificationReminder (const QString &reminder);

    //    void setCertificationExpired (bool certificationExpired );

    void setMeasurementUnit(short value);

    void setSerialNumber(const QString &value);

    void setFanState(short value);
    void setFanPrimaryDutyCycle(short value);
    //
    void setFanPrimaryNominalDutyCycleFactory(short value);
    void setFanPrimaryNominalRpmFactory(int value);
    void setFanPrimaryMinimumDutyCycleFactory(short value);
    void setFanPrimaryMinimumRpmFactory(int value);
    void setFanPrimaryStandbyDutyCycleFactory(short value);
    void setFanPrimaryStandbyRpmFactory(int value);
    //
    void setFanPrimaryNominalDutyCycleField(short value);
    void setFanPrimaryNominalRpmField(int value);
    void setFanPrimaryMinimumDutyCycleField(short value);
    void setFanPrimaryMinimumRpmField(int value);
    void setFanPrimaryStandbyDutyCycleField(short value);
    void setFanPrimaryStandbyRpmField(int value);

    void setLightIntensity(short lightIntensity);
    void saveLightIntensity(short lightIntensity);

    void setLightState(short lightState);

    void setSocketInstalled(short value);
    void setSocketState(short socketState);

    void setGasInstalled(short value);
    void setGasState(short gasState);

    void setUvInstalled(short value);
    void setUvState(short uvState);
    void setUvTimeSave(int minutes);

    void setWarmingUpTimeSave(short seconds);
    void setPostPurgeTimeSave(short seconds);

    void setExhaustContactState(short exhaustContactState);

    void setAlarmContactState(short alarmContactState);

    void setSashMotorizeInstalled(short value);
    void setSashMotorizeState(short value);

    void setSeasFlapInstalled(short value);

    void setSeasBuiltInInstalled(short value);
    void setSeasPressureDiffPaLowLimit(int value);
    void setSeasPressureDiffPaOffset(int value);

    //////////
    void setAirflowMonitorEnable(bool airflowMonitorEnable);

    //INFLOW
    void setInflowSensorConstantTemporary(short value);
    //
    void setInflowSensorConstant(short value);
    void setInflowTemperatureCalib(short value, int adc);
    //
    void setInflowAdcPointFactory(int pointZero, int pointMin, int pointNom);
    void setInflowAdcPointFactory(int point, int value);
    void setInflowVelocityPointFactory(int pointZero, int pointMin, int pointNom);
    void setInflowVelocityPointFactory(int point, int value);
    //
    void setInflowAdcPointField(int pointZero, int pointMin, int pointNom);
    void setInflowAdcPointField(int point, int value);
    void setInflowVelocityPointField(int pointZero, int pointMin, int pointNom);
    void setInflowVelocityPointField(int point, int value);
    //
    void setInflowLowLimitVelocity(short value);
    //
    void saveInflowMeaDimNominalGrid(const QJsonArray grid,
                                     int total, int average,
                                     int volume, int velocity,
                                     int ducy, int rpm,
                                     int calibMode = 0);
    void saveInflowMeaDimMinimumGrid(const QJsonArray grid,
                                     int total, int average,
                                     int volume, int velocity,
                                     int ducy, int rpm,
                                     int calibMode = 0);
    void saveInflowMeaDimStandbyGrid(const QJsonArray grid,
                                     int total, int average,
                                     int volume, int velocity,
                                     int ducy, int rpm,
                                     int calibMode = 0);
    //
    void saveInflowMeaSecNominalGrid(const QJsonArray grid,
                                     int total, int average,
                                     int velocity, int ducy, int rpm,
                                     int calibMode = 0);

    void saveInflowMeaSecMinimumGrid(const QJsonArray grid,
                                     int total, int average,
                                     int velocity, int ducy, int rpm,
                                     int calibMode = 0);

    void saveInflowMeaSecStandbyGrid(const QJsonArray grid,
                                     int total, int average,
                                     int velocity, int ducy, int rpm,
                                     int calibMode = 0);
    ///
    //DOWNFLOW
    //    void saveDownflowSensorConstant(short ifaConstant);
    //
    //    void saveDownflowAdcPointFactory(int pointZero, int pointMin, int pointNom);
    void setDownflowVelocityPointFactory(int pointZero, int pointMin, int pointNom);
    void setDownflowVelocityPointFactory(int point, int value);
    //    void saveDownflowTemperatureFactory(short ifaTemperatureFactory, int adc);
    //
    //    void saveDownflowAdcPointField(short point, int adc);
    void setDownflowVelocityPointField(int pointZero, int pointMin, int pointNom);
    void setDownflowVelocityPointField(int point, int value);
    //    void saveDownflowTemperatureField(short value, int adc);
    //
    void saveDownflowMeaNominalGrid(const QJsonArray grid, int total,
                                    int velocity,
                                    int velocityLowest, int velocityHighest,
                                    int deviation, int deviationp,
                                    int calibMode = 0);
    //
    void initAirflowCalibrationStatus(short value);
    void initFanConfigurationStatus(short value);

    void setAirflowFactoryCalibrationState(int index, bool state);
    //    void setAirflowFactorySecondaryCalibrationState(int index, bool state);
    //    void setAdcFactoryCalibrationState(int index, bool state);
    void setAirflowFieldCalibrationState(int index, bool value);

    /// DATALOG
    void setDataLogEnable(bool dataLogEnable);
    void setDataLogRunning(bool dataLogRunning);
    void setDataLogPeriod(short dataLogPeriod);
    void setDataLogCount(int dataLogCount);

    /// RESOURCE MONITOR LOG
    void setResourceMonitorLogEnable(bool value);
    void setResourceMonitorLogRunning(bool value);
    void setResourceMonitorLogPeriod(short value);
    void setResourceMonitorLogCount(int value);

    /// MODBUS
    void setModbusSlaveID(short slaveId);
    void setModbusAllowingIpMaster(const QString &ipAddr);
    void setModbusAllowSetFan(bool value);
    void setModbusAllowSetLight(bool value);
    void setModbusAllowSetLightIntensity(bool value);
    void setModbusAllowSetSocket(bool value);
    void setModbusAllowSetGas(bool value);
    void setModbusAllowSetUvLight(bool value);
    /// Dont use for nomal function
    bool _callbackOnModbusConnectionStatusChanged(QTcpSocket* newClient);

    void insertEventLog(const QString &eventText);
    ///
    void refreshLogRowsCount(const QString &table);
    void reInitializeLogger(const QString &table);

    /// UV AUTO SET
    /// ON
    void setUVAutoEnabled(int uvAutoSetEnabled);
    void setUVAutoTime(int uvAutoSetTime);
    void setUVAutoDayRepeat(int uvAutoSetDayRepeat);
    void setUVAutoWeeklyDay(int uvAutoSetWeeklyDay);
    /// OFF
    void setUVAutoEnabledOff(int uvAutoSetEnabledOff);
    void setUVAutoTimeOff(int uvAutoSetTimeOff);
    void setUVAutoDayRepeatOff(int uvAutoSetDayRepeatOff);
    void setUVAutoWeeklyDayOff(int uvAutoSetWeeklyDayOff);

    /// LIGHT AUTO SET
    /// ON
    void setLightAutoEnabled(int value);
    void setLightAutoTime(int value);
    void setLightAutoDayRepeat(int value);
    void setLightAutoWeeklyDay(int value);
    /// OFF
    void setLightAutoEnabledOff(int value);
    void setLightAutoTimeOff(int value);
    void setLightAutoDayRepeatOff(int value);
    void setLightAutoWeeklyDayOff(int value);

    /// SOCKET AUTO SET
    /// ON
    void setSocketAutoEnabled(int value);
    void setSocketAutoTime(int value);
    void setSocketAutoDayRepeat(int value);
    void setSocketAutoWeeklyDay(int value);
    /// OFF
    void setSocketAutoEnabledOff(int value);
    void setSocketAutoTimeOff(int value);
    void setSocketAutoDayRepeatOff(int value);
    void setSocketAutoWeeklyDayOff(int value);

    /// FAN AUTO SET
    /// ON
    void setFanAutoEnabled(int fanAutoSetEnabled);
    void setFanAutoTime(int fanAutoSetTime);
    void setFanAutoDayRepeat(int fanAutoSetDayRepeat);
    void setFanAutoWeeklyDay(int fanAutoSetWeeklyDay);
    /// OFF
    void setFanAutoEnabledOff(int fanAutoSetEnabledOff);
    void setFanAutoTimeOff(int fanAutoSetTimeOff);
    void setFanAutoDayRepeatOff(int fanAutoSetDayRepeatOff);
    void setFanAutoWeeklyDayOff(int fanAutoSetWeeklyDayOff);

    /// ESCO LOCK SERVICE
    void setEscoLockServiceEnable(int escoLockServiceEnable);

    /// CABINET DISPLAY NAME
    void setCabinetDisplayName(const QString &cabinetDisplayName);

    /// CABINET FAN PIN
    void setFanPIN(const QString &fanPIN);

    /// FAN USAGE
    void setFanUsageMeter(int minutes);

    /// UV USAGE
    void setUvUsageMeter(int minutes);

    /// FILTER USAGE
    void setFilterUsageMeter(int percent);
    //    void setFilterLifeRpm                   (int value);
    void setFilterLifeCalculationMode       (int value);
    void setFilterLifeMinimumBlowerUsageMode (int value);
    void setFilterLifeMaximumBlowerUsageMode (int value);
    void setFilterLifeMinimumBlowerRpmMode   (int value);
    void setFilterLifeMaximumBlowerRpmMode   (int value);


    /// SASH CYCLE METER
    void setSashCycleMeter(int sashCycleMeter);

    /// Sensor Environtmental Temperature Limitation
    void setEnvTempHighestLimit(int envTempHighestLimit);
    void setEnvTempLowestLimit(int envTempLowestLimit);

    /// Particle Counter
    void setParticleCounterSensorInstalled(bool particleCounterSensorInstalled);

    void setWatchdogResetterState(bool state);

    void setShippingModeEnable(bool shippingModeEnable);

    void setCurrentSystemAsKnown(bool value);

    void readSbcCurrentFullMacAddress();

    void setAlarmPreventMaintStateEnable(ushort pmCode, bool value);
    void setAlarmPreventMaintStateAck(ushort pmCode, bool value, bool snooze);
    void resetPreventMaintAckDate(ushort pmCode);
    void setAlarmPreventMaintStateRemindBefore(ushort pmCode, int value);

    void setEth0ConName(const QString &value);
    void setEth0Ipv4Address(const QString &value);
    void setEth0ConEnabled(bool value);
    void setWiredNetworkHasbeenConfigured(bool value);
    void initWiredConnectionStaticIP();

    void setSvnUpdateHasBeenApplied();
    void setSvnUpdateCheckEnable(bool value);
    void setSvnUpdateCheckPeriod(int value);
    void checkSoftwareVersionHistory();

    void setAlarmExperimentTimerIsOver(short value);

    //    void initReplaceablePartsSettings();
    void setReplaceablePartsSettings(short index, const QString &value);
    void setReplaceablePartsSelected(short descRowId);
    void setKeyboardStringOnAcceptedEvent(const QString &value);
    void insertReplaceableComponentsForm();
    void resetReplaceablePartsSettings();
    void setReplaceablePartsSettingsFromSelectedRecord();

    ///
    void requestEjectUsb(const QString &usbName);
    void setFrontEndScreenState(short value);
    void setInstallationWizardActive(bool value);

    void setSomeSettingsAfterExtConfigImported();
    void setAllOutputShutdown();

    void setFilterLifeDisplayEnabled(bool state);

    void setAirflowOutTempEnable(bool value);

    void setSensorConstCorrEnable(bool value);
    void setSensorConstCorrHighZone(int value);
    void setSensorConstCorrLowZone(int value);

    void setLogoutTime(int value);
    void setCFR21Part11Enable(bool value);

    void resetPowerFailureNotification();

    void setFanSpeedControllerBoard(short value);

    void setPropogateComposeEventGesture(bool value);

    void resetFieldSensorCalibration();

    void setFilterLifeReminderSnoozed(bool value);
    void setUvReplacementReminderSnoozed(bool value);

    void setAdvancedAirflowAlarmEnable(bool value);

    void refreshAirflowCalibrationGrid();

    void setCertificationParametersInt(short index, int value);
    void setCertificationParametersStr(short index, const QString &value);

    void refreshTodayBookingSchedule();
    void setBookedScheduleNotifEnable(bool value);
    void setBookedScheduleNotifTime(int value);
    void setBookedScheduleNotifCollapse(bool value);
    void setBookedScheduleAcknowledge(const QString &time, bool value);
    void refreshBookScheduleNotifDisplay();

    void setExperimentTimerAlwaysShow(bool value);

    void setNetworkConnectedStatus(short value);
	
    void setFanSpeedMaximumLimit(int value);
    void setFanSpeedFullEnable(bool value);

    void setSpecialSettingForCustomer(const QString &customer);

    void setRpExternalDatabaseEnable(bool value);
    void refreshRpExternalDatabase();
    void refreshRpExternalDefault();
    void checkValidityOfRpList();

signals:
    void hasStopped();

    void loopStarted();
    void timerEventWorkerStarted();
    void currentDateStrChanged(const QString &currDateStr);

private:
    MachineData*    pData;

    void setup();
    void loop();
    void deallocate();

    bool m_stop = false;
    bool m_loopStarterTaskExecute = false;
    bool m_deallocatting = false;

    /// Translations
    QScopedPointer<QTranslator>    m_translator;
    const QString _tr(const QString &source);
    QString m_langCode;

    /// Board IO
    QScopedPointer<QThread>         m_threadForBoardIO;
    QScopedPointer<QTimer>          m_timerEventForBoardIO;
    ///
    QScopedPointer<BoardIO>         m_boardIO;
    QScopedPointer<I2CPort>         m_i2cPort;

    /// CTP
    QScopedPointer<RTCpcf8523>      m_boardCtpRTC;
    QScopedPointer<LEDpca9633>      m_boardCtpIO;
    /// Digital Input
    QScopedPointer<DIOpca9674>      m_boardDigitalInput1;
    /// Digital Swith / PWM
    QScopedPointer<PWMpca9685>      m_boardRelay1;
    /// Analog Input
    QScopedPointer<AIManage>        m_boardAnalogInput1;
    /// Analog Output
    QScopedPointer<AOmcp4725>       m_boardAnalogOutput1;

    /// Implementation
    QScopedPointer<SashWindow>          m_pSashWindow;
    QScopedPointer<DeviceAnalogCom>     m_pLightIntensity;
    QScopedPointer<DeviceDigitalOut>    m_pLight;
    QScopedPointer<DeviceDigitalOut>    m_pSocket;
    QScopedPointer<DeviceDigitalOut>    m_pGas;
    QScopedPointer<DeviceDigitalOut>    m_pUV;
    QScopedPointer<MotorizeOnRelay>     m_pSasWindowMotorize;
    QScopedPointer<DeviceDigitalOut>    m_pExhaustContact;
    QScopedPointer<DeviceDigitalOut>    m_pAlarmContact;
    ///
    QScopedPointer<Temperature>     m_pTemperature;
    QScopedPointer<AirflowVelocity> m_pAirflowInflow;
    QScopedPointer<QTimer>           m_timerEventForSashWindowRoutine;
    void _onTriggeredEventSashWindowRoutine();
    ///
    QScopedPointer<QGpioSysfs>      m_pBuzzer;
    ///
    QScopedPointer<SensirionSPD8xx>     m_boardSensirionSPD8xx;
    QScopedPointer<PressureDiffManager> m_pSeas;

    /// Fan Primary
    QScopedPointer<QThread>         m_threadForFanRbmDsi;
    QScopedPointer<QTimer>          m_timerEventForFanRbmDsi;
    ///
    QScopedPointer<BlowerRbmDsi>    m_pFanPrimary;
    QScopedPointer<BlowerRegalECM>  m_boardRegalECM;
    ///
    QScopedPointer<QSerialPort>     m_serialPort1;

    /// Particle Counter
    QScopedPointer<QThread>         m_threadForParticleCounter;
    QScopedPointer<QTimer>          m_timerEventForParticleCounter;
    ///
    QScopedPointer<ParticleCounter>      m_pParticleCounter;
    QScopedPointer<ParticleCounterZH03B> m_boardParticleCounterZH03B;
    ///
    QScopedPointer<QSerialPort>     m_serialPort2;

    /// More Objects
    QScopedPointer<QTimer> m_timerEventForLcdToDimm;
    QScopedPointer<QTimer> m_timerEventForBuzzerBeep;
    QScopedPointer<QTimer> m_timerEventForRTCWatchdogReset;
    QScopedPointer<QTimer> m_timerEventForRTCWatchdogCountMonitor;

    QScopedPointer<QTimer> m_timerEventEvery50MSecond;
    QScopedPointer<QTimer> m_timerEventEverySecond;
    QScopedPointer<QTimer> m_timerEventEveryMinute;
    QScopedPointer<QTimer> m_timerEventEveryHalfHour;
    QScopedPointer<QTimer> m_timerEventEveryHour;

    void _onTriggeredEventEvery50MSecond();
    void _onTriggeredEventEverySecond();
    void _onTriggeredEventEveryMinute();
    void _onTriggeredEventEveryHalfHour();
    void _onTriggeredEventEveryHour();

    ///DATA LOG
    QScopedPointer<QThread>     m_threadForDatalog;
    QScopedPointer<QTimer>      m_timerEventForDataLog;
    QScopedPointer<DataLog>     m_pDataLog;
    QScopedPointer<DataLogSql>  m_pDataLogSql;

    ///ALARM LOG
    QScopedPointer<QThread>      m_threadForAlarmLog;
    QScopedPointer<AlarmLog>     m_pAlarmLog;
    QScopedPointer<AlarmLogSql>  m_pAlarmLogSql;

    ///EVENT LOG
    QScopedPointer<QThread>      m_threadForEventLog;
    QScopedPointer<EventLog>     m_pEventLog;
    QScopedPointer<EventLogSql>  m_pEventLogSql;

    ///REPLACEABLECOMP RECORD
    QScopedPointer<QThread>                   m_threadForReplaceableCompRecord;
    QScopedPointer<ReplaceableCompRecord>     m_pReplaceableCompRecord;
    QScopedPointer<ReplaceableCompRecordSql>  m_pReplaceableCompRecordSql;

    ///BOOKING SCHEDULE RECORD
    QScopedPointer<QThread>             m_threadForBookingSchedule;
    QScopedPointer<BookingSchedule>     m_pBookingSchedule;
    QScopedPointer<BookingScheduleSql>  m_pBookingScheduleSql;

    ///RESOURCE MONITOR LOG
    QScopedPointer<QThread>     m_threadForResourceMonitorLog;
    QScopedPointer<QTimer>      m_timerEventForResourceMonitorLog;
    QScopedPointer<ResourceMonitorLog>     m_pResourceMonitorLog;
    QScopedPointer<ResourceMonitorLogSql>  m_pResourceMonitorLogSql;

    ///CHECK FOR SWU UPDATE
    QScopedPointer<QThread>      m_threadForCheckSwUpdate;
    QScopedPointer<QTimer>       m_timerEventForCheckSwUpdate;
    QScopedPointer<CheckSWUpdate> m_pCheckSwUpdate;

    /// USB Auto Mount
    QScopedPointer<QThread>      m_threadForUSBAutoMount;
    QScopedPointer<QTimer>       m_timerEventForUSBAutoMount;
    QScopedPointer<USBAutoMount> m_pUSBAutoMount;

    /// OUTPUT AUTO SET
    /// UV SCHEDULER
    QScopedPointer<SchedulerDayOutput> m_uvSchedulerAutoSet;
    void _onTriggeredUvSchedulerAutoSet();
    QScopedPointer<SchedulerDayOutput> m_uvSchedulerAutoSetOff;
    void _onTriggeredUvSchedulerAutoSetOff();
    /// LIGHT SCHEDULER
    QScopedPointer<SchedulerDayOutput> m_lightSchedulerAutoSet;
    void _onTriggeredLightSchedulerAutoSet();
    QScopedPointer<SchedulerDayOutput> m_lightSchedulerAutoSetOff;
    void _onTriggeredLightSchedulerAutoSetOff();
    /// SOCKET SCHEDULER
    QScopedPointer<SchedulerDayOutput> m_socketSchedulerAutoSet;
    void _onTriggeredSocketSchedulerAutoSet();
    QScopedPointer<SchedulerDayOutput> m_socketSchedulerAutoSetOff;
    void _onTriggeredSocketSchedulerAutoSetOff();
    /// FAN SCHEDULER
    QScopedPointer<SchedulerDayOutput> m_fanSchedulerAutoSet;
    void _onTriggeredFanSchedulerAutoSet();
    QScopedPointer<SchedulerDayOutput> m_fanSchedulerAutoSetOff;
    void _onTriggeredFanSchedulerAutoSetOff();

    /// MODBUS
    QModbusTcpServer                            *m_pModbusServer;
    QModbusTcpConnObserverImp                   *m_pModbusTcpConnObserver;
    QScopedPointer<QVector<uint16_t>>            m_modbusDataUnitBufferRegisterHolding;
    void _onModbusDataWritten(QModbusDataUnit::RegisterType table, int address, int size);
    void _modbusCommandHandler(int address, uint16_t value);
    void _setModbusRegHoldingValue(int addr, uint16_t value);

    /// Backup previus operation mode
    short m_operationPrevMode = 0;

    short m_securityAccessPrevMode = 0;

    void _insertDataLog();
    void _insertAlarmLog(int alarmCode, const QString &alarmText);
    void _insertEventLog(const QString &logText);
    void _insertResourceMonitorLog();

    void _setFanPrimaryStateNominal();
    void _setFanPrimaryStateMinimum();
    void _setFanPrimaryStateStandby();
    void _setFanPrimaryStateOFF();
    void _setFanPrimaryDutyCycle(short dutyCycle);
    void _setFanPrimaryInterlocked(bool interlocked);

    void _wakeupLcdBrightnessLevel();

    void _setTimeZoneLinux(const QString &value);
    void _setDateTimeLinux(const QString &value);
    bool _getSystemClockSynchronized();
    void _syncLinuxTimeToRtc();

    QString _readMacAddress();
    QStringList _readSbcSystemInformation();
    void _setHardwareInformation(const QStringList &value);
    QString _readSbcSerialNumber();
    void _setSbcSystemInformation(const QStringList &sysInfo);
    void _setSbcCurrentSystemInformation(const QStringList &sysInfo);
    void _setSbcSerialNumber(const QString &value);

    void _initAirflowCalibartionFactory();
    void _initAirflowCalibartionField();

    void _onFanPrimaryActualDucyChanged(short value);
    void _onFanPrimaryActualRpmChanged(int value);

    void _onSashStateChanged(short state, short prevState);
    void _onLightStateChanged(short state);
    void _onSocketStateChanged(short state);
    void _onGasStateChanged(short state);
    void _onUVStateChanged(short state);

    void _onTemperatureActualChanged(double value);
    void _onInflowVelocityActualChanged(int value);
    void _calculteDownflowVelocity(int value);

    void _onSeasPressureDiffPaChanged(int value);

    void _onParticleCounterPM1_0Changed(int pm1_0);
    void _onParticleCounterPM2_5Changed(int pm2_5);
    void _onParticleCounterPM10Changed(int pm10);
    void _onParticleCounterSensorFanStateChanged(int state);

    void _onTimerEventLcdDimm();

    int m_logoutTimeCountdown = 0;
    void _startLogoutTime();
    void _resetLogoutTime();
    void _cancelLogoutTime();
    void _onTimerEventLogout();

    void _startWarmingUpTime();
    void _cancelWarmingUpTime();
    void _onTimerEventWarmingUp();

    void _startPostPurgingTime();
    void _cancelPostPurgingTime();
    void _onTimerEventPostPurging();

    void _startUVTime();
    void _cancelUVTime();
    void _onTimerEventUVTimeCountdown();
    void _setUvTimeCountdown(int value);

    void _startUVLifeMeter();
    void _stopUVLifeMeter();
    void _onTimerEventUVLifeCalculate();

    void _startFanFilterLifeMeter();
    void _stopFanFilterLifeMeter();
    void _onTimerEventFanFilterUsageMeterCalculate();

    void _startPowerOutageCapture();
    void _cancelPowerOutageCapture();
    void _onTimerEventPowerOutageCaptureTime();

    void _startMuteAlarmTimer();
    void _cancelMuteAlarmTimer();
    void _onTimerEventMuteAlarmTimer();

    void _readRTCActualTime();

    double __convertCfmToLs(double value);
    double __convertLsToCfm(double value);
    double __convertFpmToMps(double value);
    double __convertMpsToFpm(double value);
    double __toFixedDecPoint(double value, short point);
    int __convertCtoF(int c);
    int __convertFtoC(int f);
    double __convertPa2inWG(int pa);
    int __getPercentFrom(int val, int ref);
    double __map(double x, double in_min, double in_max, double out_min, double out_max) const;

    bool isMaintenanceModeActive() const;

    bool isAirflowHasCalibrated() const;

    bool isTempAmbientNormal() const;
    bool isTempAmbientLow() const;
    bool isTempAmbientHigh() const;

    bool isFanStateNominal() const;
    bool isFanStateStandby() const;

    bool isAlarmActive(short alarm) const;
    bool isAlarmNormal(short alarm) const;
    bool isAlarmNA(short alarm) const;

    bool isTempAmbNormal(short value) const;
    bool isTempAmbLow(short value) const;
    bool isTempAmbHigh(short value) const;

    void _refreshAlarmPreventMaint();
    void _checkCertificationReminder();

    void _machineState();

    void _setSoftwareUpdateAvailable(const QString &swu, const QString &path, QJsonObject history);
    void _setSoftwareUpdateAvailableReset();
    //    void _initPreventMaintReminder();

    void _readResourceMonitorParams();
    QJsonObject _getRpListDefaultJsonObj() const;
    QString _getRpListDefaultValue(const QJsonObject dbDefault, short index);

    void _initCertificationParameters();
    QString m_keyCertifParamInt[MachineEnums::CertifParamInt_Total];
    QString m_keyCertifParamStr[MachineEnums::CertifParamStr_Total];

    QString m_signedUsername;
    QString m_signedFullname;
    short m_signedUserLevel = 0;

    QString m_currentDateStr;
    //    QVariantList m_todayScheduleVarList;

    QTimer* eventTimerForDelaySafeHeightAction = nullptr;
    int  m_sashSafeAutoOnOutputDelayTimeMsec = 100; /// 100ms //original 3 seconds

    QTimer* eventTimerForDelayMotorizedOffAtFullyClosed = nullptr;
    int  m_sashMotorizedOffAtFullyClosedDelayTimeMsec = 700; /// 1000ms
    bool  m_delaySashMotorFullyClosedExecuted = false;
    uchar m_counter = 0;

    QString m_rpListSettings[MachineEnums::RPList_Total];

    bool m_needToCalculateStbRpmField = false;
    short m_countDownTimerCalculateStbRpmField = 0;

    long m_fanPrimaryRpmMovAvgTotal = 0;
    int m_fanPrimaryRpmMovAvg = 0;
    short m_fanPrimaryRpmMovAvgCountStable = 0;
    QScopedPointer<QVector<uint16_t>>  m_fanPrimaryRpmActualBuffer;
    bool m_eventLoopSashMotorActive = false;
    short m_eventLoopCounter = 0;
    short m_delaySashMotorUpAfterStucked = 1500; /// 1500ms for 6ft /// 1000ms for 4ft
    bool m_sashMovedDown = false;

    bool m_systemClockSync = false;
    bool m_networkConnectedStatus = false;

//    bool m_lcdBrightnessBusy = false;

#ifdef QT_DEBUG
    QScopedPointer<QWebSocketServer> m_pWebSocketServerDummyState;
    QList<QWebSocket *> m_clientsDummyState;
    void onDummyStateNewConnection();
#endif

    //    void _onExhPressureActualPaChanged(int newVal);
};

