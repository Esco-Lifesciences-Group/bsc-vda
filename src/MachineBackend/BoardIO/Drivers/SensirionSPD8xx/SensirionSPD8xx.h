#ifndef SENSIRIONSPD8XX_H
#define SENSIRIONSPD8XX_H

/* Sensirion Board with i2c Multiplexing IC
 * default address pressure board sensor is 0x25
 * with integrated i2c multiplexing IC,
 * sensor i2c address will forward to 0x70 (jumper selectable)
*/

#include "../ClassDriver.h"
#include <QVector>

class SensirionSPD8xx : public ClassDriver
{
    Q_OBJECT
public:
    SensirionSPD8xx(QObject *parent = nullptr);

    int setContinousDiffPresureWithAvg();
    int setContinousOff();

    enum SPD{
        SPD_RANGE_TYPE_500Pa,
        SPD_RANGE_TYPE_125Pa
    };

    void setSensorRangeType(int sensorRangeType);
    void setDataSampleMaxPressurePa(int dataSampleMaxPressurePa);
    void setDataSampleMaxTemperature(int dataSampleMaxTemperature);

    float diffPressurePa() const;
    float temperature() const;

    int readDiffPressure();
    int readProductIdentifier();

private:
    //    unsigned char m_addressMux;
    int m_sensorRangeType;
    //    int m_muxChannel;

    float m_diffPressurePa;
    float m_temperature;
    float m_scaleFactor;

    float m_dataSampleSumPressurePa;
    QVector<float> m_dataSamplesPressurePa;
    float m_dataSampleMaxPressurePa;

    float m_dataSampleSumTemperature;
    QVector<float> m_dataSamplesTemperature;
    float m_dataSampleMaxTemperature;

    uchar crc8(std::vector<uchar> &data, uint8_t datalen);

    // ClassDriver interface
public:
    int init();
    int testComm();
    int polling();
};

#endif // SENSIRIONSPD8XX_H
