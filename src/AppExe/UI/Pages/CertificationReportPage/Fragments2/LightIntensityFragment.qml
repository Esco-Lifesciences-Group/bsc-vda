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
        anchors.fill: parent
        Rectangle{
            id: gridBackgroundRectangle
            Layout.fillHeight: true
            Layout.fillWidth: true
            Layout.margins: 5
            color: "#40000000"
            border.color: "#dddddd"
            radius: 5
            Column{
                anchors.horizontalCenter: parent.horizontalCenter
                spacing: 5
                TextApp{
                    id: textTitleGrid1
                    anchors.horizontalCenter: parent.horizontalCenter
                    text: qsTr("Light Intensity Nominal Condition")
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
                            columns: settings.lightIntNomGrid.length

                            signal clickedItem(int index, double value, string valSf)

                            Repeater{
                                id: gridRepeater
                                model: settings.lightIntNomGrid
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
                                                text: Number(modelData) === -1 ? "NA" : Number(modelData)
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
                                console.debug(index, value, valSf)
                                props.editIndex = index
                                textInput1.text = settings.lightIntNomGrid[index]
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
                            text: Number(settings.lightIntNomAvg) + " " + settings.lightIntUnit
                            font.bold: true
                            //padding: 5
                        }
                    }//
                }//

                ///////////

                TextApp{
                    id: textTitleGrid2
                    anchors.horizontalCenter: parent.horizontalCenter
                    text: qsTr("Ambient Light Intensity")
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
                            columns: settings.lightIntOffGrid.length

                            signal clickedItem(int index, double value, string valSf)

                            Repeater{
                                id: gridRepeater2
                                model: settings.lightIntOffGrid
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
                                                text: Number(modelData) === -1 ? "NA" : Number(modelData)
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
                                console.debug(index, value, valSf)
                                props.editIndex2 = index
                                textInput2.text = settings.lightIntOffGrid[index]
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
                            text: Number(settings.lightIntOffAvg) + " " + settings.lightIntUnit
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
                        text: qsTr("Net Light Intensity")
                        leftPadding: 10
                    }
                    TextApp{
                        width: 20
                        text: ":"
                    }
                    TextApp{
                        verticalAlignment: Text.AlignVCenter
                        text: "%1 %2".arg(settings.lightInt).arg(settings.lightIntUnit)
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
                        text: qsTr("Net light intensity shall average a minimum of <b>800 lux (74 ft-candles)</b>.")
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
                            text: settings.lightIntRes ? qsTr("Pass")
                                                         : qsTr("Fail")
                            color: settings.lightIntRes ? "green"
                                                          : "red"
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

    TextInput{
        id: textInput1
        visible: false
        onAccepted: {
            if(isNaN(text)) text = "-1"
            //if(Number(text) === 0) text = "-1"

            const val = Number(text)
            settings.lightIntNomGrid[props.editIndex] = val
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
            //if(Number(text) === 0) text = "-1"

            const val = Number(text)
            settings.lightIntOffGrid[props.editIndex2] = val
            gridLoader2.active = false
            gridLoader2.active = true
            props.updateOff()
        }
    }//

    Settings{
        id: settings
        category: "oneOfTen"
        property var lightIntNomGrid: [-1,-1,-1,-1,-1,-1,-1,-1,-1,-1]
        property var lightIntOffGrid: [-1,-1,-1,-1,-1,-1,-1,-1,-1,-1]
        property int lightIntNomAvg: 0
        property int lightIntOffAvg: 0
        property int lightInt: 0
        property bool lightIntRes: false
        property string lightIntUnit: MachineData.measurementUnit ? "ft-cd" : "Lux"

        onLightIntNomAvgChanged: {
            lightInt = lightIntNomAvg - lightIntOffAvg
        }
        onLightIntOffAvgChanged: {
            lightInt = lightIntNomAvg - lightIntOffAvg
        }
        onLightIntChanged: {
            const accVal = MachineData.measurementUnit ? 74 : 800
            lightIntRes = lightInt >= accVal
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
            const noOfCol = settings.lightIntNomGrid.length
            let noOfColActual = 0
            for(let i=0; i<noOfCol; i++){
                const val = Number(settings.lightIntNomGrid[i])
                if(Number(val) !== -1){
                    noOfColActual++
                    tempVal += Number(val)
                }
            }
            if(noOfColActual!=0)
                average = Math.round(tempVal/noOfColActual)
            else average = 0
            //console.debug("tempVal", tempVal, "noOfCol", noOfCol, "average", average)
            settings.lightIntNomAvg = average
            //console.debug("onNoiseLevelNomGridChanged", JSON.stringify(settings.noiseLevelNomGrid))
        }
        function updateOff(){
            let average = 0
            let tempVal = 0
            const noOfCol = settings.lightIntOffGrid.length
            let noOfColActual = 0
            for(let i=0; i<noOfCol; i++){
                const val = Number(settings.lightIntOffGrid[i])
                if(Number(val) !== -1){
                    noOfColActual++
                    tempVal += Number(val)
                }
            }
            if(noOfColActual!=0)
                average = Math.round(tempVal/noOfColActual)
            else average = 0
            //console.debug("tempVal", tempVal, "noOfCol", noOfCol, "average", average)
            settings.lightIntOffAvg = average
            //console.debug("onNoiseLevelOffGridChanged", JSON.stringify(settings.noiseLevelOffGrid))
        }
    }

    UtilsApp{
        id: utils
    }//

    Component.onCompleted: {
        settings.lightIntUnit = MachineData.measurementUnit ? "ft-cd" : "Lux"

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
