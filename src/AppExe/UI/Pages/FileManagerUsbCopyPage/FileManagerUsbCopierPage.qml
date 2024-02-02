import QtQuick 2.12
import QtQuick.Layouts 1.0
import QtQuick.Controls 2.0

import Qt.labs.folderlistmodel 2.2

import UI.CusCom 1.1
import "../../CusCom/JS/IntentApp.js" as IntentApp

import ModulesCpp.UsbCopier 1.0
import ModulesCpp.Machine 1.0
import ModulesCpp.Utils 1.0

ViewApp {
    id: viewApp
    title: "USB Export"

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
                    title: qsTr("USB Export")
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
                                value: usbCopier.progressInPercent
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
                                elide: Text.ElideMiddle
                                font.pixelSize: 16
                                text: qsTr("From") + ": " + (props.sourceFileCount > 1 ? props.sourceFilePathList[props.listIndexToShow] : props.sourceFilePath)
                            }

                            TextApp {
                                id: destinationViewText
                                width: 300
                                //                                elide: Text.ElideMiddle
                                wrapMode: Text.WrapAtWordBoundaryOrAnywhere
                                font.pixelSize: 16
                                text: qsTr("To") + ": /" + (props.sourceFileCount > 1 ? props.destinationPathList[props.listIndexToShow] : props.destinationPath)
                            }
                        }
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
                            //rootFolder: "file:///" + MediaUSBStoragePath
                            //folder: "file://" + MediaUSBStoragePath
                            //                            showFiles: false

                            function goUp(){
                                // console.log(folder)
                                // console.log(rootFolder)
                                // console.log(parentFolder)

                                if (folder != rootFolder) {
                                    folder = parentFolder

                                    props.destinationPath = String(folder).replace("file://", "")
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
                                        color: "#e3dac9"
                                    }

                                    TextApp {
                                        Layout.fillHeight: true
                                        Layout.fillWidth: true
                                        leftPadding: 5
                                        verticalAlignment: Text.AlignVCenter

                                        text: qsTr("Select file destination")
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
                                border.color: "#e3dac9"

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
                                                source: fileIsDir ? "qrc:/UI/Pictures/fileIsDir"
                                                                  : "qrc:/UI/Pictures/file-icon"
                                            }

                                            TextApp {
                                                Layout.fillHeight: true
                                                Layout.fillWidth: true
                                                verticalAlignment: Text.AlignVCenter
                                                text: fileName
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
                                                if (fileIsDir) {
                                                    // console.log("fileURL: " + fileURL)
                                                    folderListModel.folder = fileURL
                                                    if (__osplatform__) {
                                                        /// linux
                                                        props.destinationPath = String(fileURL).replace("file://", "")
                                                    }
                                                    else {
                                                        /// windows
                                                        props.destinationPath = String(fileURL).replace("file:///", "")
                                                    }

                                                    let newFolder = ""
                                                    if(props.newFolder != ""){
                                                        newFolder = "%1/".arg(props.newFolder)
                                                    }

                                                    if(props.sourceFileCount > 1){
                                                        for(const fileName of props.sourceFileNameList){
                                                            props.destinationPathList.push(props.destinationPath + "/" + newFolder + fileName)
                                                        }
                                                    }
                                                    else{
                                                        props.destinationFilePath = props.destinationPath + "/" + newFolder + props.sourceFileName
                                                    }
                                                }//
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
                                props.confirmBackToClose()
                            }//
                        }//

                        ButtonBarApp {
                            width: 194
                            anchors.verticalCenter: parent.verticalCenter
                            anchors.right: parent.right

                            imageSource: "qrc:/UI/Pictures/checkicon.png"
                            text: qsTr("Save here")

                            onClicked: {
                                if (folderListModel.isNowRootFolder()){
                                    showDialogMessage(qsTr("USB Export"), qsTr("Please select valid destination!"), dialogAlert)
                                    return
                                }

                                progressBar.visible = true

                                if(props.newFolder != ""){
                                    /// Create new folder first
                                    let filePath = props.destinationFilePath
                                    let strToReplace = "%1/%2".arg(props.newFolder).arg(filePath.split("/")[filePath.split("/").length-1])

                                    let newFolderPath = filePath.replace(strToReplace, "")
                                    fileDirUtils.mkpath(newFolderPath + props.newFolder)
                                }

                                if(props.sourceFileCount > 1){
                                    usbCopier.copy(props.sourceFilePathList[props.listIndex], props.destinationPathList[props.listIndex])
                                    props.listIndex++
                                }
                                else{
                                    usbCopier.copy(props.sourceFilePath, props.destinationFilePath)
                                }
                            }//
                        }//
                    }//
                }//
            }//
        }//

        FileDirUtils {
            id: fileDirUtils
        }//

        USBCopier {
            id: usbCopier

            onFileHasRemoved:{
                timerToClosePage.start()
            }
            onFileHasCopied: {
                if(props.sourceFileCount > 1){
                    MachineAPI.insertEventLog(qsTr("User: Export file via USB (%1 to %2)").arg(props.sourceFilePathList[props.listIndex]).arg(props.destinationPathList[props.listIndex]))
                    //console.debug("@@@@@@", props.listIndex)
                    //console.debug("&&&&&&", props.test)
                    if(props.listIndex < props.sourceFileCount)
                    {
                        copy(props.sourceFilePathList[props.listIndex], props.destinationPathList[props.listIndex])
                        props.listIndex++
                    }else{
                        props.displayProcessCompleted()
                    }
                }
                else{
                    MachineAPI.insertEventLog(qsTr("User: Export file via USB (%1 to %2)").arg(props.sourceFilePath).arg(props.destinationFilePath))
                    props.displayProcessCompleted()
                }
            }//
        }//

        Timer{
            id: timerToClosePage
            interval: 100
            onTriggered: {
                if(props.backModeHome){
                    const intent = IntentApp.create("", {})
                    startRootView(intent)
                }else{
                    const intent = IntentApp.create(uri, {})
                    finishView(intent)
                }
            }
        }

        ///// Put all private property inside here
        ///// if none, please comment this block to optimize the code
        QtObject {
            id: props

            property bool backModeHome: false

            property string sourceFilePath: ""
            property string sourceFileName: ""
            property string destinationPath: ""
            property string destinationFilePath: ""
            property bool removeAfterCopy: true

            property int listIndex: 0
            property int listIndexToShow: 0
            property var sourceFilePathList:    []
            property var destinationPathList: []
            property var sourceFileNameList: []
            property int sourceFileCount: 1

            property string newFolder: ""

            onListIndexChanged: {
                if(listIndex < sourceFileCount)
                    listIndexToShow = listIndex
            }

            function showUsbEjectInstruction(){
                const bypass = false
                if(MachineData.usbDetectedList !== "" || bypass){
                    const text = qsTr("To safely remove your USB drive:")
                               + "<ul><li>"+ qsTr("Double tap on USB drive icon at Home screen:") + "</li><li>"
                               + qsTr("Select your USB drive.") + "</li></ul>"
                    showDialogMessage(qsTr("Remove USB Drive"),
                                      text,
                                      dialogInfo,
                                      function onCLosed(){
                                          if(props.removeAfterCopy){
                                              if(props.sourceFileCount > 1){
                                                  for(const path of props.sourceFilePathList){
                                                      usbCopier.remove(path);
                                                  }
                                              }else
                                                  usbCopier.remove(props.sourceFilePath)
                                          }else{
                                              timerToClosePage.start()
                                          }
                                      }, true, undefined, 5000)
                }//
                else{
                    //console.debug("Remove After Copy!")
                    if(props.removeAfterCopy){
                        console.debug("Remove After Copy!")
                        if(props.sourceFileCount > 1){
                            //console.debug("Remove After Copy!")
                            //console.debug("props.sourceFilePathList", props.sourceFilePathList)
                            for(const path of props.sourceFilePathList){
                                //console.debug("usbCopier.remove(path)")
                                usbCopier.remove(path);
                            }
                        }else{
                            usbCopier.remove(props.sourceFilePath)
                        }
                    }//
                    else{
                        timerToClosePage.start()
                    }
                }//
            }//
            function displayProcessCompleted(){
                showDialogMessage(qsTr("USB Export"),
                                  qsTr("File successfully copied."),
                                  dialogInfo)
            }//

            function confirmBackToClose(){
                props.backModeHome = false
                if(UserSessionService.roleLevel >= UserSessionService.roleLevelAdmin){
                    showUsbEjectInstruction()
                }
                else{
                    if(props.removeAfterCopy){
                        if(props.sourceFileCount > 1){
                            for(const path of props.sourceFilePathList){
                                usbCopier.remove(path);
                            }
                        }else
                            usbCopier.remove(props.sourceFilePath)
                    }
                    else
                        timerToClosePage.start()
                }//
            }//
            function confirmBackToCloseGoToHome(){
                props.backModeHome = true
                if(UserSessionService.roleLevel >= UserSessionService.roleLevelAdmin)
                    showUsbEjectInstruction()
                else{
                    if(props.removeAfterCopy){
                        if(props.sourceFileCount > 1){
                            for(const path of props.sourceFilePathList){
                                usbCopier.remove(path);
                            }
                        }else
                            usbCopier.remove(props.sourceFilePath)
                    }
                    else
                        timerToClosePage.start()
                }//
            }//
        }//

        /// One time executed after onResume
        Component.onCompleted: {
            /// override gesture swipe action
            /// basicly dont allow gesture shortcut to home page during calibration
            viewApp.fnSwipedFromLeftEdge = function(){
                props.confirmBackToClose()
            }//

            viewApp.fnSwipedFromBottomEdge = function(){
                props.confirmBackToCloseGoToHome()
            }//
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
                if(extraData['newFolder'] !== undefined){
                    props.newFolder = extraData['newFolder']
                }else{
                    props.newFolder = ""
                }

                props.sourceFilePath = _sourceFilePath
                props.sourceFilePathList = _sourceFilePathList

                //console.debug("props.sourceFilePathList", props.sourceFilePathList)

                if(count)
                    props.sourceFileCount = count

                let fileNameGet = _sourceFilePath.split("/")
                props.sourceFileName = fileNameGet[fileNameGet.length - 1]

                if(count > 1){
                    for(const pathName of _sourceFilePathList){
                        let fnameList = pathName.split("/")
                        props.sourceFileNameList.push(fnameList[fnameList.length - 1])
                    }
                }
                //console.log(props.sourceFileName)
            }//

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
