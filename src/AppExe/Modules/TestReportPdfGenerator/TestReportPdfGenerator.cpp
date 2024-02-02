#include "TestReportPdfGenerator.h"
#include <QStandardPaths>
#include <QPdfWriter>
#include <QFile>
#include <QPainter>
#include <QDir>
#include <QStandardPaths>
#include <QTextStream>
#include <QPrinter>
#include <QProcess>
#include <QTextDocument>
#include <QtConcurrent/QtConcurrent>

TestReportPdfGenerator::TestReportPdfGenerator(QObject *parent) : QObject(parent)
{

}

bool TestReportPdfGenerator::getInitialized() const
{
    return m_initialized;
}

void TestReportPdfGenerator::setInitialized(bool initialized)
{
    if (m_initialized == initialized)
        return;

    m_initialized = initialized;
    emit initializedChanged(m_initialized);
}

void TestReportPdfGenerator::init()
{
    // sanity check dont allow to double created the instance
    //m_pThread = new QThread();
    if (m_pThread != nullptr){
        qDebug() << __func__ << "Thread still here";
        return;
    }

    m_pThread = QThread::create([&](){
        //        qDebug() << "m_pThread::create" << thread();

        m_pdfGen.reset(new TestReportPdfGenerator());
        
        //check font first, if not available, send signal to qml

#ifdef __linux__
        QProcess qprocess;
        qprocess.start("rootrw");
        qprocess.waitForFinished();

        QDir dir(QString("/usr/share/fonts/truetype/freefont"));
        if(!dir.exists()){
            dir.mkpath(".");
        }

        qprocess.start("rootro");
        qprocess.waitForFinished();

        if((!QFile::exists("/usr/share/fonts/truetype/freefont/arial.ttf"))
            || (!QFile::exists("/usr/share/fonts/truetype/freefont/GARA.TTF"))){
            m_fontAvailable = false;
            emit fontNotAvailable(true);
        }
        else{
            setInitialized(true);
        }
#else
        setInitialized(true);
        //emit fontNotAvailable(true);
#endif

        QEventLoop loop;
        //        connect(this, &DataLogQmlApp::destroyed, &loop, &QEventLoop::quit);
        loop.exec();

        //        qDebug() << "m_pThread::end";
    });

    //// Tells the thread's event loop to exit with return code 0 (success).
    connect(this, &TestReportPdfGenerator::destroyed, m_pThread, &QThread::quit);
    connect(m_pThread, &QThread::finished, [](){
        qDebug() << "Thread has finished";
    });
    //connect(m_pThread, &QThread::finished, m_pThread, &QThread::deleteLater);
    connect(m_pThread, &QThread::destroyed, [](){
        qDebug() << "Thread will destroying";
        //setInitialized(false);
    });

    m_pThread->start();
}

