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
    title: "Auxiliary Functions"

    background.sourceComponent: Item {}

    content.asynchronous: true
    content.sourceComponent: ContentItemApp{
        id: contentView
        x: 0
        y: 0
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
                    title: qsTr("Auxiliary Functions")
                }
            }

            /// BODY
            Item {
                id: bodyItem
                Layout.fillWidth: true
                Layout.fillHeight: true

                Grid {
                    anchors.centerIn: parent
                    spacing: 5

                    Repeater {
                        id: auxOptionRepeater
                        // model: 5
                        // model: [
                        //     {label: "Built-in SEAS",    installed: 0},
                        //     {label: "Motorize Sash",    installed: 0},
                        //     {label: "UV Lamp",          installed: 0},
                        //     {label: "Gas Valve",        installed: 0},
                        //     {label: "Electric Socket",  installed: 0},
                        // ]

                        Rectangle {
                            height: 100
                            width: 180
                            radius: 5
                            color: "#0F2952"

                            ColumnLayout {
                                anchors.fill: parent
                                anchors.margins: 5

                                Item {
                                    Layout.fillHeight: true
                                    Layout.fillWidth: true

                                    TextApp {
                                        anchors.fill: parent
                                        horizontalAlignment: Text.AlignHCenter
                                        verticalAlignment: Text.AlignVCenter
                                        wrapMode: Text.WordWrap
                                        text: modelData.label

                                    }//
                                }//

                                Rectangle {
                                    Layout.minimumHeight: 1
                                    Layout.fillWidth: true
                                    color: "gray"
                                }//

                                Item {
                                    Layout.fillHeight: true
                                    Layout.fillWidth: true

                                    SwitchApp {
                                        anchors.centerIn: parent

                                        property bool origin: value

                                        onCheckedChanged: {
                                            if(!initialized) return
                                            //                                            console.log("onCheckedChanged:" + checked)

                                            let tempAux = props.auxNew
                                            tempAux = tempAux.filter(function(value, index, arr){
                                                return value.aux !== modelData.id;
                                            })

                                            if(origin != checked) {
                                                tempAux.push({aux: modelData.id, installed: checked, label: modelData.label})
                                            }
                                            //console.debug(JSON.stringify(tempAux))
                                            props.auxNew = tempAux
                                            //                                            console.log(props.auxNew.length)
                                        }//

                                        Component.onCompleted: {
                                            checked = modelData.installed
                                            origin  = modelData.installed
                                            initialized = true
                                        }//
                                    }//
                                }//
                            }//
                        }//
                    }//
                }//

                TextApp {
                    anchors.bottom: parent.bottom
                    anchors.horizontalCenter: parent.horizontalCenter
                    text:  "*" + qsTr("New configuration will be applied after system restart") + "."
                           + "<br>"
                           + qsTr("The system will restart after you tap the '%1' button.").arg(setButton.text) + "."
                    color: "#cccccc"
                    font.pixelSize: 16
                    horizontalAlignment: Text.AlignHCenter
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
                                var intent = IntentApp.create(uri, {"message":""})
                                finishView(intent)
                            }
                        }//

                        ButtonBarApp {
                            id: setButton
                            width: 194
                            anchors.verticalCenter: parent.verticalCenter
                            anchors.right: parent.right
                            enabled: props.auxNew.length

                            imageSource: "qrc:/UI/Pictures/checkicon.png"
                            text: qsTr("Apply")

                            onClicked: {
                                viewApp.fnSwipedFromBottomEdge  = function(){}
                                viewApp.fnSwipedFromLeftEdge    = function(){}
                                viewApp.fnSwipedFromRightEdge   = function(){}

                                /// Tell to backend
                                let auxs = props.auxNew
                                for (var aux of auxs){
                                    //console.log(aux.aux)

                                    if(aux.aux === "seas"){
                                        MachineAPI.setSeasBuiltInInstalled(aux.installed)
                                        MachineAPI.insertEventLog(qsTr("User: Set auxiliary functions (%1: %2)").arg(aux.label).arg(aux.installed ? qsTr("Enabled") : qsTr("Disabled")))
                                    }
                                    else if(aux.aux === "seasFlap"){
                                        MachineAPI.setSeasFlapInstalled(aux.installed)
                                        MachineAPI.insertEventLog(qsTr("User: Set auxiliary functions (%1: %2)").arg(aux.label).arg(aux.installed ? qsTr("Enabled") : qsTr("Disabled")))
                                    }
                                    else if(aux.aux === "mosash"){
                                        MachineAPI.setSashMotorizeInstalled(aux.installed)
                                        MachineAPI.insertEventLog(qsTr("User: Set auxiliary functions (%1: %2)").arg(aux.label).arg(aux.installed ? qsTr("Enabled") : qsTr("Disabled")))
                                    }
                                    else if(aux.aux === "uv"){
                                        MachineAPI.setUvInstalled(aux.installed)
                                        MachineAPI.insertEventLog(qsTr("User: Set auxiliary functions (%1: %2)").arg(aux.label).arg(aux.installed ? qsTr("Enabled") : qsTr("Disabled")))
                                    }
                                    else if(aux.aux === "gas"){
                                        MachineAPI.setGasInstalled(aux.installed)
                                        MachineAPI.insertEventLog(qsTr("User: Set auxiliary functions (%1: %2)").arg(aux.label).arg(aux.installed ? qsTr("Enabled") : qsTr("Disabled")))
                                    }
                                    else if(aux.aux === "soc"){
                                        MachineAPI.setSocketInstalled(aux.installed)
                                        MachineAPI.insertEventLog(qsTr("User: Set auxiliary functions (%1: %2)").arg(aux.label).arg(aux.installed ? qsTr("Enabled") : qsTr("Disabled")))
                                    }//
                                    else if(aux.aux === "pacos"){
                                        MachineAPI.setParticleCounterSensorInstalled(aux.installed)
                                        MachineAPI.insertEventLog(qsTr("User: Set auxiliary functions (%1: %2)").arg(aux.label).arg(aux.installed ? qsTr("Enabled") : qsTr("Disabled")))
                                    }//
                                }//

                                showBusyPage(qsTr("Please wait..."),
                                             function onCallback(cycle){
                                                 if (cycle >= MachineAPI.BUSY_CYCLE_1) {
                                                     const intent = IntentApp.create("qrc:/UI/Pages/ClosingPage/ClosingPage.qml", {})
                                                     startRootView(intent)
                                                 }
                                             })
                            }//
                        }//
                    }//
                }//
            }//
        }//

        // Put all private property inside here
        // if none, please comment this block to optimize the code
        QtObject {
            id: props

            property var auxNew: []
        }

        /// called Once but after onResume
        Component.onCompleted: {

        }//

        /// Execute This Every This Screen Active/Visible
        executeOnPageVisible: QtObject {

            /// onResume
            Component.onCompleted: {
                //                    ////console.debug("StackView.Active");
                let currentAuxOption = []
                currentAuxOption.push({label: qsTr("Pressure Sensor"),
                                          id: "seas",
                                          installed: MachineData.seasInstalled})
                currentAuxOption.push({label: qsTr("Exhaust Collar Board"),
                                          id: "seasFlap",
                                          installed: MachineData.seasFlapInstalled})
                currentAuxOption.push({label: qsTr("Motorized Sash"),
                                          id: "mosash",
                                          installed: MachineData.hydraulicMotorizedInstalled})
                currentAuxOption.push({label: qsTr("UV Lamp"),
                                          id: "uv",
                                          installed: MachineData.uvInstalled})
                currentAuxOption.push({label: qsTr("Gas Valve"),
                                          id: "gas",
                                          installed: MachineData.gasInstalled})
                currentAuxOption.push({label: qsTr("Electric Outlet"),
                                          id: "soc",
                                          installed: MachineData.socketInstalled})
                currentAuxOption.push({label: qsTr("Particle Counter Sensor"),
                                          id: "pacos",
                                          installed: MachineData.particleCounterSensorInstalled})
                auxOptionRepeater.model = currentAuxOption

            }

            /// onPause
            Component.onDestruction: {
                //////console.debug("StackView.DeActivating");
            }
        }//
    }//
}

/*##^##
Designer {
    D{i:0;autoSize:true;formeditorColor:"#808080";height:480;width:800}
}
##^##*/
