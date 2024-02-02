#pragma once

#include "../ClassManager.h"
#include "BoardIO/Drivers/PWMpca9685/PWMpca9685.h"

class PWMOutput : public ClassManager
{
    Q_OBJECT
public:
    explicit PWMOutput(QObject *parent = nullptr);

    enum Channel{CH_1, CH_2, CH_3, CH_4};
    void routineTask(int parameter = 0) override;

    void setSubModule(PWMpca9685 * obj);
    void setChannelIO(int channel);
    void setState(int state);
    void setInterlock(int interlock);
    void setDutyCycleMinimum(int dcyMin);
    void setDutyCycleMaximum(int dcyMax);

    int interlock() const;
    int state() const;

    bool dummyStateEnable() const;
    void setDummyStateEnable(bool dummyStateEnable);

    short dummyState() const;
    void setDummyState(short dummyState);

signals:
    void stateChanged(int newVal);
    void interlockChanged(int newVal);
    void channelIOChanged(int newVal, int oldVal);
    void workerFinished();

private:
    PWMpca9685  *pSubModule;
    int m_channelIO;

    int m_state;
    int m_interlock;
    int m_stateRequest;
    int m_dcyMin = 0;
    int m_dcyMax = 100;

    //    bool m_dummyStateEnable = true;
    bool m_dummyStateEnable = false;
    short m_dummyState = 0;
};