void TestReportPdfGenerator::generatePdfFile(const QString &sourceJson, const QString &outputFilename)
{
    QMetaObject::invokeMethod(m_pdfGen.data(), [&, sourceJson, outputFilename](){
        /// GENERATE PDF FILE SECTION
        QString targetDir = QStandardPaths::writableLocation(QStandardPaths::AppLocalDataLocation);
        qDebug() << targetDir;

        QString fileName = targetDir + "//report/" + outputFilename;//QString("/FM-TST-TR-BSC-LC1-G4-A.pdf");
        QFile pdfFile(fileName);
        bool fileIsOK = pdfFile.open(QIODevice::WriteOnly);
        qDebug() << fileIsOK;
        if(!fileIsOK){
            qDebug() << "Failed to init file";
            emit pdfExportFinished(false, fileName);
            return ;
        }

        //fix some path at html file first, comment for debug
        htmlEditFile();

        //
        QPrinter printer(QPrinter::PrinterResolution);
        QMarginsF margins = QMarginsF(10, 5, 5, 5);
        printer.setOutputFormat(QPrinter::PdfFormat);
        printer.setPageMargins(margins, QPageLayout::Unit::Millimeter);
        printer.setPageSize(QPageSize(QPageSize::A4));
        printer.setColorMode(QPrinter::GrayScale);
        printer.setOutputFileName(fileName);

        QString tempS;
        tempS = targetDir + "/report/index.html";


        QString newHtml = targetDir + "/report/index_n.html";
        QFile nhtml(newHtml);

        QFile html(tempS);

        //fill data at html page, comment for debug
        {
            if(html.exists()){
                //qDebug() << "html template file exist";
                if(html.open(QIODevice::ReadWrite)){
                    QByteArray fileData;
                    fileData = html.readAll();
                    QString htmlTxt = (fileData);
                    ///qDebug() << targetDir;

                    QFile jsonFile(targetDir + "/" + sourceJson);
                    jsonFile.open(QIODevice::ReadOnly);
                    QByteArray jsonData = jsonFile.readAll();
                    jsonFile.close();

                    /// Delete source file after data copied
                    jsonFile.remove();

                    qDebug() << "@@@ jsonData @@@" << jsonData.toStdString().c_str();

                    QJsonDocument document = QJsonDocument::fromJson(jsonData);
                    QJsonObject jsonObj = document.object();
                    if(m_outputType == "TR"){
                        if(m_customer == "ETI"){
                            htmlTxt.replace(QString("Worldwide Headquarters."), QString("Esco Technologies, Inc."));
                            htmlTxt.replace(QString("Esco Micro Pte. Ltd."), QString("903 Sheehy Drive, Suite F Horsham"));
                            htmlTxt.replace(QString("21 Changi South Street 1, Singapore 486777"), QString("Pennsylvania 19044, USA"));
                            htmlTxt.replace(QString("Tel: +65 65420833  Fax: +65 65426920"), QString("Toll-Free (USA and Canada): 1-877-479-3726"));
                            htmlTxt.replace(QString("Email: mail@escolifesciences.com"), QString("Phone: (215) 441-9661 Fax: (215) 484-698-7757"));
                            htmlTxt.replace(QString("Site: http://escolifesciences.com"), QString("eti.sales@escolifesciences.com * escolifesciences.us"));
                        }//
#ifdef __arm__
                        if(m_calibType == "FIELD_A")
                            htmlTxt.replace(QString("#rpi_br_01#"), QString("<br><br><br>"));
                        else
                            htmlTxt.replace(QString("#rpi_br_01#"), QString("<br><br>"));
                        htmlTxt.replace(QString("#bpi_br_01#"), QString(""));
                        htmlTxt.replace(QString("#win_br_01#"), QString(""));
#else
                            htmlTxt.replace(QString("#rpi_br_01#"), QString(""));
                            htmlTxt.replace(QString("#bpi_br_01#"), QString(""));
                            htmlTxt.replace(QString("#win_br_01#"), QString(""));
#endif
                        qDebug() << "@@@ docpro_field @@@" << jsonObj["docpro_field"].toString() << jsonObj["sw_ver"].toString();

                        htmlTxt.replace(QString("#cert_pro#"), QString(jsonObj["docpro"].toString()));
                        htmlTxt.replace(QString("#cert_pro_field#"), QString(jsonObj["docpro_field"].toString()));
                        htmlTxt.replace(QString("#softver#"), QString(jsonObj["sw_ver"].toString()));

                        //unit variable
                        QString uvo, uve, ute, udo, upres;
                        QString ifnpc, ifmpc, ifspc, dfnpc, dfnpci;
                        QString ifnvef, ifmvef;
                        double ifnpcInt = 0, ifmpcInt = 0, ifspcInt = 0, dfnpcInt = 0, dfnpciInt, tol = 0;
                        int sashOpening = jsonObj["sash_opening"].toInt();
                        int cabinetSize = jsonObj["cabinet_size"].toInt();
                        if (!m_measurementUnit){
                            uvo = "l/s";
                            uve = "m/s";
                            ute = "<span>&#176;</span>C";
                            udo = "mm";
                            upres = "Pa";

                            ifnpc = "0.53 <span>&#177;</span> 0.025 m/s"; ifnpcInt = 53; ifnvef = "0.53";
                            ifmpc = "0.40 <span>&#177;</span> 0.025 m/s"; ifmpcInt = 40; ifmvef = "0.40";
                            ifspc = "1.00 <span>&#177;</span> 0.025 m/s"; ifspcInt = 100;
                            /// Specific for LA2_VA2
                            if((cabinetSize == 3 && sashOpening == 8)
                                || (cabinetSize == 4)
                                || (cabinetSize == 5 && sashOpening == 8)
                                || (cabinetSize == 6 && sashOpening != 12)){
                                dfnpc = "0.30 <span>&#177;</span> 0.025 m/s"; dfnpcInt = 30;
                            }
                            else if((cabinetSize == 3 && sashOpening == 10)
                                     || (cabinetSize == 5 && sashOpening == 10)){
                                dfnpc = "0.33 <span>&#177;</span> 0.025 m/s"; dfnpcInt = 33;
                            }
                            else if(cabinetSize != 4 && sashOpening == 12){
                                dfnpc = "0.35 <span>&#177;</span> 0.025 m/s"; dfnpcInt = 35;
                            }

                            dfnpci = "<span>&#177;</span> 0.08 m/s"; dfnpciInt = 8;
                            tol = 2.5;
                        }
                        else {
                            uvo = "cfm";
                            uve = "fpm";
                            ute = "<span>&#176;</span>F";
                            udo = "in";
                            upres = "<span>&ldquo;</span>wg";

                            ifnpc = "105 <span>&#177;</span> 5 fpm"; ifnpcInt = 10500; ifnvef = "105";
                            ifmpc = "80 <span>&#177;</span> 5 fpm"; ifmpcInt = 8000; ifmvef = "80";
                            ifspc = "197 <span>&#177;</span> 5 fpm"; ifspcInt = 19700;

                            /// Specific for LA2_VA2
                            if((cabinetSize == 3 && sashOpening == 8)
                                || (cabinetSize == 4)
                                || (cabinetSize == 5 && sashOpening == 8)
                                || (cabinetSize == 6 && sashOpening != 12)){
                                dfnpc = "60 <span>&#177;</span> 5 fpm"; dfnpcInt = 6000;
                            }
                            else if((cabinetSize == 3 && sashOpening == 10)
                                     || (cabinetSize == 5 && sashOpening == 10)){
                                dfnpc = "65 <span>&#177;</span> 5 fpm"; dfnpcInt = 6500;
                            }
                            else if(cabinetSize != 4 && sashOpening == 12){
                                dfnpc = "70 <span>&#177;</span> 5 fpm"; dfnpcInt = 7000;
                            }

                            dfnpci = "<span>&#177;</span> 16 fpm"; dfnpciInt = 1600;
                            tol = 500;
                        }

                        htmlTxt.replace(QString("#testnumber#"), QString(jsonObj["test_number"].toString()));

                        if(jsonObj["wo_number"].toString() != "")
                            htmlTxt.replace(QString("#model#"), QString(jsonObj["cabinet_model"].toString()) + " WO: " + QString(jsonObj["wo_number"].toString()));
                        else
                            htmlTxt.replace(QString("#model#"), QString(jsonObj["cabinet_model"].toString()));
                        htmlTxt.replace(QString("#serialnum#"), QString(jsonObj["serial_number"].toString()));
                        htmlTxt.replace(QString("#testby#"), QString(jsonObj["tested_by"].toString()));
                        htmlTxt.replace(QString("#checkby#"), QString(jsonObj["checked_by"].toString()));

                        htmlTxt.replace(QString("#power_supply#"), QString(jsonObj["power_rating"].toString()));
                        if(m_calibType != "FULL"){
                            int ducyNomDim = jsonObj["ducy_nom"].toInt();
                            int ducyNomSec = jsonObj["ducy_nom_sec"].toInt();
                            if(ducyNomSec >= ducyNomDim)
                                htmlTxt.replace(QString("#nom_dut#"), QString::number(ducyNomSec) + "%");
                            else
                                htmlTxt.replace(QString("#nom_dut#"), QString::number(ducyNomDim) + "%");
                        }else{
                            htmlTxt.replace(QString("#nom_dut#"), QString::number(jsonObj["ducy_nom"].toInt()) + "%");
                        }
                        htmlTxt.replace(QString("#room_temp#"), QString::number(jsonObj["room_temp"].toInt()) + ute);
                        htmlTxt.replace(QString("#room_pres#"), QString(jsonObj["room_press"].toString()) + " Bar");
                        htmlTxt.replace(QString("#date#"), QString(jsonObj["test_date"].toString()));

                        QJsonArray gridArr;
                        int i;
                        /// INFLOW NOMINAL
                        gridArr = QJsonDocument::fromJson(jsonObj.value("grid_ifa_nom").toString().toStdString().c_str()).array();
                        i = 1;

                        //qDebug() << "&*&*&*&*" << gridArr;
                        bool gridAvailable = true;
                        if(!gridArr.size()){
                            gridAvailable = false;
                            QString jsonStr = "[{\"val\":0},{\"val\":0},{\"val\":0},{\"val\":0},{\"val\":0}]";
                            gridArr = QJsonDocument::fromJson(jsonStr.toStdString().c_str()).array();
                        }
                        foreach (const QJsonValue & val, gridArr){
                            QString temp = "#ifn" + QString::number(i) + "#";
                            int value = val.toObject().value("val").toInt();
                            htmlTxt.replace(temp, gridAvailable ? QString::number(value) : "NA");
                            qDebug() << temp << value;
                            i++;
                        }

                        htmlTxt.replace(QString("#ifnt#"), gridAvailable ? QString::number(jsonObj["grid_ifa_nom_total"].toInt()) : "NA");
                        htmlTxt.replace(QString("#ifna#"), gridAvailable ? QString::number(jsonObj["grid_ifa_nom_avg"].toDouble()) : "NA");
                        htmlTxt.replace(QString("#ifnvo#"), gridAvailable ? QString::number(jsonObj["grid_ifa_nom_avg"].toDouble()) : "NA");
                        if(!m_measurementUnit){
                            htmlTxt.replace(QString("#ifnve#"), gridAvailable ? QString::asprintf("%.2f", (jsonObj["grid_ifa_nom_vel"].toDouble()/100.00)) : "NA");
                        }
                        else{
                            htmlTxt.replace(QString("#ifnve#"), gridAvailable ? QString::asprintf("%.2d", (jsonObj["grid_ifa_nom_vel"].toInt()/100)) : "NA");
                        }

                        htmlTxt.replace(QString("#ifnpc#"), ifnpc);
                        if(gridAvailable){
                            if((jsonObj["grid_ifa_nom_vel"].toDouble() <= (ifnpcInt+tol)) && (jsonObj["grid_ifa_nom_vel"].toDouble() >= (ifnpcInt-tol)))
                                htmlTxt.replace(QString("#ifnp#"), "PASS");
                            else
                                htmlTxt.replace(QString("#ifnp#"), "FAIL");
                        }
                        else{
                            htmlTxt.replace(QString("#ifnp#"), "NA");
                        }

                        /// INFLOW NOMINAL SECONDARY
                        if(m_calibType != "FULL"){
                            gridArr = QJsonDocument::fromJson(jsonObj.value("grid_ifa_nom_sec").toString().toStdString().c_str()).array();
                            i = 1;
                            gridAvailable = true;

                            //qDebug() << "@@@ grid_ifa_nom_sec" << gridArr.size() << jsonObj.value("grid_ifa_nom_sec").toString();

                            if(!gridArr.size()){
                                gridAvailable = false;
                                QString jsonStr = "[{\"val\":0},{\"val\":0},{\"val\":0},{\"val\":0},{\"val\":0},{\"val\":0}]";
                                if(cabinetSize == 4){
                                    jsonStr = "[{\"val\":0},{\"val\":0},{\"val\":0},{\"val\":0},{\"val\":0},{\"val\":0},{\"val\":0},{\"val\":0}]";
                                }else if(cabinetSize == 5){
                                    jsonStr = "[{\"val\":0},{\"val\":0},{\"val\":0},{\"val\":0},{\"val\":0},{\"val\":0},{\"val\":0},{\"val\":0},{\"val\":0},{\"val\":0}]";
                                }else if(cabinetSize == 6){
                                    jsonStr = "[{\"val\":0},{\"val\":0},{\"val\":0},{\"val\":0},{\"val\":0},{\"val\":0},{\"val\":0},{\"val\":0},{\"val\":0},{\"val\":0},{\"val\":0},{\"val\":0}]";
                                }
                                gridArr = QJsonDocument::fromJson(jsonStr.toStdString().c_str()).array();
                            }
                            //qDebug() << "&*&*&*&*" << gridArr;
                            foreach (const QJsonValue & val, gridArr){
                                QString temp = "#ifns" + QString::number(i) + "#";
                                //qDebug() << val;
                                //qDebug() << val.toObject();
                                //qDebug() << val.toObject().value("val");
                                double value = 0;
                                if(m_measurementUnit){
                                    value = val.toObject().value("valImp").toDouble();
                                    htmlTxt.replace(temp, gridAvailable ? QString::number(qRound(value)) : "NA");
                                }
                                else{
                                    value = val.toObject().value("val").toDouble();
                                    htmlTxt.replace(temp, gridAvailable ? QString::number(value, 'g', 3) : "NA");
                                }
                                //qDebug() << temp << value;
                                i++;
                            }
                            for(i = gridArr.size()+1; i<=12; i++){
                                QString temp = "#ifns" + QString::number(i) + "#";
                                htmlTxt.replace(temp, "");
                            }

                            if(!m_measurementUnit){
                                htmlTxt.replace(QString("#ifnsa#"), gridAvailable ? QString::asprintf("%.2f", (jsonObj["grid_ifa_nom_avg_sec"].toDouble()/100.00)) : "NA");
                                htmlTxt.replace(QString("#ifnsc#"), gridAvailable ? QString::asprintf("%.2f", (jsonObj["grid_ifa_nom_vel_sec"].toDouble()/100.00)) : "NA");
                            }
                            else{
                                htmlTxt.replace(QString("#ifnsa#"), gridAvailable ? QString::asprintf("%.2d", (jsonObj["grid_ifa_nom_avg_sec"].toInt()/100)) : "NA");
                                htmlTxt.replace(QString("#ifnsc#"), gridAvailable ? QString::asprintf("%.2d", (jsonObj["grid_ifa_nom_vel_sec"].toInt()/100)) : "NA");
                            }

                            if(gridAvailable){
                                double convVel = jsonObj["grid_ifa_nom_vel_sec"].toDouble();
                                //qDebug() << "grid_ifa_nom_vel_sec" << convVel << ifnpcInt << tol;
                                if((convVel <= (ifnpcInt+tol)) && (convVel >= (ifnpcInt-tol)))
                                    htmlTxt.replace(QString("#ifnsp#"), "PASS");
                                else
                                    htmlTxt.replace(QString("#ifnsp#"), "FAIL");
                            }
                            else{
                                htmlTxt.replace(QString("#ifnsp#"), "NA");
                            }
                        }//

                        /// INFLOW MINIMUM
                        gridArr = QJsonDocument::fromJson(jsonObj.value("grid_ifa_fail").toString().toStdString().c_str()).array();
                        i = 1;
                        gridAvailable = true;
                        if(!gridArr.size()){
                            gridAvailable = false;
                            QString jsonStr = "[{\"val\":0},{\"val\":0},{\"val\":0},{\"val\":0},{\"val\":0}]";
                            gridArr = QJsonDocument::fromJson(jsonStr.toStdString().c_str()).array();
                        }
                        foreach (const QJsonValue & val, gridArr){
                            QString temp = "#ifm" + QString::number(i) + "#";
                            int value = val.toObject().value("val").toInt();
                            htmlTxt.replace(temp, gridAvailable ? QString::number(value) : "NA");
                            //qDebug() << val.toObject().value("val").toInt();
                            i++;
                        }

                        htmlTxt.replace(QString("#ifmt#"), gridAvailable ? QString::number(jsonObj["grid_ifa_fail_total"].toInt()) : "NA");
                        htmlTxt.replace(QString("#ifma#"), gridAvailable ? QString::number(jsonObj["grid_ifa_fail_avg"].toDouble()) : "NA");
                        htmlTxt.replace(QString("#ifmvo#"), gridAvailable ? QString::number(jsonObj["grid_ifa_fail_avg"].toDouble()) : "NA");
                        if(m_measurementUnit == 0){
                            htmlTxt.replace(QString("#ifmve#"), gridAvailable ? QString::asprintf("%.2f", (jsonObj["grid_ifa_fail_vel"].toDouble()/100.00)) : "NA");
                        }
                        else{
                            htmlTxt.replace(QString("#ifmve#"), gridAvailable ? QString::asprintf("%.2d", (jsonObj["grid_ifa_fail_vel"].toInt()/100)) : "NA");
                        }

                        htmlTxt.replace(QString("#ifmpc#"), ifmpc);

                        if(gridAvailable){
                            double convVel = jsonObj["grid_ifa_fail_vel"].toDouble();
                            if((convVel <= (ifmpcInt+tol)) && (convVel >= (ifmpcInt-tol)))
                                htmlTxt.replace(QString("#ifmp#"), "PASS");
                            else
                                htmlTxt.replace(QString("#ifmp#"), "FAIL");
                        }else{
                            htmlTxt.replace(QString("#ifmp#"), "NA");
                        }
                        /// INFLOW MINIMUM SECONDARY
                        if(m_calibType != "FULL"){
                            gridArr = QJsonDocument::fromJson(jsonObj.value("grid_ifa_fail_sec").toString().toStdString().c_str()).array();
                            i = 1;
                            gridAvailable = true;
                            if(!gridArr.size()){
                                gridAvailable = false;
                                QString jsonStr = "[{\"val\":0},{\"val\":0},{\"val\":0},{\"val\":0},{\"val\":0},{\"val\":0}]";
                                if(cabinetSize == 4){
                                    jsonStr = "[{\"val\":0},{\"val\":0},{\"val\":0},{\"val\":0},{\"val\":0},{\"val\":0},{\"val\":0},{\"val\":0}]";
                                }else if(cabinetSize == 5){
                                    jsonStr = "[{\"val\":0},{\"val\":0},{\"val\":0},{\"val\":0},{\"val\":0},{\"val\":0},{\"val\":0},{\"val\":0},{\"val\":0},{\"val\":0}]";
                                }else if(cabinetSize == 6){
                                    jsonStr = "[{\"val\":0},{\"val\":0},{\"val\":0},{\"val\":0},{\"val\":0},{\"val\":0},{\"val\":0},{\"val\":0},{\"val\":0},{\"val\":0},{\"val\":0},{\"val\":0}]";
                                }
                                gridArr = QJsonDocument::fromJson(jsonStr.toStdString().c_str()).array();
                            }
                            //qDebug() << "&*&*&*&*" << gridArr;
                            foreach (const QJsonValue & val, gridArr){
                                QString temp = "#ifms" + QString::number(i) + "#";
                                double value = 0;
                                if(m_measurementUnit){
                                    value = val.toObject().value("valImp").toDouble();
                                    htmlTxt.replace(temp, gridAvailable ? QString::number(qRound(value)) : "NA");
                                }
                                else{
                                    value = val.toObject().value("val").toDouble();
                                    htmlTxt.replace(temp, gridAvailable ? QString::asprintf("%.2f", value) : "NA");
                                }
                                i++;
                            }
                            for(i = gridArr.size()+1; i<=12; i++){
                                QString temp = "#ifms" + QString::number(i) + "#";
                                htmlTxt.replace(temp, "");
                            }

                            if(!m_measurementUnit){
                                htmlTxt.replace(QString("#ifmsa#"), gridAvailable ? QString::asprintf("%.2f", (jsonObj["grid_ifa_fail_avg_sec"].toDouble()/100.00)) : "NA");
                                htmlTxt.replace(QString("#ifmsc#"), gridAvailable ? QString::asprintf("%.2f", (jsonObj["grid_ifa_fail_vel_sec"].toDouble()/100.00)) : "NA");
                            }
                            else{
                                htmlTxt.replace(QString("#ifmsa#"), gridAvailable ? QString::asprintf("%.2d", (jsonObj["grid_ifa_fail_avg_sec"].toInt()/100)) : "NA");
                                htmlTxt.replace(QString("#ifmsc#"), gridAvailable ? QString::asprintf("%.2d", (jsonObj["grid_ifa_fail_vel_sec"].toInt()/100)) : "NA");
                            }

                            if(gridAvailable){
                                double convVel = jsonObj["grid_ifa_fail_vel_sec"].toDouble();
                                //qDebug() << "grid_ifa_fail_vel_sec" << convVel << ifmpcInt << tol;
                                if((convVel <= (ifmpcInt+tol)) && (convVel >= (ifmpcInt-tol)))
                                    htmlTxt.replace(QString("#ifmsp#"), "PASS");
                                else
                                    htmlTxt.replace(QString("#ifmsp#"), "FAIL");
                            }
                            else{
                                htmlTxt.replace(QString("#ifmsp#"), "NA");
                            }
                        }//

                        /// INFLOW STANDBY
                        gridArr = QJsonDocument::fromJson(jsonObj.value("grid_ifa_stb").toString().toStdString().c_str()).array();
                        i = 1;
                        gridAvailable = true;
                        if(!gridArr.size()){
                            gridAvailable = false;
                            QString jsonStr = "[{\"val\":0},{\"val\":0},{\"val\":0},{\"val\":0},{\"val\":0}]";
                            gridArr = QJsonDocument::fromJson(jsonStr.toStdString().c_str()).array();
                        }
                        foreach (const QJsonValue & val, gridArr){
                            QString temp = "#ifs" + QString::number(i) + "#";
                            int value = val.toObject().value("val").toInt();
                            htmlTxt.replace(temp, gridAvailable ? QString::number(value) : "NA");
                            //qDebug() << val.toObject().value("val").toInt();
                            i++;
                        }

                        htmlTxt.replace(QString("#ifst#"), gridAvailable ? QString::number(jsonObj["grid_ifa_stb_total"].toInt()) : "NA");
                        htmlTxt.replace(QString("#ifsa#"), gridAvailable ? QString::number(jsonObj["grid_ifa_stb_avg"].toDouble()) : "NA");
                        htmlTxt.replace(QString("#ifsvo#"), gridAvailable ? QString::number(jsonObj["grid_ifa_stb_avg"].toDouble()) : "NA");
                        if(m_measurementUnit == 0){
                            htmlTxt.replace(QString("#ifsve#"), gridAvailable ? QString::asprintf("%.2f", (jsonObj["grid_ifa_stb_vel"].toDouble()/100.00)) : "NA");
                        }
                        else{
                            htmlTxt.replace(QString("#ifsve#"), gridAvailable ? QString::asprintf("%.2d", (jsonObj["grid_ifa_stb_vel"].toInt()/100)) : "NA");
                        }

                        htmlTxt.replace(QString("#ifspc#"), ifspc);

                        if(gridAvailable){
                            if((jsonObj["grid_ifa_stb_vel"].toDouble() <= (ifspcInt+tol)) && (jsonObj["grid_ifa_stb_vel"].toDouble() >= (ifspcInt-tol)))
                                htmlTxt.replace(QString("#ifsp#"), "PASS");
                            else
                                htmlTxt.replace(QString("#ifsp#"), "FAIL");
                        }else{
                            htmlTxt.replace(QString("#ifsp#"), "NA");
                        }

                        /// DOWNFLOW
                        gridArr = QJsonDocument::fromJson(jsonObj.value("grid_dfa_nom").toString().toStdString().c_str()).array();
                        i = 1;
                        int dfCol[3] = {0};
                        if((cabinetSize == 3) || (cabinetSize == 4)){
                            dfCol[0] = 7;
                            dfCol[1] = 18;
                            dfCol[2] = 29;
                        }
                        else if(cabinetSize == 5){
                            dfCol[0] = 9;
                            dfCol[1] = 20;
                            dfCol[2] = 31;
                        }
                        else if(cabinetSize == 6){
                            dfCol[0] = 11;
                            dfCol[1] = 22;
                            dfCol[2] = 33;
                        }

                        int col = 0;
                        foreach (const QJsonValue & val, gridArr){
                            //qDebug() << "i value: " << i;
                            QString temp = "#d" + QString::number(i) + "#";
                            htmlTxt.replace(temp, QString::number(val.toObject().value("val").toDouble(), 'f', 2));
                            //qDebug() << val.toObject().value("val").toInt();
                            if(i == dfCol[col]){
                                for (int j = i; j < (col+1)*11; j++){
                                    temp = "#d" + QString::number(j+1) + "#";
                                    htmlTxt.replace(temp, "");
                                }
                                i = (col+1)*11;
                                col++;
                            }
                            i++;
                        }//

                        htmlTxt.replace(QString("#dfnavg#"), QString::number(jsonObj["grid_dfa_nom_avg"].toDouble()/100, 'f', 2));
                        htmlTxt.replace(QString("#dfndev#"), QString::number(jsonObj["grid_dfa_nom_dev"].toDouble()/100, 'f', 2));
                        htmlTxt.replace(QString("#dfndp#"), QString::number(jsonObj["grid_dfa_nom_devp"].toDouble()/100)+" %");

                        htmlTxt.replace(QString("#dfnpc#"), dfnpc);
                        htmlTxt.replace(QString("#dfnpci#"), dfnpci);

                        if((jsonObj["grid_dfa_nom_avg"].toDouble() <= (dfnpcInt+tol)) && (jsonObj["grid_dfa_nom_avg"].toDouble() >= (dfnpcInt-tol)))
                            htmlTxt.replace(QString("#dfnp#"), "PASS");
                        else
                            htmlTxt.replace(QString("#dfnp#"), "FAIL");
                        //////////////////////////////////////////////////

                        /// PAO
                        htmlTxt.replace(QString("#pao#"), QString(jsonObj["pao_con"].toString()));
                        htmlTxt.replace(QString("#noz#"), QString::number(jsonObj["noz_laskin"].toInt()));
                        htmlTxt.replace(QString("#dfp#"), QString(jsonObj["df_par_penet"].toString()));
                        htmlTxt.replace(QString("#dfi#"), QString(jsonObj["if_par_penet"].toString()));

                        double dfpartp = (QString(jsonObj["df_par_penet"].toString())).toDouble();
                        double ifpartp = (QString(jsonObj["if_par_penet"].toString())).toDouble();
                        double partpenlim = 0.01;

                        //qDebug() << "part pen: " << dfpartp << (dfpartp > partpenlim) << (dfpartp < partpenlim);
                        //qDebug() << "part pen: " << ifpartp << (ifpartp > partpenlim) << (ifpartp < partpenlim);

                        if((dfpartp < partpenlim) && (ifpartp < partpenlim)){
                            htmlTxt.replace(QString("#hep#"), "PASS");
                        }
                        else htmlTxt.replace(QString("#hep#"), "FAIL");

                        //////////////////////////////////////////////////
                        /// Data Balance the Motor Voltage
                        htmlTxt.replace(QString("#damper#"), QString(jsonObj["damper_opening"].toString()));
                        double nomVelDim = (jsonObj["grid_ifa_nom_vel"].toDouble()/100);
                        double nomVelSec = (jsonObj["grid_ifa_nom_vel_sec"].toDouble()/100);
                        if(nomVelSec >= nomVelDim){
                            if(m_measurementUnit)
                                htmlTxt.replace(QString("#obifn#"), QString::asprintf("%.2d", qRound(nomVelSec)));
                            else
                                htmlTxt.replace(QString("#obifn#"), QString::asprintf("%.2f", nomVelSec));
                        }else{
                            if(m_measurementUnit)
                                htmlTxt.replace(QString("#obifn#"), QString::asprintf("%.2d", qRound(nomVelDim)));
                            else
                                htmlTxt.replace(QString("#obifn#"), QString::asprintf("%.2f", nomVelDim));
                        }
                        if(m_measurementUnit)
                            htmlTxt.replace(QString("#obdfn#"), QString::number(jsonObj["grid_dfa_nom_avg"].toDouble()/100));
                        else
                            htmlTxt.replace(QString("#obdfn#"), QString::asprintf("%.2f", jsonObj["grid_dfa_nom_avg"].toDouble()/100.0));

                        htmlTxt.replace(QString("#udo#"), udo);
                        htmlTxt.replace(QString("#uve#"), uve);
                        htmlTxt.replace(QString("#uvo#"), uvo);
                        htmlTxt.replace(QString("#ute#"), ute);

                        if(m_calibType != "FULL"){
                            int ducyNomDim = jsonObj["ducy_nom"].toInt();
                            int ducyNomSec = jsonObj["ducy_nom_sec"].toInt();
                            if(ducyNomSec >= ducyNomDim){
                                htmlTxt.replace(QString("#fanndc#"), QString::number(jsonObj["ducy_nom_sec"].toInt()));
                                htmlTxt.replace(QString("#fannrpm#"), QString::number(jsonObj["rpm_nom_sec"].toInt()));
                                htmlTxt.replace(QString("#fanmdc#"), QString::number(jsonObj["ducy_fail_sec"].toInt()));
                                htmlTxt.replace(QString("#fanmrpm#"), QString::number(jsonObj["rpm_fail_sec"].toInt()));
                            }else{
                                htmlTxt.replace(QString("#fanndc#"), QString::number(jsonObj["ducy_nom"].toInt()));
                                htmlTxt.replace(QString("#fannrpm#"), QString::number(jsonObj["rpm_nom"].toInt()));
                                htmlTxt.replace(QString("#fanmdc#"), QString::number(jsonObj["ducy_fail"].toInt()));
                                htmlTxt.replace(QString("#fanmrpm#"), QString::number(jsonObj["rpm_fail"].toInt()));
                            }
                            htmlTxt.replace(QString("#fansdc#"), QString::number(jsonObj["ducy_stb"].toInt()));
                            htmlTxt.replace(QString("#fansrpm#"), QString::number(jsonObj["rpm_stb"].toInt()));
                        }else{
                            htmlTxt.replace(QString("#fanndc#"), QString::number(jsonObj["ducy_nom"].toInt()));
                            htmlTxt.replace(QString("#fannrpm#"), QString::number(jsonObj["rpm_nom"].toInt()));
                            htmlTxt.replace(QString("#fanmdc#"), QString::number(jsonObj["ducy_fail"].toInt()));
                            htmlTxt.replace(QString("#fanmrpm#"), QString::number(jsonObj["rpm_fail"].toInt()));
                            htmlTxt.replace(QString("#fansdc#"), QString::number(jsonObj["ducy_stb"].toInt()));
                            htmlTxt.replace(QString("#fansrpm#"), QString::number(jsonObj["rpm_stb"].toInt()));
                        }//

                        /////////////////////////////////////////////////
                        /// Airflow Smoke Patterns Test
                        htmlTxt.replace(QString("#asa#"), "PASS");
                        htmlTxt.replace(QString("#asb#"), "PASS");
                        htmlTxt.replace(QString("#asc#"), "PASS");
                        htmlTxt.replace(QString("#asd#"), "PASS");
                        htmlTxt.replace(QString("#ase#"), "PASS");

                        /////////////////////////////////////////////////
                        /// Motor Control Verification
                        htmlTxt.replace(QString("#mc1a#"), QString::number(jsonObj["mv_initial_ducy"].toInt()));
                        htmlTxt.replace(QString("#mc1b#"), QString::number(jsonObj["mv_initial_rpm"].toInt()));

                        htmlTxt.replace(QString("#mc2#"), QString(jsonObj["mv_initial_downflow"].toString()));
                        htmlTxt.replace(QString("#mc3#"), QString(jsonObj["mv_initial_inflow"].toString()));
                        htmlTxt.replace(QString("#mc4#"), QString(jsonObj["mv_initial_power"].toString()));

                        htmlTxt.replace(QString("#mc5a#"), QString::number(jsonObj["mv_blocked_ducy"].toInt()));
                        htmlTxt.replace(QString("#mc5b#"), QString::number(jsonObj["mv_blocked_rpm"].toInt()));

                        htmlTxt.replace(QString("#mc6#"), QString(jsonObj["mv_blocked_downflow"].toString()));
                        htmlTxt.replace(QString("#mc7#"), QString(jsonObj["mv_blocked_inflow"].toString()));
                        htmlTxt.replace(QString("#mc8#"), QString(jsonObj["mv_blocked_power"].toString()));

                        htmlTxt.replace(QString("#mc9a#"), QString::number(jsonObj["mv_final_ducy"].toInt()));
                        htmlTxt.replace(QString("#mc9b#"), QString::number(jsonObj["mv_final_rpm"].toInt()));

                        htmlTxt.replace(QString("#mc10#"), QString(jsonObj["mv_final_downflow"].toString()));
                        htmlTxt.replace(QString("#mc11#"), QString(jsonObj["mv_final_inflow"].toString()));

                        QString inIfStr, inDfStr, blIfStr, blDfStr, finIfStr, finDfStr;
                        double inIf, inDf, blIf, blDf, finIf, finDf;
                        QString mcvp;
                        inIfStr = jsonObj["mv_initial_inflow"].toString();
                        inDfStr = jsonObj["mv_initial_downflow"].toString();

                        blIfStr = jsonObj["mv_blocked_inflow"].toString();
                        blDfStr = jsonObj["mv_blocked_downflow"].toString();

                        finIfStr = jsonObj["mv_final_inflow"].toString();
                        finDfStr = jsonObj["mv_final_downflow"].toString();

                        inIf = inIfStr.toDouble() * 100;
                        inDf = inDfStr.toDouble() * 100;
                        blIf = blIfStr.toDouble() * 100;
                        blDf = blDfStr.toDouble() * 100;
                        finIf = finIfStr.toDouble() * 100;
                        finDf = finDfStr.toDouble() * 100;

                        //qDebug() << inIf << inDf << blIf << blDf << finIf << finDf;

                        if((((blIf <= (inIf + tol)) && (blIf >= (inIf - tol))) && ((blDf <= (inDf + tol)) && (blDf >= (inDf - tol)))) &&
                            (((finIf <= (inIf + tol)) && (finIf >= (inIf - tol))) && ((finDf <= (inDf + tol)) && (finDf >= (inDf - tol)))))
                            mcvp = "PASS";
                        else mcvp = "FAIL";

                        htmlTxt.replace(QString("#mcvp#"), mcvp);

                        /////////////////////////////////////////////////
                        /// Data diagnostic (For Factory Testing Only)
                        htmlTxt.replace(QString("#iff#"), QString::number(jsonObj["adc_iff"].toInt()));
                        htmlTxt.replace(QString("#ifn#"), QString::number(jsonObj["adc_ifn"].toInt()));
                        htmlTxt.replace(QString("#ifa#"), QString::number(jsonObj["adc_ifa"].toInt()));

                        htmlTxt.replace(QString("#if0#"), QString::number(jsonObj["adc_if0"].toInt()));
                        htmlTxt.replace(QString("#if1#"), QString::number(jsonObj["adc_if1"].toInt()));
                        htmlTxt.replace(QString("#if2#"), QString::number(jsonObj["adc_if2"].toInt()));
                        htmlTxt.replace(QString("#ifr#"), QString::number(jsonObj["adc_range"].toInt()));
                        if(m_calibType != "FULL")
                            htmlTxt.replace(QString("#ifrf#"), QString::number(jsonObj["adc_range_field"].toInt()));

                        htmlTxt.replace(QString("#temp#"), QString::number(jsonObj["calib_temp_adc"].toInt()));
                        htmlTxt.replace(QString("#calt#"), QString::number(jsonObj["calib_temp"].toInt()));
                        htmlTxt.replace(QString("#sevo#"), QString(jsonObj["sensor_voltage"].toString()));
                        htmlTxt.replace(QString("#const#"), QString::number(jsonObj["sensor_constant"].toInt()));

                        //qDebug() << "__AFTER__";
                        //qDebug() << htmlTxt;

                        QString ifres;
                        if((jsonObj["adc_if2"].toInt() - jsonObj["adc_if1"].toInt()) >= 80){
                            ifres = "PASS";
                            if((jsonObj["adc_if2"].toInt() - jsonObj["adc_if1"].toInt()) >= 100){
                                ifres = "GOOD";
                            }
                        }
                        else ifres = "FAIL";

                        htmlTxt.replace(QString("#ifres#"), ifres);
                    }//
                    else if(m_outputType == "CRT"){
                        htmlTxt.replace(QString("#model#"), QString(jsonObj["cabinet_model"].toString()));
                        if(jsonObj["wo_number"].toString() == ""){
                            htmlTxt.replace(QString("#work_order#"), "");
                            htmlTxt.replace(QString("#wonum#"), "");
                        }else{
                            htmlTxt.replace(QString("#work_order#"), "WO:");
                            htmlTxt.replace(QString("#wonum#"), jsonObj["wo_number"].toString());
                        }

                        htmlTxt.replace(QString("#serialnum#"), QString(jsonObj["serial_number"].toString()));
                        htmlTxt.replace(QString("#date#"), QString(jsonObj["test_date"].toString()));

                        //Force to Test Admin Spv.
                        htmlTxt.replace(QString("#ttdcheck#"), targetDir + "/report/img/ttd_spv.png");
                        htmlTxt.replace(QString("#ttdtest#"), targetDir + "/fullsigntester.png");

                        htmlTxt.replace(QString("#testername#"), QString(jsonObj["tested_by"].toString()));

                        //Footer parameters
                        htmlTxt.replace(QString("#certnumber#"), QString(jsonObj["cert_number"].toString()));
                    }//
                    else if(m_outputType == "1-10"){
                        //#header_logo_enable#
                        QString headerLogoHtml = QString("<th align=\"left\" width=\"25%\"><img width=100 height=40 src='#header_logo#'></img></th>");
                        QString headerAddressHtml = QString("<th rowspan=2 align=\"right\" style=\"font-size:7px; font-weight:normal;\"><div>#header_address#</div></th>");

                        const QString headerImgCustomer [5] = {
                            QString(targetDir + "/report/img/esco_life_black.png"),//ETI
                            QString(targetDir + "/report/img/esco_life_black.png"),//WORLD
                            QString(targetDir + "/report/img/ancare_black.png"),//ANCARE
                            "",//NONE
                            QString(targetDir + "/report/img/streamline_black.png")//STREAMLINE
                        };
                        QString customer = jsonObj.value("customer").toString();
                        short cutomerIndex = 3; // default none
                        if(customer == "ETI") cutomerIndex = 0;
                        else if(customer == "WORLD") cutomerIndex = 1;
                        else if(customer == "ANCARE") cutomerIndex = 2;
                        else if(customer == "NONE") {headerLogoHtml = ""; cutomerIndex = 3;}
                        else if(customer == "STREAMLINE") cutomerIndex = 4;

                        headerLogoHtml.replace("#header_logo#", headerImgCustomer[cutomerIndex]);
                        htmlTxt.replace("#header_logo_enable#", headerLogoHtml);

                        //#header_address_enable#
                        const QString headerAddressEti = QString("\n")
                                                         + QString("<div><b>Esco Technologies, Inc.</b></div>") + QString("\n")
                                                         + QString("<div>903 Sheehy Drive, Suite F Horsham</div>") + QString("\n")
                                                         + QString("<div>PA 19044, USA</div>") + QString("\n")
                                                         + QString("<div>Toll-Free (USA and Canada): 1-877-479-3726</div>") + QString("\n")
                                                         + QString("<div>Phone: (215) 441-9661 Fax: 484-698-7757</div>")
                                                         + QString("<div>eti.sales@escolifesciences.com * escolifesciences.us</div>");
                        const QString headerAddressWorld = QString("\n")
                                                           + QString("<div><b>Esco Micro Pte. Ltd.</b></div>") + QString("\n")
                                                           + QString("<div>21 Changi South Street 1, Singapore 486777</div>") + QString("\n")
                                                           + QString("<div>Tel: +65 65420833  Fax: +65 65426920</div>") + QString("\n")
                                                           + QString("<div>Email: mail@escolifesciences.com</div>") + QString("\n")
                                                           + QString("<div>Site: http://escolifesciences.com</div>");
                        const QString headerAddressAncare = QString("\n")
                                                            + QString("<div>P.O. Box 814</div>") + QString("\n")
                                                            + QString("<div>Bellmore, NY 11710</div>") + QString("\n")
                                                            + QString("<div>U.S. & Canada call toll-free: 1-800-645-6379</div>") + QString("\n")
                                                            + QString("<div>Tel: 516-781-0755  Fax:  516-781-4937</div>") + QString("\n")
                                                            + QString("<div>Email: information@ancare.com</div>")
                                                            + QString("<div>WWW Site: http://www.ancare.com</div>");
                        const QString headerAddressNone = "";
                        const QString headerAddressStreamline = QString("\n")
                                                                + QString("<div><b>Worldwide Headquarters</b></div>") + QString("\n")
                                                                + QString("<div>Streamline Laboratory Products</div>") + QString("\n")
                                                                + QString("<div>32 Maxwell Road, #03-13 White House, Singapore 069115</div>") + QString("\n")
                                                                + QString("<div>tel: +65 6785 1020 | fax: +65 6785 1027</div>") + QString("\n")
                                                                + QString("<div>email: mail@streamline-lab.com</div>") + QString("\n")
                                                                + QString("<div>Visit our website at: www.streamline-lab.com</div>");

                        const QString headerAddressCustomer[5] = {
                            headerAddressEti,
                            headerAddressWorld,
                            headerAddressAncare,
                            headerAddressNone,
                            headerAddressStreamline
                        };
                        headerAddressHtml.replace("#header_address#", headerAddressCustomer[cutomerIndex]);
                        htmlTxt.replace("#header_address_enable#", headerAddressHtml);


                        foreach(const QString& key, jsonObj.keys()) {
                            QJsonValue value = jsonObj.value(key);
                            if(key != "nlt_nom_grid"
                                && key != "nlt_off_grid"
                                && key != "lit_nom_grid"
                                && key != "lit_off_grid"
                                && key != "vt_nom_grid"
                                && key != "vt_off_grid")
                            {
                                qDebug() << "Key = " << key << ", Value = " << value.toString();
                                QString replaceStr = QString("#%1#").arg(key);
                                htmlTxt.replace(replaceStr, QString(jsonObj[key].toString()));
                            }else{
                                const QString replaceStrTemp = QString(QString("%1").arg(key)).replace("_grid", "");
                                QStringList strList = value.toVariant().toStringList();
                                qDebug() << "Key = " << key << ", Value = " << strList;
                                qDebug() << "replaceStrTemp" << replaceStrTemp;
                                for(short i=1; i<=strList.length(); i++){
                                    QString replaceStr = QString("#%1%2#").arg(replaceStrTemp).arg(i);
                                    qDebug() << replaceStr << "replaced by" << strList.at(i-1);
                                    htmlTxt.replace(replaceStr, strList.at(i-1));
                                }//
                            }//
                        }//
                    }//
                    //qDebug() << "__AFTER2__";
                    //qDebug() << htmlTxt;

                    //save to new file
                    if(nhtml.open(QIODevice::WriteOnly | QIODevice::Text)){
                        QTextStream out(&nhtml);
                        out << htmlTxt;
                        nhtml.close();
                    }

                    html.seek(0);
                    html.write(htmlTxt.toUtf8());

                    html.close();
                }
                else{
                    qDebug() << "cant open file" << html.errorString();
                    qDebug() << html.error();
                    html.close();
                }
            }
            else html.close();
        }//


        //open new file
        QFile nhtmlFinal(newHtml);
        nhtmlFinal.open(QFile::ReadOnly);
        QTextStream streamHtml(&nhtmlFinal);

        //html.open(QFile::ReadOnly);
        //QTextStream streamHtml(&html);

        //QFile css(targetDir + "/report/styles.css");
        //css.open(QFile::ReadOnly | QFile::Text);
        //QTextStream streamCss(&css);

        QTextDocument doc;
        //doc.setDefaultStyleSheet(streamCss.readAll());
        doc.setHtml(streamHtml.readAll());
        doc.setDefaultFont(QFont("Arial"));
        doc.setPageSize(printer.pageLayout().paintRectPixels(80).size());///100dpi
        //doc.setPageSize(printer.pageRect().size());
        doc.print(&printer);

        pdfFile.close();

        //set flag to 0
        setInitialized(false);
        m_pThread->quit();
        m_pThread->wait();

        //delete m_pThread;

        emit pdfExportFinished(true, fileName);
    });
}

