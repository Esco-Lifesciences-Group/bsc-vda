#include "EventLog.h"
#define DB_CONN_NAME "EventLogConnRoutineTask"

EventLog::EventLog(QObject *parent) : ClassManager(parent)
{

}

void EventLog::routineTask(int parameter)
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

void EventLog::reInitialize()
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

EventLogSql *EventLog::getPSqlInterface() const
{
    return pSqlInterface;
}

void EventLog::setPSqlInterface(EventLogSql *value)
{
    pSqlInterface = value;
}

void EventLog::emitSetEventLogCount(int count)
{
    emit setEventLogCount(count);
}

void EventLog::emitSetEventLogIsFull(bool value)
{
    emit setEventLogIsFull(value);
}
