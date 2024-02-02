#include <cmath>
#include <QDebug>
#include "BlowerRegalECMEON.h"

/*
Communication protocol
    - Communication data format
    - 11bits data format for asynchronous communication:
        > 1bit for start bit
        > 8bits for data
        > 1bits for stop
    - Baud rate       4800bits/s
    - Check format	CRC16 Modbus (https://www.tahapaksu.com/crc/)
    - Slave address	0x15
*/

#define ECM_SLAVE_ADDRESS_EON               0x15
#define ECM_MASTER_CMD_ACK_CODE             0x20
#define ECM_SLAVE_CMD_ACK_CODE              0x10

/// FUNCTION CODE
#define ECM_CMD_SET_START_MOTOR             0x41
#define ECM_CMD_SET_STOP_MOTOR              0x42
#define ECM_CMD_SET_CONTROL_MODE            0x38
#define ECM_CMD_SET_SPEED_REGULATION        0x44

#define ECM_CMD_REQ_CONTROL_MODE            0x3A
#define ECM_CMD_REQ_CURRENT_SPEED           0x45
#define ECM_CMD_REQ_CURRENT_FAULT           0x50
#define ECM_CMD_REQ_TOTAL_RUNTIME           0x59

/// CONSTANT
#define ECM_CONST_BYTE_READ_CONTROL_MODE        0x05
#define ECM_CONST_OFFSET_ADDRS_CURRENT_SPEED    0x01
#define ECM_CONST_CONTROL_MODE_TORQUE           0x55
#define ECM_CONST_CONTROL_MODE_AIRFLOW          0x22

#define ECM_CONST_FAULT_UNUSED_01           0x0001
#define ECM_CONST_FAULT_OVER_VOLTAGE        0x0002
#define ECM_CONST_FAULT_UNDER_VOLTAGE       0x0004
#define ECM_CONST_FAULT_STARTUP_FAILURE     0x0008
#define ECM_CONST_FAULT_UNUSED_02           0x0010
#define ECM_CONST_FAULT_OVER_TEMP           0x0020
#define ECM_CONST_FAULT_OVER_CURRENT        0x0040
#define ECM_CONST_FAULT_UNSUED_03           0x0080
#define ECM_CONST_FAULT_UNSUED_04           0x0100
#define ECM_CONST_FAULT_UNSUED_05           0x0200
#define ECM_CONST_FAULT_UNUSED_06           0x0400
#define ECM_CONST_FAULT_CURRENT_SENS_FAIL   0x0800 //Current Sensor failure
#define ECM_CONST_FAULT_USELF_CHECK_FAIL    0x1000 //Micro self check failure
#define ECM_CONST_FAULT_UNUSED_07           0x2000
#define ECM_CONST_FAULT_UNUSED_08           0x4000
#define ECM_CONST_FAULT_UNUSED_09           0x8000

/// SLAVE RESPONSE DATA LENGTH
#define ECM_RESP_LENGTH_SET_START_MOTOR        5    //15 41 10 51 98
#define ECM_RESP_LENGTH_SET_STOP_MOTOR         5    //15 42 10 51 68
#define ECM_RESP_LENGTH_SET_CONTROL_MODE       10   //15 38 10 55 FF FF 00 00 36 43
#define ECM_RESP_LENGTH_SET_SPEED_REGULATION   8    //15 44 10 55 FF 7F E6 11
#define ECM_RESP_LENGTH_REQ_CONTROL_MODE       11   //15 3A 10 05 55 FF FF 00 00 66 B7
#define ECM_RESP_LENGTH_REQ_CURRENT_SPEED      8    //15 45 10 01 00 00 9A 11
#define ECM_RESP_LENGTH_REQ_CURRENT_FAULT      7    //15 50 10 00 00 39 06
#define ECM_RESP_LENGTH_REQ_TOTAL_RUNTIME      9    //15 59 10 00 00 00 00 92 CB

//RESPONSE_TIME
#define ECM_TRANS_RESPONSE_TIME             200 //ms
#define ECM_TRANS_RESPONSE_TIME_EACH_BUFFER 50 //ms

BlowerRegalECMEON::BlowerRegalECMEON(QObject *parent)
    : ClassDriver (parent)
{
    m_address           = ECM_SLAVE_ADDRESS_EON;
    //    m_protocolVersion   = 2;
    serialComm          = nullptr;
}