void TestReportPdfGenerator::setOutputType(const QString &type)
{
    m_outputType = type;
}

void TestReportPdfGenerator::setCabinetModel(const QString &model)
{
    m_model = model;
}

void TestReportPdfGenerator::setCustomer(const QString &customer)
{
    m_customer = customer;
}

void TestReportPdfGenerator::setCalibType(const QString &value)
{
    m_calibType = value;
}

void TestReportPdfGenerator::installFont()
{
    //copy font image to linux usr folder
    //
    QMetaObject::invokeMethod(m_pdfGen.data(), [&](){
#ifdef __linux__
        QString fontDir = "/usr/share/fonts/truetype/freefont";

        if(!QFile::exists("/usr/share/fonts/truetype/freefont/arial.ttf")){
            QProcess qprocess;
            qprocess.start("rootrw");
            qprocess.waitForFinished();
            //:/Generic/TestReportTemplate/font/arial/arial.ttf
            QFile::copy(":/Generic/TestReportTemplate/font/arial/arial.ttf", fontDir + "/arial.ttf");
            QFile::copy(":/Generic/TestReportTemplate/font/arial/arialbd.ttf", fontDir + "/arialbd.ttf");
            QFile::copy(":/Generic/TestReportTemplate/font/arial/arialbi.ttf", fontDir + "/arialbi.ttf");
            QFile::copy(":/Generic/TestReportTemplate/font/arial/ariali.ttf", fontDir + "/ariali.ttf");
            QFile::copy(":/Generic/TestReportTemplate/font/arial/ARIALN.ttf", fontDir + "/ARIALN.ttf");
            QFile::copy(":/Generic/TestReportTemplate/font/arial/ARIALNB.ttf", fontDir + "/ARIALNB.ttf");
            QFile::copy(":/Generic/TestReportTemplate/font/arial/ARIALNBI.ttf", fontDir + "/ARIALNBI.ttf");
            QFile::copy(":/Generic/TestReportTemplate/font/arial/ARIALNI.ttf", fontDir + "/ARIALNI.ttf");
            QFile::copy(":/Generic/TestReportTemplate/font/arial/ariblk.ttf", fontDir + "/ariblk.ttf");

            qprocess.start("rootro");
            qprocess.waitForFinished();
        }

        if(!QFile::exists("/usr/share/fonts/truetype/freefont/GARA.ttf")){
            QProcess qprocess;
            qprocess.start("rootrw");
            qprocess.waitForFinished();

            QFile::copy(":/Generic/TestReportTemplate/font/garamond/GARA.TTF", fontDir + "/GARA.TTF");
            QFile::copy(":/Generic/TestReportTemplate/font/garamond/GARABD.TTF", fontDir + "/GARABD.TTF");
            QFile::copy(":/Generic/TestReportTemplate/font/garamond/GARAIT.TTF", fontDir + "/GARAIT.TTF");

            qprocess.start("rootro");
            qprocess.waitForFinished();
        }
#endif

        emit fontInstallingComplete(true);
    });
}

