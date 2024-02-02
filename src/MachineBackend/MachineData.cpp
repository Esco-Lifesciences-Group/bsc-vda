#include <QQmlEngine>
#include <QJSEngine>
//#include <QSettings>

#include <QDebug>

#include "MachineData.h"

static MachineData* s_instance = nullptr;

QObject *MachineData::singletonProvider(QQmlEngine *qmlEngine, QJSEngine *)
{
    if(!s_instance){
        qDebug() << "MachineData::singletonProvider::create" << s_instance;
        s_instance = new MachineData(qmlEngine);
    }
    return s_instance;
}

void MachineData::singletonDelete()
{
    qDebug() << __FUNCTION__;
    if(s_instance){
        delete s_instance;
    }
}

void MachineData::initSingleton()
{
    qDebug() << metaObject()->className() << __FUNCTION__ << thread();

    //    QSettings settings;

    //    QString  machProfId = settings.value("machProfId", "NONE").toString();
    //    setMachineProfileID(machProfId);
    //    qDebug() << machProfId;
}

QString MachineData::getCertificationParametersStr(short index) const
{
    if(index >= MachineEnums::CertifParamStr_Total || index < 0) return QString();
    return m_certificationParametersStr[index];
}

int MachineData::getCertificationParametersInt(short index) const
{
    if(index >= MachineEnums::CertifParamInt_Total || index < 0) return 0;

    return m_certificationParametersInt[index];
}

void MachineData::setCertificationParametersStr(short index, const QString &value)
{
    if(index >= MachineEnums::CertifParamStr_Total || index < 0) return;

    if(m_certificationParametersStr[index] == value) return;
    m_certificationParametersStr[index] = value;
}

void MachineData::setCertificationParametersInt(short index, int value)
{
    if(index >= MachineEnums::CertifParamInt_Total || index < 0) return;

    if(m_certificationParametersInt[index] == value) return;
    m_certificationParametersInt[index] = value;
}

void MachineData::setBookingScheduleNotifEnable(bool value)
{
    if(m_bookingScheduleNotifEnable == value) return;
    m_bookingScheduleNotifEnable = value;
    emit bookingScheduleNotifEnableChanged(value);
}

void MachineData::setBookingScheduleNotifTime(int value)
{
    if(m_bookingScheduleNotifTime == value)return;
    m_bookingScheduleNotifTime = value;
    emit bookingScheduleNotifTimeChanged(value);
}

void MachineData::setBookingScheduleTodayVarList(QVariantList value)
{
    if(m_bookingScheduleTodayVarList == value) return;
    m_bookingScheduleTodayVarList = value;
    emit bookingScheduleTodayVarListChanged(value);
}

void MachineData::setBookingScheduleTodayVarListToShow(QVariantList value)
{
    if(m_bookingScheduleTodayVarListToShow == value) return;
    m_bookingScheduleTodayVarListToShow = value;
    emit bookingScheduleTodayVarListToShowChanged(value);
}

void MachineData::setBookingScheduleTodayDispNotif(bool value)
{
    if(m_bookingScheduleTodayDispNotif == value) return;
    m_bookingScheduleTodayDispNotif = value;
    emit bookingScheduleTodayDispNotifChanged(value);
}

void MachineData::setBookingScheduleNotifCollapse(bool value)
{
    if(m_bookingScheduleNotifCollapse == value) return;
    m_bookingScheduleNotifCollapse = value;
    emit bookingScheduleNotifCollapseChanged(value);
}

bool MachineData::getBookingScheduleNotifEnable() const
{
    return m_bookingScheduleNotifEnable;
}

int MachineData::getBookingScheduleNotifTime() const
{
    return m_bookingScheduleNotifTime;
}

QVariantList MachineData::getBookingScheduleTodayVarList() const
{
    return m_bookingScheduleTodayVarList;
}

QVariantList MachineData::getBookingScheduleTodayVarListToShow() const
{
    return m_bookingScheduleTodayVarListToShow;
}

bool MachineData::getBookingScheduleTodayDispNotif() const
{
    return m_bookingScheduleTodayDispNotif;
}

bool MachineData::getBookingScheduleNotifCollapse() const
{
    return m_bookingScheduleNotifCollapse;
}

void MachineData::setExperimentTimerAlwaysShow(bool value)
{
    if(m_experimentTimerAlwaysShow == value)return;
    m_experimentTimerAlwaysShow = value;
    emit experimentTimerAlwaysShowChanged(value);
}

bool MachineData::getExperimentTimerAlwaysShow() const
{
    return m_experimentTimerAlwaysShow;
}

void MachineData::setShippingModeEnable(bool shippingModeEnable)
{
    if (m_shippingModeEnable == shippingModeEnable)
        return;

    m_shippingModeEnable = shippingModeEnable;
    emit shippingModeEnableChanged(m_shippingModeEnable);
}

QString MachineData::getSbcCurrentFullMacAddress() const
{
    return m_sbcCurrentFullMacAddress;
}

void MachineData::setSbcCurrentFullMacAddress(const QString &sbcCurrentFullMacAddress)
{
    if(m_sbcCurrentFullMacAddress == sbcCurrentFullMacAddress)return;
    m_sbcCurrentFullMacAddress = sbcCurrentFullMacAddress;
    //    emit sbcCurrentFullMacAddressChanged(m_sbcCurrentFullMacAddress);
}

QStringList MachineData::getSbcSystemInformation() const
{
    return m_sbcSystemInformation;
}

void MachineData::setSbcSystemInformation(const QStringList &sbcSystemInformation)
{
    if(m_sbcSystemInformation == sbcSystemInformation)return;
    m_sbcSystemInformation = sbcSystemInformation;
}

short MachineData::getHardwareInformation() const
{
    return m_hardwareInformation;
}

void MachineData::setHardwareInformation(short &value)
{
    if(m_hardwareInformation == value) return;
    m_hardwareInformation = value;
    //    emit hardwareInformationChanged(value);
}

bool MachineData::getSbcCurrentSerialNumberKnown() const
{
    return m_sbcCurrentSerialNumberKnown;
}

void MachineData::setSbcCurrentSerialNumberKnown(bool value)
{
    if(m_sbcCurrentSerialNumberKnown == value) return;
    m_sbcCurrentSerialNumberKnown = value;
}

QString MachineData::getSbcCurrentSerialNumber() const
{
    return m_sbcCurrentSerialNumber;
}

void MachineData::setSbcCurrentSerialNumber(const QString &value)
{
    if(m_sbcCurrentSerialNumber == value)return;
    m_sbcCurrentSerialNumber = value;
}


QStringList MachineData::getSbcCurrentSystemInformation() const
{
    return m_sbcCurrentSystemInformation;
}

void MachineData::setSbcCurrentSystemInformation(const QStringList &sbcCurrentSystemInformation)
{
    if(m_sbcCurrentSystemInformation == sbcCurrentSystemInformation)return;
    m_sbcCurrentSystemInformation = sbcCurrentSystemInformation;
}

QJsonObject MachineData::getMaintenanceChecklist() const
{
    return m_maintenanceChecklist;
}

bool MachineData::getAlarmPreventMaintActive() const
{
    return m_alarmPreventMaintActive;
}

ushort MachineData::getAlarmPreventMaintActiveCode() const
{
    return m_alarmPreventMaintActiveCode;
}

ushort MachineData::getAlarmPreventMaintState() const
{
    return m_alarmPreventMaintState;
}

ushort MachineData::getAlarmPreventMaintStateEnable() const
{
    return m_alarmPreventMaintStateEnable;
}

ushort MachineData::getAlarmPreventMaintStateAck() const
{
    return m_alarmPreventMaintStateAck;
}

//ushort MachineData::getPreventMaintChecklistNotEmpty() const
//{
//    return m_preventMaintChecklistNotEmpty;
//}

//bool MachineData::getDailyPreventMaintAck() const
//{
//    return m_dailyPreventMaintAck;
//}

//bool MachineData::getWeeklyPreventMaintAck() const
//{
//    return m_weeklyPreventMaintAck;
//}

//bool MachineData::getMonthlyPreventMaintAck() const
//{
//    return m_monthlyPreventMaintAck;
//}

//bool MachineData::getQuarterlyPreventMaintAck() const
//{
//    return m_quarterlyPreventMaintAck;
//}

//bool MachineData::getAnnuallyPreventMaintAck() const
//{
//    return m_annuallyPreventMaintAck;
//}

//bool MachineData::getBienniallyPreventMaintAck() const
//{
//    return m_bienniallyPreventMaintAck;
//}

//bool MachineData::getQuinquenniallyPreventMaintAck() const
//{
//    return m_quinquenniallyPreventMaintAck;
//}

//bool MachineData::getCanopyPreventMaintAck() const
//{
//    return m_canopyPreventMaintAck;
//}

QString MachineData::getDailyPreventMaintAckDueDate() const
{
    return m_dailyPreventMaintAckDueDate;
}

QString MachineData::getWeeklyPreventMaintAckDueDate() const
{
    return m_weeklyPreventMaintAckDueDate;
}

QString MachineData::getMonthlyPreventMaintAckDueDate() const
{
    return m_monthlyPreventMaintAckDueDate;
}

QString MachineData::getQuarterlyPreventMaintAckDueDate() const
{
    return m_quarterlyPreventMaintAckDueDate;
}

QString MachineData::getAnnuallyPreventMaintAckDueDate() const
{
    return m_annuallyPreventMaintAckDueDate;
}

QString MachineData::getBienniallyPreventMaintAckDueDate() const
{
    return m_bienniallyPreventMaintAckDueDate;
}

QString MachineData::getQuinquenniallyPreventMaintAckDueDate() const
{
    return m_quinquenniallyPreventMaintAckDueDate;
}

QString MachineData::getCanopyPreventMaintAckDueDate() const
{
    return m_canopyPreventMaintAckDueDate;
}

QString MachineData::getDailyPreventMaintLastAckDate() const
{
    return m_dailyPreventMaintLastAckDate;
}

QString MachineData::getWeeklyPreventMaintLastAckDate() const
{
    return m_weeklyPreventMaintLastAckDate;
}

QString MachineData::getMonthlyPreventMaintLastAckDate() const
{
    return m_monthlyPreventMaintLastAckDate;
}

QString MachineData::getQuarterlyPreventMaintLastAckDate() const
{
    return m_quarterlyPreventMaintLastAckDate;
}

QString MachineData::getAnnuallyPreventMaintLastAckDate() const
{
    return m_annuallyPreventMaintLastAckDate;
}

QString MachineData::getBienniallyPreventMaintLastAckDate() const
{
    return m_bienniallyPreventMaintLastAckDate;
}

QString MachineData::getQuinquenniallyPreventMaintLastAckDate() const
{
    return m_quinquenniallyPreventMaintLastAckDate;
}

QString MachineData::getCanopyPreventMaintLastAckDate() const
{
    return m_canopyPreventMaintLastAckDate;
}

int MachineData::getDailyPreventMaintRemindBefore() const
{
    return m_dailyPreventMaintRemindBefore;
}

int MachineData::getWeeklyPreventMaintRemindBefore() const
{
    return m_weeklyPreventMaintRemindBefore;
}

int MachineData::getMonthlyPreventMaintRemindBefore() const
{
    return m_monthlyPreventMaintRemindBefore;
}

int MachineData::getQuarterlyPreventMaintRemindBefore() const
{
    return m_quarterlyPreventMaintRemindBefore;
}

int MachineData::getAnnuallyPreventMaintRemindBefore() const
{
    return m_annuallyPreventMaintRemindBefore;
}

int MachineData::getBienniallyPreventMaintRemindBefore() const
{
    return m_bienniallyPreventMaintRemindBefore;
}

int MachineData::getQuinquenniallyPreventMaintRemindBefore() const
{
    return m_quinquenniallyPreventMaintRemindBefore;
}

int MachineData::getCanopyPreventMaintRemindBefore() const
{
    return m_canopyPreventMaintRemindBefore;
}

void MachineData::setMaintenanceChecklist(QJsonObject value)
{
    if(m_maintenanceChecklist == value)return;
    m_maintenanceChecklist = value;
    emit maintenanceChecklistChanged(value);
}

void MachineData::setAlarmPreventMaintActive(bool value)
{
    if(m_alarmPreventMaintActive == value)return;
    m_alarmPreventMaintActive = value;
    emit alarmPreventMaintActiveChanged(value);
}

void MachineData::setAlarmPreventMaintActiveCode(ushort value)
{
    if(m_alarmPreventMaintActive == value) return;
    m_alarmPreventMaintActiveCode = value;
    emit alarmPreventMaintActiveCodeChanged(value);
}

void MachineData::setAlarmPreventMaintState(ushort value)
{
    if(m_alarmPreventMaintState == value)return;
    m_alarmPreventMaintState = value;
    emit alarmPreventMaintStateChanged(value);
}

void MachineData::setAlarmPreventMaintStateEnable(ushort value)
{
    if(m_alarmPreventMaintStateEnable == value)return;
    m_alarmPreventMaintStateEnable = value;
    emit alarmPreventMaintStateEnableChanged(value);
}

void MachineData::setAlarmPreventMaintStateAck(ushort value)
{
    if(m_alarmPreventMaintStateAck == value) return;
    m_alarmPreventMaintStateAck = value;
    emit alarmPreventMaintStateAckChanged(value);
}

//void MachineData::setPreventMaintChecklistNotEmpty(ushort value)
//{
//    if(m_preventMaintChecklistNotEmpty == value)return;
//    m_preventMaintChecklistNotEmpty = value;
//    emit preventMaintChecklistNotEmptyChanged(value);
//}

//void MachineData::setDailyPreventMaintAck(bool value)
//{
//    if(m_dailyPreventMaintAck == value)return;
//    m_dailyPreventMaintAck = value;
//    emit dailyPreventMaintAckChanged(value);
//}

//void MachineData::setWeeklyPreventMaintAck(bool value)
//{
//    if(m_weeklyPreventMaintAck == value)return;
//    m_weeklyPreventMaintAck = value;
//    emit weeklyPreventMaintAckChanged(value);
//}

//void MachineData::setMonthlyPreventMaintAck(bool value)
//{
//    if(m_monthlyPreventMaintAck == value)return;
//    m_monthlyPreventMaintAck = value;
//    emit monthlyPreventMaintAckChanged(value);
//}

//void MachineData::setQuarterlyPreventMaintAck(bool value)
//{
//    if(m_quarterlyPreventMaintAck == value)return;
//    m_quarterlyPreventMaintAck = value;
//    emit quarterlyPreventMaintAckChanged(value);
//}

//void MachineData::setAnnuallyPreventMaintAck(bool value)
//{
//    if(m_annuallyPreventMaintAck == value)return;
//    m_annuallyPreventMaintAck = value;
//    emit annuallyPreventMaintAckChanged(value);
//}

//void MachineData::setBienniallyPreventMaintAck(bool value)
//{
//    if(m_bienniallyPreventMaintAck == value)return;
//    m_bienniallyPreventMaintAck = value;
//    emit bienniallyPreventMaintAckChanged(value);
//}

//void MachineData::setQuinquenniallyPreventMaintAck(bool value)
//{
//    if(m_quinquenniallyPreventMaintAck == value)return;
//    m_quinquenniallyPreventMaintAck = value;
//    emit quinquenniallyPreventMaintAckChanged(value);
//}

//void MachineData::setCanopyPreventMaintAck(bool value)
//{
//    if(m_canopyPreventMaintAck == value)return;
//    m_canopyPreventMaintAck = value;
//    emit canopyPreventMaintAckChanged(value);
//}

void MachineData::setDailyPreventMaintAckDueDate(const QString &value)
{
    if(m_dailyPreventMaintAckDueDate == value)return;
    m_dailyPreventMaintAckDueDate = value;
    emit dailyPreventMaintAckDueDateChanged(value);
}

void MachineData::setWeeklyPreventMaintAckDueDate(const QString &value)
{
    if(m_weeklyPreventMaintAckDueDate == value)return;
    m_weeklyPreventMaintAckDueDate = value;
    emit weeklyPreventMaintAckDueDateChanged(value);
}

void MachineData::setMonthlyPreventMaintAckDueDate(const QString &value)
{
    if(m_monthlyPreventMaintAckDueDate == value)return;
    m_monthlyPreventMaintAckDueDate = value;
    emit monthlyPreventMaintAckDueDateChanged(value);
}

void MachineData::setQuarterlyPreventMaintAckDueDate(const QString &value)
{
    if(m_quarterlyPreventMaintAckDueDate == value)return;
    m_quarterlyPreventMaintAckDueDate = value;
    emit quarterlyPreventMaintAckDueDateChanged(value);
}

void MachineData::setAnnuallyPreventMaintAckDueDate(const QString &value)
{
    if(m_annuallyPreventMaintAckDueDate == value)return;
    m_annuallyPreventMaintAckDueDate = value;
    emit annuallyPreventMaintAckDueDateChanged(value);
}

void MachineData::setBienniallyPreventMaintAckDueDate(const QString &value)
{
    if(m_bienniallyPreventMaintAckDueDate == value)return;
    m_bienniallyPreventMaintAckDueDate = value;
    emit bienniallyPreventMaintAckDueDateChanged(value);
}

void MachineData::setQuinquenniallyPreventMaintAckDueDate(const QString &value)
{
    if(m_quinquenniallyPreventMaintAckDueDate == value)return;
    m_quinquenniallyPreventMaintAckDueDate = value;
    emit quinquenniallyPreventMaintAckDueDateChanged(value);
}

void MachineData::setCanopyPreventMaintAckDueDate(const QString &value)
{
    if(m_canopyPreventMaintAckDueDate == value)return;
    m_canopyPreventMaintAckDueDate = value;
    emit canopyPreventMaintAckDueDateChanged(value);
}

void MachineData::setDailyPreventMaintLastAckDate(const QString &value)
{
    if(m_dailyPreventMaintLastAckDate == value)return;
    m_dailyPreventMaintLastAckDate = value;
    emit dailyPreventMaintLastAckDateChanged(value);
}

void MachineData::setWeeklyPreventMaintLastAckDate(const QString &value)
{
    if(m_weeklyPreventMaintLastAckDate == value)return;
    m_weeklyPreventMaintLastAckDate = value;
    emit weeklyPreventMaintLastAckDateChanged(value);
}

void MachineData::setMonthlyPreventMaintLastAckDate(const QString &value)
{
    if(m_monthlyPreventMaintLastAckDate == value)return;
    m_monthlyPreventMaintLastAckDate = value;
    emit monthlyPreventMaintLastAckDateChanged(value);
}

void MachineData::setQuarterlyPreventMaintLastAckDate(const QString &value)
{
    if(m_quarterlyPreventMaintLastAckDate == value)return;
    m_quarterlyPreventMaintLastAckDate = value;
    emit quarterlyPreventMaintLastAckDateChanged(value);
}

void MachineData::setAnnuallyPreventMaintLastAckDate(const QString &value)
{
    if(m_annuallyPreventMaintLastAckDate == value)return;
    m_annuallyPreventMaintLastAckDate = value;
    emit annuallyPreventMaintLastAckDateChanged(value);
}

void MachineData::setBienniallyPreventMaintLastAckDate(const QString &value)
{
    if(m_bienniallyPreventMaintLastAckDate == value)return;
    m_bienniallyPreventMaintLastAckDate = value;
    emit bienniallyPreventMaintLastAckDateChanged(value);
}

void MachineData::setQuinquenniallyPreventMaintLastAckDate(const QString &value)
{
    if(m_quinquenniallyPreventMaintLastAckDate == value)return;
    m_quinquenniallyPreventMaintLastAckDate = value;
    emit quinquenniallyPreventMaintLastAckDateChanged(value);
}

void MachineData::setCanopyPreventMaintLastAckDate(const QString &value)
{
    if(m_canopyPreventMaintLastAckDate == value)return;
    m_canopyPreventMaintLastAckDate = value;
    emit canopyPreventMaintLastAckDateChanged(value);
}

void MachineData::setDailyPreventMaintRemindBefore(int value)
{
    if(m_dailyPreventMaintRemindBefore == value)return;
    m_dailyPreventMaintRemindBefore = value;
    emit dailyPreventMaintRemindBeforeChanged(value);
}

void MachineData::setWeeklyPreventMaintRemindBefore(int value)
{
    if(m_weeklyPreventMaintRemindBefore == value)return;
    m_weeklyPreventMaintRemindBefore = value;
    emit weeklyPreventMaintRemindBeforeChanged(value);
}

void MachineData::setMonthlyPreventMaintRemindBefore(int value)
{
    if(m_monthlyPreventMaintRemindBefore == value)return;
    m_monthlyPreventMaintRemindBefore = value;
    emit monthlyPreventMaintRemindBeforeChanged(value);
}

void MachineData::setQuarterlyPreventMaintRemindBefore(int value)
{
    if(m_quarterlyPreventMaintRemindBefore == value)return;
    m_quarterlyPreventMaintRemindBefore = value;
    emit quarterlyPreventMaintRemindBeforeChanged(value);
}

void MachineData::setAnnuallyPreventMaintRemindBefore(int value)
{
    if(m_annuallyPreventMaintRemindBefore == value)return;
    m_annuallyPreventMaintRemindBefore = value;
    emit annuallyPreventMaintRemindBeforeChanged(value);
}

void MachineData::setBienniallyPreventMaintRemindBefore(int value)
{
    if(m_bienniallyPreventMaintRemindBefore == value)return;
    m_bienniallyPreventMaintRemindBefore = value;
    emit bienniallyPreventMaintRemindBeforeChanged(value);
}

void MachineData::setQuinquenniallyPreventMaintRemindBefore(int value)
{
    if(m_quinquenniallyPreventMaintRemindBefore == value)return;
    m_quinquenniallyPreventMaintRemindBefore = value;
    emit quinquenniallyPreventMaintRemindBeforeChanged(value);
}

void MachineData::setCanopyPreventMaintRemindBefore(int value)
{
    if(m_canopyPreventMaintRemindBefore == value)return;
    m_canopyPreventMaintRemindBefore = value;
    emit canopyPreventMaintRemindBeforeChanged(value);
}

void MachineData::setEth0ConName(const QString &value)
{
    if(m_eth0ConName == value)return;
    m_eth0ConName = value;
}

void MachineData::setEth0Ipv4Address(const QString &value)
{
    if(m_eth0Ipv4Address == value)return;
    m_eth0Ipv4Address = value;
}

void MachineData::setEth0ConEnabled(bool value)
{
    if(m_eth0ConEnabled == value)return;
    m_eth0ConEnabled = value;
}

