/**
 *  Copyright (C) 2021 by ESCO Bintan Indonesia
 *  https://escoglobal.com
 *
 *  Author: Heri Cahyono
**/

import QtQuick 2.0
import QtQuick.Layouts 1.0
import QtQuick.Controls 2.0

import UI.CusCom 1.1
import "../../CusCom/JS/IntentApp.js" as IntentApp

import ModulesCpp.Machine 1.0

ViewApp {
    id: viewApp
    title: "Manual Input Calibration"

    background.sourceComponent: Item {}

    content.asynchronous: true
    content.sourceComponent: ContentItemApp{
        id: contentView
        height: viewApp.height
        width: viewApp.width

        visible: true

        ColumnLayout {
            anchors.fill: parent
            anchors.margins: 5
            spacing: 5

            /// HEADER
            Item {
                id: headerItem
                Layout.fillWidth: true
                Layout.minimumHeight: 60

                HeaderApp {
                    anchors.fill: parent
                    title: qsTr("Manual Input Calibration")
                }
            }

            /// BODY
            Item {
                id: bodyItem
                Layout.fillWidth: true
                Layout.fillHeight: true

                Row{
                    anchors.centerIn: parent
                    spacing: 10

                    Column {
                        spacing: 5

                        TextApp {
                            text: qsTr("Constant")
                        }//

                        TextFieldApp {
                            id: sensorConstantTextField
                            width: 100
                            height: 40
                            validator: IntValidator{bottom: 0; top: 99;}

                            onPressed: {
                                KeyboardOnScreenCaller.openNumpad(this, qsTr("Constant"))
                            }//
                        }//
                    }//

                    Column {
                        spacing: 5

                        //                        Column {
                        //                            spacing: 5

                        //                            TextApp {
                        //                                text: qsTr("ADC IF0")
                        //                            }//

                        //                            TextFieldApp {
                        //                                id: adcIfaZeroTextField
                        //                                width: 100
                        //                                height: 40

                        //                                onPressed: {
                        //                                    KeyboardOnScreenCaller.openNumpad(this, qsTr("ADC IF0"))
                        //                                }//
                        //                            }//
                        //                        }//

                        Column {
                            spacing: 5

                            TextApp {
                                text: qsTr("ADC IF1")
                            }//

                            TextFieldApp {
                                id: adcIfaMinTextField
                                width: 100
                                height: 40

                                onPressed: {
                                    KeyboardOnScreenCaller.openNumpad(this, qsTr("ADC IF1"))
                                }//
                            }//
                        }//

                        Column {
                            spacing: 5

                            TextApp {
                                text: qsTr("ADC IF2")
                            }//

                            TextFieldApp {
                                id: adcIfaNomTextField
                                width: 100
                                height: 40

                                onPressed: {
                                    KeyboardOnScreenCaller.openNumpad(this, qsTr("ADC IF2"))
                                }//
                            }//
                        }//
                    }//

                    Column {
                        spacing: 5

                        Column {
                            spacing: 5

                            TextApp {
                                text: qsTr("IF Alarm")
                            }//

                            TextFieldApp {
                                id: velIfaAlarmTextField
                                width: 100
                                height: 40

                                onPressed: {
                                    KeyboardOnScreenCaller.openNumpad(this, qsTr("Inflow Alarm"))
                                }//

                                TextApp {
                                    anchors.right: parent.right
                                    anchors.rightMargin: 5
                                    verticalAlignment: Text.AlignVCenter
                                    height: parent.height
                                    text: props.meaUnitStr
                                    color: "gray"
                                }//
                            }//
                        }//

                        Column {
                            spacing: 5

                            TextApp {
                                text: qsTr("IF Minimum")
                            }//

                            TextFieldApp {
                                id: velIfaMinTextField
                                width: 100
                                height: 40

                                onPressed: {
                                    KeyboardOnScreenCaller.openNumpad(this, qsTr("Inflow Minimum"))
                                }//

                                TextApp {
                                    anchors.right: parent.right
                                    anchors.rightMargin: 5
                                    verticalAlignment: Text.AlignVCenter
                                    height: parent.height
                                    text: props.meaUnitStr
                                    color: "gray"
                                }//
                            }//
                        }//

                        Column {
                            spacing: 5

                            TextApp {
                                text: qsTr("IF Nominal")
                            }//

                            TextFieldApp {
                                id: velIfaNomTextField
                                width: 100
                                height: 40

                                onPressed: {
                                    KeyboardOnScreenCaller.openNumpad(this, qsTr("Inflow Nominal"))
                                }//

                                TextApp {
                                    anchors.right: parent.right
                                    anchors.rightMargin: 5
                                    verticalAlignment: Text.AlignVCenter
                                    height: parent.height
                                    text: props.meaUnitStr
                                    color: "gray"
                                }//
                            }//
                        }//

                        Column {
                            spacing: 5

                            TextApp {
                                text: qsTr("DF Nominal")
                            }//

                            TextFieldApp {
                                id: velDfaNomTextField
                                width: 100
                                height: 40

                                onPressed: {
                                    KeyboardOnScreenCaller.openNumpad(this, qsTr("Downflow Nominal"))
                                }//

                                TextApp {
                                    anchors.right: parent.right
                                    anchors.rightMargin: 5
                                    verticalAlignment: Text.AlignVCenter
                                    height: parent.height
                                    text: props.meaUnitStr
                                    color: "gray"
                                }//
                            }//
                        }//
                    }//

                    Column {
                        spacing: 5

                        Column {
                            spacing: 5

                            TextApp {
                                text: qsTr("ADC Temp")
                            }//

                            TextFieldApp {
                                id: calibTempAdcTextField
                                width: 100
                                height: 40

                                onPressed: {
                                    KeyboardOnScreenCaller.openNumpad(this, qsTr("ADC Temperature"))
                                }//
                            }//
                        }//

                        Column {
                            spacing: 5

                            TextApp {
                                text: qsTr("Calib Temp")
                            }//

                            TextFieldApp {
                                id: calibTempTextField
                                width: 100
                                height: 40

                                onPressed: {
                                    KeyboardOnScreenCaller.openNumpad(this, qsTr("Calib Temperature"))
                                }//

                                TextApp {
                                    anchors.right: parent.right
                                    anchors.rightMargin: 5
                                    verticalAlignment: Text.AlignVCenter
                                    height: parent.height
                                    text: props.tempUnitStr
                                    color: "gray"
                                }//
                            }//
                        }//
                    }//

                    Column {
                        spacing: 5

                        Column {
                            spacing: 5

                            TextApp {
                                text: qsTr("Fan Nominal")
                            }//

                            Row{
                                spacing: 5
                                TextFieldApp {
                                    id: fanNominalTextField
                                    width: 100
                                    height: 40

                                    onPressed: {
                                        KeyboardOnScreenCaller.openNumpad(this, qsTr("Fan Duty Cycle Nominal"))
                                    }//

                                    TextApp {
                                        anchors.right: parent.right
                                        anchors.rightMargin: 5
                                        verticalAlignment: Text.AlignVCenter
                                        height: parent.height
                                        text: "%"
                                        color: "gray"
                                    }//
                                }//
                                TextFieldApp {
                                    id: fanNomRpmTextField
                                    width: 100
                                    height: 40

                                    onPressed: {
                                        KeyboardOnScreenCaller.openNumpad(this, qsTr("Fan RPM Nominal"))
                                    }//

                                    TextApp {
                                        anchors.right: parent.right
                                        anchors.rightMargin: 5
                                        verticalAlignment: Text.AlignVCenter
                                        height: parent.height
                                        text: "RPM"
                                        color: "gray"
                                    }//
                                }//
                            }
                        }//
                        Column {
                            spacing: 5

                            TextApp {
                                text: qsTr("Fan Minimum")
                            }//

                            Row{
                                spacing: 5
                                TextFieldApp {
                                    id: fanMinimumTextField
                                    width: 100
                                    height: 40

                                    onPressed: {
                                        KeyboardOnScreenCaller.openNumpad(this, qsTr("Fan Duty Cycle Minimum"))
                                    }//

                                    TextApp {
                                        anchors.right: parent.right
                                        anchors.rightMargin: 5
                                        verticalAlignment: Text.AlignVCenter
                                        height: parent.height
                                        text: "%"
                                        color: "gray"
                                    }//
                                }//
                                TextFieldApp {
                                    id: fanMinRpmTextField
                                    width: 100
                                    height: 40

                                    onPressed: {
                                        KeyboardOnScreenCaller.openNumpad(this, qsTr("Fan RPM Minimum"))
                                    }//

                                    TextApp {
                                        anchors.right: parent.right
                                        anchors.rightMargin: 5
                                        verticalAlignment: Text.AlignVCenter
                                        height: parent.height
                                        text: "RPM"
                                        color: "gray"
                                    }//
                                }//
                            }//
                        }//
                        Column {
                            spacing: 5

                            TextApp {
                                text: qsTr("Fan Standby")
                            }//

                            Row{
                                spacing: 5
                                TextFieldApp {
                                    id: fanStandbyTextField
                                    width: 100
                                    height: 40

                                    onPressed: {
                                        KeyboardOnScreenCaller.openNumpad(this, qsTr("Fan Duty Cycle Standby"))
                                    }//

                                    TextApp {
                                        anchors.right: parent.right
                                        anchors.rightMargin: 5
                                        verticalAlignment: Text.AlignVCenter
                                        height: parent.height
                                        text: "%"
                                        color: "gray"
                                    }//
                                }//
                                TextFieldApp {
                                    id: fanStbRpmTextField
                                    width: 100
                                    height: 40

                                    onPressed: {
                                        KeyboardOnScreenCaller.openNumpad(this, qsTr("Fan RPM Standby"))
                                    }//

                                    TextApp {
                                        anchors.right: parent.right
                                        anchors.rightMargin: 5
                                        verticalAlignment: Text.AlignVCenter
                                        height: parent.height
                                        text: "RPM"
                                        color: "gray"
                                    }//
                                }//
                            }//
                        }//
                    }//
                }//

                //                RowLayout {
                //                    anchors.fill: parent

                //                    Item {
                //                        Layout.fillHeight: true
                //                        Layout.fillWidth: true
                //                    }//

                //                    Item {
                //                        Layout.fillHeight: true
                //                        Layout.fillWidth: true
                //                    }//
                //                }//
            }//

            /// FOOTER
            Item {
                id: footerItem
                Layout.fillWidth: true
                Layout.minimumHeight: 70

                Rectangle {
                    anchors.fill: parent
                    color: "#0F2952"
                    //                    border.color: "#e3dac9"
                    //                    border.width: 1
                    radius: 5

                    Item {
                        anchors.fill: parent
                        anchors.margins: 5

                        ButtonBarApp {
                            width: 194
                            anchors.verticalCenter: parent.verticalCenter

                            imageSource: "qrc:/UI/Pictures/back-step.png"
                            text: qsTr("Back")

                            onClicked: {
                                props.confirmBackToClose()
                            }//
                        }//

                        ButtonBarApp {
                            visible: props.dataHaveChanged
                            width: 194
                            anchors.verticalCenter: parent.verticalCenter
                            anchors.right: parent.right

                            imageSource: "qrc:/UI/Pictures/checkicon.png"
                            text: qsTr("Save")

                            onClicked: {
                                //                                showBusyPage(qsTr("Setting up..."),
                                //                                             function onCallback(cycle){
                                //                                                 if (cycle >= MachineAPI.BUSY_CYCLE_1){
                                //                                                     let intent = IntentApp.create("qrc:/UI/Pages/ManualInputDataPage/FinishManualInputDataPage.qml", {})
                                //                                                     finishView(intent)
                                //                                                 }
                                //                                             })

                                let constant      = Number(sensorConstantTextField.text)

                                //let adcIfaZero   = Number(adcIfaZeroTextField.text)
                                let adcIfaMin    = Number(adcIfaMinTextField.text)
                                let adcIfaNom    = Number(adcIfaNomTextField.text)

                                if (!/*(*//*(adcIfaZero < adcIfaMin)
                                      && (adcIfaZero < adcIfaNom)*/
                                        /* && */(adcIfaMin < adcIfaNom)/*)*/){
                                    showDialogMessage(qsTr("Attention!"),
                                                      qsTr("ADC value is invalid!"),
                                                      dialogAlert)
                                    return
                                }

                                let velIfaAlarm  = Number(velIfaAlarmTextField.text) * 100
                                let velIfaMin    = Number(velIfaMinTextField.text) * 100
                                let velIfaNom    = Number(velIfaNomTextField.text) * 100
                                let velDfaNom    = Number(velDfaNomTextField.text) * 100

                                if (!((velIfaMin < velIfaNom)
                                      && (velDfaNom < velIfaNom))){
                                    showDialogMessage(qsTr("Attention!"),
                                                      qsTr("Velocity value is invalid!"),
                                                      dialogAlert)
                                    return
                                }

                                let calibTempAdc = Number(calibTempAdcTextField.text)
                                let calibTemp    = Number(calibTempTextField.text)

                                let fanNominal = Number(fanNominalTextField.text)
                                let fanMinimum = Number(fanMinimumTextField.text)
                                let fanStandby = Number(fanStandbyTextField.text)

                                let fanNominalRpm = Number(fanNomRpmTextField.text)
                                let fanMinimumRpm = Number(fanMinRpmTextField.text)
                                let fanStandbyRpm = Number(fanStbRpmTextField.text)

                                if (fanStandby >= fanNominal || fanMinimum >= fanNominal) {
                                    showDialogMessage(qsTr("Attention!"),
                                                      qsTr("Fan duty cycle value is invalid!"),
                                                      dialogAlert)
                                    return
                                }

                                //console.debug("constant: "       + constant)
                                //                                //console.debug("adcIfaZero: "    + adcIfaZero)
                                //console.debug("adcIfaMin: "     + adcIfaMin)
                                //console.debug("adcIfaNom: "     + adcIfaNom)
                                //console.debug("velIfaAlarm: "   + velIfaAlarm)
                                //console.debug("velIfaMin: "     + velIfaMin)
                                //console.debug("velIfaNom: "     + velIfaNom)
                                //console.debug("velDfaNom: "     + velDfaNom)
                                //console.debug("calibTempAdc: "  + calibTempAdc)
                                //console.debug("calibTemp: "     + calibTemp)
                                //console.debug("fanNominal: "    + fanNominal)
                                //console.debug("fanMinimum: "    + fanMinimum)
                                //console.debug("fanStandby: "    + fanStandby)

                                /// clear field calibration
                                MachineAPI.setInflowAdcPointField(0, 0, 0)
                                MachineAPI.setInflowVelocityPointField(0, 0, 0)

                                /// set factory/full calibration
                                MachineAPI.setInflowSensorConstant(constant)
                                MachineAPI.setInflowAdcPointFactory(0, adcIfaMin, adcIfaNom)
                                MachineAPI.setInflowVelocityPointFactory(0, velIfaMin, velIfaNom)
                                MachineAPI.setDownflowVelocityPointFactory(0, 0, velDfaNom)
                                MachineAPI.setInflowLowLimitVelocity(velIfaAlarm)
                                MachineAPI.setInflowTemperatureCalib(calibTemp, calibTempAdc)

                                MachineAPI.setFanPrimaryNominalDutyCycleFactory(fanNominal);
                                MachineAPI.setFanPrimaryMinimumDutyCycleFactory(fanMinimum);
                                MachineAPI.setFanPrimaryStandbyDutyCycleFactory(fanStandby);

                                MachineAPI.setFanPrimaryNominalRpmFactory(fanNominalRpm);
                                MachineAPI.setFanPrimaryMinimumRpmFactory(fanMinimumRpm);
                                MachineAPI.setFanPrimaryStandbyRpmFactory(fanStandbyRpm);

                                MachineAPI.initAirflowCalibrationStatus(MachineAPI.AF_CALIB_FACTORY);

                                ///EVENT LOG
                                const message = qsTr("User: Manual input")
                                              + " ("
                                              + "Const: " + constant + ", "
                                              + "ADC-IF1: " + adcIfaMin + ", "
                                              + "ADC-IF2: " + adcIfaNom + ", "
                                              + "VEL-IF1: " + (velIfaMin / 100).toFixed(2) + ", "
                                              + "VEL-IF2: " + (velIfaNom / 100).toFixed(2) + ", "
                                              + "VEL-DF2: " + (velDfaNom / 100).toFixed(2) + ", "
                                              + "VEL-IFFail: " + (velIfaAlarm / 100).toFixed(2) + ", "
                                              + "FAN-IF1: %1% | %2RPM".arg(fanNominal).arg(fanNominalRpm) + ", "
                                              + "FAN_IF2: %1% | %2RPM".arg(fanMinimum).arg(fanMinimumRpm) + ", "
                                              + "FAN_IFS: %1% | %2RPM".arg(fanStandby).arg(fanStandbyRpm) + ", "
                                              + "TEMP: %1°C | %2".arg(calibTemp).arg(calibTempAdc)
                                              + ")"
                                MachineAPI.insertEventLog(message);


                                let intent = IntentApp.create("qrc:/UI/Pages/ManualInputDataPage/FinishManualInputDataPage.qml", {})
                                finishView(intent)
                            }//
                        }//
                    }//
                }//
            }//
        }//

        //// Put all private property inside here
        //// if none, please comment this block to optimize the code
        QtObject {
            id: props

            property var dataArray: []
            property bool dataHaveChanged: false

            property string meaUnitStr: "m/s"
            property string tempUnitStr: "°C"

            function confirmBackToClose(uriTarget){
                const message = qsTr("Exit from manual input data?")
                showDialogAsk(qsTr(title),
                              message,
                              dialogAlert,
                              function onAccepted(){
                                  MachineAPI.setOperationPreviousMode()

                                  //                                  showBusyPage(qsTr("Please wait..."),
                                  //                                               function onCallback(cycle){
                                  //                                                   if(cycle >= MachineAPI.BUSY_CYCLE_1) {
                                  let intent = IntentApp.create(uri, {})
                                  finishView(intent)
                                  //                                                   }
                                  //                                               })
                              })
            }//
            function calculateDataArray(){
                const arr = [sensorConstantTextField.text,
                             adcIfaMinTextField.text,
                             adcIfaNomTextField.text,
                             velIfaMinTextField.text,
                             velIfaAlarmTextField.text,
                             velIfaNomTextField.text,
                             velDfaNomTextField.text,
                             calibTempAdcTextField.text,
                             calibTempTextField.text,
                             fanNominalTextField.text,
                             fanMinimumTextField.text,
                             fanStandbyTextField.text,
                             fanNomRpmTextField.text,
                             fanMinRpmTextField.text,
                             fanStbRpmTextField.text]
                //console.debug(checkSum)
                return arr
            }//
        }//

        /// called Once but after onResume
        Component.onCompleted: {
            /// override gesture swipe action
            /// basicly dont allow gesture shortcut to home page during calibration
            viewApp.fnSwipedFromLeftEdge = function(){
                props.confirmBackToClose(uri)
            }

            viewApp.fnSwipedFromBottomEdge = function(){
                props.confirmBackToClose("")
            }
        }//

        /// Execute This Every This Screen Active/Visible
        executeOnPageVisible:  QtObject {

            /// onResume
            Component.onCompleted: {
                //                    ////console.debug("StackView.Active");

                sensorConstantTextField.text = MachineData.getInflowSensorConstant()

                //                adcIfaZeroTextField.text     = MachineData.getInflowAdcPointFactory(0)
                adcIfaMinTextField.text      = MachineData.getInflowAdcPointFactory(1)
                adcIfaNomTextField.text      = MachineData.getInflowAdcPointFactory(2)

                let fixedPoint = 2
                const measureIsImperial = MachineData.measurementUnit
                if(measureIsImperial) {
                    fixedPoint = 0
                    props.meaUnitStr = "fpm"
                    props.tempUnitStr = "°F"
                }

                velIfaMinTextField.text   = (MachineData.getInflowVelocityPointFactory(1) / 100).toFixed(fixedPoint)
                velIfaAlarmTextField.text = (MachineData.getInflowLowLimitVelocity() / 100).toFixed(fixedPoint)
                velIfaNomTextField.text   = (MachineData.getInflowVelocityPointFactory(2) / 100).toFixed(fixedPoint)
                velDfaNomTextField.text   = (MachineData.getDownflowVelocityPointFactory(2) / 100).toFixed(fixedPoint)

                calibTempAdcTextField.text = MachineData.getInflowTempCalibAdc()
                calibTempTextField.text = MachineData.getInflowTempCalib()

                fanNominalTextField.text = MachineData.getFanPrimaryNominalDutyCycleFactory()
                fanMinimumTextField.text = MachineData.getFanPrimaryMinimumDutyCycleFactory()
                fanStandbyTextField.text = MachineData.getFanPrimaryStandbyDutyCycleFactory()


                fanNomRpmTextField.text = MachineData.getFanPrimaryNominalRpmFactory()
                fanMinRpmTextField.text = MachineData.getFanPrimaryMinimumRpmFactory()
                fanStbRpmTextField.text = MachineData.getFanPrimaryStandbyRpmFactory()

                props.dataArray = props.calculateDataArray()
                props.dataHaveChanged = Qt.binding(function(){return JSON.stringify(props.dataArray) != JSON.stringify(props.calculateDataArray())})
            }//

            /// onPause
            Component.onDestruction: {
                //////console.debug("StackView.DeActivating");
            }//
        }//
    }//
}//

/*##^##
Designer {
    D{i:0;autoSize:true;formeditorColor:"#808080";height:480;width:800}
}
##^##*/
