#include "SensirionSPD8xx.h"
//#include <QtDebug>

#define CHIP_ADDRESS              0x25
//#define CHIP_ADDRESS_I2C_MUX      0x70

#define COMMAND_CODE_CONT_MAS_FLOW_AVG_HI  0x36
#define COMMAND_CODE_CONT_MAS_FLOW_AVG_LO  0x03

#define COMMAND_CODE_CONT_MAS_FLOW_NON_HI  0x36
#define COMMAND_CODE_CONT_MAS_FLOW_NON_LO  0x08

#define COMMAND_CODE_CONT_DIFF_PRE_AVG_HI  0x36
#define COMMAND_CODE_CONT_DIFF_PRE_AVG_LO  0x15

#define COMMAND_CODE_CONT_DIFF_PRE_NON_HI  0x36
#define COMMAND_CODE_CONT_DIFF_PRE_NON_LO  0x1E

#define COMMAND_CODE_CONT_STOP_HI  0x3F
#define COMMAND_CODE_CONT_STOP_LO  0xF9

#define COMMAND_READ_PRODUCT_IDEN_1_HI      0x36
#define COMMAND_READ_PRODUCT_IDEN_1_LO      0x7C

#define COMMAND_READ_PRODUCT_IDEN_2_HI      0xE1
#define COMMAND_READ_PRODUCT_IDEN_2_LO      0x02

#define SCALE_FACTOR_TEMPERATURE        200.0
#define SCALE_FACTOR_PRESSURE_500_PA    60.0
#define SCALE_FACTOR_PRESSURE_125_PA    240.0

using namespace std;

SensirionSPD8xx::SensirionSPD8xx(QObject *parent)
    : ClassDriver(parent)
{
    m_address       = CHIP_ADDRESS;
    //    m_addressMux    = CHIP_ADDRESS_I2C_MUX;

    m_sensorRangeType = SPD_RANGE_TYPE_125Pa;
    //    m_muxChannel      = 0b00000001;

    m_diffPressurePa    = 0.0;
    m_temperature       = 0.0;
    m_scaleFactor       = 0.0;

    m_dataSampleSumPressurePa = 0.0;
    m_dataSampleMaxPressurePa = 1;

    m_dataSampleSumTemperature = 0.0;
    m_dataSampleMaxTemperature = 1;
}

int SensirionSPD8xx::init()
{
    int error = 0;
    //error = readProductIdentifier();
    //usleep(10000); //sensor actualy need 45ms
    error = setContinousOff();
    usleep(10000); //sensor actualy need 45ms
    error = setContinousDiffPresureWithAvg();
    usleep(10000); //sensor actualy need 45ms

    return error;
}

int SensirionSPD8xx::testComm()
{
    vector<unsigned char> cmd;
    pI2C->generateFrame(I2CPort::I2C_CMD_OPERATION_WRITE,
                         m_address,
                         0,
                         2,
                         0,
                         cmd);
    cmd.push_back(COMMAND_CODE_CONT_STOP_HI);
    cmd.push_back(COMMAND_CODE_CONT_STOP_LO);
    //make buffer received message
    vector<unsigned char> receive;
    //call i2c object and pass command frame
    if(pI2C->writeData(cmd) != I2CPort::I2C_COMM_RESPONSE_OK)
    {
        //        qDebug() << QObject::metaObject()->className() << " " << "Failed to communication PDTBoardHoneywell testComm";
        return I2CPort::I2C_COMM_RESPONSE_ERROR;
    }
    return I2CPort::I2C_COMM_RESPONSE_OK;
}