BlowerRegalECMEON::~BlowerRegalECMEON()
{

}

void BlowerRegalECMEON::setSerialComm(QSerialPort *serial)
{
    serialComm = serial;
}

int BlowerRegalECMEON::start()
{
    if (!isPortValid()) return -1;

    QByteArray cmd;
    cmd.append(m_address);
    cmd.append(ECM_CMD_SET_START_MOTOR);
    cmd.append(ECM_MASTER_CMD_ACK_CODE);

    //    printf("BlowerRegalECM::stop Command - byte: ");
    //    for (int i=0; i<cmd.length(); i++) {
    //        printf("%02X ", static_cast<uchar>(cmd.at(i)));
    //    }
    //    printf("\n");
    //    fflush(stdout);

    {
        QByteArray checksum;
        CRC16(cmd, checksum);
        cmd.append(checksum);
    }

    //    printf("BlowerRegalECMEON::start Command - byte: ");
    //    for (int i=0; i<cmd.length(); i++) {
    //        printf("%02X ", cmd.at(i));
    //    }
    //    printf("\n");

    serialComm->write(cmd);
    if(serialComm->waitForBytesWritten(ECM_TRANS_RESPONSE_TIME)){
        if(serialComm->waitForReadyRead(ECM_TRANS_RESPONSE_TIME)){

            QByteArray response;
            while (serialComm->waitForReadyRead(ECM_TRANS_RESPONSE_TIME_EACH_BUFFER)) {
                response += serialComm->readAll();
            }

            //            printf("BlowerRegalECMEON::start Response - byte: ");
            //            for (int i=0; i<response.length(); i++) {
            //                printf("%02X ", static_cast<uchar>(response.at(i)));
            //            }
            //            printf("\n");

            if (response.length() == ECM_RESP_LENGTH_SET_START_MOTOR){
                if(isChecksumValid(response)){
                    return -1;
                }else return -1;
            }else return -1;
        }else return -1;
    }else return -1;
    return 0;
}

int BlowerRegalECMEON::stop()
{
    //    qDebug() << "int BlowerRegalECMEON::stop()";
    if (!isPortValid()) return -1;
    //    qDebug() << "int BlowerRegalECMEON::stop() 1";

    QByteArray cmd;
    cmd.append(m_address);
    cmd.append(ECM_CMD_SET_STOP_MOTOR);
    cmd.append(ECM_MASTER_CMD_ACK_CODE);

    //    printf("BlowerRegalECM::stop Command - byte: ");
    //    for (int i=0; i<cmd.length(); i++) {
    //        printf("%02X ", static_cast<uchar>(cmd.at(i)));
    //    }
    //    printf("\n");
    //    fflush(stdout);

    {
        QByteArray checksum;
        CRC16(cmd, checksum);
        cmd.append(checksum);
    }

    //    printf("BlowerRegalECMEON::stop Command - byte: ");
    //    for (int i=0; i<cmd.length(); i++) {
    //        printf("%02X ", static_cast<uchar>(cmd.at(i)));
    //    }
    //    printf("\n");
    //    fflush(stdout);

    serialComm->write(cmd);
    if(serialComm->waitForBytesWritten(ECM_TRANS_RESPONSE_TIME)){
        if(serialComm->waitForReadyRead(ECM_TRANS_RESPONSE_TIME)){

            QByteArray response;
            while (serialComm->waitForReadyRead(ECM_TRANS_RESPONSE_TIME_EACH_BUFFER)) {
                response += serialComm->readAll();
            }

            //            printf("BlowerRegalECMEON::stop Response - byte: ");
            //            for (int i=0; i<response.length(); i++) {
            //                printf("%02X ", static_cast<uchar>(response.at(i)));
            //            }
            //            printf("\n");
            //            fflush(stdout);
            /// Filter by data received length
            if(response.length() == ECM_RESP_LENGTH_SET_STOP_MOTOR){
                if(isChecksumValid(response)){

                }else return -1;
            }else return -1;
        }else return -1;
    }else return -1;
    return 0;
}

