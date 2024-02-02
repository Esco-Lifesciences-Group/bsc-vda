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
import Qt.labs.platform 1.0

import UI.CusCom 1.1
import "../../CusCom/JS/IntentApp.js" as IntentApp

import ModulesCpp.Machine 1.0
import ModulesCpp.Utils 1.0

ViewApp {
    id: viewApp
    title: "Screen Capture"

    background.sourceComponent: Rectangle {
        color: "#34495e"
    }

    content.asynchronous: true
    content.sourceComponent: ContentItemApp{
        id: contentView
        height: viewApp.height
        width: viewApp.width

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
                    title: qsTr("Screen Capture")
                }
            }

            /// BODY
            Item {
                id: bodyItem
                Layout.fillHeight: true
                Layout.fillWidth: true
                //                Row{
                //                    anchors.centerIn: parent
                //                    spacing: 5
                ColumnLayout{
                    anchors.fill: parent
                    Item{
                        Layout.fillHeight: true
                        Layout.fillWidth: true
                        Image {
                            id: getPicScreenImage
                            cache: false
                            anchors.fill: parent
                            height: bodyItem.height
                            fillMode: Image.PreserveAspectFit


                        }//
                    }//
                    Item{
                        Layout.minimumHeight: 60
                        Layout.fillWidth: true
                        TextApp{
                            width: parent.width
                            height: parent.height
                            padding: 10
                            text: qsTr("This captured screen will be saved until you export it.") + "<br>" + qsTr("Go back, you can continue to capture another screen and export them at the same time later.")
                            wrapMode: Text.WordWrap
                            horizontalAlignment: Text.AlignHCenter
                        }
                    }
                }//
                //                    Row{
                //                        anchors.verticalCenter: parent.verticalCenter
                //                        CheckBox{
                //                            //anchors.horizontalCenter: parent.horizontalCenter
                //                            width: 40
                //                        }
                //                        TextApp{
                //                            width: 80
                //                            //anchors.horizontalCenter: parent.horizontalCenter
                //                            text: qsTr("Include previous captured screens?")
                //                            minimumPixelSize: 20
                //                            wrapMode: Text.WordWrap
                //                        }
                //                    }
                //                }
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

                        Row{
                            spacing: 5
                            anchors.right: parent.right
                            anchors.verticalCenter: parent.verticalCenter
                            ButtonBarApp {
                                visible: ((__hwInfo__ !== MachineAPI.HardwareInfo_RPI_ZW) ? true : false)
                                width: 194

                                imageSource: "qrc:/UI/Pictures/bluetooth.png"
                                text: qsTr("Share via Bluetooth")

                                onClicked: {
                                    if(UserSessionService.roleLevel >= UserSessionService.roleLevelAdmin){
                                        if(props.fileCount > 1)
                                            props.showAskDialogToShare(props.bt)
                                        else
                                            props.shareVia(props.bt)
                                    }else{
                                        showDialogMessage(qsTr("Access Denied"), qsTr("You do not have permission to perform this action!"), dialogAlert)
                                    }
                                }//
                            }//
                            ButtonBarApp {
                                // x: 386
                                width: 194
                                // anchors.right: parent.right
                                // anchors.verticalCenter: parent.verticalCenter

                                imageSource: "qrc:/UI/Pictures/usbvia.png"
                                text: qsTr("Share via USB")

                                onClicked: {
                                    if(UserSessionService.roleLevel >= UserSessionService.roleLevelAdmin){
                                        if(props.fileCount > 1)
                                            props.showAskDialogToShare(props.usb)
                                        else
                                            props.shareVia(props.usb)
                                    }else{
                                        showDialogMessage(qsTr("Access Denied"), qsTr("You do not have permission to perform this action!"), dialogAlert)
                                    }
                                }//
                            }//
                        }//
                    }//
                }//
            }//
        }//

        FileDirUtils {
            id: fileDirUtils

            onAvailableFilesOnDir: {
                const appLocalDataLocation = StandardPaths.writableLocation(StandardPaths.AppLocalDataLocation) + "/ScreenCapture"

                props.fileCount = count

                for(let pathTemp of filenames){
                    pathTemp = appLocalDataLocation + "/%1".arg(pathTemp)
                    props.fileNames.push(pathTemp)
                }

                //console.debug(props.fileCount, props.fileNames, props.fileNames[0])
            }

            Component.onCompleted: {
                const appLocalDataLocation = StandardPaths.writableLocation(StandardPaths.AppLocalDataLocation) + "/ScreenCapture"
                let pathName = appLocalDataLocation
                if (__osplatform__) {
                    pathName = pathName.replace("file://", "")
                }
                else{
                    pathName = pathName.replace("file:///C:", "C:")
                }
                initAvailableFileOnDir(pathName)
            }
        }//

        ///// Put all private property inside here
        ///// if none, please comment this block to optimize the code
        QtObject {
            id: props

            property string pictureLink: ""
            property int fileCount: 0
            property var fileNames: []
            property bool multipleFiles: false

            readonly property int bt: 0
            readonly property int usb: 1


            function shareVia(via){
                let pictureSource = String(getPicScreenImage.source)
                let pictureSourceList = props.fileNames

                //const sourceFilePath = pictureSource.replace("file:///C:", "c:")
                //                if(__osplatform__){
                if(props.fileCount > 1 && props.multipleFiles){
                    let pictureTemp = []
                    for(const pictures of pictureSourceList){
                        if(__osplatform__)
                            pictureTemp.push(pictures.replace("file://", ""))
                        else{
                            let temp = pictures.replace("file:///C:", "c:")
                            temp = temp.replace("file:///c:", "c:")
                            pictureTemp.push(temp)
                        }
                    }
                    pictureSourceList = pictureTemp;
                }
                else{
                    if(__osplatform__)
                        pictureSource = pictureSource.replace("file://", "")
                    else{
                        pictureSource = pictureSource.replace("file:///C:", "c:")
                        pictureSource = pictureSource.replace("file:///c:", "c:")
                    }
                }//
                //                }
                //                else{
                //                    ///windows
                //                    pictureSource = pictureSource.replace("file:///C:", "c:")
                //                }

                const pageSource = via === bt ? "qrc:/UI/Pages/BluetoothFileTransfer/BluetoothFileTransfer.qml"
                                              : "qrc:/UI/Pages/FileManagerUsbCopyPage/FileManagerUsbCopierPage.qml"

                const intent = IntentApp.create(pageSource,
                                                {
                                                    "fileCount": props.multipleFiles ? props.fileCount : 1,
                                                    "sourceFilePath": pictureSource,
                                                    "sourceFilePathList": pictureSourceList
                                                });
                finishView(intent);
            }//

            function showAskDialogToShare(via){
                showDialogAsk(qsTr("Screen Capture"),
                              qsTr("Include the previous captured screens?"),
                              dialogInfo,
                              function onAccepted(){
                                  props.multipleFiles = true
                                  shareVia(via)
                              },
                              function onRejected(){
                                  shareVia(via)
                              },
                              function onClosed(){},
                              true,
                              5,
                              qsTr("YES"),
                              qsTr("NO")
                              )
            }
        }

        /// One time executed after onResume
        Component.onCompleted: {

        }//

        /// Execute This Every This Screen Active/Visible
        executeOnPageVisible:  QtObject {

            /// onResume
            Component.onCompleted: {
                //////console.debug("StackView.Active");
                const extradata = IntentApp.getExtraData(intent)

                const getpicture = extradata['filename'] || ""

                //console.debug(getpicture)

                props.pictureLink = getpicture

                getPicScreenImage.source = getpicture
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
    D{i:0;autoSize:true;height:480;width:800}
}
##^##*/