int SensirionSPD8xx::setContinousDiffPresureWithAvg()
{
    vector<unsigned char> cmd;
    pI2C->generateFrame(I2CPort::I2C_CMD_OPERATION_WRITE,
                         m_address,
                         0,
                         2,
                         0,
                         cmd);
    cmd.push_back(COMMAND_CODE_CONT_DIFF_PRE_AVG_HI);
    cmd.push_back(COMMAND_CODE_CONT_DIFF_PRE_AVG_LO);
    //make buffer received message
    vector<unsigned char> receive;
    //call i2c object and pass command frame
    if(pI2C->writeData(cmd) != I2CPort::I2C_COMM_RESPONSE_OK)
    {
        //        qDebug() << QObject::metaObject()->className() << " " << "Failed setContinousDiffPresureWithAvg";
        return I2CPort::I2C_COMM_RESPONSE_ERROR;
    }
    return I2CPort::I2C_COMM_RESPONSE_OK;
}

int SensirionSPD8xx::setContinousOff()
{
    //WITHOUT_MUX
    vector<unsigned char> cmd;
    pI2C->generateFrame(I2CPort::I2C_CMD_OPERATION_WRITE,
                         m_address,
                         0,
                         2,
                         0,
                         cmd);
    cmd.push_back(COMMAND_CODE_CONT_STOP_HI);
    cmd.push_back(COMMAND_CODE_CONT_STOP_LO);
    //make buffer received message
    vector<unsigned char> receive;
    //call i2c object and pass command frame
    if(pI2C->writeData(cmd) != I2CPort::I2C_COMM_RESPONSE_OK)
    {
        //        qDebug() << QObject::metaObject()->className() << " " << "Failed to communication PDTBoardHoneywell testComm";
        return I2CPort::I2C_COMM_RESPONSE_ERROR;
    }
    return I2CPort::I2C_COMM_RESPONSE_OK;
}

