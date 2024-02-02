#ifndef BLOWERREGALECMEON_H
#define BLOWERREGALECMEON_H

#include "../ClassDriver.h"
#include <QtSerialPort/QSerialPort>

class BlowerRegalECMEON : public ClassDriver
{
    Q_OBJECT
public:
    BlowerRegalECMEON(QObject *parent = nullptr);
    ~BlowerRegalECMEON();

    //    enum BlowerEcmDirection {
    //        BLOWER_REGAL_ECM_DIRECTION_CLW,
    //        BLOWER_REGAL_ECM_DIRECTION_CCW
    //    };

    enum BlowerEONControlMode {
        CONTROL_MODE_TORQUE,
        CONTROL_MODE_AIRVOLUME};

    void setSerialComm(QSerialPort * serial);

    int start();
    int stop();
    int setControlMode(int newVal, int lowValue, int highValue);
    int setSpeedRegulation(int newVal);

    int getControlMode(int *mode);
    int getSpeed(int *rpm);
    int getSpeedRpm();
    int getFaultStatus(int *fault);
    int getTotalRunTime(int *totRunTime);

    int getDemand(int *demand);
    int getDemandHighLimit(int *demand);
    int getDemandLowLimit(int *demand);

    int getDemand();
    int getDemandHighLimit();
    int getDemandLowLimit();

    void setDutyCycle(int newVal);
    void setInterlock(int value);
    int dutyCycle();

    void setDutyCycleLimit(int value);

signals:
    void dutyCycleChanged(int value);
    void rpmChanged(int value);
    void interlockChanged(int value);

private:
    QSerialPort* serialComm; //forwardPointer
    unsigned char m_controlMode = 0;
    int m_demand = 0;
    int m_speedRpm = 0;

    int m_highDemandLimit = 0;
    int m_lowDemandLimit = 0;

    int m_interlock = 0;
    int m_dutyCycle = 0;
    int m_dutyCycleLimit = 100;

    void CRC16(QByteArray &byte, QByteArray& checksum);
    bool isChecksumValid(QByteArray byte);

    QByteArray intToQByte16(int newVal);

    void debugPrintCommand(const QString &title, const QByteArray &cmd);

    bool isPortValid() const;
    double __map(double x, double in_min, double in_max, double out_min, double out_max) const;
};

#endif // BLOWERREGALECMEON_H