int BlowerRegalECMEON::setControlMode(int newVal, int lowValue, int highValue)
{
    qDebug() << "int BlowerRegalECMEON::setControlMode()";
    if (!isPortValid()) return -1;
    qDebug() << "int BlowerRegalECMEON::stop() 1";

    QByteArray cmd;
    cmd.append(m_address);
    cmd.append(ECM_CMD_SET_CONTROL_MODE);
    cmd.append(ECM_MASTER_CMD_ACK_CODE);

    if(newVal == CONTROL_MODE_AIRVOLUME)
        cmd.append(ECM_CONST_CONTROL_MODE_AIRFLOW);
    else
        cmd.append(ECM_CONST_CONTROL_MODE_TORQUE);

    cmd.append(static_cast<uchar>(highValue));
    cmd.append(static_cast<uchar>(highValue >> 8));
    cmd.append(static_cast<uchar>(lowValue));
    cmd.append(static_cast<uchar>(lowValue >> 8));

    printf("BlowerRegalECM::setControlMode Command - byte: ");
    for (int i=0; i<cmd.length(); i++) {
        printf("%02X ", static_cast<uchar>(cmd.at(i)));
    }
    printf("\n");
    fflush(stdout);

    {
        QByteArray checksum;
        CRC16(cmd, checksum);
        cmd.append(checksum);
    }

    printf("BlowerRegalECMEON::setControlMode Command - byte: ");
    for (int i=0; i<cmd.length(); i++) {
        printf("%02X ", static_cast<uchar>(cmd.at(i)));
    }
    printf("\n");
    fflush(stdout);

    serialComm->write(cmd);
    if(serialComm->waitForBytesWritten(ECM_TRANS_RESPONSE_TIME)){
        if(serialComm->waitForReadyRead(ECM_TRANS_RESPONSE_TIME)){

            QByteArray response;
            while (serialComm->waitForReadyRead(ECM_TRANS_RESPONSE_TIME_EACH_BUFFER)) {
                response += serialComm->readAll();
            }

            printf("BlowerRegalECMEON::setControlMode Response - byte: ");
            for (int i=0; i<response.length(); i++) {
                printf("%02X ", static_cast<uchar>(response.at(i)));
            }
            printf("\n");
            fflush(stdout);

            /// Filter by data received length
            if(response.length() == ECM_RESP_LENGTH_SET_CONTROL_MODE){
                if(isChecksumValid(response)){
                    m_controlMode = newVal;
                    m_highDemandLimit = highValue;
                    m_lowDemandLimit = lowValue;
                }else return -1;
            }else return -1;
        }else return -1;
    }else return -1;
    return 0;
}

int BlowerRegalECMEON::setSpeedRegulation(int newVal)
{
    qDebug() << "int BlowerRegalECMEON::setSpeedRegulation()";
    if (!isPortValid()) return -1;
    //    qDebug() << "int BlowerRegalECMEON::stop() 1";

    QByteArray cmd;
    cmd.append(m_address);
    cmd.append(ECM_CMD_SET_SPEED_REGULATION);
    cmd.append(ECM_MASTER_CMD_ACK_CODE);

    if(m_controlMode == CONTROL_MODE_AIRVOLUME)
        cmd.append(ECM_CONST_CONTROL_MODE_AIRFLOW);
    else
        cmd.append(ECM_CONST_CONTROL_MODE_TORQUE);

    cmd.append(static_cast<uchar>(newVal));
    cmd.append(static_cast<uchar>(newVal >> 8));

    printf("BlowerRegalECM::setSpeedRegulation Command - byte: ");
    for (int i=0; i<cmd.length(); i++) {
        printf("%02X ", static_cast<uchar>(cmd.at(i)));
    }
    printf("\n");
    fflush(stdout);

    {
        QByteArray checksum;
        CRC16(cmd, checksum);
        cmd.append(checksum);
    }

    printf("BlowerRegalECMEON::setSpeedRegulation Command - byte: ");
    for (int i=0; i<cmd.length(); i++) {
        printf("%02X ", static_cast<uchar>(cmd.at(i)));
    }
    printf("\n");
    fflush(stdout);

    serialComm->write(cmd);
    if(serialComm->waitForBytesWritten(ECM_TRANS_RESPONSE_TIME)){
        if(serialComm->waitForReadyRead(ECM_TRANS_RESPONSE_TIME)){

            QByteArray response;
            while (serialComm->waitForReadyRead(ECM_TRANS_RESPONSE_TIME_EACH_BUFFER)) {
                response += serialComm->readAll();
            }

            qDebug() << "Response length" << response.length();

            printf("BlowerRegalECMEON::setSpeedRegulation Response - byte: ");
            for (int i=0; i<response.length(); i++) {
                printf("%02X ", static_cast<uchar>(response.at(i)));
            }
            printf("\n");
            fflush(stdout);
            /// Filter by data received length
            if(response.length() == ECM_RESP_LENGTH_SET_SPEED_REGULATION){
                if(isChecksumValid(response)){
                    m_demand = newVal;
                }else return -1;
            }else return -1;
        }else return -1;
    }else return -1;

    return 0;
}