int SensirionSPD8xx::readDiffPressure()
{
    // WITHOUT_MUX_IC
    vector<unsigned char> cmd;
    pI2C->generateFrame(I2CPort::I2C_CMD_OPERATION_READ,
                         m_address,
                         0,
                         9,
                         0,
                         cmd);
    //make buffer received message
    vector<unsigned char> receive;
    //call i2c object and pass command frame
    if(pI2C->readData(cmd, receive) != I2CPort::I2C_COMM_RESPONSE_OK)
    {
        //        qDebug() << QObject::metaObject()->className() << " " << "Failed to readDiffPressure";
        return I2CPort::I2C_COMM_RESPONSE_ERROR;
    }

    //printf("SensirionSPD8xx::readDiffPressure rawdata ");
    //for(uint i=0; i < receive.size(); i++){
    //    printf("%02X", receive[i]);
    //}
    //printf("\n");
    //fflush(stdout);

    /// Check the data length to prevent a segmentation fault
    if(receive.size() < 3){
        return I2CPort::I2C_COMM_RESPONSE_ERROR;
    }
	
    vector<uchar> diffRawCrc;
    diffRawCrc.push_back(receive[0]);
    diffRawCrc.push_back(receive[1]);
    diffRawCrc.push_back(receive[2]);
    uchar crc = crc8(diffRawCrc, 2);

    //uchar crc = crc8(receiveDp, 2);
    if(crc == diffRawCrc[2]){

        int16_t dpRaw = (diffRawCrc[0] << 8) | diffRawCrc[1];
        float dp = qRound((float)dpRaw / m_scaleFactor);

        //if sample more then one mean need moving average
        if(m_dataSampleMaxPressurePa > 1){
            if(m_dataSamplesPressurePa.length() >= m_dataSampleMaxPressurePa){
                m_dataSampleSumPressurePa = m_dataSampleSumPressurePa - m_dataSamplesPressurePa.front();
                m_dataSamplesPressurePa.pop_front();
            }
            m_dataSamplesPressurePa.push_back(dp);

            m_dataSampleSumPressurePa = m_dataSampleSumPressurePa + dp;
            //dp = qRound((float)m_dataSampleSumPressurePa / (float)m_dataSamplesPressurePa.length());
            dp = (float)m_dataSampleSumPressurePa / (float)m_dataSamplesPressurePa.length();
        }

        if(m_diffPressurePa != dp){
            m_diffPressurePa = dp;

            //        printf("Value is %.2f\n", dp);
            //        fflush(stdout);
        }
    }

    vector<uchar> tempRawCrc;
    tempRawCrc.push_back(receive[3]);
    tempRawCrc.push_back(receive[4]);
    tempRawCrc.push_back(receive[5]);
    crc = crc8(tempRawCrc, 2);
    if(crc == tempRawCrc[2]){
        int16_t tempRaw = (tempRawCrc[0] << 8) | tempRawCrc[1];
        float temp = (float)tempRaw / SCALE_FACTOR_TEMPERATURE;

        //qDebug() << __func__ << "@1" << temp << m_temperature;

        //if sample more then one mean need moving average
        if(m_dataSampleMaxTemperature > 1){
            if(m_dataSamplesTemperature.length() >= m_dataSampleMaxTemperature){
                m_dataSampleSumTemperature = m_dataSampleSumTemperature - m_dataSamplesTemperature.front();
                m_dataSamplesTemperature.pop_front();
            }
            m_dataSamplesTemperature.push_back(temp);

            m_dataSampleSumTemperature = m_dataSampleSumTemperature + temp;
            //temp = qRound((float)m_dataSampleSumTemperature / (float)m_dataSamplesTemperature.length());
            temp = (float)m_dataSampleSumTemperature / (float)m_dataSamplesTemperature.length();
        }

        if(m_temperature != temp){
            m_temperature = temp;

            //        printf("Value is %.2f\n", temp);
            //        fflush(stdout);
        }
        //qDebug() << __func__ << "@2" << temp << m_temperature;
    }


    ////TESTING
    //    vector<uchar> diffRawCrc;
    //    diffRawCrc.push_back(receive[0]);
    //    diffRawCrc.push_back(receive[1]);
    //    diffRawCrc.push_back(receive[2]);
    //    uchar crc = crc8(diffRawCrc, 2);
    //    printf("crc %02X\n", crc);
    //    if(crc == diffRawCrc[2]){

    //        int16_t dpRaw = (diffRawCrc[0] << 8) | diffRawCrc[1];
    //        float dp = diffRawToDiffPressure(dpRaw, 60);

    //        printf("Value is %.2f\n", dp);
    //    }



    //    printf("SensirionSPD8xx::readDiffPressure rawdata ");
    //    for(uint i=0; i < receive.size(); i++){
    //        printf("%02X", receive[i]);
    //    }
    //    printf("\n");
    //    fflush(stdout);

    //    printf("Differential pressure\n");

    //    vector<uchar> diffRawCrc;
    //    diffRawCrc.push_back(receive[0]);
    //    diffRawCrc.push_back(receive[1]);
    //    diffRawCrc.push_back(receive[2]);
    //    uchar crc = crc8(diffRawCrc, 2);
    //    printf("crc %02X\n", crc);
    //    if(crc == diffRawCrc[2]){

    //        int16_t dpRaw = (diffRawCrc[0] << 8) | diffRawCrc[1];
    //        float dp = diffRawToDiffPressure(dpRaw, 60);

    //        printf("Value is %.2f\n", dp);
    //    }

    //    printf("Temperature\n");

    //    vector<uchar> tempRawCrc;
    //    tempRawCrc.push_back(receive[3]);
    //    tempRawCrc.push_back(receive[4]);
    //    tempRawCrc.push_back(receive[5]);
    //    crc = crc8(tempRawCrc, 2);
    //    printf("crc %02X %02X\n", crc, tempRawCrc[2]);
    //    if(crc == tempRawCrc[2]){
    //        int16_t tempRaw = (tempRawCrc[0] << 8) | tempRawCrc[1];
    //        float temp = (float)tempRaw / SCALE_FACTOR_TEMPERATURE;

    //        printf("Value is %.1f\n", temp);
    //    }

    //    printf("\n");
    //    fflush(stdout);

    return I2CPort::I2C_COMM_RESPONSE_OK;
}

