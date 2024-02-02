#pragma once

#include <QObject>
#include <QJsonObject>
#include <QJsonArray>
#include "MachineEnums.h"

class QQmlEngine;
class QJSEngine;

class MachineData;

class MachineData : public QObject
{
    Q_OBJECT

    Q_PROPERTY(int count
                   READ getCount
                       //               WRITE setDataCount
                       NOTIFY countChanged)

    Q_PROPERTY(int machineState
                   READ getMachineBackendState
                       //               WRITE setDataWorkerState
                       NOTIFY machineStateChanged)

    Q_PROPERTY(bool hasStopped
                   READ getHasStopped
                       //               WRITE setHasStopped
                       NOTIFY hasStoppedChanged)

    Q_PROPERTY(short sashWindowState READ getSashWindowState NOTIFY sashWindowStateChanged)

    /// Magnetic Switch
    Q_PROPERTY(bool magSW1State
                   READ getMagSW1State
                       //               WRITE setMagSW1State
                       NOTIFY magSWStateChanged)

    Q_PROPERTY(bool magSW2State
                   READ getMagSW2State
                       //               WRITE setMagSW2State
                       NOTIFY magSWStateChanged)

    Q_PROPERTY(bool magSW3State
                   READ getMagSW3State
                       //               WRITE setMagSW3State
                       NOTIFY magSWStateChanged)

    Q_PROPERTY(bool magSW4State
                   READ getMagSW4State
                       //               WRITE setMagSW4State
                       NOTIFY magSWStateChanged)

    Q_PROPERTY(bool magSW5State
                   READ getMagSW5State
                       //               WRITE setMagSW5State
                       NOTIFY magSWStateChanged)

    Q_PROPERTY(bool magSW6State
                   READ getMagSW6State
                       //               WRITE setMagSW6State
                       NOTIFY magSWStateChanged)

    //// FAN
    Q_PROPERTY(bool fanPrimaryInterlocked
                   READ getFanPrimaryInterlocked
                       //               WRITE setFanPrimaryInterlocked
                       NOTIFY fanPrimaryInterlockedChanged)
    Q_PROPERTY(short fanPrimaryState
                   READ getFanPrimaryState
                       //               WRITE setFanPrimaryState
                       NOTIFY fanPrimaryStateChanged)

    Q_PROPERTY(short fanPrimaryDutyCycle
                   READ getFanPrimaryDutyCycle
                       //               WRITE setFanPrimaryDutyCycle
                       NOTIFY fanPrimaryDutyCycleChanged)

    Q_PROPERTY(int fanPrimaryRpm
                   READ getFanPrimaryRpm
                       //               WRITE setFanPrimaryRpm
                       NOTIFY fanPrimaryRpmChanged)

    //    Q_PROPERTY(short fanPrimaryNominalDutyCycle
    //               READ getFanPrimaryNominalDutyCycle
    //               //               WRITE setFanPrimaryNominalDutyCycle
    //               NOTIFY fanPrimaryNominalDutyCycleChanged)

    //    Q_PROPERTY(int fanPrimaryNominalRpm
    //               READ getFanPrimaryNominalRpm
    //               //               WRITE setFanPrimaryNominalRpm
    //               NOTIFY fanPrimaryNominalRpmChanged)

    //    Q_PROPERTY(short fanPrimaryStandbyDutyCycle
    //               READ getFanPrimaryStandbyDutyCycle
    //               //               WRITE setFanPrimaryStandbyDutyCycle
    //               NOTIFY fanPrimaryStandbyDutyCycleChanged)

    //    Q_PROPERTY(int fanPrimaryStandbyRpm
    //               READ getFanPrimaryStandbyRpm
    //               //               WRITE setFanPrimaryStandbyRpm
    //               NOTIFY fanPrimaryStandbyRpmChanged)

    //    Q_PROPERTY(short fanPrimaryNominalDutyCycleFactory
    //               READ getFanPrimaryNominalDutyCycleFactory
    //               WRITE setFanPrimaryNominalDutyCycleFactory
    //               NOTIFY fanPrimaryNominalDutyCycleFactoryChanged)

    //    Q_PROPERTY(int fanPrimaryNominalRpmFactory
    //               READ getFanPrimaryNominalRpmFactory
    //               WRITE setFanPrimaryNominalRpmFactory
    //               NOTIFY fanPrimaryNominalRpmFactoryChanged)

    //    Q_PROPERTY(short fanPrimaryNominalDutyCycleField
    //               READ getFanPrimaryNominalDutyCycleField
    //               WRITE setFanPrimaryNominalDutyCycleField
    //               NOTIFY fanPrimaryNominalDutyCycleFieldChanged)

    //    Q_PROPERTY(int fanPrimaryNominalRpmField
    //               READ getFanPrimaryNominalRpmField
    //               WRITE setFanPrimaryNominalRpmField
    //               NOTIFY fanPrimaryNominalRpmFieldChanged)

    //    Q_PROPERTY(short fanPrimaryStandbyDutyCycleFactory
    //               READ getFanPrimaryStandbyDutyCycleFactory
    //               WRITE setFanPrimaryStandbyDutyCycleFactory
    //               NOTIFY fanPrimaryStandbyDutyCycleFactoryChanged)

    //    Q_PROPERTY(int fanPrimaryStandbyRpmFactory
    //               READ getFanPrimaryStandbyRpmFactory
    //               WRITE setFanPrimaryStandbyRpmFactory
    //               NOTIFY fanPrimaryStandbyRpmFactoryChanged)

    //    Q_PROPERTY(short fanPrimaryStandbyDutyCycleField
    //               READ getFanPrimaryStandbyDutyCycleField
    //               WRITE setFanPrimaryStandbyDutyCycleField
    //               NOTIFY fanPrimaryStandbyDutyCycleFieldChanged)

    //    Q_PROPERTY(int fanPrimaryStandbyRpmField
    //               READ getFanPrimaryStandbyRpmField
    //               WRITE setFanPrimaryStandbyRpmField
    //               NOTIFY fanPrimaryStandbyRpmFieldChanged)

    ///Fan Auto Set
    Q_PROPERTY(int      fanAutoSetEnabled
                   READ     getFanAutoEnabled
                       //               WRITE    setFanAutoEnabled
                       NOTIFY   fanAutoEnabledChanged)
    Q_PROPERTY(int      fanAutoSetTime
                   READ     getFanAutoTime
                       //               WRITE    setFanAutoTime
                       NOTIFY   fanAutoTimeChanged)
    Q_PROPERTY(int      fanAutoSetDayRepeat
                   READ     getFanAutoDayRepeat
                       //               WRITE    setFanAutoDayRepeat
                       NOTIFY   fanAutoDayRepeatChanged)
    Q_PROPERTY(int      fanAutoSetWeeklyDay
                   READ     getFanAutoWeeklyDay
                       //               WRITE    setFanAutoWeeklyDay
                       NOTIFY   fanAutoWeeklyDayChanged)

    Q_PROPERTY(int      fanAutoSetEnabledOff
                   READ     getFanAutoEnabledOff
                       //               WRITE    setFanAutoEnabled
                       NOTIFY   fanAutoEnabledOffChanged)
    Q_PROPERTY(int      fanAutoSetTimeOff
                   READ     getFanAutoTimeOff
                       //               WRITE    setFanAutoTime
                       NOTIFY   fanAutoTimeOffChanged)
    Q_PROPERTY(int      fanAutoSetDayRepeatOff
                   READ     getFanAutoDayRepeatOff
                       //               WRITE    setFanAutoDayRepeat
                       NOTIFY   fanAutoDayRepeatOffChanged)
    Q_PROPERTY(int      fanAutoSetWeeklyDayOff
                   READ     getFanAutoWeeklyDayOff
                       //               WRITE    setFanAutoWeeklyDay
                       NOTIFY   fanAutoWeeklyDayOffChanged)

    ////LIGHT
    Q_PROPERTY(short lightState
                   READ getLightState
                       //               WRITE setLightState
                       NOTIFY lightStateChanged)
    Q_PROPERTY(bool lightInterlocked
                   READ getLightInterlocked
                       //               WRITE setLightInterlocked
                       NOTIFY lightInterlockedChanged)
    Q_PROPERTY(short lightIntensity
                   READ getLightIntensity
                       //               WRITE setLightIntensity
                       NOTIFY lightIntensityChanged)

    ///SOCKET
    Q_PROPERTY(short socketState        READ getSocketState         NOTIFY socketStateChanged)
    Q_PROPERTY(bool socketInterlocked   READ getSocketInterlocked   NOTIFY socketInterlockedChanged)
    Q_PROPERTY(bool socketInstalled     READ getSocketInstalled     NOTIFY socketInstalledChanged)

    ///GAS
    Q_PROPERTY(short gasState           READ getGasState            NOTIFY gasStateChanged)
    Q_PROPERTY(bool gasInterlocked      READ getGasInterlocked      NOTIFY gasInterlockedChanged)
    Q_PROPERTY(bool gasInstalled        READ getGasInstalled        NOTIFY gasInstalledChanged)

    ///UV
    Q_PROPERTY(short uvState            READ getUvState NOTIFY uvStateChanged)
    Q_PROPERTY(bool uvInterlocked       READ getUvInterlocked NOTIFY uvInterlockedChanged)
    Q_PROPERTY(bool uvInstalled         READ getUvInstalled NOTIFY uvInstalledChanged)

    ///UV Auto Set
    /// ON
    Q_PROPERTY(int uvAutoSetEnabled         READ getUVAutoEnabled       NOTIFY uvAutoEnabledChanged)
    Q_PROPERTY(int uvAutoSetTime            READ getUVAutoTime          NOTIFY uvAutoTimeChanged)
    Q_PROPERTY(int uvAutoSetDayRepeat       READ getUVAutoDayRepeat     NOTIFY uvAutoDayRepeatChanged)
    Q_PROPERTY(int uvAutoSetWeeklyDay       READ getUVAutoWeeklyDay     NOTIFY uvAutoWeeklyDayChanged)
    /// OFF
    Q_PROPERTY(int uvAutoSetEnabledOff      READ getUVAutoEnabledOff    NOTIFY uvAutoEnabledOffChanged)
    Q_PROPERTY(int uvAutoSetTimeOff         READ getUVAutoTimeOff       NOTIFY uvAutoTimeOffChanged)
    Q_PROPERTY(int uvAutoSetDayRepeatOff    READ getUVAutoDayRepeatOff  NOTIFY uvAutoDayRepeatOffChanged)
    Q_PROPERTY(int uvAutoSetWeeklyDayOff    READ getUVAutoWeeklyDayOff  NOTIFY uvAutoWeeklyDayOffChanged)

    ///Light Auto Set
    /// ON
    Q_PROPERTY(int lightAutoSetEnabled         READ getLightAutoEnabled       NOTIFY lightAutoEnabledChanged)
    Q_PROPERTY(int lightAutoSetTime            READ getLightAutoTime          NOTIFY lightAutoTimeChanged)
    Q_PROPERTY(int lightAutoSetDayRepeat       READ getLightAutoDayRepeat     NOTIFY lightAutoDayRepeatChanged)
    Q_PROPERTY(int lightAutoSetWeeklyDay       READ getLightAutoWeeklyDay     NOTIFY lightAutoWeeklyDayChanged)
    /// OFF
    Q_PROPERTY(int lightAutoSetEnabledOff      READ getLightAutoEnabledOff    NOTIFY lightAutoEnabledOffChanged)
    Q_PROPERTY(int lightAutoSetTimeOff         READ getLightAutoTimeOff       NOTIFY lightAutoTimeOffChanged)
    Q_PROPERTY(int lightAutoSetDayRepeatOff    READ getLightAutoDayRepeatOff  NOTIFY lightAutoDayRepeatOffChanged)
    Q_PROPERTY(int lightAutoSetWeeklyDayOff    READ getLightAutoWeeklyDayOff  NOTIFY lightAutoWeeklyDayOffChanged)

    ///Socket Auto Set
    /// ON
    Q_PROPERTY(int socketAutoSetEnabled         READ getSocketAutoEnabled       NOTIFY socketAutoEnabledChanged)
    Q_PROPERTY(int socketAutoSetTime            READ getSocketAutoTime          NOTIFY socketAutoTimeChanged)
    Q_PROPERTY(int socketAutoSetDayRepeat       READ getSocketAutoDayRepeat     NOTIFY socketAutoDayRepeatChanged)
    Q_PROPERTY(int socketAutoSetWeeklyDay       READ getSocketAutoWeeklyDay     NOTIFY socketAutoWeeklyDayChanged)
    /// OFF
    Q_PROPERTY(int socketAutoSetEnabledOff      READ getSocketAutoEnabledOff    NOTIFY socketAutoEnabledOffChanged)
    Q_PROPERTY(int socketAutoSetTimeOff         READ getSocketAutoTimeOff       NOTIFY socketAutoTimeOffChanged)
    Q_PROPERTY(int socketAutoSetDayRepeatOff    READ getSocketAutoDayRepeatOff  NOTIFY socketAutoDayRepeatOffChanged)
    Q_PROPERTY(int socketAutoSetWeeklyDayOff    READ getSocketAutoWeeklyDayOff  NOTIFY socketAutoWeeklyDayOffChanged)


    /// SEAS BOARD FLAP
    Q_PROPERTY(bool seasFlapInstalled
                   READ getSeasFlapInstalled
                       //               WRITE setSeasBoardInstalled
                       NOTIFY seasFlapInstalledChanged)
    Q_PROPERTY(short seasFlapAlarmPressure
                   READ getSeasFlapAlarmPressure
                       //               WRITE setSeasFlapAlarmPressure
                       NOTIFY seasFlapAlarmPressureChanged)

    /// SEAS INTEGRATED
    Q_PROPERTY(bool seasInstalled
                   READ getSeasInstalled
                       //               WRITE setSeasInstalled
                       NOTIFY seasInstalledChanged)
    Q_PROPERTY(int seasPressureDiffPa
                   READ getSeasPressureDiffPa
                       //               WRITE setSeasPressureDiffPa
                       NOTIFY seasPressureDiffPaChanged)
    Q_PROPERTY(int seasPressureDiff
                   READ getSeasPressureDiff
                       //               WRITE setSeasPressureDiff
                       NOTIFY seasPressureDiffChanged)
    Q_PROPERTY(QString seasPressureDiffStr
                   READ getSeasPressureDiffStr
                       //               WRITE setSeasPressureDiffStr
                       NOTIFY seasPressureDiffStrChanged)
    Q_PROPERTY(int seasPressureDiffPaLowLimit
                   READ getSeasPressureDiffPaLowLimit
                       //               WRITE setSeasPressureDiffPaLowLimit
                       NOTIFY seasPressureDiffPaLowLimitChanged)
    Q_PROPERTY(short seasAlarmPressureLow
                   READ getAlarmSeasPressureLow
                       //               WRITE setSeasAlarmPressureLow
                       NOTIFY seasAlarmPressureLowChanged)
    Q_PROPERTY(short seasPressureDiffPaOffset
                   READ getSeasPressureDiffPaOffset
                       //               WRITE setSeasPressureDiffPaOffset
                       NOTIFY seasPressureDiffPaOffsetChanged)

    Q_PROPERTY(int seasPressureDiffPaNominal
                   READ getSeasPressureDiffPaNominal
                       //               WRITE setSeasPressureDiffPaLowLimit
                       NOTIFY seasPressureDiffPaNominalChanged)

    ///UV TIME
    Q_PROPERTY(bool uvTimeActive
                   READ getUvTimeActive
                       //               WRITE setUvTimeActive
                       NOTIFY uvTimeActiveChanged)
    ///
    Q_PROPERTY(int uvTime
                   READ getUvTime
                       //               WRITE setUvTime
                       NOTIFY uvTimeChanged)
    ///
    Q_PROPERTY(int uvTimeCountdown
                   READ getUvTimeCountdown
                       //               WRITE setUvTimeCountdown
                       NOTIFY uvTimeCountdownChanged)
    /// UV Life
    Q_PROPERTY(int uvLifeMinutes
                   READ getUvLifeMinutes
                       //               WRITE setUvLifeMinutes
                       NOTIFY uvLifeMinutesChanged)
    ///
    Q_PROPERTY(short uvLifePercent READ getUvLifePercent NOTIFY uvLifePercentChanged)
    Q_PROPERTY(QString uvLifeLevelColorStrf READ getUvLifeLevelColorStrf NOTIFY uvLifeLevelColorStrfChanged)

    Q_PROPERTY(bool uvReplacementReminder READ getUvReplacementReminder NOTIFY uvReplacementReminderChanged)
    Q_PROPERTY(bool uvReplacementReminderSnoozed READ getUvReplacementReminderSnoozed NOTIFY uvReplacementReminderSnoozedChanged)

    /// Filter Life
    Q_PROPERTY(bool filterLifeReminder READ getFilterLifeReminder NOTIFY filterLifeReminderChanged) //activate when filter life is less than 10%
    Q_PROPERTY(bool filterLifeReminderSnoozed READ getFilterLifeReminderSnoozed NOTIFY filterLifeReminderSnoozedChanged) //activate when filter life is less than 10%
    Q_PROPERTY(int filterLifeMinutes READ getFilterLifeMinutes NOTIFY filterLifeMinutesChanged)
    Q_PROPERTY(short filterLifePercent READ getFilterLifePercent NOTIFY filterLifePercentChanged)
    Q_PROPERTY(QString filterLifeLevelStrf READ getFilterLifeLevelStrf NOTIFY filterLifeLevelStrfChanged)
    Q_PROPERTY(QString filterLifeLevelColorStrf READ getFilterLifeLevelColorStrf NOTIFY filterLifeLevelColorStrfChanged)
    Q_PROPERTY(int filterLifeRpm READ getFilterLifeRpm NOTIFY filterLifeRpmChanged)
    Q_PROPERTY(int filterLifeCalculationMode READ getFilterLifeCalculationMode NOTIFY filterLifeCalculationModeChanged)
    Q_PROPERTY(int filterLifeMinimumBlowerUsageMode READ getFilterLifeMinimumBlowerUsageMode NOTIFY filterLifeMinimumBlowerUsageModeChanged)
    Q_PROPERTY(int filterLifeMaximumBlowerUsageMode READ getFilterLifeMaximumBlowerUsageMode NOTIFY filterLifeMaximumBlowerUsageModeChanged)
    Q_PROPERTY(int filterLifeMinimumBlowerRpmMode READ getFilterLifeMinimumBlowerRpmMode NOTIFY filterLifeMinimumBlowerRpmModeChanged)
    Q_PROPERTY(int filterLifeMaximumBlowerRpmMode READ getFilterLifeMaximumBlowerRpmMode NOTIFY filterLifeMinimumBlowerRpmModeChanged)

    /// Blower Meter
    Q_PROPERTY(int fanUsageMeter
                   READ getFanUsageMeter
                       //               WRITE setFanUsageMeter
                       NOTIFY fanUsageMeterChanged)

    ///ALARM
    Q_PROPERTY(short muteAlarmState READ getMuteAlarmState NOTIFY muteAlarmStateChanged)
    Q_PROPERTY(int muteAlarmTime READ getMuteAlarmTime NOTIFY muteAlarmTimeChanged)
    Q_PROPERTY(int muteAlarmTimeAtFullyOpened READ getMuteAlarmTimeAtFullyOpened NOTIFY muteAlarmTimeAtFullyOpenedChanged)
    Q_PROPERTY(int muteAlarmCountdown READ getMuteAlarmCountdown NOTIFY muteAlarmCountdownChanged)

