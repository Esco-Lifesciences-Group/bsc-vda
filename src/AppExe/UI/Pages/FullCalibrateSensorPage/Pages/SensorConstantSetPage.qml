import QtQuick 2.12
import QtQuick.Layouts 1.0
import QtQuick.Controls 2.0

import UI.CusCom 1.1
import "../../../CusCom/JS/IntentApp.js" as IntentApp

import ModulesCpp.Machine 1.0

ViewApp {
    id: viewApp
    title: "Sensor Constant"

    background.sourceComponent: Item {}

    content.asynchronous: true
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
                    id: headerApp
                    anchors.fill: parent
                    title: qsTr("Sensor Constant")
                }

            }

            /// BODY
            BodyItemApp {
                id: bodyItem
                Layout.fillWidth: true
                Layout.fillHeight: true

                Column{
                    id: parameterColumn
                    anchors.centerIn: parent
                    spacing: 20

                    TextApp{
                        anchors.horizontalCenter: parent.horizontalCenter
                        text: qsTr("Current value") + ":"
                    }
                    TextFieldApp{
                        id: currentTextApp
                        text: props.sensorConstant
                        font.pixelSize: 52
                        height: 70
                        width: 150
                        horizontalAlignment: Text.AlignHCenter
                    }
                    // TextApp{
                    //     font.pixelSize: 18
                    //     text: "(" + qsTr("Tap to change") + ")"
                    //     color: "#aaaaaa"
                    // }//

                    // TextApp{
                    //     id: currentTextApp
                    //     font.pixelSize: 52
                    //     text: props.sensorConstant
                    // }

                }//

                TextInput {
                    id: bufferTextInput
                    visible: false
                    text: currentTextApp.text
                    validator: IntValidator{bottom: 0; top: 59;}

                    onAccepted: {
                        const newConstant = Number(text);

                        if((newConstant < 41 || newConstant > 59) && newConstant !== 0){
                            text = props.sensorConstant
                            currentTextApp.text = props.sensorConstant

                            showDialogMessage(qsTr("Sensor Constant"),
                                              qsTr("Sensor constant is invalid!"),
                                              dialogAlert)

                            return
                        }

                        props.sensorConstant = newConstant
                        currentTextApp.text = newConstant
                        //setButton.visible = true
                    }
                }//

                MouseArea{
                    anchors.fill: parameterColumn
                    onClicked: {
                        KeyboardOnScreenCaller.openNumpad(bufferTextInput, qsTr("Sensor Constant"))
                    }//
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
                            id: backButton
                            width: 194
                            anchors.verticalCenter: parent.verticalCenter

                            imageSource: "qrc:/UI/Pictures/back-step.png"
                            text: qsTr("Back")

                            onClicked: {
                                if (props.sensorContantHasSet) {
                                    let intent = IntentApp.create(uri, {"pid": props.pid, "sensorConstant": props.sensorConstant })
                                    finishView(intent);
                                } else {
                                    var intent = IntentApp.create(uri, {})
                                    finishView(intent)
                                }
                            }
                        }//

                        ButtonBarApp {
                            id: setButton
                            width: 194
                            anchors.verticalCenter: parent.verticalCenter
                            anchors.right: parent.right
                            visible: (props.sensorConstant !== MachineData.inflowSensorConstant)
                                     || (props.fieldCalibration && !MachineData.getAirflowFieldCalibrationState(MachineAPI.CalFieldState_SensorConstant))
                                     || (!props.fieldCalibration && !MachineData.getAirflowFactoryCalibrationState(MachineAPI.CalFactoryState_SensorConstant))

                            imageSource: "qrc:/UI/Pictures/checkicon.png"
                            text: qsTr("Set")

                            onClicked: {
                                // Set to machine as a temporary sensor contant
                                // this required for update sesnor constant on AirflowSensor object
                                // So, AirflowSensor object can provide ADC value with current sensor constant in real-time
                                // this is not permanent, this value withh revert to original sensor constant
                                // if user not pressing the save button on _NavigationCalibratePage
                                MachineAPI.setInflowSensorConstantTemporary(props.sensorConstant);
                                MachineAPI.setInflowSensorConstant(props.sensorConstant);

                                props.sensorContantHasSet = true;

                                MachineAPI.insertEventLog(qsTr("User: Sensor constant is set to %1").arg(props.sensorConstant))
                                //                                /// give some time space to ensure the value has updated to AirflowSensor Object
                                //                                viewApp.showBusyPage(qsTr("Setting up..."),
                                //                                                     function onTriggered(cycle){
                                //                                                         if(cycle >= MachineAPI.BUSY_CYCLE_1
                                //                                                                 || MachineData.inflowSensorConstant === props.sensorConstant){
                                props.showDialogInfo()
                                //closeDialog()
                                //                                                         }//
                                //                                                     })//
                            }//
                        }//
                    }//
                }//
            }//
        }//

        /// called Once but after onResume
        Component.onCompleted: {
            let extradata = IntentApp.getExtraData(intent)
            //                    ////console.debug(JSON.stringify(extradata))
            if (extradata['pid'] !== undefined) {

                props.pid = extradata['pid']

                props.sensorConstant = extradata['sensorConstant'] || 0
                props.fieldCalibration = extradata['fieldCalib'] || false
            }
        }//

        QtObject {
            id: props

            property string pid: ""

            property int sensorConstant: 0
            property bool fieldCalibration: false

            property bool sensorContantHasSet: false

            function showDialogInfo(){
                viewApp.showDialogMessage(qsTr("Sensor Constant"),
                                          qsTr("Sensor constant value has been changed to ") + props.sensorConstant,
                                          dialogInfo,
                                          function onClosed(){
                                              //setButton.visible = false;
                                              let intent = IntentApp.create(uri, {"pid": props.pid,
                                                                                "sensorConstant": props.sensorConstant })
                                              finishView(intent);
                                          })
            }
        }//

        /// Execute This Every This Screen Active/Visible
        executeOnPageVisible: QtObject {

            /// onResume
            Component.onCompleted: {
                //                    ////console.debug("StackView.Active");
            }

            /// onPause
            Component.onDestruction: {
                //////console.debug("StackView.DeActivating");
            }//
        }//
    }//

    Component.onDestruction: {
        //        ////console.debug("onDestruction")
    }
}//

/*##^##
Designer {
    D{i:0;autoSize:true;height:480;width:800}
}
##^##*/