void TestReportPdfGenerator::initTemplateFile()
{
    qDebug() << __FUNCTION__ << thread();

    QMetaObject::invokeMethod(m_pdfGen.data(), [&](){
        QString targetDir = QStandardPaths::writableLocation(QStandardPaths::AppLocalDataLocation);
        qDebug() << targetDir;

        QString targetLocation = targetDir + QString("/report");

        QDir dir(targetLocation);
        if(!dir.exists())
            dir.mkpath(".");

        //make sure the template is clear from data
        if(QFile::exists(targetLocation + "/index.html"))
            QFile::remove(targetLocation + "/index.html");
        if(m_outputType == "TR"){
            if(m_calibType == "FIELD_A"){
                QFile::copy(":/Generic/TestReportTemplate/fm-tst-tr-a2-world-field-a.html", targetLocation+"/index.html");
            }
            else if(m_calibType == "FIELD_B"){
                QFile::copy(":/Generic/TestReportTemplate/fm-tst-tr-a2-world-field-b.html", targetLocation+"/index.html");
            }else if(m_calibType == "1_OF_10"){
                QFile::copy(":/Generic/TestReportTemplate/fm-tst-tr-1of10.html", targetLocation+"/index.html");
            }
            else {
                QFile::copy(":/Generic/TestReportTemplate/fm-tst-tr-a2-world.html", targetLocation+"/index.html");
            }
        }
        else if(m_outputType == "CRT"){
            if(m_customer == "WORLD"){
                if(m_model == "LA2")
                    QFile::copy(":/Generic/TestReportTemplate/fm-tst-crt-la2-world.html", targetLocation+"/index.html");
                if(m_model == "AC2")
                    QFile::copy(":/Generic/TestReportTemplate/fm-tst-crt-ac2-world.html", targetLocation+"/index.html");
                if(m_model == "VA2")
                    QFile::copy(":/Generic/TestReportTemplate/fm-tst-crt-va2-world.html", targetLocation+"/index.html");
            }
            else if(m_customer == "ETI"){
                if(m_model == "LA2")
                    QFile::copy(":/Generic/TestReportTemplate/fm-tst-crt-la2-eti.html", targetLocation+"/index.html");
                if(m_model == "AC2")
                    QFile::copy(":/Generic/TestReportTemplate/fm-tst-crt-ac2-eti.html", targetLocation+"/index.html");
                if(m_model == "VA2")
                    QFile::copy(":/Generic/TestReportTemplate/fm-tst-crt-va2-eti.html", targetLocation+"/index.html");
            }//
        }//
        else if(m_outputType == "1-10"){
            QFile::copy(":/Generic/TestReportTemplate/fm-tst-tr-1of10.html", targetLocation+"/index.html");
        }


        //check image file if not available copy to folder
        QDir dirImg(targetDir + QString("/report/img"));
        if(!dirImg.exists())
            dirImg.mkpath(".");

        if(!QFile::exists(targetLocation + "/img/esco_life_black.png")){
            QFile::copy(":/Generic/TestReportTemplate/img/esco_life_black.png", targetLocation + "/img/esco_life_black.png");
        }

        if(!QFile::exists(targetLocation + "/img/line.png")){
            QFile::copy(":/Generic/TestReportTemplate/img/line.png", targetLocation + "/img/line.png");
        }

        if(!QFile::exists(targetLocation + "/img/ttd_spv.png")){
            QFile::copy(":/Generic/TestReportTemplate/img/ttd_spv.png", targetLocation + "/img/ttd_spv.png");
        }
        if(!QFile::exists(targetLocation + "/img/34ft.png")){
            QFile::copy(":/Generic/TestReportTemplate/img/34ft.png", targetLocation + "/img/34ft.png");
        }
        if(!QFile::exists(targetLocation + "/img/5ft.png")){
            QFile::copy(":/Generic/TestReportTemplate/img/5ft.png", targetLocation + "/img/5ft.png");
        }
        if(!QFile::exists(targetLocation + "/img/6ft.png")){
            QFile::copy(":/Generic/TestReportTemplate/img/6ft.png", targetLocation + "/img/6ft.png");
        }
        //
        if(!QFile::exists(targetLocation + "/img/ancare_black.png")){
            QFile::copy(":/Generic/TestReportTemplate/img/ancare_black.png", targetLocation + "/img/ancare_black.png");
        }
        if(!QFile::exists(targetLocation + "/img/streamline_black.png")){
            QFile::copy(":/Generic/TestReportTemplate/img/streamline_black.png", targetLocation + "/img/streamline_black.png");
        }
    });
}

