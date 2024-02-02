#include "BookingSchedule.h"
#define DB_CONN_NAME "BookingScheduleConnRoutineTask"

#include <QDate>

BookingSchedule::BookingSchedule(QObject *parent) : ClassManager(parent)
{
    m_logBuffer.clear();
}

void BookingSchedule::routineTask(int parameter)
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

    emit hasInitialized();

    /// wait until explicity called 'quit'
    /// here will called eventloop object and listen any event request
    exec();
}

void BookingSchedule::reInitialize()
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

BookingScheduleSql *BookingSchedule::getPSqlInterface() const
{
    return pSqlInterface;
}

void BookingSchedule::setPSqlInterface(BookingScheduleSql *value)
{
    pSqlInterface = value;
}

///
/// \brief BookingSchedule::selectByDate
/// \param dateStr: yyyy-MM-dd
///
void BookingSchedule::selectByDate(const QString &dateStr)
{
    qDebug() << __func__ << dateStr << thread();

    QMetaObject::invokeMethod(pSqlInterface, [&, dateStr](){
        qDebug() << __func__ << thread();

        /// get the total rows after delete
        int count = 0;
        pSqlInterface->queryCount(&count);
        //        setTotalRows(count);

        QString options = QString().asprintf(" WHERE date='%s' ORDER BY time", qPrintable(dateStr));

        QVariantList logBuffer, logReady;
        bool done = pSqlInterface->querySelect(&logBuffer, options);
        //        setLastQueryError(!done);
        if(done) {
            /// Reconstructing every item to JSON/VariantMaplist
            /// so, QML Listview ease to present the data
            QVariantMap item;
            QVariantList itemTemp;

            /// insert empty slot, so booking will displayed as a series start from 6.00 to 22.00

            for(int i=0; i < 24; i++) {
                item.clear();

                //                short j = 6 + i;
                //                if(j >= 24)
                //                    j -= 24;

                QString timeStr = QString("%1:00").arg(i, 2, 10, QLatin1Char('0'));

                item.insert("rowid",     "");
                item.insert("date",      dateStr);
                item.insert("time",      timeStr);
                item.insert("bookTitle", "");
                item.insert("bookBy",    "");
                item.insert("note1",     "");
                item.insert("note2",     "");
                item.insert("note3",     "");
                item.insert("createdAt", "");
                item.insert("username",  "");

                logReady.append(item);
            }

            /// Repelace booked slot
            QTime timeParsed;
            //            qDebug() << "logBuffer" << logBuffer.length();
            for(int i=0; i < logBuffer.length(); i++){
                itemTemp = logBuffer.at(i).toList();

                item.clear();
                item.insert("rowid",     itemTemp.at(0/*TH_ROWID*/));
                item.insert("date",      itemTemp.at(1/*TH_DATESCHEDULE*/));
                item.insert("time",      itemTemp.at(2/*TH_TIMESCHEDULE*/));
                item.insert("bookTitle", itemTemp.at(3/*TH_BOOKTITLESCHEDULE*/));
                item.insert("bookBy",    itemTemp.at(4/*TH_BOOKBYSCHEDULE*/));
                item.insert("note1",     itemTemp.at(5/*TH_NOTEFIRSTSCHEDULE*/));
                item.insert("note2",     itemTemp.at(6/*TH_NOTESECONDSCHEDULE*/));
                item.insert("note3",     itemTemp.at(7/*TH_NOTETHIRDSCHEDULE*/));
                item.insert("createdAt", itemTemp.at(8/*TH_CREATEDATSCHEDULE*/));
                item.insert("username", itemTemp.at(9/*TH_USERNAMESCHEDULE*/));

                timeParsed = QTime::fromString(itemTemp.at(2).toString(), "HH:mm");
                int slotIndex = timeParsed.hour();
                qDebug() << "slotIndex" << slotIndex;
                logReady[slotIndex/*-6*/] = item;
            }
        }
        else {
            qWarning() << pSqlInterface->lastQueryErrorStr();
        }

        //        if(m_delayEmitSignal>0) QThread::msleep(m_delayEmitSignal);
        /// total row not implemented in booking schedule
        emit selectHasDone(done, logReady, -1);

        //        m_lastDoneTransactionStatus = done;
        //        qDebug() << __func__ << logReady;
    });
}//

QVariantList BookingSchedule::getTodaysSchedule() const
{
    return m_logBuffer;
}
