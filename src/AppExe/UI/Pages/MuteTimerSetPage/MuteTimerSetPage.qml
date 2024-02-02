/**
 *  Copyright (C) 2021 by ESCO Bintan Indonesia
 *  https://escoglobal.com
 *
 *  Author: Ahmad Qodri
**/

import QtQuick 2.4
import QtQuick.Layouts 1.0
import QtQuick.Controls 2.0

import UI.CusCom 1.1
import "../../CusCom/JS/IntentApp.js" as IntentApp

import ModulesCpp.Machine 1.0

ViewApp {
    id: viewApp
    title: "Mute Timer"

    background.sourceComponent: Item {}

    content.asynchronous: true
    content.sourceComponent: Item{
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
                    title: qsTr("Mute Timer")
                }
            }

            /// BODY
            Item {
                id: bodyItem
                Layout.fillWidth: true
                Layout.fillHeight: true

                /// fragment container
                StackView {
                    id: fragmentStackView
                    anchors.fill: parent
                    initialItem: currentValueComponent/*configureComponent*/
                }//

                /// fragment-1
                Component {
                    id: currentValueComponent
                    Item{
                        Row {
                            anchors.centerIn: parent
                            spacing: 10
                            Image{
                                source: "qrc:/UI/Pictures/mute-timer-icon.png"
                                fillMode: Image.PreserveAspectFit
                            }
                            Column {
                                id: currentValueColumn
                                spacing: 5
                                anchors.verticalCenter: parent.verticalCenter

                                TextApp{
                                    text: qsTr("Current timer") + ":"
                                }//

                                TextApp{
                                    id: currentValueText
                                    font.pixelSize: 36
                                    wrapMode: Text.WordWrap
                                    font.bold: true
                                    text: (utilsApp.strfSecsToHumanReadableShort(props.sashFullyOpened ? props.muteTimerAtFO
                                                                                                       : props.muteTimer))
                                    MouseArea {
                                        anchors.fill: parent
                                        onClicked: {
                                            // if(UserSessionService.roleLevel >= UserSessionService.roleLevelSupervisor)
                                            fragmentStackView.push(configureComponent)
                                            // else{
                                            //     showDialogMessage(qsTr("Access Denied"),
                                            //                       qsTr("You do not have permission to perform this action!"),
                                            //                       dialogAlert)
                                            // }
                                        }//
                                    }//
                                }//

                                TextApp{
                                    text: qsTr("Tap to change")
                                    color: "#cccccc"
                                    font.pixelSize: 18
                                }//
                            }//
                        }
                    }//
                }//
                /// fragment-2
                Component {
                    id: configureComponent

                    Item {
                        id: configureItem

                        Loader {
                            id: configureLoader
                            anchors.fill: parent
                            asynchronous: true
                            visible: status == Loader.Ready
                            sourceComponent: Item {
                                id: container

                                function formatText(count, modelData) {
                                    var data = count === 12 ? modelData + 1 : modelData;
                                    return data.toString().length < 2 ? "0" + data : data;
                                }//

                                FontMetrics {
                                    id: fontMetrics
                                    font.pixelSize: 20
                                }//

                                Component {
                                    id: delegateComponent

                                    Label {
                                        text: container.formatText(Tumbler.tumbler.count, modelData)
                                        opacity: 1.0 - Math.abs(Tumbler.displacement) / (Tumbler.tumbler.visibleItemCount / 2)
                                        horizontalAlignment: Text.AlignHCenter
                                        verticalAlignment: Text.AlignVCenter
                                        font.pixelSize: fontMetrics.font.pixelSize * 1.25
                                        font.bold: Tumbler.tumbler.currentIndex == index
                                        color: "#DDDDDD"
                                    }//
                                }//

                                Frame {
                                    id: frame
                                    padding: 10
                                    anchors.centerIn: parent

                                    background: Rectangle {
                                        color: "#0F2952"
                                        radius: 5
                                        border.color: "#DDDDDD"
                                    }//

                                    function generateTime(){
                                        //////console.debug("generateTime")

                                        let minutes = minutesTumbler.currentIndex;
                                        let seconds = secondsTumbler.currentIndex;
                                        props.requestTime = (minutes * 60) + seconds

                                        //console.debug("the timer: " +  props.requestTime)
                                    }
                                    Column{
                                        id: column
                                        spacing: 5
                                        TextApp {
                                            anchors.horizontalCenter: parent.horizontalCenter
                                            font.pixelSize: fontMetrics.font.pixelSize
                                            text: qsTr("MM:SS")
                                        }
                                        Row {
                                            id: row

                                            Tumbler {
                                                id: minutesTumbler
                                                model: (props.sashFullyOpened ? ((secondsTumbler.currentIndex == 0) ? 61 : 60)
                                                                              : ((secondsTumbler.currentIndex == 0) ? 16 : 15))
                                                delegate: delegateComponent
                                                width: 100

                                                onMovingChanged: {
                                                    if (!moving) {
                                                        frame.generateTime()
                                                    }//
                                                }//
                                            }//

                                            TextApp {
                                                anchors.verticalCenter: parent.verticalCenter
                                                font.pixelSize: fontMetrics.font.pixelSize
                                                text: ":"
                                            }

                                            Tumbler {
                                                id: secondsTumbler
                                                model: 60
                                                delegate: delegateComponent
                                                width: 100

                                                onMovingChanged: {
                                                    if (!moving) {
                                                        frame.generateTime()
                                                    }//
                                                }//
                                            }//
                                        }//
                                    }//
                                }//

                                Component.onCompleted: {
                                    props.requestTime = (props.sashFullyOpened ? props.muteTimerAtFO
                                                                              : props.muteTimer)//0

                                    let minutes = props.requestTime / 60
                                    let seconds =  props.requestTime % 60

                                    minutesTumbler.currentIndex = minutes
                                    secondsTumbler.currentIndex = seconds

                                    setButton.visible = true
                                }//

                                Component.onDestruction: {
                                    setButton.visible = false
                                }//
                            }//
                        }//

                        BusyIndicatorApp {
                            visible: configureLoader.status === Loader.Loading
                            anchors.centerIn: parent
                        }//
                    }//
                }//

                UtilsApp {
                    id: utilsApp
                }//

                TextApp {
                    visible: props.sashFullyOpened
                    anchors.bottom: parent.bottom
                    anchors.horizontalCenter: parent.horizontalCenter
                    text:  "*" + qsTr("This mute timer setting only applies to the mute timer when the sash is in the fully open position.")
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
                                if(setButton.visible){
                                    fragmentStackView.pop()
                                    setButton.visible = false
                                    props.requestTime = (props.sashFullyOpened ? props.muteTimerAtFO
                                                                              : props.muteTimer)
                                }
                                else{
                                    var intent = IntentApp.create(uri, {"message":""})
                                    finishView(intent)
                                }
                            }
                        }//

                        ButtonBarApp {
                            id: setButton
                            width: 194
                            anchors.verticalCenter: parent.verticalCenter
                            anchors.right: parent.right

                            /// only visible from second fragment, set options
                            visible: false

                            imageSource: "qrc:/UI/Pictures/checkicon.png"
                            text: qsTr("Set")

                            onClicked: {
                                if(props.requestTime >= 30) {
                                    if((props.requestTime !== props.muteTimer)
                                            && !props.sashFullyOpened){
                                        MachineAPI.setMuteAlarmTime(props.requestTime)

                                        MachineAPI.insertEventLog(qsTr("User: Set mute timer to %1").arg(utilsApp.strfSecsToHumanReadableShort(props.requestTime)))

                                        viewApp.showBusyPage(qsTr("Setting up..."),
                                                             function onCycle(cycle){
                                                                 if (cycle >= MachineAPI.BUSY_CYCLE_1
                                                                         || MachineData.muteAlarmTime === props.requestTime) {
                                                                     fragmentStackView.pop()
                                                                     viewApp.dialogObject.close()
                                                                 }//
                                                             })
                                    }else if((props.requestTime !== props.muteTimerAtFO)
                                             && props.sashFullyOpened){
                                        MachineAPI.setMuteAlarmTimeAtFullyOpened(props.requestTime)

                                        MachineAPI.insertEventLog(qsTr("User: Set mute timer at fully opened to %1").arg(utilsApp.strfSecsToHumanReadableShort(props.requestTime)))

                                        viewApp.showBusyPage(qsTr("Setting up..."),
                                                             function onCycle(cycle){
                                                                 if (cycle >= MachineAPI.BUSY_CYCLE_1
                                                                         || MachineData.muteAlarmTimeAtFullyOpened === props.requestTime) {
                                                                     fragmentStackView.pop()
                                                                     viewApp.dialogObject.close()
                                                                 }//
                                                             })
                                    }
                                    else{
                                        setButton.visible = false
                                        fragmentStackView.pop()
                                    }//
                                } else{
                                    viewApp.showDialogMessage(qsTr("Mute Timer"), qsTr("The minimum setting of the Mute timer is 30 seconds!"), dialogAlert)
                                }
                            }//
                        }//
                    }//
                }//
            }//
        }//

        /// Put all private property inside here
        /// if none, please comment this block to optimize the code
        QtObject {
            id: props
            property int requestTime: 0
            property int muteTimer : 0
            property int muteTimerAtFO : 0

            property bool sashFullyOpened: false
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
                    props.muteTimer = Qt.binding(function(){return MachineData.muteAlarmTime})
                    props.muteTimerAtFO = Qt.binding(function(){return MachineData.muteAlarmTimeAtFullyOpened})
                    props.sashFullyOpened = Qt.binding(function(){return MachineData.sashWindowState === MachineAPI.SASH_STATE_FULLY_OPEN_SSV})
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
    D{i:0;autoSize:true;formeditorColor:"#4c4e50";formeditorZoom:0.9;height:480;width:800}
}
##^##*/