int BlowerRegalECMEON::getControlMode(int *mode)
{
    //    qDebug() << "int BlowerRegalECMEON::getControlMode()";
    if (!isPortValid()) return -1;
    //    qDebug() << "int BlowerRegalECMEON::stop() 1";

    QByteArray cmd;
    cmd.append(m_address);
    cmd.append(ECM_CMD_REQ_CONTROL_MODE);
    cmd.append(ECM_MASTER_CMD_ACK_CODE);
    cmd.append(ECM_CONST_BYTE_READ_CONTROL_MODE);

    //    printf("BlowerRegalECM::getControlMode Command - byte: ");
    //    for (int i=0; i<cmd.length(); i++) {
    //        printf("%02X ", static_cast<uchar>(cmd.at(i)));
    //    }
    //    printf("\n");
    //    fflush(stdout);

    {
        QByteArray checksum;
        CRC16(cmd, checksum);
        cmd.append(checksum);
    }

    //    printf("BlowerRegalECMEON::getControlMode Command - byte: ");
    //    for (int i=0; i<cmd.length(); i++) {
    //        printf("%02X ", static_cast<uchar>(cmd.at(i)));
    //    }
    //    printf("\n");
    //    fflush(stdout);

    serialComm->write(cmd);
    if(serialComm->waitForBytesWritten(ECM_TRANS_RESPONSE_TIME)){
        if(serialComm->waitForReadyRead(ECM_TRANS_RESPONSE_TIME)){

            QByteArray response;
            while (serialComm->waitForReadyRead(ECM_TRANS_RESPONSE_TIME_EACH_BUFFER)) {
                response += serialComm->readAll();
            }

            //            printf("BlowerRegalECMEON::getControlMode Response - byte: ");
            //            for (int i=0; i<response.length(); i++) {
            //                printf("%02X ", static_cast<uchar>(response.at(i)));
            //            }
            //            printf("\n");
            //            fflush(stdout);
            /// Filter by data received length
            if(response.length() == ECM_RESP_LENGTH_REQ_CONTROL_MODE){
                if(isChecksumValid(response)){
                    int temp = *mode;
                    *mode = static_cast<uchar>(response.at(4));
                    if(*mode == ECM_CONST_CONTROL_MODE_TORQUE)
                        *mode = CONTROL_MODE_TORQUE;
                    else if(*mode == ECM_CONST_CONTROL_MODE_AIRFLOW)
                        *mode = CONTROL_MODE_AIRVOLUME;
                    else{
                        /// Unknown mode
                        *mode = temp;
                        return -1;
                    }
                }else return -1;
            }else return -1;
        }else return -1;
    }else return -1;
    return 0;
}


/**
 * @brief BlowerRegalECMEON::getSpeed
 * @return
 */