    ///MOTORIZE
    Q_PROPERTY(short sashWindowMotorizeState
                   READ getSashWindowMotorizeState
                       //               WRITE setSashMotorizeState
                       NOTIFY sashWindowMotorizeStateChanged)
    ///
    Q_PROPERTY(bool sashWindowMotorizeUpInterlocked
                   READ getSashWindowMotorizeUpInterlocked
                       //               WRITE setSashWindowMotorizeUpInterlocked
                       NOTIFY sashWindowMotorizeUpInterlockedChanged)
    ///
    Q_PROPERTY(bool sashWindowMotorizeDownInterlocked
                   READ getSashWindowMotorizeDownInterlocked
                       //               WRITE setSashWindowMotorizeDownInterlocked
                       NOTIFY sashWindowMotorizeDownInterlockedChanged)
    ///
    Q_PROPERTY(bool sashWindowMotorizeInstalled
                   READ getSashWindowMotorizeInstalled
                       //               WRITE setSashWindowMotorizeInstalled
                       NOTIFY sashWindowMotorizeInstalledChanged)

    ///EXHAUST_FREE_RELAY_CONTACT
    Q_PROPERTY(short exhaustContactState
                   READ getExhaustContactState
                       //               WRITE setMuteAlarmState
                       NOTIFY exhaustContactStateChanged)

    ///EXHAUST_ALAM_RELAY_CONTACT
    Q_PROPERTY(short alarmContactState
                   READ getAlarmContactState
                       //               WRITE setSashMotorizeState
                       NOTIFY alarmContactStateChanged)

    ///ALARM
    Q_PROPERTY(bool alarmsState
                   READ getAlarmsState
                       //               WRITE setAlarmsState
                       NOTIFY alarmsStateChanged)
    ///BOARD COMMUNICATION
    Q_PROPERTY(short alarmBoardComError
                   READ getAlarmBoardComError
                       //               WRITE setBoardComError
                       NOTIFY alarmBoardComErrorChanged)
    ///
    Q_PROPERTY(short alarmSash
                   READ getAlarmSash
                       //               WRITE setAlarmSash
                       NOTIFY alarmSashChanged)
    ///
    Q_PROPERTY(short alarmInflowLow
                   READ getAlarmInflowLow
                       //               WRITE setAlarmInflowLow
                       NOTIFY alarmInflowLowChanged)
    ///
    Q_PROPERTY(short alarmTempHigh
                   READ getAlarmTempHigh
                       //               WRITE setAlarmTempHigh
                       NOTIFY alarmTempHighChanged)
    ///
    Q_PROPERTY(short alarmTempLow
                   READ getAlarmTempLow
                       //               WRITE setAlarmTempLow
                       NOTIFY alarmTempLowChanged)
    ///
    Q_PROPERTY(short alarmStandbyFanOff
                   READ getAlarmStandbyFanOff
                       //               WRITE setAlarmSash
                       NOTIFY alarmStandbyFanOffChanged)
    ///
    Q_PROPERTY(short alarmExperimentTimerIsOver READ getAlarmExperimentTimerIsOver NOTIFY alarmExperimentTimerIsOverChanged)


    // Temperature
    Q_PROPERTY(int temperatureAdc
                   READ     getTemperatureAdc
                       //               WRITE    setTemperatureAdc
                       NOTIFY   temperatureAdcChanged)
    //
    Q_PROPERTY(short temperatureCelcius
                   READ     getTemperatureCelcius
                       //               WRITE    setTemperatureCelcius
                       NOTIFY   temperatureAdcChanged)
    //
    Q_PROPERTY(short temperature
                   READ     getTemperature
                       //               WRITE    setTemperature
                       NOTIFY   temperatureChanged)
    //
    Q_PROPERTY(QString temperatureValueStr
                   READ     getTemperatureValueStrf
                       //               WRITE    setTemperatureValueStr
                       NOTIFY   temperatureValueStrfChanged)
    ///
    Q_PROPERTY(short tempAmbientStatus
                   READ getTempAmbientStatus
                       //               WRITE setTempAmbientStatus
                       NOTIFY tempAmbientStatusChanged)

    ///POWER OUTAGE
    Q_PROPERTY(bool powerOutage
                   READ getPowerOutage
                       WRITE setPowerOutage
                           NOTIFY powerOutageChanged)
    Q_PROPERTY(QString powerOutageTime
                   READ getPowerOutageTime
                       //               WRITE setPowerOutageTime
                       NOTIFY powerOutageTimeChanged)
    Q_PROPERTY(QString powerOutageRecoverTime
                   READ getPowerOutageRecoverTime
                       //               WRITE setPowerOutageRecoverTime
                       NOTIFY powerOutageRecoverTimeChanged)
    Q_PROPERTY(short powerOutageFanState
                   READ getPowerOutageFanState
                       //               WRITE setPowerOutageFanState
                       NOTIFY powerOutageFanStateChanged)
    //    Q_PROPERTY(short powerOutageLightState
    //               READ getPowerOutageLightState
    //               //               WRITE setPowerOutageLightState
    //               NOTIFY powerOutageLightStateChanged)
    Q_PROPERTY(short powerOutageUvState
                   READ getPowerOutageUvState
                       //               WRITE setPowerOutageUvState
                       NOTIFY powerOutageUvStateChanged)

    /// AIRFLOW
    Q_PROPERTY(bool      airflowMonitorEnable
                   READ     getAirflowMonitorEnable
                       //               WRITE    setAirflowMonitorEnable
                       NOTIFY   airflowMonitorEnableChanged)

    Q_PROPERTY(int      ifaAdc
                   READ     getInflowAdc
                       //               WRITE    setInflowAdc
                       NOTIFY   ifaAdcChanged)

    Q_PROPERTY(int      ifaAdcConpensation
                   READ     getInflowAdcConpensation
                       //               WRITE    setInflowAdcConpensation
                       NOTIFY   ifaAdcConpensationChanged)

    Q_PROPERTY(int ifaVelocity
                   READ getInflowVelocity
                       //               WRITE setIfaVelocity
                       NOTIFY ifaVelocityChanged)

    Q_PROPERTY(QString  ifaVelocityStr
                   READ     getInflowVelocityStr
                       //               WRITE    setInflowVelocityStr
                       NOTIFY   ifaVelocityStrChanged)

    Q_PROPERTY(int dfaVelocity
                   READ getDownflowVelocity
                       //               WRITE setIfaVelocity
                       NOTIFY dfaVelocityChanged)

    Q_PROPERTY(QString  dfaVelocityStr
                   READ     getDownflowVelocityStr
                       //               WRITE    setDownflowVelocityStr
                       NOTIFY   dfaVelocityStrChanged)

    Q_PROPERTY(short airflowCalibrationStatus
                   READ     getAirflowCalibrationStatus
                       //               WRITE    setAirflowCalibrationMode
                       NOTIFY   airflowCalibrationStatusChanged)

    ///WARMING UP
    Q_PROPERTY(bool warmingUpActive
                   READ getWarmingUpActive
                       //               WRITE setWarmingUpRunning
                       NOTIFY warmingUpActiveChanged)
    ///
    Q_PROPERTY(bool warmingUpExecuted
                   READ getWarmingUpExecuted
                       //               WRITE setWarmingUpExecuted
                       NOTIFY warmingUpExecutedChanged)
    ///
    Q_PROPERTY(int warmingUpTime
                   READ getWarmingUpTime
                       //               WRITE setWarmingUpTime
                       NOTIFY warmingUpTimeChanged)
    ///
    Q_PROPERTY(int warmingUpCountdown
                   READ getWarmingUpCountdown
                       //               WRITE setWarmingUpCountdown
                       NOTIFY warmingUpCountdownChanged)

    ///POST PURGING
    Q_PROPERTY(bool postPurgingActive
                   READ getPostPurgingActive
                       //               WRITE setPostPurgingRunning
                       NOTIFY postPurgingActiveChanged)
    ///
    Q_PROPERTY(int postPurgingTime
                   READ getPostPurgingTime
                       //               WRITE setPostPurgingTime
                       NOTIFY postPurgingTimeChanged)
    ///
    Q_PROPERTY(int postPurgingCountdown
                   READ getPostPurgingCountdown
                       //               WRITE setPostPurgingCountdown
                       NOTIFY postPurgingCountdownChanged)

    /// Measurement Unit
    Q_PROPERTY(short    measurementUnit
                   READ     getMeasurementUnit
                       //               WRITE    setMeasurementUnit
                       NOTIFY   measurementUnitChanged)

    /// Operation Mode
    Q_PROPERTY(short operationMode
                   READ getOperationMode
                       //               WRITE setOperationMode
                       NOTIFY operationModeChanged)

    /// Security Access
    Q_PROPERTY(short securityAccessMode
                   READ getSecurityAccessMode
                       //                              WRITE setSecurityAccessMode
                       NOTIFY securityAccessChanged)

    /// Certification reminder date
    Q_PROPERTY(QString dateCertificationReminder
                   READ getDateCertificationReminder
                       //               WRITE setDateCertificationReminder
                       NOTIFY dateCertificationReminderChanged)
    Q_PROPERTY(bool certificationExpired
                   READ getCertificationExpired
                       //               WRITE setCertificationExpired
                       NOTIFY certificationExpiredChanged)
    Q_PROPERTY(int certificationExpiredCount
                   READ getCertificationExpiredCount
                       //               WRITE setCertificationExpiredCount
                       NOTIFY certificationExpiredCountChanged)
    Q_PROPERTY(bool certificationExpiredValid
                   READ getCertificationExpiredValid
                       //               WRITE setCertificationExpiredValid
                       NOTIFY certificationExpiredValidChanged)

    /// Serial Number
    Q_PROPERTY(QString serialNumber READ getSerialNumber WRITE setSerialNumber NOTIFY serialNumberChanged)

    /// LCD
    Q_PROPERTY(short lcdBrightnessLevel READ getLcdBrightnessLevel NOTIFY lcdBrightnessLevelChanged)
    Q_PROPERTY(short lcdBrightnessLevelUser READ getLcdBrightnessLevelUser NOTIFY lcdBrightnessLevelUserChanged)
    Q_PROPERTY(bool lcdBrightnessLevelDimmed READ getLcdBrightnessLevelDimmed NOTIFY lcdBrightnessLevelDimmedChanged)
    Q_PROPERTY(short lcdBrightnessDelayToDimm READ getLcdBrightnessDelayToDimm NOTIFY lcdBrightnessDelayToDimmChanged)
    Q_PROPERTY(bool lcdEnableLockScreen READ getLcdEnableLockScreen NOTIFY lcdEnableLockScreenChanged)

    /// language
    Q_PROPERTY(QString language READ getLanguage NOTIFY languageChanged)

    /// TimeZone
    /// example value: Asia/Jakarta#7#UTC+07:00
    Q_PROPERTY(QString timeZone READ getTimeZone NOTIFY timeZoneChanged)

    /// Time Period
    /// 12 = 12h
    /// 24 = 24h
    Q_PROPERTY(short timeClockPeriod
                   READ getTimeClockPeriod
                       //               WRITE setTimeClockPeriod
                       NOTIFY timeClockPeriodChanged)

    /// Data Log
    Q_PROPERTY(short dataLogPeriod
                   READ getDataLogPeriod
                       //               WRITE setDataLogPeriod
                       NOTIFY dataLogPeriodChanged)

    Q_PROPERTY(bool dataLogRunning
                   READ getDataLogRunning
                       //               WRITE setDataLogRunning
                       NOTIFY dataLogRunningChanged)

    Q_PROPERTY(bool dataLogEnable
                   READ getDataLogEnable
                       //               WRITE setDataLogEnable
                       NOTIFY dataLogEnableChanged)

    /// maximum rows using integer is 2M+
    /// 1 Years = 525960 Minutes (rows)
    /// 10 Years = 5259600 Minutes (rows)
    Q_PROPERTY(int dataLogCount
                   READ getDataLogCount
                       //               WRITE setDataLogCount
                       NOTIFY dataLogCountChanged)
    Q_PROPERTY(bool dataLogIsFull
                   READ getDataLogIsFull
                       //               WRITE setDataLogIsFull
                       NOTIFY dataLogIsFullChanged)
    Q_PROPERTY(int dataLogSpaceMaximum
                   READ getDataLogSpaceMaximum
                       //               WRITE setDataLogSpaceMaximum
                       NOTIFY dataLogSpaceMaximumChanged)

    /// ALARM LOG
    /// maximum rows using integer is 2M+ / 32 bit
    /// 10 Years = 315569520 rows, if 1 alarm 1 second
    Q_PROPERTY(int alarmLogCount
                   READ getAlarmLogCount
                       //               WRITE setAlarmLogCount
                       NOTIFY alarmLogCountChanged)
    Q_PROPERTY(bool alarmLogIsFull
                   READ getAlarmLogIsFull
                       //               WRITE setAlarmLogIsFull
                       NOTIFY alarmLogIsFullChanged)
    Q_PROPERTY(int alarmLogSpaceMaximum
                   READ getAlarmLogSpaceMaximum
                       //               WRITE setAlarmLogSpaceMaximum
                       NOTIFY alarmLogSpaceMaximumChanged)

    /// EVENT LOG
    /// maximum rows using integer is 2M+ / 32 bit
    /// 10 Years = 315569520 rows, if 1 alarm 1 second
    Q_PROPERTY(int eventLogCount
                   READ getEventLogCount
                       NOTIFY eventLogCountChanged)
    Q_PROPERTY(bool eventLogIsFull
                   READ getEventLogIsFull
                       NOTIFY eventLogIsFullChanged)
    Q_PROPERTY(int eventLogSpaceMaximum
                   READ getEventLogSpaceMaximum
                       NOTIFY eventLogSpaceMaximumChanged)
    /// REPLACEABLECOMPONENT RECORD
    Q_PROPERTY(int replaceableCompRecordCount
                   READ getReplaceableCompRecordCount
                       NOTIFY replaceableCompRecordCountChanged)
    Q_PROPERTY(bool replaceableCompRecordIsFull
                   READ getReplaceableCompRecordIsFull
                       NOTIFY replaceableCompRecordIsFullChanged)
    Q_PROPERTY(int replaceableCompRecordSpaceMaximum
                   READ getReplaceableCompRecordSpaceMaximum
                       NOTIFY replaceableCompRecordSpaceMaximumChanged)
    /// RESOURCE MONITOR
    Q_PROPERTY(short resourceMonitorLogPeriod READ getResourceMonitorLogPeriod NOTIFY resourceMonitorLogPeriodChanged)
    Q_PROPERTY(bool resourceMonitorLogRunning READ getResourceMonitorLogRunning NOTIFY resourceMonitorLogRunningChanged)
    Q_PROPERTY(bool resourceMonitorLogEnable READ getResourceMonitorLogEnable NOTIFY resourceMonitorLogEnableChanged)
    Q_PROPERTY(int resourceMonitorLogCount READ getResourceMonitorLogCount NOTIFY resourceMonitorLogCountChanged)
    Q_PROPERTY(bool resourceMonitorLogIsFull READ getResourceMonitorLogIsFull NOTIFY resourceMonitorLogIsFullChanged)
    Q_PROPERTY(int resourceMonitorLogSpaceMaximum READ getResourceMonitorLogSpaceMaximum NOTIFY resourceMonitorLogSpaceMaximumChanged)

    ///MODBUS
    Q_PROPERTY(short modbusSlaveID
                   READ getModbusSlaveID
                       WRITE setModbusSlaveID
                           NOTIFY modbusSlaveIDChanged)
    ///
    Q_PROPERTY(QString modbusAllowIpMaster
                   READ getModbusAllowIpMaster
                       //               WRITE setModbusAllowIpMaster
                       NOTIFY modbusAllowIpMasterChanged)
    ///
    Q_PROPERTY(bool modbusAllowSetFan
                   READ getModbusAllowSetFan
                       //               WRITE setModbusAllowSetFan
                       NOTIFY modbusAllowSetFanChanged)
    ///
    Q_PROPERTY(bool modbusAllowSetLight
                   READ getModbusAllowSetLight
                       //               WRITE setModbusAllowSetLight
                       NOTIFY modbusAllowSetLightChanged)
    ///
    Q_PROPERTY(bool modbusAllowSetLightIntensity
                   READ getModbusAllowSetLightIntensity
                       //               WRITE setModbusAllowSetLightIntensity
                       NOTIFY modbusAllowSetLightIntensityChanged)
    ///
    Q_PROPERTY(bool modbusAllowSetSocket
                   READ getModbusAllowSetSocket
                       //               WRITE setModbusAllowSetSocket
                       NOTIFY modbusAllowSetSocketChanged)
    ///
    Q_PROPERTY(bool modbusAllowSetGas
                   READ getModbusAllowSetGas
                       //               WRITE setModbusAllowGasSet
                       NOTIFY modbusAllowGasSetChanged)
    ///
    Q_PROPERTY(bool modbusAllowSetUvLight
                   READ getModbusAllowSetUvLight
                       //               WRITE setModbusAllowSetUvLight
                       NOTIFY modbusAllowSetUvLightChanged)
    ///
    Q_PROPERTY(QString modbusLatestStatus
                   READ getModbusLatestStatus
                       //               WRITE setModbusLatestStatus
                       NOTIFY modbusLatestStatusChanged)

    ////
    Q_PROPERTY(QString machineClassName
                   READ getMachineClassName
                       WRITE setMachineClassName
                           NOTIFY machineClassNameChanged)
    ////
    Q_PROPERTY(QString machineModelName
                   READ getMachineModelName
                       WRITE setMachineModelName
                           NOTIFY machineModelNameChanged)
    ////
    Q_PROPERTY(QJsonObject machineProfile READ getMachineProfile WRITE setMachineProfile NOTIFY machineProfileChanged)
    ///
    Q_PROPERTY(QString cabinetDisplayName
                   READ getCabinetDisplayName
                       //               WRITE setCabinetDisplayName
                       NOTIFY cabinetDisplayNameChanged)

    /// Board Status
    Q_PROPERTY(bool boardStatusHybridDigitalRelay
                   READ getBoardStatusHybridDigitalRelay
                       //               WRITE setBoardStatusHybridDigitalRelay
                       NOTIFY boardStatusHybridDigitalRelayChanged)

    Q_PROPERTY(bool boardStatusHybridDigitalInput
                   READ getBoardStatusHybridDigitalInput
                       //               WRITE setBoardStatusHybridDigitalInput
                       NOTIFY boardStatusHybridDigitalInputChanged)

    Q_PROPERTY(bool boardStatusHybridAnalogInput
                   READ getBoardStatusHybridAnalogInput
                       //               WRITE setBoardStatusHybridAnalogInput
                       NOTIFY boardStatusHybridAnalogInputChanged)

    Q_PROPERTY(bool boardStatusHybridAnalogOutput READ getBoardStatusHybridAnalogOutput NOTIFY boardStatusHybridAnalogOutputChanged)
    Q_PROPERTY(bool boardStatusHybridAnalogOutput2 READ getBoardStatusHybridAnalogOutput2 NOTIFY boardStatusHybridAnalogOutput2Changed)


    Q_PROPERTY(bool boardStatusRbmCom
                   READ getBoardStatusRbmCom
                       //               WRITE setBoardStatusRbmCom
                       NOTIFY boardStatusRbmComChanged)

    Q_PROPERTY(bool boardStatusPressureDiff
                   READ getBoardStatusPressureDiff
                       //               WRITE setBoardStatusPressureDiff
                       NOTIFY boardStatusPressureDiffChanged)

    Q_PROPERTY(bool boardStatusCtpRtc
                   READ getBoardStatusCtpRtc
                       //               WRITE setBoardStatusCtpRtc
                       NOTIFY boardStatusCtpRtcChanged)

