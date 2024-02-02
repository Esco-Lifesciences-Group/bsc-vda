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

ViewApp {
    id: viewApp
    title: "Certification Summary"

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
                    title: qsTr("Certification Summary")
                }
            }//

            /// BODY
            Item {
                id: bodyItem
                Layout.fillWidth: true
                Layout.fillHeight: true

                GridView{
                    id: menuGridView
                    //                        anchors.fill: parent
                    anchors.centerIn: parent
                    /// If model lest than 4, make it centerIn of parent
                    width: count < 4 ? (count * (parent.width / 4)) : parent.width
                    height: count < 4 ? parent.height / 2 : parent.height
                    cellWidth: parent.width / 4
                    cellHeight: count < 4 ? height : height / 2
                    clip: true
                    snapMode: GridView.SnapToRow
                    flickableDirection: GridView.AutoFlickIfNeeded

                    delegate: Item{
                        height: menuGridView.cellHeight
                        width: menuGridView.cellWidth
                        opacity:  iconMouseArea.pressed ? 0.5 : 1

                        ColumnLayout{
                            anchors.fill: parent
                            anchors.margins: 10
                            spacing: 0

                            //                            Rectangle {
                            //                                anchors.fill: parent
                            //                            }

                            Item {
                                id: picIconItem
                                Layout.fillHeight: true
                                Layout.fillWidth: true

                                //Rectangle{anchors.fill: parent}

                                Image {
                                    id: picIconImage
                                    source: modelData.micon ? modelData.micon : ""
                                    fillMode: Image.PreserveAspectFit
                                    anchors.fill: parent
                                }
                            }//

                            Item {
                                id: iconTextItem
                                Layout.minimumHeight: parent.height* 0.35
                                Layout.fillWidth: true

                                //                Rectangle{anchors.fill: parent}

                                Text {
                                    id: iconText
                                    text: modelData.mtitle ? modelData.mtitle : ""
                                    height: parent.height
                                    width: parent.width
                                    wrapMode: Text.WordWrap
                                    horizontalAlignment: Text.AlignHCenter
                                    verticalAlignment: Text.AlignTop
                                    color: "#dddddd"
                                    font.pixelSize: 20
                                }//
                            }//
                        }//

                        MouseArea{
                            id: iconMouseArea
                            anchors.fill: parent
                            onClicked: {
                                const intent = IntentApp.create(modelData.mlink,
                                                                {
                                                                    "fieldOrFull": modelData.fieldOrFull
                                                                })
                                finishView(intent)
                            }//
                        }//
                    }//

                    /// false = field calibration
                    /// true = factory calibration
                    model: [
                        {mtype         : "menu",
                            mtitle     : qsTr("Full Certification Summary"),
                            micon      : "qrc:/UI/Pictures/menu/cert_report_icon_full.png",
                            mlink      : "qrc:/UI/Pages/CertificationReportPage/CertificationReportPage.qml",
                            fieldOrFull: false,
                        },
                        {mtype         : "menu",
                            mtitle     : qsTr("1 of 10 Summary"),
                            micon      : "qrc:/UI/Pictures/menu/cert_report_1_10_icon.png",
                            mlink      : "qrc:/UI/Pages/CertificationReportPage/OneOfTenReportPage.qml",
                            fieldOrFull: true,
                        }
                    ]//
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
                    // border.color: "#e3dac9"
                    // border.width: 1
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

