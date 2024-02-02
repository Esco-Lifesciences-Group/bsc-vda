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

                                        let targetFileName = fileName + "_" + serialNumber + "_Full" + ".txt"

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

                                                          let targetFileName = fileName + "_" + serialNumber + "_Full" + ".txt"

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
            Layout.minimumWidth: 400
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

                                                    let targetFileName = fileName + "_" + serialNumber + "_Full" + ".txt"

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

                                                                      let targetFileName = fileName + "_" + serialNumber + "_Full" + ".txt"

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

                            ColumnLayout{
                                Layout.fillHeight: true
                                Layout.fillWidth: true
                                Item {
                                    Layout.fillHeight: true
                                    Layout.fillWidth: true
                                    Row{
                                        spacing: 40
                                        anchors.centerIn: parent

                                        Image {
                                            visible: ((__hwInfo__ !== MachineAPI.HardwareInfo_RPI_ZW) ? true : false)
                                            source: "qrc:/UI/Pictures/pdf-file-bt.png"

                                            MouseArea {
                                                anchors.fill: parent
                                                onClicked: {

                                                    props.exportToWhat = props.exportToPdfBluetooth
                                                    props.callFromPdf = 1 //flag for js generator
                                                    props.pdfOutputType = "CRT"

                                                    let fileName = String(MachineData.cabinetDisplayName).replace(" ", "_")
                                                    let serialNumber = String(MachineData.serialNumber)
                                                    if(serialNumber.length === 0) serialNumber = "00000"

                                                    let targetFileName = fileName + "_" + serialNumber + "_Full" + ".txt"

                                                    const jsonObj = bodyItem.generatePayload()
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
                                                    props.pdfOutputType = "CRT"

                                                    const message = "<b>" + qsTr("Have you inserted USB drive?") + "</b>"
                                                                  + "<br><br>"
                                                                  + qsTr("USB port can be found on top of the cabinet, near by power inlet.")
                                                    const autoclosed = false
                                                    showDialogAsk(qsTr("Export"), message, dialogAlert,
                                                                  function onAccepted(){

                                                                      let fileName = String(MachineData.cabinetDisplayName).replace(" ", "_")
                                                                      let serialNumber = String(MachineData.serialNumber)
                                                                      if(serialNumber.length === 0) serialNumber = "00000"

                                                                      let targetFileName = fileName + "_" + serialNumber + "_Full" + ".txt"

                                                                      const jsonObj = bodyItem.generatePayload()
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
                                        text: qsTr("Certificate")
                                        font.pixelSize: 18
                                        horizontalAlignment: Text.AlignHCenter
                                        verticalAlignment: Text.AlignVCenter
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

                                              const intent = IntentApp.create(urlContext, {"sourceFilePath": path, "dontRmFile": false})
                                              viewApp.startView(intent);
                                          })
                //             console.log (path)
            }
            else {
                viewApp.showDialogMessage(qsTr("Export"),
                                          qsTr("Failed while generating document."))
            }
        }
    }//

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
                setCalibType("FULL")

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

                    targetFileName = serialNumber + "_" + settingsCert.cabinetModel + "_Full_" + props.pdfOutputType + "_%1.pdf".arg(dateTimeStr)

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
                                                  const intent = IntentApp1.create(urlContext, {"sourceFilePath": fixPath, "dontRmFile": false})
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


    QtObject {
        id: settingsGeneral
        //        category: "afmeafull"
        property int calibMode: MachineAPI.CALIB_MODE_FULL

        property string ifaCalGridNom       : MachineData.getIfaCalGrid(calibMode, MachineAPI.INFLOW_GRID_NOMINAL)
        property int    ifaCalGridNomTot    : MachineData.getIfaCalGridTot(calibMode, MachineAPI.INFLOW_GRID_NOMINAL)
        property int    ifaCalGridNomAvg    : MachineData.getIfaCalGridAvg(calibMode, MachineAPI.INFLOW_GRID_NOMINAL)
        property int    ifaCalGridNomVol    : MachineData.getIfaCalGridVol(calibMode, MachineAPI.INFLOW_GRID_NOMINAL)
        property int    ifaCalGridNomVel    : MachineData.getIfaCalGridVel(calibMode, MachineAPI.INFLOW_GRID_NOMINAL)
        property int    ifaCalGridNomTotImp : MachineData.getIfaCalGridTotImp(calibMode, MachineAPI.INFLOW_GRID_NOMINAL)
        property int    ifaCalGridNomAvgImp : MachineData.getIfaCalGridAvgImp(calibMode, MachineAPI.INFLOW_GRID_NOMINAL)
        property int    ifaCalGridNomVolImp : MachineData.getIfaCalGridVolImp(calibMode, MachineAPI.INFLOW_GRID_NOMINAL)
        property int    ifaCalGridNomVelImp : MachineData.getIfaCalGridVelImp(calibMode, MachineAPI.INFLOW_GRID_NOMINAL)
        property int    ifaCalGridNomDcy    : MachineData.getIfaCalGridDcy(calibMode, MachineAPI.INFLOW_GRID_NOMINAL)
        property int    ifaCalGridNomRpm    : MachineData.getIfaCalGridRpm(calibMode, MachineAPI.INFLOW_GRID_NOMINAL)

        property string ifaCalGridMin       : MachineData.getIfaCalGrid(calibMode, MachineAPI.INFLOW_GRID_MINIMUM)
        property int    ifaCalGridMinTot    : MachineData.getIfaCalGridTot(calibMode, MachineAPI.INFLOW_GRID_MINIMUM)
        property int    ifaCalGridMinAvg    : MachineData.getIfaCalGridAvg(calibMode, MachineAPI.INFLOW_GRID_MINIMUM)
        property int    ifaCalGridMinVol    : MachineData.getIfaCalGridVol(calibMode, MachineAPI.INFLOW_GRID_MINIMUM)
        property int    ifaCalGridMinVel    : MachineData.getIfaCalGridVel(calibMode, MachineAPI.INFLOW_GRID_MINIMUM)
        property int    ifaCalGridMinTotImp : MachineData.getIfaCalGridTotImp(calibMode, MachineAPI.INFLOW_GRID_MINIMUM)
        property int    ifaCalGridMinAvgImp : MachineData.getIfaCalGridAvgImp(calibMode, MachineAPI.INFLOW_GRID_MINIMUM)
        property int    ifaCalGridMinVolImp : MachineData.getIfaCalGridVolImp(calibMode, MachineAPI.INFLOW_GRID_MINIMUM)
        property int    ifaCalGridMinVelImp : MachineData.getIfaCalGridVelImp(calibMode, MachineAPI.INFLOW_GRID_MINIMUM)
        property int    ifaCalGridMinDcy    : MachineData.getIfaCalGridDcy(calibMode, MachineAPI.INFLOW_GRID_MINIMUM)
        property int    ifaCalGridMinRpm    : MachineData.getIfaCalGridRpm(calibMode, MachineAPI.INFLOW_GRID_MINIMUM)

        property string ifaCalGridStb       : MachineData.getIfaCalGrid(calibMode, MachineAPI.INFLOW_GRID_STANDBY)
        property int    ifaCalGridStbTot    : MachineData.getIfaCalGridTot(calibMode, MachineAPI.INFLOW_GRID_STANDBY)
        property int    ifaCalGridStbAvg    : MachineData.getIfaCalGridAvg(calibMode, MachineAPI.INFLOW_GRID_STANDBY)
        property int    ifaCalGridStbVol    : MachineData.getIfaCalGridVol(calibMode, MachineAPI.INFLOW_GRID_STANDBY)
        property int    ifaCalGridStbVel    : MachineData.getIfaCalGridVel(calibMode, MachineAPI.INFLOW_GRID_STANDBY)
        property int    ifaCalGridStbTotImp : MachineData.getIfaCalGridTotImp(calibMode, MachineAPI.INFLOW_GRID_STANDBY)
        property int    ifaCalGridStbAvgImp : MachineData.getIfaCalGridAvgImp(calibMode, MachineAPI.INFLOW_GRID_STANDBY)
        property int    ifaCalGridStbVolImp : MachineData.getIfaCalGridVolImp(calibMode, MachineAPI.INFLOW_GRID_STANDBY)
        property int    ifaCalGridStbVelImp : MachineData.getIfaCalGridVelImp(calibMode, MachineAPI.INFLOW_GRID_STANDBY)
        property int    ifaCalGridStbDcy    : MachineData.getIfaCalGridDcy(calibMode, MachineAPI.INFLOW_GRID_STANDBY)
        property int    ifaCalGridStbRpm    : MachineData.getIfaCalGridRpm(calibMode, MachineAPI.INFLOW_GRID_STANDBY)

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
        //                category: "certification"

        property string serverIPv4      : MachineData.getCertificationParametersStr(MachineAPI.CertifParamStr_serverIPv4)

        property string cabinetModel    : MachineData.getCertificationParametersStr(MachineAPI.CertifParamStr_cabinetModel)
        property string woNumber        : MachineData.getCertificationParametersStr(MachineAPI.CertifParamStr_woNumber)
        property int    cabinetSize     : MachineData.getCertificationParametersInt(MachineAPI.CertifParamInt_cabinetSize)
        property string calibProc       : MachineData.getCertificationParametersStr(MachineAPI.CertifParamStr_calibProc)
        property string calibProcField  : MachineData.getCertificationParametersStr(MachineAPI.CertifParamStr_calibProcField)
        property string serialNumber    : MachineData.getCertificationParametersStr(MachineAPI.CertifParamStr_serialNumber)
        property string powerRating     : MachineData.getCertificationParametersStr(MachineAPI.CertifParamStr_powerRating)
        property int    tempRoom        : MachineData.getCertificationParametersInt(MachineAPI.CertifParamInt_tempRoom)
        property int    tempRoomImp     : MachineData.getCertificationParametersInt(MachineAPI.CertifParamInt_tempRoomImp)
        property string pressRoom       : MachineData.getCertificationParametersStr(MachineAPI.CertifParamStr_pressRoom)
        property string paoCons         : MachineData.getCertificationParametersStr(MachineAPI.CertifParamStr_paoCons)
        property string dfParPenet      : MachineData.getCertificationParametersStr(MachineAPI.CertifParamStr_dfParPenet)
        property string ifParPenet      : MachineData.getCertificationParametersStr(MachineAPI.CertifParamStr_ifParPenet)
        property int    noLaskin        : MachineData.getCertificationParametersInt(MachineAPI.CertifParamInt_noLaskin)
        property string damperOpen      : MachineData.getCertificationParametersStr(MachineAPI.CertifParamStr_damperOpen)
        property string damperOpenImp   : MachineData.getCertificationParametersStr(MachineAPI.CertifParamStr_damperOpenImp)

        property int    mvInitialFanDucy: MachineData.getCertificationParametersInt(MachineAPI.CertifParamInt_mvInitialFanDucy)
        property int    mvInitialFanRpm : MachineData.getCertificationParametersInt(MachineAPI.CertifParamInt_mvInitialFanRpm)
        //metric
        property string mvInitialDfa    : MachineData.getCertificationParametersStr(MachineAPI.CertifParamStr_mvInitialDfa)
        property string mvInitialIfa    : MachineData.getCertificationParametersStr(MachineAPI.CertifParamStr_mvInitialIfa)
        //imperial
        property string mvInitialDfaImp : MachineData.getCertificationParametersStr(MachineAPI.CertifParamStr_mvInitialDfaImp)
        property string mvInitialIfaImp : MachineData.getCertificationParametersStr(MachineAPI.CertifParamStr_mvInitialIfaImp)
        //
        property string mvInitialPower  : MachineData.getCertificationParametersStr(MachineAPI.CertifParamStr_mvInitialPower)

        property int    mvBlockFanDucy  : MachineData.getCertificationParametersInt(MachineAPI.CertifParamInt_mvBlockFanDucy)
        property int    mvBlockFanRpm   : MachineData.getCertificationParametersInt(MachineAPI.CertifParamInt_mvBlockFanRpm)
        //metric
        property string mvBlockDfa      : MachineData.getCertificationParametersStr(MachineAPI.CertifParamStr_mvBlockDfa)
        property string mvBlockIfa      : MachineData.getCertificationParametersStr(MachineAPI.CertifParamStr_mvBlockIfa)
        //imperial
        property string mvBlockDfaImp   : MachineData.getCertificationParametersStr(MachineAPI.CertifParamStr_mvBlockDfaImp)
        property string mvBlockIfaImp   : MachineData.getCertificationParametersStr(MachineAPI.CertifParamStr_mvBlockIfaImp)
        //
        property string mvBlockPower    : MachineData.getCertificationParametersStr(MachineAPI.CertifParamStr_mvBlockPower)

        property int    mvFinalFanDucy  : MachineData.getCertificationParametersInt(MachineAPI.CertifParamInt_mvFinalFanDucy)
        property int    mvFinalFanRpm   : MachineData.getCertificationParametersInt(MachineAPI.CertifParamInt_mvFinalFanRpm)
        //metric
        property string mvFinalDfa      : MachineData.getCertificationParametersStr(MachineAPI.CertifParamStr_mvFinalDfa)
        property string mvFinalIfa      : MachineData.getCertificationParametersStr(MachineAPI.CertifParamStr_mvFinalIfa)
        //imperial
        property string mvFinalDfaImp   : MachineData.getCertificationParametersStr(MachineAPI.CertifParamStr_mvFinalDfaImp)
        property string mvFinalIfaImp   : MachineData.getCertificationParametersStr(MachineAPI.CertifParamStr_mvFinalIfaImp)

        property string sensorVdc       : MachineData.getCertificationParametersStr(MachineAPI.CertifParamStr_sensorVdc)
        property int adcActual          : MachineData.getCertificationParametersInt(MachineAPI.CertifParamInt_adcActual)

        property string testerName      : MachineData.getCertificationParametersStr(MachineAPI.CertifParamStr_testerName)
        property string testerSignature : MachineData.getCertificationParametersStr(MachineAPI.CertifParamStr_testerSignature)
        property string checkerName     : MachineData.getCertificationParametersStr(MachineAPI.CertifParamStr_checkerName)
        property string checkerSignature: MachineData.getCertificationParametersStr(MachineAPI.CertifParamStr_checkerSignature)

        property string customer        : MachineData.getCertificationParametersStr(MachineAPI.CertifParamStr_customer)
        property string country         : MachineData.getCertificationParametersStr(MachineAPI.CertifParamStr_country)
        property string dateTest        : MachineData.getCertificationParametersStr(MachineAPI.CertifParamStr_dateTest)
        property string swVersion       : MachineData.getCertificationParametersStr(MachineAPI.CertifParamStr_swVersion)

        property string testReportNo    : MachineData.getCertificationParametersStr(MachineAPI.CertifParamStr_testReportNo)
        property string certifNo        : MachineData.getCertificationParametersStr(MachineAPI.CertifParamStr_certifNo)
        // onServerIPv4Changed: MachineAPI.setCertificationParametersStr(MachineAPI.CertifParamStr_serverIPv4, serverIPv4)

    }//

    function generatePayload(){
        let dataTestReport = {
            "cabinet_model":        settingsCert.cabinetModel,
            "wo_number":            settingsCert.woNumber,
            "cabinet_size":         settingsCert.cabinetSize,
            "sash_opening":         MachineData.machineProfile['sashWindow'],
            "docpro":               settingsCert.calibProc,
            "docpro_field":         settingsCert.calibProcField,
            "serial_number":        settingsCert.serialNumber,
            "test_date":            settingsCert.dateTest,
            "customer":             settingsCert.customer,
            "country":              settingsCert.country,
            "power_rating":         settingsCert.powerRating,

            "mea_unit":             MachineData.measurementUnit ? "IMP" : "MTR",

            "tested_by":            settingsCert.testerName,
            "t_signature":          settingsCert.testerSignature,
            "checked_by":           settingsCert.checkerName,
            "c_signature":          settingsCert.checkerSignature === "" ? " " : settingsCert.checkerSignature,

            "sw_ver":               settingsCert.swVersion,

            "room_temp":            MachineData.measurementUnit ? settingsCert.tempRoomImp : settingsCert.tempRoom,
            "room_press":           settingsCert.pressRoom,

            "pao_con":              settingsCert.paoCons,
            "df_par_penet":         settingsCert.dfParPenet,
            "if_par_penet":         settingsCert.ifParPenet,

            "ifa_fail_vel":         MachineData.getInflowLowLimitVelocity(),

            "noz_laskin":           settingsCert.noLaskin,
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

            "grid_ifa_stb":         settingsGeneral.ifaCalGridStb,
            "grid_ifa_stb_total":   MachineData.measurementUnit ? settingsGeneral.ifaCalGridStbTotImp : settingsGeneral.ifaCalGridStbTot,
            "grid_ifa_stb_avg":     MachineData.measurementUnit ? settingsGeneral.ifaCalGridStbAvgImp : settingsGeneral.ifaCalGridStbAvg,
            "grid_ifa_stb_vel":     MachineData.measurementUnit ? settingsGeneral.ifaCalGridStbVelImp : settingsGeneral.ifaCalGridStbVel,
            "ducy_stb":             settingsGeneral.ifaCalGridStbDcy,
            "rpm_stb":             settingsGeneral.ifaCalGridStbRpm,

            "grid_dfa_nom":         settingsGeneral.dfaCalGridNom,
            "grid_dfa_nom_avg":     MachineData.measurementUnit ? settingsGeneral.dfaCalGridNomVelImp : settingsGeneral.dfaCalGridNomVel,
            "grid_dfa_nom_total":   MachineData.measurementUnit ? settingsGeneral.dfaCalGridNomVelTotImp : settingsGeneral.dfaCalGridNomVelTot,
            "grid_dfa_nom_dev":     MachineData.measurementUnit ? settingsGeneral.dfaCalGridNomVelDevImp : settingsGeneral.dfaCalGridNomVelDev,
            "grid_dfa_nom_devp":    settingsGeneral.dfaCalGridNomVelDevp,
            "grid_dfa_nom_lowest":  MachineData.measurementUnit ? settingsGeneral.dfaCalGridNomVelLowImp : settingsGeneral.dfaCalGridNomVelLow,
            "grid_dfa_nom_highest": MachineData.measurementUnit ? settingsGeneral.dfaCalGridNomVelHighImp : settingsGeneral.dfaCalGridNomVelHigh,
            "grid_dfa_nom_count":   MachineData.machineProfile['airflow']['dfa']['nominal']['grid']['count'],
            "grid_dfa_nom_columns": MachineData.machineProfile['airflow']['dfa']['nominal']['grid']['columns'],

            "adc_iff":              MachineData.getInflowAdcPointFactory(1),
            "adc_ifn":              MachineData.getInflowAdcPointFactory(2),
            "adc_ifa":              settingsCert.adcActual,
            "adc_if0":              MachineData.getInflowAdcPointFactory(0),
            "adc_if1":              MachineData.getInflowAdcPointFactory(1),
            "adc_if2":              MachineData.getInflowAdcPointFactory(2),
            "adc_range":            MachineData.getInflowAdcPointFactory(2) - MachineData.getInflowAdcPointFactory(1),
            "calib_temp_adc":       MachineData.getInflowTempCalibAdc(),
            "calib_temp":           MachineData.getInflowTempCalib(),
            "sensor_voltage":       settingsCert.sensorVdc,
            "sensor_constant":      MachineData.getInflowSensorConstant(),

            "mv_initial_ducy":      settingsCert.mvInitialFanDucy,
            "mv_initial_rpm":       settingsCert.mvInitialFanRpm,
            "mv_initial_downflow":  MachineData.measurementUnit ? settingsCert.mvInitialDfaImp : settingsCert.mvInitialDfa,
            "mv_initial_inflow":    MachineData.measurementUnit ? settingsCert.mvInitialIfaImp : settingsCert.mvInitialIfa,
            "mv_initial_power":     settingsCert.mvInitialPower,

            "mv_blocked_ducy":      settingsCert.mvBlockFanDucy,
            "mv_blocked_rpm":       settingsCert.mvBlockFanRpm,
            "mv_blocked_downflow":  MachineData.measurementUnit ? settingsCert.mvBlockDfaImp : settingsCert.mvBlockDfa,
            "mv_blocked_inflow":    MachineData.measurementUnit ? settingsCert.mvBlockIfaImp : settingsCert.mvBlockIfa,
            "mv_blocked_power":     settingsCert.mvBlockPower,

            "mv_final_ducy":        settingsCert.mvFinalFanDucy,
            "mv_final_rpm":         settingsCert.mvFinalFanRpm,
            "mv_final_downflow":    MachineData.measurementUnit ? settingsCert.mvFinalDfaImp : settingsCert.mvFinalDfa,
            "mv_final_inflow":      MachineData.measurementUnit ? settingsCert.mvFinalIfaImp : settingsCert.mvFinalIfa,

            /*"fan_hp":             MachineData.machineProfile['fan']['horsePower'],
            "fan_rot":              MachineData.machineProfile['fan']['direction'],
            "fan_hsl":              MachineData.machineProfile['fan']['highSpeedLimit'],
            "fan_max_airvol":       MachineData.machineProfile['fan']['maxAirVolume'],
            "fan_const_a1":         MachineData.machineProfile['fan']['constant']['a1'],
            "fan_const_a2":         MachineData.machineProfile['fan']['constant']['a2'],
            "fan_const_a3":         MachineData.machineProfile['fan']['constant']['a3'],
            "fan_const_a4":         MachineData.machineProfile['fan']['constant']['a4']*/

            "fhp":                 Qt.md5(MachineData.machineProfile['fan']['horsePower']),
            "frot":                Qt.md5(MachineData.machineProfile['fan']['direction']),
            "fhsl":                Qt.md5(MachineData.machineProfile['fan']['highSpeedLimit']),
            "fmxvol":              Qt.md5(MachineData.machineProfile['fan']['maxAirVolume']),
            "fcoa1":               Qt.md5(MachineData.machineProfile['fan']['constant']['a1']),
            "fcoa2":               Qt.md5(MachineData.machineProfile['fan']['constant']['a2']),
            "fcoa3":               Qt.md5(MachineData.machineProfile['fan']['constant']['a3']),
            "fcoa4":               Qt.md5(MachineData.machineProfile['fan']['constant']['a4']),

            "cabinet_name":        MachineData.cabinetDisplayName,
            "test_number":         settingsCert.testReportNo,
            "cert_number":         settingsCert.certifNo
        }//

        return dataTestReport
    }//

    UtilsApp{
        id: utils
    }

    QtObject{
        id: props

        readonly property int exportToPdfUSB: 0
        readonly property int exportToPdfBluetooth: 1
        property int exportToWhat: 0

        property int callFromPdf: 0
        property string sourceJsonName: ""

        property string pdfOutputType: "CRT"
        property string pdfCustomer: settingsCert.customer
        property string pdfCabinetModel: MachineData.machineModelName

        function cleanName(name){
            name = name.replace(/\s+/gi, '-'); // Replace white space with dash
            return name.replace(/[^a-zA-Z0-9\-_.]/gi, ''); // Strip any special charactere exclude (- _ .)
        }

        Component.onCompleted: {
            console.debug(pdfOutputType, pdfCustomer, pdfCabinetModel)
        }
    }//
}//



/*##^##
Designer {
    D{i:0;autoSize:true;formeditorColor:"#c0c0c0";formeditorZoom:0.75;height:480;width:800}
}
##^##*/
