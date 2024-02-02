//#include <QDebug>
#include <cmath>
#include "AirflowVelocity.h"

/// 11-5-2020
/// option to select between 2 point calibration or 3 point calibration

AirflowVelocity::AirflowVelocity(QObject *parent)
    : ClassManager(parent)
{
    m_adc               = 0;
    m_adcConpensation   = 0;
    m_velocity          = 0;
    m_constant          = 0;
    m_m1                = 0;
    m_b1                = 0;
    m_m2                = 0;
    m_b2                = 0;
    m_temperature       = 0;
    m_maxAdcResBits   = 12; // Default ADC Resolution 12 bits
    m_meaUnit = 0;

    adcDummy            = 0;
    m_adcChanged        = false;
    m_velocityChanged   = false;
}

/**
 * @brief AirflowManager::worker
 * @param parameter
 * Calculate ADC Compensation, then
 * Calculate AIrflow Velocity
 * parameter:
 *  1 for force recalculate adc conpensation
 *  2 for force recalculate velocity
 *  3 for force recalculate adc conpensation and velocity
 */
void AirflowVelocity::routineTask(int parameter)
{
    //    Q_UNUSED(parameter);

    bool recalculateAdcConpensation = false;
    bool recalculateVelocity = false;

    switch (parameter) {
    case 1:
        recalculateAdcConpensation = true;
        break;
    case 2:
        recalculateVelocity = true;
        break;
    }

    int adc = pAI->getADC(m_channel);
    int mvolt = pAI->getmVolt(m_channel);

#ifdef QT_DEBUG
    if(m_dummyStateEnable){
        adc = m_dummyState;
        mvolt = __map(adc, 0, 4095, 0, 10118);
    }
#endif

    //ADC
    if(m_adc != adc){
        m_adc = adc;
        recalculateAdcConpensation = true;
        emit adcChanged(m_adc);

        //        qDebug() << __func__ << "m_adc" << m_adc;
    }

    if(m_mVolt != mvolt){
        m_mVolt = mvolt;
        emit mVoltChanged(mvolt);
    }

    //TEMPERATURE EFFECTED TO AIRFLOW SENSOR
    if(m_temperatureChanged){
        recalculateAdcConpensation = true;
        m_temperatureChanged = false;
    }

    //ADC CONPENSATION
    if(recalculateAdcConpensation || m_sensorConstantChanged){
        //ADC TEMPERATURE CONVESATION
        int adcC = m_adc;
        double adcCompTemp = 0.0;

        if((m_constant != 0) && (m_temperature <= 50.0)){
            if(m_sensorConstCorrEnable)// The correction only on the scope not on the adc value
                adcCompTemp = m_adc;
            else //original
                adcCompTemp = _getADCTempCorrection(m_adc);

            adcC = static_cast<int>(adcCompTemp);
            if(adcC < 0) adcC = m_adc;
        }//

        if(m_adcConpensation != adcC){
            m_adcConpensation   = adcC;
            recalculateVelocity = true;
            emit adcConpensationChanged(m_adcConpensation);

            // qDebug() << "m_adc" << m_adc;
            // qDebug() << "m_temperature" << m_temperature;
            // qDebug() << "m_constant" << m_constant;
        }

        // CLEAR FLAG
        //        if(m_sensorConstantChanged) qDebug() << "m_sensorConstantChanged::recalculateAdcConpensation";
        if(m_sensorConstantChanged) m_sensorConstantChanged = false;
    }//

    //VELOCITY
    if(recalculateVelocity || m_scopeChanged){
        if(m_scopeChanged) m_scopeChanged = false;

        double velocity = 0;

        if(m_sensorConstCorrEnable)
            velocity = _getActualVelocityPredictionTempCorrection(m_adcConpensation);
        else
            velocity = _getActualVelocity(m_adcConpensation);

        double velNominal   = m_velocityPoint[2];
        double velLow       = m_velocityPoint[1];
        double velActual    = velocity;
        double valueVel     = 0;

        qDebug() << velLow << velNominal << velActual << "final 1:" << valueVel;

        if(m_meaUnit) {
            if(qAbs(velActual - velLow) <= (0.01 * 196.85 * 100.0))
                velActual = velActual - (0.005 * 196.85 * 100.0);

            //if(velHigh > 0)   velHigh /= 100.0;
            if(velNominal > 0)  velNominal  /= 100.0;
            if(velLow > 0)      velLow      /= 100.0;
            if(velActual > 0)   velActual   /= 100.0;
        }//
        else{
            if(qAbs(velActual - velLow) <= (0.01 * 100.0))
                velActual = velActual - (0.005 * 100.0);
        }//

        /// generate an offset in order to decide what rounding method need to implement
        /// use 20% of the deviation between Nominal and one of the alarm velocity
        //int offsetBeforeAlarm = qRound(0.2 * (velNominal - velLow));
        /// Remove decimal point if actual velocity is greater than Nominal
        /// Round it if less than Nominal
        if(velActual > velNominal){
            // if((velActual >= (velHigh - offsetBeforeAlarm)) && (velHigh > velNominal))
            //     valueVel = qRound(velActual);
            // else
            valueVel = static_cast<int>(velActual);
        }else{
            // if(velActual <= (velLow + offsetBeforeAlarm))
            //     valueVel = static_cast<int>(velActual);
            // else
            valueVel = qRound(velActual);
        }//

        if(m_meaUnit) {
            //            if(velHigh > 0)     velHigh *= 100.0;
            if(velNominal > 0)  velNominal *= 100.0;
            if(velLow > 0)      velLow *= 100.0;
            if(velActual > 0)   velActual *= 100.0;
            if(valueVel > 0)    valueVel *= 100.0;
        }//

        // qDebug() << velLow /*<< velHigh*/ /*<< offsetBeforeAlarm*/;
        qDebug() << velLow << velNominal << velActual << "final 2:" << valueVel;

        // velocity = qRound(velocity);

        //nomalization, airflow value dont have negative
        if(valueVel < 0) valueVel = 0;

        // printf("Velocity %.2f\n", velocity);
        // fflush(stdout);

        if(fabs(valueVel - m_velocity) >= 1){
            m_velocity = valueVel;

            if(!m_velocityChanged) m_velocityChanged = true;
            emit velocityChanged(m_velocity);
        }

        //        if(fabs(velocity - m_velocity) >= 0.001){
        //            m_velocity = velocity;

        //            if(!m_velocityChanged) m_velocityChanged = true;
        //            emit velocityChanged(m_velocity);
        //        }

        //        qDebug() << "m_adcConpensation: "<< m_adcConpensation;
        //        qDebug() << "ADC2:" << m_adcPoint[2] <<"ADC1:" << m_adcPoint[1];
        //        qDebug() << "VEL2:" << m_velocityPoint[2] << "VEL1:" << m_velocityPoint[1];
        //        qDebug() << "m1: " << m_m1;
        //        qDebug() << "b1: " << m_b1;
        //        qDebug() << "m2: " << m_m2;
        //        qDebug() << "b2: " << m_b2;
    }

    emit workerFinished();

}