int BlowerRegalECMEON::getSpeed(int *rpm)
{
    //    qDebug() << "int BlowerRegalECMEON::getSpeed()";
    if (!isPortValid()) return -1;
    //    qDebug() << "int BlowerRegalECMEON::stop() 1";

    QByteArray cmd;
    cmd.append(m_address);
    cmd.append(ECM_CMD_REQ_CURRENT_SPEED);
    cmd.append(ECM_MASTER_CMD_ACK_CODE);
    cmd.append(ECM_CONST_OFFSET_ADDRS_CURRENT_SPEED);

    //    printf("BlowerRegalECM::getSpeed Command - byte: ");
    //    for (int i=0; i<cmd.length(); i++) {
    //        printf("%02X ", static_cast<uchar>(cmd.at(i)));
    //    }
    //    printf("\n");
    //    fflush(stdout);

    {
        QByteArray checksum;
        CRC16(cmd, checksum);
        cmd.append(checksum);
    }

    //    printf("BlowerRegalECMEON::getSpeed Command - byte: ");
    //    for (int i=0; i<cmd.length(); i++) {
    //        printf("%02X ", static_cast<uchar>(cmd.at(i)));
    //    }
    //    printf("\n");
    //    fflush(stdout);

    serialComm->write(cmd);
    if(serialComm->waitForBytesWritten(ECM_TRANS_RESPONSE_TIME)){
        if(serialComm->waitForReadyRead(ECM_TRANS_RESPONSE_TIME)){

            QByteArray response;
            while (serialComm->waitForReadyRead(ECM_TRANS_RESPONSE_TIME_EACH_BUFFER)) {
                response += serialComm->readAll();
            }

            //            printf("BlowerRegalECMEON::getSpeed Response - byte: ");
            //            for (int i=0; i<response.length(); i++) {
            //                printf("%02X ", static_cast<uchar>(response.at(i)));
            //            }
            //            printf("\n");
            //            fflush(stdout);
            /// Filter by data received length
            if(response.length() == ECM_RESP_LENGTH_REQ_CURRENT_SPEED){
                if(isChecksumValid(response)){
                    ushort temp = static_cast<ushort>(response.at(5));
                    *rpm = (temp << 8) | static_cast<ushort>(static_cast<uchar>(response.at(4)));
                    /// Filter the RPM speed, cause the actual condition is not more than 1300RPM
                    /// Tested on 3/4 HP
                    /// another HP might be different
                    if(*rpm > 3000) *rpm = 0;
                    if(*rpm != m_speedRpm){
                        m_speedRpm = *rpm;
                        emit rpmChanged(m_speedRpm);
                    }
                }else return -1;
            }else return -1;
        }else return -1;
    }else return -1;
    return 0;
}

int BlowerRegalECMEON::getSpeedRpm()
{
    return m_speedRpm;
}

int BlowerRegalECMEON::getFaultStatus(int *fault)
{
    //    qDebug() << "int BlowerRegalECMEON::getFaultStatus()";
    if (!isPortValid()) return -1;
    //    qDebug() << "int BlowerRegalECMEON::stop() 1";

    QByteArray cmd;
    cmd.append(m_address);
    cmd.append(ECM_CMD_REQ_CURRENT_FAULT);
    cmd.append(ECM_MASTER_CMD_ACK_CODE);

    //    printf("BlowerRegalECM::getFaultStatus Command - byte: ");
    //    for (int i=0; i<cmd.length(); i++) {
    //        printf("%02X ", static_cast<uchar>(cmd.at(i)));
    //    }
    //    printf("\n");
    //    fflush(stdout);

    {
        QByteArray checksum;
        CRC16(cmd, checksum);
        cmd.append(checksum);
    }

    //    printf("BlowerRegalECMEON::getFaultStatus Command - byte: ");
    //    for (int i=0; i<cmd.length(); i++) {
    //        printf("%02X ", static_cast<uchar>(cmd.at(i)));
    //    }
    //    printf("\n");
    //    fflush(stdout);

    serialComm->write(cmd);
    if(serialComm->waitForBytesWritten(ECM_TRANS_RESPONSE_TIME)){
        if(serialComm->waitForReadyRead(ECM_TRANS_RESPONSE_TIME)){

            QByteArray response;
            while (serialComm->waitForReadyRead(ECM_TRANS_RESPONSE_TIME_EACH_BUFFER)) {
                response += serialComm->readAll();
            }

            //            printf("BlowerRegalECMEON::getFaultStatus Response - byte: ");
            //            for (int i=0; i<response.length(); i++) {
            //                printf("%02X ", static_cast<uchar>(response.at(i)));
            //            }
            //            printf("\n");
            //            fflush(stdout);
            /// Filter by data received length
            if(response.length() == ECM_RESP_LENGTH_REQ_CURRENT_FAULT){
                if(isChecksumValid(response)){
                    ushort temp = static_cast<ushort>(response.at(4));
                    *fault = (temp << 8) | static_cast<ushort>(static_cast<uchar>(response.at(3)));
                }else return -1;
            }else return -1;
        }else return -1;
    }else return -1;
    return 0;
}

