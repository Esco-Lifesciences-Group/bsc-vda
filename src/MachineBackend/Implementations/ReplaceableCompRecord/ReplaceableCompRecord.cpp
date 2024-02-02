#include "ReplaceableCompRecord.h"
#include "./MachineEnums.h"

#define DB_CONN_NAME "ReplaceableCompRecordConnRoutineTask"

ReplaceableCompRecord::ReplaceableCompRecord(QObject *parent) : ClassManager(parent)
{
    m_rpListSelected.clear();
    for(short i=0; i< MachineEnums::RPList_Total; i++){
        m_rpListSelected.append("");
    }
}

void ReplaceableCompRecord::routineTask(int parameter)
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

void ReplaceableCompRecord::reInitialize()
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

ReplaceableCompRecordSql *ReplaceableCompRecord::getPSqlInterface() const
{
    return pSqlInterface;
}

void ReplaceableCompRecord::setPSqlInterface(ReplaceableCompRecordSql *value)
{
    pSqlInterface = value;
}

bool ReplaceableCompRecord::getDataFromTableAtRowId(QStringList *data, short rowId)
{
    //short offset = rowId;
    QString options = QString().asprintf("  ORDER BY ROWID DESC");
    qDebug() << options;
    QVariantList logBuffer;
    bool done = pSqlInterface->querySelect(&logBuffer, options);
    if(done) {
        //        qDebug() << "logBuffer length:" << logBuffer.length();
        //        qDebug() << logBuffer;
    }
    else {
        qWarning() << pSqlInterface->lastQueryErrorStr();
    }
    *data = logBuffer.at(rowId).toStringList();
    return done;
}//


void ReplaceableCompRecord::setRpListSelected(QVariantList value)
{
    if(m_rpListSelected == value)return;
    m_rpListSelected = value;
    emit rpListSelectedChanged(value);
}

void ReplaceableCompRecord::setRpListSelected(short index, const QString &value)
{
    if(index >= m_rpListSelected.length() || index < 0) return;
    if(m_rpListSelected.at(index).toString() == value) return;

    QVariantList tempVarList = m_rpListSelected;
    //    qDebug() << "replace index" << index << tempVarList.at(index) << "with" << value;
    //    qDebug() << "before" << tempVarList.at(index).toString();
    tempVarList.takeAt(index);
    tempVarList.insert(index, value);
    //    qDebug() << "after" << tempVarList.at(index).toString();
    setRpListSelected(tempVarList);
}

void ReplaceableCompRecord::emitSetReplaceableCompRecordCount(int count)
{
    emit setReplaceableCompRecordCount(count);
}

void ReplaceableCompRecord::emitSetReplaceableCompRecordIsFull(bool value)
{
    emit setReplaceableCompRecordIsFull(value);
}