///**
// * @brief AirflowManager::calculateCompensationADC
// * Not like worker function, this just calculte adc compensation
// */
//void AirflowVelocity::calculateCompensationADC()
//{
//    int adc = pAI->getADC(m_channel);

//    //dummyADC
//    //    adc = adcDummy += 10;
//    //    qDebug() << "AirflowManager::workerCompensationADC() " << adc;

//    bool recalculateAdcConpensation = false;

//    //ADC
//    int adcC = 0;
//    if(m_adc != adc){
//        m_adc = adc;
//        recalculateAdcConpensation = true;
//        emit adcChanged(m_adc);
//    }

//    //TEMPERATURE
//    if(m_temperatureChanged){
//        recalculateAdcConpensation = true;
//        m_temperatureChanged = false;
//    }

//    //ADC CONPENSATION
//    if(recalculateAdcConpensation){

//        //ADC TEMPERATURE CONVESATION
//        if((m_constant == 0) || (m_temperature > 50.0)){
//            adcC = adc;
//        }
//        else{
//            double result;
//            result =  m_temperature - 25.0;
//            result += (double)m_constant;
//            result *= (double)(adc);
//            result /= (double)(m_constant);
//            adcC = qRound(result);
//        }

//        if(m_adcConpensation != adcC){
//            m_adcConpensation   = adcC;
//            emit adcConpensationChanged(m_adcConpensation);
//        }
//    }
//}

void AirflowVelocity::setAdcPoint(int point, int value)
{
    m_adcPoint[point] = value;
}

void AirflowVelocity::setVelocityPoint(int point, double value)
{
    m_velocityPoint[point] = value;
}

void AirflowVelocity::setConstant(int value)
{
    if(m_constant == value) return;
    m_constant = value;
    m_sensorConstantChanged = true;
}

/**
 * @brief AirflowManager::initScope
 * Pre calculate velocity scope
 */