int BlowerRegalECMEON::getTotalRunTime(int *totRunTime)
{
    //    qDebug() << "int BlowerRegalECMEON::getFaultStatus()";
    if (!isPortValid()) return -1;
    //    qDebug() << "int BlowerRegalECMEON::stop() 1";

    QByteArray cmd;
    cmd.append(m_address);
    cmd.append(ECM_CMD_REQ_TOTAL_RUNTIME);
    cmd.append(ECM_MASTER_CMD_ACK_CODE);

    //    printf("BlowerRegalECM::getFaultStatus Command - byte: ");
    //    for (int i=0; i<cmd.length(); i++) {
    //        printf("%02X ", static_cast<uchar>(cmd.at(i)));
    //    }
    //    printf("\n");
    //    fflush(stdout);

    {
        QByteArray checksum;
        CRC16(cmd, checksum);
        cmd.append(checksum);
    }

    //    printf("BlowerRegalECMEON::getFaultStatus Command - byte: ");
    //    for (int i=0; i<cmd.length(); i++) {
    //        printf("%02X ", static_cast<uchar>(cmd.at(i)));
    //    }
    //    printf("\n");
    //    fflush(stdout);

    serialComm->write(cmd);
    if(serialComm->waitForBytesWritten(ECM_TRANS_RESPONSE_TIME)){
        if(serialComm->waitForReadyRead(ECM_TRANS_RESPONSE_TIME)){

            QByteArray response;
            while (serialComm->waitForReadyRead(ECM_TRANS_RESPONSE_TIME_EACH_BUFFER)) {
                response += serialComm->readAll();
            }

            //            printf("BlowerRegalECMEON::getFaultStatus Response - byte: ");
            //            for (int i=0; i<response.length(); i++) {
            //                printf("%02X ", static_cast<uchar>(response.at(i)));
            //            }
            //            printf("\n");
            //            fflush(stdout);
            /// Filter by data received length
            if(response.length() == ECM_RESP_LENGTH_REQ_TOTAL_RUNTIME){
                if(isChecksumValid(response)){
                    int temp = static_cast<int>(response.at(6)) << (3*8);
                    temp |= static_cast<int>(response.at(5)) << (2*8);
                    temp |= static_cast<int>(response.at(4)) << (8);
                    temp |= static_cast<int>(response.at(3));
                    *totRunTime = temp;
                }else return -1;
            }else return -1;
        }else return -1;
    }else return -1;
    return 0;
}

int BlowerRegalECMEON::getDemand(int *demand)
{
    *demand = m_demand;
    return 0;
}

int BlowerRegalECMEON::getDemandHighLimit(int *demand)
{
    *demand = m_highDemandLimit;
    return 0;
}

int BlowerRegalECMEON::getDemandLowLimit(int *demand)
{
    *demand = m_lowDemandLimit;
    return 0;
}

int BlowerRegalECMEON::getDemand()
{
    return m_demand;
}

int BlowerRegalECMEON::getDemandHighLimit()
{
    return m_highDemandLimit;
}

int BlowerRegalECMEON::getDemandLowLimit()
{
    return m_lowDemandLimit;
}

void BlowerRegalECMEON::setDutyCycle(int value)
{
    bool needStart = false;
    bool needStop = false;

    if(value >= m_dutyCycleLimit) value = m_dutyCycleLimit;
    if(value <0) value = 0;

    if(!m_dutyCycle && value) needStart = true;
    if(m_dutyCycle && !value) needStop = true;

    if(m_dutyCycle == value) return;
    int ducy = m_interlock ? 0 : value;
    int demand = qRound(__map(ducy, 0, 100, m_lowDemandLimit, m_highDemandLimit));
    if(demand == m_demand) return;
    int response = setSpeedRegulation(demand);
    if(!response){
        m_demand = demand;
        m_dutyCycle = ducy;
        emit dutyCycleChanged(value);
    }

    if(needStart){
        start();
    }
    else if(needStop){
        stop();
    }

    //    emit dutyCycleChanged(value);
}

