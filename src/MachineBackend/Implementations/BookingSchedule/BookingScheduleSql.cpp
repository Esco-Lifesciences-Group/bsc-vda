#include "BookingScheduleSql.h"
#include <QProcess>

#define DEFAULT_CONNECTION_NAME             "BOOKINGSCHEDULE_DB"
#define DEFAULT_DB_LOCATION                 "bookingschedule.db"

#define DB_QUERY_INIT                       "\
CREATE TABLE IF NOT EXISTS bookingschedule_V2 \
(date TEXT,\
 time TEXT,\
 bookTitle TEXT,\
 bookBy TEXT,\
 note1 TEXT,\
 note2 TEXT,\
 note3 TEXT,\
 createdAt TEXT,\
 username TEXT)"

#define DB_QUERY_ADD                        "INSERT INTO bookingschedule_V2 VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)"

#define DB_QUERY_DELETE                     "DELETE FROM bookingschedule_V2"
#define DB_QUERY_DELETE_OLDEST_ROWID        "DELETE FROM bookingschedule_V2 WHERE ROWID = (SELECT ROWID FROM bookingschedule_V2 ORDER BY ROWID LIMIT 1)"
#define DB_QUERY_COUNT_ROWS                 "SELECT COUNT(*) FROM bookingschedule_V2"

//#define DB_QUERY_SELECT_WITH_OFFSET_LIMIT_ASC        "SELECT * FROM bookingschedule_V2 ORDER BY ROWID ASC LIMIT :limit OFFSET :offset;"
//#define DB_QUERY_SELECT_WITH_OFFSET_LIMIT_DESC       "SELECT * FROM bookingschedule_V2 ORDER BY ROWID DESC LIMIT :limit OFFSET :offset;"
#define DB_QUERY_SELECT                     "SELECT rowid,* FROM bookingschedule_V2"
//#define DB_QUERY_SELECT                     "SELECT * FROM bookingschedule_V2"

BookingScheduleSql::BookingScheduleSql(QObject *parent) : QObject(parent)
{

}

BookingScheduleSql::~BookingScheduleSql()
{
    QSqlDatabase::removeDatabase(m_connectionName);
}

bool BookingScheduleSql::init(const QString &uniqConnectionName, const QString &fileName)
{
    qDebug () << __FUNCTION__ << thread();

    m_connectionName = uniqConnectionName.isEmpty() ? DEFAULT_CONNECTION_NAME : uniqConnectionName;

    QSqlDatabase m_dataBase;
    m_dataBase = QSqlDatabase::addDatabase("QSQLITE", m_connectionName);

    QString targetLocation = fileName;
    if(fileName.isEmpty()) {
        QString dataPath = QStandardPaths::writableLocation(QStandardPaths::DataLocation);
        targetLocation = dataPath + "/" + DEFAULT_DB_LOCATION;
        //        qDebug() << defaultTargetLocation;
    }
    m_dataBase.setDatabaseName(targetLocation);

    if(m_dataBase.open()){
        QSqlQuery query(QSqlDatabase::database(m_connectionName));
        if(query.exec(DB_QUERY_INIT)){
            return true;
        }
    }else{
        /// fix the timestamps of the file
        /// if the reason is corrupted file
#ifdef __linux__
        QProcess qprocess;
        qprocess.start("touch", QStringList() << targetLocation);
        qprocess.waitForFinished();
#endif

        /// Try to re open the database
        if(m_dataBase.open()){
            QSqlQuery query(QSqlDatabase::database(m_connectionName));
            if(query.exec(DB_QUERY_INIT)){
                return true;
            }
        }
    }
    //    qDebug() << m_dataBase.lastError().text();
    m_queryLastErrorStr = m_dataBase.lastError().text();
    return false;
}

