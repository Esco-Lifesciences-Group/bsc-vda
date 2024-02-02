#include "AlarmLog.h"
#define DB_CONN_NAME "AlarmLogConnRoutineTask"

AlarmLog::AlarmLog(QObject *parent) : ClassManager(parent)
{

}

void AlarmLog::routineTask(int parameter)
{
    qDebug() << __func__ << thread();

    Q_UNUSED(parameter)

    if(!pSqlInterface) return;

    /// initial sql connection
    bool initialized = pSqlInterface->init(DB_CONN_NAME);
    Q_UNUSED(initialized);
    //    qDebug() << __func__ << "initialDb" << initialized << thread();

    int count;
    pSqlInterface->queryCount(&count);

    if(m_rowCount != count){
        m_rowCount = count;

        emit rowCountChanged(count);
    }

    /// wait until explicity called 'quit'
    /// here will called eventloop object and listen any event request
    exec();
}

void AlarmLog::reInitialize()
{
    /// Remove the old connection and recreate a new connection
    QSqlDatabase::removeDatabase(DB_CONN_NAME);
    if(!pSqlInterface) return;
    /// initial sql connection
    pSqlInterface->init(DB_CONN_NAME);
    int count;
    pSqlInterface->queryCount(&count);

    m_rowCount = count;
    emit rowCountChanged(count);
}

AlarmLogSql* AlarmLog::getPSqlInterface() const
{
    return pSqlInterface;
}

void AlarmLog::setPSqlInterface(AlarmLogSql *value)
{
    pSqlInterface = value;
}

void AlarmLog::emitSetAlarmLogCount(int count)
{
    emit setAlarmLogCount(count);
}

void AlarmLog::emitSetAlarmLogIsFull(bool value)
{
    emit setAlarmLogIsFull(value);
}