void BlowerRegalECMEON::setInterlock(int value)
{
    if(m_interlock == value)return;
    m_interlock = value;
    emit interlockChanged(value);
}

int BlowerRegalECMEON::dutyCycle()
{
    return m_dutyCycle;
}

void BlowerRegalECMEON::setDutyCycleLimit(int value)
{
    m_dutyCycleLimit = value;
}

/// https://www.modbustools.com/modbus_crc16.htm
/// \brief BlowerRegalECMEON::CRC16
/// \param byte
/// \param checksum
///
void BlowerRegalECMEON::CRC16 (QByteArray &byte, QByteArray& checksum)
{
    static const ushort wCRCTable[] = {
        0X0000, 0XC0C1, 0XC181, 0X0140, 0XC301, 0X03C0, 0X0280, 0XC241,
        0XC601, 0X06C0, 0X0780, 0XC741, 0X0500, 0XC5C1, 0XC481, 0X0440,
        0XCC01, 0X0CC0, 0X0D80, 0XCD41, 0X0F00, 0XCFC1, 0XCE81, 0X0E40,
        0X0A00, 0XCAC1, 0XCB81, 0X0B40, 0XC901, 0X09C0, 0X0880, 0XC841,
        0XD801, 0X18C0, 0X1980, 0XD941, 0X1B00, 0XDBC1, 0XDA81, 0X1A40,
        0X1E00, 0XDEC1, 0XDF81, 0X1F40, 0XDD01, 0X1DC0, 0X1C80, 0XDC41,
        0X1400, 0XD4C1, 0XD581, 0X1540, 0XD701, 0X17C0, 0X1680, 0XD641,
        0XD201, 0X12C0, 0X1380, 0XD341, 0X1100, 0XD1C1, 0XD081, 0X1040,
        0XF001, 0X30C0, 0X3180, 0XF141, 0X3300, 0XF3C1, 0XF281, 0X3240,
        0X3600, 0XF6C1, 0XF781, 0X3740, 0XF501, 0X35C0, 0X3480, 0XF441,
        0X3C00, 0XFCC1, 0XFD81, 0X3D40, 0XFF01, 0X3FC0, 0X3E80, 0XFE41,
        0XFA01, 0X3AC0, 0X3B80, 0XFB41, 0X3900, 0XF9C1, 0XF881, 0X3840,
        0X2800, 0XE8C1, 0XE981, 0X2940, 0XEB01, 0X2BC0, 0X2A80, 0XEA41,
        0XEE01, 0X2EC0, 0X2F80, 0XEF41, 0X2D00, 0XEDC1, 0XEC81, 0X2C40,
        0XE401, 0X24C0, 0X2580, 0XE541, 0X2700, 0XE7C1, 0XE681, 0X2640,
        0X2200, 0XE2C1, 0XE381, 0X2340, 0XE101, 0X21C0, 0X2080, 0XE041,
        0XA001, 0X60C0, 0X6180, 0XA141, 0X6300, 0XA3C1, 0XA281, 0X6240,
        0X6600, 0XA6C1, 0XA781, 0X6740, 0XA501, 0X65C0, 0X6480, 0XA441,
        0X6C00, 0XACC1, 0XAD81, 0X6D40, 0XAF01, 0X6FC0, 0X6E80, 0XAE41,
        0XAA01, 0X6AC0, 0X6B80, 0XAB41, 0X6900, 0XA9C1, 0XA881, 0X6840,
        0X7800, 0XB8C1, 0XB981, 0X7940, 0XBB01, 0X7BC0, 0X7A80, 0XBA41,
        0XBE01, 0X7EC0, 0X7F80, 0XBF41, 0X7D00, 0XBDC1, 0XBC81, 0X7C40,
        0XB401, 0X74C0, 0X7580, 0XB541, 0X7700, 0XB7C1, 0XB681, 0X7640,
        0X7200, 0XB2C1, 0XB381, 0X7340, 0XB101, 0X71C0, 0X7080, 0XB041,
        0X5000, 0X90C1, 0X9181, 0X5140, 0X9301, 0X53C0, 0X5280, 0X9241,
        0X9601, 0X56C0, 0X5780, 0X9741, 0X5500, 0X95C1, 0X9481, 0X5440,
        0X9C01, 0X5CC0, 0X5D80, 0X9D41, 0X5F00, 0X9FC1, 0X9E81, 0X5E40,
        0X5A00, 0X9AC1, 0X9B81, 0X5B40, 0X9901, 0X59C0, 0X5880, 0X9841,
        0X8801, 0X48C0, 0X4980, 0X8941, 0X4B00, 0X8BC1, 0X8A81, 0X4A40,
        0X4E00, 0X8EC1, 0X8F81, 0X4F40, 0X8D01, 0X4DC0, 0X4C80, 0X8C41,
        0X4400, 0X84C1, 0X8581, 0X4540, 0X8701, 0X47C0, 0X4680, 0X8641,
        0X8201, 0X42C0, 0X4380, 0X8341, 0X4100, 0X81C1, 0X8081, 0X4040 };

    ushort wCRCWord = 0xFFFF;

    for(short i=0; i< byte.length(); i++){
        uchar nTemp = byte.at(i) ^ wCRCWord;
        wCRCWord >>= 8;
        wCRCWord ^= wCRCTable[nTemp];
    }

    uchar ckl = static_cast<uchar>(wCRCWord);
    uchar ckh = static_cast<uchar>(wCRCWord >> 8);

    checksum.append((char)ckl);
    checksum.append((char)ckh);

    Q_UNUSED(ckl)
    Q_UNUSED(ckh)
    //    printf("BlowerRegalECMEON::isChecksumValid - checksum: %02X %02X \n", ckl, ckh);
    //    fflush(stdout);
}