QString MachineData::getEth0ConName() const
{
    return m_eth0ConName;
}

QString MachineData::getEth0Ipv4Address() const
{
    return m_eth0Ipv4Address;
}

bool MachineData::getEth0ConEnabled() const
{
    return m_eth0ConEnabled;
}

void MachineData::setWiredNetworkHasbeenConfigured(bool value)
{
    if(m_wiredNetworkHasbeenConfigured == value)return;
    m_wiredNetworkHasbeenConfigured = value;
    emit wiredNetworkHasbeenConfiguredChanged(value);
}

bool MachineData::getWiredNetworkHasbeenConfigured() const
{
    return m_wiredNetworkHasbeenConfigured;
}

void MachineData::setSvnUpdateAvailable(bool value)
{
    if(m_svnUpdateAvailable == value)return;
    m_svnUpdateAvailable = value;
    emit svnUpdateAvailableChanged(value);
}

void MachineData::setSvnUpdateSwuVersion(const QString &value)
{
    if(m_svnUpdateSwuVersion == value)return;
    m_svnUpdateSwuVersion = value;
    emit svnUpdateSwuVersionChanged(value);
}

void MachineData::setSvnUpdatePath(const QString &value)
{
    if(m_svnUpdatePath == value)return;
    m_svnUpdatePath = value;
    emit svnUpdatePathChanged(value);
}

void MachineData::setSvnUpdateHistory(QJsonObject value)
{
    if(m_svnUpdateHistory == value)return;
    m_svnUpdateHistory = value;
    emit svnUpdateHistoryChanged(value);
}

bool MachineData::getSvnUpdateAvailable() const
{
    return m_svnUpdateAvailable;
}

QString MachineData::getSvnUpdateSwuVersion() const
{
    return m_svnUpdateSwuVersion;
}

QString MachineData::getSvnUpdatePath() const
{
    return m_svnUpdatePath;
}

QJsonObject MachineData::getSvnUpdateHistory() const
{
    return m_svnUpdateHistory;
}

bool MachineData::getSvnUpdateCheckForUpdateEnable() const
{
    return m_svnUpdateCheckForUpdateEnable;
}

int MachineData::getSvnUpdateCheckForUpdatePeriod() const
{
    return m_svnUpdateCheckForUpdatePeriod;
}

void MachineData::setSvnUpdateCheckForUpdateEnable(bool value)
{
    if(m_svnUpdateCheckForUpdateEnable == value)return;
    m_svnUpdateCheckForUpdateEnable = value;
    emit svnUpdateCheckForUpdateEnableChanged(value);
}

void MachineData::setSvnUpdateCheckForUpdatePeriod(int value)
{
    if(m_svnUpdateCheckForUpdatePeriod == value)return;
    m_svnUpdateCheckForUpdatePeriod = value;
    emit svnUpdateCheckForUpdatePeriodChanged(value);
}

void MachineData::setRpListDefault(QJsonObject value)
{
    if(m_rpListDefault == value)return;
    m_rpListDefault = value;
    emit rpListDefaultChanged(value);
    //    qDebug() << value;
}

void MachineData::setRpListLast(QVariantList value)
{
    if(m_rpListLast == value)return;
    m_rpListLast = value;
    emit rpListLastChanged(value);
}

void MachineData::setRpListLast(short index, const QString &value)
{
    if(index >= m_rpListLast.length() || index < 0) return;
    if(m_rpListLast.at(index).toString() == value) return;

    QVariantList tempVarList = m_rpListLast;
    //    qDebug() << "replace index" << index << tempVarList.at(index) << "with" << value;
    //    qDebug() << "before" << tempVarList.at(index).toString();
    tempVarList.takeAt(index);
    tempVarList.insert(index, value);
    //    qDebug() << "after" << tempVarList.at(index).toString();
    setRpListLast(tempVarList);
}

QJsonObject MachineData::getRpListDefault() const
{
    return m_rpListDefault;
}

QVariantList MachineData::getRpListLast() const
{
    return m_rpListLast;
}

QString MachineData::getRpListLastAtIndex(short index) const
{
    if(index >= m_rpListLast.length() || m_rpListLast.length() < 0) return "";
    return m_rpListLast.at(index).toString();
}

void MachineData::setRpListSelected(QVariantList value)
{
    if(m_rpListSelected == value)return;
    m_rpListSelected = value;
    emit rpListSelectedChanged(value);
}

void MachineData::setRpListSelected(short index, const QString &value)
{
    if(index >= m_rpListSelected.length() || index < 0) return;
    if(m_rpListSelected.at(index).toString() == value) return;

    QVariantList tempVarList = m_rpListSelected;
    //    qDebug() << "replace index" << index << tempVarList.at(index) << "with" << value;
    //    qDebug() << "before" << tempVarList.at(index).toString();
    tempVarList.takeAt(index);
    tempVarList.insert(index, value);
    //    qDebug() << "after" << tempVarList.at(index).toString();
    setRpListSelected(tempVarList);
}

QVariantList MachineData::getRpListSelected() const
{
    return m_rpListSelected;
}

QString MachineData::getRpListSelectedAtIndex(short index) const
{
    if(index >= m_rpListSelected.length() || m_rpListSelected.length() < 0) return "";
    return m_rpListSelected.at(index).toString();
}

void MachineData::setKeyboardStringOnAcceptedEvent(const QString &value)
{
    emit keyboardStringOnAcceptedEventSignal(value);
    if(m_keyboardStringOnAcceptedEvent == value)return;
    m_keyboardStringOnAcceptedEvent = value;
    emit keyboardStringOnAcceptedEventChanged(value);
}

QString MachineData::getKeyboardStringOnAcceptedEvent() const
{
    return m_keyboardStringOnAcceptedEvent;
}

void MachineData::setUserLasLogin(QJsonArray value)
{
    if(m_userLastLogin == value) return;
    m_userLastLogin = value;
    emit userLastLoginChanged(value);
}

QJsonArray MachineData::getUserLastLogin() const
{
    return m_userLastLogin;
}

QString MachineData::getUsbDetectedList() const
{
    return m_usbDetectedList;
}

void MachineData::setUsbDetectedList(const QString &list)
{
    if(m_usbDetectedList == list)
        return;
    m_usbDetectedList = list;
    emit usbDetectedListChanged(m_usbDetectedList);
}

QString MachineData::getLastUsbDetectedName() const
{
    return m_lastUsbDetectedName;
}

void MachineData::setLastUsbDetectedName(const QString &name)
{
    if(m_lastUsbDetectedName == name)
        return;
    m_lastUsbDetectedName = name;
    emit lastUsbDetectedNameChanged(m_lastUsbDetectedName);
}

void MachineData::setFrontEndScreenState(short value)
{
    if(m_frontEndScreenState == value) return;
    m_frontEndScreenState = value;
    emit frontEndScreenStateChanged(value);
}

short MachineData::getFrontEndScreenState() const
{
    return m_frontEndScreenState;
}

void MachineData::setFrontEndScreenStatePrev(short value)
{
    if(m_frontEndScreenStatePrev == value) return;
    m_frontEndScreenStatePrev = value;
    emit frontEndScreenStatePrevChanged(value);
}

short MachineData::getFrontEndScreenStatePrev() const
{
    return m_frontEndScreenStatePrev;
}

void MachineData::setInstallationWizardActive(bool value)
{
    if(m_installationWizardActive == value)return;
    m_installationWizardActive = value;
    emit installationWizardActiveChanged(value);
}

bool MachineData::getInstallationWizardActive() const
{
    return m_installationWizardActive;
}

void MachineData::setCabinetUpTime(int value)
{
    if(m_cabinetUpTime == value)return;
    m_cabinetUpTime = value;
    emit cabinetUpTimeChanged(value);
}

int MachineData::getCabinetUpTime() const
{
    return m_cabinetUpTime;
}

bool MachineData::getFrontPanelSwitchInstalled() const
{
    return m_frontPanelSwitchInstalled;
}

bool MachineData::getFrontPanelSwitchState() const
{
    return m_frontPanelSwitchState;
}

short MachineData::getFrontPanelAlarm() const
{
    return m_frontPanelAlarm;
}

void MachineData::setFrontPanelSwitchInstalled(bool value)
{
    if(m_frontPanelSwitchInstalled == value)return;
    m_frontPanelSwitchInstalled = value;
    emit frontPanelSwitchInstalledChanged(value);
}

void MachineData::setFrontPanelSwitchState(bool value)
{
    if(m_frontPanelSwitchState == value)return;
    m_frontPanelSwitchState = value;
    emit frontPanelSwitchStateChanged(value);
}

void MachineData::setFrontPanelAlarm(short value)
{
    if(m_frontPanelAlarm == value)return;
    m_frontPanelAlarm = value;
    emit frontPanelAlarmChanged(value);
}

void MachineData::setSashMotorDownStuckSwitch(bool value)
{
    if(m_sashMotorDownStuckSwitch == value)return;
    m_sashMotorDownStuckSwitch = value;
    emit sashMotorDownStuckSwitchChanged(value);
}

bool MachineData::getSashMotorDownStuckSwitch() const
{
    return m_sashMotorDownStuckSwitch;
}

short MachineData::getAlarmSashMotorDownStuck() const
{
    return m_alarmSashMotorDownStuck;
}

void MachineData::setAlarmSashMotorDownStuck(short value)
{
    if(m_alarmSashMotorDownStuck == value)return;
    m_alarmSashMotorDownStuck = value;
    emit alarmSashMotorDownStuckChanged(value);
}

void MachineData::setSashWindowSafeHeight2(bool value)
{
    if(m_sashWindowSafeHeight2 == value)return;
    m_sashWindowSafeHeight2 = value;
    emit sashWindowSafeHeight2Changed(value);
}

bool MachineData::getSashWindowSafeHeight2() const
{
    return m_sashWindowSafeHeight2;
}

void MachineData::setSashMotorOffDelayMsec(int value)
{
    if(m_sashMotorOffDelayMsec == value)return;
    m_sashMotorOffDelayMsec = value;
    emit sashMotorOffDelayMsecChanged(value);
}

int MachineData::getSashMotorOffDelayMsec() const
{
    return m_sashMotorOffDelayMsec;
}

//void MachineData::setResourceMonitorParamsActive(bool value)
//{
//    if(m_resourceMonitorParamsActive == value) return;
//    m_resourceMonitorParamsActive = value;
//    emit resourceMonitorParamsActiveChanged(value);
//}

//bool MachineData::getResourceMonitorParamsActive() const
//{
//    return m_resourceMonitorParamsActive;
//}

void MachineData::setResourceMonitorParams(const QStringList &value)
{
    if(m_resourceMonitorParams == value)return;
    m_resourceMonitorParams = value;
    emit resourceMonitorParamsChanged(value);
}

QStringList MachineData::getResourceMonitorParams() const
{
    return m_resourceMonitorParams;
}

void MachineData::setUSdCardIndustrial(bool value)
{
    if(m_uSdCardIndustrial == value)return;
    m_uSdCardIndustrial = value;
    emit uSdCardIndustrialChanged(value);
}

bool MachineData::getUSdCardIndustrial() const
{
    return m_uSdCardIndustrial;
}

bool MachineData::getFilterLifeDisplayEnabled() const
{
    return m_filterLifeDisplayEnabled;
}

void MachineData::setFilterLifeDisplayEnabled(bool state)
{
    if(m_filterLifeDisplayEnabled == state)
        return;
    m_filterLifeDisplayEnabled = state;
    emit filterLifeDisplayEnabledChanged(m_filterLifeDisplayEnabled);
}

void MachineData::setAirflowOutTempEnable(bool value)
{
    if(m_airflowOutTempEnable == value)return;
    m_airflowOutTempEnable = value;
    emit airflowOutTempEnableChanged(value);
}

bool MachineData::getAirflowOutTempEnable() const
{
    return m_airflowOutTempEnable;
}

void MachineData::setSensorConstCorrEnable(bool value)
{
    if(m_sensorConstCorrEnable == value)return;
    m_sensorConstCorrEnable = value;
    emit sensorConstCorrEnableChanged(value);
}

void MachineData::setSensorConstCorrHighZone(int value)
{
    if(m_sensorConstCorrHighZone == value)return;
    m_sensorConstCorrHighZone = value;
    emit sensorConstCorrHighZoneChanged(value);
}

void MachineData::setSensorConstCorrLowZone(int value)
{
    if(m_sensorConstCorrLowZone == value)return;
    m_sensorConstCorrLowZone = value;
    emit sensorConstCorrLowZoneChanged(value);
}

bool MachineData::getSensorConstCorrEnable() const
{
    return m_sensorConstCorrEnable;
}

int MachineData::getSensorConstCorrHighZone() const
{
    return m_sensorConstCorrHighZone;
}

int MachineData::getSensorConstCorrLowZone() const
{
    return m_sensorConstCorrLowZone;
}

void MachineData::setAdcInflowPointCorrection(short point, int value)
{
    if(point < 0 || point >= 3)return;

    if(m_adcInflowPointCorrection[point] == value)return;
    m_adcInflowPointCorrection[point] = value;
}

int MachineData::getAdcInflowPointCorrection(short point) const
{
    if(point < 0 || point >= 3)return 0;
    return m_adcInflowPointCorrection[point];
}

void MachineData::setHaBoardInputCh1MVolt(int value)
{
    if(m_haBoardInputCh1MVolt == value)return;
    m_haBoardInputCh1MVolt = value;
    emit haBoardInputCh1MVoltChanged(value);
}

void MachineData::setHaBoardInputCh2MVolt(int value)
{
    if(m_haBoardInputCh2MVolt == value)return;
    m_haBoardInputCh2MVolt = value;
    emit haBoardInputCh2MVoltChanged(value);
}

int MachineData::getHaBoardInputCh1MVolt() const
{
    return m_haBoardInputCh1MVolt;
}

int MachineData::getHaBoardInputCh2MVolt() const
{
    return m_haBoardInputCh2MVolt;
}

void MachineData::setLogoutTime(int value)
{
    if(m_logoutTime == value)return;
    m_logoutTime = value;
    emit logoutTimeChanged(value);
}

int MachineData::getLogoutTime() const
{
    return m_logoutTime;
}

void MachineData::setCfr21Part11Enable(bool value)
{
    if(m_cfr21Part11Enable == value)return;
    m_cfr21Part11Enable = value;
    emit cfr21Part11EnableChanged(value);
}

bool MachineData::getCfr21Part11Enable() const
{
    return m_cfr21Part11Enable;
}

void MachineData::setFanSpeedControllerBoard(short value)
{
    if(m_fanSpeedControllerBoard == value)return;
    m_fanSpeedControllerBoard = value;
    emit fanSpeedControllerBoardChanged(value);
}

short MachineData::getFanSpeedControllerBoard() const
{
    return m_fanSpeedControllerBoard;
}

void MachineData::setPropogateComposeEventGesture(bool value)
{
    if(m_propogateComposeEventGesture == value)return;
    m_propogateComposeEventGesture = value;
    emit propogateComposeEventGestureChanged(value);
}

short MachineData::getPropogateComposeEventGesture() const
{
    return m_propogateComposeEventGesture;
}

void MachineData::setAdvancedAirflowAlarmEnable(bool value)
{
    if(m_advancedAirflowAlarmEnable == value)return;
    m_advancedAirflowAlarmEnable = value;
    emit advancedAirflowAlarmEnableChanged(value);
}

void MachineData::setAlarmDownflowLow(short value)
{
    if(m_alarmDownflowLow == value)return;
    m_alarmDownflowLow = value;
    emit alarmDownflowLowChanged(value);
}

void MachineData::setAlarmDownflowHigh(short value)
{
    if(m_alarmDownflowHigh == value)return;
    m_alarmDownflowHigh = value;
    emit alarmDownflowHighChanged(value);
}

bool MachineData::getAdvancedAirflowAlarmEnable() const
{
    return m_advancedAirflowAlarmEnable;
}

short MachineData::getAlarmDownflowLow() const
{
    return m_alarmDownflowLow;
}

short MachineData::getAlarmDownflowHigh() const
{
    return m_alarmDownflowHigh;
}

QString MachineData::getIfaCalGrid(short calibMode, short inflowGridPoint) const
{
    if(calibMode < 0)calibMode = 0;
    else if(calibMode >= MachineEnums::CALIB_MODE_TOTAL) calibMode = MachineEnums::CALIB_MODE_TOTAL-1;
    if(inflowGridPoint < 0)inflowGridPoint = 0;
    else if(inflowGridPoint >= MachineEnums::INFLOW_GRID_TOTAL) inflowGridPoint = MachineEnums::INFLOW_GRID_TOTAL-1;

    return m_ifaCalGrid[calibMode][inflowGridPoint];
}

int MachineData::getIfaCalGridTot(short calibMode, short inflowGridPoint) const
{
    if(calibMode < 0)calibMode = 0;
    else if(calibMode >= MachineEnums::CALIB_MODE_TOTAL) calibMode = MachineEnums::CALIB_MODE_TOTAL-1;
    if(inflowGridPoint < 0)inflowGridPoint = 0;
    else if(inflowGridPoint >= MachineEnums::INFLOW_GRID_TOTAL) inflowGridPoint = MachineEnums::INFLOW_GRID_TOTAL-1;

    return m_ifaCalGridTot[calibMode][inflowGridPoint];
}

int MachineData::getIfaCalGridAvg(short calibMode, short inflowGridPoint) const
{
    if(calibMode < 0)calibMode = 0;
    else if(calibMode >= MachineEnums::CALIB_MODE_TOTAL) calibMode = MachineEnums::CALIB_MODE_TOTAL-1;
    if(inflowGridPoint < 0)inflowGridPoint = 0;
    else if(inflowGridPoint >= MachineEnums::INFLOW_GRID_TOTAL) inflowGridPoint = MachineEnums::INFLOW_GRID_TOTAL-1;

    return m_ifaCalGridAvg[calibMode][inflowGridPoint];
}

int MachineData::getIfaCalGridVol(short calibMode, short inflowGridPoint) const
{
    if(calibMode < 0)calibMode = 0;
    else if(calibMode >= MachineEnums::CALIB_MODE_TOTAL) calibMode = MachineEnums::CALIB_MODE_TOTAL-1;
    if(inflowGridPoint < 0)inflowGridPoint = 0;
    else if(inflowGridPoint >= MachineEnums::INFLOW_GRID_TOTAL) inflowGridPoint = MachineEnums::INFLOW_GRID_TOTAL-1;

    return m_ifaCalGridVol[calibMode][inflowGridPoint];
}

int MachineData::getIfaCalGridVel(short calibMode, short inflowGridPoint) const
{
    if(calibMode < 0)calibMode = 0;
    else if(calibMode >= MachineEnums::CALIB_MODE_TOTAL) calibMode = MachineEnums::CALIB_MODE_TOTAL-1;
    if(inflowGridPoint < 0)inflowGridPoint = 0;
    else if(inflowGridPoint >= MachineEnums::INFLOW_GRID_TOTAL) inflowGridPoint = MachineEnums::INFLOW_GRID_TOTAL-1;

    return m_ifaCalGridVel[calibMode][inflowGridPoint];
}

int MachineData::getIfaCalGridTotImp(short calibMode, short inflowGridPoint) const
{
    if(calibMode < 0)calibMode = 0;
    else if(calibMode >= MachineEnums::CALIB_MODE_TOTAL) calibMode = MachineEnums::CALIB_MODE_TOTAL-1;
    if(inflowGridPoint < 0)inflowGridPoint = 0;
    else if(inflowGridPoint >= MachineEnums::INFLOW_GRID_TOTAL) inflowGridPoint = MachineEnums::INFLOW_GRID_TOTAL-1;

    return m_ifaCalGridTotImp[calibMode][inflowGridPoint];
}

int MachineData::getIfaCalGridAvgImp(short calibMode, short inflowGridPoint) const
{
    if(calibMode < 0)calibMode = 0;
    else if(calibMode >= MachineEnums::CALIB_MODE_TOTAL) calibMode = MachineEnums::CALIB_MODE_TOTAL-1;
    if(inflowGridPoint < 0)inflowGridPoint = 0;
    else if(inflowGridPoint >= MachineEnums::INFLOW_GRID_TOTAL) inflowGridPoint = MachineEnums::INFLOW_GRID_TOTAL-1;

    return m_ifaCalGridAvgImp[calibMode][inflowGridPoint];
}

int MachineData::getIfaCalGridVolImp(short calibMode, short inflowGridPoint) const
{
    if(calibMode < 0)calibMode = 0;
    else if(calibMode >= MachineEnums::CALIB_MODE_TOTAL) calibMode = MachineEnums::CALIB_MODE_TOTAL-1;
    if(inflowGridPoint < 0)inflowGridPoint = 0;
    else if(inflowGridPoint >= MachineEnums::INFLOW_GRID_TOTAL) inflowGridPoint = MachineEnums::INFLOW_GRID_TOTAL-1;

    return m_ifaCalGridVolImp[calibMode][inflowGridPoint];
}

int MachineData::getIfaCalGridVelImp(short calibMode, short inflowGridPoint) const
{
    if(calibMode < 0)calibMode = 0;
    else if(calibMode >= MachineEnums::CALIB_MODE_TOTAL) calibMode = MachineEnums::CALIB_MODE_TOTAL-1;
    if(inflowGridPoint < 0)inflowGridPoint = 0;
    else if(inflowGridPoint >= MachineEnums::INFLOW_GRID_TOTAL) inflowGridPoint = MachineEnums::INFLOW_GRID_TOTAL-1;

    return m_ifaCalGridVelImp[calibMode][inflowGridPoint];
}

int MachineData::getIfaCalGridDcy(short calibMode, short inflowGridPoint) const
{
    if(calibMode < 0)calibMode = 0;
    else if(calibMode >= MachineEnums::CALIB_MODE_TOTAL) calibMode = MachineEnums::CALIB_MODE_TOTAL-1;
    if(inflowGridPoint < 0)inflowGridPoint = 0;
    else if(inflowGridPoint >= MachineEnums::INFLOW_GRID_TOTAL) inflowGridPoint = MachineEnums::INFLOW_GRID_TOTAL-1;

    return m_ifaCalGridDcy[calibMode][inflowGridPoint];
}

int MachineData::getIfaCalGridRpm(short calibMode, short inflowGridPoint) const
{
    if(calibMode < 0)calibMode = 0;
    else if(calibMode >= MachineEnums::CALIB_MODE_TOTAL) calibMode = MachineEnums::CALIB_MODE_TOTAL-1;
    if(inflowGridPoint < 0)inflowGridPoint = 0;
    else if(inflowGridPoint >= MachineEnums::INFLOW_GRID_TOTAL) inflowGridPoint = MachineEnums::INFLOW_GRID_TOTAL-1;

    return m_ifaCalGridRpm[calibMode][inflowGridPoint];
}

