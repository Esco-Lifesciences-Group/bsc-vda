import QtQuick 2.0
import QtQuick.Layouts 1.0
import QtQuick.Controls 2.0
import UI.CusCom 1.1
import Qt.labs.settings 1.1

import ModulesCpp.Machine 1.0

Item {
    id: control

    GridLayout {
        columns: 2
        columnSpacing: 0
        anchors.fill: parent
        Rectangle{
            id: gridBackgroundRectangle
            Layout.fillHeight: true
            Layout.fillWidth: true
            Layout.margins: 5
            color: "#40000000"
            border.color: "#dddddd"
            radius: 5
            clip: true
            Flickable {
                id: vibrationFlick
                height: contentCol.height > gridBackgroundRectangle.height
                        ? gridBackgroundRectangle.height - 10 : contentCol.height
                width: contentCol.width > gridBackgroundRectangle.width
                       ? gridBackgroundRectangle.width - 10 : contentCol.width
                clip: true
                contentHeight: contentCol.height
                contentWidth: contentCol.width
                ScrollBar.vertical: verticalScrollBar
                Column{
                    id: contentCol
                    anchors.horizontalCenter: parent.horizontalCenter
                    spacing: 5
                    CheckBoxApp{
                        //anchors.right: parent.right
                        width: 250
                        text: qsTr("Vibration test")
                        checked: settings.vibTestEn
                        onCheckedChanged: {
                            if(!props.initialFisnished) return
                            settings.vibTestEn = checked
                        }
                    }

                    TextApp{
                        id: textTitleGrid1
                        anchors.horizontalCenter: parent.horizontalCenter
                        text: qsTr("Actual vibration (cabinet on), 20 consecutive readings x 10^-5 m RMS Amplitude")
                    }
                    Flickable {
                        id: girdFlick
                        height: gridLoader.height > gridBackgroundRectangle.height
                                ? gridBackgroundRectangle.height - 10 : gridLoader.height
                        width: gridLoader.width > gridBackgroundRectangle.width
                               ? gridBackgroundRectangle.width - 10 : gridLoader.width
                        clip: true
                        contentHeight: gridLoader.height
                        contentWidth: gridLoader.width
                        anchors.horizontalCenter: parent.horizontalCenter

                        //ScrollBar.vertical: verticalScrollBar
                        ScrollBar.horizontal: horizontalScrollBar

                        /// GRID
                        Loader {
                            id: gridLoader
                            asynchronous: true
                            visible: status == Loader.Ready
                            active: false
                            sourceComponent:  Grid{
                                id: pointCalGrid
                                spacing: 2
                                rows: 2
                                columns: settings.vibNomGrid.length/2

                                signal clickedItem(int index, double value, string valSf)

                                Repeater{
                                    id: gridRepeater
                                    model: settings.vibNomGrid
                                    Rectangle{
                                        id: gridRect
                                        height: 80
                                        width: 100
                                        radius: 5
                                        color: "#7f8c8d"

                                        ColumnLayout{
                                            anchors.fill: parent
                                            spacing: 0

                                            Rectangle{
                                                id: boxHeaderRectangle
                                                Layout.fillWidth: true
                                                Layout.minimumHeight: 30
                                                color: "#2ecc71"

                                                Text{
                                                    id: titleTextApp
                                                    anchors.fill: parent
                                                    horizontalAlignment: Text.AlignHCenter
                                                    verticalAlignment: Text.AlignVCenter
                                                    text: "P-" + (index + 1)
                                                    font.pixelSize: 20
                                                    color: "#dddddd"
                                                }
                                            }

                                            Item {
                                                Layout.fillHeight: true
                                                Layout.fillWidth: true

                                                Text{
                                                    id: containtTextApp
                                                    anchors.fill: parent
                                                    horizontalAlignment: Text.AlignHCenter
                                                    verticalAlignment: Text.AlignVCenter
                                                    font.pixelSize: 32
                                                    text: Number(modelData) === -1 ? "NA" : Number(Number(modelData)/100).toFixed(2)
                                                    color: "#dddddd"
                                                    elide: Text.ElideRight
                                                }
                                            }
                                        }

                                        MouseArea{
                                            anchors.fill: parent
                                            onClicked: {
                                                //console.debug("Press")
                                                pointCalGrid.clickedItem(index, modelData, containtTextApp.text)
                                            }
                                        }
                                    }
                                }
                                onClickedItem: {
                                    //console.debug(index, value, valSf)
                                    props.editIndex = index
                                    textInput1.text = Number(Number(settings.vibNomGrid[index])/100).toFixed(2)
                                    KeyboardOnScreenCaller.openNumpad(textInput1, textTitleGrid1.text + " (P-%1)".arg(index + 1))
                                }//
                            }//
                        }//
                    }//
                    Rectangle{
                        id: horizontalScrollRectangle
                        height: 10
                        width: girdFlick.width
                        color: "transparent"
                        border.color: "#dddddd"
                        radius: 5
                        anchors.horizontalCenter: parent.horizontalCenter

                        /// Horizontal ScrollBar
                        ScrollBar {
                            id: horizontalScrollBar
                            anchors.fill: parent
                            orientation: Qt.Horizontal
                            policy: ScrollBar.AlwaysOn

                            contentItem: Rectangle {
                                implicitWidth: 0
                                implicitHeight: 5
                                radius: width / 2
                                color: "#dddddd"
                            }//
                        }//
                    }//

                    Column{
                        //spacing: 5
                        //anchors.bottom: parent.bottom
                        //anchors.bottomMargin: 10
                        Row{
                            spacing: 10
                            TextApp{
                                width: 200
                                verticalAlignment: Text.AlignVCenter
                                text: qsTr("Average")
                                leftPadding: 10
                            }
                            TextApp{
                                width: 20
                                text: ":"
                            }
                            TextApp{
                                id: textAvg
                                textFormat: Text.RichText
                                verticalAlignment: Text.AlignVCenter
                                text: (Number(settings.vibNomAvg) === -1 ? "NA"
                                                                         : (Number(settings.vibNomAvg)/100).toFixed(2))
                                      + " " + qsTr("x 10^-5 m RMS Amplitude")
                                font.bold: true
                                //padding: 5
                            }
                        }//
                    }//

                    ///////////

                    TextApp{
                        id: textTitleGrid2
                        anchors.horizontalCenter: parent.horizontalCenter
                        text: qsTr("Background vibration (cabinet off), 20 consecutive readings x 10^-5 m RMS Amplitude")
                    }
                    Flickable {
                        id: girdFlick2
                        height: gridLoader2.height > gridBackgroundRectangle.height
                                ? gridBackgroundRectangle.height - 10 : gridLoader2.height
                        width: gridLoader2.width > gridBackgroundRectangle.width
                               ? gridBackgroundRectangle.width - 10 : gridLoader2.width
                        clip: true
                        contentHeight: gridLoader2.height
                        contentWidth: gridLoader2.width
                        anchors.horizontalCenter: parent.horizontalCenter

                        //ScrollBar.vertical: verticalScrollBar2
                        ScrollBar.horizontal: horizontalScrollBar2

                        /// GRID
                        Loader {
                            id: gridLoader2
                            asynchronous: true
                            visible: status == Loader.Ready
                            active: false
                            sourceComponent:  Grid{
                                id: pointCalGrid2
                                spacing: 2
                                rows: 2
                                columns: settings.vibOffGrid.length/rows

                                signal clickedItem(int index, double value, string valSf)

                                Repeater{
                                    id: gridRepeater2
                                    model: settings.vibOffGrid
                                    Rectangle{
                                        id: gridRect2
                                        height: 80
                                        width: 100
                                        radius: 5
                                        color: "#7f8c8d"

                                        ColumnLayout{
                                            anchors.fill: parent
                                            spacing: 0

                                            Rectangle{
                                                id: boxHeaderRectangle2
                                                Layout.fillWidth: true
                                                Layout.minimumHeight: 30
                                                color: "#2ecc71"

                                                Text{
                                                    id: titleTextApp2
                                                    anchors.fill: parent
                                                    horizontalAlignment: Text.AlignHCenter
                                                    verticalAlignment: Text.AlignVCenter
                                                    text: "P-" + (index + 1)
                                                    font.pixelSize: 20
                                                    color: "#dddddd"
                                                }
                                            }

                                            Item {
                                                Layout.fillHeight: true
                                                Layout.fillWidth: true

                                                Text{
                                                    id: containtTextApp2
                                                    anchors.fill: parent
                                                    horizontalAlignment: Text.AlignHCenter
                                                    verticalAlignment: Text.AlignVCenter
                                                    font.pixelSize: 32
                                                    text: Number(modelData) === -1 ? "NA" : Number(Number(modelData)/100).toFixed(2)
                                                    color: "#dddddd"
                                                    elide: Text.ElideRight
                                                }
                                            }
                                        }

                                        MouseArea{
                                            anchors.fill: parent
                                            onClicked: {
                                                //console.debug("Press")
                                                pointCalGrid2.clickedItem(index, modelData, containtTextApp2.text)
                                            }
                                        }
                                    }
                                }
                                onClickedItem: {
                                    //console.debug(index, value, valSf)
                                    props.editIndex2 = index
                                    textInput2.text = Number(Number(settings.vibOffGrid[index])/100).toFixed(2)
                                    KeyboardOnScreenCaller.openNumpad(textInput2, textTitleGrid2.text + " (P-%1)".arg(index + 1))
                                }//
                            }//
                        }//
                    }//
                    Rectangle{
                        id: horizontalScrollRectangle2
                        height: 10
                        width: girdFlick2.width
                        color: "transparent"
                        border.color: "#dddddd"
                        radius: 5
                        anchors.horizontalCenter: parent.horizontalCenter

                        /// Horizontal ScrollBar
                        ScrollBar {
                            id: horizontalScrollBar2
                            anchors.fill: parent
                            orientation: Qt.Horizontal
                            policy: ScrollBar.AlwaysOn

                            contentItem: Rectangle {
                                implicitWidth: 0
                                implicitHeight: 5
                                radius: width / 2
                                color: "#dddddd"
                            }//
                        }//
                    }//
                    Column{
                        //spacing: 5
                        //anchors.bottom: parent.bottom
                        //anchors.bottomMargin: 10
                        Row{
                            spacing: 10
                            TextApp{
                                width: 200
                                verticalAlignment: Text.AlignVCenter
                                text: qsTr("Average")
                                leftPadding: 10
                            }
                            TextApp{
                                width: 20
                                text: ":"
                            }
                            TextApp{
                                id: textAvg2
                                textFormat: Text.RichText
                                verticalAlignment: Text.AlignVCenter
                                text: (Number(settings.vibOffAvg) === -1 ? "NA"
                                                                         : (Number(settings.vibOffAvg)/100).toFixed(2))
                                      + " " + qsTr("x 10^-5 m RMS Amplitude")
                                font.bold: true
                                //padding: 5
                            }
                        }//
                    }//

                    Row{
                        spacing: 10
                        TextApp{
                            width: 200
                            verticalAlignment: Text.AlignVCenter
                            text: qsTr("Net Vibration")
                            leftPadding: 10
                        }
                        TextApp{
                            width: 20
                            text: ":"
                        }
                        TextApp{
                            verticalAlignment: Text.AlignVCenter
                            text: "%1 %2".arg(Number(settings.vib) === -1 ? "NA"
                                                                          : (Number(settings.vib)/100).toFixed(2)).arg(qsTr("x 10^-5 m RMS Amplitude"))
                            font.bold: true
                            //padding: 5
                        }
                    }//

                    Row{
                        spacing: 10
                        TextApp{
                            id: accText
                            width: 200
                            text: qsTr("Acceptance")
                            leftPadding: 10
                        }
                        TextApp{
                            width: 20
                            text: ":"
                        }
                        TextApp{
                            id: accTextField
                            width: gridBackgroundRectangle.width - (accText.width + 40)
                            //padding: 10
                            textFormat: Text.RichText
                            text: qsTr("Maximum net vibration should not exceed 0.5 x 10-5 m RMS amplitude or 2 x 10-4 in RMS amplitude.")
                            wrapMode: Text.WordWrap
                            minimumPixelSize: 20
                        }
                    }//

                    Row{
                        spacing: 10
                        TextApp{
                            width: 200
                            verticalAlignment: Text.AlignVCenter
                            text: qsTr("Result")
                            leftPadding: 10
                            font.bold: true
                        }
                        TextApp{
                            width: 20
                            text: ":"
                        }
                        Rectangle {
                            id: textResultRect
                            color: "#e3dac9"
                            TextApp {
                                text: (settings.vib == -1) ? "NA"
                                                           : (settings.vibRes ? qsTr("Pass")
                                                                              : qsTr("Fail"))
                                color: (settings.vib == -1) ? "black"
                                                            : (settings.vibRes ? "green"
                                                                               : "red")
                                font.bold: true
                            }
                            radius: 2
                            width: childrenRect.width
                            height: childrenRect.height
                        }//
                    }//
                }//
            }//
        }//
        Rectangle{
            id: verticalScrollRectangle
            Layout.fillHeight: true
            Layout.minimumWidth: 10
            Layout.margins: 5
            //height: vibrationFlick.height
            //width: 10
            color: "transparent"
            border.color: "#dddddd"
            radius: 5
            //anchors.verticalCenter: parent.verticalCenter

            /// Vertical ScrollBar
            ScrollBar {
                id: verticalScrollBar
                anchors.fill: parent
                orientation: Qt.Vertical
                policy: ScrollBar.AlwaysOn

                contentItem: Rectangle {
                    implicitWidth: 5
                    implicitHeight: 20
                    radius: width / 2
                    color: "#dddddd"
                }//
            }//
        }//
    }//

    TextInput{
        id: textInput1
        visible: false
        onAccepted: {
            if(isNaN(text)) text = "-1"
            else if(Number(text) === 0) text = "-1"
            let val = -1
            if(Number(text) !== -1)
                val = Number(text)*100
            settings.vibNomGrid[props.editIndex] = val
            gridLoader.active = false
            gridLoader.active = true
            props.updateNom()
        }
    }//

    TextInput{
        id: textInput2
        visible: false
        onAccepted: {
            if(isNaN(text)) text = "-1"
            if(Number(text) === 0) text = "-1"
            let val = -1
            if(Number(text) !== -1)
                val = Number(text)*100
            settings.vibOffGrid[props.editIndex2] = val
            gridLoader2.active = false
            gridLoader2.active = true
            props.updateOff()
        }
    }//

    Settings{
        id: settings
        category: "oneOfTen"
        property var vibNomGrid: [-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1] //*100
        property var vibOffGrid: [-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1] //*100
        property var vibNomGridBup: [-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1] //*100
        property var vibOffGridBup: [-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1] //*100
        property int vibNomAvg: -1 //*100
        property int vibOffAvg: -1 //*100
        property int vib: -1 //*100
        property bool vibRes: false
        property bool vibTestEn: true

        onVibNomAvgChanged: {
            if(!props.initialFisnished) return
            vib = vibNomAvg - vibOffAvg
        }
        onVibOffAvgChanged: {
            if(!props.initialFisnished) return
            vib = vibNomAvg - vibOffAvg
        }
        onVibChanged: {
            if(!props.initialFisnished) return
            let accVal = MachineData.measurementUnit ? 2 : 0.50
            accVal *= 100
            vibRes = vib <= accVal
        }
        onVibTestEnChanged: {
            if(!props.initialFisnished) return
            if(!vibTestEn){
                vibNomGridBup = vibNomGrid
                vibOffGridBup = vibOffGrid
                vibNomGrid = [-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1]
                vibOffGrid = [-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1]
                vibNomAvg = -1
                vibOffAvg = -1
                vib = -1
            }else{
                vibNomGrid = vibNomGridBup
                vibOffGrid = vibOffGridBup
                props.updateNom()
                props.updateOff()
            }
        }
    }

    QtObject{
        id: props
        property bool initialFisnished: false
        property int editIndex: 0
        property int editIndex2: 0

        function updateNom(){
            let average = 0
            let tempVal = 0
            const noOfCol = settings.vibNomGrid.length
            let noOfColActual = 0
            for(let i=0; i<noOfCol; i++){
                const val = Number(settings.vibNomGrid[i])
                if(Number(val) !== -1){
                    noOfColActual++
                    tempVal += Number(val)
                }
            }
            if(noOfColActual!=0)
                average = Math.round(tempVal/noOfColActual)
            else average = 0
            //console.debug("tempVal", tempVal, "noOfCol", noOfCol, "average", average)
            settings.vibNomAvg = average
            //console.debug("onNoiseLevelNomGridChanged", JSON.stringify(settings.noiseLevelNomGrid))
        }
        function updateOff(){
            let average = 0
            let tempVal = 0
            const noOfCol = settings.vibOffGrid.length
            let noOfColActual = 0
            for(let i=0; i<noOfCol; i++){
                const val = Number(settings.vibOffGrid[i])
                if(Number(val) !== -1){
                    noOfColActual++
                    tempVal += Number(val)
                }
            }
            if(noOfColActual!=0)
                average = Math.round(tempVal/noOfColActual)
            else average = 0
            //console.debug("tempVal", tempVal, "noOfCol", noOfCol, "average", average)
            settings.vibOffAvg = average
            //console.debug("onNoiseLevelOffGridChanged", JSON.stringify(settings.noiseLevelOffGrid))
        }
    }

    UtilsApp{
        id: utils
    }//

    Component.onCompleted: {
        gridLoader.active = true
        gridLoader2.active = true

        props.initialFisnished = true
    }
}//

/*##^##
Designer {
    D{i:0;autoSize:true;height:480;width:640}
}
##^##*/
