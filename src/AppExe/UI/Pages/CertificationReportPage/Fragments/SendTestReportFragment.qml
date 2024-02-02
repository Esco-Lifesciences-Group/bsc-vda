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
        //        initialItem: printerComponent
        //        initialItem: sendServerDoneComponent

        Component.onCompleted: {
            sectionStackView.replace(connectTargetComp)
            //                        sectionStackView.push(printerComponent)
        }//
    }//

    Component {
        id: connectTargetComp

        Item {
            Column {
                anchors.centerIn: parent
                //        columnSpacing: 10
                spacing: 10
                //        columns: 1

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
                        if(props.motorVerificationPassed && props.vdcSensorPassed)
                        {
                            //                        sectionStackView.replace(printeToServerComponent); return
                            viewApp.showBusyPage(qsTr("Connecting..."), function onCallback(cycle){
                                if (cycle >= MachineAPI.BUSY_CYCLE_10){
                                    /// time out after 3o second
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
                        else{
                            if(!props.vdcSensorPassed){
                                const message = qsTr("Sensor VDC is invalid!")
                                props.showFailedNotification(message)
                            }
                            else{
                                const message = qsTr("Motor verification is not passed!")
                                props.showFailedNotification(message)
                            }
                        }
                    }//
                }//
            }//

            QtObject {
                id: settingsCert
                //                category: "certification"

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

                    /// NOT IMPLEMENTED, IT WILL RESPONSIBE BY SERVER
                    //                    Column {
                    //                        spacing: 5

                    //                        TextApp {
                    //                            text: qsTr("Test Report Template")
                    //                        }//

                    //                        ComboBoxApp {
                    //                            id: templateTestReportCombox
                    //                            width: 300
                    //                            font.pixelSize: 20

                    //                            textRole: 'name'
                    //                            model: props.testReportTemplates

                    //                            //                            model: [
                    //                            //                                {'id': 1, 'name': "LA2-4 (NSF)"},
                    //                            //                                {'id': 1, 'name': "LA2-4 (EN)"},
                    //                            //                            ]
                    //                        }//
                    //                    }//

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
                            //                            model: [
                            //                                {'id': 1, 'name': "PDF file (saved on server)"},
                            //                                {'id': 1, 'name': "Test Room - Cassete 1"},
                            //                                {'id': 1, 'name': "Test Room - Cassete 2"}
                            //                            ]
                        }//
                    }//

                    Column {
                        spacing: 5

                        TextApp {
                            text: qsTr("Printer for Certificate")
                        }//

                        ComboBoxApp {
                            id: printerForCertCombox
                            width: 300
                            font.pixelSize: 20

                            textRole: 'name'
                            model: props.printerDevices

                            //                            model: [
                            //                                {'id': 1, 'name': "PDF file (saved on server)"},
                            //                                {'id': 1, 'name': "Test Room - Cassete 1"},
                            //                                {'id': 1, 'name': "Test Room - Cassete 2"}
                            //                            ]
                        }//
                    }//
                }//

                ButtonBarApp {
                    anchors.horizontalCenter: parent.horizontalCenter
                    text: qsTr("Send")
                    imageSource: "qrc:/UI/Pictures/upload-icon-35px.png"

                    onClicked: {
                        //                        console.log(JSON.stringify(printeToServerItem.generatePayload("", "")))

                        if(/*!templateTestReportCombox.currentIndex ||*/ !printerForTestReportCombox.currentIndex || !printerForCertCombox.currentIndex) {
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

                        //                        const template          = templateTestReportCombox.currentText
                        const printerForReport  = printerForTestReportCombox.currentText
                        const printerForCert    = printerForCertCombox.currentText

                        const varString =   printeToServerItem.generatePayload(printerForReport, printerForCert)
                        //                        //console.log("var string " + varString)

                        let xhttpPrint = new XMLHttpRequest()
                        const url = "http://" + settingsCert.serverIPv4 + "/store-and-print/"
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

            QtObject {
                id: settingsGeneral
                //                category: "afmeafull"
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

                // onServerIPv4Changed: MachineAPI.setCertificationParametersStr(MachineAPI.CertifParamStr_serverIPv4, serverIPv4)
            }//

            function generatePayload(pftr, pfcr){

                let meaUnitStr = MachineData.measurementUnit ? 'imp' : 'metric'
                let precision = MachineData.measurementUnit ? 0 : 2
                let precisionTol = MachineData.measurementUnit ? 0 : 3

                let ifnpc = Number(MachineData.machineProfile['airflow']['ifa']['dim']["nominal"][meaUnitStr]['velocity']).toFixed(precision)
                    + " ± "
                    + Number(MachineData.machineProfile['airflow']['ifa']['dim']["nominal"][meaUnitStr]['velocityTol']).toFixed(precisionTol)
                    + " "
                    + (MachineData.measurementUnit ? "fpm" : "m/s")

                let ifmpc = Number(MachineData.machineProfile['airflow']['ifa']['dim']["minimum"][meaUnitStr]['velocity']).toFixed(precision)
                    + " ± "
                    + Number(MachineData.machineProfile['airflow']['ifa']['dim']["minimum"][meaUnitStr]['velocityTol']).toFixed(precisionTol)
                    + " "
                    + (MachineData.measurementUnit ? "fpm" : "m/s")

                let ifspc = Number(MachineData.machineProfile['airflow']['ifa']['dim']["stb"][meaUnitStr]['velocity']).toFixed(precision)
                    + " ± "
                    + Number(MachineData.machineProfile['airflow']['ifa']['dim']["stb"][meaUnitStr]['velocityTol']).toFixed(precisionTol)
                    + " "
                    + (MachineData.measurementUnit ? "fpm" : "m/s")

                let dfnpc = Number(MachineData.machineProfile['airflow']['dfa']['nominal'][meaUnitStr]['velocity']).toFixed(precision)
                    + " ± "
                    + Number(MachineData.machineProfile['airflow']['dfa']['nominal'][meaUnitStr]['velocityTol']).toFixed(precisionTol)
                    + " "
                    + (MachineData.measurementUnit ? "fpm" : "m/s")

                //                console.log(ifnpc)
                //                console.log(ifmpc)
                //                console.log(ifspc)
                //                console.log(dfnpc)

                const dataTestReport = {
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

                    "noz_laskin":           settingsCert.noLaskin,
                    "damper_opening":       MachineData.measurementUnit ? settingsCert.damperOpenImp : settingsCert.damperOpen,

                    "grid_ifa_nom":         settingsGeneral.ifaCalGridNom,
                    "grid_ifa_nom_total":   MachineData.measurementUnit ? settingsGeneral.ifaCalGridNomTotImp : settingsGeneral.ifaCalGridNomTot,
                    "grid_ifa_nom_avg":     MachineData.measurementUnit ? settingsGeneral.ifaCalGridNomAvgImp : settingsGeneral.ifaCalGridNomAvg,
                    "grid_ifa_nom_vel":     MachineData.measurementUnit ? settingsGeneral.ifaCalGridNomVelImp : settingsGeneral.ifaCalGridNomVel,
                    "ducy_nom":             settingsGeneral.ifaCalGridNomDcy,
                    "rpm_nom":              settingsGeneral.ifaCalGridNomRpm,
                    "grid_ifa_nom_spec":    ifnpc,

                    "ifa_fail_vel":         MachineData.getInflowLowLimitVelocity(),

                    "grid_ifa_fail":        settingsGeneral.ifaCalGridMin,
                    "grid_ifa_fail_total":  MachineData.measurementUnit ? settingsGeneral.ifaCalGridMinTotImp : settingsGeneral.ifaCalGridMinTot,
                    "grid_ifa_fail_avg":    MachineData.measurementUnit ? settingsGeneral.ifaCalGridMinAvgImp : settingsGeneral.ifaCalGridMinAvg,
                    "grid_ifa_fail_vel":    MachineData.measurementUnit ? settingsGeneral.ifaCalGridMinVelImp : settingsGeneral.ifaCalGridMinVel,
                    "ducy_fail":            settingsGeneral.ifaCalGridMinDcy,
                    "rpm_fail":             settingsGeneral.ifaCalGridMinRpm,
                    "grid_ifa_fail_spec":   ifmpc,

                    "grid_ifa_stb":         settingsGeneral.ifaCalGridStb,
                    "grid_ifa_stb_total":   MachineData.measurementUnit ? settingsGeneral.ifaCalGridStbTotImp : settingsGeneral.ifaCalGridStbTot,
                    "grid_ifa_stb_avg":     MachineData.measurementUnit ? settingsGeneral.ifaCalGridStbAvgImp : settingsGeneral.ifaCalGridStbAvg,
                    "grid_ifa_stb_vel":     MachineData.measurementUnit ? settingsGeneral.ifaCalGridStbVelImp : settingsGeneral.ifaCalGridStbVel,
                    "ducy_stb":             settingsGeneral.ifaCalGridStbDcy,
                    "rpm_stb":              settingsGeneral.ifaCalGridStbRpm,
                    "grid_ifa_stb_spec":    ifspc,

                    "grid_dfa_nom":         settingsGeneral.dfaCalGridNom,
                    "grid_dfa_nom_avg":     MachineData.measurementUnit ? settingsGeneral.dfaCalGridNomVelImp : settingsGeneral.dfaCalGridNomVel,
                    "grid_dfa_nom_total":   MachineData.measurementUnit ? settingsGeneral.dfaCalGridNomVelTotImp : settingsGeneral.dfaCalGridNomVelTot,
                    "grid_dfa_nom_dev":     MachineData.measurementUnit ? settingsGeneral.dfaCalGridNomVelDevImp : settingsGeneral.dfaCalGridNomVelDev,
                    "grid_dfa_nom_devp":    settingsGeneral.dfaCalGridNomVelDevp,
                    "grid_dfa_nom_lowest":  MachineData.measurementUnit ? settingsGeneral.dfaCalGridNomVelLowImp : settingsGeneral.dfaCalGridNomVelLow,
                    "grid_dfa_nom_highest": MachineData.measurementUnit ? settingsGeneral.dfaCalGridNomVelHighImp : settingsGeneral.dfaCalGridNomVelHigh,
                    "grid_dfa_nom_count":   MachineData.machineProfile['airflow']['dfa']['nominal']['grid']['count'],
                    "grid_dfa_nom_columns": MachineData.machineProfile['airflow']['dfa']['nominal']['grid']['columns'],
                    "grid_dfa_nom_spec":    dfnpc,

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

                    /*                    "fan_hp":               MachineData.machineProfile['fan']['horsePower'],
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
                    "fcoa4":               Qt.md5(MachineData.machineProfile['fan']['constant']['a4'])
                }//

                const dataTestReportStringify = JSON.stringify(dataTestReport)

                const dataPayload = {
                    "pftr": pftr,
                    "pfcr": pfcr,
                    "details": dataTestReportStringify
                }//

                return dataPayload
                //                //console.log()
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
        id: settings
        //        category: "certification"

        property string sensorVdc       : MachineData.getCertificationParametersStr(MachineAPI.CertifParamStr_sensorVdc)

        property string mvInitialDfa    : MachineData.getCertificationParametersStr(MachineAPI.CertifParamStr_mvInitialDfa)
        property string mvInitialIfa    : MachineData.getCertificationParametersStr(MachineAPI.CertifParamStr_mvInitialIfa)
        property string mvBlockDfa      : MachineData.getCertificationParametersStr(MachineAPI.CertifParamStr_mvBlockDfa)
        property string mvBlockIfa      : MachineData.getCertificationParametersStr(MachineAPI.CertifParamStr_mvBlockIfa)
        property string mvFinalDfa      : MachineData.getCertificationParametersStr(MachineAPI.CertifParamStr_mvFinalDfa)
        property string mvFinalIfa      : MachineData.getCertificationParametersStr(MachineAPI.CertifParamStr_mvFinalIfa)

        property string mvInitialDfaImp : MachineData.getCertificationParametersStr(MachineAPI.CertifParamStr_mvInitialDfaImp)
        property string mvInitialIfaImp : MachineData.getCertificationParametersStr(MachineAPI.CertifParamStr_mvInitialIfaImp)
        property string mvBlockDfaImp   : MachineData.getCertificationParametersStr(MachineAPI.CertifParamStr_mvBlockDfaImp)
        property string mvBlockIfaImp   : MachineData.getCertificationParametersStr(MachineAPI.CertifParamStr_mvBlockIfaImp)
        property string mvFinalDfaImp   : MachineData.getCertificationParametersStr(MachineAPI.CertifParamStr_mvFinalDfaImp)
        property string mvFinalIfaImp   : MachineData.getCertificationParametersStr(MachineAPI.CertifParamStr_mvFinalIfaImp)

        Component.onCompleted: {
            const mvInitialDfa =     settings.mvInitialDfa
            const mvInitialIfa =     settings.mvInitialIfa
            const mvBlockDfa =       settings.mvBlockDfa
            const mvBlockIfa =       settings.mvBlockIfa
            const mvFinalDfa =       settings.mvFinalDfa
            const mvFinalIfa =       settings.mvFinalIfa

            const mvInitialDfaImp =     settings.mvInitialDfaImp
            const mvInitialIfaImp =     settings.mvInitialIfaImp
            const mvBlockDfaImp =       settings.mvBlockDfaImp
            const mvBlockIfaImp =       settings.mvBlockIfaImp
            const mvFinalDfaImp =       settings.mvFinalDfaImp
            const mvFinalIfaImp =       settings.mvFinalIfaImp

            let tolerance = 0.025
            let initialDfa = Number(mvInitialDfa)
            let initialIfa = Number(mvInitialIfa)

            let blockedIfa = Number(mvBlockIfa)
            let blockedDfa = Number(mvBlockDfa)
            let finalIfa = Number(mvFinalIfa)
            let finalDfa = Number(mvFinalDfa)

            if(MachineData.measurementUnit === MachineAPI.MEA_UNIT_IMPERIAL){
                tolerance = 5
                initialDfa = Number(mvInitialDfaImp)
                initialIfa = Number(mvInitialIfaImp)

                blockedIfa = Number(mvBlockIfaImp)
                blockedDfa = Number(mvBlockDfaImp)
                finalIfa = Number(mvFinalIfaImp)
                finalDfa = Number(mvFinalDfaImp)
            }//

            tolerance *= 1000
            initialDfa *= 1000
            initialIfa *= 1000

            blockedIfa *= 1000
            blockedDfa *= 1000
            finalIfa *= 1000
            finalDfa *= 1000

            // console.debug(tolerance, initialDfa, initialIfa, blockedIfa, blockedDfa, finalIfa, finalDfa)

            const dfaBlockPassed = (Math.abs(Number(initialDfa) - Number(blockedDfa))) > tolerance ? false : true
            const ifaBlockPassed = (Math.abs(Number(initialIfa) - Number(blockedIfa))) > tolerance ? false : true

            const dfaFinalPassed = (Math.abs(Number(initialDfa) - Number(finalDfa))) > tolerance ? false : true
            const ifaFinalPassed = (Math.abs(Number(initialIfa) - Number(finalIfa))) > tolerance ? false : true

            // console.debug("blockedDfa", Math.abs(Number(initialDfa) - Number(blockedDfa)))
            // console.debug("blockedIfa", Math.abs(Number(initialIfa) - Number(blockedIfa)))
            // console.debug("finalDfa", Math.abs(Number(initialDfa) - Number(finalDfa)))
            // console.debug("finalIfa", Math.abs(Number(initialIfa) - Number(finalIfa)))
            // console.debug("dfaBlockPassed:", dfaBlockPassed, "ifaBlockPassed:",  ifaBlockPassed, "dfaFinalPassed:",  dfaFinalPassed, "ifaFinalPassed:",  ifaFinalPassed)

            props.motorVerificationPassed = (dfaBlockPassed && ifaBlockPassed && dfaFinalPassed && ifaFinalPassed)
            if(__osplatform__)
                props.vdcSensorPassed = (Number(settings.sensorVdc) > 0.1)
            else
                props.vdcSensorPassed = true;
        }//
    }//

    QtObject {
        id: props

        property bool motorVerificationPassed: false
        property bool vdcSensorPassed: false

        property var printerDevices: [{}]
        property var testReportTemplates: [{}]

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
