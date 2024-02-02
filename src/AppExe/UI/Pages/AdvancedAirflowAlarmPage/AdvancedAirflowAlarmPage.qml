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
    title: "Advanced Airflow Alarm"

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
                    title: qsTr("Advanced Airflow Alarm")
                }
            }

            /// BODY
            Item {
                id: bodyItem
                Layout.fillWidth: true
                Layout.fillHeight: true
                Column{
                    anchors.centerIn: parent
                    spacing: 15
                    Column{
                        TextApp{
                            anchors.horizontalCenter: parent.horizontalCenter
                            text: qsTr("Enable or Disable the Downflow Fail Alarm")
                        }
                        Row{
                            anchors.horizontalCenter: parent.horizontalCenter
                            spacing: 5
                            Column{
                                TextApp{
                                    text: qsTr("Low Downflow Alarm")
                                }
                                TextApp{
                                    text: qsTr("High Downflow Alarm")
                                }
                            }
                            Column{
                                TextApp{
                                    text: ": %1".arg(props.downflowLowStrf)
                                }
                                TextApp{
                                    text: ": %1".arg(props.downflowHighStrf)
                                }
                            }
                        }
                    }
                    ComboBoxApp {
                        id: comboBox
                        width: 190
                        height: 50
                        backgroundColor: "#0F2952"
                        backgroundBorderColor: "#dddddd"
                        backgroundBorderWidth: 2
                        font.pixelSize: 20
                        anchors.horizontalCenter: parent.horizontalCenter
                        textRole: "text"

                        model: [
                            {text: qsTr("Disable"), value: false},
                            {text: qsTr("Enable"),  value: true}
                        ]

                        onActivated: {
                            //////console.debug(index)
                            //////console.debug(model[index].value)
                            let newValue = model[index].value
                            if(props.advAfEnabled !== newValue){
                                //props.advAfEnabled = newValue

                                MachineAPI.setAdvancedAirflowAlarmEnable(newValue)

                                let stringEn = newValue ? qsTr("Enabled") : qsTr("Disabled")
                                const eventStr = qsTr("User: Advanced airflow alarm is %1").arg(stringEn)
                                MachineAPI.insertEventLog("%1".arg(eventStr))

                                viewApp.showBusyPage(qsTr("Setting up..."),
                                                     function onTriggered(cycle){
                                                         if((cycle >= MachineAPI.BUSY_CYCLE_1)
                                                                 || (MachineData.advancedAirflowAlarmEnable === newValue)){
                                                             props.advAfEnabled = MachineData.advancedAirflowAlarmEnable
                                                             comboBox.currentIndex = props.advAfEnabled ? 1 : 0

                                                             viewApp.dialogObject.close()}
                                                     })//
                            }//
                        }//

                        //                            Component.onCompleted: {
                        //                                currentIndex = props.advAfEnabled
                        //                            }
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

            property bool advAfEnabled: false

            property string downflowLowStrf: ""
            property string downflowHighStrf: ""
        }

        /// called Once but after onResume
        Component.onCompleted: {

        }//

        /// Execute This Every This Screen Active/Visible
        executeOnPageVisible: QtObject {

            /// onResume
            Component.onCompleted: {
                //                    ////console.debug("StackView.Active");

                props.advAfEnabled = MachineData.advancedAirflowAlarmEnable
                comboBox.currentIndex = props.advAfEnabled ? 1 : 0

                let dfaNomVel = MachineData.getDownflowVelocityPointFactory(MachineAPI.POINT_NOMINAL)

                if(MachineData.airflowCalibrationStatus === MachineAPI.AF_CALIB_FIELD)
                    dfaNomVel = MachineData.getDownflowVelocityPointField(MachineAPI.POINT_NOMINAL)

                let tolerance = 1000 //10 fpm
                props.downflowLowStrf = "%1 fpm".arg(Number((dfaNomVel+tolerance)/100).toFixed(0))
                props.downflowHighStrf = "%1 fpm".arg(Number((dfaNomVel-tolerance)/100).toFixed(0))

                if(MachineData.measurementUnit === MachineAPI.MEA_UNIT_METRIC){
                    tolerance = 5
                    props.downflowLowStrf = "%1 m/s".arg(Number((dfaNomVel+tolerance)/100).toFixed(2))
                    props.downflowHighStrf = "%1 m/s".arg(Number((dfaNomVel-tolerance)/100).toFixed(2))
                }
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