    Q_PROPERTY(bool boardStatusCtpIoe
                   READ getBoardStatusCtpIoe
                       //               WRITE setBoardStatusCtpIoe
                       NOTIFY boardStatusCtpIoeChanged)

    Q_PROPERTY(bool boardStatusParticleCounter
                   READ getBoardStatusParticleCounter
                       //               WRITE setBoardStatusParticleCounter
                       NOTIFY boardStatusParticleCounterChanged)

    Q_PROPERTY(int escoLockServiceEnable
                   READ getEscoLockServiceEnable
                       //               WRITE setEscoLockServiceEnable
                       NOTIFY escoLockServiceEnableChanged)

    Q_PROPERTY(QString fanPIN
                   READ getFanPIN
                       //               WRITE setFanPIN
                       NOTIFY fanPINChanged)

    Q_PROPERTY(int sashCycleMeter
                   READ getSashCycleMeter
                       //               WRITE setSashCycleMeter
                       NOTIFY sashCycleMeterChanged)

    Q_PROPERTY(short sashCycleMotorLockedAlarm
                   READ getSashCycleMotorLockedAlarm
                       //               WRITE setSashCycleMeter
                       NOTIFY sashCycleMotorLockedAlarmChanged)

    Q_PROPERTY(int envTempLowestLimit
                   READ getEnvTempLowestLimit
                       //               WRITE setEnvTempLowestLimit
                       NOTIFY envTempLowestLimitChanged)

    Q_PROPERTY(int envTempHighestLimit
                   READ getEnvTempHighestLimit
                       //               WRITE setEnvTempHighestLimit
                       NOTIFY envTempHighestLimitChanged)

    /// PARTICLE COUNTER
    Q_PROPERTY(int particleCounterPM2_5
                   READ getParticleCounterPM2_5
                       //               WRITE setParticleCounterPM2_5
                       NOTIFY particleCounterPM2_5Changed)

    Q_PROPERTY(int particleCounterPM1_0
                   READ getParticleCounterPM1_0
                       //               WRITE setParticleCounterPM1_0
                       NOTIFY particleCounterPM1_0Changed)

    Q_PROPERTY(int particleCounterPM10
                   READ getParticleCounterPM10
                       //               WRITE setParticleCounterPM10
                       NOTIFY particleCounterPM10Changed)

    Q_PROPERTY(short particleCounterSensorFanState
                   READ getParticleCounterSensorFanState
                       //               WRITE setParticleCounterSensorFanState
                       NOTIFY particleCounterSensorFanStateChanged)

    Q_PROPERTY(bool particleCounterSensorInstalled
                   READ getParticleCounterSensorInstalled
                       //               WRITE setParticleCounterSensorInstalled
                       NOTIFY particleCounterSensorInstalledChanged)

    /// VIVARIUM MUTE
    Q_PROPERTY(bool vivariumMuteState
                   READ getVivariumMuteState
                       //               WRITE setVivariumMuteState
                       NOTIFY vivariumMuteStateChanged)

    /// RTC_WATCHDOG
    Q_PROPERTY(int watchdogCounter
                   READ getWatchdogCounter
                       //               WRITE setWatchdogCounter
                       NOTIFY watchdogCounterChanged)
    Q_PROPERTY(QString rtcActualDate
                   READ getRtcActualDate
                       //               WRITE setRtcActualDate
                       NOTIFY rtcActualDateChanged)
    Q_PROPERTY(QString rtcActualTime
                   READ getRtcActualTime
                       //               WRITE setRtcActualTime
                       NOTIFY rtcActualTimeChanged)
    Q_PROPERTY(bool rtcBatteryLowStatus READ getRtcBatteryLowStatus NOTIFY rtcBatteryLowStatusChanged)

    /// SHIPPING MODE
    Q_PROPERTY(bool shippingModeEnable
                   READ getShippingModeEnable
                       //               WRITE setShippingModeEnable
                       NOTIFY shippingModeEnableChanged)

    Q_PROPERTY(QString machineProfileID READ getMachineProfileID WRITE setMachineProfileID NOTIFY machineProfileIDChanged)

    /// PREVENTIVE MAINTENANCE
    Q_PROPERTY(QJsonObject maintenanceChecklist READ getMaintenanceChecklist WRITE setMaintenanceChecklist NOTIFY maintenanceChecklistChanged)
    Q_PROPERTY(bool alarmPreventMaintActive READ getAlarmPreventMaintActive WRITE setAlarmPreventMaintActive NOTIFY alarmPreventMaintActiveChanged)
    Q_PROPERTY(ushort alarmPreventMaintActiveCode READ getAlarmPreventMaintActiveCode WRITE setAlarmPreventMaintActiveCode NOTIFY alarmPreventMaintActiveCodeChanged)

    Q_PROPERTY(ushort alarmPreventMaintState READ getAlarmPreventMaintState NOTIFY alarmPreventMaintStateChanged)
    Q_PROPERTY(ushort alarmPreventMaintStateEnable READ getAlarmPreventMaintStateEnable NOTIFY alarmPreventMaintStateEnableChanged)
    Q_PROPERTY(ushort alarmPreventMaintStateAck READ getAlarmPreventMaintStateAck NOTIFY alarmPreventMaintStateAckChanged)
    //    Q_PROPERTY(ushort preventMaintChecklistNotEmpty READ getPreventMaintChecklistNotEmpty WRITE setPreventMaintChecklistNotEmpty NOTIFY preventMaintChecklistNotEmptyChanged)

    //    Q_PROPERTY(bool dailyPreventMaintAck READ getDailyPreventMaintAck NOTIFY dailyPreventMaintAckChanged)
    //    Q_PROPERTY(bool weeklyPreventMaintAck READ getWeeklyPreventMaintAck NOTIFY weeklyPreventMaintAckChanged)
    //    Q_PROPERTY(bool monthlyPreventMaintAck READ getMonthlyPreventMaintAck NOTIFY monthlyPreventMaintAckChanged)
    //    Q_PROPERTY(bool quarterlyPreventMaintAck READ getQuarterlyPreventMaintAck NOTIFY quarterlyPreventMaintAckChanged)
    //    Q_PROPERTY(bool annuallyPreventMaintAck READ getAnnuallyPreventMaintAck NOTIFY annuallyPreventMaintAckChanged)
    //    Q_PROPERTY(bool bienniallyPreventMaintAck READ getBienniallyPreventMaintAck NOTIFY bienniallyPreventMaintAckChanged)
    //    Q_PROPERTY(bool quinquenniallyPreventMaintAck READ getQuinquenniallyPreventMaintAck NOTIFY quinquenniallyPreventMaintAckChanged)
    //    Q_PROPERTY(bool canopyPreventMaintAck READ getCanopyPreventMaintAck NOTIFY canopyPreventMaintAckChanged)

    Q_PROPERTY(QString dailyPreventMaintAckDueDate READ getDailyPreventMaintAckDueDate NOTIFY dailyPreventMaintAckDueDateChanged)
    Q_PROPERTY(QString weeklyPreventMaintAckDueDate READ getWeeklyPreventMaintAckDueDate NOTIFY weeklyPreventMaintAckDueDateChanged)
    Q_PROPERTY(QString monthlyPreventMaintAckDueDate READ getMonthlyPreventMaintAckDueDate NOTIFY monthlyPreventMaintAckDueDateChanged)
    Q_PROPERTY(QString quarterlyPreventMaintAckDueDate READ getQuarterlyPreventMaintAckDueDate NOTIFY quarterlyPreventMaintAckDueDateChanged)
    Q_PROPERTY(QString annuallyPreventMaintAckDueDate READ getAnnuallyPreventMaintAckDueDate NOTIFY annuallyPreventMaintAckDueDateChanged)
    Q_PROPERTY(QString bienniallyPreventMaintAckDueDate READ getBienniallyPreventMaintAckDueDate NOTIFY bienniallyPreventMaintAckDueDateChanged)
    Q_PROPERTY(QString quinquenniallyPreventMaintAckDueDate READ getQuinquenniallyPreventMaintAckDueDate NOTIFY quinquenniallyPreventMaintAckDueDateChanged)
    Q_PROPERTY(QString canopyPreventMaintAckDueDate READ getCanopyPreventMaintAckDueDate NOTIFY canopyPreventMaintAckDueDateChanged)

    Q_PROPERTY(QString dailyPreventMaintLastAckDate READ getDailyPreventMaintLastAckDate NOTIFY dailyPreventMaintLastAckDateChanged)
    Q_PROPERTY(QString weeklyPreventMaintLastAckDate READ getWeeklyPreventMaintLastAckDate NOTIFY weeklyPreventMaintLastAckDateChanged)
    Q_PROPERTY(QString monthlyPreventMaintLastAckDate READ getMonthlyPreventMaintLastAckDate NOTIFY monthlyPreventMaintLastAckDateChanged)
    Q_PROPERTY(QString quarterlyPreventMaintLastAckDate READ getQuarterlyPreventMaintLastAckDate NOTIFY quarterlyPreventMaintLastAckDateChanged)
    Q_PROPERTY(QString annuallyPreventMaintLastAckDate READ getAnnuallyPreventMaintLastAckDate NOTIFY annuallyPreventMaintLastAckDateChanged)
    Q_PROPERTY(QString bienniallyPreventMaintLastAckDate READ getBienniallyPreventMaintLastAckDate NOTIFY bienniallyPreventMaintLastAckDateChanged)
    Q_PROPERTY(QString quinquenniallyPreventMaintLastAckDate READ getQuinquenniallyPreventMaintLastAckDate NOTIFY quinquenniallyPreventMaintLastAckDateChanged)
    Q_PROPERTY(QString canopyPreventMaintLastAckDate READ getCanopyPreventMaintLastAckDate NOTIFY canopyPreventMaintLastAckDateChanged)

    Q_PROPERTY(int dailyPreventMaintRemindBefore READ getDailyPreventMaintRemindBefore NOTIFY dailyPreventMaintRemindBeforeChanged)
    Q_PROPERTY(int weeklyPreventMaintRemindBefore READ getWeeklyPreventMaintRemindBefore NOTIFY weeklyPreventMaintRemindBeforeChanged)
    Q_PROPERTY(int monthlyPreventMaintRemindBefore READ getMonthlyPreventMaintRemindBefore NOTIFY monthlyPreventMaintRemindBeforeChanged)
    Q_PROPERTY(int quarterlyPreventMaintRemindBefore READ getQuarterlyPreventMaintRemindBefore NOTIFY quarterlyPreventMaintRemindBeforeChanged)
    Q_PROPERTY(int annuallyPreventMaintRemindBefore READ getAnnuallyPreventMaintRemindBefore NOTIFY annuallyPreventMaintRemindBeforeChanged)
    Q_PROPERTY(int bienniallyPreventMaintRemindBefore READ getBienniallyPreventMaintRemindBefore NOTIFY bienniallyPreventMaintRemindBeforeChanged)
    Q_PROPERTY(int quinquenniallyPreventMaintRemindBefore READ getQuinquenniallyPreventMaintRemindBefore NOTIFY quinquenniallyPreventMaintRemindBeforeChanged)
    Q_PROPERTY(int canopyPreventMaintRemindBefore READ getCanopyPreventMaintRemindBefore NOTIFY canopyPreventMaintRemindBeforeChanged)
    Q_PROPERTY(bool wiredNetworkHasbeenConfigured     READ getWiredNetworkHasbeenConfigured      NOTIFY wiredNetworkHasbeenConfiguredChanged)

    Q_PROPERTY(bool svnUpdateAvailable READ getSvnUpdateAvailable NOTIFY svnUpdateAvailableChanged)
    Q_PROPERTY(QString svnUpdateSwuVersion READ getSvnUpdateSwuVersion NOTIFY svnUpdateSwuVersionChanged)
    Q_PROPERTY(QString svnUpdatePath READ getSvnUpdatePath NOTIFY svnUpdatePathChanged)
    Q_PROPERTY(QJsonObject svnUpdateHistory READ getSvnUpdateHistory NOTIFY svnUpdateHistoryChanged)
    Q_PROPERTY(bool svnUpdateCheckForUpdateEnable READ getSvnUpdateCheckForUpdateEnable NOTIFY svnUpdateCheckForUpdateEnableChanged)
    Q_PROPERTY(int svnUpdateCheckForUpdatePeriod READ getSvnUpdateCheckForUpdatePeriod NOTIFY svnUpdateCheckForUpdatePeriodChanged)

    ////
    Q_PROPERTY(QJsonObject rpListDefault READ getRpListDefault WRITE setRpListDefault NOTIFY rpListDefaultChanged)
    Q_PROPERTY(QVariantList rpListLast READ getRpListLast NOTIFY rpListLastChanged)
    Q_PROPERTY(QVariantList rpListSelected READ getRpListSelected NOTIFY rpListSelectedChanged)
    Q_PROPERTY(QString keyboardStringOnAcceptedEvent READ getKeyboardStringOnAcceptedEvent NOTIFY keyboardStringOnAcceptedEventChanged)

    Q_PROPERTY(QJsonArray userLastLogin READ getUserLastLogin NOTIFY userLastLoginChanged)

    /// USB Auto Mount
    Q_PROPERTY(QString usbDetectedList READ getUsbDetectedList NOTIFY usbDetectedListChanged)
    Q_PROPERTY(QString lastUsbDetectedName READ getLastUsbDetectedName NOTIFY lastUsbDetectedNameChanged)

    ///
    Q_PROPERTY(short frontEndScreenState READ getFrontEndScreenState NOTIFY frontEndScreenStateChanged)
    Q_PROPERTY(short frontEndScreenStatePrev READ getFrontEndScreenStatePrev NOTIFY frontEndScreenStatePrevChanged)
    Q_PROPERTY(bool installationWizardActive READ getInstallationWizardActive NOTIFY installationWizardActiveChanged)
    Q_PROPERTY(int cabinetUpTime READ getCabinetUpTime NOTIFY cabinetUpTimeChanged)

    /// FRONT PANEL SWITCH LA2 EU
    Q_PROPERTY(bool frontPanelSwitchInstalled READ getFrontPanelSwitchInstalled NOTIFY frontPanelSwitchInstalledChanged)
    Q_PROPERTY(bool frontPanelSwitchState READ getFrontPanelSwitchState NOTIFY frontPanelSwitchStateChanged)
    Q_PROPERTY(short frontPanelAlarm READ getFrontPanelAlarm NOTIFY frontPanelAlarmChanged)
    ///SASH MOTORIZED
    Q_PROPERTY(bool sashMotorDownStuckSwitch READ getSashMotorDownStuckSwitch NOTIFY sashMotorDownStuckSwitchChanged)
    Q_PROPERTY(short alarmSashMotorDownStuck READ getAlarmSashMotorDownStuck NOTIFY alarmSashMotorDownStuckChanged)
    Q_PROPERTY(short sashWindowSafeHeight2 READ getSashWindowSafeHeight2 NOTIFY sashWindowSafeHeight2Changed)
    Q_PROPERTY(short sashMotorOffDelayMsec READ getSashMotorOffDelayMsec NOTIFY sashMotorOffDelayMsecChanged)

    ///Resource Monitor
    //    Q_PROPERTY(bool resourceMonitorParamsActive READ getResourceMonitorParamsActive NOTIFY resourceMonitorParamsActiveChanged)
    Q_PROPERTY(QStringList resourceMonitorParams READ getResourceMonitorParams NOTIFY resourceMonitorParamsChanged)
    Q_PROPERTY(bool uSdCardIndustrial READ getUSdCardIndustrial NOTIFY uSdCardIndustrialChanged)

    /// Filter Life Display
    Q_PROPERTY(bool filterLifeDisplayEnabled READ getFilterLifeDisplayEnabled NOTIFY filterLifeDisplayEnabledChanged)

    /// AIRFLOW OUT TEMP
    Q_PROPERTY(bool airflowOutTempEnable READ getAirflowOutTempEnable NOTIFY   airflowOutTempEnableChanged)

    /// SENSOR CONSTANT CORRECTION
    Q_PROPERTY(bool sensorConstCorrEnable READ getSensorConstCorrEnable NOTIFY sensorConstCorrEnableChanged)
    Q_PROPERTY(int sensorConstCorrHighZone READ getSensorConstCorrHighZone NOTIFY sensorConstCorrHighZoneChanged)
    Q_PROPERTY(int sensorConstCorrLowZone READ getSensorConstCorrLowZone NOTIFY sensorConstCorrLowZoneChanged)

    /// HYBRID ANALOG INPUT MVOLT
    Q_PROPERTY(int haBoardInputCh1MVolt READ getHaBoardInputCh1MVolt NOTIFY haBoardInputCh1MVoltChanged)
    Q_PROPERTY(int haBoardInputCh2MVolt READ getHaBoardInputCh2MVolt NOTIFY haBoardInputCh2MVoltChanged)

    ///
    Q_PROPERTY(short inflowSensorConstant READ getInflowSensorConstant NOTIFY inflowSensorConstantChanged)

    /// LOGOUT TIME
    Q_PROPERTY(int logoutTime READ getLogoutTime NOTIFY logoutTimeChanged)

    /// 21 CFR PART 11
    Q_PROPERTY(bool cfr21Part11Enable READ getCfr21Part11Enable NOTIFY cfr21Part11EnableChanged)

    ///
    Q_PROPERTY(short fanSpeedControllerBoard READ getFanSpeedControllerBoard WRITE setFanSpeedControllerBoard NOTIFY fanSpeedControllerBoardChanged)

    ///
    Q_PROPERTY(bool propogateComposeEventGesture READ getPropogateComposeEventGesture NOTIFY propogateComposeEventGestureChanged)

    /// ADVANCED AIRFLOW ALARM
    Q_PROPERTY(bool  advancedAirflowAlarmEnable   READ getAdvancedAirflowAlarmEnable    NOTIFY advancedAirflowAlarmEnableChanged)
    Q_PROPERTY(short alarmDownflowLow       READ getAlarmDownflowLow        NOTIFY alarmDownflowLowChanged) //(< -10 fpm from nominal)
    Q_PROPERTY(short alarmDownflowHigh      READ getAlarmDownflowHigh       NOTIFY alarmDownflowHighChanged) //(> +10 fpm from nominal)

    /// Booking Schedule
    Q_PROPERTY(bool         bookingScheduleNotifEnable          READ getBookingScheduleNotifEnable          NOTIFY bookingScheduleNotifEnableChanged)
    Q_PROPERTY(int          bookingScheduleNotifTime            READ getBookingScheduleNotifTime            NOTIFY bookingScheduleNotifTimeChanged)
    Q_PROPERTY(bool         bookingScheduleNotifCollapse        READ getBookingScheduleNotifCollapse        NOTIFY bookingScheduleNotifCollapseChanged)
    Q_PROPERTY(QVariantList bookingScheduleTodayVarList         READ getBookingScheduleTodayVarList         NOTIFY bookingScheduleTodayVarListChanged)
    Q_PROPERTY(QVariantList bookingScheduleTodayVarListToShow   READ getBookingScheduleTodayVarListToShow   NOTIFY bookingScheduleTodayVarListToShowChanged)
    Q_PROPERTY(bool bookingScheduleTodayDispNotif    READ getBookingScheduleTodayDispNotif NOTIFY bookingScheduleTodayDispNotifChanged)

    /// Experiment Timer
    Q_PROPERTY(bool experimentTimerAlwaysShow READ getExperimentTimerAlwaysShow NOTIFY experimentTimerAlwaysShowChanged)