void AirflowVelocity::initScope()
{
    // qDebug() << metaObject()->className() << __func__ << m_adcPoint[2] << m_adcPoint[1] << m_adcPoint[0];
    // qDebug() << metaObject()->className() << __func__ << m_velocityPoint[2] << m_velocityPoint[1];

    double temp = (m_velocityPoint[1] - m_velocityPoint[0]);
    if(temp == 0) temp = 0.01;

    double m1 = (static_cast<double>(m_adcPoint[1] - m_adcPoint[0])) / temp;
    double b1 = (static_cast<double>(m_adcPoint[0])) - (m1 * m_velocityPoint[0]);

    temp = (m_velocityPoint[2] - m_velocityPoint[1]);
    if(temp == 0) temp = 0.01;
    double m2 = (static_cast<double>(m_adcPoint[2] - m_adcPoint[1])) / temp;
    double b2 = (static_cast<double>(m_adcPoint[1])) - (m2 * m_velocityPoint[1]);


    if((m_m1 != m1) || (m_b1 != b1) || (m_m2 != m2) || (m_b2 != b2)){
        m_m1 = m1;
        m_b1 = b1;
        m_m2 = m2;
        m_b2 = b2;

        m_scopeChanged = true;

        qDebug() << metaObject()->className() << __func__ << "Scope changed!";
        qDebug() << metaObject()->className() << __func__ << m1 << b1;
        qDebug() << metaObject()->className() << __func__ << m2 << b2;
    }

    //qDebug() << "ADC2: "<< m_adcPoint[2] <<" ADC1: " << m_adcPoint[1];
    //qDebug() << "VEL2: " << m_velocityPoint[2] << " VEL1: " << m_velocityPoint[1];
}

void AirflowVelocity::setMeasurementUnit(uchar value)
{
    m_meaUnit = value;
}

void AirflowVelocity::setTemperature(double newVal)
{
    qDebug() << metaObject()->className() << __func__ << newVal;

    if(abs(m_temperature - newVal) < 0.01) return;
    m_temperature = newVal;
    if(!m_temperatureChanged) m_temperatureChanged = true;
}

void AirflowVelocity::setAdcResolutionBits(unsigned char bits)
{
    m_maxAdcResBits = bits;
}

void AirflowVelocity::setSensorConstCorrEnable(bool value)
{
    m_sensorConstCorrEnable = value;
}

void AirflowVelocity::setSensorConstCorrHighZone(int value)
{
    m_sensorConstCorrHighZone = value;
}

void AirflowVelocity::setSensorConstCorrLowZone(int value)
{
    m_sensorConstCorrLowZone = value;
}

void AirflowVelocity::setTemperatureCalib(double value)
{
    m_temperatureCalib = value;
}

bool AirflowVelocity::getDummyStateEnable() const
{
    return m_dummyStateEnable;
}

void AirflowVelocity::setDummyStateEnable(bool dummyStateEnable)
{
    m_dummyStateEnable = dummyStateEnable;
}

int AirflowVelocity::getDummyState() const
{
    return m_dummyState;
}

void AirflowVelocity::setDummyState(int dummyState)
{
    m_dummyState = dummyState;
}

double AirflowVelocity::_getActualVelocity(int adc)
{
    qDebug() << metaObject()->className() << __func__ << adc;
    double velocity = 0.0;
    if(adc < m_adcPoint[0]){
        velocity = 0;

        qDebug() << metaObject()->className() << __func__ << "m_adcPoint[0]" << m_adcPoint[0] << m_adcConpensation << "velocity" << velocity;
    }else if(adc < m_adcPoint[1]){
        velocity = /*qRound(*/(adc - m_b1) / m_m1/*)*/;

        qDebug() << metaObject()->className() << __func__ << "m_adcPoint[1]"  << m_adcPoint[1] << m_adcConpensation << m_b1 << m_m1 << "velocity" << velocity;
    }else{
        velocity = /*qRound(*/(adc - m_b2) / m_m2/*)*/;
        qDebug() << metaObject()->className() << __func__ << "m_adcPoint[2]" << m_adcPoint[2] << m_adcConpensation << m_b2 << m_m2 << "velocity" << velocity;
    }
    return velocity;
}

int AirflowVelocity::_getADCTempCorrection(int adc)
{
    double adcCompTemp = 0.0;
    adcCompTemp = (m_temperature - 25.0) + static_cast<double>(m_constant);
    adcCompTemp *= static_cast<double>(adc);
    adcCompTemp /= static_cast<double>(m_constant);
    return static_cast<int>(adcCompTemp);
}

