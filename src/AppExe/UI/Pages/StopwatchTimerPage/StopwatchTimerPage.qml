import QtQuick 2.4
import QtQuick.Layouts 1.0
import QtQuick.Controls 2.0

import UI.CusCom 1.1
import "../../CusCom/JS/IntentApp.js" as IntentApp

import ModulesCpp.Machine 1.0

ViewApp {
    id: viewApp
    title: "Stopwatch Timer"

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
                    title: qsTr("Stopwatch Timer")
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
                        id: rightContentItem
                        Layout.fillHeight: true
                        Layout.fillWidth: true
                        Column {
                            anchors.centerIn: parent
                            spacing: 10
                            TextApp{
                                id: countTimerTextApp
                                //anchors.fill: parent
                                anchors.horizontalCenter: parent.horizontalCenter
                                text: utils.strfSecsToHHMMSS(props.timerCount)
                                //verticalAlignment: Text.AlignVCenter
                                horizontalAlignment: Text.AlignHCenter
                                font.pixelSize: 50
                            }
                            ListView {
                                id: snapStopwatchListView
                                height: rightContentItem.height - (countTimerTextApp.height + 40)
                                width: rightContentItem.width - 70
                                anchors.horizontalCenter: parent.horizontalCenter
                                orientation: ListView.Vertical
                                spacing: 2
                                clip: true
                                visible: false

                                delegate: Rectangle {
                                    //radius: 5
                                    height: 35
                                    color: "#34495E"
                                    width: snapStopwatchListView.width
                                    RowLayout{
                                        anchors.fill: parent
                                        TextApp{
                                            Layout.fillHeight: true
                                            Layout.minimumWidth: 50
                                            verticalAlignment: Text.AlignVCenter
                                            horizontalAlignment: Text.AlignHCenter
                                            text: modelData.index
                                        }
                                        TextApp{
                                            Layout.fillHeight: true
                                            Layout.fillWidth: true
                                            verticalAlignment: Text.AlignVCenter
                                            horizontalAlignment: Text.AlignHCenter
                                            text: "+" + utils.strfSecsToHHMMSS(modelData.elapsed)
                                        }
                                        TextApp{
                                            Layout.fillHeight: true
                                            Layout.fillWidth: true
                                            verticalAlignment: Text.AlignVCenter
                                            horizontalAlignment: Text.AlignHCenter
                                            text: utils.strfSecsToHHMMSS(modelData.count)
                                        }
                                    }
                                }
                            }
                        }
                    }//

                    Item {
                        Layout.fillHeight: true
                        Layout.fillWidth: true

                        Row {
                            anchors.centerIn: parent
                            spacing: 5

                            Rectangle {
                                visible: props.timerStatus === StopwatchTimerService.statusPlay
                                height: 75
                                width: 150
                                radius: 10
                                //                                color: "#2ecc71"
                                color: "#1f95d7"
                                border.color: "#34495e"
                                border.width: 3
                                opacity: captureMouseArea.pressed ? 0.5 : 1

                                Image {
                                    source: "qrc:/UI/Pictures/playcontrol/capture.png"
                                    anchors.centerIn: parent
                                    fillMode: Image.PreserveAspectFit
                                }//

                                MouseArea {
                                    id: captureMouseArea
                                    anchors.fill: parent
                                    onClicked: {
                                        //                                        props.timerStopped = true
                                        //                                        props.timerRunning = false
                                        StopwatchTimerService.capture()
                                        //                                        MachineAPI.insertEventLog(qsTr("Experiment timer is stopped"))
                                    }//
                                }//
                            }//

                            Rectangle {
                                visible: props.timerStatus === StopwatchTimerService.statusPause
                                height: 75
                                width: 150
                                radius: 10
                                //                                color: "#2ecc71"
                                color: "#1f95d7"
                                border.color: "#34495e"
                                border.width: 3
                                opacity: stopMouseArea.pressed ? 0.5 : 1

                                Image {
                                    source: "qrc:/UI/Pictures/playcontrol/stop.png"
                                    anchors.centerIn: parent
                                    fillMode: Image.PreserveAspectFit
                                }//

                                MouseArea {
                                    id: stopMouseArea
                                    anchors.fill: parent
                                    onClicked: {
                                        //                                        props.timerStopped = true
                                        //                                        props.timerRunning = false
                                        StopwatchTimerService.stop()
                                        //                                        MachineAPI.insertEventLog(qsTr("Experiment timer is stopped"))
                                    }//
                                }//
                            }//

                            Rectangle {
                                visible: (props.timerStatus === StopwatchTimerService.statusStop)
                                         || (props.timerStatus === StopwatchTimerService.statusPause)
                                height: 75
                                width: 150
                                radius: 10
                                color: "#1f95d7"
                                border.color: "#34495e"
                                border.width: 3
                                opacity: playMouseArea.pressed ? 0.5 : 1

                                Image {
                                    source: "qrc:/UI/Pictures/playcontrol/play.png"
                                    anchors.centerIn: parent
                                    fillMode: Image.PreserveAspectFit
                                }

                                MouseArea {
                                    id: playMouseArea
                                    anchors.fill: parent
                                    onClicked: {
                                        if((ExperimentTimerService.status === ExperimentTimerService.statusPlay) || (ExperimentTimerService.status === ExperimentTimerService.statusPause)){
                                            let autoClose = false
                                            const message = qsTr("The Experiment timer is still active, experiment timer will stop if continue.") + "<br>" +
                                                          qsTr("Are you sure you want to continue?")
                                            showDialogAsk(qsTr("Attention!"), message, dialogAlert, function onAccepted(){
                                                viewApp.closeDialog()
                                                ExperimentTimerService.stop()
                                                StopwatchTimerService.start()
                                            }, function(){}, function(){}, autoClose)
                                        }
                                        else{
                                            StopwatchTimerService.start()
                                        }
                                    }//
                                }//
                            }//

                            Rectangle {
                                visible: props.timerStatus === StopwatchTimerService.statusPlay
                                height: 75
                                width: 150
                                radius: 10
                                color: "#1f95d7"
                                border.color: "#34495e"
                                border.width: 3
                                opacity: pauseMouseArea.pressed ? 0.5 : 1

                                Image {
                                    source: "qrc:/UI/Pictures/playcontrol/pause.png"
                                    anchors.centerIn: parent
                                    fillMode: Image.PreserveAspectFit
                                }

                                MouseArea {
                                    id: pauseMouseArea
                                    anchors.fill: parent
                                    onClicked: {
                                        //                                        props.timerStopped = false
                                        //                                        props.timerRunning = false
                                        StopwatchTimerService.pause()
                                        //                                        MachineAPI.insertEventLog(qsTr("Experiment timer is paused"))
                                    }//
                                }//
                            }//
                        }//
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
            }//
        }//

        UtilsApp {
            id: utils
        }//

        //// Put all private property inside here
        //// if none, please comment this block to optimize the code
        QtObject {
            id: props

            property int timerCount: 0
            property int timerStatus: 0

            property var snapStopwatchModel: []

            function stopwatchCaptureModelUpdated(){
                props.snapStopwatchModel = StopwatchTimerService.captureModel
                snapStopwatchListView.model = reverseArr(props.snapStopwatchModel)
                if (JSON.stringify(props.snapStopwatchModel) != "[]") snapStopwatchListView.visible = true
                else snapStopwatchListView.visible = false
            }

            function reverseArr(input) {
                var ret = new Array;
                for(var i = input.length-1; i >= 0; i--) {
                    ret.push(input[i]);
                }
                return ret;
            }
        }//

        /// Called once time after on resume
        Component.onCompleted: {
            //Init
            props.snapStopwatchModel = StopwatchTimerService.captureModel
            snapStopwatchListView.model = props.reverseArr(props.snapStopwatchModel)
            if (JSON.stringify(props.snapStopwatchModel) != "[]") snapStopwatchListView.visible = true
            else snapStopwatchListView.visible = false
        }//

        /// Execute This Every This Screen Active/Visible
        executeOnPageVisible: QtObject {

            /// onResume
            Component.onCompleted: {
                //                    ////console.debug("StackView.Active");
                props.timerCount = Qt.binding(function(){ return StopwatchTimerService.count })
                props.timerStatus = Qt.binding( function() { return StopwatchTimerService.status })

                //Signal
                StopwatchTimerService.captureModelUpdated.connect(props.stopwatchCaptureModelUpdated)
            }

            /// onPause
            Component.onDestruction: {
                //////console.debug("StackView.DeActivating");
                //Signal
                StopwatchTimerService.captureModelUpdated.disconnect(props.stopwatchCaptureModelUpdated)
            }
        }//
    }//
}

/*##^##
Designer {
    D{i:0;autoSize:true;formeditorColor:"#808080";formeditorZoom:0.75;height:480;width:800}
}
##^##*/