QString MachineData::getIfaCalGridSec(short calibMode, short inflowGridPoint) const
{
    if(calibMode < 0)calibMode = 0;
    else if(calibMode >= MachineEnums::CALIB_MODE_TOTAL) calibMode = MachineEnums::CALIB_MODE_TOTAL-1;
    if(inflowGridPoint < 0)inflowGridPoint = 0;
    else if(inflowGridPoint >= MachineEnums::INFLOW_GRID_TOTAL) inflowGridPoint = MachineEnums::INFLOW_GRID_TOTAL-1;

    return m_ifaCalGridSec[calibMode][inflowGridPoint];
}

int MachineData::getIfaCalGridTotSec(short calibMode, short inflowGridPoint) const
{
    if(calibMode < 0)calibMode = 0;
    else if(calibMode >= MachineEnums::CALIB_MODE_TOTAL) calibMode = MachineEnums::CALIB_MODE_TOTAL-1;
    if(inflowGridPoint < 0)inflowGridPoint = 0;
    else if(inflowGridPoint >= MachineEnums::INFLOW_GRID_TOTAL) inflowGridPoint = MachineEnums::INFLOW_GRID_TOTAL-1;

    return m_ifaCalGridTotSec[calibMode][inflowGridPoint];
}

int MachineData::getIfaCalGridAvgSec(short calibMode, short inflowGridPoint) const
{
    if(calibMode < 0)calibMode = 0;
    else if(calibMode >= MachineEnums::CALIB_MODE_TOTAL) calibMode = MachineEnums::CALIB_MODE_TOTAL-1;
    if(inflowGridPoint < 0)inflowGridPoint = 0;
    else if(inflowGridPoint >= MachineEnums::INFLOW_GRID_TOTAL) inflowGridPoint = MachineEnums::INFLOW_GRID_TOTAL-1;

    return m_ifaCalGridAvgSec[calibMode][inflowGridPoint];
}

int MachineData::getIfaCalGridVelSec(short calibMode, short inflowGridPoint) const
{
    if(calibMode < 0)calibMode = 0;
    else if(calibMode >= MachineEnums::CALIB_MODE_TOTAL) calibMode = MachineEnums::CALIB_MODE_TOTAL-1;
    if(inflowGridPoint < 0)inflowGridPoint = 0;
    else if(inflowGridPoint >= MachineEnums::INFLOW_GRID_TOTAL) inflowGridPoint = MachineEnums::INFLOW_GRID_TOTAL-1;

    return m_ifaCalGridVelSec[calibMode][inflowGridPoint];
}

int MachineData::getIfaCalGridTotSecImp(short calibMode, short inflowGridPoint) const
{
    if(calibMode < 0)calibMode = 0;
    else if(calibMode >= MachineEnums::CALIB_MODE_TOTAL) calibMode = MachineEnums::CALIB_MODE_TOTAL-1;
    if(inflowGridPoint < 0)inflowGridPoint = 0;
    else if(inflowGridPoint >= MachineEnums::INFLOW_GRID_TOTAL) inflowGridPoint = MachineEnums::INFLOW_GRID_TOTAL-1;

    return m_ifaCalGridTotSecImp[calibMode][inflowGridPoint];
}

int MachineData::getIfaCalGridAvgSecImp(short calibMode, short inflowGridPoint) const
{
    if(calibMode < 0)calibMode = 0;
    else if(calibMode >= MachineEnums::CALIB_MODE_TOTAL) calibMode = MachineEnums::CALIB_MODE_TOTAL-1;
    if(inflowGridPoint < 0)inflowGridPoint = 0;
    else if(inflowGridPoint >= MachineEnums::INFLOW_GRID_TOTAL) inflowGridPoint = MachineEnums::INFLOW_GRID_TOTAL-1;

    return m_ifaCalGridAvgSecImp[calibMode][inflowGridPoint];
}

int MachineData::getIfaCalGridVelSecImp(short calibMode, short inflowGridPoint) const
{
    if(calibMode < 0)calibMode = 0;
    else if(calibMode >= MachineEnums::CALIB_MODE_TOTAL) calibMode = MachineEnums::CALIB_MODE_TOTAL-1;
    if(inflowGridPoint < 0)inflowGridPoint = 0;
    else if(inflowGridPoint >= MachineEnums::INFLOW_GRID_TOTAL) inflowGridPoint = MachineEnums::INFLOW_GRID_TOTAL-1;

    return m_ifaCalGridVelSecImp[calibMode][inflowGridPoint];
}

int MachineData::getIfaCalGridDcySec(short calibMode, short inflowGridPoint) const
{
    if(calibMode < 0)calibMode = 0;
    else if(calibMode >= MachineEnums::CALIB_MODE_TOTAL) calibMode = MachineEnums::CALIB_MODE_TOTAL-1;
    if(inflowGridPoint < 0)inflowGridPoint = 0;
    else if(inflowGridPoint >= MachineEnums::INFLOW_GRID_TOTAL) inflowGridPoint = MachineEnums::INFLOW_GRID_TOTAL-1;

    return m_ifaCalGridDcySec[calibMode][inflowGridPoint];
}

int MachineData::getIfaCalGridRpmSec(short calibMode, short inflowGridPoint) const
{
    if(calibMode < 0)calibMode = 0;
    else if(calibMode >= MachineEnums::CALIB_MODE_TOTAL) calibMode = MachineEnums::CALIB_MODE_TOTAL-1;
    if(inflowGridPoint < 0)inflowGridPoint = 0;
    else if(inflowGridPoint >= MachineEnums::INFLOW_GRID_TOTAL) inflowGridPoint = MachineEnums::INFLOW_GRID_TOTAL-1;

    return m_ifaCalGridRpmSec[calibMode][inflowGridPoint];
}

QString MachineData::getDfaCalGrid(short calibMode, short downflowGridPoint) const
{
    if(calibMode < 0)calibMode = 0;
    else if(calibMode >= MachineEnums::CALIB_MODE_TOTAL) calibMode = MachineEnums::CALIB_MODE_TOTAL-1;
    if(downflowGridPoint < 0)downflowGridPoint = 0;
    else if(downflowGridPoint >= MachineEnums::DOWNFLOW_GRID_TOTAL) calibMode = MachineEnums::DOWNFLOW_GRID_TOTAL-1;
    return m_dfaCalGrid[calibMode][downflowGridPoint];
}

int MachineData::getDfaCalGridVel(short calibMode, short downflowGridPoint) const
{
    if(calibMode < 0)calibMode = 0;
    else if(calibMode >= MachineEnums::CALIB_MODE_TOTAL) calibMode = (MachineEnums::CALIB_MODE_TOTAL-1);
    if(downflowGridPoint < 0)downflowGridPoint = 0;
    else if(downflowGridPoint >= MachineEnums::DOWNFLOW_GRID_TOTAL) downflowGridPoint = (MachineEnums::DOWNFLOW_GRID_TOTAL-1);
    return m_dfaCalGridVel[calibMode][downflowGridPoint];
}

int MachineData::getDfaCalGridVelTot(short calibMode, short downflowGridPoint) const
{
    if(calibMode < 0)calibMode = 0;
    else if(calibMode >= MachineEnums::CALIB_MODE_TOTAL) calibMode = (MachineEnums::CALIB_MODE_TOTAL-1);
    if(downflowGridPoint < 0)downflowGridPoint = 0;
    else if(downflowGridPoint >= MachineEnums::DOWNFLOW_GRID_TOTAL) downflowGridPoint = (MachineEnums::DOWNFLOW_GRID_TOTAL-1);

    return m_dfaCalGridVelTot[calibMode][downflowGridPoint];
}

int MachineData::getDfaCalGridVelDev(short calibMode, short downflowGridPoint) const
{
    if(calibMode < 0)calibMode = 0;
    else if(calibMode >= MachineEnums::CALIB_MODE_TOTAL) calibMode = MachineEnums::CALIB_MODE_TOTAL-1;
    if(downflowGridPoint < 0)downflowGridPoint = 0;
    else if(downflowGridPoint >= MachineEnums::DOWNFLOW_GRID_TOTAL) downflowGridPoint = MachineEnums::DOWNFLOW_GRID_TOTAL-1;
    return m_dfaCalGridVelDev[calibMode][downflowGridPoint];
}

int MachineData::getDfaCalGridVelDevp(short calibMode, short downflowGridPoint) const
{
    if(calibMode < 0)calibMode = 0;
    else if(calibMode >= MachineEnums::CALIB_MODE_TOTAL) calibMode = MachineEnums::CALIB_MODE_TOTAL-1;
    if(downflowGridPoint < 0)downflowGridPoint = 0;
    else if(downflowGridPoint >= MachineEnums::DOWNFLOW_GRID_TOTAL) downflowGridPoint = MachineEnums::DOWNFLOW_GRID_TOTAL-1;
    return m_dfaCalGridVelDevp[calibMode][downflowGridPoint];
}

int MachineData::getDfaCalGridVelHigh(short calibMode, short downflowGridPoint) const
{
    if(calibMode < 0)calibMode = 0;
    else if(calibMode >= MachineEnums::CALIB_MODE_TOTAL) calibMode = MachineEnums::CALIB_MODE_TOTAL-1;
    if(downflowGridPoint < 0)downflowGridPoint = 0;
    else if(downflowGridPoint >= MachineEnums::DOWNFLOW_GRID_TOTAL) downflowGridPoint = MachineEnums::DOWNFLOW_GRID_TOTAL-1;
    return m_dfaCalGridVelHigh[calibMode][downflowGridPoint];
}

int MachineData::getDfaCalGridVelLow(short calibMode, short downflowGridPoint) const
{
    if(calibMode < 0)calibMode = 0;
    else if(calibMode >= MachineEnums::CALIB_MODE_TOTAL) calibMode = MachineEnums::CALIB_MODE_TOTAL-1;
    if(downflowGridPoint < 0)downflowGridPoint = 0;
    else if(downflowGridPoint >= MachineEnums::DOWNFLOW_GRID_TOTAL) downflowGridPoint = MachineEnums::DOWNFLOW_GRID_TOTAL-1;
    return m_dfaCalGridVelLow[calibMode][downflowGridPoint];
}

int MachineData::getDfaCalGridVelImp(short calibMode, short downflowGridPoint) const
{
    if(calibMode < 0)calibMode = 0;
    else if(calibMode >= MachineEnums::CALIB_MODE_TOTAL) calibMode = MachineEnums::CALIB_MODE_TOTAL-1;
    if(downflowGridPoint < 0)downflowGridPoint = 0;
    else if(downflowGridPoint >= MachineEnums::DOWNFLOW_GRID_TOTAL) downflowGridPoint = MachineEnums::DOWNFLOW_GRID_TOTAL-1;
    return m_dfaCalGridVelImp[calibMode][downflowGridPoint];
}

int MachineData::getDfaCalGridVelTotImp(short calibMode, short downflowGridPoint) const
{
    if(calibMode < 0)calibMode = 0;
    else if(calibMode >= MachineEnums::CALIB_MODE_TOTAL) calibMode = MachineEnums::CALIB_MODE_TOTAL-1;
    if(downflowGridPoint < 0)downflowGridPoint = 0;
    else if(downflowGridPoint >= MachineEnums::DOWNFLOW_GRID_TOTAL) downflowGridPoint = MachineEnums::DOWNFLOW_GRID_TOTAL-1;

    return m_dfaCalGridVelTotImp[calibMode][downflowGridPoint];
}

int MachineData::getDfaCalGridVelDevImp(short calibMode, short downflowGridPoint) const
{
    if(calibMode < 0)calibMode = 0;
    else if(calibMode >= MachineEnums::CALIB_MODE_TOTAL) calibMode = MachineEnums::CALIB_MODE_TOTAL-1;
    if(downflowGridPoint < 0)downflowGridPoint = 0;
    else if(downflowGridPoint >= MachineEnums::DOWNFLOW_GRID_TOTAL) downflowGridPoint = MachineEnums::DOWNFLOW_GRID_TOTAL-1;
    return m_dfaCalGridVelDevImp[calibMode][downflowGridPoint];
}

int MachineData::getDfaCalGridVelDevpImp(short calibMode, short downflowGridPoint) const
{
    if(calibMode < 0)calibMode = 0;
    else if(calibMode >= MachineEnums::CALIB_MODE_TOTAL) calibMode = MachineEnums::CALIB_MODE_TOTAL-1;
    if(downflowGridPoint < 0)downflowGridPoint = 0;
    else if(downflowGridPoint >= MachineEnums::DOWNFLOW_GRID_TOTAL) downflowGridPoint = MachineEnums::DOWNFLOW_GRID_TOTAL-1;
    return m_dfaCalGridVelDevpImp[calibMode][downflowGridPoint];
}

int MachineData::getDfaCalGridVelHighImp(short calibMode, short downflowGridPoint) const
{
    if(calibMode < 0)calibMode = 0;
    else if(calibMode >= MachineEnums::CALIB_MODE_TOTAL) calibMode = MachineEnums::CALIB_MODE_TOTAL-1;
    if(downflowGridPoint < 0)downflowGridPoint = 0;
    else if(downflowGridPoint >= MachineEnums::DOWNFLOW_GRID_TOTAL) downflowGridPoint = MachineEnums::DOWNFLOW_GRID_TOTAL-1;
    return m_dfaCalGridVelHighImp[calibMode][downflowGridPoint];
}

int MachineData::getDfaCalGridVelLowImp(short calibMode, short downflowGridPoint) const
{
    if(calibMode < 0)calibMode = 0;
    else if(calibMode >= MachineEnums::CALIB_MODE_TOTAL) calibMode = MachineEnums::CALIB_MODE_TOTAL-1;
    if(downflowGridPoint < 0)downflowGridPoint = 0;
    else if(downflowGridPoint >= MachineEnums::DOWNFLOW_GRID_TOTAL) downflowGridPoint = MachineEnums::DOWNFLOW_GRID_TOTAL-1;
    return m_dfaCalGridVelLowImp[calibMode][downflowGridPoint];
}

void MachineData::setIfaCalGrid(short calibMode, short inflowGridPoint, const QString &value)
{
    if(calibMode < 0)calibMode = 0;
    else if(calibMode >= MachineEnums::CALIB_MODE_TOTAL) calibMode = MachineEnums::CALIB_MODE_TOTAL-1;
    if(inflowGridPoint < 0)inflowGridPoint = 0;
    else if(inflowGridPoint >= MachineEnums::INFLOW_GRID_TOTAL) inflowGridPoint = MachineEnums::INFLOW_GRID_TOTAL-1;
    if(m_ifaCalGrid[calibMode][inflowGridPoint] == value)return;
    m_ifaCalGrid[calibMode][inflowGridPoint] = value;
}

void MachineData::setIfaCalGridTot(short calibMode, short inflowGridPoint, int value)
{
    if(calibMode < 0)calibMode = 0;
    else if(calibMode >= MachineEnums::CALIB_MODE_TOTAL) calibMode = MachineEnums::CALIB_MODE_TOTAL-1;
    if(inflowGridPoint < 0)inflowGridPoint = 0;
    else if(inflowGridPoint >= MachineEnums::INFLOW_GRID_TOTAL) inflowGridPoint = MachineEnums::INFLOW_GRID_TOTAL-1;
    if(m_ifaCalGridTot[calibMode][inflowGridPoint] == value)return;
    m_ifaCalGridTot[calibMode][inflowGridPoint] = value;
}

void MachineData::setIfaCalGridAvg(short calibMode, short inflowGridPoint, int value)
{
    if(calibMode < 0)calibMode = 0;
    else if(calibMode >= MachineEnums::CALIB_MODE_TOTAL) calibMode = MachineEnums::CALIB_MODE_TOTAL-1;
    if(inflowGridPoint < 0)inflowGridPoint = 0;
    else if(inflowGridPoint >= MachineEnums::INFLOW_GRID_TOTAL) inflowGridPoint = MachineEnums::INFLOW_GRID_TOTAL-1;
    if(m_ifaCalGridAvg[calibMode][inflowGridPoint] == value)return;
    m_ifaCalGridAvg[calibMode][inflowGridPoint] = value;
}

void MachineData::setIfaCalGridVol(short calibMode, short inflowGridPoint, int value)
{
    if(calibMode < 0)calibMode = 0;
    else if(calibMode >= MachineEnums::CALIB_MODE_TOTAL) calibMode = MachineEnums::CALIB_MODE_TOTAL-1;
    if(inflowGridPoint < 0)inflowGridPoint = 0;
    else if(inflowGridPoint >= MachineEnums::INFLOW_GRID_TOTAL) inflowGridPoint = MachineEnums::INFLOW_GRID_TOTAL-1;
    if(m_ifaCalGridVol[calibMode][inflowGridPoint] == value)return;
    m_ifaCalGridVol[calibMode][inflowGridPoint] = value;
}

void MachineData::setIfaCalGridVel(short calibMode, short inflowGridPoint, int value)
{
    if(calibMode < 0)calibMode = 0;
    else if(calibMode >= MachineEnums::CALIB_MODE_TOTAL) calibMode = MachineEnums::CALIB_MODE_TOTAL-1;
    if(inflowGridPoint < 0)inflowGridPoint = 0;
    else if(inflowGridPoint >= MachineEnums::INFLOW_GRID_TOTAL) inflowGridPoint = MachineEnums::INFLOW_GRID_TOTAL-1;
    if(m_ifaCalGridVel[calibMode][inflowGridPoint] == value)return;
    m_ifaCalGridVel[calibMode][inflowGridPoint] = value;
}

void MachineData::setIfaCalGridTotImp(short calibMode, short inflowGridPoint, int value)
{
    if(calibMode < 0)calibMode = 0;
    else if(calibMode >= MachineEnums::CALIB_MODE_TOTAL) calibMode = MachineEnums::CALIB_MODE_TOTAL-1;
    if(inflowGridPoint < 0)inflowGridPoint = 0;
    else if(inflowGridPoint >= MachineEnums::INFLOW_GRID_TOTAL) inflowGridPoint = MachineEnums::INFLOW_GRID_TOTAL-1;
    if(m_ifaCalGridTotImp[calibMode][inflowGridPoint] == value)return;
    m_ifaCalGridTotImp[calibMode][inflowGridPoint] = value;
}

void MachineData::setIfaCalGridAvgImp(short calibMode, short inflowGridPoint, int value)
{
    if(calibMode < 0)calibMode = 0;
    else if(calibMode >= MachineEnums::CALIB_MODE_TOTAL) calibMode = MachineEnums::CALIB_MODE_TOTAL-1;
    if(inflowGridPoint < 0)inflowGridPoint = 0;
    else if(inflowGridPoint >= MachineEnums::INFLOW_GRID_TOTAL) inflowGridPoint = MachineEnums::INFLOW_GRID_TOTAL-1;
    if(m_ifaCalGridAvgImp[calibMode][inflowGridPoint] == value)return;
    m_ifaCalGridAvgImp[calibMode][inflowGridPoint] = value;
}

void MachineData::setIfaCalGridVolImp(short calibMode, short inflowGridPoint, int value)
{
    if(calibMode < 0)calibMode = 0;
    else if(calibMode >= MachineEnums::CALIB_MODE_TOTAL) calibMode = MachineEnums::CALIB_MODE_TOTAL-1;
    if(inflowGridPoint < 0)inflowGridPoint = 0;
    else if(inflowGridPoint >= MachineEnums::INFLOW_GRID_TOTAL) inflowGridPoint = MachineEnums::INFLOW_GRID_TOTAL-1;
    if(m_ifaCalGridVolImp[calibMode][inflowGridPoint] == value)return;
    m_ifaCalGridVolImp[calibMode][inflowGridPoint] = value;
}

void MachineData::setIfaCalGridVelImp(short calibMode, short inflowGridPoint, int value)
{
    if(calibMode < 0)calibMode = 0;
    else if(calibMode >= MachineEnums::CALIB_MODE_TOTAL) calibMode = MachineEnums::CALIB_MODE_TOTAL-1;
    if(inflowGridPoint < 0)inflowGridPoint = 0;
    else if(inflowGridPoint >= MachineEnums::INFLOW_GRID_TOTAL) inflowGridPoint = MachineEnums::INFLOW_GRID_TOTAL-1;
    if(m_ifaCalGridVelImp[calibMode][inflowGridPoint] == value)return;
    m_ifaCalGridVelImp[calibMode][inflowGridPoint] = value;
}

void MachineData::setIfaCalGridDcy(short calibMode, short inflowGridPoint, int value)
{
    if(calibMode < 0)calibMode = 0;
    else if(calibMode >= MachineEnums::CALIB_MODE_TOTAL) calibMode = MachineEnums::CALIB_MODE_TOTAL-1;
    if(inflowGridPoint < 0)inflowGridPoint = 0;
    else if(inflowGridPoint >= MachineEnums::INFLOW_GRID_TOTAL) inflowGridPoint = MachineEnums::INFLOW_GRID_TOTAL-1;
    if(m_ifaCalGridDcy[calibMode][inflowGridPoint] == value)return;
    m_ifaCalGridDcy[calibMode][inflowGridPoint] = value;
}

void MachineData::setIfaCalGridRpm(short calibMode, short inflowGridPoint, int value)
{
    if(calibMode < 0)calibMode = 0;
    else if(calibMode >= MachineEnums::CALIB_MODE_TOTAL) calibMode = MachineEnums::CALIB_MODE_TOTAL-1;
    if(inflowGridPoint < 0)inflowGridPoint = 0;
    else if(inflowGridPoint >= MachineEnums::INFLOW_GRID_TOTAL) inflowGridPoint = MachineEnums::INFLOW_GRID_TOTAL-1;
    if(m_ifaCalGridRpm[calibMode][inflowGridPoint] == value)return;
    m_ifaCalGridRpm[calibMode][inflowGridPoint] = value;
}

void MachineData::setIfaCalGridSec(short calibMode, short inflowGridPoint, const QString &value)
{
    if(calibMode < 0)calibMode = 0;
    else if(calibMode >= MachineEnums::CALIB_MODE_TOTAL) calibMode = MachineEnums::CALIB_MODE_TOTAL-1;
    if(inflowGridPoint < 0)inflowGridPoint = 0;
    else if(inflowGridPoint >= MachineEnums::INFLOW_GRID_TOTAL) inflowGridPoint = MachineEnums::INFLOW_GRID_TOTAL-1;
    if(m_ifaCalGridSec[calibMode][inflowGridPoint] == value)return;
    m_ifaCalGridSec[calibMode][inflowGridPoint] = value;
}