void TestReportPdfGenerator::setMeasurementUnit(int unit)
{
    m_measurementUnit = unit;
}

void TestReportPdfGenerator::htmlEditFile()
{
    QString targetDir = QStandardPaths::writableLocation(QStandardPaths::AppLocalDataLocation);

    QString tempS;
    tempS = targetDir + "/report/index.html";

    QFile html(tempS);

    html.setPermissions(QFileDevice::ReadOwner | QFileDevice::WriteOwner);

    if(html.exists()){
        //qDebug() << "html template file exist";
        if(html.open(QIODevice::ReadWrite)){
            QByteArray fileData;
            fileData = html.readAll();
            QString htmlTxt = (fileData);
            //qDebug() << targetDir;
            htmlTxt.replace(QString("#targetDir#"), QString(targetDir));

            html.seek(0);
            html.write(htmlTxt.toUtf8());

            html.close();
        }
        else{
            qDebug() << "cant open file" << html.errorString();
            qDebug() << html.error();
        }
    }
}

QJsonArray TestReportPdfGenerator::ObjectToArray( const QJsonObject &json_obj ) const
{
    QJsonArray json_arr;
    QJsonObject::const_iterator iter = json_obj.begin();

    while (iter != json_obj.end())
    {
        if ( iter->isObject() )
        {
            json_arr.append(ObjectToArray(iter->toObject()));
        }
        else
        {
            json_arr.append(*iter);
        }
        iter++;
    }

    return json_arr;
}
//void TestReportPdfGenerator::createDownflowGridImg()
//{
//    QString targetDir = QStandardPaths::writableLocation(QStandardPaths::AppLocalDataLocation);

