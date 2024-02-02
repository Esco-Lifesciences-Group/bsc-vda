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

Item {
    id: bodyItem
    Layout.fillWidth: true
    Layout.fillHeight: true

    Flow {
        anchors.centerIn: parent
        width: 305
        spacing: 5

        Rectangle {
            height: 100
            width: 305
            radius: 5
            color: "#0F2952"
            border.color: "#e3dac9"

            ColumnLayout {
                anchors.fill: parent

                TextApp {
                    Layout.margins: 5
                    text: "Export Via"
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
                                source: "qrc:/UI/Pictures/pdf-export-bt.png"
                            }//

                            MouseArea {
                                anchors.fill: parent
                                onClicked: {
                                    props.exportToWhat = props.exportToPdfBluetooth

                                    let fileName = String(MachineData.cabinetDisplayName).replace(" ", "_")
                                    let serialNumber = String(MachineData.serialNumber)
                                    if(serialNumber.length === 0) serialNumber = "00000"

                                    let targetFileName = fileName + "_" + serialNumber + "_field" + ".txt"

                                    const jsonObj = bodyItem.generatePayload()
                                    jstoText.write(jsonObj, targetFileName)
                                }//
                            }//
                        }//

                        Item {
                            Layout.fillHeight: true
                            Layout.fillWidth: true

                            Image {
                                anchors.centerIn: parent
                                source: "qrc:/UI/Pictures/pdf-export-usb.png"
                            }//

                            MouseArea {
                                anchors.fill: parent
                                onClicked: {

                                    props.exportToWhat = props.exportToPdfUSB

                                    const message = "<b>" + qsTr("Have you inserted USB drive?") + "</b>"
                                                  + "<br><br>"
                                                  + qsTr("USB port can be found on top of the cabinet, nearby power inlet.")
                                    const autoclosed = false
                                    showDialogAsk(qsTr("USB Export"), message, dialogAlert,
                                                  function onAccepted(){
                                                      let fileName = String(MachineData.cabinetDisplayName).replace(" ", "_")
                                                      let serialNumber = String(MachineData.serialNumber)
                                                      if(serialNumber.length === 0) serialNumber = "00000"

                                                      let targetFileName = fileName + "_" + serialNumber + "_field" + ".txt"

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
    }//

    JstoText {
        id: jstoText

        onExportFinished: {
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
                                         qsTr("Failed when creating document"))
            }
        }
    }

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

        property string ifaCalGridNomSec        : MachineData.getIfaCalGridSec(calibMode, MachineAPI.INFLOW_GRID_NOMINAL)
        property int    ifaCalGridNomTotSec     : MachineData.getIfaCalGridTotSec(calibMode, MachineAPI.INFLOW_GRID_NOMINAL)
        property int    ifaCalGridNomAvgSec     : MachineData.getIfaCalGridAvgSec(calibMode, MachineAPI.INFLOW_GRID_NOMINAL)
        property int    ifaCalGridNomVelSec     : MachineData.getIfaCalGridVelSec(calibMode, MachineAPI.INFLOW_GRID_NOMINAL)
        property int    ifaCalGridNomTotSecImp  : MachineData.getIfaCalGridTotSecImp(calibMode, MachineAPI.INFLOW_GRID_NOMINAL)
        property int    ifaCalGridNomAvgSecImp  : MachineData.getIfaCalGridAvgSecImp(calibMode, MachineAPI.INFLOW_GRID_NOMINAL)
        property int    ifaCalGridNomVelSecImp  : MachineData.getIfaCalGridVelSecImp(calibMode, MachineAPI.INFLOW_GRID_NOMINAL)
        property int    ifaCalGridNomDcySec     : MachineData.getIfaCalGridDcySec(calibMode, MachineAPI.INFLOW_GRID_NOMINAL)
        property int    ifaCalGridNomRpmSec     : MachineData.getIfaCalGridRpmSec(calibMode, MachineAPI.INFLOW_GRID_NOMINAL)

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

    Settings {
        id: settingsCert
        category: "certification"

        property string cabinetModel:       MachineData.machineModelName
        property int    cabinetSize:        MachineData.machineProfile['width']['feet']
        property string calibProc:          ""
        property string calibProcField:     ""
        property string serialNumber:       ""
        property string powerRating:        "220 VAC / 50Hz"

        property string testerNameField:         ""
        property string testerSignatureField:    ""
        property string checkerNameField:        ""
        property string checkerSignatureField:   ""

        property string customer:           "WORLD-MTR"
        property string country:            "SINGAPORE"
        property string dateTest:           Qt.formatDate(new Date, "dd-MMM-yyyy")
        property string swVersion:          Qt.application.name + " - " + Qt.application.version
    }//

    function generatePayload(trt, pftr, pfcr){
        let dataTestReport = {
            "calib_fil":            true, /// this field calibration

            "cabinet_model":        settingsCert.cabinetModel,
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

            "tested_by":            settingsCert.testerNameField,
            "t_signature":          settingsCert.testerSignatureField,
            "checked_by":           settingsCert.checkerNameField,
            "c_signature":          settingsCert.checkerSignatureField === "" ? " " : settingsCert.checkerSignatureField,

            "sw_ver":               settingsCert.swVersion,

            "grid_ifa_nom":         settingsGeneral.ifaCalGridNom,
            "grid_ifa_nom_total":   MachineData.measurementUnit ? settingsGeneral.ifaCalGridNomTotImp : settingsGeneral.ifaCalGridNomTot,
            "grid_ifa_nom_avg":     MachineData.measurementUnit ? settingsGeneral.ifaCalGridNomAvgImp : settingsGeneral.ifaCalGridNomAvg,
            "grid_ifa_nom_vel":     MachineData.measurementUnit ? settingsGeneral.ifaCalGridNomVelImp : settingsGeneral.ifaCalGridNomVel,

            "ducy_nom":             MachineData.getFanPrimaryNominalDutyCycle(),
            "ducy_stb":             MachineData.getFanPrimaryStandbyDutyCycle(),

            "grid_dfa_nom":         settingsGeneral.dfaCalGridNom,
            "grid_dfa_nom_avg":     MachineData.measurementUnit ? settingsGeneral.dfaCalGridNomVelImp : settingsGeneral.dfaCalGridNomVel,
            "grid_dfa_nom_total":   MachineData.measurementUnit ? settingsGeneral.dfaCalGridNomVelTotImp : settingsGeneral.dfaCalGridNomVelTot,
            "grid_dfa_nom_dev":     MachineData.measurementUnit ? settingsGeneral.dfaCalGridNomVelDevImp : settingsGeneral.dfaCalGridNomVelDev,
            "grid_dfa_nom_devp":    settingsGeneral.dfaCalGridNomVelDevp,
            "grid_dfa_nom_lowest":  MachineData.measurementUnit ? settingsGeneral.dfaCalGridNomVelLowImp : settingsGeneral.dfaCalGridNomVelLow,
            "grid_dfa_nom_highest": MachineData.measurementUnit ? settingsGeneral.dfaCalGridNomVelHighImp : settingsGeneral.dfaCalGridNomVelHigh,
            "grid_dfa_nom_count":   MachineData.machineProfile['airflow']['dfa']['nominal']['grid']['count'],
            "grid_dfa_nom_columns": MachineData.machineProfile['airflow']['dfa']['nominal']['grid']['columns'],

            "cabinet_name":         MachineData.cabinetDisplayName
        }//

        const dataPayload = {
            "trt":  trt,
            "pftr": pftr,
            "pfcr": pfcr,
            "data": dataTestReport
        }//

        return dataPayload
    }//

    QtObject{
        id: props

        readonly property int exportToPdfUSB: 0
        readonly property int exportToPdfBluetooth: 1
        property int exportToWhat: 0
    }//
}//



/*##^##
Designer {
    D{i:0;autoSize:true;formeditorColor:"#c0c0c0";formeditorZoom:0.75;height:480;width:800}
}
##^##*/
