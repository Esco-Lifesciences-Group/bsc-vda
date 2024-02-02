#include "PWMOutput.h"

/// PWM DUTY CYCLE RANGE 1-1000 (equals to 1-100%)

PWMOutput::PWMOutput(QObject *parent)
    : ClassManager(parent)
{
    pSubModule      = nullptr;
    m_channelIO     = 0;
    m_state         = 0;
    m_interlock     = 0;
    m_stateRequest  = 0;
    m_dcyMin        = 0;
}

int PWMOutput::interlock() const
{
    return m_interlock;
}

int PWMOutput::state() const
{
    return m_state;
}

bool PWMOutput::dummyStateEnable() const
{
    return m_dummyStateEnable;
}

void PWMOutput::setDummyStateEnable(bool dummyStateEnable)
{
    m_dummyStateEnable = dummyStateEnable;
}

short PWMOutput::dummyState() const
{
    return m_dummyState;
}

void PWMOutput::setDummyState(short dummyState)
{
    m_dummyState = dummyState;
    m_stateRequest = dummyState;
}

void PWMOutput::routineTask(int parameter)
{
    Q_UNUSED(parameter)
    //    qDebug() << "PWMOutputManager::worker()";
    int ival;
    ival =  pSubModule->getRegBufferPWM(m_channelIO);


#ifdef QT_DEBUG
    if(m_dummyStateEnable){
        ival = m_dummyState;
    }
#endif
    //get actual state
    if(m_state != ival){
        m_state = ival;

        //Signal
        qDebug() << "State changed " << m_state;
        emit stateChanged(m_state);
    }

    //    qDebug() << "Interlocked :" << m_interlock;

    //override with locked state
    m_stateRequest &= ~m_interlock;

    //set sub module to expection state
    if(m_state != m_stateRequest){
        int pwmDcy = m_stateRequest;
        pSubModule->setPWM(m_channelIO, pwmDcy, ClassDriver::I2C_OUT_BUFFER);

        //m_state = m_stateRequest;
        //qDebug() << "State changed 2" << m_state;
        //emit stateChanged(m_state);

//#ifdef QT_DEBUG
//        if(m_dummyStateEnable){
//            m_dummyState = static_cast<short>(m_stateRequest);
//        }
//#endif
        //        m_stateRequest = BackendEEnums::DIGITAL_STATE_OFF;
        //        qDebug() << "m_stateRequest: " << m_stateRequest;
    }

    emit workerFinished();
}

void PWMOutput::setSubModule(PWMpca9685 *obj)
{
    pSubModule = obj;
}

void PWMOutput::setChannelIO(int channel)
{
    //    qDebug() << "DigitalOutManager::setChannelIO(): " << channel;
    if(m_channelIO != channel){
        int oldState = m_channelIO;
        m_channelIO = channel;

        emit channelIOChanged(m_channelIO, oldState);
    }
}

void PWMOutput::setState(int state)
{
    //    printf("DigitalOutManager::setState\n");
    //    fflush(stdout);

#ifdef QT_DEBUG
    if(m_dummyStateEnable){
        m_dummyState = static_cast<short>(state);
        m_stateRequest = m_dummyState;
    }
#endif

    if(m_state == state) return;
    if(m_stateRequest == state) return;

    m_stateRequest = state;
    if(m_stateRequest <= m_dcyMin)
        m_stateRequest = m_dcyMin;
    else if(m_stateRequest > m_dcyMax)
        m_stateRequest = m_dcyMax;
}

void PWMOutput::setInterlock(int interlock)
{
    //    qDebug() << __func__ << interlock << thread();

    if(m_interlock == interlock)return;
    m_interlock = interlock;

    emit interlockChanged(m_interlock);
}

void PWMOutput::setDutyCycleMinimum(int dcyMin)
{
    m_dcyMin = dcyMin;
}

void PWMOutput::setDutyCycleMaximum(int dcyMax)
{
    m_dcyMax = dcyMax;
}

