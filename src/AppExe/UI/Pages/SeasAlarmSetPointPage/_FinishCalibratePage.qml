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
    title: "Pressure Alarm Setpoint"

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
                    title: qsTr("Pressure Alarm Setpoint")
                }//
            }//

            /// BODY
            Item {
                id: bodyItem
                Layout.fillWidth: true
                Layout.fillHeight: true

                Column {
                    anchors.centerIn: parent
                    spacing: 2

                    Image {
                        id: featureImage
                        anchors.horizontalCenter: parent.horizontalCenter
                        height: 100
                        fillMode: Image.PreserveAspectFit
                        source: "qrc:/UI/Pictures/done-green-white.png"
                    }//

                    TextApp {
                        width: 500
                        wrapMode: Text.WordWrap
                        horizontalAlignment: Text.AlignHCenter
                        text: "Setpoint setting has been done!"
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

                            imageSource: "qrc:/UI/Pictures/back-step.png"
                            text: qsTr("Close")

                            onClicked: {
                                MachineAPI.setFrontEndScreenState(MachineAPI.ScreenState_Other)

                                var intent = IntentApp.create(uri, {})
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
                //                    ////console.debug("StackView.Active");
                /// set back operation mode
                MachineAPI.setOperationPreviousMode();

                //                if(MachineData.sashWindowState === MachineAPI.SASH_STATE_WORK_SSV){
                //                    const showLoading = MachineData.fanPrimaryDutyCycle !== MachineData.getFanPrimaryNominalDutyCycle()
                //                    if(showLoading){
                //                        viewApp.showBusyPage(qsTr("Adjusting fan duty cycle..."),
                //                                             function onTriggered(cycle){
                //                                                 if(cycle >= MachineAPI.BUSY_CYCLE_1){
                //                                                     // close this pop up dialog
                //                                                     viewApp.dialogObject.close()
                //                                                 }
                //                                             })//
                //                    }//
                //                    if(showLoading)
                //                        MachineAPI.setFanState(MachineAPI.FAN_STATE_OFF)
                //                    MachineAPI.setFanState(MachineAPI.FAN_STATE_ON)
                //                }//
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
    D{i:0;autoSize:true;height:480;width:800}
}
##^##*/