    Q_PROPERTY(int fanSpeedMaxLimit         READ getFanSpeedMaxLimit        NOTIFY fanSpeedMaxLimitChanged)
    Q_PROPERTY(int fanSpeedMaxLimitSaved    READ getFanSpeedMaxLimitSaved   NOTIFY fanSpeedMaxLimitSavedChanged)
    Q_PROPERTY(int fanSpeedFullEnable       READ getFanSpeedFullEnable      NOTIFY fanSpeedFullEnableChanged)

    /// System Time And Date
    Q_PROPERTY(QString systemActualDate READ getSystemActualDate NOTIFY systemActualDateChanged)
    Q_PROPERTY(QString systemActualTime READ getSystemActualTime NOTIFY systemActualTimeChanged)

    /// RP Database External Resources
    //    Q_PROPERTY(QJsonObject rpExtDatabase READ getRpExtDatabase NOTIFY rpExtDatabaseChanged)
    Q_PROPERTY(bool rpExtDatabaseEnable READ getRpExtDatabaseEnable NOTIFY rpExtDatabaseEnableChanged)

public:
    static QObject *singletonProvider(QQmlEngine *qmlEngine, QJSEngine *);
    static void singletonDelete();

    explicit MachineData(QObject *parent = nullptr);
    ~MachineData() override;

    Q_INVOKABLE short getMachineBackendState() const;
    void setMachineBackendState(short getMachineBackendState);

    int getCount() const;
    void setCount(int count);

    bool getHasStopped() const;
    void setHasStopped(bool hasStopped);

    void setMachineProfileID(const QString &value);
    QString getMachineProfileID()const;
    ///CONTROL STATE

    ///SASH
    short getSashWindowState() const;
    void setSashWindowState(short sashWindowState);
    short getSashWindowStateSample(short index) const;
    void setSashWindowStateSample(short sashWindowState, short index);
    bool getSashWindowStateChangedValid() const;
    void setSashWindowStateChangedValid(bool value);

    ///FAN
    short getFanPrimaryState() const;
    void setFanPrimaryState(short fanPrimaryState);
    ///
    bool getFanPrimaryInterlocked() const;
    void setFanPrimaryInterlocked(short fanPrimaryInterlocked);

    ///LIGHT
    void setLightInterlocked(bool lightInterlocked);
    bool getLightInterlocked() const;
    ///
    short getLightState() const;
    void setLightState(short lightState);
    ///
    short getLightIntensity() const;
    void setLightIntensity(short lightIntensity);

    ///SOCKET
    void setSocketInterlocked(bool socketInterlocked);
    bool getSocketInterlocked() const;
    ///
    short getSocketState() const;
    void setSocketState(short socketState);
    ///
    bool getSocketInstalled() const;
    void setSocketInstalled(bool socketInstalled);

    ///GAS
    bool getGasInterlocked() const;
    void setGasInterlocked(bool gasInterlocked);
    ///
    short getGasState() const;
    void setGasState(short gasState);
    ///
    bool getGasInstalled() const;
    void setGasInstalled(bool gasInstalled);

    ///UV
    bool getUvInterlocked() const;
    void setUvInterlocked(bool uvInterlocked);
    ///
    short getUvState() const;
    void setUvState(short uvState);
    ///
    bool getUvInstalled() const;
    void setUvInstalled(bool uvInstalled);
    /// UV TIME
    bool getUvTimeActive() const;
    void setUvTimeActive(bool uvTimeActive);
    ///
    int getUvTime() const;
    void setUvTime(int uvTime);
    ///
    int getUvTimeCountdown() const;
    void setUvTimeCountdown(int uvTimeCountdown);
    ///UV LIFE
    int getUvLifeMinutes() const;
    void setUvLifeMinutes(int uvLifeMinutes);
    ///
    short getUvLifePercent() const;
    void setUvLifePercent(short uvLifePercent);
    QString getUvLifeLevelColorStrf() const;
    void setUvLifeLevelColorStrf(const QString &value);

    bool getUvReplacementReminder() const;
    void setUvReplacementReminder(bool value);
    bool getUvReplacementReminderSnoozed() const;
    void setUvReplacementReminderSnoozed(bool value);

    //// SASH-MOTORIZE
    short getSashWindowPrevState() const;
    void setSashWindowPrevState(short sashMotorizeState);
    ///
    short getSashWindowMotorizeState() const;
    void setSashWindowMotorizeState(short sashMotorizeState);
    ////
    bool getSashWindowMotorizeUpInterlocked() const;
    void setSashWindowMotorizeUpInterlocked(bool sashWindowMotorizeUpInterlocked);
    ////
    bool getSashWindowMotorizeDownInterlocked() const;
    void setSashWindowMotorizeDownInterlocked(bool sashWindowMotorizeDownInterlocked);
    ////
    bool getSashWindowMotorizeInstalled() const;
    void setSashWindowMotorizeInstalled(bool sashWindowMotorizeInstalled);

    ///FREE-RELAY-CONTACT
    short getExhaustContactState() const;
    void setExhaustContactState(short exhaustContactState);
    ///
    short getAlarmContactState() const;
    void setAlarmContactState(short alarmContactState);

    ///MUTE ALARM
    short getMuteAlarmState() const;
    void setMuteAlarmState(short muteAlarmState);
    ///
    int getMuteAlarmTime() const;
    void setMuteAlarmTime(int muteAlarmTime);
    int getMuteAlarmTimeAtFullyOpened() const;
    void setMuteAlarmTimeAtFullyOpened(int muteAlarmTime);
    ///
    int getMuteAlarmCountdown() const;
    void setMuteAlarmCountdown(int muteAlarmCountdown);

    ///ALARM
    bool getAlarmsState() const;
    void setAlarmsState(bool alarmsState);
    ///
    short getAlarmBoardComError() const;
    void setAlarmBoardComError(short alarmBoardComError);
    ///
    short getAlarmInflowLow() const;
    void setAlarmInflowLow(short alarmInflowLow);
    ///
    short getAlarmSash() const;
    void setAlarmSash(short alarmSash);
    ///
    short getAlarmStandbyFanOff() const;
    void setAlarmStandbyFanOff(short alarm);
    ///
    short getAlarmExperimentTimerIsOver() const;
    void setAlarmExperimentTimerIsOver(short value);
    ///
    //    void setAlarmDownfLow(bool alarmDownflowLow);
    //    void setAlarmDownfHigh(bool alarmDownflowHigh);
    short getAlarmTempHigh() const;
    void setAlarmTempHigh(short alarmTempHigh);
    ///
    short getAlarmTempLow() const;
    void setAlarmTempLow(short alarmTempLow);

    //TEMPERATURE
    int getTemperatureAdc() const;
    short getTemperatureCelcius() const;
    short getTemperature() const;
    QString getTemperatureValueStrf() const;
    //
    void setTemperatureAdc(int temperatureAdc);
    void setTemperatureCelcius(short temperatureCelcius);
    void setTemperature(short temperature);
    void setTemperatureValueStrf(const QString &temperatureValueStrf);
    //
    short getTempAmbientStatus() const;
    void setTempAmbientStatus(short tempAmbientStatus);

    //MEASUREMENT UNIT
    short getMeasurementUnit() const;
    void setMeasurementUnit(short measurementUnit);
    //
    short getMeasurementUnitDuringCalib() const;
    void setMeasurementUnitDuringCalib(short measurementUnitDuringCalib);

    //FAN
    Q_INVOKABLE short   getFanPrimaryDutyCycle() const;
    Q_INVOKABLE int     getFanPrimaryRpm() const;
    //
    Q_INVOKABLE short   getFanPrimaryNominalDutyCycle() const;
    Q_INVOKABLE int     getFanPrimaryNominalRpm() const;
    Q_INVOKABLE short   getFanPrimaryMinimumDutyCycle() const;
    Q_INVOKABLE int     getFanPrimaryMinimumRpm() const;
    Q_INVOKABLE short   getFanPrimaryStandbyDutyCycle() const;
    Q_INVOKABLE int     getFanPrimaryStandbyRpm() const;
    //
    Q_INVOKABLE short   getFanPrimaryNominalDutyCycleFactory() const;
    Q_INVOKABLE int     getFanPrimaryNominalRpmFactory() const;
    Q_INVOKABLE short   getFanPrimaryNominalDutyCycleField() const;
    Q_INVOKABLE int     getFanPrimaryNominalRpmField() const;
    //
    Q_INVOKABLE short   getFanPrimaryMinimumDutyCycleFactory() const;
    Q_INVOKABLE int     getFanPrimaryMinimumRpmFactory() const;
    Q_INVOKABLE short   getFanPrimaryMinimumDutyCycleField() const;
    Q_INVOKABLE int     getFanPrimaryMinimumRpmField() const;
    //
    Q_INVOKABLE short   getFanPrimaryStandbyDutyCycleFactory() const;
    Q_INVOKABLE int     getFanPrimaryStandbyRpmFactory() const;
    Q_INVOKABLE short   getFanPrimaryStandbyDutyCycleField() const;
    Q_INVOKABLE int     getFanPrimaryStandbyRpmField() const;
    //
    void    setFanPrimaryDutyCycle(short value);
    void    setFanPrimaryRpm(int value);
    //
    void    setFanPrimaryNominalDutyCycle(short value);
    void    setFanPrimaryNominalRpm(short value);
    void    setFanPrimaryMinimumDutyCycle(short value);
    void    setFanPrimaryMinimumRpm(short value);
    void    setFanPrimaryStandbyDutyCycle(short value);
    void    setFanPrimaryStandbyRpm(int fanPrimaryStandbyRpm);
    //
    void    setFanPrimaryNominalDutyCycleFactory(short fanPrimaryNominalDutyCycleFactory);
    void    setFanPrimaryNominalRpmFactory(int fanPrimaryNominalRpmFactory);
    void    setFanPrimaryNominalDutyCycleField(short fanPrimaryNominalDutyCycleField);
    void    setFanPrimaryNominalRpmField(int fanPrimaryNominalRpmField);
    //
    void    setFanPrimaryMinimumDutyCycleFactory(short fanPrimaryMinimumDutyCycleFactory);
    void    setFanPrimaryMinimumRpmFactory(int fanPrimaryMinimumRpmFactory);
    void    setFanPrimaryMinimumDutyCycleField(short fanPrimaryMinimumDutyCycleField);
    void    setFanPrimaryMinimumRpmField(int fanPrimaryMinimumRpmField);
    //
    void    setFanPrimaryStandbyDutyCycleFactory(short fanPrimaryStandbyDutyCycleFactory);
    void    setFanPrimaryStandbyRpmFactory(int fanPrimaryStandbyRpmFactory);
    //
    void    setFanPrimaryStandbyDutyCycleField(short fanPrimaryStandbyDutyCycleField);
    void    setFanPrimaryStandbyRpmField(int fanPrimaryStandbyRpmField);

    void setAirflowFactoryCalibrationState(int index, bool state);
    Q_INVOKABLE bool getAirflowFactoryCalibrationState(int index);

    //    void setAirflowFactorySecondaryCalibrationState(int index, bool state);
    //    Q_INVOKABLE bool getAirflowFactorySecondaryCalibrationState(int index);

    //    void setAdcFactoryCalibrationState(int index, bool state);
    //    Q_INVOKABLE bool getAdcFactoryCalibrationState(int index);

    void setAirflowFieldCalibrationState(short index, bool value);
    Q_INVOKABLE bool getAirflowFieldCalibrationState(short index);

    // Magenetic Swtich for Sash Windows
    void setMagSWState(short index, bool value);
    bool getMagSW1State() const;
    bool getMagSW2State() const;
    bool getMagSW3State() const;
    bool getMagSW4State() const;
    bool getMagSW5State() const;
    bool getMagSW6State() const;

    //MACHINE ID
    QJsonObject getMachineProfile() const;
    QString getMachineProfileName() const;
    QString getMachineModelName() const;
    QString getMachineClassName() const;
    void setMachineProfile(QJsonObject machineProfile);
    void setMachineProfileName(const QString &machineProfile);
    void setMachineModelName(const QString &machineModelName);
    void setMachineClassName(const QString &machineClassName);

    //LCD BRIGHTNESS
    short getLcdBrightnessLevelUser() const;
    short getLcdBrightnessLevel() const;
    short getLcdBrightnessDelayToDimm() const;
    bool getLcdBrightnessLevelDimmed() const;
    bool getLcdEnableLockScreen() const;
    ///
    void setLcdBrightnessLevelUser(short lcdBrightnessLevelUser);
    void setLcdBrightnessLevel(short lcdBrightnessLevel);
    void setLcdBrightnessDelayToDimm(short lcdBrightnessDelayToDimm);
    void setLcdBrightnessLevelDimmed(bool lcdBrightnessLevelDimmed);
    void setLcdEnableLockScreen(bool value);

    //LANGUAGE
    QString getLanguage() const;
    void setLanguage(const QString &language);

    //TIMEZONE
    QString getTimeZone() const;
    void    setTimeZone(const QString &timeZone);
    short   getTimeClockPeriod() const;
    void    setTimeClockPeriod(short timeClockPeriod);

    //AIRFLOW MONITOR
    bool getAirflowMonitorEnable() const;
    void setAirflowMonitorEnable(bool airflowMonitorEnable);
    int     getInflowVelocity() const;
    int     getInflowAdc() const;
    int     getInflowAdcConpensation() const;
    QString getInflowVelocityStr() const;
    //
    Q_INVOKABLE short getInflowSensorConstant();
    Q_INVOKABLE int getInflowTempCalib();
    Q_INVOKABLE int getInflowTempCalibAdc();
    Q_INVOKABLE int getInflowAdcPointFactory(short point);
    Q_INVOKABLE int getInflowVelocityPointFactory(short point);
    Q_INVOKABLE int getInflowAdcPointField(short point);
    Q_INVOKABLE int getInflowVelocityPointField(short point);
    //
    Q_INVOKABLE int getInflowLowLimitVelocity() const;
    //

    void    setInflowAdc(int ifaAdc);
    void    setInflowAdcConpensation(int ifaAdcConpensation);
    void    setInflowVelocity(int ifaVelocity);
    void    setInflowVelocityStr(const QString &ifaVelocityStr);
    //
    void    setInflowLowLimitVelocity(int ifaLowLimitVelocity);
    void    setInflowSensorConstant(short value);
    void    setInflowTempCalib(short value);
    void    setInflowTempCalibAdc(short value);
    void    setInflowAdcPointFactory(short point, int value);
    void    setInflowVelocityPointFactory(short point, int value);
    void    setInflowAdcPointField(short point, int value);
    void    setInflowVelocityPointField(short point, int value);
    //
    QString getDownflowVelocityStr() const;
    int getDownflowVelocity() const;
    //
    Q_INVOKABLE int getDownflowVelocityPointFactory(short point);
    Q_INVOKABLE int getDownflowVelocityPointField(short point);
    //
    void    setDownflowVelocity(int dfaVelocity);
    void    setDownflowVelocityStr(const QString &dfaVelocityStr);
    void    setDownflowVelocityPointFactory(short point, int value);
    void    setDownflowVelocityPointField(short point, int value);
    //
    void    setAirflowCalibrationStatus(short airflowCalibrationStatus);
    short   getAirflowCalibrationStatus() const;

    /// Board Status
    bool getBoardStatusHybridDigitalRelay() const;
    void setBoardStatusHybridDigitalRelay(bool boardStatusHybridDigitalRelay);
    //
    bool getBoardStatusHybridDigitalInput() const;
    void setBoardStatusHybridDigitalInput(bool boardStatusHybridDigitalInput);
    //
    bool getBoardStatusHybridAnalogInput() const;
    void setBoardStatusHybridAnalogInput(bool boardStatusHybridAnalogInput);
    //
    bool getBoardStatusHybridAnalogOutput() const;
    void setBoardStatusHybridAnalogOutput(bool boardStatusHybridAnalogOutput);
    //
    bool getBoardStatusHybridAnalogOutput2() const;
    void setBoardStatusHybridAnalogOutput2(bool value);
    bool getBoardStatusRbmCom() const;
    void setBoardStatusRbmCom(bool boardStatusRbmCom);
    //
    bool getBoardStatusPressureDiff() const;
    void setBoardStatusPressureDiff(bool boardStatusPressureDiff);
    //
    bool getBoardStatusCtpRtc() const;
    void setBoardStatusCtpRtc(bool boardStatusCtpRtc);
    //
    bool getBoardStatusParticleCounter() const;
    void setBoardStatusParticleCounter(bool boardStatusParticleCounter);
    //
    bool getBoardStatusCtpIoe() const;
    void setBoardStatusCtpIoe(bool boardStatusCtpIoe);

    /// DATA LOG
    bool getDataLogEnable() const;
    bool getDataLogRunning() const;
    short getDataLogPeriod() const;
    int   getDataLogCount() const;
    bool  getDataLogIsFull() const;
    //
    void setDataLogEnable(bool dataLogEnable);
    void setDataLogRunning(bool dataLogRunning);
    void setDataLogCount(int dataLogCount);
    void setDataLogPeriod(short dataLogPeriod);
    void setDataLogIsFull(bool dataLogIsFull);

    /// RESOURCE MONITOR
    bool getResourceMonitorLogEnable() const;
    bool getResourceMonitorLogRunning() const;
    short getResourceMonitorLogPeriod() const;
    int   getResourceMonitorLogCount() const;
    bool  getResourceMonitorLogIsFull() const;
    //
    void setResourceMonitorLogEnable(bool value);
    void setResourceMonitorLogRunning(bool value);
    void setResourceMonitorLogCount(int value);
    void setResourceMonitorLogPeriod(short value);
    void setResourceMonitorLogIsFull(bool value);


    /// OPERATION MODE
    short getOperationMode() const;
    void setOperationMode(short operationMode);

    ///WARMING UP
    bool getWarmingUpActive() const;
    void setWarmingUpActive(bool warmingUpActive);
    bool getWarmingUpExecuted() const;
    void setWarmingUpExecuted(bool warmingUpExecuted);
    ///
    int getWarmingUpTime() const;
    void setWarmingUpTime(int warmingUpTime);
    ///
    int getWarmingUpCountdown() const;
    void setWarmingUpCountdown(int warmingUpCountdown);

    ///POST PURGING
    bool getPostPurgingActive() const;
    void setPostPurgingActive(bool postPurgingActive);
    ///
    int getPostPurgingTime() const;
    void setPostPurgingTime(int postPurgingTime);
    ///
    int getPostPurgingCountdown() const;
    void setPostPurgingCountdown(int postPurgingCountdown);

    /// Filter Life
    bool getFilterLifeReminder() const;
    void setFilterLifeReminder(bool filterLifeReminder);
    bool getFilterLifeReminderSnoozed() const;
    void setFilterLifeReminderSnoozed(bool value);
    int getFilterLifeMinutes() const;
    void setFilterLifeMinutes(int filterLifeMinutes);
    ///
    short getFilterLifePercent() const;
    void setFilterLifePercent(short value);
    QString getFilterLifeLevelStrf() const;
    void setFilterLifeLevelStrf(const QString &value);
    QString getFilterLifeLevelColorStrf() const;
    void setFilterLifeLevelColorStrf(const QString &value);

    void setFilterLifeRpm                   (int value);
    void setFilterLifeCalculationMode       (int value);
    void setFilterLifeMinimumBlowerUsageMode (int value);
    void setFilterLifeMaximumBlowerUsageMode (int value);
    void setFilterLifeMinimumBlowerRpmMode   (int value);
    void setFilterLifeMaximumBlowerRpmMode   (int value);

