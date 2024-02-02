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
import Qt.labs.folderlistmodel 2.2

import UI.CusCom 1.1
import "../../CusCom/JS/IntentApp.js" as IntentApp

import ModulesCpp.UsbCopier 1.0
import ModulesCpp.Machine 1.0
//import ModulesCpp.ImportExternalConfiguration 1.0

ViewApp {
    id: viewApp

    title: "USB Import"

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
                    title: qsTr("USB Import")
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
                        Layout.fillHeight: true
                        Layout.fillWidth: true
                        Column {
                            anchors.centerIn: parent
                            spacing: 5

                            Image {
                                anchors.horizontalCenter: parent.horizontalCenter
                                source: "qrc:/UI/Pictures/copy-thumbnail.png"
                            }

                            ProgressBar {
                                id: progressBar
                                anchors.horizontalCenter: parent.horizontalCenter
                                width: 300
                                height: 20
                                to: 100
                                value: usbCopier.progressInPercent
                                visible: false

                                background: Rectangle {
                                    implicitWidth: 300
                                    implicitHeight: 10
                                    color: "#effffd"
                                    radius: 2
                                    clip: true
                                }//

                                contentItem: Item {
                                    implicitWidth: 250
                                    implicitHeight: 10

                                    Rectangle {
                                        width: progressBar.visualPosition * parent.width
                                        height: parent.height
                                        radius: 2
                                        color: "#18AA00"
                                    }//

                                    Text {
                                        anchors.centerIn: parent
                                        text: progressBar.value + "%"
                                    }
                                }//
                            }//
                            TextApp {
                                id: sourceViewText
                                width: 300
                                //elide: Text.ElideMiddle
                                wrapMode: Text.WrapAtWordBoundaryOrAnywhere
                                font.pixelSize: 16
                                text: qsTr("From") + ": " + props.sourceFilePath
                            }

                            TextApp {
                                id: destinationViewText
                                width: 300
                                elide: Text.ElideMiddle
                                //wrapMode: Text.WrapAtWordBoundaryOrAnywhere
                                font.pixelSize: 16
                                text: qsTr("To") + ": " + props.destinationPath
                            }
                        }//
                    }//

                    Item {
                        Layout.fillHeight: true
                        Layout.fillWidth: true
                        enabled: !usbCopier.copying

                        /// Handle File and Directory Model
                        FolderListModel {
                            id: folderListModel
                            showDirs: true
                            showDirsFirst: true
                            nameFilters: [ props.fileFilter ]
                            //rootFolder: "file:///" + MediaUSBStoragePath
                            //folder: "file://" + MediaUSBStoragePath
                            //                            showFiles: false

                            function goUp(){
                                //                                console.log(folder)
                                //                                console.log(rootFolder)
                                //                                console.log(parentFolder)

                                if (folder != rootFolder) {
                                    folder = parentFolder

                                    props.sourcePath = String(folder).replace("file://", "")
                                }
                            }

                            function isNowRootFolder(){
                                return folder === rootFolder
                            }
                            Component.onCompleted: {
                                if (__osplatform__) {
                                    /// linux
                                    rootFolder = "file://" + MediaUSBStoragePath
                                    folder = rootFolder
                                }
                                else {
                                    /// windows
                                    rootFolder = "file:///" + MediaUSBStoragePath
                                    folder = rootFolder
                                }
                            }
                        }//

                        /// File-Manager Presentation

                        ColumnLayout {
                            anchors.fill: parent

                            Rectangle {
                                Layout.fillWidth: true
                                Layout.minimumHeight: 40
                                color:dstMouseArea.pressed ? "#000000" : /*"#55000000"*/"#1F95D7"
                                border.color: "white"
                                radius: 5

                                RowLayout {
                                    anchors.fill: parent
                                    spacing: 0

                                    Image {
                                        Layout.fillHeight: true
                                        Layout.maximumWidth: height
                                        source: "qrc:/UI/Pictures/up-side.png"
                                    }//

                                    Rectangle {
                                        Layout.fillHeight: true
                                        Layout.minimumWidth: 1
                                        color: "#effffd"
                                    }

                                    TextApp {
                                        Layout.fillHeight: true
                                        Layout.fillWidth: true
                                        leftPadding: 5
                                        verticalAlignment: Text.AlignVCenter

                                        text: qsTr("Select database file") + " (%1)".arg(props.fileFilter)
                                    }//
                                }//

                                MouseArea {
                                    id: dstMouseArea
                                    anchors.fill: parent
                                    onClicked: {
                                        folderListModel.goUp()
                                    }
                                }

                            }//

                            Rectangle {
                                Layout.fillHeight: true
                                Layout.fillWidth: true
                                radius: 5
                                color: "#55000000"
                                border.color: "#effffd"

                                ListView {
                                    id: fileManagerListView
                                    anchors.fill: parent

                                    clip: true
                                    model: folderListModel

                                    TextApp {
                                        anchors.centerIn: parent
                                        visible: fileManagerListView.count == 0
                                        text: qsTr("Empty")
                                    }//

                                    delegate: Item {
                                        height: 40
                                        width: fileManagerListView.width

                                        RowLayout {
                                            anchors.fill: parent
                                            spacing: 0

                                            Image {
                                                id: iconImage
                                                Layout.minimumHeight: 40
                                                Layout.minimumWidth: 40
                                                source: fileIsDir ? "qrc:/UI/Pictures/fileIsDir" : "qrc:/UI/Pictures/file-icon"
                                            }

                                            TextApp {
                                                Layout.fillHeight: true
                                                Layout.fillWidth: true
                                                verticalAlignment: Text.AlignVCenter
                                                text: fileName
                                                elide: Text.ElideRight
                                            }
                                            Item{
                                                visible: String(props.fileSelected) == String(fileName)
                                                Layout.minimumHeight: 40
                                                Layout.minimumWidth: 40
                                                Image {
                                                    id: selectedIcon
                                                    anchors.fill: parent
                                                    source: "qrc:/UI/Pictures/checkicon.png"
                                                }
                                            }
                                        }//

                                        Rectangle {
                                            anchors.bottom: parent.bottom
                                            height: 1
                                            width: parent.width
                                        }//

                                        MouseArea {
                                            anchors.fill: parent
                                            onClicked: {
                                                console.log("fileURL: " + fileUrl, "filename:", fileName)
                                                if (fileIsDir) {
                                                    folderListModel.folder = fileUrl
                                                }
                                                if (__osplatform__) {
                                                    /// linux
                                                    props.sourcePath = String(fileUrl).replace("file://", "")
                                                }
                                                else {
                                                    /// windows
                                                    props.sourcePath = String(fileUrl).replace("file:///", "")
                                                }
                                                props.sourceFilePath = props.sourcePath

                                                const extension = props.sourceFilePath.split('.').pop();

                                                if(extension === "db"){
                                                    props.fileSelected = fileName
                                                    importButton.visible = true
                                                }
                                                else
                                                    importButton.visible = false

                                                ////console.debug("sourceFilePath: " + props.sourceFilePath)
                                            }//
                                        }//
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
                    //                    border.color: "#effffd"
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
                                var intent = IntentApp.create(uri, {})
                                finishView(intent)
                            }
                        }//
                        ButtonBarApp {
                            id: importButton
                            visible: false
                            width: 194
                            anchors.verticalCenter: parent.verticalCenter
                            anchors.right: parent.right

                            imageSource: "qrc:/UI/Pictures/checkicon.png"
                            text: qsTr("Import")

                            onClicked: {
                                let re = /(?:\.([^.]+))?$/;
                                let extension = re.exec(props.sourceFilePath)[1]
                                //console.debug("Extension:", extension)

                                if (String(extension) != String("db")){
                                    showDialogMessage(qsTr("USB Import"), qsTr("Please select valid source file!"), dialogAlert)
                                    return
                                }

                                const message = qsTr("Are you sure you want to restore the %1 database with the selected database file?").arg(props.databaseSelectedStr)
                                viewApp.showDialogAsk(qsTr("Notification"),
                                                      message,
                                                      viewApp.dialogInfo,
                                                      function onAccepted(){
                                                          viewApp.showBusyPage(qsTr("Restoring..."), function onCallback(cycle){
                                                              if (cycle >= MachineAPI.BUSY_CYCLE_1){
                                                                  if(!progressBar.visible) progressBar.visible = true

                                                                  usbCopier.copy(props.sourceFilePath, props.destinationFilePath, false)
                                                                  viewApp.closeDialog()
                                                              }
                                                          })
                                                      }, function(){}, function(){}, true, 5)//

                            }//
                        }//
                    }//
                }//
            }//
        }//

        USBCopier {
            id: usbCopier

            onFileHasCopied: {
                MachineAPI.insertEventLog(qsTr("User: Import file via USB (%1 to %2)").arg(props.sourceFilePath).arg(props.destinationFilePath))
                let str = props.fileFilter
                MachineAPI.reInitializeLogger(str.replace(".db", ""))
                viewApp.showDialogMessage(qsTr("Import"),
                                          qsTr("A database of %1 has been restored.").arg(props.databaseSelectedStr),
                                          viewApp.dialogInfo,
                                          function onClosed(){
                                              var intent = IntentApp.create(uri, {"prevPage": "restore"})
                                              finishView(intent)
                                          },
                                          false)
            }//
        }//
        // ImportExternalConfiguration{
        //     id: importConfig
        // }//

        ///// Put all private property inside here
        ///// if none, please comment this block to optimize the code
        QtObject {
            id: props

            property string sourceFilePath: ""
            property string sourcePath: ""
            property string fileSelected: ""

            property string fileFilter: ""
            property string destinationPath: ""
            property string destinationFilePath: ""

            property string databaseSelectedStr: ""
        }//

        /// One time executed after onResume
        Component.onCompleted: {
        }//

        /// Execute This Every This Screen Active/Visible
        executeOnPageVisible: QtObject {

            /// onResume
            Component.onCompleted: {
                let extradata = IntentApp.getExtraData(intent)
                //console.debug("data", extradata['prevPage']);
                if(extradata['dbName'] !== undefined){
                    props.fileFilter = extradata['dbName']
                }//
                if(extradata['dbPath'] !== undefined){
                    let dbPath = extradata['dbPath']
                    props.destinationFilePath = dbPath
                    props.destinationPath = dbPath.replace("/%1".arg(props.fileFilter), "")
                }//
                if(extradata['name'] !== undefined){
                    props.databaseSelectedStr = extradata['name']
                }

                //console.debug("fileFilter", props.fileFilter)
                //console.debug("destinationPath", props.destinationPath)
                //console.debug("destinationFilePath", props.destinationFilePath)
            }//
            /// onPause
            Component.onDestruction: {
                //////console.debug("StackView.DeActivating");
            }
        }//
    }//
}//
