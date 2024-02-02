/**
 *  Copyright (C) 2021 by ESCO Bintan Indonesia
 *  https://escoglobal.com
 *
 *  Author: Ahmad Qodri
**/

import QtQuick 2.0
import QtQuick.Layouts 1.0
import QtQuick.Controls 2.0

import UI.CusCom 1.1
import "../../CusCom/JS/IntentApp.js" as IntentApp

import ModulesCpp.Machine 1.0

ViewApp {
    id: viewApp
    title: "Airflow Out Temperature"

    background.sourceComponent: Item {}

    content.asynchronous: true
    content.sourceComponent: ContentItemApp{
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
                    title: qsTr("Airflow Out Temperature")
                }
            }

            /// BODY
            Item {
                id: bodyItem
                Layout.fillWidth: true
                Layout.fillHeight: true

                RowLayout {
                    anchors.fill: parent
                    spacing: 10
                    Item {
                        Layout.fillHeight: true
                        Layout.fillWidth: true
                        Image{
                            source: "qrc:/UI/Pictures/airflow-out-temp-set.png"
                            fillMode: Image.PreserveAspectFit
                            anchors.verticalCenter: parent.verticalCenter
                            anchors.right: parent.right
                        }
                    }

                    Item {
                        Layout.fillHeight: true
                        Layout.fillWidth: true

                        ComboBoxApp {
                            id: comboBox
                            width: 190
                            height: 50
                            backgroundColor: "#0F2952"
                            backgroundBorderColor: "#dddddd"
                            backgroundBorderWidth: 2
                            font.pixelSize: 20
                            anchors.verticalCenter: parent.verticalCenter
                            textRole: "text"

                            model: [
                                {text: qsTr("Disable"), value: 0},
                                {text: qsTr("Enable"),  value: 1}
                            ]//

                            onActivated: {
                                let newValue = model[index].value
                                var message = ""
                                if(newValue !== props.airflowOutTempEnable){
                                    if(newValue === 0)
                                        message = qsTr("By Disabling the Airflow Out Temperature, the airflow monitoring will be disabled when the actual ambient temperature is out of range.") + "<br>"
                                                + qsTr("The temperature alarm is enabled.")
                                    else
                                        message = qsTr("By Enabling the Airflow Out Temperature, the airflow monitoring will be enabled if the actual ambient temperature is out of range.") + "<br>"
                                                + qsTr("The temperature alarm is disabled.")
                                    const autoclosed = true
                                    showDialogAsk(qsTr("Airflow Out Temperature"), message, (newValue ? dialogAlert : dialogInfo),
                                                  function onAccepted(){
                                                      MachineAPI.setAirflowOutTempEnable(newValue)

                                                      const stringEvent = newValue ? qsTr("User: Airflow out temp is enabled")
                                                                                 : qsTr("User: Airflow out temp is disabled")
                                                      MachineAPI.insertEventLog(stringEvent)

                                                      viewApp.showBusyPage(qsTr("Setting up..."),
                                                                           function(cycle){
                                                                               if(cycle >= MachineAPI.BUSY_CYCLE_1
                                                                                       || Number(MachineData.airflowOutTempEnable) == Number(newValue)){
                                                                                   comboBox.currentIndex = props.airflowOutTempEnable
                                                                                   viewApp.closeDialog();
                                                                               }
                                                                           })
                                                  },
                                                  function(){//onRejected
                                                      comboBox.currentIndex = props.airflowOutTempEnable
                                                  }, function(){//onClosed
                                                      comboBox.currentIndex = props.airflowOutTempEnable
                                                  }, autoclosed, 10)
                                }//
                            }//
                            //                            Component.onCompleted: {
                            //                                currentIndex = props.elsIsEnabled
                            //                            }
                        }//
                    }//
                }//
                /// Show this warning if using esco airflow sensor
                //                TextApp{
                //                    visible: MachineData.getInflowSensorConstant() > 0
                //                    anchors.bottom: parent.bottom
                //                    anchors.horizontalCenter: parent.horizontalCenter
                //                    horizontalAlignment: Text.AlignHCenter
                //                    width: 500
                //                    color: "#cccccc"
                //                    font.pixelSize: 16
                //                    wrapMode: Text.WordWrap
                //                    minimumPixelSize: 16
                //                    text: qsTr("The Airflow Monitor will be forcibly disabled if Airflow Out Temperature is set to Enable!")
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
                                var intent = IntentApp.create(uri, {"message":""})
                                finishView(intent)
                            }
                        }//
                    }//
                }//
            }
        }//

        /// Put all private property inside here
        /// if none, please comment this block to optimize the code
        QtObject {
            id: props

            property int airflowOutTempEnable: 0
        }

        /// called Once but after onResume
        Component.onCompleted: {

        }//

        /// Execute This Every This Screen Active/Visible
        executeOnPageVisible: QtObject {

            /// onResume
            Component.onCompleted: {
                //                    ////console.debug("StackView.Active");

                props.airflowOutTempEnable = Qt.binding(function(){return MachineData.airflowOutTempEnable})
                comboBox.currentIndex = props.airflowOutTempEnable
            }//

            /// onPause
            Component.onDestruction: {
                //////console.debug("StackView.DeActivating");
            }//
        }//
    }//
}

/*##^##
Designer {
    D{i:0;autoSize:true;height:480;width:800}
}
##^##*/