    int getFilterLifeRpm                    ()const;
    int getFilterLifeCalculationMode        ()const;
    int getFilterLifeMinimumBlowerUsageMode  ()const;
    int getFilterLifeMaximumBlowerUsageMode  ()const;
    int getFilterLifeMinimumBlowerRpmMode    ()const;
    int getFilterLifeMaximumBlowerRpmMode    ()const;

    /// POWER OUTAGE
    bool getPowerOutage() const;
    void setPowerOutage(bool powerOutage);
    ///
    QString getPowerOutageTime() const;
    void setPowerOutageTime(const QString &powerOutageTime);
    ///
    QString getPowerOutageRecoverTime() const;
    void setPowerOutageRecoverTime(const QString &powerOutageRecoverTime);
    ///
    short getPowerOutageFanState() const;
    void setPowerOutageFanState(short powerOutageFanState);
    ///
    //    short getPowerOutageLightState() const;
    //    void setPowerOutageLightState(short powerOutageLightState);
    ///
    short getPowerOutageUvState() const;
    void setPowerOutageUvState(short powerOutageUvState);

    /// SEAS BOARD FLAP
    bool getSeasFlapInstalled() const;
    void setSeasFlapInstalled(bool seasFlapInstalled);
    ///
    short getSeasFlapAlarmPressure() const;
    void setSeasFlapAlarmPressure(short seasFlapAlarmPressure);
    /// SEAS
    bool getSeasInstalled() const;
    void setSeasInstalled(bool seasInstalled);
    ///
    int getSeasPressureDiffPa() const;
    void setSeasPressureDiffPa(int seasPressureDiffPa);
    ///
    int getSeasPressureDiffPaLowLimit() const;
    void setSeasPressureDiffPaLowLimit(int seasPressureDiffPaLowLimit);
    ///
    int getSeasPressureDiff() const;
    void setSeasPressureDiff(int seasPressureDiff);
    ///
    QString getSeasPressureDiffStr() const;
    void setSeasPressureDiffStrf(const QString &seasPressureDiffStr);

    ///
    short getAlarmSeasPressureLow() const;
    void setSeasAlarmPressureLow(short seasAlarmPressureLow);
    ///
    short getSeasPressureDiffPaOffset() const;
    void setSeasPressureDiffPaOffset(short seasPressureDiffPaOffset);
    ///
    short getSeasPressureDiffPaNominal() const;
    void setSeasPressureDiffPaNominal(short value);

    /// FAN USAGE METER
    int getFanUsageMeter() const;
    void setFanUsageMeter(int fanUsageMeter);

    /// SERIAL NUMBER
    QString getSerialNumber() const;
    void setSerialNumber(const QString &serialNumber);

    /// ALARM LOG
    int getAlarmLogCount() const;
    void setAlarmLogCount(int alarmLogCount);
    ///
    bool getAlarmLogIsFull() const;
    void setAlarmLogIsFull(bool alarmLogIsFull);

    /// MODBUS
    short getModbusSlaveID() const;
    void setModbusSlaveID(short modbusSlaveID);
    ///
    QString getModbusAllowIpMaster() const;
    void setModbusAllowIpMaster(const QString &modbusAllowIpMaster);
    ////
    bool getModbusAllowSetFan() const;
    void setModbusAllowSetFan(bool modbusAllowSetFan);
    ///
    bool getModbusAllowSetLight() const;
    void setModbusAllowSetLight(bool modbusAllowSetLight);
    ///
    bool getModbusAllowSetLightIntensity() const;
    void setModbusAllowSetLightIntensity(bool modbusAllowSetLightIntensity);
    ///
    bool getModbusAllowSetSocket() const;
    void setModbusAllowSetSocket(bool modbusAllowSetSocket);
    ///
    bool getModbusAllowSetGas() const;
    void setModbusAllowSetGas(bool modbusAllowGasSet);
    ///
    bool getModbusAllowSetUvLight() const;
    void setModbusAllowSetUvLight(bool modbusAllowSetUvLight);
    ///
    QString getModbusLatestStatus() const;
    void setModbusLatestStatus(const QString &modbusLatestStatus);

    /// EVENT LOG
    int getEventLogCount() const;
    void setEventLogCount(int eventLogCount);
    ///
    bool getEventLogIsFull() const;
    void setEventLogIsFull(bool eventLogIsFull);

    /// REPLACEABLECOMP RECORD
    int getReplaceableCompRecordCount() const;
    void setReplaceableCompRecordCount(int value);
    ///
    bool getReplaceableCompRecordIsFull() const;
    void setReplaceableCompRecordIsFull(bool value);

    /// UV AUTO SET
    /// ON
    int getUVAutoEnabled() const;
    void setUVAutoEnabled(int uvAutoSetEnabled);
    ///
    int getUVAutoTime() const;
    void setUVAutoTime(int uvAutoSetTime);
    ///
    int getUVAutoDayRepeat() const;
    void setUVAutoDayRepeat(int uvAutoSetDayRepeat);
    ///
    int getUVAutoWeeklyDay() const;
    void setUVAutoWeeklyDay(int uvAutoSetWeeklyDay);
    /// OFF
    int getUVAutoEnabledOff() const;
    void setUVAutoEnabledOff(int uvAutoSetEnabledOff);
    ///
    int getUVAutoTimeOff() const;
    void setUVAutoTimeOff(int uvAutoSetTimeOff);
    ///
    int getUVAutoDayRepeatOff() const;
    void setUVAutoDayRepeatOff(int uvAutoSetDayRepeatOff);
    ///
    int getUVAutoWeeklyDayOff() const;
    void setUVAutoWeeklyDayOff(int uvAutoSetWeeklyDayOff);

    /// Light AUTO SET
    ///
    int getLightAutoEnabled() const;
    int getLightAutoTime() const;
    int getLightAutoDayRepeat() const;
    int getLightAutoWeeklyDay() const;
    int getLightAutoEnabledOff() const;
    int getLightAutoTimeOff() const;
    int getLightAutoDayRepeatOff() const;
    int getLightAutoWeeklyDayOff() const;
    ///
    void setLightAutoEnabled(int value);
    void setLightAutoTime(int value);
    void setLightAutoDayRepeat(int value);
    void setLightAutoWeeklyDay(int value);
    void setLightAutoEnabledOff(int value);
    void setLightAutoTimeOff(int value);
    void setLightAutoDayRepeatOff(int value);
    void setLightAutoWeeklyDayOff(int value);

    /// Socket AUTO SET
    ///
    int getSocketAutoEnabled() const;
    int getSocketAutoTime() const;
    int getSocketAutoDayRepeat() const;
    int getSocketAutoWeeklyDay() const;
    int getSocketAutoEnabledOff() const;
    int getSocketAutoTimeOff() const;
    int getSocketAutoDayRepeatOff() const;
    int getSocketAutoWeeklyDayOff() const;
    ///
    void setSocketAutoEnabled(int value);
    void setSocketAutoTime(int value);
    void setSocketAutoDayRepeat(int value);
    void setSocketAutoWeeklyDay(int value);
    void setSocketAutoEnabledOff(int value);
    void setSocketAutoTimeOff(int value);
    void setSocketAutoDayRepeatOff(int value);
    void setSocketAutoWeeklyDayOff(int value);

    /// FAN AUTO SET
    /// ON
    int getFanAutoEnabled() const;
    void setFanAutoEnabled(int fanAutoSetEnabled);
    ///
    int getFanAutoTime() const;
    void setFanAutoTime(int fanAutoSetTime);
    ///
    int getFanAutoDayRepeat() const;
    void setFanAutoDayRepeat(int fanAutoSetDayRepeat);
    ///
    int getFanAutoWeeklyDay() const;
    void setFanAutoWeeklyDay(int fanAutoSetWeeklyDay);
    /// OFF
    int getFanAutoEnabledOff() const;
    void setFanAutoEnabledOff(int fanAutoSetEnabledOff);
    ///
    int getFanAutoTimeOff() const;
    void setFanAutoTimeOff(int fanAutoSetTimeOff);
    ///
    int getFanAutoDayRepeatOff() const;
    void setFanAutoDayRepeatOff(int fanAutoSetDayRepeatOff);
    ///
    int getFanAutoWeeklyDayOff() const;
    void setFanAutoWeeklyDayOff(int fanAutoSetWeeklyDayOff);

    ///Security Accsess
    short getSecurityAccessMode() const;
    void setSecurityAccessMode(short securityAccessMode);

    /// Certification Date Reminder
    QString getDateCertificationReminder() const;
    void setDateCertificationReminder(const QString &dateCertificationReminder);
    ///
    bool getCertificationExpired() const;
    void setCertificationExpired(bool certificationExpired);
    ///
    int getCertificationExpiredCount() const;
    void setCertificationExpiredCount(int certificationExpiredCount);
    ///
    bool getCertificationExpiredValid() const;
    void setCertificationExpiredValid(bool certificationExpiredValid);

    /// ESCO LOCK SERVICE
    int getEscoLockServiceEnable() const;
    void setEscoLockServiceEnable(int escoLockServiceEnable);

    /// CABINET NAME
    QString getCabinetDisplayName() const;
    void setCabinetDisplayName(const QString &cabinetDisplayName);

    /// FAN PIN
    QString getFanPIN() const;
    void setFanPIN(const QString &fanPIN);

    /// SASH CYCLE METER
    bool getSashCycleCountValid() const;
    void setSashCycleCountValid(bool sashCycleCountValid);
    int getSashCycleMeter() const;
    void setSashCycleMeter(int sashCycleMeter);
    short getSashCycleMotorLockedAlarm() const;
    void setSashCycleMotorLockedAlarm(short value);

    /// ENVIRONMENTAL TEMPERATURE LIMIT
    int getEnvTempHighestLimit() const;
    int getEnvTempLowestLimit() const;
    ///
    void setEnvTempHighestLimit(int envTempHighestLimit);
    void setEnvTempLowestLimit(int envTempLowestLimit);

    /// PARTICLE COUNTER
    int getParticleCounterPM2_5() const;
    int getParticleCounterPM10() const;
    int getParticleCounterPM1_0() const;
    short getParticleCounterSensorFanState() const;
    bool getParticleCounterSensorInstalled() const;
    ///
    void setParticleCounterPM2_5(int particleCounterPM2_5);
    void setParticleCounterPM10(int particleCounterPM10);
    void setParticleCounterPM1_0(int particleCounterPM1_0);
    void setParticleCounterSensorFanState(short particleCounterSensorFanState);
    void setParticleCounterSensorInstalled(bool particleCounterSensorInstalled);

    bool getVivariumMuteState() const;
    void setVivariumMuteState(bool vivariumMuteState);

    /// WATCHDOG
    int getWatchdogCounter() const;
    QString getRtcActualDate() const;
    QString getRtcActualTime() const;
    bool getRtcBatteryLowStatus() const;
    ///
    void setWatchdogCounter(int watchdogCounter);
    void setRtcActualDate(const QString &rtcActualDate);
    void setRtcActualTime(const QString &rtcActualTime);
    void setRtcBatteryLowStatus(bool value);

    /// LOGS
    int getDataLogSpaceMaximum() const;
    int getAlarmLogSpaceMaximum() const;
    int getEventLogSpaceMaximum() const;
    int getReplaceableCompRecordSpaceMaximum() const;
    int getResourceMonitorLogSpaceMaximum() const;
    ///
    void setAlarmLogSpaceMaximum(int alarmLogSpaceMaximum);
    void setEventLogSpaceMaximum(int eventLogSpaceMaximum);
    void setDataLogSpaceMaximum(int dataLogSpaceMaximum);
    void setReplaceableCompRecordSpaceMaximum(int value);
    void setResourceMonitorLogSpaceMaximum(int dataLogSpaceMaximum);

    bool getShippingModeEnable() const;
    void setShippingModeEnable(bool shippingModeEnable);

    Q_INVOKABLE QString getSbcSerialNumber() const;
    void setSbcSerialNumber(const QString &sbcSerialNumber);
    Q_INVOKABLE QString getSbcCurrentFullMacAddress() const;
    void setSbcCurrentFullMacAddress(const QString &sbcCurrentFullMacAddress);
    Q_INVOKABLE QStringList getSbcSystemInformation()const;
    void setSbcSystemInformation(const QStringList &sbcSystemInformation);
    Q_INVOKABLE short getHardwareInformation()const;
    void setHardwareInformation(short &value);

    Q_INVOKABLE bool getSbcCurrentSerialNumberKnown()const;
    void setSbcCurrentSerialNumberKnown(bool value);

    Q_INVOKABLE QString getSbcCurrentSerialNumber() const;
    void setSbcCurrentSerialNumber(const QString &sbcCurrentSerialNumber);
    Q_INVOKABLE QStringList getSbcCurrentSystemInformation()const;
    void setSbcCurrentSystemInformation(const QStringList &sbcCurrentSystemInformation);

    /// PREVENTIVE MAINTENANCE
    QJsonObject getMaintenanceChecklist()const;
    bool getAlarmPreventMaintActive()const;
    ushort getAlarmPreventMaintActiveCode()const;
    ushort getAlarmPreventMaintState()const;
    ushort getAlarmPreventMaintStateEnable()const;
    ushort getAlarmPreventMaintStateAck()const;
    //    ushort getPreventMaintChecklistNotEmpty()const;

    //    bool getDailyPreventMaintAck()const;
    //    bool getWeeklyPreventMaintAck()const;
    //    bool getMonthlyPreventMaintAck()const;
    //    bool getQuarterlyPreventMaintAck()const;
    //    bool getAnnuallyPreventMaintAck()const;
    //    bool getBienniallyPreventMaintAck()const;
    //    bool getQuinquenniallyPreventMaintAck()const;
    //    bool getCanopyPreventMaintAck()const;

    QString getDailyPreventMaintAckDueDate()const;
    QString getWeeklyPreventMaintAckDueDate()const;
    QString getMonthlyPreventMaintAckDueDate()const;
    QString getQuarterlyPreventMaintAckDueDate()const;
    QString getAnnuallyPreventMaintAckDueDate()const;
    QString getBienniallyPreventMaintAckDueDate()const;
    QString getQuinquenniallyPreventMaintAckDueDate()const;
    QString getCanopyPreventMaintAckDueDate()const;

    QString getDailyPreventMaintLastAckDate()const;
    QString getWeeklyPreventMaintLastAckDate()const;
    QString getMonthlyPreventMaintLastAckDate()const;
    QString getQuarterlyPreventMaintLastAckDate()const;
    QString getAnnuallyPreventMaintLastAckDate()const;
    QString getBienniallyPreventMaintLastAckDate()const;
    QString getQuinquenniallyPreventMaintLastAckDate()const;
    QString getCanopyPreventMaintLastAckDate()const;

    int getDailyPreventMaintRemindBefore()const;
    int getWeeklyPreventMaintRemindBefore()const;
    int getMonthlyPreventMaintRemindBefore()const;
    int getQuarterlyPreventMaintRemindBefore()const;
    int getAnnuallyPreventMaintRemindBefore()const;
    int getBienniallyPreventMaintRemindBefore()const;
    int getQuinquenniallyPreventMaintRemindBefore()const;
    int getCanopyPreventMaintRemindBefore()const;

    void setMaintenanceChecklist(QJsonObject value);
    void setAlarmPreventMaintActive(bool value);
    void setAlarmPreventMaintActiveCode(ushort value);
    void setAlarmPreventMaintState(ushort value);
    void setAlarmPreventMaintStateEnable(ushort value);
    void setAlarmPreventMaintStateAck(ushort value);
    //    void setPreventMaintChecklistNotEmpty(ushort value);

    //    void setDailyPreventMaintAck(bool value);
    //    void setWeeklyPreventMaintAck(bool value);
    //    void setMonthlyPreventMaintAck(bool value);
    //    void setQuarterlyPreventMaintAck(bool value);
    //    void setAnnuallyPreventMaintAck(bool value);
    //    void setBienniallyPreventMaintAck(bool value);
    //    void setQuinquenniallyPreventMaintAck(bool value);
    //    void setCanopyPreventMaintAck(bool value);

    void setDailyPreventMaintAckDueDate(const QString &value);
    void setWeeklyPreventMaintAckDueDate(const QString &value);
    void setMonthlyPreventMaintAckDueDate(const QString &value);
    void setQuarterlyPreventMaintAckDueDate(const QString &value);
    void setAnnuallyPreventMaintAckDueDate(const QString &value);
    void setBienniallyPreventMaintAckDueDate(const QString &value);
    void setQuinquenniallyPreventMaintAckDueDate(const QString &value);
    void setCanopyPreventMaintAckDueDate(const QString &value);

    void setDailyPreventMaintLastAckDate(const QString &value);
    void setWeeklyPreventMaintLastAckDate(const QString &value);
    void setMonthlyPreventMaintLastAckDate(const QString &value);
    void setQuarterlyPreventMaintLastAckDate(const QString &value);
    void setAnnuallyPreventMaintLastAckDate(const QString &value);
    void setBienniallyPreventMaintLastAckDate(const QString &value);
    void setQuinquenniallyPreventMaintLastAckDate(const QString &value);
    void setCanopyPreventMaintLastAckDate(const QString &value);

    void setDailyPreventMaintRemindBefore(int value);
    void setWeeklyPreventMaintRemindBefore(int value);
    void setMonthlyPreventMaintRemindBefore(int value);
    void setQuarterlyPreventMaintRemindBefore(int value);
    void setAnnuallyPreventMaintRemindBefore(int value);
    void setBienniallyPreventMaintRemindBefore(int value);
    void setQuinquenniallyPreventMaintRemindBefore(int value);
    void setCanopyPreventMaintRemindBefore(int value);

    /// ETHERNET CONNECTION
    void setEth0ConName(const QString &value);
    void setEth0Ipv4Address(const QString &value);
    void setEth0ConEnabled(bool value);

    Q_INVOKABLE QString getEth0ConName()const;
    Q_INVOKABLE QString getEth0Ipv4Address()const;
    Q_INVOKABLE bool getEth0ConEnabled()const;

    void setWiredNetworkHasbeenConfigured(bool value);
    bool getWiredNetworkHasbeenConfigured()const;

    /// SVN UPDATE
    void setSvnUpdateAvailable(bool value);
    void setSvnUpdateSwuVersion(const QString &value);
    void setSvnUpdatePath(const QString &value);
    void setSvnUpdateHistory(QJsonObject value);

    bool getSvnUpdateAvailable()const;
    QString getSvnUpdateSwuVersion()const;
    QString getSvnUpdatePath()const;
    QJsonObject getSvnUpdateHistory()const;

    bool getSvnUpdateCheckForUpdateEnable()const;
    int getSvnUpdateCheckForUpdatePeriod()const;
    void setSvnUpdateCheckForUpdateEnable(bool value);
    void setSvnUpdateCheckForUpdatePeriod(int value);

    void setRpListDefault(QJsonObject value);
    void setRpListLast(QVariantList value);
    void setRpListLast(short index, const QString &value);
    QJsonObject getRpListDefault()const;
    QVariantList getRpListLast()const;
    QString getRpListLastAtIndex(short index)const;

    void setRpListSelected(QVariantList value);
    void setRpListSelected(short index, const QString &value);
    QVariantList getRpListSelected()const;
    QString getRpListSelectedAtIndex(short index)const;

    void setKeyboardStringOnAcceptedEvent(const QString &value);
    QString getKeyboardStringOnAcceptedEvent()const;

    void setUserLasLogin(QJsonArray value);
    QJsonArray getUserLastLogin()const;

    QString getUsbDetectedList() const;
    void setUsbDetectedList(const QString &list);

    QString getLastUsbDetectedName() const;
    void setLastUsbDetectedName(const QString &name);