double AirflowVelocity::_calculateVelocity(int adc, double x1, double y1, double x2, double y2)
{
    float m, b, velocity;

    /* Straight Line Equation Forming
             *
         *          +------------------+
         *	    |	y = mx + b     |
         *          +------------------+
         * where
         *         y = y coordinate
         *         x = x coordinate
         *         m = (y0 - y1)/(x0 - x1)
         *
         * so,     b = y - mx
         */

    if(adc >= x1)
    {
        /// Prevent segmentation fault (value divided by 0)
        double y2_y1 = y2 - y1;
        if(y2_y1 == 0) y2_y1 = 0.01;

        m = ((float)x2 - (float)x1)/y2_y1;
        b = x1 - m * y1;

        /// Prevent segmentation fault (value divided by 0)
        if(m == 0) m = 1;
        velocity = (adc - b)/m;
    }
    else
    {
        if( adc > 0)
        {
            /// Prevent segmentation fault (value divided by 0)
            if(y1 == 0) y1 = 0.01;
            m = ((float)x1 - (float)0)/y1;

            /// Prevent segmentation fault (value divided by 0)
            if(m == 0) m = 1;
            velocity = (adc - 0)/m;
        }
        else velocity = 0;
    }
    return velocity;
}

double AirflowVelocity::_getActualVelocityPredictionTempCorrection(int adc)
{
    qDebug() << metaObject()->className() << __func__ << adc;
    int adcPointCorrection[AIRFLOWNANAGER_MAX_ADC_POINT] = {0};
    adcPointCorrection[1] = _getADCPredictionTempCorrection(m_adcPoint[1]);
    adcPointCorrection[2] = _getADCPredictionTempCorrection(m_adcPoint[2]);

    for(short i=0; i<AIRFLOWNANAGER_MAX_ADC_POINT; i++){
        if(m_adcPointCorrection[i] != adcPointCorrection[i]){
            m_adcPointCorrection[i] = adcPointCorrection[i];
            emit adcPointCorrectionChanged(i, m_adcPointCorrection[i]);
        }
    }

    return _calculateVelocity(adc, m_adcPointCorrection[1], m_velocityPoint[1], m_adcPointCorrection[2], m_velocityPoint[2]);
}

int AirflowVelocity::_getADCPredictionTempCorrection(int adc)
{
    double adcCompTemp = 0.0;

    qDebug() << m_temperature << m_temperatureCalib;
    if(qAbs(m_temperature - m_temperatureCalib) < 0.2){
        adcCompTemp = adc;
    }else{
        int constantCorrection = m_constant;
        if(m_temperature > (m_temperatureCalib+1))
            constantCorrection = m_sensorConstCorrHighZone;
        else if(m_temperature < (m_temperatureCalib-1))
            constantCorrection = m_sensorConstCorrLowZone;

        adcCompTemp = static_cast<double>(adc) * static_cast<double>(constantCorrection);

        /// Prevent segmentation fault (value divided by 0)
        double temp = ((m_temperature - m_temperatureCalib) + static_cast<double>(constantCorrection));
        if(temp == 0) temp = 1;
        adcCompTemp /= temp;
    }//

    return static_cast<int>(adcCompTemp);
}

void AirflowVelocity::setAIN(AIManage *value)
{
    pAI = value;
}

void AirflowVelocity::setChannel(int channel)
{
    m_channel = channel;
}

bool AirflowVelocity::getVelocityChanged() const
{
    return m_velocityChanged;
}

void AirflowVelocity::setVelocityChanged(bool velocityChanged)
{
    m_velocityChanged = velocityChanged;
}

bool AirflowVelocity::getAdcChanged() const
{
    return m_adcChanged;
}

void AirflowVelocity::setAdcChanged(bool newVal)
{
    m_adcChanged = newVal;
}

double AirflowVelocity::getB1() const
{
    return m_b1;
}

double AirflowVelocity::getB2() const
{
    return m_b2;
}

double AirflowVelocity::getVelocityPoint(int point) const
{
    return m_velocityPoint[point];
}

double AirflowVelocity::getM2() const
{
    return m_m2;
}

double AirflowVelocity::getM1() const
{
    return m_m1;
}

double AirflowVelocity::velocity() const
{
    return m_velocity;
}

int AirflowVelocity::adcConpensation() const
{
    return m_adcConpensation;
}

int AirflowVelocity::adc() const
{
    return m_adc;
}

double AirflowVelocity::__map(double x, double in_min, double in_max, double out_min, double out_max) const
{
    /// Prevent segmentation fault (value divided by 0)
    if((in_max - in_min) != 0)
        return (x - in_min) * (out_max - out_min) / (in_max - in_min) + out_min;
    return 0.0;
}