bool BookingScheduleSql::queryInsert(const QVariantMap data)
{
    qDebug () << __FUNCTION__ << thread();

    bool success = false;

    QSqlQuery query(QSqlDatabase::database(m_connectionName));

    bool prepared = query.prepare(DB_QUERY_ADD);
    Q_UNUSED(prepared);
    //    qDebug() << prepared;

    query.addBindValue(data["date"].toString());
    query.addBindValue(data["time"].toString());
    query.addBindValue(data["bookTitle"].toString());
    query.addBindValue(data["bookBy"].toString());
    query.addBindValue(data["note1"].toString());
    query.addBindValue(data["note2"].toInt());
    query.addBindValue(data["note3"].toString());
    query.addBindValue(data["createdAt"].toInt());
    query.addBindValue(data["username"].toInt());

    //    qDebug() << query.lastQuery();

    if(query.exec()) {
        success = true;
    }
    //    else {
    //        //        qDebug() << "error";
    //    }
    m_queryLastErrorStr = query.lastError().text();
    return success;
}

bool BookingScheduleSql::querySelect(QVariantList *data, const QString &dbQueryConfig)
{
    //    qDebug () << __FUNCTION__ << QThread::currentThreadId();

    QSqlQuery query(QSqlDatabase::database(m_connectionName));

    QString statement(DB_QUERY_SELECT);
    statement.append(dbQueryConfig);
    bool prepared = query.prepare(statement);
    Q_UNUSED(prepared)
    //    qDebug() << prepared << query.lastQuery();

    bool success = false;
    if(query.exec()){
        success = true;
        while(query.next()){
            QVariantList dataItem;

            dataItem.push_back(query.value(TableHeaderEnum::TH_ROWID));
            dataItem.push_back(query.value(TableHeaderEnum::TH_TIMESTAMP));
            dataItem.push_back(query.value(TableHeaderEnum::TH_DATESCHEDULE));
            dataItem.push_back(query.value(TableHeaderEnum::TH_TIMESCHEDULE));
            dataItem.push_back(query.value(TableHeaderEnum::TH_BOOKTITLESCHEDULE));
            dataItem.push_back(query.value(TableHeaderEnum::TH_BOOKBYSCHEDULE));
            dataItem.push_back(query.value(TableHeaderEnum::TH_NOTEFIRSTSCHEDULE));
            dataItem.push_back(query.value(TableHeaderEnum::TH_NOTESECONDSCHEDULE));
            dataItem.push_back(query.value(TableHeaderEnum::TH_NOTETHIRDSCHEDULE));
            dataItem.push_back(query.value(TableHeaderEnum::TH_CREATEDATSCHEDULE));
            dataItem.push_back(query.value(TableHeaderEnum::TH_USERNAMESCHEDULE));

            data->push_back(dataItem);
        }
    }
    //    else{
    //        qWarning() << __func__ << query.lastError().text();
    //    }
    m_queryLastErrorStr = query.lastError().text();
    return success;
}
bool BookingScheduleSql::queryDelete(const QString &dbQueryConfig)
{
    qDebug () << __FUNCTION__ << thread();

    bool success = false;

    QSqlQuery query(QSqlDatabase::database(m_connectionName));

    QString statement(DB_QUERY_DELETE);
    statement.append(dbQueryConfig);
    bool prepared = query.prepare(statement);
    Q_UNUSED(prepared)

    if(query.exec()){
        success = true;
    }
    //    else{
    //        qWarning() << __func__  << query.lastError();
    //    }
    m_queryLastErrorStr = query.lastError().text();
    return success;
}

bool BookingScheduleSql::queryDeleteOldestRowId()
{
    qDebug () << __FUNCTION__ << thread();

    bool success = false;

    QSqlQuery query(QSqlDatabase::database(m_connectionName));

    QString statement(DB_QUERY_DELETE_OLDEST_ROWID);

    qDebug() << statement;

    bool prepared = query.prepare(statement);
    Q_UNUSED(prepared)

    if(query.exec()){
        success = true;
    }
    else{
        qWarning() << __func__  << query.lastError();
    }
    qDebug() << success;
    m_queryLastErrorStr = query.lastError().text();
    return success;
}

bool BookingScheduleSql::queryCount(int *count)
{
    bool success = false;

    QSqlQuery query(QSqlDatabase::database(m_connectionName));

    bool prepared = query.prepare(DB_QUERY_COUNT_ROWS);
    Q_UNUSED(prepared)

    if(query.exec()){
        success = true;
        query.next();
        *count = query.value(0).toInt();
    }
    m_queryLastErrorStr = query.lastError().text();
    return success;
}

QString BookingScheduleSql::lastQueryErrorStr() const
{
    return m_queryLastErrorStr;
}