    void setFrontEndScreenState(short value);
    short getFrontEndScreenState() const;
    void setFrontEndScreenStatePrev(short value);
    short getFrontEndScreenStatePrev() const;

    void setInstallationWizardActive(bool value);
    bool getInstallationWizardActive()const;

    void setCabinetUpTime(int value);
    int getCabinetUpTime()const;

    ///////////////
    /// Front Panel Switch on LA2EU
    bool getFrontPanelSwitchInstalled() const;
    bool getFrontPanelSwitchState() const;
    short getFrontPanelAlarm() const;
    void setFrontPanelSwitchInstalled(bool value);
    void setFrontPanelSwitchState(bool value);
    void setFrontPanelAlarm(short value);
    /// SASH MOTORIZED
    void setSashMotorDownStuckSwitch(bool value);
    bool getSashMotorDownStuckSwitch()const;

    short getAlarmSashMotorDownStuck()const;
    void setAlarmSashMotorDownStuck(short value);

    void setSashWindowSafeHeight2(bool value);
    bool getSashWindowSafeHeight2()const;

    void setSashMotorOffDelayMsec(int value);
    int getSashMotorOffDelayMsec()const;

    //    void setResourceMonitorParamsActive(bool value);
    //    bool getResourceMonitorParamsActive()const;
    void setResourceMonitorParams(const QStringList &value);
    QStringList getResourceMonitorParams()const;
    void setUSdCardIndustrial(bool value);
    bool getUSdCardIndustrial()const;

    /// FILTER LIFE DISPLAY
    bool getFilterLifeDisplayEnabled() const;
    void setFilterLifeDisplayEnabled(bool state);

    /// AIRFLOW OUT TEMP
    void setAirflowOutTempEnable(bool value);
    bool getAirflowOutTempEnable()const;

    /// SENSOR CONSTANT CORRECTION
    void setSensorConstCorrEnable(bool value);
    void setSensorConstCorrHighZone(int value);
    void setSensorConstCorrLowZone(int value);

    bool getSensorConstCorrEnable()const;
    int getSensorConstCorrHighZone()const;
    int getSensorConstCorrLowZone()const;
    /// SENSOR CONSTANT CORRECTION
    void setAdcInflowPointCorrection(short point, int value);
    Q_INVOKABLE int getAdcInflowPointCorrection(short point)const;

    /// HYBRID ANALOG INPUT MVOLT
    void setHaBoardInputCh1MVolt(int value);
    void setHaBoardInputCh2MVolt(int value);
    int getHaBoardInputCh1MVolt()const;
    int getHaBoardInputCh2MVolt()const;

    /// LOGOUT TIME
    void setLogoutTime(int value);
    int getLogoutTime()const;

    /// 21 CFR PART 11
    void setCfr21Part11Enable(bool value);
    bool getCfr21Part11Enable()const;

    void setFanSpeedControllerBoard(short value);
    short getFanSpeedControllerBoard()const;

    void setPropogateComposeEventGesture(bool value);
    short getPropogateComposeEventGesture()const;

    /// ADVANCED AIRFLOW ALARM
    void setAdvancedAirflowAlarmEnable(bool value);
    void setAlarmDownflowLow    (short value);
    void setAlarmDownflowHigh   (short value);

    bool getAdvancedAirflowAlarmEnable()const;
    short getAlarmDownflowLow   ()const;
    short getAlarmDownflowHigh  ()const;


    /// INFLOW DIM GRID
    Q_INVOKABLE QString getIfaCalGrid(short calibMode, short inflowGridPoint)const;
    Q_INVOKABLE int getIfaCalGridTot(short calibMode, short inflowGridPoint)const;
    Q_INVOKABLE int getIfaCalGridAvg(short calibMode, short inflowGridPoint)const;
    Q_INVOKABLE int getIfaCalGridVol(short calibMode, short inflowGridPoint)const;
    Q_INVOKABLE int getIfaCalGridVel(short calibMode, short inflowGridPoint)const;
    Q_INVOKABLE int getIfaCalGridTotImp(short calibMode, short inflowGridPoint)const;
    Q_INVOKABLE int getIfaCalGridAvgImp(short calibMode, short inflowGridPoint)const;
    Q_INVOKABLE int getIfaCalGridVolImp(short calibMode, short inflowGridPoint)const;
    Q_INVOKABLE int getIfaCalGridVelImp(short calibMode, short inflowGridPoint)const;
    Q_INVOKABLE int getIfaCalGridDcy(short calibMode, short inflowGridPoint)const;
    Q_INVOKABLE int getIfaCalGridRpm(short calibMode, short inflowGridPoint)const;

    /// INFLOW SEC GRID
    Q_INVOKABLE QString getIfaCalGridSec(short calibMode, short inflowGridPoint)const;
    Q_INVOKABLE int getIfaCalGridTotSec(short calibMode, short inflowGridPoint)const;
    Q_INVOKABLE int getIfaCalGridAvgSec(short calibMode, short inflowGridPoint)const;
    Q_INVOKABLE int getIfaCalGridVelSec(short calibMode, short inflowGridPoint)const;
    Q_INVOKABLE int getIfaCalGridTotSecImp(short calibMode, short inflowGridPoint)const;
    Q_INVOKABLE int getIfaCalGridAvgSecImp(short calibMode, short inflowGridPoint)const;
    Q_INVOKABLE int getIfaCalGridVelSecImp(short calibMode, short inflowGridPoint)const;
    Q_INVOKABLE int getIfaCalGridDcySec(short calibMode, short inflowGridPoint)const;
    Q_INVOKABLE int getIfaCalGridRpmSec(short calibMode, short inflowGridPoint)const;

    /// DOWNFLOW GRID
    Q_INVOKABLE QString getDfaCalGrid(short calibMode, short downflowGridPoint)const;
    Q_INVOKABLE int getDfaCalGridVel(short calibMode, short downflowGridPoint)const;
    Q_INVOKABLE int getDfaCalGridVelTot(short calibMode, short downflowGridPoint)const;
    Q_INVOKABLE int getDfaCalGridVelDev(short calibMode, short downflowGridPoint)const;
    Q_INVOKABLE int getDfaCalGridVelDevp(short calibMode, short downflowGridPoint)const;
    Q_INVOKABLE int getDfaCalGridVelHigh(short calibMode, short downflowGridPoint)const;
    Q_INVOKABLE int getDfaCalGridVelLow(short calibMode, short downflowGridPoint)const;
    Q_INVOKABLE int getDfaCalGridVelImp(short calibMode, short downflowGridPoint)const;
    Q_INVOKABLE int getDfaCalGridVelTotImp(short calibMode, short downflowGridPoint)const;
    Q_INVOKABLE int getDfaCalGridVelDevImp(short calibMode, short downflowGridPoint)const;
    Q_INVOKABLE int getDfaCalGridVelDevpImp(short calibMode, short downflowGridPoint)const;
    Q_INVOKABLE int getDfaCalGridVelHighImp(short calibMode, short downflowGridPoint)const;
    Q_INVOKABLE int getDfaCalGridVelLowImp(short calibMode, short downflowGridPoint)const;

    /// INFLOW DIM GRID
    void setIfaCalGrid(short calibMode, short inflowGridPoint, const QString &value);
    void setIfaCalGridTot(short calibMode, short inflowGridPoint, int value);
    void setIfaCalGridAvg(short calibMode, short inflowGridPoint, int value);
    void setIfaCalGridVol(short calibMode, short inflowGridPoint, int value);
    void setIfaCalGridVel(short calibMode, short inflowGridPoint, int value);
    void setIfaCalGridTotImp(short calibMode, short inflowGridPoint, int value);
    void setIfaCalGridAvgImp(short calibMode, short inflowGridPoint, int value);
    void setIfaCalGridVolImp(short calibMode, short inflowGridPoint, int value);
    void setIfaCalGridVelImp(short calibMode, short inflowGridPoint, int value);
    void setIfaCalGridDcy(short calibMode, short inflowGridPoint, int value);
    void setIfaCalGridRpm(short calibMode, short inflowGridPoint, int value);

    /// INFLOW SEC GRID
    void setIfaCalGridSec(short calibMode, short inflowGridPoint, const QString &value);
    void setIfaCalGridTotSec(short calibMode, short inflowGridPoint, int value);
    void setIfaCalGridAvgSec(short calibMode, short inflowGridPoint, int value);
    void setIfaCalGridVelSec(short calibMode, short inflowGridPoint, int value);
    void setIfaCalGridTotSecImp(short calibMode, short inflowGridPoint, int value);
    void setIfaCalGridAvgSecImp(short calibMode, short inflowGridPoint, int value);
    void setIfaCalGridVelSecImp(short calibMode, short inflowGridPoint, int value);
    void setIfaCalGridDcySec(short calibMode, short inflowGridPoint, int value);
    void setIfaCalGridRpmSec(short calibMode, short inflowGridPoint, int value);

    /// DOWNFLOW GRID
    void setDfaCalGrid(short calibMode, short downflowGridPoint, const QString &value);
    void setDfaCalGridVel(short calibMode, short downflowGridPoint, int value);
    void setDfaCalGridVelTot(short calibMode, short downflowGridPoint, int value);
    void setDfaCalGridVelDev(short calibMode, short downflowGridPoint, int value);
    void setDfaCalGridVelDevp(short calibMode, short downflowGridPoint, int value);
    void setDfaCalGridVelHigh(short calibMode, short downflowGridPoint, int value);
    void setDfaCalGridVelLow(short calibMode, short downflowGridPoint, int value);
    void setDfaCalGridVelImp(short calibMode, short downflowGridPoint, int value);
    void setDfaCalGridVelTotImp(short calibMode, short downflowGridPoint, int value);
    void setDfaCalGridVelDevImp(short calibMode, short downflowGridPoint, int value);
    void setDfaCalGridVelDevpImp(short calibMode, short downflowGridPoint, int value);
    void setDfaCalGridVelHighImp(short calibMode, short downflowGridPoint, int value);
    void setDfaCalGridVelLowImp(short calibMode, short downflowGridPoint, int value);

    /// Certification Parameters
    Q_INVOKABLE QString getCertificationParametersStr(short index)const;
    Q_INVOKABLE int getCertificationParametersInt(short index)const;

    void setCertificationParametersStr(short index, const QString &value);
    void setCertificationParametersInt(short index, int value);

    /// Booking Schedule
    void setBookingScheduleNotifEnable(bool value);
    void setBookingScheduleNotifTime(int value);
    void setBookingScheduleTodayVarList(QVariantList value);
    void setBookingScheduleTodayVarListToShow(QVariantList value);
    void setBookingScheduleTodayDispNotif(bool value);
    void setBookingScheduleNotifCollapse(bool value);

    bool getBookingScheduleNotifEnable() const;
    int getBookingScheduleNotifTime() const;
    QVariantList getBookingScheduleTodayVarList() const;
    QVariantList getBookingScheduleTodayVarListToShow() const;
    bool getBookingScheduleTodayDispNotif() const;
    bool getBookingScheduleNotifCollapse() const;

    void setExperimentTimerAlwaysShow(bool value);
    bool getExperimentTimerAlwaysShow()const;


    void setFanSpeedMaxLimit(int value);
    int getFanSpeedMaxLimit() const;

    void setFanSpeedMaxLimitSaved(int value);
    int getFanSpeedMaxLimitSaved() const;

    void setFanSpeedFullEnable(bool value);
    bool getFanSpeedFullEnable() const;

    void setSystemActualDate(const QString &value);
    QString getSystemActualDate() const;
    void setSystemActualTime(const QString &value);
    QString getSystemActualTime() const;

    /// RP Database External Resources
    Q_INVOKABLE QJsonObject getRpExtDatabase() const;
    void setRpExtDatabase(QJsonObject value);
    Q_INVOKABLE QJsonObject getRpExtDefault() const;
    void setRpExtDefault(QJsonObject value);
    bool getRpExtDatabaseEnable() const;
    void setRpExtDatabaseEnable(bool value);


public slots:
    void initSingleton();

signals:
    void machineStateChanged(int machineState);
    void machineProfileIDChanged(const QString &value);

    void countChanged(int count);

    void hasStoppedChanged(bool hasStopped);

    void fanPrimaryStateChanged(short fanPrimaryState);
    void lightStateChanged(short lightState);
    void socketStateChanged(short socketState);
    void gasStateChanged(short gasState);
    void uvStateChanged(short uvState);

    void muteAlarmStateChanged(short muteAlarmState);

    void sashWindowStateChanged(short sashWindowState);
    void sashWindowPrevStateChanged(short sashMotorizeState);
    void sashWindowMotorizeStateChanged(short sashMotorizeState);
    void exhaustContactStateChanged(short gasState);
    void alarmContactStateChanged(short uvState);
    void lightIntensityChanged(short lightIntensity);

    void magSWStateChanged(short index, bool state);

    void alarmInflowLowChanged(short alarmInflowLow);
    void alarmSashChanged(short alarmSash);
    void alarmSashUnsafeChanged(short alarmSashUnsafe);
    void alarmStandbyFanOffChanged(short alarm);
    void alarmExperimentTimerIsOverChanged(short value);

    void airflowMonitorEnableChanged(bool airflowMonitorEnable);
    void ifaAdcChanged(int ifaAdc);
    void ifaAdcConpensationChanged(int ifaAdcConpensation);
    void ifaVelocityChanged(int ifaVelocity);
    void ifaVelocityStrChanged(const QString &dfaVelocityStr);
    void dfaVelocityChanged(int dfaVelocity);
    void dfaVelocityStrChanged(const QString &dfaVelocityStr);

    void airflowCalibrationStatusChanged(short airflowCalibrationStatus);

    void measurementUnitChanged(short measurementUnit);
    void measurementUnitDuringCalibChanged(short measurementUnitDuringCalib);

    void fanPrimaryDutyCycleChanged(short fanPrimaryDutyCycle);
    void fanPrimaryRpmChanged(int fanPrimaryRpm);

    void temperatureChanged(short temperature);
    void temperatureAdcChanged(int value);
    void temperatureValueStrfChanged(const QString &value);

    void machineModelNameChanged(const QString &machineModelName);
    void machineClassNameChanged(const QString &machineClassName);
    void machineProfileNameChanged(const QString &machineProfile);
    void machineProfileChanged(QJsonObject machineProfile);

    void lcdBrightnessLevelChanged(short lcdBrightnessLevel);
    void lcdBrightnessLevelUserChanged(short lcdBrightnessLevelUser);
    void lcdBrightnessDelayToDimmChanged(short lcdBrightnessDelayToDimm);
    void lcdBrightnessLevelDimmedChanged(bool lcdBrightnessLevelDimmed);
    void lcdEnableLockScreenChanged(bool value);

    void languageChanged(const QString &language);

    void timeZoneChanged(const QString &timeZone);
    void timeClockPeriodChanged(short timeClockPeriod);

    //    void fanPrimaryStandbyRpmChanged(int fanPrimaryStandbyRpm);
    //    void fanPrimaryNominalDutyCycleFieldChanged(short fanPrimaryNominalDutyCycleField);
    //    void fanPrimaryNominalRpmFieldChanged(int fanPrimaryNominalRpmField);
    //    void fanPrimaryNominalDutyCycleFactoryChanged(short fanPrimaryNominalDutyCycleFactory);
    //    void fanPrimaryNominalRpmFactoryChanged(int fanPrimaryNominalRpmFactory);
    //    void fanPrimaryStandbyDutyCycleFactoryChanged(short fanPrimaryStandbyDutyCycleFactory);
    //    void fanPrimaryStandbyRpmFactoryChanged(int fanPrimaryStandbyRpmFactory);
    //    void fanPrimaryStandbyDutyCycleFieldChanged(short fanPrimaryStandbyDutyCycleField);
    //    void fanPrimaryStandbyRpmFieldChanged(int fanPrimaryStandbyRpmField);

    void exhPressureActualPaChanged();

    void boardStatusHybridDigitalRelayChanged(bool boardStatusHybridDigitalRelay);
    void boardStatusHybridDigitalInputChanged(bool boardStatusHybridDigitalInput);
    void boardStatusHybridAnalogInputChanged(bool boardStatusHybridAnalogInput);
    void boardStatusHybridAnalogOutputChanged(bool boardStatusHybridAnalogOutput);
    void boardStatusHybridAnalogOutput2Changed(bool value);
    void boardStatusAnalogOutputChanged(bool value);
    void boardStatusRbmComChanged(bool boardStatusRbmCom);
    void boardStatusPressureDiffChanged(bool boardStatusPressureDiff);
    void boardStatusCtpRtcChanged(bool boardStatusCtpRtc);
    void boardStatusParticleCounterChanged(bool boardStatusParticleCounter);
    void boardStatusCtpIoeChanged(bool boardStatusCtpIoe);

    /// DATA LOG
    void dataLogEnableChanged(bool dataLogEnable);
    void dataLogRunningChanged(bool dataLogRunning);
    void dataLogCountChanged(int dataLogCount);
    void dataLogPeriodChanged(int dataLogCount);
    void dataLogIsFullChanged(bool dataLogIsFull);

    /// RESOURCE MONITOR
    void resourceMonitorLogEnableChanged(bool value);
    void resourceMonitorLogRunningChanged(bool value);
    void resourceMonitorLogCountChanged(int value);
    void resourceMonitorLogPeriodChanged(int value);
    void resourceMonitorLogIsFullChanged(bool value);

    void fanPrimaryInterlockedChanged(short fanPrimaryInterlocked);
    void lightInterlockedChanged(bool lightInterlocked);
    void socketInterlockedChanged(bool socketInterlocked);
    void gasInterlockedChanged(bool gasInterlocked);
    void socketInstalledChanged(bool socketInstalled);
    void gasInstalledChanged(bool gasInstalled);

    void uvInterlockedChanged(bool uvInterlocked);
    void uvInstalledChanged(bool uvInstalled);
    ///
    void uvTimeActiveChanged(bool uvTimeActive);
    void uvTimeChanged(int uvTime);
    void uvTimeCountdownChanged(int uvTimeCountdown);

    void tempAmbientStatusChanged(short tempAmbientStatus);

    void operationModeChanged(short operationMode);

    void sashWindowMotorizeUpInterlockedChanged(bool sashWindowMotorizeUpInterlocked);
    void sashWindowMotorizeDownInterlockedChanged(bool sashWindowMotorizeDownInterlocked);
    void sashWindowMotorizeInstalledChanged(bool sashWindowMotorizeInstalled);

    void warmingUpActiveChanged(bool warmingUpRunning);
    void warmingUpExecutedChanged(bool warmingUpExecuted);
    void warmingUpTimeChanged(int warmingUpTime);
    void warmingUpCountdownChanged(int warmingUpCountdown);

    void fanPrimarySwithingStateTriggered(bool stateTo);

    void uvLifeMinutesChanged(int uvLifeMinutes);
    void uvLifePercentChanged(short uvLifePercent);
    void uvLifeLevelColorStrfChanged(const QString &value);
    void uvReplacementReminderChanged(bool value);
    void uvReplacementReminderSnoozedChanged(bool value);

    void alarmSashFullyOpenChanged(short alarmSashFullyOpen);
    void alarmsStateChanged(bool alarmState);
    void alarmBoardComErrorChanged(short alarmBoardComError);

    void postPurgingActiveChanged(bool postPurgingActive);
    void postPurgingTimeChanged(int postPurgingTime);
    void postPurgingCountdownChanged(int postPurgingCountdown);

