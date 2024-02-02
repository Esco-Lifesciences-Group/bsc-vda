import QtQuick 2.0
import QtQuick.Controls 2.7
import QtQuick.Layouts 1.0
import UI.CusCom 1.1
import Qt.labs.settings 1.1
import ModulesCpp.Machine 1.0

Item {
    StackView {
        id: sectionStackView
        anchors.fill: parent
        // initialItem: printerComponent
        // initialItem: sendServerDoneComponent

        Component.onCompleted: {
            sectionStackView.replace(connectTargetComp)
            // sectionStackView.push(printerComponent)
        }//
    }//

    Component {
        id: connectTargetComp

        Item {
            Column {
                anchors.centerIn: parent
                // columnSpacing: 10
                spacing: 10
                // columns: 1

                Column {
                    spacing: 5

                    TextApp {
                        text: qsTr("Server Address")
                    }//

                    TextFieldApp {
                        id: serverIpTextField
                        width: 300
                        height: 40

                        onPressed: {
                            KeyboardOnScreenCaller.openKeyboard(this, qsTr("Server Address"))
                        }//

                        onAccepted: {
                            settingsCert.serverIPv4 = text
                        }//
                    }//
                }//

                ButtonBarApp {
                    anchors.horizontalCenter: parent.horizontalCenter
                    text: qsTr("Connect")
                    imageSource: "qrc:/UI/Pictures/upload-icon-35px.png"

                    onClicked: {
                        viewApp.showBusyPage(qsTr("Connecting..."), function onCallback(cycle){
                            if (cycle >= MachineAPI.BUSY_CYCLE_10){
                                /// time out after 30 second
                                viewApp.closeDialog()
                            }
                        })

                        let xhttpPrinter = new XMLHttpRequest()
                        const url2 = "http://" + settingsCert.serverIPv4 + "/printer/"
                        //console.log("XMLHttpRequest-url:" + url2)
                        xhttpPrinter.open("GET", url2, true);
                        //                                    xhttpPrinter.setRequestHeader('Content-Type', 'application/json');

                        xhttpPrinter.onreadystatechange = function(){
                            if(xhttpPrinter.readyState === XMLHttpRequest.DONE) {
                                const xstatus = xhttpPrinter.status
                                //console.log("XMLHttpRequest:" + xstatus)
                                //console.log(xstatus)
                                if(xstatus === 200) {
                                    viewApp.closeDialog()

                                    const reponseText = xhttpPrinter.responseText
                                    //console.log(reponseText)

                                    let model = JSON.parse(reponseText)
                                    model.unshift({"id":0, "name": "Tap here to select"});
                                    props.printerDevices = model

                                    sectionStackView.replace(printeToServerComponent)
                                }
                                else {
                                    //console.log(3)
                                    props.showDialogFailComServer()
                                }
                            }
                        }
                        xhttpPrinter.send()

                    }//
                }//
            }//

            QtObject {
                id: settingsCert
                //category: "certification"

                property string serverIPv4: MachineData.getCertificationParametersStr(MachineAPI.CertifParamStr_serverIPv4)

                onServerIPv4Changed: MachineAPI.setCertificationParametersStr(MachineAPI.CertifParamStr_serverIPv4, serverIPv4)

                Component.onCompleted: {
                    serverIpTextField.text = serverIPv4
                }//
            }//
        }//
    }//

    Component {
        id: printeToServerComponent

        Item {
            id: printeToServerItem

            Column {
                anchors.centerIn: parent
                //        columnSpacing: 10
                spacing: 10
                //        columns: 1

                Column {
                    spacing: 5

                    Column {
                        spacing: 5

                        TextApp {
                            text: qsTr("Printer for Test Report")
                        }//

                        ComboBoxApp {
                            id: printerForTestReportCombox
                            width: 300
                            font.pixelSize: 20

                            textRole: 'name'
                            model: props.printerDevices
                        }//
                    }//
                }//

                ButtonBarApp {
                    anchors.horizontalCenter: parent.horizontalCenter
                    text: qsTr("Send")
                    imageSource: "qrc:/UI/Pictures/upload-icon-35px.png"

                    onClicked: {
                        // console.log(JSON.stringify(printeToServerItem.generatePayload("", "")))

                        if(!printerForTestReportCombox.currentIndex) {
                            viewApp.showDialogMessage(qsTr("Attention!"),
                                                      qsTr("Please select the valid option for all the forms!"),
                                                      viewApp.dialogAlert)
                            return
                        }

                        viewApp.showBusyPage(qsTr("Sending..."), function onCallback(cycle){
                            if (cycle >= MachineAPI.BUSY_CYCLE_10){
                                /// time out after 3o second
                                viewApp.closeDialog()
                            }
                        })

                        // const template          = templateTestReportCombox.currentText
                        const printerForReport  = printerForTestReportCombox.currentText
                        // const printerForCert    = printerForCertCombox.currentText

                        const varString =   printeToServerItem.generatePayload(printerForReport)
                        ////console.log("var string " + varString)

                        let xhttpPrint = new XMLHttpRequest()
                        const url = "http://" + settingsCert.serverIPv4 + "/1-10/store-and-print/"
                        //console.log("XMLHttpRequest-url:" + url)
                        xhttpPrint.open("POST", url, true);
                        xhttpPrint.setRequestHeader('Content-Type', 'application/json');

                        xhttpPrint.onreadystatechange = function(){
                            if(xhttpPrint.readyState === XMLHttpRequest.DONE) {
                                const xstatus = xhttpPrint.status
                                //                                console.log("XMLHttpRequest:" + xstatus)
                                if(xstatus === 200 || xstatus === 201) {
                                    viewApp.closeDialog()

                                    const reponseText = xhttpPrint.responseText
                                    //                                    console.log(reponseText)

                                    viewApp.closeDialog()
                                    sectionStackView.replace(sendServerDoneComponent)
                                }
                                else {
                                    //console.log(5)
                                    //                                    console.log(xhttpPrint.responseText)
                                    //                                    props.showDialogFailComServer()
                                    viewApp.closeDialog()
                                    serverResponseMessageTextArea.text = qsTr("Failed! Because") + " " + xhttpPrint.responseText
                                    serverResponseMessageItem.visible = true
                                }//
                            }//
                        }//
                        xhttpPrint.send(JSON.stringify(varString))
                    }//
                }//
            }//

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

            function generatePayload(pftr){
                let acceptNoise = "The noise shall not exceed 67 dBA (Based on NSF/ANSI 49 standard)." // NSF

                if(settings.noiseStd == "EN")
                    acceptNoise = "The noise should not exceed 65 dBA (Based on EN12469:2000 standard)."
                else if(settings.noiseStd == "NSF ETI")
                    acceptNoise = "The noise shall not exceed 68 dBA (Based on NSF/ANSI 49 standard)."
                else if(settings.noiseStd == "AUS")
                    acceptNoise = "The noise should not exceed 65 dBA (Based on AS 1807.20.2000 standard)."

                let noiseLevelNomGrid = [], noiseLevelOffGrid = [], i = 0;
                for(i=0; i<settings.noiseLevelNomGrid; i++){
                    noiseLevelNomGrid.push(Number(Number(settings.noiseLevelNomGrid[i])/10).toFixed(1))
                }
                for(i=0; i<settings.noiseLevelOffGrid; i++){
                    noiseLevelOffGrid.push(Number(Number(settings.noiseLevelOffGrid[i])/10).toFixed(1))
                }

                let lightIntNomGrid = [], lightIntOffGrid = []
                for(i=0; i<settings.lightIntNomGrid; i++){
                    if(Number(settings.lightIntNomGrid[i]) == Number(-1))
                        lightIntNomGrid.push("NA")
                    else
                        lightIntNomGrid.push(Number(Number(settings.lightIntNomGrid[i])/1).toFixed())
                }
                for(i=0; i<settings.lightIntOffGrid; i++){
                    if(Number(settings.lightIntOffGrid[i]) == Number(-1))
                        lightIntOffGrid.push("NA")
                    else
                        lightIntOffGrid.push(Number(Number(settings.lightIntOffGrid[i])/1).toFixed())
                }
                let vibNomGrid = [], vibOffGrid = []
                for(i=0; i<settings.vibNomGrid; i++){
                    if(Number(settings.vibNomGrid[i]) == Number(-1))
                        vibNomGrid.push("NA")
                    else
                        vibNomGrid.push(Number(Number(settings.vibNomGrid[i])/100).toFixed(2))
                }
                for(i=0; i<settings.vibOffGrid; i++){
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

                const dataTestReportStringify = JSON.stringify(dataTestReport)

                const dataPayload = {
                    "pftr110": pftr,
                    "details": dataTestReportStringify
                }//

                return dataPayload
            }//

            Item {
                id: serverResponseMessageItem
                anchors.fill: parent
                visible: false

                Rectangle {
                    anchors.fill: parent
                    color: "#DC143C"
                    radius: 5
                }//

                ColumnLayout {
                    anchors.fill: parent

                    Rectangle {
                        Layout.minimumHeight: 30
                        Layout.fillWidth: true
                        color: "#0F2952"

                        TextApp {
                            anchors.fill: parent
                            horizontalAlignment: Text.AlignHCenter
                            verticalAlignment: Text.AlignVCenter
                            text: qsTr("Server Response")
                        }
                    }

                    Item {
                        Layout.fillHeight: true
                        Layout.fillWidth: true

                        ScrollView {
                            id: view
                            anchors.fill: parent

                            TextArea {
                                id: serverResponseMessageTextArea
                                // text: "TextArea\n...\n...\n...\n...\n...\n...\n"
                                font.pixelSize: 20
                                color: "#e3dac9"
                                wrapMode: Text.WrapAtWordBoundaryOrAnywhere
                            }//
                        }//
                    }//

                    Rectangle {
                        Layout.minimumHeight: 50
                        Layout.fillWidth: true
                        color: "#0F2952"
                        opacity: serverInfoMouseArea.pressed ? 0.5 : 1

                        TextApp {
                            anchors.fill: parent
                            horizontalAlignment: Text.AlignHCenter
                            verticalAlignment: Text.AlignVCenter
                            text: qsTr("Close")
                        }//

                        MouseArea {
                            id: serverInfoMouseArea
                            anchors.fill: parent
                            onClicked: {
                                sectionStackView.replace(connectTargetComp)
                            }//
                        }//
                    }//
                }//
            }//
        }//
    }//

    Component {
        id: sendServerDoneComponent

        Item {
            id: sendServerDoneItem

            Column {
                anchors.centerIn: parent
                spacing: 10

                Image {
                    anchors.horizontalCenter: parent.horizontalCenter
                    source: "qrc:/UI/Pictures/flat-ui_printer.png"

                    Rectangle {
                        height: 10
                        width: 100
                        radius: 5
                        color: "#27ae60"
                        anchors.horizontalCenter: parent.horizontalCenter
                        anchors.top: parent.top
                        anchors.topMargin: parent.height * 0.375

                        Timer {
                            id: blinkAnimTimer
                            running: true;
                            interval: 2000
                            onTriggered: {
                                stop()
                                parent.opacity = !parent.opacity
                                interval = parent.opacity ? 2000 : 200
                                start()
                            }//
                        }//
                    }//
                }//

                Column {
                    TextApp {
                        anchors.horizontalCenter: parent.horizontalCenter
                        text: qsTr("Certification data has been sent to the server!")
                    }//

                    TextApp {
                        anchors.horizontalCenter: parent.horizontalCenter
                        text: qsTr("It will take a moment to print the document.") + "<br>" +
                              qsTr("Please check the printer's queue if necessary.")
                    }//
                }//

                TextApp {
                    anchors.horizontalCenter: parent.horizontalCenter
                    font.underline: true
                    text: qsTr("Got problem? Send again.")

                    MouseArea {
                        anchors.fill: parent
                        onClicked: {
                            sectionStackView.replace(connectTargetComp, StackView.PopTransition)
                        }//
                    }//
                }//
            }//
        }//
    }//

    UtilsApp{
        id: utils
    }

    QtObject {
        id: props

        property var printerDevices: [{}]

        function showDialogFailComServer(){
            viewApp.showDialogMessage(qsTr("Attention!"),
                                      qsTr("Failed to communicate with the server!"), viewApp.dialogAlert)
        }//

        function showFailedNotification(message){
            viewApp.showDialogMessage(qsTr("Attention!"),
                                      message, viewApp.dialogAlert)
        }

        Component.onCompleted: {

        }
    }//
}//
