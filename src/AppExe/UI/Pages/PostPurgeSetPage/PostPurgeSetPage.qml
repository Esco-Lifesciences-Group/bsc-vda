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
    title: "Post Purge Timer"

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
                    title: qsTr("Post Purge Timer")
                }
            }

            /// BODY
            Item {
                id: bodyItem
                Layout.fillWidth: true
                Layout.fillHeight: true

                Column{
                    anchors.centerIn: parent
                    spacing: 10

                    Row{
                        spacing: 10
                        anchors.horizontalCenter: parent.horizontalCenter

                        Image{
                            source: "qrc:/UI/Pictures/warmup-option-icon.png"
                            fillMode: Image.PreserveAspectFit
                        }

                        ComboBoxApp {
                            id: comboBox
                            //enabled: UserSessionService.roleLevel >= UserSessionService.roleLevelSupervisor
                            width: 190
                            height: 50
                            backgroundColor: enabled ? "#0F2952" : "#404244"
                            backgroundBorderColor: "#dddddd"
                            backgroundBorderWidth: 2
                            font.pixelSize: 20
                            anchors.verticalCenter: parent.verticalCenter
                            textRole: "text"

                            model: [
                                {text: qsTr("Disabled"),    value: 0},
                                {text: qsTr("1 Minute"),    value: 60},
                                {text: qsTr("3 Minutes"),   value: 180},
                                {text: qsTr("5 Minutes"),   value: 300}
                            ]

                            onActivated: {
                                //////console.debug(index)
                                //////console.debug(model[index].value)
                                let newValue = model[index].value
                                if(props.postpurgeTimer !== newValue){
                                    //                                    props.postpurgeTimer = newValue
                                    MachineAPI.setPostPurgeTimeSave(newValue)

                                    MachineAPI.insertEventLog(qsTr("User: Set post purge time to %1").arg(model[index].text))

                                    ////console.debug("Postpurge: ", props.postpurgeTimer , " min")
                                    viewApp.showBusyPage((qsTr("Setting up...")),
                                                         function onTriggered(cycle){
                                                             if(cycle >= MachineAPI.BUSY_CYCLE_1
                                                                     || MachineData.postPurgingTime === newValue){
                                                                 viewApp.dialogObject.close()}
                                                         })
                                }//
                            }//

                            //                            Component.onCompleted: {
                            //                                if(props.postpurgeTimer == 1)
                            //                                    currentIndex = 0
                            //                                else if(props.postpurgeTimer == 3)
                            //                                    currentIndex = 1
                            //                                else if(props.postpurgeTimer == 5)
                            //                                    currentIndex = 2
                            //                                else currentIndex = 0
                            //                            }
                        }//
                    }//

                    TextApp{
                        width: 500
                        minimumPixelSize: 20
                        text: qsTr("After the user turns off the internal fan, the post-purge period follows. This is to ensure that all contaminants are purged from the work zone.")
                        wrapMode: Text.WordWrap
                        horizontalAlignment: Text.AlignJustify
                    }//

                    //                    TextApp{
                    //                        width: 500
                    //                        color: "#929292"
                    //                        text: qsTr("Note:\nSystem does not have a tool to measure actual contaminants.\nUser can clean manually during this period.")
                    //                        wrapMode: Text.WordWrap
                    //                        horizontalAlignment: Text.AlignJustify
                    //                    }
                }
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

            property int postpurgeTimer: 60
        }

        /// called Once but after onResume
        Component.onCompleted: {

        }//

        /// Execute This Every This Screen Active/Visible
        Loader {
            active: viewApp.stackViewStatusForeground
            sourceComponent: QtObject {

                /// onResume
                Component.onCompleted: {
                    //                    ////console.debug("StackView.Active");

                    props.postpurgeTimer = MachineData.postPurgingTime
                    if(props.postpurgeTimer == 60)
                        comboBox.currentIndex = 1
                    else if(props.postpurgeTimer == 180)
                        comboBox.currentIndex = 2
                    else if(props.postpurgeTimer == 300)
                        comboBox.currentIndex = 3
                    else comboBox.currentIndex = 0
                }

                /// onPause
                Component.onDestruction: {
                    //////console.debug("StackView.DeActivating");
                }
            }//
        }//
    }//
}//

/*##^##
Designer {
    D{i:0;autoSize:true;formeditorColor:"#808080";height:480;width:800}
}
##^##*/
