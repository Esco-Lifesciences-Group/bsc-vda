/**
 *  Copyright (C) 2021 by ESCO Bintan Indonesia
 *  https://escoglobal.com
 *
 *  Author: Heri Cahyono
**/

import QtQuick 2.12
import QtQuick.Layouts 1.0
import QtQuick.Controls 2.0
import Qt.labs.settings 1.1
import Qt.labs.platform 1.0

import UI.CusCom 1.1
import "../../CusCom/JS/IntentApp.js" as IntentApp

import ModulesCpp.Machine 1.0

ViewApp {
    id: viewApp
    title: "1 of 10 Summary"

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
                    id: headerApp
                    anchors.fill: parent
                    title: qsTr("1 of 10 Summary")
                }
            }

            /// BODY
            Item {
                id: bodyItem
                Layout.fillWidth: true
                Layout.fillHeight: true

                Loader {
                    id: fragmentLoader
                    anchors.fill: parent
                    asynchronous: true
                    source: ""

                    // source: "Fragments/ProfileFragment.qml"
                    // source: "Fragments/MotorVerificationFragment.qml"
                    // source: "Fragments/ADCFragment.qml"
                    // source: "Fragments/DownflowGridFragment.qml"
                    // sourceComponent: /*profile*//*signComponent*//*motorControlVeficationComp*//*inflowComp*/downflowComp
                }//

                BusyIndicatorApp{
                    anchors.centerIn: parent
                    visible: fragmentLoader.status == Loader.Loading
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

                    RowLayout {
                        anchors.fill: parent
                        anchors.margins: 5

                        ButtonBarApp {
                            Layout.minimumWidth: 194
                            Layout.fillHeight: true
                            enabled: fragmentLoader.status == Loader.Ready
                            imageSource: "qrc:/UI/Pictures/back-step.png"
                            text: qsTr("Back")

                            onClicked: {
                                let index = pageIndexListView.currentIndex
                                index = index - 1
                                if(index>=0){
                                    const modelData = pageIndexListView.model
                                    fragmentLoader.setSource(modelData[index]["link"], {})

                                    pageIndexListView.currentIndex = index
                                }
                                else {
                                    const message = qsTr("Are you sure you want to close?")
                                    showDialogAsk(qsTr("1 of 10 Summary"), message, dialogAlert, function onAccepted(){
                                        timerToClose.start()
                                    })//
                                }//
                            }//
                        }//

                        Item {
                            Layout.fillHeight: true
                            Layout.fillWidth: true

                            ListView {
                                id: pageIndexListView
                                height: 50
                                //                                width: parent.width
                                width: Math.min(parent.width, ((childWidth + spacing) * count) - spacing)
                                anchors.right: parent.right
                                anchors.verticalCenter: parent.verticalCenter
                                orientation: ListView.Horizontal
                                spacing: 5
                                clip: true
                                snapMode: ListView.SnapToItem
                                preferredHighlightBegin: (pageIndexListView.width / 2) - 75
                                preferredHighlightEnd: (pageIndexListView.width / 2) + 75
                                highlightRangeMode: ListView.ApplyRange
                                // layoutDirection: Qt.RightToLeft

                                // model: [
                                //     {"title": qsTr("Model"),                "link": "Fragments/ProfileFragment.qml"},
                                //     {"title": qsTr("Motor Verification"),   "link": "Fragments/MotorVerificationFragment.qml"},
                                //     {"title": qsTr("Inflow"),               "link": "Fragments/InflowGridFragment.qml"},
                                //     {"title": qsTr("Downflow"),             "link": "Fragments/DownflowGridFragment.qml"},
                                //     {"title": qsTr("ADC"),                  "link": "Fragments/ADCFragment.qml"},
                                //     {"title": qsTr("Tester"),               "link": "Fragments/TesterFragment.qml"},
                                //     {"title": qsTr("Send"),                 "link": "Fragments/SendTestReportFragment.qml"},
                                //     {"title": qsTr("Export"),               "link": "Fragments/ExportFragment.qml"},
                                // ]

                                property int childWidth: 150

                                delegate: Rectangle {
                                    radius: 5
                                    height: 50
                                    color: pageIndexListView.currentIndex == index ? "#27ae60" : "#7f8c8d"
                                    width: pageIndexListView.childWidth

                                    TextApp {
                                        anchors.fill: parent
                                        horizontalAlignment: Text.AlignHCenter
                                        verticalAlignment: Text.AlignVCenter
                                        wrapMode: Text.WordWrap
                                        //                                        text: index
                                        text: modelData["title"]
                                    }//

                                    MouseArea {
                                        anchors.fill: parent
                                        onClicked: {
                                            fragmentLoader.setSource(modelData["link"], {})
                                            //                                            fragmentLoader.source = modelData["link"]
                                            pageIndexListView.currentIndex = index

                                        }//
                                    }//
                                }//
                            }//
                        }//

                        ButtonBarApp {
                            Layout.minimumWidth: 194
                            Layout.fillHeight: true
                            enabled: (pageIndexListView.currentIndex != (pageIndexListView.count - 1)
                                      && fragmentLoader.status == Loader.Ready)
                            opacity: enabled ? 1 : 0.5

                            imageSource: "qrc:/UI/Pictures/next-step.png"
                            text: qsTr("Next")

                            onClicked: {
                                let index = pageIndexListView.currentIndex
                                index = index + 1
                                if (index < pageIndexListView.count ) {
                                    const modelData = pageIndexListView.model
                                    fragmentLoader.setSource(modelData[index]["link"], {})
                                    //                                            fragmentLoader.source = modelData["link"]
                                    pageIndexListView.currentIndex = index
                                }
                            }//
                        }//
                    }//
                }//
            }//
        }//
        Timer{
            id: timerToClose
            running: false
            repeat: false
            interval: 100
            onTriggered: {
                props.exit()
            }
        }
        Settings {
            id: settings
            category: "certification"

            Component.onCompleted: {
            }//

            /// Call this when this page session closed
            Component.onDestruction: {

            }//
        }//

        /// Put all private property inside here
        /// if none, please comment this block to optimize the code
        //        QtObject {
        //            id: props
        //        }

        QtObject{
            id: props
            function exit(){
                let intent = IntentApp.create(uri, {})
                finishView(intent)
            }
        }

        /// called Once but after onResume
        Component.onCompleted: {
            const extradata = IntentApp.getExtraData(intent)

            pageIndexListView.model = [
                        {"title": qsTr("Profile"),           "link": "Fragments2/ProfileFragment.qml"},
                        {"title": qsTr("Noise Level"),       "link": "Fragments2/NoiseLevelFragment.qml"},
                        {"title": qsTr("Light Intensity"),   "link": "Fragments2/LightIntensityFragment.qml"},
                        {"title": qsTr("Vibration"),         "link": "Fragments2/VibrationFragment.qml"},
                        {"title": qsTr("Print"),             "link": "Fragments2/SendReportFragment.qml"},
                        {"title": qsTr("Export"),            "link": "Fragments2/ExportFragment.qml"}
                    ]

            fragmentLoader.setSource("Fragments2/ProfileFragment.qml", {})

        }//

        /// Execute This Every This Screen Active/Visible
        executeOnPageVisible: QtObject {

            /// onResume
            Component.onCompleted: {
                //                    ////console.debug("StackView.Active");
                MachineAPI.refreshAirflowCalibrationGrid()
            }

            /// onPause
            Component.onDestruction: {
                //////console.debug("StackView.DeActivating");
            }
        }//
    }//
}//

/*##^##
Designer {
    D{i:0;autoSize:true;formeditorColor:"#4c4e50";formeditorZoom:0.66;height:600;width:1024}
}
##^##*/
