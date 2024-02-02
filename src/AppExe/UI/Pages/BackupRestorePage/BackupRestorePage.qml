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
import Qt.labs.platform 1.0

import UI.CusCom 1.1
import "../../CusCom/JS/IntentApp.js" as IntentApp

import ModulesCpp.Machine 1.0

ViewApp {
    id: viewApp
    title: "Backup/Restore Database"

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
                    title: qsTr("Backup/Restore") + " - " + props.databaseSelectedStr
                }
            }

            /// BODY
            Item {
                id: bodyItem
                Layout.fillWidth: true
                Layout.fillHeight: true
                Column{
                    visible: !sorryText.visible
                    anchors.centerIn: parent
                    spacing: 30

                    Column{
                        anchors.horizontalCenter: parent.horizontalCenter
                        spacing: 10
                        TextApp{
                            anchors.horizontalCenter: parent.horizontalCenter
                            text: qsTr("Backup/Restore the database of %1").arg(props.databaseSelectedStr)
                            //font.bold: true
                        }
                    }//

                    Row{
                        anchors.horizontalCenter: parent.horizontalCenter
                        spacing: 80
                        Column{
                            spacing: 5
                            Image{
                                anchors.horizontalCenter: parent.horizontalCenter
                                opacity: backupMA.pressed ? 0.5 : 1
                                source: "qrc:/UI/Pictures/backup-icon.png"
                                MouseArea{
                                    id: backupMA
                                    anchors.fill: parent
                                    onClicked: {
                                        let fileSource = props.databaseLocation
                                        let date = new Date()
                                        let dateTimeStr = Qt.formatDateTime(date, "yyyyMMddhhmm")

                                        let folderName = "BackupDB_%1".arg(dateTimeStr)

                                        const intent = IntentApp.create("qrc:/UI/Pages/FileManagerUsbCopyPage/FileManagerUsbCopierPage.qml",
                                                                        {
                                                                            "sourceFilePath": fileSource,
                                                                            "dontRmFile": 1,
                                                                            "newFolder": folderName
                                                                        });
                                        startView(intent);
                                    }
                                }
                            }
                            TextApp{
                                anchors.horizontalCenter: parent.horizontalCenter
                                text: qsTr("Backup")
                            }
                        }
                        Column{
                            spacing: 5
                            Image{
                                opacity: restoreMA.pressed ? 0.5 : 1
                                anchors.horizontalCenter: parent.horizontalCenter
                                source: "qrc:/UI/Pictures/restore-icon.png"
                                MouseArea{
                                    id: restoreMA
                                    anchors.fill: parent
                                    onClicked: {
                                        const intent = IntentApp.create("qrc:/UI/Pages/BackupRestorePage/RestoreDatabaseFilePage.qml",
                                                                        {
                                                                            "dbName": props.databaseSelectedFileStr,
                                                                            "dbPath": props.databaseLocation,
                                                                            "name": props.databaseSelectedStr
                                                                        })
                                        startView(intent)
                                    }
                                }
                            }
                            TextApp{
                                anchors.horizontalCenter: parent.horizontalCenter
                                text: qsTr("Restore")
                            }
                        }
                    }
                }//
                TextApp{
                    id: sorryText
                    anchors.centerIn: parent
                    visible: !MachineData.getSbcCurrentSerialNumberKnown()
                    font.pixelSize: 24
                    text: qsTr("Sorry, this screen is currently unavailable!")
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
                    }//
                }//
            }//
        }//

        ///// Put all private property inside here
        ///// if none, please comment this block to optimize the code
        QtObject {
            id: props
            property var databaseList: [
                {"db": "bookingschedule.db",        "name": qsTr("Booking Schedule")},
                {"db": "datalog.db",                "name": qsTr("Data Log")},
                {"db": "alarmlog.db",               "name": qsTr("Alarm Log")},
                {"db": "eventlog.db",               "name": qsTr("Event Log")},
                {"db": "replaceablecomprecord.db",  "name": qsTr("Replaceable Components Record")},
                {"db": "systemmonitorlog.db",       "name": qsTr("System Monitor Log")},
                {"db": "usermanage.db",             "name": qsTr("User Accounts")}
            ]
            property var databaseSelected: []
            property string databaseSelectedStr: ""
            property string databaseSelectedFileStr: ""
            property string databaseLocation: ""
            //property string configLocation: StandardPaths.writableLocation(StandardPaths.ConfigLocation)
        }//

        /// One time executed after onResume
        Component.onCompleted: {
            //console.debug("Data location", props.dataLocation)
            //console.debug("Config location", props.configLocation)
        }//

        /// Execute This Every This Screen Active/Visible
        executeOnPageVisible: QtObject {

            /// onResume
            Component.onCompleted: {
                //////console.debug("StackView.Active");

                let extradata = IntentApp.getExtraData(intent)
                //console.debug("data", extradata['prevPage']);
                if(extradata['db'] !== undefined){
                    props.databaseSelected = []
                    for(const element of props.databaseList){
                        if(element["db"] === extradata['db']){
                            //console.debug("Selected Database is", JSON.stringify(element))
                            props.databaseSelected.push(element)
                            props.databaseSelectedStr = element["name"]
                            props.databaseSelectedFileStr = element["db"]
                            break
                        }
                    }

                    let appLocalDataLocation = StandardPaths.writableLocation(StandardPaths.AppLocalDataLocation)
                    let fileSource = appLocalDataLocation + "/%1".arg(props.databaseSelectedFileStr)
                    if (__osplatform__) {
                        /// linux
                        fileSource = fileSource.replace("file://", "")
                    }
                    else {
                        /// windows
                        fileSource = fileSource.replace("file:///C:", "c:")
                    }
                    props.databaseLocation = fileSource
                }//
                if(!props.databaseSelected.length){
                    //console.debug("Unknown selected database")
                }//
            }//

            /// onPause
            Component.onDestruction: {
                //////console.debug("StackView.DeActivating");
            }
        }//
    }//
}//