void MachineData::setIfaCalGridTotSec(short calibMode, short inflowGridPoint, int value)
{
    if(calibMode < 0)calibMode = 0;
    else if(calibMode >= MachineEnums::CALIB_MODE_TOTAL) calibMode = MachineEnums::CALIB_MODE_TOTAL-1;
    if(inflowGridPoint < 0)inflowGridPoint = 0;
    else if(inflowGridPoint >= MachineEnums::INFLOW_GRID_TOTAL) inflowGridPoint = MachineEnums::INFLOW_GRID_TOTAL-1;
    if(m_ifaCalGridTotSec[calibMode][inflowGridPoint] == value)return;
    m_ifaCalGridTotSec[calibMode][inflowGridPoint] = value;
}

void MachineData::setIfaCalGridAvgSec(short calibMode, short inflowGridPoint, int value)
{
    if(calibMode < 0)calibMode = 0;
    else if(calibMode >= MachineEnums::CALIB_MODE_TOTAL) calibMode = MachineEnums::CALIB_MODE_TOTAL-1;
    if(inflowGridPoint < 0)inflowGridPoint = 0;
    else if(inflowGridPoint >= MachineEnums::INFLOW_GRID_TOTAL) inflowGridPoint = MachineEnums::INFLOW_GRID_TOTAL-1;
    if(m_ifaCalGridAvgSec[calibMode][inflowGridPoint] == value)return;
    m_ifaCalGridAvgSec[calibMode][inflowGridPoint] = value;
}

void MachineData::setIfaCalGridVelSec(short calibMode, short inflowGridPoint, int value)
{
    if(calibMode < 0)calibMode = 0;
    else if(calibMode >= MachineEnums::CALIB_MODE_TOTAL) calibMode = MachineEnums::CALIB_MODE_TOTAL-1;
    if(inflowGridPoint < 0)inflowGridPoint = 0;
    else if(inflowGridPoint >= MachineEnums::INFLOW_GRID_TOTAL) inflowGridPoint = MachineEnums::INFLOW_GRID_TOTAL-1;
    if(m_ifaCalGridVelSec[calibMode][inflowGridPoint] == value)return;
    m_ifaCalGridVelSec[calibMode][inflowGridPoint] = value;
}

void MachineData::setIfaCalGridTotSecImp(short calibMode, short inflowGridPoint, int value)
{
    if(calibMode < 0)calibMode = 0;
    else if(calibMode >= MachineEnums::CALIB_MODE_TOTAL) calibMode = MachineEnums::CALIB_MODE_TOTAL-1;
    if(inflowGridPoint < 0)inflowGridPoint = 0;
    else if(inflowGridPoint >= MachineEnums::INFLOW_GRID_TOTAL) inflowGridPoint = MachineEnums::INFLOW_GRID_TOTAL-1;
    if(m_ifaCalGridTotSecImp[calibMode][inflowGridPoint] == value)return;
    m_ifaCalGridTotSecImp[calibMode][inflowGridPoint] = value;
}

void MachineData::setIfaCalGridAvgSecImp(short calibMode, short inflowGridPoint, int value)
{
    if(calibMode < 0)calibMode = 0;
    else if(calibMode >= MachineEnums::CALIB_MODE_TOTAL) calibMode = MachineEnums::CALIB_MODE_TOTAL-1;
    if(inflowGridPoint < 0)inflowGridPoint = 0;
    else if(inflowGridPoint >= MachineEnums::INFLOW_GRID_TOTAL) inflowGridPoint = MachineEnums::INFLOW_GRID_TOTAL-1;
    if(m_ifaCalGridAvgSecImp[calibMode][inflowGridPoint] == value)return;
    m_ifaCalGridAvgSecImp[calibMode][inflowGridPoint] = value;
}

void MachineData::setIfaCalGridVelSecImp(short calibMode, short inflowGridPoint, int value)
{
    if(calibMode < 0)calibMode = 0;
    else if(calibMode >= MachineEnums::CALIB_MODE_TOTAL) calibMode = MachineEnums::CALIB_MODE_TOTAL-1;
    if(inflowGridPoint < 0)inflowGridPoint = 0;
    else if(inflowGridPoint >= MachineEnums::INFLOW_GRID_TOTAL) inflowGridPoint = MachineEnums::INFLOW_GRID_TOTAL-1;
    if(m_ifaCalGridVelSecImp[calibMode][inflowGridPoint] == value)return;
    m_ifaCalGridVelSecImp[calibMode][inflowGridPoint] = value;
}

void MachineData::setIfaCalGridDcySec(short calibMode, short inflowGridPoint, int value)
{
    if(calibMode < 0)calibMode = 0;
    else if(calibMode >= MachineEnums::CALIB_MODE_TOTAL) calibMode = MachineEnums::CALIB_MODE_TOTAL-1;
    if(inflowGridPoint < 0)inflowGridPoint = 0;
    else if(inflowGridPoint >= MachineEnums::INFLOW_GRID_TOTAL) inflowGridPoint = MachineEnums::INFLOW_GRID_TOTAL-1;
    if(m_ifaCalGridDcySec[calibMode][inflowGridPoint] == value)return;
    m_ifaCalGridDcySec[calibMode][inflowGridPoint] = value;
}

void MachineData::setIfaCalGridRpmSec(short calibMode, short inflowGridPoint, int value)
{
    if(calibMode < 0)calibMode = 0;
    else if(calibMode >= MachineEnums::CALIB_MODE_TOTAL) calibMode = MachineEnums::CALIB_MODE_TOTAL-1;
    if(inflowGridPoint < 0)inflowGridPoint = 0;
    else if(inflowGridPoint >= MachineEnums::INFLOW_GRID_TOTAL) inflowGridPoint = MachineEnums::INFLOW_GRID_TOTAL-1;
    if(m_ifaCalGridRpmSec[calibMode][inflowGridPoint] == value)return;
    m_ifaCalGridRpmSec[calibMode][inflowGridPoint] = value;
}

void MachineData::setDfaCalGrid(short calibMode, short downflowGridPoint, const QString &value)
{
    if(calibMode < 0)calibMode = 0;
    else if(calibMode >= MachineEnums::CALIB_MODE_TOTAL) calibMode = MachineEnums::CALIB_MODE_TOTAL-1;
    if(downflowGridPoint < 0)downflowGridPoint = 0;
    else if(downflowGridPoint >= MachineEnums::DOWNFLOW_GRID_TOTAL) downflowGridPoint = MachineEnums::DOWNFLOW_GRID_TOTAL-1;
    if(m_dfaCalGrid[calibMode][downflowGridPoint] == value)return;
    m_dfaCalGrid[calibMode][downflowGridPoint] = value;
}

void MachineData::setDfaCalGridVel(short calibMode, short downflowGridPoint, int value)
{
    if(calibMode < 0)calibMode = 0;
    else if(calibMode >= MachineEnums::CALIB_MODE_TOTAL) calibMode = MachineEnums::CALIB_MODE_TOTAL-1;
    if(downflowGridPoint < 0)downflowGridPoint = 0;
    else if(downflowGridPoint >= MachineEnums::DOWNFLOW_GRID_TOTAL) downflowGridPoint = MachineEnums::DOWNFLOW_GRID_TOTAL-1;

    if(m_dfaCalGridVel[calibMode][downflowGridPoint] == value)return;
    m_dfaCalGridVel[calibMode][downflowGridPoint] = value;
}

void MachineData::setDfaCalGridVelTot(short calibMode, short downflowGridPoint, int value)
{
    if(calibMode < 0)calibMode = 0;
    else if(calibMode >= MachineEnums::CALIB_MODE_TOTAL) calibMode = MachineEnums::CALIB_MODE_TOTAL-1;
    if(downflowGridPoint < 0)downflowGridPoint = 0;
    else if(downflowGridPoint >= MachineEnums::DOWNFLOW_GRID_TOTAL) downflowGridPoint = MachineEnums::DOWNFLOW_GRID_TOTAL-1;

    if(m_dfaCalGridVelTot[calibMode][downflowGridPoint] == value)return;
    m_dfaCalGridVelTot[calibMode][downflowGridPoint] = value;
}

void MachineData::setDfaCalGridVelDev(short calibMode, short downflowGridPoint, int value)
{
    if(calibMode < 0)calibMode = 0;
    else if(calibMode >= MachineEnums::CALIB_MODE_TOTAL) calibMode = MachineEnums::CALIB_MODE_TOTAL-1;
    if(downflowGridPoint < 0)downflowGridPoint = 0;
    else if(downflowGridPoint >= MachineEnums::DOWNFLOW_GRID_TOTAL) downflowGridPoint = MachineEnums::DOWNFLOW_GRID_TOTAL-1;
    if(m_dfaCalGridVelDev[calibMode][downflowGridPoint] == value)return;
    m_dfaCalGridVelDev[calibMode][downflowGridPoint] = value;
}

void MachineData::setDfaCalGridVelDevp(short calibMode, short downflowGridPoint, int value)
{
    if(calibMode < 0)calibMode = 0;
    else if(calibMode >= MachineEnums::CALIB_MODE_TOTAL) calibMode = MachineEnums::CALIB_MODE_TOTAL-1;
    if(downflowGridPoint < 0)downflowGridPoint = 0;
    else if(downflowGridPoint >= MachineEnums::DOWNFLOW_GRID_TOTAL) downflowGridPoint = MachineEnums::DOWNFLOW_GRID_TOTAL-1;
    if(m_dfaCalGridVelDevp[calibMode][downflowGridPoint] == value)return;
    m_dfaCalGridVelDevp[calibMode][downflowGridPoint] = value;
}

void MachineData::setDfaCalGridVelHigh(short calibMode, short downflowGridPoint, int value)
{
    if(calibMode < 0)calibMode = 0;
    else if(calibMode >= MachineEnums::CALIB_MODE_TOTAL) calibMode = MachineEnums::CALIB_MODE_TOTAL-1;
    if(downflowGridPoint < 0)downflowGridPoint = 0;
    else if(downflowGridPoint >= MachineEnums::DOWNFLOW_GRID_TOTAL) downflowGridPoint = MachineEnums::DOWNFLOW_GRID_TOTAL-1;
    if(m_dfaCalGridVelHigh[calibMode][downflowGridPoint] == value)return;
    m_dfaCalGridVelHigh[calibMode][downflowGridPoint] = value;
}

void MachineData::setDfaCalGridVelLow(short calibMode, short downflowGridPoint, int value)
{
    if(calibMode < 0)calibMode = 0;
    else if(calibMode >= MachineEnums::CALIB_MODE_TOTAL) calibMode = MachineEnums::CALIB_MODE_TOTAL-1;
    if(downflowGridPoint < 0)downflowGridPoint = 0;
    else if(downflowGridPoint >= MachineEnums::DOWNFLOW_GRID_TOTAL) downflowGridPoint = MachineEnums::DOWNFLOW_GRID_TOTAL-1;
    if(m_dfaCalGridVelLow[calibMode][downflowGridPoint] == value)return;
    m_dfaCalGridVelLow[calibMode][downflowGridPoint] = value;
}

void MachineData::setDfaCalGridVelImp(short calibMode, short downflowGridPoint, int value)
{
    if(calibMode < 0)calibMode = 0;
    else if(calibMode >= MachineEnums::CALIB_MODE_TOTAL) calibMode = MachineEnums::CALIB_MODE_TOTAL-1;
    if(downflowGridPoint < 0)downflowGridPoint = 0;
    else if(downflowGridPoint >= MachineEnums::DOWNFLOW_GRID_TOTAL) downflowGridPoint = MachineEnums::DOWNFLOW_GRID_TOTAL-1;
    if(m_dfaCalGridVelImp[calibMode][downflowGridPoint] == value)return;
    m_dfaCalGridVelImp[calibMode][downflowGridPoint] = value;
}

void MachineData::setDfaCalGridVelTotImp(short calibMode, short downflowGridPoint, int value)
{
    if(calibMode < 0)calibMode = 0;
    else if(calibMode >= MachineEnums::CALIB_MODE_TOTAL) calibMode = MachineEnums::CALIB_MODE_TOTAL-1;
    if(downflowGridPoint < 0)downflowGridPoint = 0;
    else if(downflowGridPoint >= MachineEnums::DOWNFLOW_GRID_TOTAL) downflowGridPoint = MachineEnums::DOWNFLOW_GRID_TOTAL-1;

    if(m_dfaCalGridVelTotImp[calibMode][downflowGridPoint] == value)return;
    m_dfaCalGridVelTotImp[calibMode][downflowGridPoint] = value;
}

void MachineData::setDfaCalGridVelDevImp(short calibMode, short downflowGridPoint, int value)
{
    if(calibMode < 0)calibMode = 0;
    else if(calibMode >= MachineEnums::CALIB_MODE_TOTAL) calibMode = MachineEnums::CALIB_MODE_TOTAL-1;
    if(downflowGridPoint < 0)downflowGridPoint = 0;
    else if(downflowGridPoint >= MachineEnums::DOWNFLOW_GRID_TOTAL) downflowGridPoint = MachineEnums::DOWNFLOW_GRID_TOTAL-1;
    if(m_dfaCalGridVelDevImp[calibMode][downflowGridPoint] == value)return;
    m_dfaCalGridVelDevImp[calibMode][downflowGridPoint] = value;
}

void MachineData::setDfaCalGridVelDevpImp(short calibMode, short downflowGridPoint, int value)
{
    if(calibMode < 0)calibMode = 0;
    else if(calibMode >= MachineEnums::CALIB_MODE_TOTAL) calibMode = MachineEnums::CALIB_MODE_TOTAL-1;
    if(downflowGridPoint < 0)downflowGridPoint = 0;
    else if(downflowGridPoint >= MachineEnums::DOWNFLOW_GRID_TOTAL) downflowGridPoint = MachineEnums::DOWNFLOW_GRID_TOTAL-1;
    if(m_dfaCalGridVelDevpImp[calibMode][downflowGridPoint] == value)return;
    m_dfaCalGridVelDevpImp[calibMode][downflowGridPoint] = value;
}

void MachineData::setDfaCalGridVelHighImp(short calibMode, short downflowGridPoint, int value)
{
    if(calibMode < 0)calibMode = 0;
    else if(calibMode >= MachineEnums::CALIB_MODE_TOTAL) calibMode = MachineEnums::CALIB_MODE_TOTAL-1;
    if(downflowGridPoint < 0)downflowGridPoint = 0;
    else if(downflowGridPoint >= MachineEnums::DOWNFLOW_GRID_TOTAL) downflowGridPoint = MachineEnums::DOWNFLOW_GRID_TOTAL-1;
    if(m_dfaCalGridVelHighImp[calibMode][downflowGridPoint] == value)return;
    m_dfaCalGridVelHighImp[calibMode][downflowGridPoint] = value;
}

void MachineData::setDfaCalGridVelLowImp(short calibMode, short downflowGridPoint, int value)
{
    if(calibMode < 0)calibMode = 0;
    else if(calibMode >= MachineEnums::CALIB_MODE_TOTAL) calibMode = MachineEnums::CALIB_MODE_TOTAL-1;
    if(downflowGridPoint < 0)downflowGridPoint = 0;
    else if(downflowGridPoint >= MachineEnums::DOWNFLOW_GRID_TOTAL) downflowGridPoint = MachineEnums::DOWNFLOW_GRID_TOTAL-1;
    if(m_dfaCalGridVelLowImp[calibMode][downflowGridPoint] == value)return;
    m_dfaCalGridVelLowImp[calibMode][downflowGridPoint] = value;
}


void MachineData::setFanSpeedMaxLimit(int value)
{
    if(m_fanSpeedMaxLimit == value) return;
    m_fanSpeedMaxLimit = value;
    emit fanSpeedMaxLimitChanged(value);
}

int MachineData::getFanSpeedMaxLimit() const
{
    return m_fanSpeedMaxLimit;
}

void MachineData::setFanSpeedMaxLimitSaved(int value)
{
    if(m_fanSpeedMaxLimitSaved == value) return;
    m_fanSpeedMaxLimitSaved = value;
    emit fanSpeedMaxLimitSavedChanged(value);
}

int MachineData::getFanSpeedMaxLimitSaved() const
{
    return m_fanSpeedMaxLimitSaved;
}

void MachineData::setFanSpeedFullEnable(bool value)
{
    if(m_fanSpeedFullEnable == value) return;
    m_fanSpeedFullEnable = value;
    emit fanSpeedFullEnableChanged(value);
}

bool MachineData::getFanSpeedFullEnable() const
{
    return m_fanSpeedFullEnable;
}

void MachineData::setSystemActualDate(const QString &value)
{
    if(m_systemActualDate == value) return;
    m_systemActualDate = value;
    emit systemActualDateChanged(value);
}

QString MachineData::getSystemActualDate() const
{
    return m_systemActualDate;
}

void MachineData::setSystemActualTime(const QString &value)
{
    if(m_systemActualTime == value) return;
    m_systemActualTime = value;
    emit systemActualTimeChanged(value);
}

QString MachineData::getSystemActualTime() const
{
    return m_systemActualTime;
}

QJsonObject MachineData::getRpExtDatabase() const
{
    return m_rpExtDatabase;
}

void MachineData::setRpExtDatabase(QJsonObject value)
{
    if(m_rpExtDatabase == value) return;
    m_rpExtDatabase = value;
    emit rpExtDatabaseChanged();
}

QJsonObject MachineData::getRpExtDefault() const
{
    return m_rpExtDefault;
}

void MachineData::setRpExtDefault(QJsonObject value)
{
    if(m_rpExtDefault == value) return;
    m_rpExtDefault = value;
    emit rpExtDefaultChanged();
}

bool MachineData::getRpExtDatabaseEnable() const
{
    return m_rpExtDatabaseEnable;
}

void MachineData::setRpExtDatabaseEnable(bool value)
{
    if(m_rpExtDatabaseEnable == value) return;
    m_rpExtDatabaseEnable = value;
    emit rpExtDatabaseEnableChanged(value);
}

QString MachineData::getSbcSerialNumber() const
{
    return m_sbcSerialNumber;
}

void MachineData::setSbcSerialNumber(const QString &value)
{
    if(m_sbcSerialNumber == value)return;
    m_sbcSerialNumber = value;
}

void MachineData::setAlarmLogSpaceMaximum(int alarmLogSpaceMaximum)
{
    if (m_alarmLogSpaceMaximum == alarmLogSpaceMaximum)
        return;

    m_alarmLogSpaceMaximum = alarmLogSpaceMaximum;
    emit alarmLogSpaceMaximumChanged(m_alarmLogSpaceMaximum);
}

void MachineData::setEventLogSpaceMaximum(int eventLogSpaceMaximum)
{
    if (m_eventLogSpaceMaximum == eventLogSpaceMaximum)
        return;

    m_eventLogSpaceMaximum = eventLogSpaceMaximum;
    emit eventLogSpaceMaximumChanged(m_eventLogSpaceMaximum);
}

void MachineData::setDataLogSpaceMaximum(int dataLogSpaceMaximum)
{
    if (m_dataLogSpaceMaximum == dataLogSpaceMaximum)
        return;

    m_dataLogSpaceMaximum = dataLogSpaceMaximum;
    emit dataLogSpaceMaximumChanged(m_dataLogSpaceMaximum);
}

void MachineData::setReplaceableCompRecordSpaceMaximum(int value)
{
    if(m_replaceableCompRecordSpaceMaximum == value)return;
    m_replaceableCompRecordSpaceMaximum = value;
    emit replaceableCompRecordSpaceMaximumChanged(value);
}

void MachineData::setResourceMonitorLogSpaceMaximum(int value)
{
    if(m_resourceMonitorLogSpaceMaximum == value)return;
    m_resourceMonitorLogSpaceMaximum = value;
    emit resourceMonitorLogSpaceMaximumChanged(value);
}

bool MachineData::getShippingModeEnable() const
{
    return m_shippingModeEnable;
}

void MachineData::setWatchdogCounter(int watchdogCounter)
{
    if (m_watchdogCounter == watchdogCounter)
        return;

    m_watchdogCounter = watchdogCounter;
    emit watchdogCounterChanged(m_watchdogCounter);
}

void MachineData::setRtcActualDate(const QString &rtcActualDate)
{
    if (m_rtcActualDate == rtcActualDate)
        return;

    m_rtcActualDate = rtcActualDate;
    emit rtcActualDateChanged(m_rtcActualDate);
}

void MachineData::setRtcActualTime(const QString &rtcActualTime)
{
    if (m_rtcActualTime == rtcActualTime)
        return;

    m_rtcActualTime = rtcActualTime;
    emit rtcActualTimeChanged(m_rtcActualTime);
}

void MachineData::setRtcBatteryLowStatus(bool value)
{
    if(m_rtcBatteryLowStatus == value) return;
    m_rtcBatteryLowStatus = value;
    emit rtcBatteryLowStatusChanged(value);
}

int MachineData::getDataLogSpaceMaximum() const
{
    return m_dataLogSpaceMaximum;
}

int MachineData::getAlarmLogSpaceMaximum() const
{
    return m_alarmLogSpaceMaximum;
}

int MachineData::getEventLogSpaceMaximum() const
{
    return m_eventLogSpaceMaximum;
}

int MachineData::getReplaceableCompRecordSpaceMaximum() const
{
    return m_replaceableCompRecordSpaceMaximum;
}

int MachineData::getResourceMonitorLogSpaceMaximum() const
{
    return m_resourceMonitorLogSpaceMaximum;
}

void MachineData::setVivariumMuteState(bool vivariumMuteState)
{
    if (m_vivariumMuteState == vivariumMuteState)
        return;

    m_vivariumMuteState = vivariumMuteState;
    emit vivariumMuteStateChanged(m_vivariumMuteState);
}

int MachineData::getWatchdogCounter() const
{
    return m_watchdogCounter;
}

QString MachineData::getRtcActualDate() const
{
    return m_rtcActualDate;
}

QString MachineData::getRtcActualTime() const
{
    return m_rtcActualTime;
}

bool MachineData::getRtcBatteryLowStatus() const
{
    return m_rtcBatteryLowStatus;
}

void MachineData::setParticleCounterSensorFanState(short particleCounterSensorFanState)
{
    if (m_particleCounterSensorFanState == particleCounterSensorFanState)
        return;

    m_particleCounterSensorFanState = particleCounterSensorFanState;
    emit particleCounterSensorFanStateChanged(m_particleCounterSensorFanState);
}