    /// Filter lIfe
    void filterLifeReminderChanged(bool filterLifeReminder);
    void filterLifeReminderSnoozedChanged(bool value);
    void filterLifeMinutesChanged(int filterLifeMinutes);
    void filterLifePercentChanged(short filterLifePercent);
    void filterLifeLevelStrfChanged(const QString &value);
    void filterLifeLevelColorStrfChanged(const QString &value);
    void filterLifeRpmChanged                   (int value);
    void filterLifeCalculationModeChanged       (int value);
    void filterLifeMinimumBlowerUsageModeChanged (int value);
    void filterLifeMaximumBlowerUsageModeChanged (int value);
    void filterLifeMinimumBlowerRpmModeChanged   (int value);
    void filterLifeMaximumBlowerRpmModeChanged   (int value);

    void powerOutageChanged(bool powerOutage);
    void powerOutageTimeChanged(const QString &powerOutageTime);
    void powerOutageRecoverTimeChanged(const QString &powerOutageRecoverTime);
    void powerOutageFanStateChanged(short powerOutageFanState);
    void powerOutageUvStateChanged(short powerOutageUvState);

    //    void powerOutageLightStateChanged(short powerOutageLightState);

    void seasFlapInstalledChanged(bool seasFlapInstalled);
    void seasFlapAlarmPressureChanged(short seasFlapAlarmPressure);

    void seasInstalledChanged(bool seasInstalled);
    void seasPressureDiffPaChanged(int seasPressureDiffPa);
    void seasPressureDiffChanged(int seasPressureDiff);
    void seasPressureDiffStrChanged(const QString &seasPressureDiffStr);
    void seasPressureDiffPaLowLimitChanged(int seasPressureDiffPaLowLimit);
    void seasAlarmPressureLowChanged(short seasAlarmPressureLow);
    void seasPressureDiffPaOffsetChanged(short seasPressureDiffPaOffset);
    void seasPressureDiffPaNominalChanged(short value);

    void fanUsageMeterChanged(int fanUsageMeter);

    void muteAlarmTimeChanged(int muteAlarmTime);
    void muteAlarmTimeAtFullyOpenedChanged(int value);
    void muteAlarmCountdownChanged(int muteAlarmCountdown);

    void serialNumberChanged(const QString &serialNumber);

    void alarmLogCountChanged(int alarmLogCount);
    void alarmLogIsFullChanged(bool alarmLogIsFull);

    void modbusAllowIpMasterChanged(const QString &modbusAllowIpMaster);
    void modbusAllowSetFanChanged(bool modbusAllowSetFan);
    void modbusAllowSetLightChanged(bool modbusAllowSetLight);
    void modbusAllowSetLightIntensityChanged(bool modbusAllowSetLightIntensity);
    void modbusAllowSetSocketChanged(bool modbusAllowSetSocket);
    void modbusAllowGasSetChanged(bool modbusAllowGasSet);
    void modbusAllowSetUvLightChanged(bool modbusAllowSetUvLight);
    void modbusLatestStatusChanged(const QString &modbusLatestStatus);

    void modbusSlaveIDChanged(short modbusSlaveID);

    void eventLogCountChanged(int eventLogCount);
    void eventLogIsFullChanged(bool eventLogIsFull);
    void replaceableCompRecordCountChanged(int value);
    void replaceableCompRecordIsFullChanged(bool value);

    void uvAutoEnabledChanged(int uvAutoSetEnabled);
    void uvAutoTimeChanged(int uvAutoSetTime);
    void uvAutoDayRepeatChanged(int uvAutoSetDayRepeat);
    void uvAutoWeeklyDayChanged(int uvAutoSetWeeklyDay);

    void uvAutoEnabledOffChanged(int uvAutoSetEnabledOff);
    void uvAutoTimeOffChanged(int uvAutoSetTimeOff);
    void uvAutoDayRepeatOffChanged(int uvAutoSetDayRepeatOff);
    void uvAutoWeeklyDayOffChanged(int uvAutoSetWeeklyDayOff);

    void lightAutoEnabledChanged(int lightAutoSetEnabled);
    void lightAutoTimeChanged(int lightAutoSetTime);
    void lightAutoDayRepeatChanged(int lightAutoSetDayRepeat);
    void lightAutoWeeklyDayChanged(int lightAutoSetWeeklyDay);

    void lightAutoEnabledOffChanged(int lightAutoSetEnabledOff);
    void lightAutoTimeOffChanged(int lightAutoSetTimeOff);
    void lightAutoDayRepeatOffChanged(int lightAutoSetDayRepeatOff);
    void lightAutoWeeklyDayOffChanged(int lightAutoSetWeeklyDayOff);

    void socketAutoEnabledChanged(int socketAutoSetEnabled);
    void socketAutoTimeChanged(int socketAutoSetTime);
    void socketAutoDayRepeatChanged(int socketAutoSetDayRepeat);
    void socketAutoWeeklyDayChanged(int socketAutoSetWeeklyDay);

    void socketAutoEnabledOffChanged(int socketAutoSetEnabledOff);
    void socketAutoTimeOffChanged(int socketAutoSetTimeOff);
    void socketAutoDayRepeatOffChanged(int socketAutoSetDayRepeatOff);
    void socketAutoWeeklyDayOffChanged(int socketAutoSetWeeklyDayOff);

    void fanAutoEnabledChanged(int fanAutoSetEnabled);
    void fanAutoTimeChanged(int fanAutoSetTime);
    void fanAutoDayRepeatChanged(int fanAutoSetDayRepeat);
    void fanAutoWeeklyDayChanged(int fanAutoSetWeeklyDay);
    void fanAutoEnabledOffChanged(int fanAutoSetEnabledOff);
    void fanAutoTimeOffChanged(int fanAutoSetTimeOff);
    void fanAutoDayRepeatOffChanged(int fanAutoSetDayRepeatOff);
    void fanAutoWeeklyDayOffChanged(int fanAutoSetWeeklyDayOff);

    void securityAccessChanged(short securityAccessMode);

    void dateCertificationReminderChanged(const QString &dateCertificationReminder);

    void certificationExpiredChanged(bool certificationExpired);

    void certificationExpiredCountChanged(int certificationExpiredCount);

    void escoLockServiceEnableChanged(int escoLockServiceEnable);

    void certificationExpiredValidChanged(int certificationExpiredValid);

    void cabinetDisplayNameChanged(const QString &cabinetDisplayName);

    void fanPINChanged(const QString &fanPIN);

    void sashCycleMeterChanged(int sashCycleMeter);

    void sashCycleMotorLockedAlarmChanged(short value);

    void envTempHighestLimitChanged(int envTempHighestLimit);

    void envTempLowestLimitChanged(int envTempLowestLimit);

    void alarmTempHighChanged(short alarmTempHigh);

    void alarmTempLowChanged(short alarmTempLow);

    void particleCounterPM2_5Changed(int particleCounterPM2_5);

    void particleCounterPM10Changed(int particleCounterPM10);

    void particleCounterPM1_0Changed(int particleCounterPM1_0);

    void particleCounterSensorInstalledChanged(bool particleCounterSensorInstalled);

    void particleCounterSensorFanStateChanged(short particleCounterSensorFanState);

    void vivariumMuteStateChanged(bool vivariumMuteState);

    void watchdogCounterChanged(int watchdogCounter);

    void rtcActualDateChanged(const QString &rtcActualDate);
    void rtcActualTimeChanged(const QString &rtcActualTime);
    void rtcBatteryLowStatusChanged(bool value);

    void dataLogSpaceMaximumChanged(int dataLogSpaceMaximum);
    void alarmLogSpaceMaximumChanged(int alarmLogSpaceMaximum);
    void eventLogSpaceMaximumChanged(int eventLogSpaceMaximum);
    void replaceableCompRecordSpaceMaximumChanged(int value);
    void resourceMonitorLogSpaceMaximumChanged(int value);

    void shippingModeEnableChanged(bool shippingModeEnable);

    /// PREVENTIVE MAINTENANCE
    void maintenanceChecklistChanged(QJsonObject value);
    void alarmPreventMaintActiveChanged(bool value);
    void alarmPreventMaintActiveCodeChanged(ushort value);
    void alarmPreventMaintStateChanged(ushort value);
    void alarmPreventMaintStateEnableChanged(ushort value);
    void alarmPreventMaintStateAckChanged(ushort value);
    //    void preventMaintChecklistNotEmptyChanged(ushort value);
    //    void dailyPreventMaintAckChanged(bool value);
    //    void weeklyPreventMaintAckChanged(bool value);
    //    void monthlyPreventMaintAckChanged(bool value);
    //    void quarterlyPreventMaintAckChanged(bool value);
    //    void annuallyPreventMaintAckChanged(bool value);
    //    void bienniallyPreventMaintAckChanged(bool value);
    //    void quinquenniallyPreventMaintAckChanged(bool value);
    //    void canopyPreventMaintAckChanged(bool value);

    void dailyPreventMaintAckDueDateChanged(const QString &value);
    void weeklyPreventMaintAckDueDateChanged(const QString &value);
    void monthlyPreventMaintAckDueDateChanged(const QString &value);
    void quarterlyPreventMaintAckDueDateChanged(const QString &value);
    void annuallyPreventMaintAckDueDateChanged(const QString &value);
    void bienniallyPreventMaintAckDueDateChanged(const QString &value);
    void quinquenniallyPreventMaintAckDueDateChanged(const QString &value);
    void canopyPreventMaintAckDueDateChanged(const QString &value);

    void dailyPreventMaintLastAckDateChanged(const QString &value);
    void weeklyPreventMaintLastAckDateChanged(const QString &value);
    void monthlyPreventMaintLastAckDateChanged(const QString &value);
    void quarterlyPreventMaintLastAckDateChanged(const QString &value);
    void annuallyPreventMaintLastAckDateChanged(const QString &value);
    void bienniallyPreventMaintLastAckDateChanged(const QString &value);
    void quinquenniallyPreventMaintLastAckDateChanged(const QString &value);
    void canopyPreventMaintLastAckDateChanged(const QString &value);
    void preventMaintDateHasBeenReset();

    void dailyPreventMaintRemindBeforeChanged(int value);
    void weeklyPreventMaintRemindBeforeChanged(int value);
    void monthlyPreventMaintRemindBeforeChanged(int value);
    void quarterlyPreventMaintRemindBeforeChanged(int value);
    void annuallyPreventMaintRemindBeforeChanged(int value);
    void bienniallyPreventMaintRemindBeforeChanged(int value);
    void quinquenniallyPreventMaintRemindBeforeChanged(int value);
    void canopyPreventMaintRemindBeforeChanged(int value);

    void wiredNetworkHasbeenConfiguredChanged(bool value);

    /// SVN UPDATE
    //bool m_centurionUpdateEnable = false;
    void svnUpdateAvailableChanged(bool value);
    void svnUpdateSwuVersionChanged(const QString &value);
    void svnUpdatePathChanged(const QString &value);
    void svnUpdateHistoryChanged(QJsonObject value);

    void svnUpdateCheckForUpdateEnableChanged(bool value);
    void svnUpdateCheckForUpdatePeriodChanged(int value);

    void rpListDefaultChanged(QJsonObject value);
    void rpListLastChanged(QVariantList value);
    void rpListSelectedChanged(QVariantList value);
    void keyboardStringOnAcceptedEventSignal(const QString &value);
    void keyboardStringOnAcceptedEventChanged(const QString &value);

    void userLastLoginChanged(QJsonArray value);

    void usbDetectedListChanged(const QString &list);
    void lastUsbDetectedNameChanged(const QString &name);

    void usbHasMounted(const QString &name);
    void usbHasEjected(const QString &name);

    void frontEndScreenStateChanged(short value);
    void frontEndScreenStatePrevChanged(short value);
    void installationWizardActiveChanged(short value);
    void cabinetUpTimeChanged(int value);

    /// Front Panel Switch on LA2EU
    void frontPanelSwitchInstalledChanged(bool value);
    void frontPanelSwitchStateChanged(bool value);
    void frontPanelAlarmChanged(bool value);

    ///SASH MOTORIZED
    void sashMotorDownStuckSwitchChanged(bool value);
    void alarmSashMotorDownStuckChanged(short value);
    void sashWindowSafeHeight2Changed(bool value);
    void sashMotorOffDelayMsecChanged(int value);

    ///Resource Monitor
    //    void resourceMonitorParamsActiveChanged(bool value);
    void resourceMonitorParamsChanged(const QStringList &value);
    void uSdCardIndustrialChanged(bool value);

    void filterLifeDisplayEnabledChanged(bool state);
    void airflowOutTempEnableChanged(bool value);

    ///
    void inflowSensorConstantChanged(short value);
    void ifaTemperatureCalibChanged(int value);
    /// SENSOR CONSTANT CORRECTION
    void sensorConstCorrEnableChanged(bool value);
    void sensorConstCorrHighZoneChanged(int value);
    void sensorConstCorrLowZoneChanged(int value);

    /// HYBRID ANALOG INPUT MVOLT
    void haBoardInputCh1MVoltChanged(int value);
    void haBoardInputCh2MVoltChanged(int value);

    /// LOGOUT TIME
    void logoutTimeChanged(int value);
    void timerEventLogout();

    /// 21 CFR PART 11
    bool cfr21Part11EnableChanged(bool value);

    short fanSpeedControllerBoardChanged(short value);

    short propogateComposeEventGestureChanged(short value);

    /// ADVANCED AIRFLOW ALARM
    void advancedAirflowAlarmEnableChanged(bool value);
    void alarmDownflowLowChanged(short value);
    void alarmDownflowHighChanged(short value);

    /// Booking Schedule
    void bookingScheduleNotifEnableChanged(bool value);
    void bookingScheduleNotifTimeChanged(int value);
    void bookingScheduleTodayVarListChanged(QVariantList value);
    void bookingScheduleTodayVarListToShowChanged(QVariantList value);
    void bookingScheduleTodayDispNotifChanged(bool value);
    void bookingScheduleNotifCollapseChanged(bool value);

    /// Experiment Timer
    void experimentTimerAlwaysShowChanged(bool value);

    void fanSpeedMaxLimitChanged(int value);
    void fanSpeedMaxLimitSavedChanged(int value);
    void fanSpeedFullEnableChanged(bool value);

    void systemActualDateChanged(const QString &value);
    void systemActualTimeChanged(const QString &value);

    /// RP Database External Resources
    void rpExtDatabaseEnableChanged(bool value);
    void rpExtDatabaseChanged();
    void rpExtDefaultChanged();
    void checkValidityOfRpListFinised(bool valid);

private:
    ///
    QString m_machineProfileID;
    short m_machineState;

    int m_count = 0;
    bool m_hasStopped = true;

    // CONTROL STATES

    ///SASH-Magnetic Switch
    bool  m_magSwitchState[6] = {false, false, false, false, false, false};
    ///SASH
    short m_sashWindowState = 0;
    short m_sashWindowStateSample[5] = {0};
    bool m_sashWindowStateChangedValid = false;

    short m_fanPrimaryState = 0;

    short m_lightState = 0;
    bool m_lightInterlocked = false;
    short m_lightIntensity = 0;

    bool m_socketInterlocked = false;
    short m_socketState = 0;
    bool m_socketInstalled = false;

    bool m_gasInterlocked = false;
    short m_gasState = 0;
    bool m_gasInstalled = false;

    bool m_uvInterlocked = false;
    short m_uvState = 0;
    bool m_uvInstalled = false;

    short m_muteAlarmState = 0;
    int m_muteAlarmTime = 0;
    int m_muteAlarmTimeAtFullyOpened = 0;
    int m_muteAlarmCountdown = 0;

    short m_sashWindowPrevState = 0;
    short m_sashWindowMotorizeState = 0;
    short m_exhaustContactState = 0;
    short m_alarmContactState = 0;

    /// ALARM STATES
    bool m_alarmsState = false;
    short m_alarmBoardComError = 0;
    short m_alarmInflowLow = 0;
    short m_alarmSash = 0;
    short m_alarmStandbyFanOff = 0;
    short m_alarmExperimentTimerIsOver = 0;
    //    bool m_alarmDownflowLow = false;
    //    bool m_alarmDownflowHigh = false;
    short m_alarmTempHigh = 0;
    short m_alarmTempLow = 0;

    short m_measurementUnit = 0; //mps
    short m_measurementUnitDuringCalib = 0; //mps

    // ACTUAL TEMPERATURE
    int     m_temperatureAdc = 0;
    short   m_temperature = 0;
    QString m_temperatureValueStrf;
    short   m_temperatureCelcius = 0;

    //IFA
    short m_airflowCalibrationStatus = 0;
    //
    bool m_airflowMonitorEnable = true;
    int     m_ifaAdc = 0;
    int     m_ifaAdcConpensation = 0;
    int     m_ifaVelocity = 0;
    QString m_ifaVelocityStr;
    //
    short   m_ifaConstant = 0;
    short   m_ifaTemperatureCalib = 0;
    short   m_ifaTemperatureCalibAdc = 0;
    //
    int     m_ifaAdcPointFactory[3] = {0,0,0};
    int     m_ifaVelocityPointFactory[3] = {0,0,0};
    //
    int     m_ifaAdcPointField[3] = {0,0,0};
    int     m_ifaVelocityPointField[3] = {0,0,0};
    //
    int     m_ifaLowLimitVelocity = 0;
    //DFA
    int     m_dfaVelocity = 0;
    int     m_dfaVelocityPointFactory[3] = {0,0,0};
    int     m_dfaVelocityPointField[3] = {0,0,0};
    QString m_dfaVelocityStr;

    // PRESSURE DIFFERENTIAL
    int    m_dataExhPressureActualPa = 0;

    //MACHINE PROFILE
    QString     m_machineProfileName;
    QJsonObject m_machineProfile;
    QString     m_unitModelName;
    QString     m_unitClassName;

    //LCD BRIGHTNESS
    short m_lcdBrightnessLevelUser = 0;
    short m_lcdBrightnessLevel = 0;
    short m_lcdBrightnessDelayToDimm = 0;
    bool m_lcdBrightnessLevelDimmed = 0;
    bool m_lcdEnableLockScreen = 0;

    //DATE TIME AND LANGUAGE
    QString m_language;
    QString m_timeZone;
    short m_timeClockPeriod = 12; // 12h

    //FAN CALIBRATION
    short   m_fanPrimaryDutyCycle = 0;
    int     m_fanPrimaryRpm = 0;
    short   m_fanPrimaryNominalDutyCycle = 0;
    int     m_fanPrimaryNominalRpm = 0;
    short   m_fanPrimaryMinimumDutyCycle = 0;
    int     m_fanPrimaryMinimumRpm = 0;
    short   m_fanPrimaryStandbyDutyCycle = 0;
    int     m_fanPrimaryStandbyRpm = 0;
    short   m_fanPrimaryNominalDutyCycleFactory = 0;
    int     m_fanPrimaryNominalRpmFactory = 0;
    short   m_fanPrimaryNominalDutyCycleField = 0;
    int     m_fanPrimaryNominalRpmField = 0;

    short   m_fanPrimaryMinimumDutyCycleFactory = 0;
    int     m_fanPrimaryMinimumRpmFactory = 0;
    short   m_fanPrimaryMinimumDutyCycleField = 0;
    int     m_fanPrimaryMinimumRpmField = 0;

    short   m_fanPrimaryStandbyDutyCycleFactory = 0;
    int     m_fanPrimaryStandbyRpmFactory = 0;
    short   m_fanPrimaryStandbyDutyCycleField = 0;
    int     m_fanPrimaryStandbyRpmField = 0;

