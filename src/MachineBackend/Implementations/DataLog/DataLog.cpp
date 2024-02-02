#include "DataLog.h"
#define DB_CONN_NAME "DataLogConnRoutineTask"

DataLog::DataLog(QObject *parent) : ClassManager(parent)
{

}

void DataLog::routineTask(int parameter)
{
    qDebug() << metaObject()->className() << __FUNCTION__ << thread();

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

void DataLog::reInitialize()
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

DataLogSql *DataLog::getPSqlInterface() const
{
    qDebug() << metaObject()->className() << __FUNCTION__ << thread();

    return pSqlInterface;
}

void DataLog::setPSqlInterface(DataLogSql *value)
{
    qDebug() << metaObject()->className() << __FUNCTION__ << thread();

    pSqlInterface = value;
}

void DataLog::emitSetDataLogCount(int count)
{
    emit setDataLogCount(count);
}

void DataLog::emitSetDataLogIsFull(bool value)
{
    emit setDataLogIsFull(value);
}