bool BlowerRegalECMEON::isChecksumValid(QByteArray byte)
{
    QByteArray dataByte;
    QByteArray checkSum, checkSumCal;

    //    printf("BlowerRegalECM::isChecksumValid byte: ");
    //    for (int i=0; i<byte.length(); i++) {
    //        printf("%02X ", static_cast<uchar>(byte.at(i)));
    //    }
    //    printf("\n");
    //    fflush(stdout);

    for(short i=0; i<byte.length(); i++){
        if(i<(byte.length()-2))
            dataByte.append(byte.at(i));
        else
            checkSum.append(byte.at(i));
    }

    //    printf("BlowerRegalECM::isChecksumValid dataByte: ");
    //    for (int i=0; i<dataByte.length(); i++) {
    //        printf("%02X ", static_cast<uchar>(dataByte.at(i)));
    //    }
    //    printf("\n");
    //    fflush(stdout);

    //    printf("BlowerRegalECM::isChecksumValid checkSum: ");
    //    for (int i=0; i<checkSum.length(); i++) {
    //        printf("%02X ", static_cast<uchar>(checkSum.at(i)));
    //    }
    //    printf("\n");
    //    fflush(stdout);

    CRC16(dataByte, checkSumCal);

    //    printf("BlowerRegalECM::isChecksumValid checkSumCal: ");
    //    for (int i=0; i<checkSumCal.length(); i++) {
    //        printf("%02X ", static_cast<uchar>(checkSumCal.at(i)));
    //    }
    //    printf("\n");
    //    fflush(stdout);

    if(checkSum != checkSumCal) return false;

    //    qDebug() << "Checksum is valid!";

    return true;
}

QByteArray BlowerRegalECMEON::intToQByte16(int newVal)
{
    QByteArray cmd;
    cmd.append((char)(newVal & 0x00ff));
    cmd.append((char)(newVal >> 8));
    return cmd;
}

void BlowerRegalECMEON::debugPrintCommand(const QString &title, const QByteArray &cmd)
{
    printf("BlowerRegalECMEON::debugPrintCommand %s - data: ", title.toStdString().c_str());
    for (int i=0; i<cmd.length(); i++) {
        printf("%02X ", (uchar)(cmd.at(i)));
    }
    printf("\n");
    fflush(stdout);
}

bool BlowerRegalECMEON::isPortValid() const
{
    if (serialComm != nullptr) {
        if(serialComm->isOpen()) {
            return true;
        }
    }
    return false;
}

double BlowerRegalECMEON::__map(double x, double in_min, double in_max, double out_min, double out_max) const
{
    return (x - in_min) * (out_max - out_min) / (in_max - in_min) + out_min;
}