/// Not Correct Yet
int SensirionSPD8xx::readProductIdentifier()
{
    vector<unsigned char> cmd1;
    pI2C->generateFrame(I2CPort::I2C_CMD_OPERATION_WRITE,
                         m_address,
                         0,
                         18,
                         0,
                         cmd1);
    cmd1.push_back(COMMAND_READ_PRODUCT_IDEN_1_HI);
    cmd1.push_back(COMMAND_READ_PRODUCT_IDEN_1_LO);
    //make buffer received message
    vector<unsigned char> receive1;
    //call i2c object and pass command frame
    if(pI2C->readData(cmd1, receive1) != I2CPort::I2C_COMM_RESPONSE_OK)
    {
        //        qDebug() << QObject::metaObject()->className() << " " << "Failed to readProductIdentifier";
        return I2CPort::I2C_COMM_RESPONSE_ERROR;
    }
    else{
        vector<unsigned char> cmd2;
        pI2C->generateFrame(I2CPort::I2C_CMD_OPERATION_WRITE,
                             m_address,
                             0,
                             18,
                             0,
                             cmd2);
        cmd2.push_back(COMMAND_READ_PRODUCT_IDEN_2_HI);
        cmd2.push_back(COMMAND_READ_PRODUCT_IDEN_2_LO);
        vector<unsigned char> receive2;
        if(pI2C->readData(cmd2, receive2) != I2CPort::I2C_COMM_RESPONSE_OK)
        {
            //        qDebug() << QObject::metaObject()->className() << " " << "Failed to readProductIdentifier";
            return I2CPort::I2C_COMM_RESPONSE_ERROR;
        }

        vector<unsigned char> cmd3;
        pI2C->generateFrame(I2CPort::I2C_CMD_OPERATION_READ,
                             m_address,
                             0,
                             18,
                             0,
                             cmd3);
        //make buffer received message
        vector<unsigned char> receive3;
        //call i2c object and pass command frame
        if(pI2C->readData(cmd3, receive3) != I2CPort::I2C_COMM_RESPONSE_OK)
        {
            //        qDebug() << QObject::metaObject()->className() << " " << "Failed to readDiffPressure";
            return I2CPort::I2C_COMM_RESPONSE_ERROR;
        }

        printf("SensirionSPD8xx::readProductIdentifier ");
        for(uint i=0; i < receive3.size(); i++){
            printf("%02X", receive3[i]);
        }
        printf("\n");
        fflush(stdout);

        return I2CPort::I2C_COMM_RESPONSE_OK;
    }
}

void SensirionSPD8xx::setDataSampleMaxPressurePa(int dataSampleMaxPressurePa)
{
    m_dataSampleMaxPressurePa = dataSampleMaxPressurePa;
}

void SensirionSPD8xx::setDataSampleMaxTemperature(int dataSampleMaxTemperature)
{
    m_dataSampleMaxTemperature = dataSampleMaxTemperature;
}

void SensirionSPD8xx::setSensorRangeType(int sensorRangeType)
{
    m_sensorRangeType = sensorRangeType;
    if(m_sensorRangeType) m_scaleFactor = SCALE_FACTOR_PRESSURE_125_PA;
    else m_scaleFactor = SCALE_FACTOR_PRESSURE_500_PA;
}

float SensirionSPD8xx::diffPressurePa() const
{
    return m_diffPressurePa;
}

float SensirionSPD8xx::temperature() const
{
    return m_temperature;
}

uchar SensirionSPD8xx::crc8(std::vector<uchar> &data, uint8_t datalen)
{
    uchar crc = 0xFF;

    for(int i=0; i < datalen; i++){
        crc ^= (data[i]);
        for(uchar bit = 8; bit > 0; --bit){
            if(crc & 0x80)  crc = (crc << 1) ^ 0x31;
            else            crc = (crc << 1);
        }
    }

    return crc;
}

int SensirionSPD8xx::polling()
{
    int error = 0;
    error = readDiffPressure();
    return error;
}
