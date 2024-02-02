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
    title: "Reset Field Calibration"

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
                    title: qsTr("Reset Field Calibration")
                }
            }

            /// BODY
            Item {
                id: bodyItem
                Layout.fillWidth: true
                Layout.fillHeight: true
                Rectangle{
                    width: 700
                    height: parent.height
                    anchors.centerIn: parent
                    color: "transparent"
                    TextApp{
                        width: parent.width
                        height: parent.height
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                        padding: 10
                        wrapMode: Text.WordWrap
                        minimumPixelSize: 20
                        text: qsTr("By resetting the Field Calibration, all field calibration data will be lost and the cabinet will use the full calibration data instead.") + "<br><br>" +
                              qsTr("Tap the '%1' button to reset.").arg(resetBtn.text)
                    }
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

                            imageSource: "qrc:/UI/Pictures/back-step.png"
                            text: qsTr("Back")

                            onClicked: {
                                let intent = IntentApp.create(uri, {})
                                finishView(intent)
                            }//
                        }//

                        ButtonBarApp {
                            id: resetBtn
                            width: 194
                            anchors.verticalCenter: parent.verticalCenter
                            anchors.right: parent.right

                            imageSource: "qrc:/UI/Pictures/checkicon.png"
                            text: qsTr("Reset")

                            onClicked: {
                                const message = qsTr("You will reset Field Calibration data, and use Full Calibration data instead.") + "<br>"
                                              + qsTr("Are you sure you want to continue?")
                                var autoClose = false
                                viewApp.showDialogAsk(qsTr("Reset Field Calibration"),
                                                      message,
                                                      viewApp.dialogAlert,
                                                      function onAccepted(){
                                                          props.performReset()
                                                      }, function onRejected(){
                                                          return;
                                                      }, function(){}, autoClose)


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

            property string meaUnitStr: "m/s"
            property string tempUnitStr: "°C"

            function performReset(){

                ///// INFLOW
                /// clear field calibration
                MachineAPI.setInflowAdcPointField       (0, 0, 0)
                MachineAPI.setInflowVelocityPointField  (0, 0, 0)
                ///// DOWNFLOW
                /// clear field calibration
                // MachineAPI.setDownflowAdcPointField     (0, 0, 0)
                MachineAPI.setDownflowVelocityPointField(0, 0, 0)

                /// Reset the Field calibration state
                for(let i=0; i<MachineAPI.CalFieldState_Total; i++)
                    MachineAPI.setAirflowFieldCalibrationState(i, false)

                //Clear the airflow grid
                MachineAPI.resetFieldSensorCalibration()

                MachineAPI.initAirflowCalibrationStatus(MachineAPI.AF_CALIB_FACTORY);


                MachineAPI.insertEventLog(qsTr("User: Reset Field Calibration data"))

                //                showBusyPage(qsTr("Resetting..."),
                //                             function onCallback(seconds){
                //                                 if (seconds >= MachineAPI.BUSY_CYCLE_1){
                showDialogMessage(qsTr("Reset Field Calibration"),
                                  qsTr("Field sensor calibration is reset!"),
                                  dialogInfo,
                                  function onCLosed(){
                                      /// Back to Main Screen
                                      if(MachineData.fanPrimaryState === MachineAPI.FAN_STATE_ON){
                                          MachineAPI.setFanState(MachineAPI.FAN_STATE_ON)
                                      }
                                      else if(MachineData.fanPrimaryState === MachineAPI.FAN_STATE_STANDBY){
                                          MachineAPI.setFanState(MachineAPI.FAN_STATE_STANDBY)
                                      }
                                      const intent = IntentApp.create("", {})
                                      startRootView(intent)
                                  })

                //                                 }
                //                             })//
            }
        }//

        /// called Once but after onResume
        Component.onCompleted: {

        }//

        /// Execute This Every This Screen Active/Visible
        executeOnPageVisible:  QtObject {

            /// onResume
            Component.onCompleted: {
                // ////console.debug("StackView.Active");
                let fixedPoint = 2
                const measureIsImperial = MachineData.measurementUnit
                if(measureIsImperial) {
                    fixedPoint = 0
                    props.meaUnitStr = "fpm"
                    props.tempUnitStr = "°F"
                }
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