void MachineData::setParticleCounterSensorInstalled(bool particleCounterSensorInstalled)
{
    if (m_particleCounterSensorInstalled == particleCounterSensorInstalled)
        return;

    m_particleCounterSensorInstalled = particleCounterSensorInstalled;
    emit particleCounterSensorInstalledChanged(m_particleCounterSensorInstalled);
}

bool MachineData::getVivariumMuteState() const
{
    return m_vivariumMuteState;
}

short MachineData::getParticleCounterSensorFanState() const
{
    return m_particleCounterSensorFanState;
}

void MachineData::setParticleCounterPM2_5(int particleCounterPM2_5)
{
    if (m_particleCounterPM2_5 == particleCounterPM2_5)
        return;

    m_particleCounterPM2_5 = particleCounterPM2_5;
    emit particleCounterPM2_5Changed(m_particleCounterPM2_5);
}

void MachineData::setParticleCounterPM10(int particleCounterPM10)
{
    if (m_particleCounterPM10 == particleCounterPM10)
        return;

    m_particleCounterPM10 = particleCounterPM10;
    emit particleCounterPM10Changed(m_particleCounterPM10);
}

void MachineData::setParticleCounterPM1_0(int particleCounterPM1_0)
{
    if (m_particleCounterPM1_0 == particleCounterPM1_0)
        return;

    m_particleCounterPM1_0 = particleCounterPM1_0;
    emit particleCounterPM1_0Changed(m_particleCounterPM1_0);
}

bool MachineData::getParticleCounterSensorInstalled() const
{
    return m_particleCounterSensorInstalled;
}

void MachineData::setAlarmTempHigh(short alarmTempHigh)
{
    if (m_alarmTempHigh == alarmTempHigh)
        return;

    m_alarmTempHigh = alarmTempHigh;
    emit alarmTempHighChanged(m_alarmTempHigh);
}

void MachineData::setAlarmTempLow(short alarmTempLow)
{
    if (m_alarmTempLow == alarmTempLow)
        return;

    m_alarmTempLow = alarmTempLow;
    emit alarmTempLowChanged(m_alarmTempLow);
}

void MachineData::setEnvTempHighestLimit(int envTempHighestLimit)
{
    if (m_envTempHighestLimit == envTempHighestLimit)
        return;

    m_envTempHighestLimit = envTempHighestLimit;
    emit envTempHighestLimitChanged(m_envTempHighestLimit);
}

void MachineData::setEnvTempLowestLimit(int envTempLowestLimit)
{
    if (m_envTempLowestLimit == envTempLowestLimit)
        return;

    m_envTempLowestLimit = envTempLowestLimit;
    emit envTempLowestLimitChanged(m_envTempLowestLimit);
}

int MachineData::getParticleCounterPM2_5() const
{
    return m_particleCounterPM2_5;
}

int MachineData::getParticleCounterPM10() const
{
    return m_particleCounterPM10;
}

int MachineData::getParticleCounterPM1_0() const
{
    return m_particleCounterPM1_0;
}

short MachineData::getAlarmTempHigh() const
{
    return m_alarmTempHigh;
}

short MachineData::getAlarmTempLow() const
{
    return m_alarmTempLow;
}

void MachineData::setSashCycleMeter(int sashCycleMeter)
{
    if (m_sashCycleMeter == sashCycleMeter)
        return;

    m_sashCycleMeter = sashCycleMeter;
    emit sashCycleMeterChanged(m_sashCycleMeter);
}

short MachineData::getSashCycleMotorLockedAlarm() const
{
    return m_sashCycleMotorLockedAlarm;
}

void MachineData::setSashCycleMotorLockedAlarm(short value)
{
    if(m_sashCycleMotorLockedAlarm == value) return;
    m_sashCycleMotorLockedAlarm = value;
    emit sashCycleMotorLockedAlarmChanged(m_sashCycleMotorLockedAlarm);
}

int MachineData::getEnvTempHighestLimit() const
{
    return m_envTempHighestLimit;
}

int MachineData::getEnvTempLowestLimit() const
{
    return m_envTempLowestLimit;
}

void MachineData::setFanPIN(const QString &fanPIN)
{
    if (m_fanPIN == fanPIN)
        return;

    m_fanPIN = fanPIN;
    emit fanPINChanged(m_fanPIN);
}

/// getSashCycleCountValid() return true if sash state has reached Standby, Fully Closed, and Fully Opened
/// getSashCycleCountValid() return false if sash state in Safe height
bool MachineData::getSashCycleCountValid() const
{
    return m_sashCycleCountValid;
}

void MachineData::setSashCycleCountValid(bool sashCycleCountValid)
{
    if(m_sashCycleCountValid == sashCycleCountValid) return;
    m_sashCycleCountValid = sashCycleCountValid;
}

int MachineData::getSashCycleMeter() const
{
    return m_sashCycleMeter;
}

void MachineData::setCabinetDisplayName(const QString &cabinetDisplayName)
{
    if (m_cabinetDisplayName == cabinetDisplayName)
        return;

    m_cabinetDisplayName = cabinetDisplayName;
    emit cabinetDisplayNameChanged(m_cabinetDisplayName);
}

QString MachineData::getFanPIN() const
{
    return m_fanPIN;
}

void MachineData::setEscoLockServiceEnable(int escoLockServiceEnable)
{
    if (m_escoLockServiceEnable == escoLockServiceEnable)
        return;

    m_escoLockServiceEnable = escoLockServiceEnable;
    emit escoLockServiceEnableChanged(m_escoLockServiceEnable);
}

QString MachineData::getCabinetDisplayName() const
{
    return m_cabinetDisplayName;
}

bool MachineData::getCertificationExpiredValid() const
{
    return m_certificationExpiredValid;
}

void MachineData::setCertificationExpiredCount(int certificationExpiredCount)
{
    if (m_certificationExpiredCount == certificationExpiredCount)
        return;

    m_certificationExpiredCount = certificationExpiredCount;
    emit certificationExpiredCountChanged(m_certificationExpiredCount);
}

void MachineData::setCertificationExpired(bool certificationExpired)
{
    if (m_certificationExpired == certificationExpired)
        return;

    m_certificationExpired = certificationExpired;
    emit certificationExpiredChanged(m_certificationExpired);
}

int MachineData::getCertificationExpiredCount() const
{
    return m_certificationExpiredCount;
}

void MachineData::setFanAutoWeeklyDay(int fanAutoWeeklyDay)
{
    if (m_fanAutoWeeklyDay == fanAutoWeeklyDay)
        return;

    m_fanAutoWeeklyDay = fanAutoWeeklyDay;
    emit fanAutoWeeklyDayChanged(m_fanAutoWeeklyDay);
}

int MachineData::getFanAutoEnabledOff() const
{
    return m_fanAutoEnabledOff;
}

void MachineData::setFanAutoEnabledOff(int fanAutoEnabledOff)
{
    if(m_fanAutoEnabledOff == fanAutoEnabledOff)return;
    m_fanAutoEnabledOff = fanAutoEnabledOff;
    emit fanAutoEnabledOffChanged(m_fanAutoEnabledOff);
}

int MachineData::getFanAutoTimeOff() const
{
    return m_fanAutoTimeOff;
}

void MachineData::setFanAutoTimeOff(int fanAutoTimeOff)
{
    if(m_fanAutoTimeOff == fanAutoTimeOff)return;
    m_fanAutoTimeOff = fanAutoTimeOff;
    emit fanAutoTimeOffChanged(m_fanAutoTimeOff);
}

int MachineData::getFanAutoDayRepeatOff() const
{
    return m_fanAutoDayRepeatOff;
}

void MachineData::setFanAutoDayRepeatOff(int fanAutoDayRepeatOff)
{
    if(m_fanAutoDayRepeatOff == fanAutoDayRepeatOff)return;
    m_fanAutoDayRepeatOff = fanAutoDayRepeatOff;
    emit fanAutoDayRepeatOffChanged(m_fanAutoDayRepeatOff);
}

int MachineData::getFanAutoWeeklyDayOff() const
{
    return m_fanAutoWeeklyDayOff;
}

void MachineData::setFanAutoWeeklyDayOff(int fanAutoWeeklyDayOff)
{
    if(m_fanAutoWeeklyDayOff == fanAutoWeeklyDayOff)return;
    m_fanAutoWeeklyDayOff = fanAutoWeeklyDayOff;
    emit fanAutoWeeklyDayOffChanged(m_fanAutoWeeklyDayOff);
}

short MachineData::getSecurityAccessMode() const
{
    return m_securityAccessMode;
}

void MachineData::setSecurityAccessMode(short securityAccessMode)
{
    if (m_securityAccessMode == securityAccessMode)
        return;

    m_securityAccessMode = securityAccessMode;
    emit securityAccessChanged(m_securityAccessMode);
}

QString MachineData::getDateCertificationReminder() const
{
    return m_dateCertificationReminder;
}

void MachineData::setDateCertificationReminder(const QString &dateCertificationReminder)
{
    if (m_dateCertificationReminder == dateCertificationReminder)
        return;

    m_dateCertificationReminder = dateCertificationReminder;
    emit dateCertificationReminderChanged(m_dateCertificationReminder);
}

bool MachineData::getCertificationExpired() const
{
    return m_certificationExpired;
}

void MachineData::setFanAutoDayRepeat(int fanAutoDayRepeat)
{
    if (m_fanAutoDayRepeat == fanAutoDayRepeat)
        return;

    m_fanAutoDayRepeat = fanAutoDayRepeat;
    emit fanAutoDayRepeatChanged(m_fanAutoDayRepeat);
}

void MachineData::setFanAutoTime(int fanAutoTime)
{
    if (m_fanAutoTime == fanAutoTime)
        return;

    m_fanAutoTime = fanAutoTime;
    emit fanAutoTimeChanged(m_fanAutoTime);
}

void MachineData::setFanAutoEnabled(int fanAutoEnabled)
{
    if (m_fanAutoEnabled == fanAutoEnabled)
        return;

    m_fanAutoEnabled = fanAutoEnabled;
    emit fanAutoEnabledChanged(m_fanAutoEnabled);
}

void MachineData::setUVAutoEnabled(int uvAutoEnabled)
{
    if (m_uvAutoEnabled == uvAutoEnabled)
        return;

    m_uvAutoEnabled = uvAutoEnabled;
    emit uvAutoEnabledChanged(m_uvAutoEnabled);
}

void MachineData::setUVAutoTime(int uvAutoTime)
{
    if (m_uvAutoTime == uvAutoTime)
        return;

    m_uvAutoTime = uvAutoTime;
    emit uvAutoTimeChanged(m_uvAutoTime);
}

void MachineData::setUVAutoDayRepeat(int uvAutoDayRepeat)
{
    if (m_uvAutoDayRepeat == uvAutoDayRepeat)
        return;

    m_uvAutoDayRepeat = uvAutoDayRepeat;
    emit uvAutoDayRepeatChanged(m_uvAutoDayRepeat);
}

void MachineData::setUVAutoWeeklyDay(int uvAutoWeeklyDay)
{
    if (m_uvAutoWeeklyDay == uvAutoWeeklyDay)
        return;

    m_uvAutoWeeklyDay = uvAutoWeeklyDay;
    emit uvAutoWeeklyDayChanged(m_uvAutoWeeklyDay);
}

int MachineData::getUVAutoEnabledOff() const
{
    return m_uvAutoEnabledOff;
}

void MachineData::setUVAutoEnabledOff(int uvAutoEnabledOff)
{
    if (m_uvAutoEnabledOff == uvAutoEnabledOff)
        return;

    m_uvAutoEnabledOff = uvAutoEnabledOff;
    emit uvAutoEnabledOffChanged(m_uvAutoEnabledOff);
}

int MachineData::getUVAutoTimeOff() const
{
    return m_uvAutoTimeOff;
}

void MachineData::setUVAutoTimeOff(int uvAutoTimeOff)
{
    if (m_uvAutoTimeOff == uvAutoTimeOff)
        return;

    m_uvAutoTimeOff = uvAutoTimeOff;
    emit uvAutoTimeOffChanged(m_uvAutoTimeOff);
}

int MachineData::getUVAutoDayRepeatOff() const
{
    return m_uvAutoDayRepeatOff;
}

void MachineData::setUVAutoDayRepeatOff(int uvAutoDayRepeatOff)
{
    if (m_uvAutoDayRepeatOff == uvAutoDayRepeatOff)
        return;

    m_uvAutoDayRepeatOff = uvAutoDayRepeatOff;
    emit uvAutoDayRepeatOffChanged(m_uvAutoDayRepeatOff);
}

int MachineData::getUVAutoWeeklyDayOff() const
{
    return m_uvAutoWeeklyDayOff;
}

void MachineData::setUVAutoWeeklyDayOff(int uvAutoWeeklyDayOff)
{
    if (m_uvAutoWeeklyDayOff == uvAutoWeeklyDayOff)
        return;

    m_uvAutoWeeklyDayOff = uvAutoWeeklyDayOff;
    emit uvAutoWeeklyDayOffChanged(m_uvAutoWeeklyDayOff);
}

///////////

int MachineData::getLightAutoEnabled() const
{
    return m_lightAutoEnabled;
}

int MachineData::getLightAutoTime() const
{
    return m_lightAutoTime;
}

int MachineData::getLightAutoDayRepeat() const
{
    return m_lightAutoDayRepeat;
}

int MachineData::getLightAutoWeeklyDay() const
{
    return m_lightAutoWeeklyDay;
}

int MachineData::getLightAutoEnabledOff() const
{
    return m_lightAutoEnabledOff;
}

int MachineData::getLightAutoTimeOff() const
{
    return m_lightAutoTimeOff;
}

int MachineData::getLightAutoDayRepeatOff() const
{
    return m_lightAutoDayRepeatOff;
}

int MachineData::getLightAutoWeeklyDayOff() const
{
    return m_lightAutoWeeklyDayOff;
}

void MachineData::setLightAutoEnabled(int value)
{
    if(m_lightAutoEnabled == value) return;
    m_lightAutoEnabled = value;
    emit lightAutoEnabledChanged(value);
}

void MachineData::setLightAutoTime(int value)
{
    if(m_lightAutoTime == value) return;
    m_lightAutoTime = value;
    emit lightAutoTimeChanged(value);
}

void MachineData::setLightAutoDayRepeat(int value)
{
    if(m_lightAutoDayRepeat == value) return;
    m_lightAutoDayRepeat = value;
    emit lightAutoDayRepeatChanged(value);
}

void MachineData::setLightAutoWeeklyDay(int value)
{
    if(m_lightAutoWeeklyDay == value) return;
    m_lightAutoWeeklyDay = value;
    emit lightAutoWeeklyDayChanged(value);
}

void MachineData::setLightAutoEnabledOff(int value)
{
    if(m_lightAutoEnabledOff == value) return;
    m_lightAutoEnabledOff = value;
    emit lightAutoEnabledOffChanged(value);
}

void MachineData::setLightAutoTimeOff(int value)
{
    if(m_lightAutoTimeOff == value) return;
    m_lightAutoTimeOff = value;
    emit lightAutoTimeOffChanged(value);
}

void MachineData::setLightAutoDayRepeatOff(int value)
{
    if(m_lightAutoDayRepeatOff == value) return;
    m_lightAutoDayRepeatOff = value;
    emit lightAutoDayRepeatOffChanged(value);
}

void MachineData::setLightAutoWeeklyDayOff(int value)
{
    if(m_lightAutoWeeklyDayOff == value) return;
    m_lightAutoWeeklyDayOff = value;
    emit lightAutoWeeklyDayOffChanged(value);
}

///////////

int MachineData::getSocketAutoEnabled() const
{
    return m_socketAutoEnabled;
}

int MachineData::getSocketAutoTime() const
{
    return m_socketAutoTime;
}

int MachineData::getSocketAutoDayRepeat() const
{
    return m_socketAutoDayRepeat;
}

int MachineData::getSocketAutoWeeklyDay() const
{
    return m_socketAutoWeeklyDay;
}

int MachineData::getSocketAutoEnabledOff() const
{
    return m_socketAutoEnabledOff;
}

int MachineData::getSocketAutoTimeOff() const
{
    return m_socketAutoTimeOff;
}

int MachineData::getSocketAutoDayRepeatOff() const
{
    return m_socketAutoDayRepeatOff;
}

int MachineData::getSocketAutoWeeklyDayOff() const
{
    return m_socketAutoWeeklyDayOff;
}

void MachineData::setSocketAutoEnabled(int value)
{
    if(m_socketAutoEnabled == value) return;
    m_socketAutoEnabled = value;
    emit socketAutoEnabledChanged(value);
}

void MachineData::setSocketAutoTime(int value)
{
    if(m_socketAutoTime == value) return;
    m_socketAutoTime = value;
    emit socketAutoTimeChanged(value);
}

void MachineData::setSocketAutoDayRepeat(int value)
{
    if(m_socketAutoDayRepeat == value) return;
    m_socketAutoDayRepeat = value;
    emit socketAutoDayRepeatChanged(value);
}

void MachineData::setSocketAutoWeeklyDay(int value)
{
    if(m_socketAutoWeeklyDay == value) return;
    m_socketAutoWeeklyDay = value;
    emit socketAutoWeeklyDayChanged(value);
}

void MachineData::setSocketAutoEnabledOff(int value)
{
    if(m_socketAutoEnabledOff == value) return;
    m_socketAutoEnabledOff = value;
    emit socketAutoEnabledOffChanged(value);
}

void MachineData::setSocketAutoTimeOff(int value)
{
    if(m_socketAutoTimeOff == value) return;
    m_socketAutoTimeOff = value;
    emit socketAutoTimeOffChanged(value);
}

void MachineData::setSocketAutoDayRepeatOff(int value)
{
    if(m_socketAutoDayRepeatOff == value) return;
    m_socketAutoDayRepeatOff = value;
    emit socketAutoDayRepeatOffChanged(value);
}

void MachineData::setSocketAutoWeeklyDayOff(int value)
{
    if(m_socketAutoWeeklyDayOff == value) return;
    m_socketAutoWeeklyDayOff = value;
    emit socketAutoWeeklyDayOffChanged(value);
}

////////
int MachineData::getFanAutoEnabled() const
{
    return m_fanAutoEnabled;
}

int MachineData::getFanAutoTime() const
{
    return m_fanAutoTime;
}

int MachineData::getFanAutoDayRepeat() const
{
    return m_fanAutoDayRepeat;
}

int MachineData::getFanAutoWeeklyDay() const
{
    return m_fanAutoWeeklyDay;
}

void MachineData::setLcdBrightnessLevelDimmed(bool lcdBrightnessLevelDimmed)
{
    if (m_lcdBrightnessLevelDimmed == lcdBrightnessLevelDimmed)
        return;

    m_lcdBrightnessLevelDimmed = lcdBrightnessLevelDimmed;
    emit lcdBrightnessLevelDimmedChanged(m_lcdBrightnessLevelDimmed);
}

void MachineData::setLcdEnableLockScreen(bool value)
{
    if(m_lcdEnableLockScreen == value) return;
    m_lcdEnableLockScreen = value;
    emit lcdEnableLockScreenChanged(value);
}

void MachineData::setEventLogIsFull(bool eventLogIsFull)
{
    if (m_eventLogIsFull == eventLogIsFull)
        return;

    m_eventLogIsFull = eventLogIsFull;
    emit eventLogIsFullChanged(m_eventLogIsFull);
}

int MachineData::getReplaceableCompRecordCount() const
{
    return m_replaceableCompRecordCount;
}

void MachineData::setReplaceableCompRecordCount(int value)
{
    if(m_replaceableCompRecordCount == value) return;
    m_replaceableCompRecordCount = value;
    emit replaceableCompRecordCountChanged(value);
}

bool MachineData::getReplaceableCompRecordIsFull() const
{
    return m_replaceableCompRecordIsFull;
}

void MachineData::setReplaceableCompRecordIsFull(bool value)
{
    if(m_replaceableCompRecordIsFull == value) return;
    m_replaceableCompRecordIsFull = value;
    emit replaceableCompRecordIsFullChanged(value);
}

int MachineData::getUVAutoEnabled() const
{
    return m_uvAutoEnabled;
}

int MachineData::getUVAutoTime() const
{
    return m_uvAutoTime;
}

int MachineData::getUVAutoDayRepeat() const
{
    return m_uvAutoDayRepeat;
}

int MachineData::getUVAutoWeeklyDay() const
{
    return m_uvAutoWeeklyDay;
}

bool MachineData::getLcdBrightnessLevelDimmed() const
{
    return m_lcdBrightnessLevelDimmed;
}

bool MachineData::getLcdEnableLockScreen() const
{
    return m_lcdEnableLockScreen;
}

void MachineData::setEventLogCount(int eventLogCount)
{
    if (m_eventLogCount == eventLogCount)
        return;

    m_eventLogCount = eventLogCount;
    emit eventLogCountChanged(m_eventLogCount);
}

bool MachineData::getEventLogIsFull() const
{
    return m_eventLogIsFull;
}

void MachineData::setModbusSlaveID(short modbusSlaveID)
{
    if (m_modbusSlaveID == modbusSlaveID)
        return;

    m_modbusSlaveID = modbusSlaveID;
    emit modbusSlaveIDChanged(m_modbusSlaveID);
}

void MachineData::setModbusLatestStatus(const QString &modbusLatestStatus)
{
    if (m_modbusLatestStatus == modbusLatestStatus)
        return;

    m_modbusLatestStatus = modbusLatestStatus;
    emit modbusLatestStatusChanged(m_modbusLatestStatus);
}

int MachineData::getEventLogCount() const
{
    return m_eventLogCount;
}

short MachineData::getModbusSlaveID() const
{
    return m_modbusSlaveID;
}

void MachineData::setModbusAllowSetUvLight(bool modbusAllowSetUvLight)
{
    if (m_modbusAllowSetUvLight == modbusAllowSetUvLight)
        return;

    m_modbusAllowSetUvLight = modbusAllowSetUvLight;
    emit modbusAllowSetUvLightChanged(m_modbusAllowSetUvLight);
}

QString MachineData::getModbusLatestStatus() const
{
    return m_modbusLatestStatus;
}

void MachineData::setModbusAllowSetGas(bool modbusAllowGasSet)
{
    if (m_modbusAllowSetGas == modbusAllowGasSet)
        return;

    m_modbusAllowSetGas = modbusAllowGasSet;
    emit modbusAllowGasSetChanged(m_modbusAllowSetGas);
}

