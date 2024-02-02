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
import "../../CusCom/JS/IntentApp.js" as IntentApp

import ModulesCpp.Machine 1.0
import ModulesCpp.Settings 1.0

ViewApp {
    id: viewApp
    title: "Experiment Timer"

    background.sourceComponent: Item {}

    content.asynchronous: true
    content.sourceComponent: ContentItemApp {
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
                    title: qsTr("Experiment Timer")
                }
            }

            /// BODY
            Item {
                id: bodyItem
                Layout.fillWidth: true
                Layout.fillHeight: true

                RowLayout {
                    anchors.fill: parent

                    Item {
                        Layout.fillHeight: true
                        Layout.fillWidth: true

                        Row {
                            anchors.centerIn: parent
                            spacing: 100

                            Column {
                                spacing: 0

                                Rectangle {
                                    width: 150
                                    height: 150
                                    color: "transparent"


                                    Image {
                                        anchors.fill: parent
                                        source: "qrc:/UI/Pictures/menu/Experiment-Timer.png"
                                        fillMode: Image.PreserveAspectFit
                                    }//

                                    MouseArea {
                                        anchors.fill: parent

                                        onClicked: {
                                            const intent = IntentApp.create("qrc:/UI/Pages/ExperimentTimerPage/ExperimentTimerPage.qml", {})
                                            startView(intent)
                                        }//
                                    }//
                                }//

                                TextApp {
                                    anchors.horizontalCenter: parent.horizontalCenter
                                    text: qsTr("Timer")
                                    //                                    font.pixelSize: 30
                                    //                                    font.bold: true
                                }//
                            }//

                            Column {
                                spacing: 0

                                Rectangle {
                                    width: 150
                                    height: 150
                                    color: "transparent"

                                    Image {
                                        id: tourImage
                                        anchors.fill: parent
                                        source: "qrc:/UI/Pictures/menu/stopwatch.png"
                                        fillMode: Image.PreserveAspectFit
                                    }//

                                    MouseArea {
                                        anchors.fill: parent

                                        onClicked: {
                                            const intent = IntentApp.create("qrc:/UI/Pages/StopwatchTimerPage/StopwatchTimerPage.qml", {})
                                            startView(intent)
                                        }
                                    }//
                                }//

                                TextApp {
                                    anchors.horizontalCenter: parent.horizontalCenter
                                    text: qsTr("Stopwatch")
                                    //                                    font.pixelSize: 30
                                    //                                    font.bold: true
                                }//
                            }//
                        }//
                    }//
                }//

                CheckBox {
                    id: policyCheckBox
                    text :qsTr("Always display timer on home screen")
                    height: 30//parent.height
                    font.pixelSize: 20
                    anchors.right: parent.right
                    anchors.bottom: parent.bottom
                    anchors.rightMargin: 40
                    anchors.bottomMargin: 10
                    checked: MachineData.experimentTimerAlwaysShow

                    visible: UserSessionService.roleLevel > UserSessionService.roleLevelGuest

                    contentItem: Text {
                        text: policyCheckBox.text
                        font: policyCheckBox.font
                        opacity: enabled ? 1.0 : 0.3
                        color: "#e3dac9"
                        verticalAlignment: Text.AlignVCenter
                        anchors.left: parent.left
                        anchors.leftMargin: 40
                    }//

                    onCheckedChanged: {
                        MachineAPI.setExperimentTimerAlwaysShow(checked)
                        MachineAPI.insertEventLog(qsTr("User: Always display timer on home screen") + " = " + (checked ? qsTr("Enable") : qsTr("Disable")))
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
                                var intent = IntentApp.create(uri, {"message":""})
                                finishView(intent)
                            }
                        }//
                    }//
                }//
            }//
        }//

        ///// Put all private property inside here
        ///// if none, please comment this block to optimize the code
        QtObject {
            id: props

            property int countDefault: 50
            property int count: 50
        }//

        /// One time executed after onResume
        Component.onCompleted: {

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
            }
        }//
    }//
}//

