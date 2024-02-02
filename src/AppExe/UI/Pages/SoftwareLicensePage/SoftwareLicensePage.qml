/**
 *  Copyright (C) 2021 by ESCO Bintan Indonesia
 *  https://escoglobal.com
 *
 *  Author:
 *  - Ahmad Qodri
**/

import QtQuick 2.12
import QtQuick.Layouts 1.0
import QtQuick.Controls 2.7

import UI.CusCom 1.1
import "../../CusCom/JS/IntentApp.js" as IntentApp

import ModulesCpp.Machine 1.0
import ModulesCpp.FileReader 1.0

ViewApp {
    id: viewApp
    title: "About Software"

    background.sourceComponent: Item {}

    content.asynchronous: true
    content.sourceComponent: ContentItemApp {
        id: contentView
        height: viewApp.height
        width: viewApp.width

        /// just for development
        /// comment following line after release
        visible: true

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
                    title: qsTr("About Software")
                }
            }

            /// BODY
            Item {
                id: bodyItem
                Layout.fillWidth: true
                Layout.fillHeight: true
                Rectangle{
                    color: "#66000000"
                    anchors.fill: parent
                    radius: 5
                    border.width: 1
                    border.color: "#e3dac9"
                    z : -1
                }
                RowLayout {
                    anchors.fill: parent
                    anchors.margins: 5
                    spacing: 10
                    Item{
                        Layout.fillHeight: true
                        Layout.minimumWidth: 250
                        Column{
                            anchors.margins: 5
                            spacing: 10
                            Column{
                                TextApp{
                                    text: "OS version:"
                                    font.bold: true
                                    font.pixelSize: 16
                                }
                                TextApp{
                                    text: OSRevision
                                    font.pixelSize: 16
                                }
                            }//
                            Column{
                                TextApp{
                                    text: "Software version:"
                                    font.bold: true
                                    font.pixelSize: 16
                                }
                                TextApp{
                                    text: props.softwareProfile
                                    font.pixelSize: 16
                                }
                            }//
                            Column{
                                TextApp{
                                    text: "Software libraries:"
                                    font.bold: true
                                    font.pixelSize: 16
                                }
                                TextApp{
                                    text: props.softwareLibraries
                                    font.pixelSize: 16
                                }
                            }//
                        }//
                    }//
                    Rectangle{
                        Layout.fillHeight: true
                        Layout.minimumWidth: 1
                        color: "grey"
                    }
                    Flickable {
                        id: view
                        Layout.fillHeight: true
                        Layout.fillWidth: true
                        //anchors.fill: parent
                        //anchors.margins: 2
                        contentWidth: content.width
                        contentHeight: content.height
                        property real span : contentY + height
                        clip: true

                        flickableDirection: Flickable.VerticalFlick
                        ScrollBar.vertical: verticalScrollBar.scrollBar
                        TextApp {
                            id: content
                            width: parent.width
                            //height: parent.height
                            leftPadding: 100
                            topPadding: 10
                            rightPadding: 10
                            bottomPadding: 10
                            wrapMode: Text.WrapAnywhere
                            font.pixelSize: 16
                            text: props.textToDisplay1 + "\n\n\n" + props.textToDisplay2 //(use only LGPLv3)
                        }//
                    }//
                    ScrollBarApp {
                        id: verticalScrollBar
                        Layout.fillHeight: true
                        Layout.minimumWidth: 20
                        Layout.fillWidth: false
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
                    //border.color: "#e3dac9"
                    //border.width: 1
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

                        ButtonBarApp {
                            id: setButton
                            width: 194
                            visible: false
                            anchors.verticalCenter: parent.verticalCenter
                            anchors.right: parent.right

                            imageSource: "qrc:/UI/Pictures/checkicon.png"
                            text: qsTr("Next")

                            onClicked: {
                                //                                currentTimeZoneText.text = currentTimeZoneText.text + "AAAA-"
                                /// if this page called from welcome page
                                /// show this button to making more mantap
                                var intent = IntentApp.create(uri, {"welcomesetupdone": 1})
                                finishView(intent)
                            }//
                        }//
                    }//
                }//
            }//
        }//

        FileReader{
            id: lgpl3

            onFileOutputChanged: {
                props.textToDisplay1 = value;
            }

            Component.onCompleted: {
                setFilePath(":/UI/Pages/SoftwareLicensePage/LICENSE.LGPLv3")
                readFile()
            }
        }

        FileReader{
            id: gpl3

            onFileOutputChanged: {
                props.textToDisplay2 = value;
            }

            Component.onCompleted: {
                setFilePath(":/UI/Pages/SoftwareLicensePage/LICENSE.GPL3")
                readFile()
            }
        }

        FileReader{
            id: swLib

            onFileOutputChanged: {
                props.softwareLibraries = value;
            }

            Component.onCompleted: {
                setFilePath(":/UI/Pages/SoftwareLicensePage/LIBRARIES")
                readFile()
            }
        }

        ///// Put all private property inside here
        ///// if none, please comment this block to optimize the code
        QtObject {
            id: props

            property string textToDisplay1
            property string textToDisplay2
            property string softwareProfile: MachineData.getCertificationParametersStr(MachineAPI.CertifParamStr_cabinetModel)
                                             + " - "
                                             + (Qt.application.name + "-" + Qt.application.version)
            property string softwareLibraries: ""

        }//

        /// One time executed after onResume
        Component.onCompleted: {
            MachineAPI.setPropogateComposeEventGesture(true)
        }//
        Component.onDestruction: {
            MachineAPI.setPropogateComposeEventGesture(false)
        }//

        /// Execute This Every This Screen Active/Visible
        executeOnPageVisible: QtObject {
            /// onResume
            Component.onCompleted: {
                const extraData = IntentApp.getExtraData(intent)
                const thisOpenedFromWelcomePage = extraData["welcomesetup"] || false
                if(thisOpenedFromWelcomePage) {
                    setButton.visible = true

                    viewApp.enabledSwipedFromLeftEdge   = false
                    viewApp.enabledSwipedFromRightEdge  = false
                    viewApp.enabledSwipedFromBottomEdge = false
                }//
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
    D{i:0;autoSize:true;formeditorColor:"#4c4e50";height:480;width:800}
}
##^##*/