bool MachineData::getModbusAllowSetUvLight() const
{
    return m_modbusAllowSetUvLight;
}

void MachineData::setModbusAllowSetSocket(bool modbusAllowSetSocket)
{
    if (m_modbusAllowSetSocket == modbusAllowSetSocket)
        return;

    m_modbusAllowSetSocket = modbusAllowSetSocket;
    emit modbusAllowSetSocketChanged(m_modbusAllowSetSocket);
}

bool MachineData::getModbusAllowSetGas() const
{
    return m_modbusAllowSetGas;
}

void MachineData::setModbusAllowSetLightIntensity(bool modbusAllowSetLightIntensity)
{
    if (m_modbusAllowSetLightIntensity == modbusAllowSetLightIntensity)
        return;

    m_modbusAllowSetLightIntensity = modbusAllowSetLightIntensity;
    emit modbusAllowSetLightIntensityChanged(m_modbusAllowSetLightIntensity);
}

bool MachineData::getModbusAllowSetSocket() const
{
    return m_modbusAllowSetSocket;
}

void MachineData::setModbusAllowSetLight(bool modbusAllowSetLight)
{
    if (m_modbusAllowSetLight == modbusAllowSetLight)
        return;

    m_modbusAllowSetLight = modbusAllowSetLight;
    emit modbusAllowSetLightChanged(m_modbusAllowSetLight);
}

bool MachineData::getModbusAllowSetLightIntensity() const
{
    return m_modbusAllowSetLightIntensity;
}

void MachineData::setModbusAllowSetFan(bool modbusAllowSetFan)
{
    if (m_modbusAllowSetFan == modbusAllowSetFan)
        return;

    m_modbusAllowSetFan = modbusAllowSetFan;
    emit modbusAllowSetFanChanged(m_modbusAllowSetFan);
}

bool MachineData::getModbusAllowSetLight() const
{
    return m_modbusAllowSetLight;
}

void MachineData::setModbusAllowIpMaster(const QString &modbusAllowIpMaster)
{
    if (m_modbusAllowIpMaster == modbusAllowIpMaster)
        return;

    m_modbusAllowIpMaster = modbusAllowIpMaster;
    emit modbusAllowIpMasterChanged(m_modbusAllowIpMaster);
}

bool MachineData::getModbusAllowSetFan() const
{
    return m_modbusAllowSetFan;
}


MachineData::MachineData(QObject *parent) : QObject(parent)
{
    m_rpListLast.clear();
    m_rpListSelected.clear();

    for(short i=0; i< MachineEnums::RPList_Total; i++){
        m_rpListLast.append("");
        m_rpListSelected.append("");
    }

    m_bookingScheduleTodayVarList.clear();
    m_bookingScheduleTodayVarListToShow.clear();
    //qDebug() << "m_rpListLast.length()" << ((m_rpListLast.length() == MachineEnums::RPList_Total) ? "Valid" : "Invalid");
}//

MachineData::~MachineData()
{
    //    qDebug() << metaObject()->className() << __FUNCTION__ << thread();
}

short MachineData::getMachineBackendState() const
{
    return m_machineState;
}

void MachineData::setMachineBackendState(short workerState)
{
    if (m_machineState == workerState)
        return;

    m_machineState = workerState;
    emit machineStateChanged(m_machineState);
}

int MachineData::getCount() const
{
    return m_count;
}

void MachineData::setCount(int count)
{
    if (m_count == count)
        return;

    m_count = count;
    emit countChanged(m_count);
}

bool MachineData::getHasStopped() const
{
    return m_hasStopped;
}

void MachineData::setHasStopped(bool hasStopped)
{
    if (m_hasStopped == hasStopped)
        return;

    m_hasStopped = hasStopped;
    emit hasStoppedChanged(m_hasStopped);
}

void MachineData::setMachineProfileID(const QString &value)
{
    if(m_machineProfileID == value)return;

    //    QSettings settings;
    //    settings.setValue("machProfId", value);

    m_machineProfileID = value;
    emit machineProfileIDChanged(value);
}//

QString MachineData::getMachineProfileID() const
{
    return m_machineProfileID;
}

void MachineData::setAlarmLogCount(int alarmLogCount)
{
    if (m_alarmLogCount == alarmLogCount)
        return;

    m_alarmLogCount = alarmLogCount;
    emit alarmLogCountChanged(m_alarmLogCount);
}

void MachineData::setAlarmLogIsFull(bool alarmLogIsFull)
{
    if (m_alarmLogIsFull == alarmLogIsFull)
        return;

    m_alarmLogIsFull = alarmLogIsFull;
    emit alarmLogIsFullChanged(m_alarmLogIsFull);
}

QString MachineData::getModbusAllowIpMaster() const
{
    return m_modbusAllowIpMaster;
}

void MachineData::setSerialNumber(const QString &serialNumber)
{
    if (m_serialNumber == serialNumber)
        return;

    m_serialNumber = serialNumber;
    emit serialNumberChanged(m_serialNumber);
}

int MachineData::getAlarmLogCount() const
{
    return m_alarmLogCount;
}

bool MachineData::getAlarmLogIsFull() const
{
    return m_alarmLogIsFull;
}

short MachineData::getFanPrimaryState() const
{
    return m_fanPrimaryState;
}

short MachineData::getLightState() const
{
    return m_lightState;
}

short MachineData::getSocketState() const
{
    return m_socketState;
}

short MachineData::getGasState() const
{
    return m_gasState;
}

short MachineData::getUvState() const
{
    return m_uvState;
}

short MachineData::getMuteAlarmState() const
{
    return m_muteAlarmState;
}

short MachineData::getSashWindowState() const
{
    return m_sashWindowState;
}

short MachineData::getSashWindowPrevState() const
{
    return m_sashWindowPrevState;
}

short MachineData::getSashWindowMotorizeState() const
{
    return m_sashWindowMotorizeState;
}

short MachineData::getExhaustContactState() const
{
    return m_exhaustContactState;
}

short MachineData::getAlarmContactState() const
{
    return m_alarmContactState;
}

short MachineData::getLightIntensity() const
{
    return m_lightIntensity;
}

short MachineData::getAlarmInflowLow() const
{
    return m_alarmInflowLow;
}

short MachineData::getAlarmSash() const
{
    return m_alarmSash;
}

//bool MachineData::getAlarmDownflowLow() const
//{
//    return m_alarmDownflowLow;
//}

//bool MachineData::getAlarmDownflowHigh() const
//{
//    return m_alarmDownflowHigh;
//}

int MachineData::getTemperatureAdc() const
{
    return m_temperatureAdc;
}

QString MachineData::getTemperatureValueStrf() const
{
    return m_temperatureValueStrf;
}

short MachineData::getMeasurementUnit() const
{
    return m_measurementUnit;
}

void MachineData::setMuteAlarmTime(int muteAlarmTime)
{
    if (m_muteAlarmTime == muteAlarmTime)
        return;

    m_muteAlarmTime = muteAlarmTime;
    emit muteAlarmTimeChanged(m_muteAlarmTime);
}

int MachineData::getMuteAlarmTimeAtFullyOpened() const
{
    return m_muteAlarmTimeAtFullyOpened;
}

void MachineData::setMuteAlarmTimeAtFullyOpened(int value)
{
    if(m_muteAlarmTimeAtFullyOpened == value) return;
    m_muteAlarmTimeAtFullyOpened = value;
    emit muteAlarmTimeAtFullyOpenedChanged(value);
}

void MachineData::setMuteAlarmCountdown(int muteAlarmCountdown)
{
    if (m_muteAlarmCountdown == muteAlarmCountdown)
        return;

    m_muteAlarmCountdown = muteAlarmCountdown;
    emit muteAlarmCountdownChanged(m_muteAlarmCountdown);
}

void MachineData::setFanUsageMeter(int fanUsageMeter)
{
    if (m_fanUsageMeter == fanUsageMeter)
        return;

    m_fanUsageMeter = fanUsageMeter;
    //    qDebug() << __func__ <<  m_fanUsageMeter;
    emit fanUsageMeterChanged(m_fanUsageMeter);
}

QString MachineData::getSerialNumber() const
{
    return m_serialNumber;
}

int MachineData::getMuteAlarmTime() const
{
    return m_muteAlarmTime;
}

int MachineData::getMuteAlarmCountdown() const
{
    return m_muteAlarmCountdown;
}

void MachineData::setSeasPressureDiffPaOffset(short seasPressureDiffPaOffset)
{
    if (m_seasPressureDiffPaOffset == seasPressureDiffPaOffset)
        return;

    m_seasPressureDiffPaOffset = seasPressureDiffPaOffset;
    emit seasPressureDiffPaOffsetChanged(m_seasPressureDiffPaOffset);
}

short MachineData::getSeasPressureDiffPaNominal() const
{
    return m_seasPressureDiffPaNominal;
}

void MachineData::setSeasPressureDiffPaNominal(short value)
{
    if(m_seasPressureDiffPaNominal == value)return;
    m_seasPressureDiffPaNominal = value;
    emit seasPressureDiffPaNominalChanged(value);
}

int MachineData::getFanUsageMeter() const
{
    return m_fanUsageMeter;
}

void MachineData::setSeasAlarmPressureLow(short seasAlarmPressureLow)
{
    if (m_seasAlarmPressureLow == seasAlarmPressureLow)
        return;

    m_seasAlarmPressureLow = seasAlarmPressureLow;
    emit seasAlarmPressureLowChanged(m_seasAlarmPressureLow);
}

short MachineData::getSeasPressureDiffPaOffset() const
{
    return m_seasPressureDiffPaOffset;
}

void MachineData::setSeasPressureDiffPaLowLimit(int seasPressureDiffPaLowLimit)
{
    if (m_seasPressureDiffPaLowLimit == seasPressureDiffPaLowLimit)
        return;

    m_seasPressureDiffPaLowLimit = seasPressureDiffPaLowLimit;
    emit seasPressureDiffPaLowLimitChanged(m_seasPressureDiffPaLowLimit);
}

void MachineData::setSeasPressureDiffStrf(const QString &seasPressureDiffStr)
{
    if (m_seasPressureDiffStr == seasPressureDiffStr)
        return;

    m_seasPressureDiffStr = seasPressureDiffStr;
    emit seasPressureDiffStrChanged(m_seasPressureDiffStr);
}

short MachineData::getSeasFlapAlarmPressure() const
{
    return m_seasFlapAlarmPressure;
}

void MachineData::setSeasFlapAlarmPressure(short seasFlapAlarmPressure)
{
    if(m_seasFlapAlarmPressure == seasFlapAlarmPressure)return;
    m_seasFlapAlarmPressure = seasFlapAlarmPressure;
    emit seasFlapAlarmPressureChanged(m_seasFlapAlarmPressure);
}

short MachineData::getAlarmSeasPressureLow() const
{
    return m_seasAlarmPressureLow;
}

int MachineData::getSeasPressureDiffPaLowLimit() const
{
    return m_seasPressureDiffPaLowLimit;
}

void MachineData::setSeasPressureDiff(int seasPressureDiff)
{
    if (m_seasPressureDiff == seasPressureDiff)
        return;

    m_seasPressureDiff = seasPressureDiff;
    emit seasPressureDiffChanged(m_seasPressureDiff);
}

QString MachineData::getSeasPressureDiffStr() const
{
    return m_seasPressureDiffStr;
}

void MachineData::setSeasPressureDiffPa(int seasPressureDiffPa)
{
    if (m_seasPressureDiffPa == seasPressureDiffPa)
        return;

    m_seasPressureDiffPa = seasPressureDiffPa;
    emit seasPressureDiffPaChanged(m_seasPressureDiffPa);
}

int MachineData::getSeasPressureDiff() const
{
    return m_seasPressureDiff;
}

void MachineData::setSeasInstalled(bool seasInstalled)
{
    if (m_seasInstalled == seasInstalled)
        return;

    m_seasInstalled = seasInstalled;
    emit seasInstalledChanged(m_seasInstalled);
}

int MachineData::getSeasPressureDiffPa() const
{
    return m_seasPressureDiffPa;
}

void MachineData::setPowerOutageUvState(short powerOutageUvState)
{
    if (m_powerOutageUvState == powerOutageUvState)
        return;

    m_powerOutageUvState = powerOutageUvState;
    emit powerOutageUvStateChanged(m_powerOutageUvState);
}

bool MachineData::getSeasFlapInstalled() const
{
    return m_seasFlapInstalled;
}

void MachineData::setSeasFlapInstalled(bool seasFlapInstalled)
{
    if (m_seasFlapInstalled == seasFlapInstalled)
        return;

    m_seasFlapInstalled = seasFlapInstalled;
    emit powerOutageUvStateChanged(m_seasFlapInstalled);
}

bool MachineData::getSeasInstalled() const
{
    return m_seasInstalled;
}

//short MachineData::getPowerOutageLightState() const
//{
//    return m_powerOutageLightState;
//}

//void MachineData::setPowerOutageLightState(short powerOutageLightState)
//{
//    if (m_powerOutageLightState == powerOutageLightState)
//        return;

//    m_powerOutageLightState = powerOutageLightState;
//    emit powerOutageLightStateChanged(m_powerOutageLightState);
//}

short MachineData::getPowerOutageUvState() const
{
    return m_powerOutageUvState;
}

void MachineData::setPowerOutageFanState(short powerOutageFanState)
{
    if (m_powerOutageFanState == powerOutageFanState)
        return;

    m_powerOutageFanState = powerOutageFanState;
    emit powerOutageFanStateChanged(m_powerOutageFanState);
}

void MachineData::setPowerOutageRecoverTime(const QString &powerOutageRecoverTime)
{
    if (m_powerOutageRecoverTime == powerOutageRecoverTime)
        return;

    m_powerOutageRecoverTime = powerOutageRecoverTime;
    emit powerOutageRecoverTimeChanged(m_powerOutageRecoverTime);
}

short MachineData::getPowerOutageFanState() const
{
    return m_powerOutageFanState;
}

void MachineData::setPowerOutageTime(const QString &powerOutageTime)
{
    if (m_powerOutageTime == powerOutageTime)
        return;

    m_powerOutageTime = powerOutageTime;
    emit powerOutageTimeChanged(m_powerOutageTime);
}

void MachineData::setPowerOutage(bool powerOutage)
{
    if (m_powerOutage == powerOutage)
        return;

    m_powerOutage = powerOutage;
    emit powerOutageChanged(m_powerOutage);
}

QString MachineData::getPowerOutageTime() const
{
    return m_powerOutageTime;
}

QString MachineData::getPowerOutageRecoverTime() const
{
    return m_powerOutageRecoverTime;
}

void MachineData::setFilterLifeMinutes(int filterLifeMinutes)
{
    if (m_filterLifeMinutes == filterLifeMinutes)
        return;

    m_filterLifeMinutes = filterLifeMinutes;
    emit filterLifeMinutesChanged(m_filterLifeMinutes);
}

void MachineData::setFilterLifePercent(short filterLifePercent)
{
    if (m_filterLifePercent == filterLifePercent)
        return;

    m_filterLifePercent = filterLifePercent;
    emit filterLifePercentChanged(m_filterLifePercent);
}

QString MachineData::getFilterLifeLevelStrf() const
{
    return m_filterLifeLevelStrf;
}

void MachineData::setFilterLifeLevelStrf(const QString &value)
{
    if(m_filterLifeLevelStrf == value) return;
    m_filterLifeLevelStrf = value;
    emit filterLifeLevelStrfChanged(value);
}

QString MachineData::getFilterLifeLevelColorStrf() const
{
    return m_filterLifeLevelColorStrf;
}

void MachineData::setFilterLifeLevelColorStrf(const QString &value)
{
    if(m_filterLifeLevelColorStrf == value) return;
    m_filterLifeLevelColorStrf = value;
    emit filterLifeLevelColorStrfChanged(value);
}

void MachineData::setFilterLifeRpm(int value)
{
    if(m_filterLifeRpm == value) return;
    m_filterLifeRpm = value;
    emit filterLifeRpmChanged(value);
}

void MachineData::setFilterLifeCalculationMode(int value)
{
    if(m_filterLifeCalculationMode == value) return;
    m_filterLifeCalculationMode = value;
    emit filterLifeCalculationModeChanged(value);
}

void MachineData::setFilterLifeMinimumBlowerUsageMode(int value)
{
    if(m_filterLifeMinimumBlowerUsageMode == value) return;
    m_filterLifeMinimumBlowerUsageMode = value;
    emit filterLifeMinimumBlowerUsageModeChanged(value);
}

void MachineData::setFilterLifeMaximumBlowerUsageMode(int value)
{
    if(m_filterLifeMaximumBlowerUsageMode == value) return;
    m_filterLifeMaximumBlowerUsageMode = value;
    emit filterLifeMaximumBlowerUsageModeChanged(value);
}

void MachineData::setFilterLifeMinimumBlowerRpmMode(int value)
{
    if(m_filterLifeMinimumBlowerRpmMode == value) return;
    m_filterLifeMinimumBlowerRpmMode = value;
    emit filterLifeMinimumBlowerRpmModeChanged(value);
}

void MachineData::setFilterLifeMaximumBlowerRpmMode(int value)
{
    if(m_filterLifeMaximumBlowerRpmMode == value) return;
    m_filterLifeMaximumBlowerRpmMode = value;
    emit filterLifeMaximumBlowerRpmModeChanged(value);
}

int MachineData::getFilterLifeRpm() const
{
    return m_filterLifeRpm;
}

int MachineData::getFilterLifeCalculationMode() const
{
    return m_filterLifeCalculationMode;
}

int MachineData::getFilterLifeMinimumBlowerUsageMode() const
{
    return m_filterLifeMinimumBlowerUsageMode;
}

int MachineData::getFilterLifeMaximumBlowerUsageMode() const
{
    return m_filterLifeMaximumBlowerUsageMode;
}

int MachineData::getFilterLifeMinimumBlowerRpmMode() const
{
    return m_filterLifeMinimumBlowerRpmMode;
}

int MachineData::getFilterLifeMaximumBlowerRpmMode() const
{
    return m_filterLifeMaximumBlowerRpmMode;
}

bool MachineData::getPowerOutage() const
{
    return m_powerOutage;
}

void MachineData::setPostPurgingCountdown(int postPurgingCountdown)
{
    if (m_postPurgingCountdown == postPurgingCountdown)
        return;

    m_postPurgingCountdown = postPurgingCountdown;
    emit postPurgingCountdownChanged(m_postPurgingCountdown);
}

bool MachineData::getFilterLifeReminder() const
{
    return m_filterLifeReminder;
}

void MachineData::setFilterLifeReminder(bool filterLifeReminder)
{
    if(m_filterLifeReminder == filterLifeReminder)return;
    m_filterLifeReminder = filterLifeReminder;
    emit filterLifeReminderChanged(m_filterLifeReminder);
}

bool MachineData::getFilterLifeReminderSnoozed() const
{
    return m_filterLifeReminderSnoozed;
}

void MachineData::setFilterLifeReminderSnoozed(bool value)
{
    if(m_filterLifeReminderSnoozed == value)return;
    m_filterLifeReminderSnoozed = value;
    emit filterLifeReminderSnoozedChanged(value);
}

int MachineData::getFilterLifeMinutes() const
{
    return m_filterLifeMinutes;
}

short MachineData::getFilterLifePercent() const
{
    return m_filterLifePercent;
}

void MachineData::setPostPurgingTime(int postPurgingTime)
{
    if (m_postPurgingTime == postPurgingTime)
        return;

    m_postPurgingTime = postPurgingTime;
    emit postPurgingTimeChanged(m_postPurgingTime);
}

int MachineData::getPostPurgingCountdown() const
{
    return m_postPurgingCountdown;
}

void MachineData::setPostPurgingActive(bool postPurgingActive)
{
    if (m_postPurgingActive == postPurgingActive)
        return;

    m_postPurgingActive = postPurgingActive;
    emit postPurgingActiveChanged(m_postPurgingActive);
}

int MachineData::getPostPurgingTime() const
{
    return m_postPurgingTime;
}

void MachineData::setAlarmBoardComError(short alarmBoardComError)
{
    if (m_alarmBoardComError == alarmBoardComError)
        return;

    m_alarmBoardComError = alarmBoardComError;
    emit alarmBoardComErrorChanged(m_alarmBoardComError);
}

void MachineData::setAlarmsState(bool alarmsState)
{
    if (m_alarmsState == alarmsState)
        return;

    m_alarmsState = alarmsState;
    emit alarmsStateChanged(m_alarmsState);
}

void MachineData::setUvLifePercent(short uvLifePercent)
{
    if (m_uvLifePercent == uvLifePercent)
        return;

    m_uvLifePercent = uvLifePercent;
    emit uvLifePercentChanged(m_uvLifePercent);
}

QString MachineData::getUvLifeLevelColorStrf() const
{
    return m_uvLifeLevelColorStrf;
}

void MachineData::setUvLifeLevelColorStrf(const QString &value)
{
    if (m_uvLifeLevelColorStrf == value)
        return;

    m_uvLifeLevelColorStrf = value;
    emit uvLifeLevelColorStrfChanged(value);
}

bool MachineData::getUvReplacementReminder() const
{
    return m_uvReplacementReminder;
}

void MachineData::setUvReplacementReminder(bool value)
{
    if(m_uvReplacementReminder == value)return;
    m_uvReplacementReminder = value;
    emit uvReplacementReminderChanged(value);
}

bool MachineData::getUvReplacementReminderSnoozed() const
{
    return m_uvReplacementReminderSnoozed;
}

void MachineData::setUvReplacementReminderSnoozed(bool value)
{
    if(m_uvReplacementReminderSnoozed == value)return;
    m_uvReplacementReminderSnoozed = value;
    emit uvReplacementReminderSnoozedChanged(value);
}

void MachineData::setUvLifeMinutes(int uvLifeMinutes)
{
    if (m_uvLifeMinutes == uvLifeMinutes)
        return;

    m_uvLifeMinutes = uvLifeMinutes;
    emit uvLifeMinutesChanged(m_uvLifeMinutes);
}

short MachineData::getUvLifePercent() const
{
    return m_uvLifePercent;
}

void MachineData::setUvTimeActive(bool uvTimeActive)
{
    if (m_uvTimeActive == uvTimeActive)
        return;

    m_uvTimeActive = uvTimeActive;
    emit uvTimeActiveChanged(m_uvTimeActive);
}

void MachineData::setUvTime(int uvTime)
{
    if (m_uvTime == uvTime)
        return;

    m_uvTime = uvTime;
    emit uvTimeChanged(m_uvTime);
}

