import QtQuick 2.0
import QtQuick.Layouts 1.0
import QtQuick.Controls 2.0
import Qt.labs.settings 1.1
import UI.CusCom 1.1
import ModulesCpp.Machine 1.0

import "../Components" as LocalComp

Item {
    id: control

    ColumnLayout {
        anchors.fill: parent

        Item {
            //            visible: fieldOrFull
            Layout.fillHeight: true
            Layout.fillWidth: true

            RowLayout {
                anchors.fill: parent

                Item {
                    Layout.fillWidth: false
                    Layout.minimumWidth: 200
                    Layout.fillHeight: true

                    Column {
                        spacing: 2

                        TextApp {
                            text: qsTr("Inflow Nominal")
                            font.bold: true
                        }//

                        TextApp {
                            //                            text: fieldOrFull ? qsTr("Duty cycle") + ": " + "<b>" + valueStrf + "</b>" : ""
                            text: qsTr("Duty cycle") + ": " + "<b>" + valueStrf + "</b>"

                            property string valueStrf: "0%"

                            Component.onCompleted: {
                                valueStrf = settings.ifaCalGridNomDcySec + "%"
                            }//
                        }//

                        TextApp {
                            text: qsTr("Total") + ": " + "<b>" + valueStrf + "</b>"

                            property string valueStrf: "0"

                            Component.onCompleted: {
                                const meaVel = MachineData.measurementUnit ?  "fpm" : "m/s"
                                let vel = (MachineData.measurementUnit ? settings.ifaCalGridNomTotSecImp : settings.ifaCalGridNomTotSec)
                                if(MachineData.measurementUnit) vel = (vel/100).toFixed()
                                else vel = (vel/100).toFixed(2)
                                valueStrf = vel + " " + meaVel
                            }//
                        }//

                        TextApp {
                            text: qsTr("Average") + ": " + "<b>" + valueStrf + "</b>"

                            property string valueStrf: "0"

                            Component.onCompleted: {
                                const meaVel = MachineData.measurementUnit ?  "fpm" : "m/s"
                                let vel = (MachineData.measurementUnit ? settings.ifaCalGridNomAvgSecImp : settings.ifaCalGridNomAvgSec)
                                if(MachineData.measurementUnit) vel = (vel/100).toFixed()
                                else vel = (vel/100).toFixed(2)
                                valueStrf = vel + " " + meaVel
                            }//
                        }//

                        TextApp {
                            text: qsTr("Velocity") + ": " + "<b>" + valueStrf + "</b>"

                            property string valueStrf: "0"

                            Component.onCompleted: {
                                const meaVel = MachineData.measurementUnit ?  "fpm" : "m/s"
                                let vel = (MachineData.measurementUnit ? settings.ifaCalGridNomVelSecImp : settings.ifaCalGridNomVelSec)
                                if(MachineData.measurementUnit) vel = (vel/100).toFixed()
                                else vel = (vel/100).toFixed(2)
                                valueStrf = vel + " " + meaVel
                            }//
                        }//
                    }//
                }//

                Item {
                    Layout.fillHeight: true
                    Layout.fillWidth: true

                    LocalComp.AirflowGridWrapper {
                        id: loaderIfaNomSecGrid
                        anchors.fill: parent
                        visibleHorizontalScroll: true
                        visibleVerticalScroll: true
                    }//

                    Loader {
                        active: props.gridCountNomSec == 0
                        anchors.centerIn: parent
                        sourceComponent:TextApp {
                            anchors.centerIn: parent
                            text: qsTr("NA")
                            font.pixelSize: 32
                            //                        visible: settings.ifaCalGridNomSec.length < 10 //make the setting overiten, don't do this
                        }//
                    }//
                }//
            }//
        }//

        Rectangle {
            Layout.fillWidth: true
            Layout.minimumHeight: 1
            Layout.fillHeight: false
            color: "#e3dac9"
        }//

        Item {
            //            visible: fieldOrFull
            Layout.fillHeight: true
            Layout.fillWidth: true

            RowLayout {
                anchors.fill: parent

                Item {
                    Layout.fillWidth: false
                    Layout.minimumWidth: 200
                    Layout.fillHeight: true

                    Column {
                        spacing: 2

                        TextApp {
                            text: qsTr("Inflow Minimum")
                            font.bold: true
                        }//

                        TextApp {
                            //                            text: fieldOrFull ? qsTr("Duty cycle") + ": " + "<b>" + valueStrf + "</b>" : ""
                            text: qsTr("Duty cycle") + ": " + "<b>" + valueStrf + "</b>"

                            property string valueStrf: "0%"

                            Component.onCompleted: {
                                valueStrf = settings.ifaCalGridMinDcySec + "%"
                            }//
                        }//

                        TextApp {
                            text: qsTr("Total") + ": " + "<b>" + valueStrf + "</b>"

                            property string valueStrf: "0"

                            Component.onCompleted: {
                                const meaVel = MachineData.measurementUnit ?  "fpm" : "m/s"
                                let vel = (MachineData.measurementUnit ? settings.ifaCalGridMinTotSecImp : settings.ifaCalGridMinTotSec)
                                if(MachineData.measurementUnit) vel = (vel/100).toFixed()
                                else vel = (vel/100).toFixed(2)
                                valueStrf = vel + " " + meaVel
                            }//
                        }//

                        TextApp {
                            text: qsTr("Average") + ": " + "<b>" + valueStrf + "</b>"

                            property string valueStrf: "0"

                            Component.onCompleted: {
                                const meaVel = MachineData.measurementUnit ?  "fpm" : "m/s"
                                let vel = (MachineData.measurementUnit ? settings.ifaCalGridMinAvgSecImp : settings.ifaCalGridMinAvgSec)
                                if(MachineData.measurementUnit) vel = (vel/100).toFixed()
                                else vel = (vel/100).toFixed(2)
                                valueStrf = vel + " " + meaVel
                            }//
                        }//

                        TextApp {
                            text: qsTr("Velocity") + ": " + "<b>" + valueStrf + "</b>"

                            property string valueStrf: "0"

                            Component.onCompleted: {
                                const meaVel = MachineData.measurementUnit ?  "fpm" : "m/s"
                                let vel = (MachineData.measurementUnit ? settings.ifaCalGridMinVelSecImp : settings.ifaCalGridMinVelSec)
                                if(MachineData.measurementUnit) vel = (vel/100).toFixed()
                                else vel = (vel/100).toFixed(2)
                                valueStrf = vel + " " + meaVel
                            }//
                        }//
                    }//
                }//

                Item {
                    Layout.fillHeight: true
                    Layout.fillWidth: true

                    LocalComp.AirflowGridWrapper {
                        id: loaderIfaMinSecGrid
                        anchors.fill: parent
                        visibleHorizontalScroll: true
                        visibleVerticalScroll: true
                    }//

                    Loader {
                        active: props.gridCountMinSec == 0
                        anchors.centerIn: parent
                        sourceComponent:TextApp {
                            anchors.centerIn: parent
                            text: qsTr("NA")
                            font.pixelSize: 32
                            //                        visible: settings.ifaCalGridNomSec.length < 10 //make the setting overiten, don't do this
                        }//
                    }//
                }//
            }//
        }//

        //        Rectangle {
        //            Layout.fillWidth: true
        //            Layout.minimumHeight: 1
        //            Layout.fillHeight: false
        //            color: "#e3dac9"
        //        }//

        //        Item {
        //            //            visible: fieldOrFull
        //            Layout.fillHeight: true
        //            Layout.fillWidth: true

        //            RowLayout {
        //                anchors.fill: parent

        //                Item {
        //                    Layout.fillWidth: false
        //                    Layout.minimumWidth: 200
        //                    Layout.fillHeight: true

        //                    Column {
        //                        spacing: 2

        //                        TextApp {
        //                            text: qsTr("Inflow Standby")
        //                            font.bold: true
        //                        }//

        //                        TextApp {
        //                            //                            text: fieldOrFull ? qsTr("Duty cycle") + ": " + "<b>" + valueStrf + "</b>" : ""
        //                            text: qsTr("Duty cycle") + ": " + "<b>" + valueStrf + "</b>"

        //                            property string valueStrf: "0%"

        //                            Component.onCompleted: {
        //                                valueStrf = settings.ifaCalGridStbDcySec + "%"
        //                            }//
        //                        }//

        //                        TextApp {
        //                            text: qsTr("Total") + ": " + "<b>" + valueStrf + "</b>"

        //                            property string valueStrf: "0"

        //                            Component.onCompleted: {
        //                                const meaVel = MachineData.measurementUnit ?  "fpm" : "m/s"
        //                                let vel = (MachineData.measurementUnit ? settings.ifaCalGridStbTotSecImp : settings.ifaCalGridStbTotSec)
        //                                if(MachineData.measurementUnit) vel = (vel/100).toFixed()
        //                                else vel = (vel/100).toFixed(2)
        //                                valueStrf = vel + " " + meaVel
        //                            }//
        //                        }//

        //                        TextApp {
        //                            text: qsTr("Average") + ": " + "<b>" + valueStrf + "</b>"

        //                            property string valueStrf: "0"

        //                            Component.onCompleted: {
        //                                const meaVel = MachineData.measurementUnit ?  "fpm" : "m/s"
        //                                let vel = (MachineData.measurementUnit ? settings.ifaCalGridStbAvgSecImp : settings.ifaCalGridStbAvgSec)
        //                                if(MachineData.measurementUnit) vel = (vel/100).toFixed()
        //                                else vel = (vel/100).toFixed(2)
        //                                valueStrf = vel + " " + meaVel
        //                            }//
        //                        }//

        //                        TextApp {
        //                            text: qsTr("Velocity") + ": " + "<b>" + valueStrf + "</b>"

        //                            property string valueStrf: "0"

        //                            Component.onCompleted: {
        //                                const meaVel = MachineData.measurementUnit ?  "fpm" : "m/s"
        //                                let vel = (MachineData.measurementUnit ? settings.ifaCalGridStbVelSecImp : settings.ifaCalGridStbVelSec)
        //                                if(MachineData.measurementUnit) vel = (vel/100).toFixed()
        //                                else vel = (vel/100).toFixed(2)
        //                                valueStrf = vel + " " + meaVel
        //                            }//
        //                        }//
        //                    }//
        //                }//

        //                Item {
        //                    Layout.fillHeight: true
        //                    Layout.fillWidth: true

        //                    LocalComp.AirflowGridWrapper {
        //                        id: loaderIfaStbSecGrid
        //                        anchors.fill: parent
        //                        visibleHorizontalScroll: true
        //                        visibleVerticalScroll: true
        //                    }//

        //                    Loader {
        //                        active: props.gridCountStbSec == 0
        //                        anchors.centerIn: parent
        //                        sourceComponent:TextApp {
        //                            anchors.centerIn: parent
        //                            text: qsTr("NA")
        //                            font.pixelSize: 32
        //                            //                        visible: settings.ifaCalGridStbSec.length < 10 //make the setting overiten, don't do this
        //                        }//
        //                    }//
        //                }//
        //            }//
        //        }//
    }//

    JsonStringifyWorkerApp {
        id: jsonStringify

        //        onEstablishedChanged: {
        //            console.log("onEstablishedChanged")
        //        }//

        onMessage: {
            //            //console.debug(JSON.stringify(messageObject))

            /* if(messageObject.id === "loaderIfaNomGrid"){
                const grid = messageObject.data || [{}]
                props.gridCountDim = grid.length
                console.log("gridCountDim: " + props.gridCountDim)
                loaderIfaNomGrid.loader.setSource("../Components/AirflowGrid.qml",
                                                  {
                                                      "measureUnit": MachineData.measurementUnit,
                                                      "columns": 5,
                                                      "model": grid,
                                                      "valueMinimum": 0,
                                                      "valueMaximum": 1000,
                                                  })
                //                console.log("Nominal grid")
                jsonStringify.s2j('loaderIfaNomSecGrid', settings.ifaCalGridNomSec)
            }
            else */
            if(messageObject.id === "loaderIfaNomSecGrid"){
                const grid = messageObject.data || [{}]
                //                console.log("grid-length:" + grid.length)
                //                console.log("grid:" + grid)
                props.gridCountNomSec = grid.length || 0
                console.log("gridCountNomSec: " + props.gridCountNomSec)
                loaderIfaNomSecGrid.loader.setSource("../Components/AirflowGrid.qml",
                                                     {
                                                         "measureUnit": MachineData.measurementUnit,
                                                         "columns": props.gridCountNomSec,
                                                         "model": grid,
                                                         "valueMinimum": 0,
                                                         "valueMaximum": 1000,
                                                     })
                jsonStringify.s2j('loaderIfaMinSecGrid', settings.ifaCalGridMinSec)
            }//
            else if(messageObject.id === "loaderIfaMinSecGrid"){
                const grid = messageObject.data || [{}]
                //                console.log("grid-length:" + grid.length)
                //                console.log("grid:" + grid)
                props.gridCountMinSec = grid.length || 0
                console.log("gridCountMinSec: " + props.gridCountMinSec)
                loaderIfaMinSecGrid.loader.setSource("../Components/AirflowGrid.qml",
                                                     {
                                                         "measureUnit": MachineData.measurementUnit,
                                                         "columns": props.gridCountMinSec,
                                                         "model": grid,
                                                         "valueMinimum": 0,
                                                         "valueMaximum": 1000,
                                                     })
                //                jsonStringify.s2j('loaderIfaStbSecGrid', settings.ifaCalGridStbSec)
            }//
            //            else if(messageObject.id === "loaderIfaStbSecGrid"){
            //                const grid = messageObject.data || [{}]
            //                //                console.log("grid-length:" + grid.length)
            //                //                console.log("grid:" + grid)
            //                props.gridCountStbSec = grid.length
            //                console.log("gridCountStbSec: " + props.gridCountStbSec)
            //                loaderIfaStbSecGrid.loader.setSource("../Components/AirflowGrid.qml",
            //                                                     {
            //                                                         "measureUnit": MachineData.measurementUnit,
            //                                                         "columns": props.gridCountStbSec,
            //                                                         "model": grid,
            //                                                         "valueMinimum": 0,
            //                                                         "valueMaximum": 1000,
            //                                                     })
            ////                jsonStringify.s2j('loaderIfaStbSecGrid', settings.ifaCalGridStbSec)
            //            }//
        }//
    }//

    QtObject {
        id: props

        //        property int gridCountDim: 0
        property int gridCountNomSec: 0
        property int gridCountMinSec: 0
        property int gridCountStbSec: 0
    }//

    QtObject {
        id: settings

        //        category: "afmeafield"
        property int calibMode: MachineAPI.CALIB_MODE_FIELD

        property string ifaCalGridNomSec        : MachineData.getIfaCalGridSec(calibMode, MachineAPI.INFLOW_GRID_NOMINAL)
        property int    ifaCalGridNomTotSec     : MachineData.getIfaCalGridTotSec(calibMode, MachineAPI.INFLOW_GRID_NOMINAL)
        property int    ifaCalGridNomAvgSec     : MachineData.getIfaCalGridAvgSec(calibMode, MachineAPI.INFLOW_GRID_NOMINAL)
        property int    ifaCalGridNomVelSec     : MachineData.getIfaCalGridVelSec(calibMode, MachineAPI.INFLOW_GRID_NOMINAL)
        property int    ifaCalGridNomTotSecImp  : MachineData.getIfaCalGridTotSecImp(calibMode, MachineAPI.INFLOW_GRID_NOMINAL)
        property int    ifaCalGridNomAvgSecImp  : MachineData.getIfaCalGridAvgSecImp(calibMode, MachineAPI.INFLOW_GRID_NOMINAL)
        property int    ifaCalGridNomVelSecImp  : MachineData.getIfaCalGridVelSecImp(calibMode, MachineAPI.INFLOW_GRID_NOMINAL)
        property int    ifaCalGridNomDcySec     : MachineData.getIfaCalGridDcySec(calibMode, MachineAPI.INFLOW_GRID_NOMINAL)

        property string ifaCalGridMinSec        : MachineData.getIfaCalGridSec(calibMode, MachineAPI.INFLOW_GRID_MINIMUM)
        property int    ifaCalGridMinTotSec     : MachineData.getIfaCalGridTotSec(calibMode, MachineAPI.INFLOW_GRID_MINIMUM)
        property int    ifaCalGridMinAvgSec     : MachineData.getIfaCalGridAvgSec(calibMode, MachineAPI.INFLOW_GRID_MINIMUM)
        property int    ifaCalGridMinVelSec     : MachineData.getIfaCalGridVelSec(calibMode, MachineAPI.INFLOW_GRID_MINIMUM)
        property int    ifaCalGridMinTotSecImp  : MachineData.getIfaCalGridTotSecImp(calibMode, MachineAPI.INFLOW_GRID_MINIMUM)
        property int    ifaCalGridMinAvgSecImp  : MachineData.getIfaCalGridAvgSecImp(calibMode, MachineAPI.INFLOW_GRID_MINIMUM)
        property int    ifaCalGridMinVelSecImp  : MachineData.getIfaCalGridVelSecImp(calibMode, MachineAPI.INFLOW_GRID_MINIMUM)
        property int    ifaCalGridMinDcySec     : MachineData.getIfaCalGridDcySec(calibMode, MachineAPI.INFLOW_GRID_MINIMUM)

        property string ifaCalGridStbSec        : MachineData.getIfaCalGridSec(calibMode, MachineAPI.INFLOW_GRID_STANDBY)
        property int    ifaCalGridStbTotSec     : MachineData.getIfaCalGridTotSec(calibMode, MachineAPI.INFLOW_GRID_STANDBY)
        property int    ifaCalGridStbAvgSec     : MachineData.getIfaCalGridAvgSec(calibMode, MachineAPI.INFLOW_GRID_STANDBY)
        property int    ifaCalGridStbVelSec     : MachineData.getIfaCalGridVelSec(calibMode, MachineAPI.INFLOW_GRID_STANDBY)
        property int    ifaCalGridStbTotSecImp  : MachineData.getIfaCalGridTotSecImp(calibMode, MachineAPI.INFLOW_GRID_STANDBY)
        property int    ifaCalGridStbAvgSecImp  : MachineData.getIfaCalGridAvgSecImp(calibMode, MachineAPI.INFLOW_GRID_STANDBY)
        property int    ifaCalGridStbVelSecImp  : MachineData.getIfaCalGridVelSecImp(calibMode, MachineAPI.INFLOW_GRID_STANDBY)
        property int    ifaCalGridStbDcySec     : MachineData.getIfaCalGridDcySec(calibMode, MachineAPI.INFLOW_GRID_STANDBY)

        Component.onCompleted: {
            //const jdata = {"hello": "hello", "world": "world"}
            //jsonStringify.s2j('loaderIfaStbGrid', ifaCalGridStb)

            jsonStringify.s2j('loaderIfaNomSecGrid', ifaCalGridNomSec)
            //            jsonStringify.s2j('loaderIfaNomSecGrid', ifaCalGridNomSec)
        }//
    }//
}//

/*##^##
Designer {
    D{i:0;autoSize:true;height:480;width:640}
}
##^##*/
