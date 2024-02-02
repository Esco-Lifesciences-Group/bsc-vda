/**
 *  Copyright (C) 2021 by ESCO Bintan Indonesia
 *  https://escoglobal.com
 *
 *  Author:
 *  - Heri Cahyono
**/

import QtQuick 2.12
import QtQuick.Layouts 1.0
import QtQuick.Controls 2.0

import UI.CusCom 1.1
//import "../../CusCom/JS/IntentApp.js" as IntentApp
import "../../../CusCom/JS/IntentApp.js" as IntentApp

//import BookingScheduleQmlApp 1.0

import ModulesCpp.Machine 1.0

import Qt.labs.settings 1.1

import ModulesCpp.JstoText 1.0
import ModulesCpp.TestReportPdfGenerator 1.0

Item {
    id: bodyItem
    Layout.fillWidth: true
    Layout.fillHeight: true

    property bool fieldAdvanced

    RowLayout{
        anchors.fill: parent
        Item{
            Layout.fillHeight: true
            Layout.fillWidth: true
            //Layout.minimumWidth: 100
        }

        Item{
            Layout.fillHeight: true
            Layout.minimumWidth: 200
            Rectangle {
                id: exportRect
                height: 140
                width: parent.width
                radius: 5
                color: "#0F2952"
                border.color: "#e3dac9"
                anchors.centerIn: parent

                ColumnLayout {
                    anchors.fill: parent

                    TextApp {
                        Layout.margins: 5
                        text: qsTr("Export as Text")
                        //                                text: qsTr("Export") + " " + qsTr("(Week: ") + props.exportTargetWeek + ")"
                    }//

                    Item {
                        Layout.fillHeight: true
                        Layout.fillWidth: true

                        RowLayout {
                            anchors.fill: parent

                            Item {
                                Layout.fillHeight: true
                                Layout.fillWidth: true
                                visible: ((__hwInfo__ !== MachineAPI.HardwareInfo_RPI_ZW) ? true : false)
                                Image {
                                    anchors.centerIn: parent
                                    source: "qrc:/UI/Pictures/txt-file-bt.png"
                                }//

                                MouseArea {
                                    anchors.fill: parent
                                    onClicked: {
                                        props.exportToWhat = props.exportToPdfBluetooth
                                        props.callFromPdf = 0 //flag for js generator

                                        let fileName = String(MachineData.cabinetDisplayName).replace(" ", "_")
                                        let serialNumber = String(MachineData.serialNumber)
                                        if(serialNumber.length === 0) serialNumber = "00000"

                                        let targetFileName = fileName + "_" + serialNumber + "_Field_Adv" + ".txt"

                                        const jsonObj = bodyItem.generatePayload()

                                        //console.debug(JSON.stringify(jsonObj))
                                        jstoText.write(jsonObj, targetFileName)

                                    }//
                                }//
                            }//

                            Item {
                                Layout.fillHeight: true
                                Layout.fillWidth: true

                                Image {
                                    anchors.centerIn: parent
                                    source: "qrc:/UI/Pictures/txt-file-usb.png"
                                }//

                                MouseArea {
                                    anchors.fill: parent
                                    onClicked: {

                                        props.exportToWhat = props.exportToPdfUSB
                                        props.callFromPdf = 0 //flag for js generator

                                        const message = "<b>" + qsTr("Have you inserted USB drive?") + "</b>"
                                                      + "<br><br>"
                                                      + qsTr("USB port can be found on top of the cabinet, near by power inlet.")
                                        const autoclosed = false
                                        showDialogAsk(qsTr("Export"), message, dialogAlert,
                                                      function onAccepted(){

                                                          let fileName = String(MachineData.cabinetDisplayName).replace(" ", "_")
                                                          let serialNumber = String(MachineData.serialNumber)
                                                          if(serialNumber.length === 0) serialNumber = "00000"

                                                          let targetFileName = fileName + "_" + serialNumber + "_Field_Adv" + ".txt"

                                                          const jsonObj = bodyItem.generatePayload()
                                                          jstoText.write(jsonObj, targetFileName)
                                                      },
                                                      function(){}, function(){}, autoclosed)
                                    }//
                                }//
                            }//
                        }//
                    }//
                }//
            }//
            TextApp{
                anchors.bottom: exportRect.bottom
                font.pixelSize: 14
                font.italic: true
                text: qsTr("Intended for service only")
            }
        }//

        Item{
            Layout.fillHeight: true
            Layout.minimumWidth: 50
        }

        Item{
            Layout.fillHeight: true
            //Layout.fillWidth: true
            Layout.minimumWidth: 200
            Rectangle {
                height: 140
                width: parent.width
                radius: 5
                color: "#0F2952"
                border.color: "#e3dac9"
                anchors.centerIn: parent
                //anchors.fill: parent

                ColumnLayout {
                    anchors.fill: parent

                    TextApp {
                        Layout.margins: 5
                        text: qsTr("Export as PDF")
                        //                                text: qsTr("Export") + " " + qsTr("(Week: ") + props.exportTargetWeek + ")"
                    }//

                    Item {
                        Layout.fillHeight: true
                        Layout.fillWidth: true

                        RowLayout {
                            anchors.fill: parent

                            ColumnLayout{
                                Layout.fillHeight: true
                                Layout.fillWidth: true
                                Item {
                                    Layout.fillHeight: true
                                    Layout.fillWidth: true
                                    Row{
                                        anchors.centerIn: parent
                                        spacing: 40
                                        Image {
                                            visible: ((__hwInfo__ !== MachineAPI.HardwareInfo_RPI_ZW) ? true : false)
                                            source: "qrc:/UI/Pictures/pdf-file-bt.png"

                                            MouseArea {
                                                anchors.fill: parent
                                                onClicked: {
                                                    props.exportToWhat = props.exportToPdfBluetooth
                                                    props.callFromPdf = 1 //flag for js generator
                                                    props.pdfOutputType = "TR"

                                                    let fileName = String(MachineData.cabinetDisplayName).replace(" ", "_")
                                                    let serialNumber = String(MachineData.serialNumber)
                                                    if(serialNumber.length === 0) serialNumber = "00000"

                                                    let targetFileName = fileName + "_" + serialNumber + "_Field_Adv" + ".txt"

                                                    const jsonObj = bodyItem.generatePayload()
                                                    console.debug(JSON.stringify(jsonObj))

                                                    //Generate latest json file first

                                                    jstoText.write(jsonObj, targetFileName)
                                                    props.sourceJsonName = targetFileName

                                                    //Generate pdf
                                                    pdfExportLoader.active = true
                                                }//
                                            }//
                                        }//
                                        Image {
                                            source: "qrc:/UI/Pictures/pdf-file-usb.png"

                                            MouseArea {
                                                anchors.fill: parent
                                                onClicked: {

                                                    props.exportToWhat = props.exportToPdfUSB
                                                    props.callFromPdf = 1 //flag for js generator
                                                    props.pdfOutputType = "TR"

                                                    const message = "<b>" + qsTr("Have you inserted USB drive?") + "</b>"
                                                                  + "<br><br>"
                                                                  + qsTr("USB port can be found on top of the cabinet, near by power inlet.")
                                                    const autoclosed = false
                                                    showDialogAsk(qsTr("Export"), message, dialogAlert,
                                                                  function onAccepted(){

                                                                      let fileName = String(MachineData.cabinetDisplayName).replace(" ", "_")
                                                                      let serialNumber = String(MachineData.serialNumber)
                                                                      if(serialNumber.length === 0) serialNumber = "00000"

                                                                      let targetFileName = fileName + "_" + serialNumber + "_Field_Adv" + ".txt"

                                                                      const jsonObj = bodyItem.generatePayload()
                                                                      console.debug(JSON.stringify(jsonObj))

                                                                      //Generate latest json file first

                                                                      jstoText.write(jsonObj, targetFileName)
                                                                      props.sourceJsonName = targetFileName

                                                                      //Generate pdf
                                                                      pdfExportLoader.active = true
                                                                      //pdfReport.init(MachineData.workingMode)
                                                                  },
                                                                  function(){}, function(){}, autoclosed)
                                                }//
                                            }//
                                        }//
                                    }//
                                }//
                                Item {
                                    Layout.fillWidth: true
                                    Layout.minimumHeight: 30
                                    TextApp {
                                        anchors.fill: parent
                                        //Layout.margins: 5
                                        text: qsTr("Test Report")
                                        font.pixelSize: 18
                                        horizontalAlignment: Text.AlignHCenter
                                        verticalAlignment: Text.AlignVCenter
                                        //                                text: qsTr("Export") + " " + qsTr("(Week: ") + props.exportTargetWeek + ")"
                                    }//
                                }//
                            }//
                        }//
                    }//
                }//
            }//
        }//

        Item{
            Layout.fillHeight: true
            Layout.fillWidth: true
            //Layout.minimumWidth: 100
        }
    }//

    JstoText {
        id: jstoText

        onExportFinished: {
            if(props.callFromPdf) {
                if(!done){
                    console.debug("Failed to generate jstoText data!")
                }
                return
            }
            if (done) {
                viewApp.showDialogMessage(qsTr("Export"),
                                          qsTr("The document has been generated."),
                                          viewApp.dialogInfo,
                                          function onClosed(){
                                              let urlContext = "qrc:/UI/Pages/FileManagerUsbCopyPage/FileManagerUsbCopierPage.qml";
                                              if(props.exportToWhat == props.exportToPdfBluetooth){
                                                  urlContext = "qrc:/UI/Pages/BluetoothFileTransfer/BluetoothFileTransfer.qml"
                                              }

                                              const intent = IntentApp.create(urlContext, {"sourceFilePath": path})
                                              viewApp.startView(intent);
                                          })
                //             console.log (path)
            }
            else {
                viewApp.showDialogMessage(qsTr("Export"),
                                          qsTr("Failed while generating document."))
            }
        }
    }

    /// Initialize the following variable first before activating the Loader
    /// m_outputType = "CRT" / "TR" (setOutputType())
    /// m_customer = "ETI" / "WORLD" (setCustomer())
    /// m_model = "AC2" / "LA2" / "VA2" (setCabinetModel())
    /// m_calibType = "FULL" / "FIELD_A" / "FIELD_B" (setCalibType())
    Loader {
        id: pdfExportLoader
        active: false
        sourceComponent: TestReportPdfGenerator {
            id: pdfReport
            onInitializedChanged: {
                //console.debug("pdf export: " + initialized)
                setOutputType(props.pdfOutputType)
                setCustomer(props.pdfCustomer)
                setCabinetModel(props.pdfCabinetModel)
                setCalibType("FIELD_A")

                if(initialized){
                    //comment this for debug html file
                    initTemplateFile()

                    let date = new Date()
                    let dateTimeStr = Qt.formatDateTime(date, "yyyyMMddhhmmss")

                    const message = qsTr("Generating") + "..."
                    viewApp.showBusyPage(message)

                    let serialNumber = String(MachineData.serialNumber)
                    if(serialNumber.length === 0) serialNumber = "00000"
                    let targetFileName
                    targetFileName = serialNumber + "_" + settingsCert.cabinetModel + "_Field_Adv_" + props.pdfOutputType + "_%1.pdf".arg(dateTimeStr)
                    //console.debug(targetFileName)
                    //console.debug(props.cleanName(targetFileName))
                    generatePdfFile(props.sourceJsonName, props.cleanName(targetFileName))
                }
                else props.callFromPdf = 0
                //props.callFromPdf = 0
            }

            onPdfExportFinished: {
                //export some variable to local, so can be process
                let expToWhat = props.exportToWhat
                let expToPdfBt = props.exportToPdfBluetooth
                let fixPath = path
                let IntentApp1 = IntentApp
                let viewApp1 = viewApp

                if (done) {
                    viewApp.showDialogMessage(qsTr("Export"),
                                              qsTr("The document has been generated."),
                                              viewApp.dialogInfo,
                                              function onClosed(){
                                                  let urlContext = "qrc:/UI/Pages/FileManagerUsbCopyPage/FileManagerUsbCopierPage.qml";
                                                  //let urlContext = "qrc:/UI/Pages/TcpFileTransfer/TcpFileTransfer.qml";
                                                  if(expToWhat == expToPdfBt){
                                                      urlContext = "qrc:/UI/Pages/BluetoothFileTransfer/BluetoothFileTransfer.qml"
                                                  }

                                                  //console.debug("export to what: " + props.exportToWhat)
                                                  const intent = IntentApp1.create(urlContext, {"sourceFilePath": fixPath})
                                                  viewApp1.startView(intent);
                                              })
                    //console.log("pdfoutput: " + path)
                }
                else {
                    viewApp.showDialogMessage(qsTr("Export"),
                                              qsTr("Failed while generating document."))
                }
                //props.callFromPdf = 0
                pdfExportLoader.active = false
            }//

            onFontNotAvailable: {
                console.debug("Font not available, install to continue")
                let viewApp1 = viewApp
                if(noFont){
                    const message = "<b>" + qsTr("Font not available!") + "</b>"
                                  + "<br><br>"
                                  + qsTr("Install font to continue PDF exporting, system will restart after Install pressed")
                    const autoclosed = false
                    showDialogAsk(qsTr("Export"), message, dialogAlert,
                                  function onAccepted(){
                                      const message = qsTr("Installing") + "..."
                                      viewApp1.showBusyPage(message)

                                      installFont()
                                  },
                                  function(){}, function(){}, autoclosed)
                    //pdfExportLoader.active = false
                }
            }

            onFontInstallingComplete: {
                let viewApp1 = viewApp
                let IntentApp1 = IntentApp

                if(complete){
                    viewApp.showDialogMessage(qsTr("Export"),
                                              qsTr("Font has installed"),
                                              viewApp.dialogInfo,
                                              function onClosed(){
                                                  const intent = IntentApp1.create("qrc:/UI/Pages/ClosingPage/ClosingPage.qml", {})
                                                  viewApp1.startRootView(intent)
                                              })
                }

                pdfExportLoader.active = false
            }

            Component.onCompleted: {
                init()
                setMeasurementUnit(MachineData.measuremetUnit)
            }
        }//
    }//

    /// directly access to file settings
    QtObject {
        id: settingsGeneral
        //        category: "afmeafield"
        property int calibMode: MachineAPI.CALIB_MODE_FIELD

        property string ifaCalGridNom           : MachineData.getIfaCalGrid(calibMode, MachineAPI.INFLOW_GRID_NOMINAL)
        property int    ifaCalGridNomTot        : MachineData.getIfaCalGridTot(calibMode, MachineAPI.INFLOW_GRID_NOMINAL)
        property int    ifaCalGridNomAvg        : MachineData.getIfaCalGridAvg(calibMode, MachineAPI.INFLOW_GRID_NOMINAL)
        property int    ifaCalGridNomVol        : MachineData.getIfaCalGridVol(calibMode, MachineAPI.INFLOW_GRID_NOMINAL)
        property int    ifaCalGridNomVel        : MachineData.getIfaCalGridVel(calibMode, MachineAPI.INFLOW_GRID_NOMINAL)
        property int    ifaCalGridNomTotImp     : MachineData.getIfaCalGridTotImp(calibMode, MachineAPI.INFLOW_GRID_NOMINAL)
        property int    ifaCalGridNomAvgImp     : MachineData.getIfaCalGridAvgImp(calibMode, MachineAPI.INFLOW_GRID_NOMINAL)
        property int    ifaCalGridNomVolImp     : MachineData.getIfaCalGridVolImp(calibMode, MachineAPI.INFLOW_GRID_NOMINAL)
        property int    ifaCalGridNomVelImp     : MachineData.getIfaCalGridVelImp(calibMode, MachineAPI.INFLOW_GRID_NOMINAL)
        property int    ifaCalGridNomDcy        : MachineData.getIfaCalGridDcy(calibMode, MachineAPI.INFLOW_GRID_NOMINAL)
        property int    ifaCalGridNomRpm        : MachineData.getIfaCalGridRpm(calibMode, MachineAPI.INFLOW_GRID_NOMINAL)

        property string ifaCalGridMin           : MachineData.getIfaCalGrid(calibMode, MachineAPI.INFLOW_GRID_MINIMUM)
        property int    ifaCalGridMinTot        : MachineData.getIfaCalGridTot(calibMode, MachineAPI.INFLOW_GRID_MINIMUM)
        property int    ifaCalGridMinAvg        : MachineData.getIfaCalGridAvg(calibMode, MachineAPI.INFLOW_GRID_MINIMUM)
        property int    ifaCalGridMinVol        : MachineData.getIfaCalGridVol(calibMode, MachineAPI.INFLOW_GRID_MINIMUM)
        property int    ifaCalGridMinVel        : MachineData.getIfaCalGridVel(calibMode, MachineAPI.INFLOW_GRID_MINIMUM)
        property int    ifaCalGridMinTotImp     : MachineData.getIfaCalGridTotImp(calibMode, MachineAPI.INFLOW_GRID_MINIMUM)
        property int    ifaCalGridMinAvgImp     : MachineData.getIfaCalGridAvgImp(calibMode, MachineAPI.INFLOW_GRID_MINIMUM)
        property int    ifaCalGridMinVolImp     : MachineData.getIfaCalGridVolImp(calibMode, MachineAPI.INFLOW_GRID_MINIMUM)
        property int    ifaCalGridMinVelImp     : MachineData.getIfaCalGridVelImp(calibMode, MachineAPI.INFLOW_GRID_MINIMUM)
        property int    ifaCalGridMinDcy        : MachineData.getIfaCalGridDcy(calibMode, MachineAPI.INFLOW_GRID_MINIMUM)
        property int    ifaCalGridMinRpm        : MachineData.getIfaCalGridRpm(calibMode, MachineAPI.INFLOW_GRID_MINIMUM)

        property string ifaCalGridNomSec        : MachineData.getIfaCalGridSec(calibMode, MachineAPI.INFLOW_GRID_NOMINAL)
        property int    ifaCalGridNomTotSec     : MachineData.getIfaCalGridTotSec(calibMode, MachineAPI.INFLOW_GRID_NOMINAL)
        property int    ifaCalGridNomAvgSec     : MachineData.getIfaCalGridAvgSec(calibMode, MachineAPI.INFLOW_GRID_NOMINAL)
        property int    ifaCalGridNomVelSec     : MachineData.getIfaCalGridVelSec(calibMode, MachineAPI.INFLOW_GRID_NOMINAL)
        property int    ifaCalGridNomTotSecImp  : MachineData.getIfaCalGridTotSecImp(calibMode, MachineAPI.INFLOW_GRID_NOMINAL)
        property int    ifaCalGridNomAvgSecImp  : MachineData.getIfaCalGridAvgSecImp(calibMode, MachineAPI.INFLOW_GRID_NOMINAL)
        property int    ifaCalGridNomVelSecImp  : MachineData.getIfaCalGridVelSecImp(calibMode, MachineAPI.INFLOW_GRID_NOMINAL)
        property int    ifaCalGridNomDcySec     : MachineData.getIfaCalGridDcySec(calibMode, MachineAPI.INFLOW_GRID_NOMINAL)
        property int    ifaCalGridNomRpmSec     : MachineData.getIfaCalGridRpmSec(calibMode, MachineAPI.INFLOW_GRID_NOMINAL)

        property string ifaCalGridMinSec        : MachineData.getIfaCalGridSec(calibMode, MachineAPI.INFLOW_GRID_MINIMUM)
        property int    ifaCalGridMinTotSec     : MachineData.getIfaCalGridTotSec(calibMode, MachineAPI.INFLOW_GRID_MINIMUM)
        property int    ifaCalGridMinAvgSec     : MachineData.getIfaCalGridAvgSec(calibMode, MachineAPI.INFLOW_GRID_MINIMUM)
        property int    ifaCalGridMinVelSec     : MachineData.getIfaCalGridVelSec(calibMode, MachineAPI.INFLOW_GRID_MINIMUM)
        property int    ifaCalGridMinTotSecImp  : MachineData.getIfaCalGridTotSecImp(calibMode, MachineAPI.INFLOW_GRID_MINIMUM)
        property int    ifaCalGridMinAvgSecImp  : MachineData.getIfaCalGridAvgSecImp(calibMode, MachineAPI.INFLOW_GRID_MINIMUM)
        property int    ifaCalGridMinVelSecImp  : MachineData.getIfaCalGridVelSecImp(calibMode, MachineAPI.INFLOW_GRID_MINIMUM)
        property int    ifaCalGridMinDcySec     : MachineData.getIfaCalGridDcySec(calibMode, MachineAPI.INFLOW_GRID_MINIMUM)
        property int    ifaCalGridMinRpmSec     : MachineData.getIfaCalGridRpmSec(calibMode, MachineAPI.INFLOW_GRID_MINIMUM)

        property string dfaCalGridNom           : MachineData.getDfaCalGrid(calibMode, MachineAPI.DOWNFLOW_GRID_NOMINAL)
        property int    dfaCalGridNomVel        : MachineData.getDfaCalGridVel(calibMode, MachineAPI.DOWNFLOW_GRID_NOMINAL)
        property int    dfaCalGridNomVelTot     : MachineData.getDfaCalGridVelTot(calibMode, MachineAPI.DOWNFLOW_GRID_NOMINAL)
        property int    dfaCalGridNomVelDev     : MachineData.getDfaCalGridVelDev(calibMode, MachineAPI.DOWNFLOW_GRID_NOMINAL)
        property int    dfaCalGridNomVelDevp    : MachineData.getDfaCalGridVelDevp(calibMode, MachineAPI.DOWNFLOW_GRID_NOMINAL)
        property int    dfaCalGridNomVelHigh    : MachineData.getDfaCalGridVelHigh(calibMode, MachineAPI.DOWNFLOW_GRID_NOMINAL)
        property int    dfaCalGridNomVelLow     : MachineData.getDfaCalGridVelLow(calibMode, MachineAPI.DOWNFLOW_GRID_NOMINAL)
        property int    dfaCalGridNomVelImp     : MachineData.getDfaCalGridVelImp(calibMode, MachineAPI.DOWNFLOW_GRID_NOMINAL)
        property int    dfaCalGridNomVelTotImp  : MachineData.getDfaCalGridVelTotImp(calibMode, MachineAPI.DOWNFLOW_GRID_NOMINAL)
        property int    dfaCalGridNomVelDevImp  : MachineData.getDfaCalGridVelDevImp(calibMode, MachineAPI.DOWNFLOW_GRID_NOMINAL)
        property int    dfaCalGridNomVelDevpImp : MachineData.getDfaCalGridVelDevpImp(calibMode, MachineAPI.DOWNFLOW_GRID_NOMINAL)
        property int    dfaCalGridNomVelHighImp : MachineData.getDfaCalGridVelHighImp(calibMode, MachineAPI.DOWNFLOW_GRID_NOMINAL)
        property int    dfaCalGridNomVelLowImp  : MachineData.getDfaCalGridVelLowImp(calibMode, MachineAPI.DOWNFLOW_GRID_NOMINAL)
    }//

    QtObject {
        id: settingsCert
        //category: "certification"

        property string cabinetModel        : MachineData.getCertificationParametersStr(MachineAPI.CertifParamStr_cabinetModel)
        property int    cabinetSize         : MachineData.getCertificationParametersInt(MachineAPI.CertifParamInt_cabinetSize)
        property string calibProcField      : MachineData.getCertificationParametersStr(MachineAPI.CertifParamStr_calibProcField)
        property string serialNumber        : MachineData.getCertificationParametersStr(MachineAPI.CertifParamStr_serialNumber)
        property string powerRating         : MachineData.getCertificationParametersStr(MachineAPI.CertifParamStr_powerRating)
        property int    tempRoom            : MachineData.getCertificationParametersInt(MachineAPI.CertifParamInt_tempRoom)
        property int    tempRoomImp         : MachineData.getCertificationParametersInt(MachineAPI.CertifParamInt_tempRoomImp)
        property string pressRoom           : MachineData.getCertificationParametersStr(MachineAPI.CertifParamStr_pressRoom)

        property string damperOpen      : MachineData.getCertificationParametersStr(MachineAPI.CertifParamStr_damperOpen)
        property string damperOpenImp   : MachineData.getCertificationParametersStr(MachineAPI.CertifParamStr_damperOpenImp)

        property string testerNameField     : MachineData.getCertificationParametersStr(MachineAPI.CertifParamStr_testerNameField)
        property string testerSignatureField: MachineData.getCertificationParametersStr(MachineAPI.CertifParamStr_testerSignatureField)
        property string checkerNameField    : MachineData.getCertificationParametersStr(MachineAPI.CertifParamStr_checkerNameField)
        property string checkerSignatureField: MachineData.getCertificationParametersStr(MachineAPI.CertifParamStr_checkerSignatureField)

        property string customer:           MachineData.getCertificationParametersStr(MachineAPI.CertifParamStr_customer)
        property string country:            MachineData.getCertificationParametersStr(MachineAPI.CertifParamStr_country)
        property string dateTest:           MachineData.getCertificationParametersStr(MachineAPI.CertifParamStr_dateTest)
        property string swVersion:          MachineData.getCertificationParametersStr(MachineAPI.CertifParamStr_swVersion)

        property string sensorVdc       : MachineData.getCertificationParametersStr(MachineAPI.CertifParamStr_sensorVdc)
        property int adcActual          : MachineData.getCertificationParametersInt(MachineAPI.CertifParamInt_adcActual)

        property string testReportNoFieldA    : MachineData.getCertificationParametersStr(MachineAPI.CertifParamStr_testReportNoFieldA)
    }//

    function generatePayload(trt, pftr, pfcr){
        let dataTestReport = {
            "cabinet_model":        settingsCert.cabinetModel,
            //            "wo_number":            settingsCert.woNumber,
            "cabinet_size":         settingsCert.cabinetSize,
            "sash_opening":         MachineData.machineProfile['sashWindow'],
            //            "docpro":               settingsCert.calibProc,
            "docpro_field":         settingsCert.calibProcField,
            "serial_number":        settingsCert.serialNumber,
            "test_date":            settingsCert.dateTest,
            "customer":             settingsCert.customer,
            "country":              settingsCert.country,
            "power_rating":         settingsCert.powerRating,

            "mea_unit":             MachineData.measurementUnit ? "IMP" : "MTR",

            "tested_by":            settingsCert.testerNameField,
            "t_signature":          settingsCert.testerSignatureField,
            "checked_by":           settingsCert.checkerNameField,
            "c_signature":          settingsCert.checkerSignatureField === "" ? " " : settingsCert.checkerSignatureField,

            "sw_ver":               settingsCert.swVersion,

            "room_temp":            MachineData.measurementUnit ? settingsCert.tempRoomImp : settingsCert.tempRoom,
            "room_press":           settingsCert.pressRoom,

            //            "pao_con":              settingsCert.paoCons,
            //            "df_par_penet":         settingsCert.dfParPenet,
            //            "if_par_penet":         settingsCert.ifParPenet,

            "ifa_fail_vel":         MachineData.getInflowLowLimitVelocity(),

            //            "noz_laskin":           settingsCert.noLaskin,
            "damper_opening":       MachineData.measurementUnit ? settingsCert.damperOpenImp : settingsCert.damperOpen,

            "grid_ifa_nom":         settingsGeneral.ifaCalGridNom,
            "grid_ifa_nom_total":   MachineData.measurementUnit ? settingsGeneral.ifaCalGridNomTotImp : settingsGeneral.ifaCalGridNomTot,
            "grid_ifa_nom_avg":     MachineData.measurementUnit ? settingsGeneral.ifaCalGridNomAvgImp : settingsGeneral.ifaCalGridNomAvg,
            "grid_ifa_nom_vel":     MachineData.measurementUnit ? settingsGeneral.ifaCalGridNomVelImp : settingsGeneral.ifaCalGridNomVel,
            "ducy_nom":             settingsGeneral.ifaCalGridNomDcy,
            "rpm_nom":             settingsGeneral.ifaCalGridNomRpm,

            "grid_ifa_fail":        settingsGeneral.ifaCalGridMin,
            "grid_ifa_fail_total":  MachineData.measurementUnit ? settingsGeneral.ifaCalGridMinTotImp : settingsGeneral.ifaCalGridMinTot,
            "grid_ifa_fail_avg":    MachineData.measurementUnit ? settingsGeneral.ifaCalGridMinAvgImp : settingsGeneral.ifaCalGridMinAvg,
            "grid_ifa_fail_vel":    MachineData.measurementUnit ? settingsGeneral.ifaCalGridMinVelImp : settingsGeneral.ifaCalGridMinVel,
            "ducy_fail":            settingsGeneral.ifaCalGridMinDcy,
            "rpm_fail":            settingsGeneral.ifaCalGridMinRpm,

            //            "grid_ifa_stb":         settingsGeneral.ifaCalGridStb,
            //            "grid_ifa_stb_total":   MachineData.measurementUnit ? settingsGeneral.ifaCalGridStbTotImp : settingsGeneral.ifaCalGridStbTot,
            //            "grid_ifa_stb_avg":     MachineData.measurementUnit ? settingsGeneral.ifaCalGridStbAvgImp : settingsGeneral.ifaCalGridStbAvg,
            //            "grid_ifa_stb_vel":     MachineData.measurementUnit ? settingsGeneral.ifaCalGridStbVelImp : settingsGeneral.ifaCalGridStbVel,
            "ducy_stb":             MachineData.getFanPrimaryStandbyDutyCycleField(),
            "rpm_stb":              MachineData.getFanPrimaryStandbyRpmField(),

            "grid_dfa_nom":         settingsGeneral.dfaCalGridNom,
            "grid_dfa_nom_avg":     MachineData.measurementUnit ? settingsGeneral.dfaCalGridNomVelImp : settingsGeneral.dfaCalGridNomVel,
            "grid_dfa_nom_total":   MachineData.measurementUnit ? settingsGeneral.dfaCalGridNomVelTotImp : settingsGeneral.dfaCalGridNomVelTot,
            "grid_dfa_nom_dev":     MachineData.measurementUnit ? settingsGeneral.dfaCalGridNomVelDevImp : settingsGeneral.dfaCalGridNomVelDev,
            "grid_dfa_nom_devp":    settingsGeneral.dfaCalGridNomVelDevp,
            "grid_dfa_nom_lowest":  MachineData.measurementUnit ? settingsGeneral.dfaCalGridNomVelLowImp : settingsGeneral.dfaCalGridNomVelLow,
            "grid_dfa_nom_highest": MachineData.measurementUnit ? settingsGeneral.dfaCalGridNomVelHighImp : settingsGeneral.dfaCalGridNomVelHigh,
            "grid_dfa_nom_count":   MachineData.machineProfile['airflow']['dfa']['nominal']['grid']['count'],
            "grid_dfa_nom_columns": MachineData.machineProfile['airflow']['dfa']['nominal']['grid']['columns'],

            "adc_iff":              MachineData.getInflowAdcPointField(1),
            "adc_ifn":              MachineData.getInflowAdcPointField(2),
            "adc_ifa":              settingsCert.adcActual,
            "adc_if0":              MachineData.getInflowAdcPointFactory(0),
            "adc_if1":              MachineData.getInflowAdcPointFactory(1),
            "adc_if2":              MachineData.getInflowAdcPointFactory(2),
            "adc_range":            MachineData.getInflowAdcPointFactory(2) - MachineData.getInflowAdcPointFactory(1),
            "adc_range_field":      MachineData.getInflowAdcPointField(2) - MachineData.getInflowAdcPointField(1),
            "calib_temp_adc":       MachineData.getInflowTempCalibAdc(),
            "calib_temp":           MachineData.getInflowTempCalib(),
            "sensor_voltage":       settingsCert.sensorVdc,
            "sensor_constant":      MachineData.getInflowSensorConstant(),

            "grid_ifa_nom_sec":     settingsGeneral.ifaCalGridNomSec,
            "grid_ifa_nom_avg_sec": MachineData.measurementUnit ? settingsGeneral.ifaCalGridNomAvgSecImp : settingsGeneral.ifaCalGridNomAvgSec,
            "grid_ifa_nom_vel_sec": MachineData.measurementUnit ? settingsGeneral.ifaCalGridNomVelSecImp : settingsGeneral.ifaCalGridNomVelSec,
            "ducy_nom_sec":         settingsGeneral.ifaCalGridNomDcySec,
            "rpm_nom_sec":         settingsGeneral.ifaCalGridNomRpmSec,

            "grid_ifa_fail_sec":     settingsGeneral.ifaCalGridMinSec,
            "grid_ifa_fail_avg_sec": MachineData.measurementUnit ? settingsGeneral.ifaCalGridMinAvgSecImp : settingsGeneral.ifaCalGridMinAvgSec,
            "grid_ifa_fail_vel_sec": MachineData.measurementUnit ? settingsGeneral.ifaCalGridMinVelSecImp : settingsGeneral.ifaCalGridMinVelSec,
            "ducy_fail_sec":         settingsGeneral.ifaCalGridMinDcySec,
            "rpm_fail_sec":         settingsGeneral.ifaCalGridMinRpmSec,

            "cabinet_name":        MachineData.cabinetDisplayName,
            "test_number":         settingsCert.testReportNoFieldA
        }//

        //        const dataPayload = {
        //            "trt":  trt,
        //            "pftr": pftr,
        //            "pfcr": pfcr,
        //            "data": dataTestReport
        //        }//

        return dataTestReport
    }//

    QtObject{
        id: props

        readonly property int exportToPdfUSB: 0
        readonly property int exportToPdfBluetooth: 1
        property int exportToWhat: 0

        property int callFromPdf: 0
        property string sourceJsonName: ""

        property string pdfOutputType: "TR"
        property string pdfCustomer: settingsCert.customer
        property string pdfCabinetModel: MachineData.machineModelName

        function cleanName(name){
            name = name.replace(/\s+/gi, '-'); // Replace white space with dash
            return name.replace(/[^a-zA-Z0-9\-_.]/gi, ''); // Strip any special charactere
        }
    }//
}//



/*##^##
Designer {
    D{i:0;autoSize:true;formeditorColor:"#c0c0c0";formeditorZoom:0.75;height:480;width:800}
}
##^##*/