void MachineData::setUvTimeCountdown(int uvTimeCountdown)
{
    if (m_uvTimeCountdown == uvTimeCountdown)
        return;

    m_uvTimeCountdown = uvTimeCountdown;
    emit uvTimeCountdownChanged(m_uvTimeCountdown);
}

void MachineData::setWarmingUpActive(bool warmingUpActive)
{
    if (m_warmingUpActive == warmingUpActive)
        return;

    m_warmingUpActive = warmingUpActive;
    emit warmingUpActiveChanged(m_warmingUpActive);
}

bool MachineData::getWarmingUpExecuted() const
{
    return m_warmingUpStateExecuted;
}

void MachineData::setWarmingUpExecuted(bool warmingUpExecuted)
{
    if(m_warmingUpStateExecuted == warmingUpExecuted) return;
    m_warmingUpStateExecuted = warmingUpExecuted;
    emit warmingUpExecutedChanged(m_warmingUpStateExecuted);
}

void MachineData::setWarmingUpTime(int warmingUpTime)
{
    if (m_warmingUpTime == warmingUpTime)
        return;

    m_warmingUpTime = warmingUpTime;
    emit warmingUpTimeChanged(m_warmingUpTime);
}

void MachineData::setWarmingUpCountdown(int warmingUpCountdown)
{
    if (m_warmingUpCountdown == warmingUpCountdown)
        return;

    m_warmingUpCountdown = warmingUpCountdown;
    emit warmingUpCountdownChanged(m_warmingUpCountdown);
}

bool MachineData::getPostPurgingActive() const
{
    return m_postPurgingActive;
}

short MachineData::getAlarmBoardComError() const
{
    return m_alarmBoardComError;
}

bool MachineData::getAlarmsState() const
{
    return m_alarmsState;
}

int MachineData::getUvLifeMinutes() const
{
    return m_uvLifeMinutes;
}

bool MachineData::getUvTimeActive() const
{
    return m_uvTimeActive;
}

int MachineData::getUvTime() const
{
    return m_uvTime;
}

int MachineData::getUvTimeCountdown() const
{
    return m_uvTimeCountdown;
}

void MachineData::setSashWindowMotorizeUpInterlocked(bool sashWindowMotorizeUpInterlocked)
{
    if (m_sashWindowMotorizeUpInterlocked == sashWindowMotorizeUpInterlocked)
        return;

    m_sashWindowMotorizeUpInterlocked = sashWindowMotorizeUpInterlocked;
    emit sashWindowMotorizeUpInterlockedChanged(m_sashWindowMotorizeUpInterlocked);
}

void MachineData::setSashWindowMotorizeDownInterlocked(bool sashWindowMotorizeDownInterlocked)
{
    if (m_sashWindowMotorizeDownInterlocked == sashWindowMotorizeDownInterlocked)
        return;

    m_sashWindowMotorizeDownInterlocked = sashWindowMotorizeDownInterlocked;
    emit sashWindowMotorizeDownInterlockedChanged(m_sashWindowMotorizeDownInterlocked);
}

void MachineData::setSashWindowMotorizeInstalled(bool sashWindowMotorizeInstalled)
{
    if (m_sashWindowMotorizeInstalled == sashWindowMotorizeInstalled)
        return;

    m_sashWindowMotorizeInstalled = sashWindowMotorizeInstalled;
    emit sashWindowMotorizeInstalledChanged(m_sashWindowMotorizeInstalled);
}

void MachineData::setOperationMode(short operationMode)
{
    if (m_operationMode == operationMode)
        return;

    m_operationMode = operationMode;
    emit operationModeChanged(m_operationMode);
}

bool MachineData::getWarmingUpActive() const
{
    return m_warmingUpActive;
}

int MachineData::getWarmingUpTime() const
{
    return m_warmingUpTime;
}

int MachineData::getWarmingUpCountdown() const
{
    return m_warmingUpCountdown;
}

bool MachineData::getSashWindowMotorizeUpInterlocked() const
{
    return m_sashWindowMotorizeUpInterlocked;
}

bool MachineData::getSashWindowMotorizeDownInterlocked() const
{
    return m_sashWindowMotorizeDownInterlocked;
}

bool MachineData::getSashWindowMotorizeInstalled() const
{
    return m_sashWindowMotorizeInstalled;
}

void MachineData::setTempAmbientStatus(short tempAmbientStatus)
{
    if (m_tempAmbientStatus == tempAmbientStatus)
        return;

    m_tempAmbientStatus = tempAmbientStatus;
    emit tempAmbientStatusChanged(m_tempAmbientStatus);
}

void MachineData::setFanPrimaryInterlocked(short fanPrimaryInterlocked)
{
    if (m_fanPrimaryInterlocked == fanPrimaryInterlocked)
        return;

    m_fanPrimaryInterlocked = fanPrimaryInterlocked;
    emit fanPrimaryInterlockedChanged(m_fanPrimaryInterlocked);
}

void MachineData::setUvInstalled(bool uvInstalled)
{
    if (m_uvInstalled == uvInstalled)
        return;

    m_uvInstalled = uvInstalled;
    emit uvInstalledChanged(m_uvInstalled);
}

void MachineData::setGasInstalled(bool gasInstalled)
{
    if (m_gasInstalled == gasInstalled)
        return;

    m_gasInstalled = gasInstalled;
    emit gasInstalledChanged(m_gasInstalled);
}

bool MachineData::getUvInstalled() const
{
    return m_uvInstalled;
}

void MachineData::setSocketInstalled(bool socketInstalled)
{
    if (m_socketInstalled == socketInstalled)
        return;

    m_socketInstalled = socketInstalled;
    emit socketInstalledChanged(m_socketInstalled);
}

bool MachineData::getGasInstalled() const
{
    return m_gasInstalled;
}

void MachineData::setSocketInterlocked(bool socketInterlocked)
{
    if (m_socketInterlocked == socketInterlocked)
        return;

    m_socketInterlocked = socketInterlocked;
    emit socketInterlockedChanged(m_socketInterlocked);
}

void MachineData::setLightInterlocked(bool lightInterlocked)
{
    if (m_lightInterlocked == lightInterlocked)
        return;

    m_lightInterlocked = lightInterlocked;
    emit lightInterlockedChanged(m_lightInterlocked);
}

void MachineData::setGasInterlocked(bool gasInterlocked)
{
    if (m_gasInterlocked == gasInterlocked)
        return;

    m_gasInterlocked = gasInterlocked;
    emit gasInterlockedChanged(m_gasInterlocked);
}

void MachineData::setUvInterlocked(bool uvInterlocked)
{
    if (m_uvInterlocked == uvInterlocked)
        return;

    m_uvInterlocked = uvInterlocked;
    emit uvInterlockedChanged(m_uvInterlocked);
}

void MachineData::setDataLogIsFull(bool dataLogIsFull)
{
    if (m_dataLogIsFull == dataLogIsFull)
        return;

    m_dataLogIsFull = dataLogIsFull;
    emit dataLogIsFullChanged(m_dataLogIsFull);
}

bool MachineData::getResourceMonitorLogEnable() const
{
    return m_resourceMonitorLogEnable;
}

bool MachineData::getResourceMonitorLogRunning() const
{
    return m_resourceMonitorLogRunning;
}

short MachineData::getResourceMonitorLogPeriod() const
{
    return m_resourceMonitorLogPeriod;
}

int MachineData::getResourceMonitorLogCount() const
{
    return m_resourceMonitorLogCount;
}

bool MachineData::getResourceMonitorLogIsFull() const
{
    return m_resourceMonitorLogIsFull;
}

void MachineData::setResourceMonitorLogEnable(bool value)
{
    if(m_resourceMonitorLogEnable == value)return;
    m_resourceMonitorLogEnable = value;
    emit resourceMonitorLogEnableChanged(value);
}

void MachineData::setResourceMonitorLogRunning(bool value)
{
    if(m_resourceMonitorLogRunning == value)return;
    m_resourceMonitorLogRunning = value;
    emit resourceMonitorLogRunningChanged(value);
}

void MachineData::setResourceMonitorLogCount(int value)
{
    if(m_resourceMonitorLogCount == value)return;
    m_resourceMonitorLogCount = value;
    emit resourceMonitorLogCountChanged(value);
}

void MachineData::setResourceMonitorLogPeriod(short value)
{
    if(m_resourceMonitorLogPeriod == value)return;
    m_resourceMonitorLogPeriod = value;
    emit resourceMonitorLogPeriodChanged(value);
}

void MachineData::setResourceMonitorLogIsFull(bool value)
{
    if(m_resourceMonitorLogIsFull == value)return;
    m_resourceMonitorLogIsFull = value;
    emit resourceMonitorLogIsFullChanged(value);
}

short MachineData::getOperationMode() const
{
    return m_operationMode;
}

short MachineData::getTempAmbientStatus() const
{
    return m_tempAmbientStatus;
}

bool MachineData::getFanPrimaryInterlocked() const
{
    return m_fanPrimaryInterlocked;
}

bool MachineData::getSocketInstalled() const
{
    return m_socketInstalled;
}

bool MachineData::getLightInterlocked() const
{
    return m_lightInterlocked;
}

bool MachineData::getSocketInterlocked() const
{
    return m_socketInterlocked;
}

bool MachineData::getGasInterlocked() const
{
    return m_gasInterlocked;
}

bool MachineData::getUvInterlocked() const
{
    return m_uvInterlocked;
}

void MachineData::setDataLogPeriod(short dataLogPeriod)
{
    if (m_dataLogPeriod == dataLogPeriod)
        return;

    m_dataLogPeriod = dataLogPeriod;
    emit dataLogPeriodChanged(m_dataLogPeriod);
}

bool MachineData::getDataLogIsFull() const
{
    return m_dataLogIsFull;
}

void MachineData::setDataLogCount(int dataLogCount)
{
    if (m_dataLogCount == dataLogCount)
        return;

    m_dataLogCount = dataLogCount;
    emit dataLogCountChanged(m_dataLogCount);
}

int MachineData::getDataLogCount() const
{
    return m_dataLogCount;
}

void MachineData::setDataLogEnable(bool dataLogEnable)
{
    if (m_dataLogEnable == dataLogEnable)
        return;

    m_dataLogEnable = dataLogEnable;
    emit dataLogEnableChanged(m_dataLogEnable);
}

void MachineData::setDataLogRunning(bool dataLogRunning)
{
    if (m_dataLogRunning == dataLogRunning)
        return;

    m_dataLogRunning = dataLogRunning;
    emit dataLogRunningChanged(m_dataLogRunning);
}

short MachineData::getDataLogPeriod() const
{
    return m_dataLogPeriod;
}

void MachineData::setBoardStatusCtpRtc(bool boardStatusCtpRtc)
{
    if (m_boardStatusCtpRtc == boardStatusCtpRtc)
        return;

    m_boardStatusCtpRtc = boardStatusCtpRtc;
    emit boardStatusCtpRtcChanged(m_boardStatusCtpRtc);
}

void MachineData::setBoardStatusParticleCounter(bool boardStatusParticleCounter)
{
    if(m_boardStatusParticleCounter == boardStatusParticleCounter)
        return;
    m_boardStatusParticleCounter = boardStatusParticleCounter;
    emit boardStatusParticleCounterChanged(m_boardStatusParticleCounter);
}

bool MachineData::getBoardStatusParticleCounter() const
{
    return m_boardStatusParticleCounter;
}

void MachineData::setBoardStatusCtpIoe(bool boardStatusCtpIoe)
{
    if (m_boardStatusCtpIoe == boardStatusCtpIoe)
        return;

    m_boardStatusCtpIoe = boardStatusCtpIoe;
    emit boardStatusCtpIoeChanged(m_boardStatusCtpIoe);
}

bool MachineData::getDataLogEnable() const
{
    return m_dataLogEnable;
}

bool MachineData::getDataLogRunning() const
{
    return m_dataLogRunning;
}

bool MachineData::getMagSW1State() const
{
    return m_magSwitchState[0];
}

bool MachineData::getMagSW2State() const
{
    return m_magSwitchState[1];
}

bool MachineData::getMagSW3State() const
{
    return m_magSwitchState[2];
}

bool MachineData::getMagSW4State() const
{
    return m_magSwitchState[3];
}

bool MachineData::getMagSW5State() const
{
    return m_magSwitchState[4];
}

bool MachineData::getMagSW6State() const
{
    return m_magSwitchState[5];
}

void MachineData::setBoardStatusPressureDiff(bool boardStatusPressureDiff)
{
    if (m_boardStatusPressureDiff == boardStatusPressureDiff)
        return;

    m_boardStatusPressureDiff = boardStatusPressureDiff;
    emit boardStatusPressureDiffChanged(m_boardStatusPressureDiff);
}

bool MachineData::getBoardStatusCtpRtc() const
{
    return m_boardStatusCtpRtc;
}

bool MachineData::getBoardStatusCtpIoe() const
{
    return m_boardStatusCtpIoe;
}

void MachineData::setBoardStatusRbmCom(bool boardStatusRbmCom)
{
    if (m_boardStatusRbmCom == boardStatusRbmCom)
        return;

    m_boardStatusRbmCom = boardStatusRbmCom;
    emit boardStatusRbmComChanged(m_boardStatusRbmCom);
}

bool MachineData::getBoardStatusPressureDiff() const
{
    return m_boardStatusPressureDiff;
}

void MachineData::setBoardStatusHybridAnalogOutput(bool boardStatusHybridAnalogOutput)
{
    if (m_boardStatusHybridAnalogOutput == boardStatusHybridAnalogOutput)
        return;

    m_boardStatusHybridAnalogOutput = boardStatusHybridAnalogOutput;
    emit boardStatusHybridAnalogOutputChanged(m_boardStatusHybridAnalogOutput);
}

bool MachineData::getBoardStatusHybridAnalogOutput2() const
{
    return m_boardStatusHybridAnalogOutput2;
}

void MachineData::setBoardStatusHybridAnalogOutput2(bool value)
{
    if(m_boardStatusHybridAnalogOutput2 == value)return;
    m_boardStatusHybridAnalogOutput2 = value;
    emit boardStatusHybridAnalogOutput2Changed(value);
}
bool MachineData::getBoardStatusRbmCom() const
{
    return m_boardStatusRbmCom;
}

void MachineData::setBoardStatusHybridAnalogInput(bool boardStatusHybridAnalogInput)
{
    if (m_boardStatusHybridAnalogInput == boardStatusHybridAnalogInput)
        return;

    m_boardStatusHybridAnalogInput = boardStatusHybridAnalogInput;
    emit boardStatusHybridAnalogInputChanged(m_boardStatusHybridAnalogInput);
}

bool MachineData::getBoardStatusHybridAnalogOutput() const
{
    return m_boardStatusHybridAnalogOutput;
}

void MachineData::setBoardStatusHybridDigitalInput(bool boardStatusHybridDigitalInput)
{
    if (m_boardStatusHybridDigitalInput == boardStatusHybridDigitalInput)
        return;

    m_boardStatusHybridDigitalInput = boardStatusHybridDigitalInput;
    emit boardStatusHybridDigitalInputChanged(m_boardStatusHybridDigitalInput);
}

bool MachineData::getBoardStatusHybridAnalogInput() const
{
    return m_boardStatusHybridAnalogInput;
}

void MachineData::setBoardStatusHybridDigitalRelay(bool boardStatusHybridDigitalRelay)
{
    if (m_boardStatusHybridDigitalRelay == boardStatusHybridDigitalRelay)
        return;

    m_boardStatusHybridDigitalRelay = boardStatusHybridDigitalRelay;
    emit boardStatusHybridDigitalRelayChanged(m_boardStatusHybridDigitalRelay);
}

bool MachineData::getBoardStatusHybridDigitalInput() const
{
    return m_boardStatusHybridDigitalInput;
}

void MachineData::setFanPrimaryStandbyDutyCycleField(short fanPrimaryStandbyDutyCycleField)
{
    if (m_fanPrimaryStandbyDutyCycleField == fanPrimaryStandbyDutyCycleField)
        return;

    m_fanPrimaryStandbyDutyCycleField = fanPrimaryStandbyDutyCycleField;
    //    emit fanPrimaryStandbyDutyCycleFieldChanged(m_fanPrimaryStandbyDutyCycleField);
}

void MachineData::setFanPrimaryStandbyRpmField(int fanPrimaryStandbyRpmField)
{
    if (m_fanPrimaryStandbyRpmField == fanPrimaryStandbyRpmField)
        return;

    m_fanPrimaryStandbyRpmField = fanPrimaryStandbyRpmField;
    //    emit fanPrimaryStandbyRpmFieldChanged(m_fanPrimaryStandbyRpmField);
}

void MachineData::setAirflowFactoryCalibrationState(int index, bool state)
{
    if(index < 0 || index >= MachineEnums::CalFactoryState_Total)return;
    if(m_airflowFactoryCalibrationState[index] == state) return;
    m_airflowFactoryCalibrationState[index] = state;
}

bool MachineData::getAirflowFactoryCalibrationState(int index)
{
    if(index < 0 || index >= MachineEnums::CalFactoryState_Total)return false;
    return m_airflowFactoryCalibrationState[index];
}

void MachineData::setAirflowFieldCalibrationState(short index, bool value)
{
    if(index < 0 || index >= MachineEnums::CalFieldState_Total)return;
    if(m_airflowFieldCalibrationState[index] == value) return;
    m_airflowFieldCalibrationState[index] = value;
}

bool MachineData::getAirflowFieldCalibrationState(short index)
{
    if(index < 0 || index >= MachineEnums::CalFieldState_Total)return false;
    return m_airflowFieldCalibrationState[index];
}

void MachineData::setMagSWState(short index, bool value)
{
    if(index > 5) return;
    if(m_magSwitchState[index] == value) return;

    m_magSwitchState[index] = value;

    emit magSWStateChanged(index, value);
}

void MachineData::setMeasurementUnitDuringCalib(short measurementUnitDuringCalib)
{
    if (m_measurementUnitDuringCalib == measurementUnitDuringCalib)
        return;

    m_measurementUnitDuringCalib = measurementUnitDuringCalib;
    emit measurementUnitDuringCalibChanged(m_measurementUnitDuringCalib);
}

void MachineData::setTemperatureCelcius(short temperatureCelcius)
{
    if (m_temperatureCelcius == temperatureCelcius)
        return;

    m_temperatureCelcius = temperatureCelcius;
    emit temperatureAdcChanged(m_temperatureCelcius);
}

void MachineData::setFanPrimaryStandbyDutyCycleFactory(short fanPrimaryStandbyDutyCycleFactory)
{
    if (m_fanPrimaryStandbyDutyCycleFactory == fanPrimaryStandbyDutyCycleFactory)
        return;

    m_fanPrimaryStandbyDutyCycleFactory = fanPrimaryStandbyDutyCycleFactory;
    //    emit fanPrimaryStandbyDutyCycleFactoryChanged(m_fanPrimaryStandbyDutyCycleFactory);
}

void MachineData::setFanPrimaryStandbyRpmFactory(int fanPrimaryStandbyRpmFactory)
{
    if (m_fanPrimaryStandbyRpmFactory == fanPrimaryStandbyRpmFactory)
        return;

    m_fanPrimaryStandbyRpmFactory = fanPrimaryStandbyRpmFactory;
    //        emit fanPrimaryStandbyRpmFactoryChanged(m_fanPrimaryStandbyRpmFactory);
}

void MachineData::setFanPrimaryNominalDutyCycleField(short fanPrimaryNominalDutyCycleField)
{
    if (m_fanPrimaryNominalDutyCycleField == fanPrimaryNominalDutyCycleField)
        return;

    m_fanPrimaryNominalDutyCycleField = fanPrimaryNominalDutyCycleField;
    //    emit fanPrimaryNominalDutyCycleFieldChanged(m_fanPrimaryNominalDutyCycleField);
}

void MachineData::setFanPrimaryNominalRpmField(int fanPrimaryNominalRpmField)
{
    if (m_fanPrimaryNominalRpmField == fanPrimaryNominalRpmField)
        return;

    m_fanPrimaryNominalRpmField = fanPrimaryNominalRpmField;
    //    emit fanPrimaryNominalRpmFieldChanged(m_fanPrimaryNominalRpmField);
}

void MachineData::setFanPrimaryMinimumDutyCycleFactory(short fanPrimaryMinimumDutyCycleFactory)
{
    if (m_fanPrimaryMinimumDutyCycleFactory == fanPrimaryMinimumDutyCycleFactory)
        return;

    m_fanPrimaryMinimumDutyCycleFactory = fanPrimaryMinimumDutyCycleFactory;
}

void MachineData::setFanPrimaryMinimumRpmFactory(int fanPrimaryMinimumRpmFactory)
{
    if (m_fanPrimaryMinimumRpmFactory == fanPrimaryMinimumRpmFactory)
        return;

    m_fanPrimaryMinimumRpmFactory = fanPrimaryMinimumRpmFactory;
}

void MachineData::setFanPrimaryMinimumDutyCycleField(short fanPrimaryMinimumDutyCycleField)
{
    if (m_fanPrimaryMinimumDutyCycleField == fanPrimaryMinimumDutyCycleField)
        return;

    m_fanPrimaryMinimumDutyCycleField = fanPrimaryMinimumDutyCycleField;
}

void MachineData::setFanPrimaryMinimumRpmField(int fanPrimaryMinimumRpmField)
{
    if (m_fanPrimaryMinimumRpmField == fanPrimaryMinimumRpmField)
        return;

    m_fanPrimaryMinimumRpmField = fanPrimaryMinimumRpmField;
}

void MachineData::setFanPrimaryNominalDutyCycleFactory(short fanPrimaryNominalDutyCycleFactory)
{
    if (m_fanPrimaryNominalDutyCycleFactory == fanPrimaryNominalDutyCycleFactory)
        return;

    m_fanPrimaryNominalDutyCycleFactory = fanPrimaryNominalDutyCycleFactory;
    //    emit fanPrimaryNominalDutyCycleFactoryChanged(m_fanPrimaryNominalDutyCycleFactory);
}

void MachineData::setFanPrimaryNominalRpmFactory(int fanPrimaryNominalRpmFactory)
{
    if (m_fanPrimaryNominalRpmFactory == fanPrimaryNominalRpmFactory)
        return;

    m_fanPrimaryNominalRpmFactory = fanPrimaryNominalRpmFactory;
    //    emit fanPrimaryNominalRpmFactoryChanged(m_fanPrimaryNominalRpmFactory);
}

