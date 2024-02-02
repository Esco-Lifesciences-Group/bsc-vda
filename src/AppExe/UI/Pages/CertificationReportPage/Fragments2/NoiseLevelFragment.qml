import QtQuick 2.0
import QtQuick.Layouts 1.0
import QtQuick.Controls 2.0
import UI.CusCom 1.1
import Qt.labs.settings 1.1

import ModulesCpp.Machine 1.0

Item {
    id: control

    anchors.fill: parent

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
                    text: qsTr("Noise Level Reading at Nominal Condition")
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
                            columns: settings.noiseLevelNomGrid.length

                            signal clickedItem(int index, double value, string valSf)

                            Repeater{
                                id: gridRepeater
                                model: settings.noiseLevelNomGrid
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
                                                text: Number(Number(modelData)/10).toFixed(1)
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
                                textInput1.text = Number(Number(settings.noiseLevelNomGrid[index])/10).toFixed(1)
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
                            width: 160
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
                            text: Number(settings.noiseLevelNomAvg/10).toFixed(1) + " dBA"
                            font.bold: true
                            //padding: 5
                        }
                    }//
                }//

                ///////////

                TextApp{
                    id: textTitleGrid2
                    anchors.horizontalCenter: parent.horizontalCenter
                    text: qsTr("Ambient Noise Level - Fan Off")
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
                            columns: settings.noiseLevelOffGrid.length

                            signal clickedItem(int index, double value, string valSf)

                            Repeater{
                                id: gridRepeater2
                                model: settings.noiseLevelOffGrid
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
                                                text: Number(Number(modelData)/10).toFixed(1)
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
                                textInput2.text = Number(Number(settings.noiseLevelOffGrid[index])/10).toFixed(1)
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
                            width: 160
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
                            text: Number(settings.noiseLevelOffAvg/10).toFixed(1) + " dBA"
                            font.bold: true
                            //padding: 5
                        }
                    }//
                }//
                // Rectangle{
                //     anchors.horizontalCenter: parent.horizontalCenter
                //     width: girdFlick2.width
                //     height: 1
                //     color: "#dddddd"
                // }
                Row{
                    spacing: 10
                    Row{
                        spacing: 10
                        TextApp{
                            id: textDiff
                            height: 40
                            width: 160
                            verticalAlignment: Text.AlignVCenter
                            text: qsTr("Difference")
                            leftPadding: 10
                        }
                        TextApp{
                            height: 40
                            width: 20
                            verticalAlignment: Text.AlignVCenter
                            text: ":"
                        }
                        TextApp{
                            id: textFieldDiff
                            height: 40
                            verticalAlignment: Text.AlignVCenter
                            text: Number(settings.noiseLevelDiffNomOff/10).toFixed(1)
                            font.bold: true
                        }
                        TextApp{
                            height: 40
                            verticalAlignment: Text.AlignVCenter
                            text: "dBA"
                        }
                    }//
                    Rectangle{ width: 1; height: 40; color: "#dddddd"}
                    Row{
                        spacing: 10
                        TextApp{
                            id: textCorr
                            height: 40
                            width: 160
                            verticalAlignment: Text.AlignVCenter
                            text: qsTr("Correction Noise")
                            leftPadding: 10
                        }
                        TextApp{
                            height: 40
                            width: 20
                            verticalAlignment: Text.AlignVCenter
                            text: ":"
                        }
                        TextFieldApp{
                            id: textFieldCorr
                            width: 60
                            height: 40
                            //validator: IntValidator{}
                            text: Number(settings.noiseLevelCorr/10).toFixed(1)
                            onPressed: {
                                KeyboardOnScreenCaller.openNumpad(this, textCorr.text)
                            }//
                            onAccepted: {
                                settings.noiseLevelCorr = Number(text)*10
                            }//
                        }
                        TextApp{
                            height: 40
                            verticalAlignment: Text.AlignVCenter
                            text: "dBA"
                        }
                    }//
                    Rectangle{ width: 1; height: 40; color: "#dddddd"}
                    Row{
                        spacing: 10
                        TextApp{
                            id: textNoise
                            height: 40
                            width: 160
                            verticalAlignment: Text.AlignVCenter
                            text: qsTr("Noise Level")
                            leftPadding: 10
                        }
                        TextApp{
                            height: 40
                            width: 20
                            verticalAlignment: Text.AlignVCenter
                            text: ":"
                        }
                        TextApp{
                            id: textFieldNoise
                            height: 40
                            verticalAlignment: Text.AlignVCenter
                            text: Number(settings.noiseLevel/10).toFixed(1)
                            font.bold: true
                        }
                        TextApp{
                            height: 40
                            verticalAlignment: Text.AlignVCenter
                            text: "dBA"
                        }
                    }//
                }//

                Row{
                    spacing: 10
                    TextApp{
                        id: accText
                        width: 160
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
                        text: "---"
                        wrapMode: Text.WordWrap
                        minimumPixelSize: 20
                        states: [
                            State {
                                when: settings.noiseStd == "EN"
                                PropertyChanges {
                                    target: accTextField
                                    text: qsTr("The noise should not exceed 65 dBA (Based on EN12469:2000 standard).")
                                }
                            },
                            State {
                                when: settings.noiseStd == "NSF ETI"
                                PropertyChanges {
                                    target: accTextField
                                    text: qsTr("The noise shall not exceed 68 dBA (Based on NSF/ANSI 49 standard).")
                                }
                            },
                            State {
                                when: settings.noiseStd == "NSF"
                                PropertyChanges {
                                    target: accTextField
                                    text: qsTr("The noise shall not exceed 67 dBA (Based on NSF/ANSI 49 standard).")
                                }
                            },
                            State {
                                when: settings.noiseStd == "AUS"
                                PropertyChanges {
                                    target: accTextField
                                    text: qsTr("The noise should not exceed 65 dBA (Based on AS 1807.20.2000 standard).")
                                }
                            }
                        ]//
                    }
                }//

                Row{
                    spacing: 10
                    TextApp{
                        width: 160
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
                            text: settings.noiseLevelRes ? qsTr("Pass")
                                                         : qsTr("Fail")
                            color: settings.noiseLevelRes ? "green"
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
            const val = Number(text) * 10
            settings.noiseLevelNomGrid[props.editIndex] = val
            gridLoader.active = false
            gridLoader.active = true
            props.updateNom()
        }
    }//

    TextInput{
        id: textInput2
        visible: false
        onAccepted: {
            const val = Number(text) * 10
            settings.noiseLevelOffGrid[props.editIndex2] = val
            gridLoader2.active = false
            gridLoader2.active = true
            props.updateOff()
        }
    }//

    Settings{
        id: settings
        category: "oneOfTen"

        property string noiseStd: "NSF" //EN, NSF ETI, NSF, AUS

        property var noiseLevelNomGrid: [0,0,0,0,0,0,0,0,0,0] // *10
        property var noiseLevelOffGrid: [0,0,0,0,0,0,0,0,0,0] // *10
        property int noiseLevelNomAvg: 0 // *10
        property int noiseLevelOffAvg: 0 // *10
        property int noiseLevelDiffNomOff: 0 // *10
        property int noiseLevelCorr: 0 // *10 ->input from textfield
        property int noiseLevel: 0 // *10
        property bool noiseLevelRes: false // true = Pass

        onNoiseLevelCorrChanged: {
            props.calculateNoiseLevel(noiseLevelNomAvg, noiseLevelCorr)
        }
        onNoiseLevelChanged: {
            //console.debug("noiseLevel", noiseLevel)
            let result = true
            const val = noiseLevel
            if(noiseStd == "EN" || noiseStd == "AUS"){//<=65
                if(val > 650) result = false
            }else if(noiseStd == "NSF ETI"){//<=68
                if(val > 680) result = false
            }else{//<=67
                if(val > 670) result = false
            }//
            noiseLevelRes = result
        }//
    }//

    QtObject{
        id: props

        property bool initialFisnished: false
        property int editIndex: 0
        property int editIndex2: 0

        function calculateNoiseLevel(noiseNom, correction){
            //console.debug("noiseNom", noiseNom, "correction", correction)
            let noiseValue = noiseNom - correction
            //=IF((X13-I20)<=67,(X13-I20),ROUND((X13-I20),0))
            //X13 -> noiseNom
            //I20 -> correction
            if((noiseNom-correction) > 670){
                noiseValue = Math.round((noiseNom-correction)/10) * 10
            }//

            settings.noiseLevel = noiseValue
        }

        function updateNom(){
            let average = 0
            let tempVal = 0
            const noOfCol = settings.noiseLevelNomGrid.length
            for(let i=0; i<noOfCol; i++){
                tempVal += Number(settings.noiseLevelNomGrid[i])
            }
            average = Math.round(tempVal/noOfCol)
            //console.debug("tempVal", tempVal, "noOfCol", noOfCol, "average", average)
            settings.noiseLevelNomAvg = average
            settings.noiseLevelDiffNomOff = settings.noiseLevelNomAvg - settings.noiseLevelOffAvg
            props.calculateNoiseLevel(settings.noiseLevelNomAvg, settings.noiseLevelCorr)
            //console.debug("onNoiseLevelNomGridChanged", JSON.stringify(settings.noiseLevelNomGrid))
        }
        function updateOff(){
            let average = 0
            let tempVal = 0
            const noOfCol = settings.noiseLevelOffGrid.length
            for(let i=0; i<noOfCol; i++){
                tempVal += settings.noiseLevelOffGrid[i]
            }
            average = Math.round(tempVal/noOfCol)
            settings.noiseLevelOffAvg = average
            settings.noiseLevelDiffNomOff = settings.noiseLevelNomAvg - settings.noiseLevelOffAvg
            //console.debug("onNoiseLevelOffAvgChanged", JSON.stringify(settings.noiseLevelOffGrid))
        }

        Component.onCompleted: {
        }
    }//
    //    QtObject{
    //        id: props
    //        property bool initialFisnished: false

    //    }

    //    UtilsApp{
    //        id: utils
    //    }//

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
