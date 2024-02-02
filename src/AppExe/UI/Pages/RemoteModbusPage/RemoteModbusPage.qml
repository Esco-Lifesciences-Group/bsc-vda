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
    title: "Remote Modbus"

    background.sourceComponent: Item {}//

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
                    anchors.fill: parent
                    title: qsTr("Remote Modbus")
                }//
            }//

            /// BODY
            Item {
                id: bodyItem
                Layout.fillWidth: true
                Layout.fillHeight: true

                RowLayout {
                    anchors.fill: parent

                    Item {
                        id: leftContentItem
                        Layout.fillHeight: true
                        Layout.fillWidth: true

                        Column {
                            spacing: 5
                            anchors.verticalCenter: parent.verticalCenter

                            Row {
                                anchors.horizontalCenter: parent.horizontalCenter
                                spacing: 5

                                Column {
                                    spacing: 5
                                    //                                    anchors.horizontalCenter: parent.horizontalCenter

                                    TextApp {
                                        horizontalAlignment: Text.AlignHCenter
                                        text: qsTr("S-ID")
                                    }//

                                    TextFieldApp {
                                        id: slaveIdTextField
                                        horizontalAlignment: Text.AlignHCenter
                                        text: "1"
                                        placeholderText: "1"
                                        width: 70
                                        validator: IntValidator{bottom: 1; top: 127}

                                        onPressed: {
                                            KeyboardOnScreenCaller.openNumpad(this, qsTr("Slave ID"))
                                        }//

                                        onAccepted: {
                                            let newVal = Number(text)
                                            if (newVal < 1 || newVal > 127) return

                                            MachineAPI.setModbusSlaveID(newVal)
                                            MachineAPI.insertEventLog(qsTr("User: Set Remote Modbus slave ID to %1").arg(newVal))

                                            showBusyPage(qsTr("Setting up..."), function onCallback(cycle){
                                                if(cycle >= MachineAPI.BUSY_CYCLE_1
                                                        || MachineData.modbusSlaveID === newVal) {
                                                    closeDialog();
                                                }
                                            })
                                        }//
                                    }////
                                }//

                                Column {
                                    spacing: 5
                                    //anchors.horizontalCenter: parent.horizontalCenter

                                    TextApp {
                                        horizontalAlignment: Text.AlignHCenter
                                        text: qsTr("IPv4 of Master")
                                    }////

                                    TextFieldApp {
                                        id: allowIpMasterTextField
                                        horizontalAlignment: Text.AlignHCenter
                                        text: "127.0.0.1"
                                        placeholderText: "127.0.0.1"
                                        validator: RegExpValidator {
                                            regExp: /^(?:(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)$/
                                        }

                                        onPressed: {
                                            KeyboardOnScreenCaller.openNumpad(this, qsTr("IPv4 of the Remote Master Device"))
                                        }

                                        onAccepted: {
                                            let regex = /^(?:(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)$/
                                            const newIp = text

                                            if(newIp.match(regex)){
                                                MachineAPI.setModbusAllowingIpMaster(newIp)
                                                MachineAPI.insertEventLog(qsTr("User: Set IPv4 of Master to %1").arg(newIp))

                                                showBusyPage(qsTr("Setting up..."), function onCallback(cycle){
                                                    if(cycle >= MachineAPI.BUSY_CYCLE_1
                                                            || MachineData.modbusAllowIpMaster === newIp) {
                                                        closeDialog();
                                                    }
                                                })
                                            }//
                                            else{
                                                showDialogMessage(qsTr("Remote Modbus"),
                                                                  qsTr("The IPv4 address is invalid!"),
                                                                  dialogAlert)
                                            }//
                                        }//
                                    }////
                                }//

                                Column {
                                    spacing: 5
                                    //                                    anchors.horizontalCenter: parent.horizontalCenter

                                    TextApp {
                                        horizontalAlignment: Text.AlignHCenter
                                        text: qsTr("Port")
                                    }////

                                    TextFieldApp {
                                        id: portTextField
                                        horizontalAlignment: Text.AlignHCenter
                                        text: "5502"
                                        placeholderText: "5502"
                                        width: 80
                                        enabled: false
                                        colorBackground: "gray"
                                        //                                        validator: IntValidator{bottom: 1; top: 127}

                                        //                                        onPressed: {
                                        //                                            KeyboardOnScreenCaller.openNumpad(this, qsTr("Slave ID"))
                                        //                                        }//

                                        //                                        onAccepted: {
                                        //                                            showBusyPage(qsTr("Setting up..."), function onCallback(seconds){
                                        //                                                if(seconds === 3) {
                                        //                                                    closeDialog();
                                        //                                                }
                                        //                                            })

                                        //                                            MachineAPI.setModbusAllowingIpMaster(text)
                                        //                                        }//
                                    }////
                                }//
                            }//

                            Row {
                                spacing: 5

                                TextApp {
                                    id: asterixText
                                    text: "*"
                                }////

                                TextApp {
                                    width: leftContentItem.width - asterixText.width
                                    minimumPixelSize: 20
                                    wrapMode: Text.WordWrap
                                    text: qsTr("The System will accept only the connection from master which has this IPv4 address, otherwise will be rejected.")
                                }////
                            }////

                            Row {
                                spacing: 5

                                TextApp {
                                    text: "*"
                                }////

                                TextApp {
                                    width: leftContentItem.width - asterixText.width
                                    minimumPixelSize: 20
                                    wrapMode: Text.WordWrap
                                    text: qsTr("To accept any masters connection, set the IPv4 to \"0.0.0.0\".")
                                }////
                            }////

                            Row {
                                spacing: 5

                                TextApp {
                                    text: "*"
                                }////

                                TextApp {
                                    width: leftContentItem.width - asterixText.width
                                    minimumPixelSize: 20
                                    wrapMode: Text.WordWrap
                                    text: qsTr("To reject any masters connection, set the IPv4 to \"127.0.0.1\". It's default.")
                                }////
                            }////

                            TextApp {
                                width: leftContentItem.width - asterixText.width
                                minimumPixelSize: 20
                                wrapMode: Text.WordWrap
                                text: qsTr("Status:") + " " + props.recentStatus
                            }////
                        }////
                    }////

                    Item {

                        Layout.fillHeight: true
                        Layout.fillWidth: true

                        Column{
                            spacing: 15
                            anchors.verticalCenter: parent.verticalCenter
                            anchors.horizontalCenter: parent.horizontalCenter

                            TextApp {
                                //anchors.horizontalCenter: parent.horizontalCenter
                                text: qsTr("Allow the Remote Master Device to write the states of:")
                            }////

                            Grid {
                                spacing: 10
                                columns: 2

                                Row {
                                    SwitchApp {
                                        id: fanSwitch

                                        onCheckedChanged: {
                                            if(!initialized) return
                                            MachineAPI.setModbusAllowSetFan(checked);
                                            MachineAPI.insertEventLog(qsTr("User: %1 remote modbus to control %2").arg(checked ? qsTr("Allow") : qsTr("Forbid")).arg(fanSwitchText.text))
                                        }////
                                    }////

                                    TextApp {
                                        id: fanSwitchText
                                        anchors.verticalCenter: parent.verticalCenter
                                        text: qsTr("Fan")
                                    }////
                                }//

                                Row {
                                    SwitchApp {
                                        id: lightSwitch

                                        onCheckedChanged: {
                                            if(!initialized) return
                                            MachineAPI.setModbusAllowSetLight(checked)
                                            MachineAPI.insertEventLog(qsTr("User: %1 remote modbus to control %2").arg(checked ? qsTr("Allow") : qsTr("Forbid")).arg(lightSwitchText.text))
                                        }//
                                    }//

                                    TextApp {
                                        id: lightSwitchText
                                        anchors.verticalCenter: parent.verticalCenter
                                        text: qsTr("Light")
                                    }//
                                }//

                                Row {
                                    SwitchApp {
                                        id: lightIntensitySwitch

                                        onCheckedChanged: {
                                            if(!initialized) return
                                            MachineAPI.setModbusAllowSetLightIntensity(checked)
                                            MachineAPI.insertEventLog(qsTr("User: %1 remote modbus to control %2").arg(checked ? qsTr("Allow") : qsTr("Forbid")).arg(lightIntensitySwitchtext.text))
                                        }//
                                    }//

                                    TextApp {
                                        id: lightIntensitySwitchtext
                                        anchors.verticalCenter: parent.verticalCenter
                                        text: qsTr("Light Intensity")
                                    }//
                                }//

                                Row {
                                    visible: MachineData.socketInstalled
                                    SwitchApp {
                                        id: socketSwitch

                                        onCheckedChanged: {
                                            if(!initialized) return
                                            MachineAPI.setModbusAllowSetSocket(checked)
                                            MachineAPI.insertEventLog(qsTr("User: %1 remote modbus to control %2").arg(checked ? qsTr("Allow") : qsTr("Forbid")).arg(socketSwitchText.text))
                                        }//
                                    }//

                                    TextApp {
                                        id: socketSwitchText
                                        anchors.verticalCenter: parent.verticalCenter
                                        text: qsTr("Outlet")
                                    }//
                                }//

                                Row {
                                    visible: MachineData.gasInstalled
                                    SwitchApp {
                                        id: gasSwitch

                                        onCheckedChanged: {
                                            if(!initialized) return
                                            MachineAPI.setModbusAllowSetGas(checked)
                                            MachineAPI.insertEventLog(qsTr("User: %1 remote modbus to control %2").arg(checked ? qsTr("Allow") : qsTr("Forbid")).arg(gasSwitchText.text))
                                        }//
                                    }//

                                    TextApp {
                                        id: gasSwitchText
                                        anchors.verticalCenter: parent.verticalCenter
                                        text: qsTr("Gas")
                                    }//
                                }//

                                Row {
                                    visible: MachineData.uvInstalled
                                    SwitchApp {
                                        id: uvLightSwitch

                                        onCheckedChanged: {
                                            if(!initialized) return
                                            MachineAPI.setModbusAllowSetUvLight(checked)
                                            MachineAPI.insertEventLog(qsTr("User: %1 remote modbus to control %2").arg(checked ? qsTr("Allow") : qsTr("Forbid")).arg(uvLightSwitchText.text))
                                        }//
                                    }//

                                    TextApp {
                                        id: uvLightSwitchText
                                        anchors.verticalCenter: parent.verticalCenter
                                        text: qsTr("UV Light")
                                    }//
                                }//
                            }//

                            Row {
                                spacing: 5

                                TextApp {
                                    text: "*"
                                }////

                                TextApp {
                                    width: leftContentItem.width - asterixText.width
                                    wrapMode: Text.WordWrap
                                    text:qsTr("by default the system will only accept read operations")
                                }////
                            }////
                        }//
                    }////
                }////
            }////

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
                                var intent = IntentApp.create(uri, {"message":""})
                                finishView(intent)
                            }//
                        }////
                    }////
                }////
            }//
        }////

        /// Put all private property inside here
        /// if none, please comment this block to optimize the code
        QtObject {
            id: props

            property string recentStatus: qsTr("None")
        }//

        /// called Once but after onResume
        Component.onCompleted: {

        }////

        /// Execute This Every This Screen Active/Visible
        executeOnPageVisible: QtObject {

            /// onResume
            Component.onCompleted: {
                //                    ////console.debug("StackView.Active");
                slaveIdTextField.text = MachineData.modbusSlaveID
                allowIpMasterTextField.text = MachineData.modbusAllowIpMaster
                fanSwitch.checked = MachineData.modbusAllowSetFan
                fanSwitch.initialized = true
                lightSwitch.checked = MachineData.modbusAllowSetLight
                lightSwitch.initialized = true
                lightIntensitySwitch.checked = MachineData.modbusAllowSetLightIntensity
                lightIntensitySwitch.initialized = true
                socketSwitch.checked = MachineData.modbusAllowSetSocket
                socketSwitch.initialized = true
                gasSwitch.checked = MachineData.modbusAllowSetGas
                gasSwitch.initialized = true
                uvLightSwitch.checked = MachineData.modbusAllowSetUvLight
                uvLightSwitch.initialized = true

                props.recentStatus = Qt.binding(function(){
                    let status = MachineData.modbusLatestStatus;
                    status = status.replace("1@", "connected@")
                    status = status.replace("0@", "disconnected@")
                    //                        status.replace("0#", qsTr("disconnected"))
                    //                        status.replace("1#", qsTr("conneted"))
                    return status.length ? status : qsTr("None")
                })
            }//

            /// onPause
            Component.onDestruction: {
                //////console.debug("StackView.DeActivating");
            }//
        }////
    }////
}//

/*##^##
Designer {
    D{i:0;autoSize:true;formeditorColor:"#c0c0c0";height:480;width:800}
}
##^##*/