void MachineData::setTemperature(short temperature)
{
    if (m_temperature == temperature)
        return;

    m_temperature = temperature;
    emit temperatureChanged(m_temperature);
}

int MachineData::getInflowLowLimitVelocity() const
{
    return m_ifaLowLimitVelocity;
}

void MachineData::setAirflowMonitorEnable(bool airflowMonitorEnable)
{
    if(m_airflowMonitorEnable == airflowMonitorEnable) return;
    m_airflowMonitorEnable = airflowMonitorEnable;
    emit airflowMonitorEnableChanged(m_airflowMonitorEnable);
}

void MachineData::setInflowLowLimitVelocity(int ifaLowLimitVelocity)
{
    if (m_ifaLowLimitVelocity == ifaLowLimitVelocity)
        return;

    m_ifaLowLimitVelocity = ifaLowLimitVelocity;
}

void MachineData::setAirflowCalibrationStatus(short airflowCalibrationMode)
{
    if (m_airflowCalibrationStatus == airflowCalibrationMode)
        return;

    m_airflowCalibrationStatus = airflowCalibrationMode;
    emit airflowCalibrationStatusChanged(m_airflowCalibrationStatus);
}

void MachineData::setInflowAdc(int ifaAdc)
{
    if (m_ifaAdc == ifaAdc)
        return;

    m_ifaAdc = ifaAdc;
    emit ifaAdcChanged(m_ifaAdc);
}

void MachineData::setInflowAdcConpensation(int ifaAdcConpensation)
{
    if (m_ifaAdcConpensation == ifaAdcConpensation)
        return;

    m_ifaAdcConpensation = ifaAdcConpensation;
    emit ifaAdcConpensationChanged(m_ifaAdcConpensation);
}

void MachineData::setInflowVelocityStr(const QString &ifaVelocityStr)
{
    if (m_ifaVelocityStr == ifaVelocityStr)
        return;

    m_ifaVelocityStr = ifaVelocityStr;
    emit ifaVelocityStrChanged(m_ifaVelocityStr);
}

void MachineData::setDownflowVelocityStr(const QString &dfaVelocityStr)
{
    if (m_dfaVelocityStr == dfaVelocityStr)
        return;

    m_dfaVelocityStr = dfaVelocityStr;
    emit dfaVelocityStrChanged(m_dfaVelocityStr);
}

void MachineData::setInflowSensorConstant(short value)
{
    if (m_ifaConstant == value)
        return;

    m_ifaConstant = value;
    emit inflowSensorConstantChanged(value);
}

void MachineData::setInflowTempCalib(short value)
{
    if (m_ifaTemperatureCalib == value)
        return;

    m_ifaTemperatureCalib = value;
    emit ifaTemperatureCalibChanged(value);
}

void MachineData::setInflowTempCalibAdc(short value)
{
    if (m_ifaTemperatureCalibAdc == value)
        return;

    m_ifaTemperatureCalibAdc = value;
}

void MachineData::setInflowAdcPointFactory(short point, int value)
{
    if(point >= 3 || point < 0) return;

    if (m_ifaAdcPointFactory[point] == value)
        return;

    m_ifaAdcPointFactory[point] = value;
    //    emit ifaAdcConpensationChanged(m_ifaAdcConpensation);
}

void MachineData::setInflowVelocityPointFactory(short point, int value)
{
    if(point >= 3 || point < 0) return;

    if (m_ifaVelocityPointFactory[point] == value)
        return;

    m_ifaVelocityPointFactory[point] = value;
    //    emit ifaAdcConpensationChanged(m_ifaAdcConpensation);
}

void MachineData::setInflowAdcPointField(short point, int value)
{
    if(point >= 3 || point < 0) return;

    if (m_ifaAdcPointField[point] == value)
        return;

    m_ifaAdcPointField[point] = value;
    //    emit ifaAdcConpensationChanged(m_ifaAdcConpensation);
}

void MachineData::setInflowVelocityPointField(short point, int value)
{
    if(point >= 3 || point < 0) return;

    if (m_ifaVelocityPointField[point] == value)
        return;

    m_ifaVelocityPointField[point] = value;
    //    emit ifaAdcConpensationChanged(m_ifaAdcConpensation);
}

void MachineData::setDownflowVelocityPointFactory(short point, int value)
{
    if(point >= 3 || point < 0) return;

    if (m_dfaVelocityPointFactory[point] == value)
        return;

    m_dfaVelocityPointFactory[point] = value;
    //    emit ifaAdcConpensationChanged(m_ifaAdcConpensation);
}

void MachineData::setDownflowVelocityPointField(short point, int value)
{
    if(point >= 3 || point < 0) return;

    if (m_dfaVelocityPointField[point] == value)
        return;

    m_dfaVelocityPointField[point] = value;
    //    emit ifaAdcConpensationChanged(m_ifaAdcConpensation);
}

short MachineData::getAirflowCalibrationStatus() const
{
    return m_airflowCalibrationStatus;
}

bool MachineData::getBoardStatusHybridDigitalRelay() const
{
    return m_boardStatusHybridDigitalRelay;
}

short MachineData::getFanPrimaryStandbyDutyCycleField() const
{
    return m_fanPrimaryStandbyDutyCycleField;
}

int MachineData::getFanPrimaryStandbyRpmField() const
{
    return m_fanPrimaryStandbyRpmField;
}

short MachineData::getMeasurementUnitDuringCalib() const
{
    return m_measurementUnitDuringCalib;
}

short MachineData::getTemperatureCelcius() const
{
    return m_temperatureCelcius;
}

short MachineData::getFanPrimaryStandbyDutyCycleFactory() const
{
    return m_fanPrimaryStandbyDutyCycleFactory;
}

int MachineData::getFanPrimaryStandbyRpmFactory() const
{
    return m_fanPrimaryStandbyRpmFactory;
}

short MachineData::getFanPrimaryNominalDutyCycleField() const
{
    return m_fanPrimaryNominalDutyCycleField;
}

int MachineData::getFanPrimaryNominalRpmField() const
{
    return m_fanPrimaryNominalRpmField;
}

short MachineData::getFanPrimaryNominalDutyCycleFactory() const
{
    return m_fanPrimaryNominalDutyCycleFactory;
}

int MachineData::getFanPrimaryNominalRpmFactory() const
{
    return m_fanPrimaryNominalRpmFactory;
}

short MachineData::getFanPrimaryMinimumDutyCycleFactory() const
{
    return m_fanPrimaryMinimumDutyCycleFactory;
}

int MachineData::getFanPrimaryMinimumRpmFactory() const
{
    return m_fanPrimaryMinimumRpmFactory;
}

short MachineData::getFanPrimaryMinimumDutyCycleField() const
{
    return m_fanPrimaryMinimumDutyCycleField;
}

int MachineData::getFanPrimaryMinimumRpmField() const
{
    return m_fanPrimaryMinimumRpmField;
}

int MachineData::getFanPrimaryStandbyRpm() const
{
    return m_fanPrimaryStandbyRpm;
}

short MachineData::getTemperature() const
{
    return m_temperature;
}

void MachineData::setInflowVelocity(int ifaVelocity)
{
    if (m_ifaVelocity == ifaVelocity)
        return;

    m_ifaVelocity = ifaVelocity;
    emit ifaVelocityChanged(m_ifaVelocity);
}

int MachineData::getInflowAdc() const
{
    return m_ifaAdc;
}

int MachineData::getInflowAdcConpensation() const
{
    return m_ifaAdcConpensation;
}

QString MachineData::getInflowVelocityStr() const
{
    return m_ifaVelocityStr;
}

QString MachineData::getDownflowVelocityStr() const
{
    return m_dfaVelocityStr;
}

int MachineData::getDownflowVelocity() const
{
    return m_dfaVelocity;
}

short MachineData::getInflowSensorConstant()
{
    return m_ifaConstant;
}

int MachineData::getInflowTempCalib()
{
    return m_ifaTemperatureCalib;
}

int MachineData::getInflowTempCalibAdc()
{
    return m_ifaTemperatureCalibAdc;
}

int MachineData::getInflowAdcPointFactory(short point)
{
    if(point >= 3 || point < 0) return 0;

    return m_ifaAdcPointFactory[point];
}

int MachineData::getInflowVelocityPointFactory(short point)
{
    if(point >= 3 || point < 0) return 0;
    return m_ifaVelocityPointFactory[point];
}

int MachineData::getInflowAdcPointField(short point)
{
    if(point >= 3 || point < 0) return 0;
    return m_ifaAdcPointField[point];
}

int MachineData::getInflowVelocityPointField(short point)
{
    if(point >= 3 || point < 0) return 0;
    return m_ifaVelocityPointField[point];
}

int MachineData::getDownflowVelocityPointFactory(short point)
{
    if(point >= 3 || point < 0) return 0;
    return m_dfaVelocityPointFactory[point];
}

int MachineData::getDownflowVelocityPointField(short point)
{
    if(point >= 3 || point < 0) return 0;
    return m_dfaVelocityPointField[point];
}

void MachineData::setDownflowVelocity(int dfaVelocity)
{
    if (m_dfaVelocity == dfaVelocity)
        return;

    m_dfaVelocity = dfaVelocity;
    emit dfaVelocityChanged(m_dfaVelocity);
}

void MachineData::setFanPrimaryRpm(int value)
{
    if (m_fanPrimaryRpm == value)
        return;

    m_fanPrimaryRpm = value;
    emit fanPrimaryRpmChanged(m_fanPrimaryRpm);
}

void MachineData::setFanPrimaryNominalDutyCycle(short value)
{
    if (m_fanPrimaryNominalDutyCycle == value)
        return;

    m_fanPrimaryNominalDutyCycle = value;
    //    emit fanPrimaryNominalDutyCycleChanged(m_fanPrimaryNominalDutyCycle);
}

void MachineData::setFanPrimaryNominalRpm(short value)
{
    if (m_fanPrimaryNominalRpm == value)
        return;

    m_fanPrimaryNominalRpm = value;
    //    emit fanPrimaryNominalRpmChanged(m_fanPrimaryNominalRpm);
}

void MachineData::setFanPrimaryMinimumDutyCycle(short value)
{
    if (m_fanPrimaryMinimumDutyCycle == value)
        return;

    m_fanPrimaryMinimumDutyCycle = value;
    //    emit fanPrimaryMinimumDutyCycleChanged(m_fanPrimaryMinimumDutyCycle);
}

void MachineData::setFanPrimaryMinimumRpm(short value)
{
    if (m_fanPrimaryMinimumRpm == value)
        return;

    m_fanPrimaryMinimumRpm = value;
    //    emit fanPrimaryMinimumRpmChanged(m_fanPrimaryMinimumRpm);
}

void MachineData::setFanPrimaryStandbyDutyCycle(short value)
{
    if (m_fanPrimaryStandbyDutyCycle == value)
        return;

    m_fanPrimaryStandbyDutyCycle = value;
    //    emit fanPrimaryStandbyDutyCycleChanged(m_fanPrimaryStandbyDutyCycle);
}

void MachineData::setFanPrimaryStandbyRpm(int fanPrimaryStandbyRpm)
{
    if (m_fanPrimaryStandbyRpm == fanPrimaryStandbyRpm)
        return;

    m_fanPrimaryStandbyRpm = fanPrimaryStandbyRpm;
    //    emit fanPrimaryStandbyRpmChanged(m_fanPrimaryStandbyRpm);
}

int MachineData::getInflowVelocity() const
{
    return m_ifaVelocity;
}

void MachineData::setMachineProfileName(const QString &machineProfileName)
{
    if (m_machineProfileName == machineProfileName)
        return;

    m_machineProfileName = machineProfileName;
    emit machineProfileNameChanged(m_machineProfileName);
}

QJsonObject MachineData::getMachineProfile() const
{
    return m_machineProfile;
}

void MachineData::setMachineProfile(QJsonObject machineProfile)
{
    if (m_machineProfile == machineProfile)
        return;

    m_machineProfile = machineProfile;
    emit machineProfileChanged(m_machineProfile);
}

int MachineData::getFanPrimaryRpm() const
{
    return m_fanPrimaryRpm;
}

short MachineData::getFanPrimaryNominalDutyCycle() const
{
    return m_fanPrimaryNominalDutyCycle;
}

int MachineData::getFanPrimaryNominalRpm() const
{
    return m_fanPrimaryNominalRpm;
}

short MachineData::getFanPrimaryMinimumDutyCycle() const
{
    return m_fanPrimaryMinimumDutyCycle;
}

int MachineData::getFanPrimaryMinimumRpm() const
{
    return m_fanPrimaryMinimumRpm;
}

short MachineData::getFanPrimaryStandbyDutyCycle() const
{
    return m_fanPrimaryStandbyDutyCycle;
}

void MachineData::setTimeClockPeriod(short timeClockPeriod)
{
    if (m_timeClockPeriod == timeClockPeriod)
        return;

    m_timeClockPeriod = timeClockPeriod;
    emit timeClockPeriodChanged(m_timeClockPeriod);
}

bool MachineData::getAirflowMonitorEnable() const
{
    return m_airflowMonitorEnable;
}

QString MachineData::getMachineProfileName() const
{
    return m_machineProfileName;
}

void MachineData::setTimeZone(const QString &timeZone)
{
    if (m_timeZone == timeZone)
        return;

    m_timeZone = timeZone;
    emit timeZoneChanged(m_timeZone);
}

short MachineData::getTimeClockPeriod() const
{
    return m_timeClockPeriod;
}

void MachineData::setLanguage(const QString &language)
{
    if (m_language == language)
        return;

    m_language = language;
    emit languageChanged(m_language);
}

QString MachineData::getTimeZone() const
{
    return m_timeZone;
}

void MachineData::setLcdBrightnessDelayToDimm(short lcdBrightnessDelayToDimm)
{
    if (m_lcdBrightnessDelayToDimm == lcdBrightnessDelayToDimm)
        return;

    m_lcdBrightnessDelayToDimm = lcdBrightnessDelayToDimm;
    emit lcdBrightnessDelayToDimmChanged(m_lcdBrightnessDelayToDimm);
}

QString MachineData::getLanguage() const
{
    return m_language;
}

void MachineData::setLcdBrightnessLevelUser(short lcdBrightnessLevelUser)
{
    if (m_lcdBrightnessLevelUser == lcdBrightnessLevelUser)
        return;

    m_lcdBrightnessLevelUser = lcdBrightnessLevelUser;
    emit lcdBrightnessLevelUserChanged(m_lcdBrightnessLevelUser);
}

void MachineData::setLcdBrightnessLevel(short lcdBrightnessLevel)
{
    if (m_lcdBrightnessLevel == lcdBrightnessLevel)
        return;

    m_lcdBrightnessLevel = lcdBrightnessLevel;
    emit lcdBrightnessLevelChanged(m_lcdBrightnessLevel);
}

short MachineData::getLcdBrightnessDelayToDimm() const
{
    return m_lcdBrightnessDelayToDimm;
}

//void MachineData::setUnitModelID(int unitModelID)
//{
//    if (m_unitModelID == unitModelID)
//        return;

//    m_unitModelID = unitModelID;
//    emit unitModelIDChanged(m_unitModelID);
//}

void MachineData::setMachineModelName(const QString &unitModelName)
{
    if (m_unitModelName == unitModelName)
        return;

    m_unitModelName = unitModelName;
    emit machineModelNameChanged(m_unitModelName);
}

void MachineData::setFanPrimaryDutyCycle(short value)
{
    if (m_fanPrimaryDutyCycle == value)
        return;

    m_fanPrimaryDutyCycle = value;
    emit fanPrimaryDutyCycleChanged(m_fanPrimaryDutyCycle);
}

QString MachineData::getMachineModelName() const
{
    return m_unitModelName;
}

//int MachineData::getUnitModelID() const
//{
//    return m_unitModelID;
//}

QString MachineData::getMachineClassName() const
{
    return m_unitClassName;
}

void MachineData::setMachineClassName(const QString &unitClassName)
{
    if (m_unitClassName == unitClassName)
        return;

    m_unitClassName = unitClassName;
    emit machineClassNameChanged(m_unitClassName);
}

short MachineData::getLcdBrightnessLevelUser() const
{
    return m_lcdBrightnessLevelUser;
}

short MachineData::getLcdBrightnessLevel() const
{
    return m_lcdBrightnessLevel;
}

void MachineData::setFanPrimaryState(short fanPrimaryState)
{
    if (m_fanPrimaryState == fanPrimaryState)
        return;

    m_fanPrimaryState = fanPrimaryState;
    emit fanPrimaryStateChanged(m_fanPrimaryState);
}

void MachineData::setLightState(short lightState)
{
    if (m_lightState == lightState)
        return;

    m_lightState = lightState;
    emit lightStateChanged(m_lightState);
}

void MachineData::setSocketState(short socketState)
{
    if (m_socketState == socketState)
        return;

    m_socketState = socketState;
    emit socketStateChanged(m_socketState);
}

void MachineData::setGasState(short gasState)
{
    if (m_gasState == gasState)
        return;

    m_gasState = gasState;
    emit gasStateChanged(m_gasState);
}

void MachineData::setUvState(short uvState)
{
    if (m_uvState == uvState)
        return;

    m_uvState = uvState;
    emit uvStateChanged(m_uvState);
}

void MachineData::setMuteAlarmState(short muteAlarmState)
{
    if (m_muteAlarmState == muteAlarmState)
        return;

    m_muteAlarmState = muteAlarmState;
    emit muteAlarmStateChanged(m_muteAlarmState);
}

void MachineData::setSashWindowState(short sashWindowState)
{
    if (m_sashWindowState == sashWindowState)
        return;

    m_sashWindowState = sashWindowState;
    emit sashWindowStateChanged(m_sashWindowState);
}

short MachineData::getSashWindowStateSample(short index) const
{
    if(index >= 5 || index < 0) return 0;
    return m_sashWindowStateSample[index];
}

void MachineData::setSashWindowStateSample(short sashWindowState, short index)
{
    if(index >= 5 || index < 0) return;

    if (m_sashWindowStateSample[index] == sashWindowState)
        return;

    m_sashWindowStateSample[index] = sashWindowState;
}

bool MachineData::getSashWindowStateChangedValid() const
{
    return m_sashWindowStateChangedValid;
}

void MachineData::setSashWindowStateChangedValid(bool value)
{
    if (m_sashWindowStateChangedValid == value)
        return;

    m_sashWindowStateChangedValid = value;
}
void MachineData::setSashWindowPrevState(short sashMotorizeState)
{
    if (m_sashWindowPrevState == sashMotorizeState)
        return;

    m_sashWindowPrevState = sashMotorizeState;
    emit sashWindowPrevStateChanged(m_sashWindowPrevState);
}
void MachineData::setSashWindowMotorizeState(short sashMotorizeState)
{
    if (m_sashWindowMotorizeState == sashMotorizeState)
        return;

    m_sashWindowMotorizeState = sashMotorizeState;
    emit sashWindowMotorizeStateChanged(m_sashWindowMotorizeState);
}

void MachineData::setExhaustContactState(short exhaustContactState)
{
    if (m_exhaustContactState == exhaustContactState)
        return;

    m_exhaustContactState = exhaustContactState;
    emit exhaustContactStateChanged(m_exhaustContactState);
}

void MachineData::setAlarmContactState(short alarmContactState)
{
    if (m_alarmContactState == alarmContactState)
        return;

    m_alarmContactState = alarmContactState;
    emit alarmContactStateChanged(m_alarmContactState);
}

void MachineData::setLightIntensity(short lightIntensity)
{
    if (m_lightIntensity == lightIntensity)
        return;

    m_lightIntensity = lightIntensity;
    emit lightIntensityChanged(m_lightIntensity);
}

void MachineData::setAlarmInflowLow(short alarmInflowLow)
{
    if (m_alarmInflowLow == alarmInflowLow)
        return;

    m_alarmInflowLow = alarmInflowLow;
    emit alarmInflowLowChanged(m_alarmInflowLow);
}

void MachineData::setAlarmSash(short alarmSash)
{
    if (m_alarmSash == alarmSash)
        return;

    m_alarmSash = alarmSash;
    emit alarmSashChanged(m_alarmSash);
}

short MachineData::getAlarmStandbyFanOff() const
{
    return m_alarmStandbyFanOff;
}

void MachineData::setAlarmStandbyFanOff(short alarm)
{
    if (m_alarmStandbyFanOff == alarm)
        return;

    m_alarmStandbyFanOff = alarm;
    emit alarmStandbyFanOffChanged(m_alarmStandbyFanOff);
}

short MachineData::getAlarmExperimentTimerIsOver() const
{
    return m_alarmExperimentTimerIsOver;
}

void MachineData::setAlarmExperimentTimerIsOver(short value)
{
    if(m_alarmExperimentTimerIsOver == value)return;
    m_alarmExperimentTimerIsOver = value;
    emit alarmExperimentTimerIsOverChanged(value);
}

void MachineData::setTemperatureAdc(int temperatureAdc)
{
    if (m_temperatureAdc == temperatureAdc)
        return;

    m_temperatureAdc = temperatureAdc;
    emit temperatureAdcChanged(m_temperatureAdc);
}

void MachineData::setTemperatureValueStrf(const QString &temperatureValueStrf)
{
    if (m_temperatureValueStrf == temperatureValueStrf)
        return;

    m_temperatureValueStrf = temperatureValueStrf;
    emit temperatureValueStrfChanged(m_temperatureValueStrf);
}

void MachineData::setMeasurementUnit(short measurementUnit)
{
    if (m_measurementUnit == measurementUnit)
        return;

    m_measurementUnit = measurementUnit;
    emit measurementUnitChanged(m_measurementUnit);
}

short MachineData::getFanPrimaryDutyCycle() const
{
    return m_fanPrimaryDutyCycle;
}


////////////////////////////////////EXHAUST_PRESSURE_MONITOR
//int MachineData::dataExhPressureActualPa() const
//{
//    return m_dataExhPressureActualPa;
//}

//void MachineData::setDataExhPressureActualPa(int newVal)
//{
//    if(m_dataExhPressureActualPa == newVal) return;
//    m_dataExhPressureActualPa = newVal;
//    emit exhPressureActualPaChanged();
//}

int MachineData::getEscoLockServiceEnable() const
{
    return m_escoLockServiceEnable;
}

void MachineData::setCertificationExpiredValid(bool certificationExpiredValid)
{
    if (m_certificationExpiredValid == certificationExpiredValid)
        return;

    m_certificationExpiredValid = certificationExpiredValid;
    emit certificationExpiredValidChanged(m_certificationExpiredValid);
}
