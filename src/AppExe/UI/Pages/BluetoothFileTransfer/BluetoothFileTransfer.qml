import QtQuick 2.12
import QtQuick.Layouts 1.0
import QtQuick.Controls 2.0

import QtBluetooth 5.12
import ModulesCpp.BluetoothTransfer 1.0
import Qt.labs.platform 1.0

import UI.CusCom 1.1
import "../../CusCom/JS/IntentApp.js" as IntentApp

import ModulesCpp.Machine 1.0

ViewApp {
    id: viewApp
    title: "Bluetooth File Transfer"

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
                    title: qsTr("Bluetooth File Transfer")
                }
            }

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
                                value: bluetoothTransfer.progress
                                visible: false

                                background: Rectangle {
                                    implicitWidth: 300
                                    implicitHeight: 10
                                    color: "#e3dac9"
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
                                elide: Text.ElideRight
                                font.pixelSize: 16
                                text: qsTr("File") + ": " + /*(props.sourceFileCount > 1 ? props.sourceFileNameList[props.listIndexToShow]
                                                                                       : */props.sourceFileName/*)*/
                                //Component.onCompleted: {
                                //    text = Qt.binding(function(){
                                //        let filename = props.sourceFileName
                                //        const index = props.listIndexToShow
                                //        if(props.sourceFileCount > 1){
                                //            filename = props.sourceFileNameList[index]
                                //        }
                                //        return qsTr("File") + ": " + filename
                                //    })
                                //}
                            }

                            TextApp {
                                id: destinationViewText
                                width: 300
                                //                                elide: Text.ElideMiddle
                                wrapMode: Text.WrapAtWordBoundaryOrAnywhere
                                font.pixelSize: 16
                                text: qsTr("To") + ": " + props.targetDeviceName
                            }//
                        }//

                        TextApp {
                            font.pixelSize: 11
                            anchors.bottom: parent.bottom
                            width: parent.width
                            wrapMode: Text.WrapAtWordBoundaryOrAnywhere
                            horizontalAlignment: Text.AlignHCenter
                            text: qsTr("Note: Successful file transfer to your device is NOT guaranteed. Only tested with few Devices. Ensure the Receive File option in the target device is activated. If any problem occurred, please use USB Transfer instead.")
                        }//
                    }//

                    Item {
                        Layout.fillHeight: true
                        Layout.fillWidth: true
                        //                        enabled: !usbCopier.copying

                        /// File-Manager Presentation

                        ColumnLayout {
                            anchors.fill: parent

                            Rectangle {
                                Layout.fillWidth: true
                                Layout.minimumHeight: 40
                                color: dstMouseArea.pressed ? "#000000" : /*"#55000000"*/(bluetoothDiscoveryModel.running ? "#27ae60" : "#1F95D7")
                                border.color: "white"
                                radius: 5

                                RowLayout {
                                    anchors.fill: parent
                                    spacing: 0

                                    TextApp {
                                        id: titleDevicesText
                                        Layout.fillHeight: true
                                        Layout.fillWidth: true
                                        leftPadding: 5
                                        verticalAlignment: Text.AlignVCenter

                                        text: qsTr("Available devices")

                                        states: [
                                            State {
                                                when: bluetoothDiscoveryModel.running
                                                PropertyChanges {
                                                    target: titleDevicesText
                                                    text: qsTr("Scanning...")
                                                }//
                                            }//
                                        ]
                                    }//

                                    Rectangle {
                                        Layout.fillHeight: true
                                        Layout.minimumWidth: 1
                                        color: "#e3dac9"
                                    }//

                                    Image {
                                        Layout.fillHeight: true
                                        Layout.maximumWidth: height
                                        source: "qrc:/UI/Pictures/scan-icon.png"
                                    }//
                                }//

                                MouseArea {
                                    id: dstMouseArea
                                    anchors.fill: parent
                                    onClicked: {
                                        if (bluetoothDiscoveryModel.running) return
                                        itemListModel.clear()

                                        bluetoothDiscoveryModel.running = false
                                        bluetoothDiscoveryModel.running = true
                                    }//
                                }//
                            }//

                            Rectangle {
                                Layout.fillHeight: true
                                Layout.fillWidth: true
                                radius: 5
                                color: "#55000000"
                                border.color: "#e3dac9"

                                /// Model Bluetooth Available Device
                                BluetoothDiscoveryModel {
                                    id: bluetoothDiscoveryModel
                                    discoveryMode: BluetoothDiscoveryModel.MinimalServiceDiscovery
                                    onErrorChanged: {
                                        if (error == BluetoothDiscoveryModel.NoError)
                                            lastErrorString = ""
                                        if (error == BluetoothDiscoveryModel.PoweredOffError)
                                            lastErrorString = qsTr("Bluetooth turned off")
                                        else
                                            lastErrorString = qsTr("Cannot find any device.")
                                    }

                                    property string lastErrorString: ""
                                    onLastErrorStringChanged: {
                                        console.log("lastErrorString: " + lastErrorString)
                                    }
                                    //onDeviceDiscovered: {
                                    //    console.debug("onDeviceDiscovered", device)
                                    //}
                                    onServiceDiscovered: {
                                        console.log("Found new service "
                                                    + service.deviceAddress
                                                    + " "
                                                    + service.deviceName
                                                    + " "
                                                    + service.serviceName
                                                    + " "
                                                    + service.serviceDescription)

                                        if (String(service.serviceName).includes("Object Push")){
                                            const profile = {
                                                "deviceName": service.deviceName,
                                                "deviceAddress": service.deviceAddress,
                                                "deviceService": service.serviceName
                                            }
                                            itemListModel.append(profile)
                                        }//
                                    }//

                                    //  onRunningChanged: {
                                    //      console.log("onRunningChanged: " + running)
                                    //      if (!running) {
                                    //          targetDevicesListView.model = []
                                    //          targetDevicesListView.model = props.objectPushServiceModel
                                    //      }
                                    //  }//
                                }//

                                ListView {
                                    id: targetDevicesListView
                                    anchors.fill: parent
                                    spacing: 2

                                    clip: true
                                    model: itemListModel
                                    //  model: props.objectPushServiceModel
                                    //  model: bluetoothDiscoveryModel


                                    //  TextApp {
                                    //      anchors.centerIn: parent
                                    //      visible: fileManagerListView.count == 0
                                    //      text: qsTr("Empty")
                                    //  }//

                                    delegate: Item {
                                        height: 60
                                        width: targetDevicesListView.width

                                        Item {
                                            anchors.fill: parent
                                            anchors.rightMargin: 5
                                            anchors.leftMargin: 5

                                            Rectangle {
                                                visible: itemMouseArea.pressed
                                                anchors.fill: parent
                                                color: "#000000"
                                            }//

                                            ColumnLayout {
                                                anchors.fill: parent
                                                spacing: 0

                                                TextApp {
                                                    id: bluetoothDevNameText
                                                    Layout.fillWidth: true
                                                    elide: Text.ElideRight
                                                    horizontalAlignment: Text.AlignHCenter
                                                    text: deviceName
                                                }//

                                                TextApp {
                                                    id: bluetoothDevAddressText
                                                    Layout.fillWidth: true
                                                    horizontalAlignment: Text.AlignHCenter
                                                    font.pixelSize: 14
                                                    color: "lightgray"
                                                    text: deviceAddress
                                                }//
                                            }//

                                            Rectangle {
                                                height: 1
                                                width: parent.width
                                                color: "#e3dac9"
                                                anchors.bottom: parent.bottom
                                            }//
                                        }//

                                        MouseArea {
                                            id: itemMouseArea
                                            anchors.fill: parent
                                            onClicked: {
                                                props.targetDeviceName = deviceName
                                                props.targetDeviceAddress = deviceAddress
                                                if(props.sourceFileCount > 1){
                                                    //console.debug("bluetoothTransfer.initTransferList")
                                                    bluetoothTransfer.initTransferList(deviceName, deviceAddress, props.sourceFilePathList)
                                                }
                                                else{
                                                    //console.debug("bluetoothTransfer.initTransfer")
                                                    bluetoothTransfer.initTransfer(deviceName, deviceAddress, props.sourceFilePath)
                                                }
                                            }//
                                        }//
                                    }//
                                }//

                                ListModel {
                                    id: itemListModel
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

        BluetoothTransfer {
            id: bluetoothTransfer

            onPairingStarted: {
                showBusyPage(qsTr("Pairing..."), function ignore(){})
            }//

            onPairingFinished: {
                closeDialog()
                if (paired){
                    showDialogMessage(qsTr(title), qsTr("The device has paired successfully."), dialogInfo)
                }
                else {
                    showDialogMessage(qsTr(title), qsTr("Pairing failed!"), dialogAlert)
                }
            }//

            onTranferFileStarted: {
                progressBar.visible = true
                closeDialog()
            }//
            onTranferFilesStarted: {
                let fileNameGet = String(fileName[fileName.length-1]).split("/")

                props.sourceFileName = String(fileNameGet[fileNameGet.length - 1])

                progressBar.visible = true
                closeDialog()
            }//

            onTranferFileFinished: {
                // enum TransferError {
                //     NoError = 0,
                //     UnknownError = 1,
                //     FileNotFoundError = 2,
                //     HostNotFoundError = 3,
                //     UserCanceledTransferError = 4,
                //     IODeviceNotReadableError = 5,
                //     ResourceBusyError = 6,
                //     SessionError = 7
                // };
                //console.debug("Error", error)
                if (complete) {
                    MachineAPI.insertEventLog(qsTr("User: Export file via Bluetooth (%1 to %2)").arg(props.sourceFilePath).arg(props.targetDeviceName))
                    showDialogMessage(qsTr(title), qsTr("File transfer is completed."), dialogInfo)
                }
                else {
                    if (error == 3) {
                        showDialogMessage(qsTr(title), qsTr("Connection problem, please try again later!"), dialogAlert)
                    }
                    else {
                        showDialogMessage(qsTr(title), qsTr("File transfer has failed."), dialogAlert)
                    }
                }
            }//
        }//

        ///// Put all private property inside here
        ///// if none, please comment this block to optimize the code
        QtObject {
            id: props

            property string sourceFilePath:     ""
            property string sourceFileName:     ""
            property string targetDeviceName:   ""
            property string targetDeviceAddress:""
            property bool removeAfterCopy: true

            property int listIndex: 0
            property int listIndexToShow: 0
            property var sourceFilePathList:  []
            property var destinationPathList: []
            property var sourceFileNameList:  []
            property int sourceFileCount: 1

            onListIndexChanged: {
                if(listIndex < sourceFileCount)
                    listIndexToShow = listIndex
            }
        }//

        /// One time executed after onResume
        Component.onCompleted: {

        }//
        Component.onDestruction: {
            if(props.removeAfterCopy){
                //console.debug("Component.onDestruction", props.sourceFilePath)
                if(props.sourceFileCount > 1){
                    for(const path of props.sourceFilePathList){
                        MachineAPI.deleteFileOnSystem(path);
                    }
                }else
                    MachineAPI.deleteFileOnSystem(props.sourceFilePath);
            }//
        }//

        /// Execute This Every This Screen Active/Visible
        executeOnPageVisible: QtObject {

            /// onResume
            Component.onCompleted: {
                //////console.debug("StackView.Active");
                const extraData = IntentApp.getExtraData(intent)
                const _sourceFilePath = extraData['sourceFilePath'] || ""
                const _sourceFilePathList = extraData['sourceFilePathList'] || []

                const _dontRmFile = extraData['dontRmFile'] || 0
                const count = extraData['fileCount'] || 0

                if(_dontRmFile){
                    props.removeAfterCopy = false
                }

                props.sourceFilePath = _sourceFilePath
                props.sourceFilePathList = _sourceFilePathList

                let fileNameGet = _sourceFilePath.split("/")
                props.sourceFileName = fileNameGet[fileNameGet.length - 1]

                if(count)
                    props.sourceFileCount = count

                if(count > 1){
                    for(const pathName of _sourceFilePathList){
                        let fnameList = pathName.split("/")
                        props.sourceFileNameList.push(fnameList[fnameList.length - 1])
                    }
                }
                //console.debug("props.sourceFileNameList", props.sourceFileNameList)
            }//

            /// onPause
            Component.onDestruction: {
                //////console.debug("StackView.DeActivating");
            }//
        }//
    }//
}//

/*##^##
Designer {
    D{i:0;autoSize:true;formeditorColor:"#4c4e50";height:480;width:800}
}
##^##*/
