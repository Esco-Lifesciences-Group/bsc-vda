/**
 *  Copyright (C) 2021 by ESCO Bintan Indonesia
 *  https://escoglobal.com
 *
 *  Author:
 *  - Ahmad Qodri
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
                                        let date = new Date()
                                        let dateTimeStr = Qt.formatDateTime(date, "yyyyMMddhhmmss")

                                        props.exportToWhat = props.exportToBluetooth
                                        props.callFromPdf = 0 //flag for js generator

                                        //let fileName = String(MachineData.cabinetDisplayName).replace(" ", "_")
                                        let serialNumber = String(MachineData.serialNumber)
                                        if(serialNumber.length === 0) serialNumber = "00000"

                                        let targetFileName = serialNumber + "_" + settings.cabinetModel + "_Full_" + props.fileOutputType + "_%1.txt".arg(dateTimeStr)
                                        targetFileName = props.cleanName(targetFileName)

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
                                        props.exportToWhat = props.exportToUSB
                                        props.callFromPdf = 0 //flag for js generator

                                        const message = "<b>" + qsTr("Have you inserted USB drive?") + "</b>"
                                                      + "<br><br>"
                                                      + qsTr("USB port can be found on top of the cabinet, near by power inlet.")
                                        const autoclosed = false
                                        showDialogAsk(qsTr("Export"), message, dialogAlert,
                                                      function onAccepted(){
                                                          let date = new Date()
                                                          let dateTimeStr = Qt.formatDateTime(date, "yyyyMMddhhmmss")
                                                          //let fileName = String(MachineData.cabinetDisplayName).replace(" ", "_")
                                                          let serialNumber = String(MachineData.serialNumber)
                                                          if(serialNumber.length === 0) serialNumber = "00000"

                                                          let targetFileName = serialNumber + "_" + settings.cabinetModel + "_Full_" + props.fileOutputType + "_%1.txt".arg(dateTimeStr)
                                                          targetFileName = props.cleanName(targetFileName)

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
                        //text: qsTr("Export") + " " + qsTr("(Week: ") + props.exportTargetWeek + ")"
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
                                                    props.exportToWhat = props.exportToBluetooth
                                                    props.callFromPdf = 1 //flag for js generator

                                                    let date = new Date()
                                                    let dateTimeStr = Qt.formatDateTime(date, "yyyyMMddhhmmss")

                                                    //let fileName = String(MachineData.cabinetDisplayName).replace(" ", "_")
                                                    let serialNumber = String(MachineData.serialNumber)
                                                    if(serialNumber.length === 0) serialNumber = "00000"

                                                    let targetFileName = serialNumber + "_" + settings.cabinetModel + "_Full_" + props.fileOutputType + "_%1.txt".arg(dateTimeStr)
                                                    targetFileName = props.cleanName(targetFileName)

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

                                                    props.exportToWhat = props.exportToUSB
                                                    props.callFromPdf = 1 //flag for js generator

                                                    const message = "<b>" + qsTr("Have you inserted USB drive?") + "</b>"
                                                                  + "<br><br>"
                                                                  + qsTr("USB port can be found on top of the cabinet, near by power inlet.")
                                                    const autoclosed = false
                                                    showDialogAsk(qsTr("Export"), message, dialogAlert,
                                                                  function onAccepted(){
                                                                      let date = new Date()
                                                                      let dateTimeStr = Qt.formatDateTime(date, "yyyyMMddhhmmss")
                                                                      //let fileName = String(MachineData.cabinetDisplayName).replace(" ", "_")
                                                                      let serialNumber = String(MachineData.serialNumber)
                                                                      if(serialNumber.length === 0) serialNumber = "00000"

                                                                      let targetFileName = serialNumber + "_" + settings.cabinetModel + "_Full_" + props.fileOutputType + "_%1.txt".arg(dateTimeStr)
                                                                      targetFileName = props.cleanName(targetFileName)

                                                                      const jsonObj = bodyItem.generatePayload()
                                                                      console.debug(JSON.stringify(jsonObj))

                                                                      //Generate latest json file first
                                                                      jstoText.write(jsonObj, targetFileName)
                                                                      props.sourceJsonName = targetFileName

                                                                      //Generate pdf
                                                                      pdfExportLoader.active = true
                                                                  },
                                                                  function(){}, function(){}, autoclosed)
                                                }//
                                            }//
                                        }//
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
                                              if(props.exportToWhat == props.exportToBluetooth){
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
                setOutputType(props.fileOutputType)
                setCustomer(props.pdfCustomer)
                setCabinetModel(props.pdfCabinetModel)

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

                    targetFileName = serialNumber + "_" + settings.cabinetModel + "_Full_" + props.fileOutputType + "_%1.pdf".arg(dateTimeStr)

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
                let expToBt = props.exportToBluetooth
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
                                                  if(expToWhat == expToBt){
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


    function generatePayload(pftr){
        let acceptNoise = "The noise shall not exceed 67 dBA (Based on NSF/ANSI 49 standard)." // NSF

        if(settings.noiseStd == "EN")
            acceptNoise = "The noise should not exceed 65 dBA (Based on EN12469:2000 standard)."
        else if(settings.noiseStd == "NSF ETI")
            acceptNoise = "The noise shall not exceed 68 dBA (Based on NSF/ANSI 49 standard)."
        else if(settings.noiseStd == "AUS")
            acceptNoise = "The noise should not exceed 65 dBA (Based on AS 1807.20.2000 standard)."

        let noiseLevelNomGrid = [], noiseLevelOffGrid = [], i = 0;
        for(i=0; i<settings.noiseLevelNomGrid.length; i++){
            noiseLevelNomGrid.push(Number(Number(settings.noiseLevelNomGrid[i])/10).toFixed(1))
        }
        for(i=0; i<settings.noiseLevelOffGrid.length; i++){
            noiseLevelOffGrid.push(Number(Number(settings.noiseLevelOffGrid[i])/10).toFixed(1))
        }

        let lightIntNomGrid = [], lightIntOffGrid = []
        for(i=0; i<settings.lightIntNomGrid.length; i++){
            if(Number(settings.lightIntNomGrid[i]) == Number(-1))
                lightIntNomGrid.push("NA")
            else
                lightIntNomGrid.push(Number(Number(settings.lightIntNomGrid[i])/1).toFixed())
        }
        for(i=0; i<settings.lightIntOffGrid.length; i++){
            if(Number(settings.lightIntOffGrid[i]) == Number(-1))
                lightIntOffGrid.push("NA")
            else
                lightIntOffGrid.push(Number(Number(settings.lightIntOffGrid[i])/1).toFixed())
        }
        let vibNomGrid = [], vibOffGrid = []
        for(i=0; i<settings.vibNomGrid.length; i++){
            if(Number(settings.vibNomGrid[i]) == Number(-1))
                vibNomGrid.push("NA")
            else
                vibNomGrid.push(Number(Number(settings.vibNomGrid[i])/100).toFixed(2))
        }
        for(i=0; i<settings.vibOffGrid.length; i++){
            if(Number(settings.vibOffGrid[i]) == Number(-1))
                vibOffGrid.push("NA")
            else
                vibOffGrid.push(Number(Number(settings.vibOffGrid[i])/100).toFixed(2))
        }
        const dataTestReport = {
            "customer":         settings.customer,
            "header_logo_txt":  settings.customer == "STREAMLINE" ? "Manufacturer of Laminar Flow Cabinets" : "",
            "model":            settings.cabinetModel,
            "serialnum":        settings.serialNumber,
            "testby":           settings.testedBy,
            "checkby":          settings.checkedBy,
            "date":             settings.date,

            "nlt_nom_grid":     noiseLevelNomGrid,
            "nlt_nom_avg":      Number(settings.noiseLevelNomAvg/10).toFixed(1),
            "nlt_off_grid":     noiseLevelOffGrid,
            "nlt_off_avg":      Number(settings.noiseLevelOffAvg/10).toFixed(1),
            "diff_on_off":      Number(settings.noiseLevelDiffNomOff/10).toFixed(1),
            "corr_noise":       Number(settings.noiseLevelCorr/10).toFixed(1),
            "cab_noise":        Number(settings.noiseLevel/10).toFixed(1),
            "acc_std":          acceptNoise,
            "nlt_res":          settings.noiseLevelRes ? "Pass" : "Fail",

            "lit_nom_grid":     lightIntNomGrid,
            "lit_nom_avg":      String(settings.lightIntNomAvg),
            "lit_off_grid":     lightIntOffGrid,
            "lit_off_avg":      String(settings.lightIntOffAvg),
            "lit_net":          String(settings.lightInt),
            "lit_res":          settings.lightIntRes ? "Pass" : "Fail",

            "vt_nom_grid":      vibNomGrid,
            "vt_nom_avg":       settings.vibTestEn ? (Number(settings.vibNomAvg/100).toFixed(2)) : "NA",
            "vt_off_grid":      vibOffGrid,
            "vt_off_avg":       settings.vibTestEn ? (Number(settings.vibOffAvg/100).toFixed(2)) : "NA",
            "vt_net":           settings.vibTestEn ? (Number(settings.vib/100).toFixed(2)) : "NA",
            "vt_res":           settings.vibTestEn ? (settings.vibRes ? "Pass" : "Fail") : "NA",

            "testnumber":       settings.formNo
        }//

        return dataTestReport
    }//

    UtilsApp{
        id: utils
    }

    Settings{
        id: settings
        category: "oneOfTen"

        property string cabinetModel: MachineData.getCertificationParametersStr(MachineAPI.CertifParamStr_cabinetModel)
        property string serialNumber: MachineData.getCertificationParametersStr(MachineAPI.CertifParamStr_serialNumber)
        property string formNo: "FM-TST-TR-1 of 10-01-B"
        property string testedBy: ""
        property string checkedBy: ""
        property string date: ""
        property string noiseStd: "NSF" //EN, NSF ETI, NSF, AUS
        property string customer: "WORLD" // ETI, WORLD, ANCARE, NONE, STREAMLINE

        property var noiseLevelNomGrid: [0,0,0,0,0,0,0,0,0,0] // *10
        property var noiseLevelOffGrid: [0,0,0,0,0,0,0,0,0,0] // *10
        property int noiseLevelNomAvg: 0 // *10
        property int noiseLevelOffAvg: 0 // *10
        property int noiseLevelDiffNomOff: 0 // *10
        property int noiseLevelCorr: 0 // *10 ->input from textfield
        property int noiseLevel: 0 // *10
        property bool noiseLevelRes: false // true = Pass

        property var lightIntNomGrid: [-1,-1,-1,-1,-1,-1,-1,-1,-1,-1]
        property var lightIntOffGrid: [-1,-1,-1,-1,-1,-1,-1,-1,-1,-1]
        property int lightIntNomAvg: 0
        property int lightIntOffAvg: 0
        property int lightInt: 0
        property bool lightIntRes: false
        property string lightIntUnit: MachineData.measurementUnit ? "ft-cd" : "Lux"

        property var vibNomGrid: [-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1] //*100
        property var vibOffGrid: [-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1] //*100
        property var vibNomGridBup: [-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1] //*100
        property var vibOffGridBup: [-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1] //*100
        property int vibNomAvg: -1 //*100
        property int vibOffAvg: -1 //*100
        property int vib: -1 //*100
        property bool vibRes: false
        property bool vibTestEn: true
    }//

    QtObject{
        id: props

        readonly property int exportToUSB: 0
        readonly property int exportToBluetooth: 1
        property int exportToWhat: 0

        property int callFromPdf: 0
        property string sourceJsonName: ""

        property string fileOutputType: "1-10"
        property string pdfCustomer: settings.customer
        property string pdfCabinetModel: MachineData.machineModelName

        function cleanName(name){
            name = name.replace(/\s+/gi, '-'); // Replace white space with dash
            return name.replace(/[^a-zA-Z0-9\-_.]/gi, ''); // Strip any special charactere exclude (- _ .)
        }

        Component.onCompleted: {
            console.debug(fileOutputType, pdfCustomer, pdfCabinetModel)
        }
    }//
}//



/*##^##
Designer {
    D{i:0;autoSize:true;formeditorColor:"#c0c0c0";formeditorZoom:0.75;height:480;width:800}
}
##^##*/