//    int width = 1374;
//    int height = 300;

//    QImage image(QSize(width,height),QImage::Format_RGB32);
//    //QPainter painter(&image);
//    QScopedPointer<QPainter> painter(new QPainter(&image));

//    painter->fillRect(QRectF(0,0,width,height),Qt::white);

//    QRect rect(0, 0, width, height);

//    QTextOption textOption(Qt::AlignHCenter | Qt::AlignVCenter);
//    textOption.setWrapMode(QTextOption::WordWrap);

//    QFont font;
//    font.setPointSize(14);
//    painter->setFont(font);

//    /// Title
//    rect.setRect(0, 0, width, height);
//    painter->drawText(rect, QString("Downflow Grid"), textOption);

//    //base rectangle
//    QPen pen;
//    pen.setColor(Qt::black);
//    pen.setWidth(1);
//    painter->setPen(pen);
//    painter->drawRect(QRectF(5,5,(width-10), 93));

//    //create grid
//    int initH = 18;
//    int initW = 20;
//    int gridW = 33;
//    int gridH = 16;

//    for(int j = 0; j < 3; j++){
//        for(int i = 0; i < 12; i++){
//            painter->drawRect(QRectF(initW, initH, gridW, gridH));
//            initW = initW + gridW + 20;
//        }
//        initH = initH + gridH + 8;
//        initW = 20;
//    }
//    image.save(targetDir + QString("/report/img/df-grid.png"));
//}
