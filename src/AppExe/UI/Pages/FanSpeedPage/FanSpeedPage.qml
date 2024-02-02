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
    title: "Fan Speed"

    background.sourceComponent: Item {}

    content.sourceComponent: ContentItemApp {
        id: contentView
        height: viewApp.height
        width: viewApp.width

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
                    title: qsTr("Fan Speed")
                }
            }

            /// BODY
            Item {
                id: bodyItem
                Layout.fillWidth: true
                Layout.fillHeight: true

                Rectangle{
                    width: MachineData.measurementUnit ? 595 : 585
                    height: 60
                    color: "#0F2952"
                    radius: 5
                    TextApp{
                        anchors.fill: parent
                        verticalAlignment: Text.AlignVCenter
                        horizontalAlignment: Text.AlignLeft
                        leftPadding: 10
                        text:  qsTr("Nominal Duty Cycle Configuration: %1%").arg(props.fanDutyCycleNominal) + "<br>" +
                               qsTr("to get nominal inflow (%1) and nominal downflow (%2)").arg(props.sensorVelNominalStrf).arg(props.sensorVelNominalDfaStrf)
                    }
                }

                Column {
                    anchors.centerIn: parent
                    spacing: 20

                    //                    Column {
                    //                        spacing: 10
                    //                        TextApp {
                    //                            anchors.horizontalCenter: parent.horizontalCenter
                    //                            text: qsTr("Inflow Fan")
                    //                        }
                    //                        Row{
                    //                            spacing: 20
                    //                            TextFieldApp {
                    //                                id: ifaDcyTextField
                    //                                width: 70
                    //                                height: 50
                    //                                validator: IntValidator{bottom: 0; top: 100;}

                    //                                TextApp {
                    //                                    anchors.right: parent.right
                    //                                    anchors.rightMargin: 5
                    //                                    verticalAlignment: Text.AlignVCenter
                    //                                    height: parent.height
                    //                                    text: "%"
                    //                                    color: "gray"
                    //                                }//

                    //                                onPressed: {
                    //                                    KeyboardOnScreenCaller.openNumpad(this, qsTr("Inflow Fan (%)"))
                    //                                }//
                    //                                onAccepted: {
                    //                                    fanInflowSlider.value = Number(text)
                    //                                    MachineAPI.setFanInflowDutyCycle(Number(text))
                    //                                }
                    //                            }//
                    //                            SliderApp {
                    //                                id: fanInflowSlider
                    //                                anchors.verticalCenter: parent.verticalCenter
                    //                                width: 700
                    //                                stepSize: 1
                    //                                from: 0
                    //                                to: 100
                    //                                padding: 0

                    //                                onValueChanged: {
                    //                                    if (pressed) {
                    //                                        MachineAPI.setFanInflowDutyCycle(fanInflowSlider.value)
                    //                                        ifaDcyTextField.text = fanInflowSlider.value
                    //                                    }//
                    //                                }//
                    //                            }//
                    //                        }//
                    //                    }//

                    Column {
                        spacing: 10
                        TextApp {
                            anchors.horizontalCenter: parent.horizontalCenter
                            text: qsTr("RPM : ") + MachineData.fanPrimaryRpm
                        }
                        Row{
                            spacing: 20
                            TextFieldApp {
                                id: dfaDcyTextField
                                width: 70
                                height: 50
                                validator: IntValidator{bottom: 0; top: MachineData.fanSpeedMaxLimit;}

                                TextApp {
                                    anchors.right: parent.right
                                    anchors.rightMargin: 5
                                    verticalAlignment: Text.AlignVCenter
                                    height: parent.height
                                    text: "%"
                                    color: "gray"
                                }//

                                onPressed: {
                                    KeyboardOnScreenCaller.openNumpad(this, qsTr("Fan Duty Cycle (%)"))
                                }//
                                onAccepted: {
                                    fanDownflowSlider.value = Number(text)
                                    MachineAPI.setFanPrimaryDutyCycle(Number(text))
                                }
                            }//
                            SliderApp {
                                id: fanDownflowSlider
                                anchors.verticalCenter: parent.verticalCenter
                                width: 700
                                stepSize: 1
                                from: 0
                                to: MachineData.fanSpeedMaxLimit
                                padding: 0

                                onValueChanged: {
                                    if (pressed) {
                                        MachineAPI.setFanPrimaryDutyCycle(fanDownflowSlider.value)
                                        dfaDcyTextField.text = fanDownflowSlider.value
                                    }//
                                }//
                            }//
                        }//
                    }//
                    CheckBoxApp{
                        checked: MachineData.fanSpeedFullEnable
                        text: qsTr("Full Speed")

                        onCheckedChanged: {
                            MachineAPI.setFanSpeedFullEnable(checked);
                            if(!checked){
                                //console.debug(dfaDcyTextField.text, fanDownflowSlider.value, MachineData.fanSpeedMaxLimit)
                                if(fanDownflowSlider.value >= MachineData.fanSpeedMaxLimitSaved){
                                    fanDownflowSlider.value = MachineData.fanSpeedMaxLimitSaved
                                    dfaDcyTextField.text = fanDownflowSlider.value
                                    MachineAPI.setFanPrimaryDutyCycle(fanDownflowSlider.value)
                                }
                            }
                        }
                    }
                }//

                TextApp{
                    anchors.bottom: parent.bottom
                    anchors.horizontalCenter: parent.horizontalCenter
                    horizontalAlignment: Text.AlignHCenter
                    width: 500
                    color: "#cccccc"
                    font.pixelSize: 16
                    text:  qsTr("This feature is used to set the duty cycle of the internal fan for testing/certification purposes, ") + "<br>" +
                           qsTr("If you choose to change and set the nominal duty cycle from this menu, tap <b>'%1'</b> button,").arg(setButton.text) + "<br>" +
                           qsTr("It is recommended to redo the ADC calibration process if the airflow reading is outside of the required range.")
                }//
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

                            imageSource: "/UI/Pictures/back-step.png"
                            text: qsTr("Back")

                            onClicked: {
                                if((props.fanDutyCycleNominal === fanDownflowSlider.value) || (fanDownflowSlider.value === 0)){
                                    props.outFromPage()
                                }
                                else{
                                    let autoClose = false
                                    const message = qsTr("The Current fan speed will not be saved as nominal duty cycle configuration.") + "<br>" +
                                                  qsTr("Are you sure you want to go back?")
                                    showDialogAsk(qsTr("Attention!"), message, dialogAlert, function onAccepted(){
                                        //                                        showBusyPage(qsTr("Loading..."),
                                        //                                                     function onCycle(cycle){
                                        //                                                         if (cycle >= MachineAPI.BUSY_CYCLE_1){
                                        viewApp.closeDialog()
                                        props.outFromPage()
                                        //                                                         }
                                        //                                                     })//
                                    }, function(){}, function(){}, autoClose)
                                }//
                            }//
                        }//

                        ButtonBarApp {
                            id: setButton
                            width: 210
                            anchors.verticalCenter: parent.verticalCenter
                            anchors.right: parent.right
                            visible:  fanDownflowSlider.value !== 0

                            imageSource: "qrc:/UI/Pictures/checkicon.png"
                            text: qsTr("Set as Nominal Duty Cycle")

                            onClicked: {
                                let val = Number(fanDownflowSlider.value)
                                if(isNaN(val)) return

                                if(val > 60){
                                    // Show Warning if more than 60% of ducy
                                    showDialogAsk(qsTr("Warning"),
                                                  qsTr("The nominal fan speed seems too high!"),
                                                  dialogAlert,
                                                  function onAccepted(){
                                                      props.confirmToSet()
                                                  },
                                                  function onRejected(){
                                                      fanDownflowSlider.value = MachineData.fanPrimaryDutyCycle
                                                  },
                                                  function onCLosed(){
                                                      fanDownflowSlider.value = MachineData.fanPrimaryDutyCycle
                                                  },
                                                  true,
                                                  5,
                                                  qsTr("It's Okay"),//accept
                                                  qsTr("Cancel"))//Reject
                                }//
                                else{
                                    props.confirmToSet()
                                }
                            }//
                        }//
                    }//
                }//
            }//
        }//

        QtObject{
            id: props
            property int fanDutyCycleNominal: 0 /*+ 15*/
            property int fanDutyCycleMinimum: 0 /*+ 15*/

            property int fanRpmNominal: 0
            property int fanRpmMinimum: 0

            property int sensorVelNominal: 0 /*+ 53*/
            property int sensorVelNominalDfa: 0 /*+ 33*/

            property string sensorVelNominalStrf: "" /*+ 53*/
            property string sensorVelNominalDfaStrf: "" /*+ 33*/
            property string meaUnitStrf: MachineData.measurementUnit ? "fpm" : "m/s"

            property int decimalPoint: MachineData.measurementUnit ? 0 : 2

            function outFromPage(){
                var intent = IntentApp.create(uri, {"message":""})
                finishView(intent)
            }//

            function saveNominalDone(){
                const ducy = fanDownflowSlider.value
                MachineAPI.insertEventLog(qsTr("User: Set Fan Speed (%1%) as Nominal duty cycle setpoint").arg(ducy))
                showDialogMessage(qsTr("Fan Speed"),
                                  qsTr("Nominal fan speed has been changed to %1% ").arg(ducy),
                                  dialogInfo,
                                  function onAccepted(){
                                      viewApp.closeDialog()
                                     // props.outFromPage()
                                  }, false)
            }//

            function confirmToSet(){
                if(fanDownflowSlider.value > props.fanDutyCycleMinimum){
                    let autoClose = false
                    showDialogAsk(qsTr("Attention!"),
                                  qsTr("Are you sure you want to set %1% as nominal fan speed configuration?").arg(fanDownflowSlider.value),
                                  dialogAlert,
                                  function onAccepted(){
                                      let settings = 0x0000

                                      const fanPrimaryRpm = MachineData.fanPrimaryRpm
                                      const calibStatusField = MachineData.airflowCalibrationStatus === MachineAPI.AF_CALIB_FIELD
                                      const calibStatusFactory = MachineData.airflowCalibrationStatus === MachineAPI.AF_CALIB_FACTORY
                                      const calibStatusNone = MachineData.airflowCalibrationStatus === MachineAPI.AF_CALIB_NONE

                                      //If Fan Nominal Value is different than current state, reset all airflow balance factory state (only state, not the value inside)
                                      if(fanDownflowSlider.value !== MachineData.getFanPrimaryNominalDutyCycle()){
                                          if(calibStatusField){
                                              MachineAPI.setAirflowFieldCalibrationState(MachineAPI.CalFieldState_InflowDimNominal, false) //if nom
                                              MachineAPI.setAirflowFieldCalibrationState(MachineAPI.CalFieldState_InflowDimMinimum, false) //if fail
                                              MachineAPI.setAirflowFieldCalibrationState(MachineAPI.CalFieldState_InflowDimStandby, false) //if stb
                                              MachineAPI.setAirflowFieldCalibrationState(MachineAPI.CalFieldState_InflowSecNominal, false) //if nom
                                              MachineAPI.setAirflowFieldCalibrationState(MachineAPI.CalFieldState_InflowSecMinimum, false) //if fail
                                              MachineAPI.setAirflowFieldCalibrationState(MachineAPI.CalFieldState_InflowSecStandby, false) //if stb
                                              MachineAPI.setAirflowFieldCalibrationState(MachineAPI.CalFieldState_DownflowNominal, false) //df nom
                                          }//
                                          else{
                                              MachineAPI.setAirflowFactoryCalibrationState(MachineAPI.CalFactoryState_InflowDimNominal, false) //if nom
                                              MachineAPI.setAirflowFactoryCalibrationState(MachineAPI.CalFactoryState_InflowDimMinimum, false) //if fail
                                              MachineAPI.setAirflowFactoryCalibrationState(MachineAPI.CalFactoryState_InflowDimStandby, false) //if stb
                                              MachineAPI.setAirflowFactoryCalibrationState(MachineAPI.CalFactoryState_DownflowNominal, false) //df nom
                                          }
                                          settings |= 0x0001
                                      }//

                                      if(calibStatusNone){
                                          MachineAPI.setFanPrimaryNominalDutyCycleFactory(fanDownflowSlider.value)
                                          MachineAPI.setFanPrimaryNominalRpmFactory(fanPrimaryRpm)

                                          MachineAPI.initFanConfigurationStatus(MachineAPI.AF_CALIB_FACTORY)

                                          settings |= 0x0002
                                      }//
                                      else if(calibStatusFactory){
                                          MachineAPI.setFanPrimaryNominalDutyCycleFactory(fanDownflowSlider.value)
                                          MachineAPI.setFanPrimaryNominalRpmFactory(fanPrimaryRpm)

                                          MachineAPI.initAirflowCalibrationStatus(MachineAPI.AF_CALIB_FACTORY)

                                          settings |= 0x0004
                                      }//
                                      else{
                                          MachineAPI.setFanPrimaryNominalDutyCycleField(fanDownflowSlider.value)
                                          MachineAPI.setFanPrimaryNominalRpmField(fanPrimaryRpm)

                                          MachineAPI.initAirflowCalibrationStatus(MachineAPI.AF_CALIB_FIELD)

                                          settings |= 0x0008
                                      }//

                                      props.fanDutyCycleNominal = fanDownflowSlider.value//MachineData.getFanPrimaryNominalDutyCycle()

                                      showBusyPage(qsTr("Setting up..."),
                                                   function onCycle(cycle){
                                                       let valueSet = true

                                                       if(settings & 0x0001){
                                                           valueSet &= ((MachineData.getAirflowFactoryCalibrationState(MachineAPI.CalFactoryState_InflowDimNominal) === false)
                                                                        && (MachineData.getAirflowFactoryCalibrationState(MachineAPI.CalFactoryState_InflowDimMinimum) === false)
                                                                        && (MachineData.getAirflowFactoryCalibrationState(MachineAPI.CalFactoryState_InflowDimStandby) === false)
                                                                        && (MachineData.getAirflowFactoryCalibrationState(MachineAPI.CalFactoryState_DownflowNominal) === false))
                                                       }
                                                       if((settings & 0x0002) || (settings & 0x0004)){
                                                           valueSet &= ((MachineData.getFanPrimaryNominalDutyCycleFactory() === fanDownflowSlider.value)
                                                                        && (MachineData.getFanPrimaryNominalRpmFactory() === fanPrimaryRpm))
                                                       }
                                                       if(settings & 0x0008){
                                                           valueSet &= ((MachineData.getFanPrimaryNominalDutyCycleField() === fanDownflowSlider.value)
                                                                        && (MachineData.getFanPrimaryNominalRpmField() === fanPrimaryRpm))//
                                                       }//

                                                       if (cycle >= MachineAPI.BUSY_CYCLE_1 || valueSet){
                                                           //viewApp.closeDialog()
                                                           props.saveNominalDone()
                                                       }
                                                   })

                                  }, function(){}, function(){}, autoClose);
                }//
                else{
                    var autoClose = false
                    const message = qsTr("The nominal duty cycle must be greater than the minimum duty cycle. If you want to continue to set this value as nominal, go to Full Sensor Calibration.")
                    showDialogMessage(qsTr("Attention"),
                                      message,
                                      dialogAlert,
                                      function(){}, autoClose)
                }//
            }
        }

        /// called Once but after onResume
        Component.onCompleted: {
            if(MachineData.airflowCalibrationStatus === MachineAPI.AF_CALIB_FIELD){
                props.sensorVelNominal    = MachineData.getInflowVelocityPointField(2);
                props.sensorVelNominalDfa = MachineData.getDownflowVelocityPointField(2);
            }
            else{
                props.sensorVelNominal    = MachineData.getInflowVelocityPointFactory(2);
                props.sensorVelNominalDfa = MachineData.getDownflowVelocityPointFactory(2);
            }

            props.sensorVelNominalStrf = ((props.sensorVelNominal/100).toFixed(props.decimalPoint)).toString() + " " + props.meaUnitStrf
            props.sensorVelNominalDfaStrf = ((props.sensorVelNominalDfa/100).toFixed(props.decimalPoint)).toString() + " " + props.meaUnitStrf
        }//
        Component.onDestruction: {
            MachineAPI.setFanSpeedFullEnable(false);
        }//

        /// Execute This Every This Screen Active/Visible
        executeOnPageVisible: QtObject {

            /// onResume
            Component.onCompleted: {
                ////console.debug("StackView.Active");

                fanDownflowSlider.value = MachineData.fanPrimaryDutyCycle
                dfaDcyTextField.text = fanDownflowSlider.value

                props.fanDutyCycleNominal = Qt.binding(function(){return MachineData.getFanPrimaryNominalDutyCycle()})
                props.fanDutyCycleMinimum = Qt.binding(function(){return MachineData.getFanPrimaryMinimumDutyCycle()})

                props.fanRpmNominal = Qt.binding(function(){return MachineData.getFanPrimaryNominalRpm()})
                props.fanRpmMinimum = Qt.binding(function(){return MachineData.getFanPrimaryMinimumRpm()})

                MachineAPI.setFrontEndScreenState(MachineAPI.ScreenState_FanSpeed)
            }//

            /// onPause
            Component.onDestruction: {
                //////console.debug("StackView.DeActivating");
                MachineAPI.setFrontEndScreenState(MachineAPI.ScreenState_Other)
            }
        }//
    }//
}//

/*##^##
Designer {
    D{i:0;autoSize:true;height:480;width:800}
}
##^##*/