    bool    m_boardStatusHybridDigitalRelay = false;
    bool    m_boardStatusHybridDigitalInput = false;
    bool    m_boardStatusHybridAnalogInput  = false;
    bool    m_boardStatusHybridAnalogOutput = false;
    bool    m_boardStatusHybridAnalogOutput2 = false;
    bool    m_boardStatusRbmCom  = false;
    bool    m_boardStatusPressureDiff  = false;
    bool    m_boardStatusCtpRtc = false;
    bool    m_boardStatusParticleCounter = false;
    bool    m_boardStatusCtpIoe = false;

    /// Datalog
    bool m_dataLogEnable    = false;
    bool m_dataLogRunning   = false;
    short m_dataLogPeriod   = 10; //minutes
    int   m_dataLogCount    = 0;
    bool  m_dataLogIsFull   = false;
    /// Resource Monitor
    bool m_resourceMonitorLogEnable    = false;
    bool m_resourceMonitorLogRunning   = false;
    short m_resourceMonitorLogPeriod   = 10; //minutes
    int   m_resourceMonitorLogCount    = 0;
    bool  m_resourceMonitorLogIsFull   = false;

    bool m_fanPrimaryInterlocked = false;

    short m_tempAmbientStatus = 0;

    short m_operationMode = 0;

    bool m_sashWindowMotorizeUpInterlocked = false;
    bool m_sashWindowMotorizeDownInterlocked = false;
    bool m_sashWindowMotorizeInstalled = false;

    ///WARMING UP
    bool m_warmingUpActive = false;
    bool m_warmingUpStateExecuted = false;
    int  m_warmingUpTime = 0;
    int  m_warmingUpCountdown = 0;

    bool m_uvTimeActive = false;
    int m_uvTime = 0;
    int m_uvTimeCountdown = 0;

    int m_uvLifeMinutes = 0;
    short m_uvLifePercent = 0;
    QString m_uvLifeLevelColorStrf;
    bool m_uvReplacementReminder = false;
    bool m_uvReplacementReminderSnoozed = false;

    bool m_postPurgingActive = false;
    int m_postPurgingTime = 0;
    int m_postPurgingCountdown = 0;

    /// Filter Life
    bool m_filterLifeReminder = false;
    bool m_filterLifeReminderSnoozed = false;
    int m_filterLifeMinutes = 0;
    short m_filterLifePercent = 0;
    QString m_filterLifeLevelStrf;
    QString m_filterLifeLevelColorStrf;
    int m_filterLifeRpm                    = 0;
    int m_filterLifeCalculationMode        = 0;
    int m_filterLifeMinimumBlowerUsageMode  = 0;
    int m_filterLifeMaximumBlowerUsageMode  = 0;
    int m_filterLifeMinimumBlowerRpmMode    = 0;
    int m_filterLifeMaximumBlowerRpmMode    = 0;

    bool m_powerOutage = false;
    QString m_powerOutageTime;
    QString m_powerOutageRecoverTime;
    short m_powerOutageFanState = 0;
    //    short m_powerOutageLightState = 0;
    short m_powerOutageUvState = 0;

    ///    SEAS FLAP
    bool m_seasFlapInstalled = false;
    short m_seasFlapAlarmPressure = 0;

    /// SEAS
    bool m_seasInstalled = false;
    int m_seasPressureDiffPa = 0;
    int m_seasPressureDiff = 0;
    QString m_seasPressureDiffStr;
    int m_seasPressureDiffPaLowLimit = 0;
    short m_seasAlarmPressureLow = 0;
    short m_seasPressureDiffPaOffset = 0;
    short m_seasPressureDiffPaNominal = 0;

    /// FAN USAGE MATER
    int m_fanUsageMeter = 0;
    QString m_serialNumber;

    /// ALARM LOG
    int m_alarmLogCount = 0;
    bool m_alarmLogIsFull = false;

    /// MODBUS
    QString m_modbusAllowIpMaster;
    bool m_modbusAllowSetFan = false;
    bool m_modbusAllowSetLight = false;
    bool m_modbusAllowSetLightIntensity = false;
    bool m_modbusAllowSetSocket = false;
    bool m_modbusAllowSetGas = false;
    bool m_modbusAllowSetUvLight = false;
    QString m_modbusLatestStatus;
    short m_modbusSlaveID = 1;

    int m_eventLogCount = 0;
    bool m_eventLogIsFull = false;

    int m_replaceableCompRecordCount = 0;
    bool m_replaceableCompRecordIsFull = false;

    int m_uvAutoEnabled = 0;
    int m_uvAutoTime = 0;
    int m_uvAutoDayRepeat = 0;
    int m_uvAutoWeeklyDay = 0;
    int m_uvAutoEnabledOff = 0;
    int m_uvAutoTimeOff = 0;
    int m_uvAutoDayRepeatOff = 0;
    int m_uvAutoWeeklyDayOff = 0;

    int m_lightAutoEnabled = 0;
    int m_lightAutoTime = 0;
    int m_lightAutoDayRepeat = 0;
    int m_lightAutoWeeklyDay = 0;
    int m_lightAutoEnabledOff = 0;
    int m_lightAutoTimeOff = 0;
    int m_lightAutoDayRepeatOff = 0;
    int m_lightAutoWeeklyDayOff = 0;

    int m_socketAutoEnabled = 0;
    int m_socketAutoTime = 0;
    int m_socketAutoDayRepeat = 0;
    int m_socketAutoWeeklyDay = 0;
    int m_socketAutoEnabledOff = 0;
    int m_socketAutoTimeOff = 0;
    int m_socketAutoDayRepeatOff = 0;
    int m_socketAutoWeeklyDayOff = 0;

    int m_fanAutoEnabled = 0;
    int m_fanAutoTime = 0;
    int m_fanAutoDayRepeat = 0;
    int m_fanAutoWeeklyDay = 0;
    int m_fanAutoEnabledOff = 0;
    int m_fanAutoTimeOff = 0;
    int m_fanAutoDayRepeatOff = 0;
    int m_fanAutoWeeklyDayOff = 0;

    short m_securityAccessMode = 0;

    QString m_dateCertificationReminder;
    bool m_certificationExpired = false;
    int m_certificationExpiredCount = 0;
    bool m_certificationExpiredValid = false;

    bool m_escoLockServiceEnable = false;

    QString m_cabinetDisplayName;

    QString m_fanPIN;

    /// m_sashCycleCountValid return true if sash state has reached Standby, Fully Closed, and Fully Opened
    /// m_sashCycleCountValid return false if sash state in Safe height
    bool m_sashCycleCountValid = false;
    int m_sashCycleMeter = 0;
    short m_sashCycleMotorLockedAlarm = false;

    int m_envTempHighestLimit = 0;
    int m_envTempLowestLimit = 0;

    /// PARTICLE COUNTER
    int m_particleCounterPM2_5 = 0;
    int m_particleCounterPM10 = 0;
    int m_particleCounterPM1_0 = 0;
    bool m_particleCounterSensorInstalled = false;
    short m_particleCounterSensorFanState = 0;

    bool m_vivariumMuteState = false;

    /// WATCHDOG
    int m_watchdogCounter = 0;
    QString m_rtcActualDate;
    QString m_rtcActualTime;
    bool m_rtcBatteryLowStatus;

    int m_dataLogSpaceMaximum = 0;
    int m_alarmLogSpaceMaximum = 0;
    int m_eventLogSpaceMaximum = 0;
    int m_replaceableCompRecordSpaceMaximum = 0;
    int m_resourceMonitorLogSpaceMaximum = 0;

    bool m_shippingModeEnable = false;

    QString m_sbcSerialNumber;
    QString m_sbcCurrentFullMacAddress;
    QStringList m_sbcSystemInformation;
    bool m_sbcCurrentSerialNumberKnown = false;
    QString m_sbcCurrentSerialNumber;
    QStringList m_sbcCurrentSystemInformation;
    short m_hardwareInformation = 0;

    /// PREVENTIVE MAINTENANCE
    QJsonObject m_maintenanceChecklist;
    bool m_alarmPreventMaintActive = false;
    ushort m_alarmPreventMaintActiveCode = 0;
    ushort m_alarmPreventMaintState = 0;
    ushort m_alarmPreventMaintStateEnable = 0;
    ushort m_alarmPreventMaintStateAck = 0;
    //    ushort m_preventMaintChecklistNotEmpty = 0;

    //    bool m_dailyPreventMaintAck = false;
    //    bool m_weeklyPreventMaintAck = false;
    //    bool m_monthlyPreventMaintAck = false;
    //    bool m_quarterlyPreventMaintAck = false;
    //    bool m_annuallyPreventMaintAck = false;
    //    bool m_bienniallyPreventMaintAck = false;
    //    bool m_quinquenniallyPreventMaintAck = false;
    //    bool m_canopyPreventMaintAck = false;

    QString m_dailyPreventMaintAckDueDate;
    QString m_weeklyPreventMaintAckDueDate;
    QString m_monthlyPreventMaintAckDueDate;
    QString m_quarterlyPreventMaintAckDueDate;
    QString m_annuallyPreventMaintAckDueDate;
    QString m_bienniallyPreventMaintAckDueDate;
    QString m_quinquenniallyPreventMaintAckDueDate;
    QString m_canopyPreventMaintAckDueDate;

    QString m_dailyPreventMaintLastAckDate;
    QString m_weeklyPreventMaintLastAckDate;
    QString m_monthlyPreventMaintLastAckDate;
    QString m_quarterlyPreventMaintLastAckDate;
    QString m_annuallyPreventMaintLastAckDate;
    QString m_bienniallyPreventMaintLastAckDate;
    QString m_quinquenniallyPreventMaintLastAckDate;
    QString m_canopyPreventMaintLastAckDate;

    int m_dailyPreventMaintRemindBefore;
    int m_weeklyPreventMaintRemindBefore;
    int m_monthlyPreventMaintRemindBefore;
    int m_quarterlyPreventMaintRemindBefore;
    int m_annuallyPreventMaintRemindBefore;
    int m_bienniallyPreventMaintRemindBefore;
    int m_quinquenniallyPreventMaintRemindBefore;
    int m_canopyPreventMaintRemindBefore;

    bool m_airflowFieldCalibrationState[MachineEnums::CalFieldState_Total] = {false};
    bool m_airflowFactoryCalibrationState[MachineEnums::CalFactoryState_Total] = {false};

    /// ETHERNET CONNECTION
    QString m_eth0ConName;
    QString m_eth0Ipv4Address;
    bool m_eth0ConEnabled = false;
    bool m_wiredNetworkHasbeenConfigured = false;

    /// SVN UPDATE
    //bool m_centurionUpdateEnable = false;
    bool m_svnUpdateAvailable = false;
    QString m_svnUpdateSwuVersion;
    QString m_svnUpdatePath;
    QJsonObject m_svnUpdateHistory;

    bool m_svnUpdateCheckForUpdateEnable;
    int m_svnUpdateCheckForUpdatePeriod;

    QJsonObject m_rpListDefault;
    QVariantList m_rpListLast;
    QVariantList m_rpListSelected;
    QString m_keyboardStringOnAcceptedEvent;

    QJsonArray m_userLastLogin;

    QString m_usbDetectedList = "";
    QString m_lastUsbDetectedName = "";

    short m_frontEndScreenState = 0;
    short m_frontEndScreenStatePrev = 0;
    bool m_installationWizardActive= false;
    int m_cabinetUpTime = 0;

    bool m_frontPanelSwitchInstalled = false;
    bool m_frontPanelSwitchState = false;
    short m_frontPanelAlarm = 0;

    bool m_sashMotorDownStuckSwitch = false;
    short m_alarmSashMotorDownStuck = 0;
    bool m_sashWindowSafeHeight2 = false;
    int m_sashMotorOffDelayMsec = 0;

    //    bool m_resourceMonitorParamsActive = false;
    QStringList m_resourceMonitorParams;
    bool m_uSdCardIndustrial = false;

    bool m_filterLifeDisplayEnabled = false;
    bool m_airflowOutTempEnable = false;

    /// SENSOR CONSTANT CORRECTION
    bool m_sensorConstCorrEnable = false;
    int m_sensorConstCorrHighZone = 0;
    int m_sensorConstCorrLowZone = 0;
    int m_adcInflowPointCorrection[3] = {0};

    /// HYBRID ANALOG INPUT MVOLT
    int m_haBoardInputCh1MVolt = 0;
    int m_haBoardInputCh2MVolt = 0;

    /// LOGOUT TIME
    int m_logoutTime = 0;

    /// 21 CFR PART 11
    bool m_cfr21Part11Enable = false;

    short m_fanSpeedControllerBoard = 0;

    bool m_propogateComposeEventGesture = false;

    /// ADVANCED AIRFLOW ALARM
    bool m_advancedAirflowAlarmEnable = false;
    short m_alarmDownflowLow = 0;
    short m_alarmDownflowHigh = 0;

    /// Booking Schedule
    bool m_bookingScheduleNotifEnable = 0;
    int m_bookingScheduleNotifTime = 0;
    QVariantList m_bookingScheduleTodayVarList;
    QVariantList m_bookingScheduleTodayVarListToShow;
    bool m_bookingScheduleTodayDispNotif = false;
    bool m_bookingScheduleNotifCollapse = false;

    /// Experiment Timer
    bool m_experimentTimerAlwaysShow = false;

    /// INFLOW DIM GRID
    QString m_ifaCalGrid[MachineEnums::CALIB_MODE_TOTAL][MachineEnums::INFLOW_GRID_TOTAL];
    int m_ifaCalGridTot[MachineEnums::CALIB_MODE_TOTAL][MachineEnums::INFLOW_GRID_TOTAL] = {{0},{0}};
    int m_ifaCalGridAvg[MachineEnums::CALIB_MODE_TOTAL][MachineEnums::INFLOW_GRID_TOTAL] = {{0},{0}};
    int m_ifaCalGridVol[MachineEnums::CALIB_MODE_TOTAL][MachineEnums::INFLOW_GRID_TOTAL] = {{0},{0}};
    int m_ifaCalGridVel[MachineEnums::CALIB_MODE_TOTAL][MachineEnums::INFLOW_GRID_TOTAL] = {{0},{0}};
    int m_ifaCalGridTotImp[MachineEnums::CALIB_MODE_TOTAL][MachineEnums::INFLOW_GRID_TOTAL] = {{0},{0}};
    int m_ifaCalGridAvgImp[MachineEnums::CALIB_MODE_TOTAL][MachineEnums::INFLOW_GRID_TOTAL] = {{0},{0}};
    int m_ifaCalGridVolImp[MachineEnums::CALIB_MODE_TOTAL][MachineEnums::INFLOW_GRID_TOTAL] = {{0},{0}};
    int m_ifaCalGridVelImp[MachineEnums::CALIB_MODE_TOTAL][MachineEnums::INFLOW_GRID_TOTAL] = {{0},{0}};
    int m_ifaCalGridDcy[MachineEnums::CALIB_MODE_TOTAL][MachineEnums::INFLOW_GRID_TOTAL] = {{0},{0}};
    int m_ifaCalGridRpm[MachineEnums::CALIB_MODE_TOTAL][MachineEnums::INFLOW_GRID_TOTAL] = {{0},{0}};

    /// INFLOW SEC GRID
    QString m_ifaCalGridSec[MachineEnums::CALIB_MODE_TOTAL][MachineEnums::INFLOW_GRID_TOTAL];
    int m_ifaCalGridTotSec[MachineEnums::CALIB_MODE_TOTAL][MachineEnums::INFLOW_GRID_TOTAL] = {{0},{0}};
    int m_ifaCalGridAvgSec[MachineEnums::CALIB_MODE_TOTAL][MachineEnums::INFLOW_GRID_TOTAL] = {{0},{0}};
    int m_ifaCalGridVelSec[MachineEnums::CALIB_MODE_TOTAL][MachineEnums::INFLOW_GRID_TOTAL] = {{0},{0}};
    int m_ifaCalGridTotSecImp[MachineEnums::CALIB_MODE_TOTAL][MachineEnums::INFLOW_GRID_TOTAL] = {{0},{0}};
    int m_ifaCalGridAvgSecImp[MachineEnums::CALIB_MODE_TOTAL][MachineEnums::INFLOW_GRID_TOTAL] = {{0},{0}};
    int m_ifaCalGridVelSecImp[MachineEnums::CALIB_MODE_TOTAL][MachineEnums::INFLOW_GRID_TOTAL] = {{0},{0}};
    int m_ifaCalGridDcySec[MachineEnums::CALIB_MODE_TOTAL][MachineEnums::INFLOW_GRID_TOTAL] = {{0},{0}};
    int m_ifaCalGridRpmSec[MachineEnums::CALIB_MODE_TOTAL][MachineEnums::INFLOW_GRID_TOTAL] = {{0},{0}};

    /// DOWNFLOW GRID
    QString m_dfaCalGrid[MachineEnums::CALIB_MODE_TOTAL][MachineEnums::DOWNFLOW_GRID_TOTAL];
    int m_dfaCalGridVel[MachineEnums::CALIB_MODE_TOTAL][MachineEnums::DOWNFLOW_GRID_TOTAL] = {{0},{0}};
    int m_dfaCalGridVelTot[MachineEnums::CALIB_MODE_TOTAL][MachineEnums::DOWNFLOW_GRID_TOTAL] = {{0},{0}};
    int m_dfaCalGridVelDev[MachineEnums::CALIB_MODE_TOTAL][MachineEnums::DOWNFLOW_GRID_TOTAL] = {{0},{0}};
    int m_dfaCalGridVelDevp[MachineEnums::CALIB_MODE_TOTAL][MachineEnums::DOWNFLOW_GRID_TOTAL] = {{0},{0}};
    int m_dfaCalGridVelHigh[MachineEnums::CALIB_MODE_TOTAL][MachineEnums::DOWNFLOW_GRID_TOTAL] = {{0},{0}};
    int m_dfaCalGridVelLow[MachineEnums::CALIB_MODE_TOTAL][MachineEnums::DOWNFLOW_GRID_TOTAL] = {{0},{0}};
    int m_dfaCalGridVelImp[MachineEnums::CALIB_MODE_TOTAL][MachineEnums::DOWNFLOW_GRID_TOTAL] = {{0},{0}};
    int m_dfaCalGridVelTotImp[MachineEnums::CALIB_MODE_TOTAL][MachineEnums::DOWNFLOW_GRID_TOTAL] = {{0},{0}};
    int m_dfaCalGridVelDevImp[MachineEnums::CALIB_MODE_TOTAL][MachineEnums::DOWNFLOW_GRID_TOTAL] = {{0},{0}};
    int m_dfaCalGridVelDevpImp[MachineEnums::CALIB_MODE_TOTAL][MachineEnums::DOWNFLOW_GRID_TOTAL] = {{0},{0}};
    int m_dfaCalGridVelHighImp[MachineEnums::CALIB_MODE_TOTAL][MachineEnums::DOWNFLOW_GRID_TOTAL] = {{0},{0}};
    int m_dfaCalGridVelLowImp[MachineEnums::CALIB_MODE_TOTAL][MachineEnums::DOWNFLOW_GRID_TOTAL] = {{0},{0}};

    QString m_certificationParametersStr[MachineEnums::CertifParamStr_Total];
    int m_certificationParametersInt[MachineEnums::CertifParamInt_Total];


    int m_fanSpeedMaxLimit = 0;
    int m_fanSpeedMaxLimitSaved = 0;
    bool m_fanSpeedFullEnable = false;

    QString m_systemActualTime;
    QString m_systemActualDate;

    bool m_rpExtDatabaseEnable = false;
    QJsonObject m_rpExtDatabase;
    QJsonObject m_rpExtDefault;
};





