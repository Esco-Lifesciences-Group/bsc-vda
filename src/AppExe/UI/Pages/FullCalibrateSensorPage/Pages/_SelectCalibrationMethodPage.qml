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
import "../../../CusCom/JS/IntentApp.js" as IntentApp

import ModulesCpp.Machine 1.0

ViewApp {
    id: viewApp
    title: "Full Sensor Calibration"

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
                    anchors.fill: parent
                    title: qsTr(viewApp.title)
                }
            }

            /// BODY
            Item {
                id: bodyItem
                Layout.fillWidth: true
                Layout.fillHeight: true

                Row{
                    anchors.centerIn: parent
                    spacing: 80
                    Column{
                        spacing: 5
                        Image{
                            opacity: dimButton.pressed ? 0.5 : 1
                            source: "qrc:/UI/Pictures/menu/ifa_dim_measure.png"
                            height: 150
                            fillMode: Image.PreserveAspectFit
                            Image{
                                id: dimDoneBadge
                                visible: MachineData.getAirflowFactoryCalibrationState(0) && MachineData.getAirflowFactoryCalibrationState(1) &&
                                         MachineData.getAirflowFactoryCalibrationState(2) && MachineData.getAirflowFactoryCalibrationState(3)
                                height: 70
                                fillMode: Image.PreserveAspectFit
                                anchors.top: parent.top
                                anchors.right: parent.right
                                source: "qrc:/UI/Pictures/done-green-white.png"
                            }
                            MouseArea{
                                id: dimButton
                                anchors.fill: parent
                                onClicked: {
                                    var intent = IntentApp.create("qrc:/UI/Pages/FullCalibrateSensorPage/Pages/_NavigationCalibratePage.qml", {})
                                    finishView(intent)
                                }
                            }
                        }
                        TextApp{
                            anchors.horizontalCenter: parent.horizontalCenter
                            text: qsTr("DIM Method")
                        }
                    }//
                    Column{
                        spacing: 5
                        Image{
                            opacity: secondaryButton.pressed ? 0.5 : 1
                            source: "qrc:/UI/Pictures/menu/ifa_sec_measure.png"
                            height: 150
                            fillMode: Image.PreserveAspectFit
                            Image{
                                id: secondaryBadgeDone
                                visible: MachineData.getAirflowFactorySecondaryCalibrationState(0) && MachineData.getAirflowFactorySecondaryCalibrationState(1) &&
                                         MachineData.getAirflowFactorySecondaryCalibrationState(2) && MachineData.getAirflowFactorySecondaryCalibrationState(3)
                                height: 70
                                fillMode: Image.PreserveAspectFit
                                anchors.top: parent.top
                                anchors.right: parent.right
                                source: "qrc:/UI/Pictures/done-green-white.png"
                            }
                            MouseArea{
                                id: secondaryButton
                                anchors.fill: parent
                                onClicked: {
                                    var intent = IntentApp.create("qrc:/UI/Pages/FullCalibrateSensorPage/Pages/_NavigationCalibrateSecPage.qml", {})
                                    finishView(intent)
                                }
                            }
                        }
                        TextApp{
                            anchors.horizontalCenter: parent.horizontalCenter
                            text: qsTr("Secondary Method")
                        }
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
                            width: 194
                            anchors.verticalCenter: parent.verticalCenter

                            imageSource: "qrc:///UI/Pictures/back-step.png"
                            text: qsTr("Back")

                            onClicked: {
                                var intent = IntentApp.create(uri, {"navigation":"back"})
                                finishView(intent)
                            }
                        }//
                    }//
                }//
            }//
        }//

        /// called Once but after onResume
        Component.onCompleted: {

        }//

        /// Execute This Every This Screen Active/Visible
        executeOnPageVisible: QtObject {

            /// onResume
            Component.onCompleted: {
                //console.debug("StackView.Active");

                //                    lightIntensitySlider.value = MachineData.lightIntensity
            }

            /// onPause
            Component.onDestruction: {
                ////console.debug("StackView.DeActivating");
            }
        }//
    }//
}

/*##^##
Designer {
    D{i:0;autoSize:true;height:480;width:800}
}
##^##*/
