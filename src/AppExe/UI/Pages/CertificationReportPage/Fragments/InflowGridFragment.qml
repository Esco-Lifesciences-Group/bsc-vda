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
                            width: 200
                            text: qsTr("Inflow Nominal")
                            font.bold: true
                        }//

                        TextApp {
                            width: 200
                            text: qsTr("Duty cycle") + ": " + "<b>" + valueStrf + "</b>"

                            property string valueStrf: "0%"

                            Component.onCompleted: {
                                valueStrf = settings.ifaCalGridNomDcy + "%"
                            }//
                        }//

                        TextApp {
                            width: 200
                            text: qsTr("Total") + ": " + "<b>" + valueStrf + "</b>"

                            property string valueStrf: "0"

                            Component.onCompleted: {
                                const meaVol = MachineData.measurementUnit ? "cfm" : "l/s"
                                valueStrf = (MachineData.measurementUnit ? settings.ifaCalGridNomTotImp : settings.ifaCalGridNomTot) + " " + meaVol

                            }//
                        }//

                        TextApp {
                            width: 200
                            text: qsTr("Average") + ": " + "<b>" + valueStrf + "</b>"

                            property string valueStrf: "0"

                            Component.onCompleted: {
                                const meaVol = MachineData.measurementUnit ? "cfm" : "l/s"
                                valueStrf = (MachineData.measurementUnit ? settings.ifaCalGridNomAvgImp : settings.ifaCalGridNomAvg) + " " + meaVol

                            }//
                        }//

                        TextApp {
                            width: 200
                            text: qsTr("Velocity") + ": " + "<b>" + valueStrf + "</b>"

                            property string valueStrf: "0"

                            Component.onCompleted: {
                                const meaVel = MachineData.measurementUnit ? "fpm" : "m/s"
                                let vel = (MachineData.measurementUnit ? settings.ifaCalGridNomVelImp : settings.ifaCalGridNomVel)
                                if(MachineData.measurementUnit) vel = (vel/100).toFixed()
                                else vel = (vel/100).toFixed(2)
                                valueStrf = vel + " " + meaVel

                            }//
                        }//
                    }//
                }

                Item {
                    Layout.fillHeight: true
                    Layout.fillWidth: true

                    LocalComp.AirflowGridWrapper {
                        id: loaderIfaNomGrid
                        anchors.fill: parent
                        visibleHorizontalScroll: false
                        visibleVerticalScroll: false
                    }//
                    Loader {
                        active: props.gridCountNom == 0
                        anchors.centerIn: parent
                        sourceComponent:TextApp {
                            anchors.centerIn: parent
                            text: qsTr("NA")
                            font.pixelSize: 32
                            //                        visible: settings.ifaCalGridStbSec.length < 10 //make the setting overiten, don't do this
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
                            width: 200
                            text: qsTr("Inflow Minimum")
                            font.bold: true
                        }//

                        TextApp {
                            width: 200
                            text: qsTr("Duty cycle") + ": " + "<b>" + valueStrf + "</b>"

                            property string valueStrf: "0%"

                            Component.onCompleted: {
                                valueStrf = settings.ifaCalGridMinDcy + "%"
                            }//
                        }//

                        TextApp {
                            width: 200
                            text: qsTr("Total") + ": " + "<b>" + valueStrf + "</b>"

                            property string valueStrf: "0"

                            Component.onCompleted: {
                                const meaVol = MachineData.measurementUnit ? "cfm" : "l/s"
                                valueStrf = (MachineData.measurementUnit ? settings.ifaCalGridMinTotImp : settings.ifaCalGridMinTot) + " " + meaVol
                            }//
                        }//

                        TextApp {
                            width: 200
                            text: qsTr("Average") + ": " + "<b>" + valueStrf + "</b>"

                            property string valueStrf: "0"

                            Component.onCompleted: {
                                const meaVol = MachineData.measurementUnit ?  "cfm" : "l/s"
                                valueStrf = (MachineData.measurementUnit ? settings.ifaCalGridMinAvgImp : settings.ifaCalGridMinAvg) + " " + meaVol

                            }//
                        }//

                        TextApp {
                            width: 200
                            text: qsTr("Velocity") + ": " + "<b>" + valueStrf + "</b>"

                            property string valueStrf: "0"

                            Component.onCompleted: {
                                const meaVel = MachineData.measurementUnit ?  "fpm" : "m/s"
                                let vel = (MachineData.measurementUnit ? settings.ifaCalGridMinVelImp : settings.ifaCalGridMinVel)
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
                        id: loaderIfaMinGrid
                        anchors.fill: parent
                        visibleHorizontalScroll: false
                        visibleVerticalScroll: false
                    }//
                    Loader {
                        active: props.gridCountMin == 0
                        anchors.centerIn: parent
                        sourceComponent:TextApp {
                            anchors.centerIn: parent
                            text: qsTr("NA")
                            font.pixelSize: 32
                            //visible: settings.ifaCalGridStbSec.length < 10 //make the setting overiten, don't do this
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
        }

        Item {
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
                            width: 200
                            text: qsTr("Inflow Standby")
                            font.bold: true
                        }

                        TextApp {
                            width: 200
                            text: qsTr("Duty cycle") + ": " + "<b>" + valueStrf + "</b>"

                            property string valueStrf: "0%"

                            Component.onCompleted: {
                                valueStrf = settings.ifaCalGridStbDcy + "%"
                            }//
                        }//

                        TextApp {
                            width: 200
                            text: qsTr("Total") + ": " + "<b>" + valueStrf + "</b>"

                            property string valueStrf: "0"

                            Component.onCompleted: {
                                const meaVol = MachineData.measurementUnit ? "cfm" : "l/s"
                                valueStrf = (MachineData.measurementUnit ? settings.ifaCalGridStbTotImp : settings.ifaCalGridStbTot) + " " + meaVol
                            }
                        }

                        TextApp {
                            width: 200
                            text: qsTr("Average") + ": " + "<b>" + valueStrf + "</b>"

                            property string valueStrf: "0"

                            Component.onCompleted: {
                                const meaVol = MachineData.measurementUnit ? "cfm" : "l/s"
                                valueStrf = (MachineData.measurementUnit ? settings.ifaCalGridStbAvgImp : settings.ifaCalGridStbAvg) + " " + meaVol
                            }
                        }

                        TextApp {
                            width: 200
                            text: qsTr("Velocity") + ": " + "<b>" + valueStrf + "</b>"

                            property string valueStrf: "0"

                            Component.onCompleted: {
                                const meaVel = MachineData.measurementUnit ? "fpm" : "m/s"
                                let vel = (MachineData.measurementUnit ? settings.ifaCalGridStbVelImp : settings.ifaCalGridStbVel)
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
                        id: loaderIfaStbGrid
                        anchors.fill: parent
                        visibleHorizontalScroll: false
                        visibleVerticalScroll: false
                    }//
                    Loader {
                        active: props.gridCountStb == 0
                        anchors.centerIn: parent
                        sourceComponent:TextApp {
                            anchors.centerIn: parent
                            text: qsTr("NA")
                            font.pixelSize: 32
                            //                        visible: settings.ifaCalGridStbSec.length < 10 //make the setting overiten, don't do this
                        }//
                    }//
                }//
            }//
        }//
    }//

    JsonStringifyWorkerApp {
        id: jsonStringify

        //        onEstablishedChanged: {
        //            console.log("onEstablishedChanged")
        //        }//

        onMessage: {
            //            //console.debug(JSON.stringify(messageObject))

            if(messageObject.id === "loaderIfaNomGrid"){
                const grid = messageObject.data || [{}]
                props.gridCountNom = grid.length || 0
                loaderIfaNomGrid.loader.setSource("../Components/AirflowGrid.qml",
                                                  {
                                                      "measureUnit": MachineData.measurementUnit,
                                                      "columns": 5,
                                                      "model": grid,
                                                      "valueMinimum": 0,
                                                      "valueMaximum": 1000,
                                                  })
                //                console.log("Nominal grid")
                //                console.log(settings.ifaCalGridMin)
                jsonStringify.s2j('loaderIfaMinGrid', settings.ifaCalGridMin)
            }

            else if(messageObject.id === "loaderIfaMinGrid"){
                const grid = messageObject.data || [{}]
                props.gridCountMin = grid.length || 0
                loaderIfaMinGrid.loader.setSource("../Components/AirflowGrid.qml",
                                                  {
                                                      "measureUnit": MachineData.measurementUnit,
                                                      "columns": 5,
                                                      "model": grid,
                                                      "valueMinimum": 0,
                                                      "valueMaximum": 1000,
                                                  })
                //                console.log("Minimum grid")
                jsonStringify.s2j('loaderIfaStbGrid', settings.ifaCalGridStb)

            }//
            else if(messageObject.id ===  "loaderIfaStbGrid"){
                const grid = messageObject.data || [{}]
                props.gridCountStb = grid.length || 0
                loaderIfaStbGrid.loader.setSource("../Components/AirflowGrid.qml",
                                                  {
                                                      "measureUnit": MachineData.measurementUnit,
                                                      "columns": 5,
                                                      "model": grid,
                                                      "valueMinimum": 0,
                                                      "valueMaximum": 1000,
                                                  })
                //                console.log("std grid")
            }//
        }//
    }//

    QtObject{
        id: props
        property int gridCountNom: 0
        property int gridCountMin: 0
        property int gridCountStb: 0
    }

    QtObject {
        id: settings
        //category: "afmeafull"
        property int calibMode: MachineAPI.CALIB_MODE_FULL

        property string ifaCalGridNom       : MachineData.getIfaCalGrid(calibMode, MachineAPI.INFLOW_GRID_NOMINAL)
        property int    ifaCalGridNomTot    : MachineData.getIfaCalGridTot(calibMode, MachineAPI.INFLOW_GRID_NOMINAL)
        property int    ifaCalGridNomAvg    : MachineData.getIfaCalGridAvg(calibMode, MachineAPI.INFLOW_GRID_NOMINAL)
        property int    ifaCalGridNomVol    : MachineData.getIfaCalGridVol(calibMode, MachineAPI.INFLOW_GRID_NOMINAL)
        property int    ifaCalGridNomVel    : MachineData.getIfaCalGridVel(calibMode, MachineAPI.INFLOW_GRID_NOMINAL)
        property int    ifaCalGridNomTotImp : MachineData.getIfaCalGridTotImp(calibMode, MachineAPI.INFLOW_GRID_NOMINAL)
        property int    ifaCalGridNomAvgImp : MachineData.getIfaCalGridAvgImp(calibMode, MachineAPI.INFLOW_GRID_NOMINAL)
        property int    ifaCalGridNomVolImp : MachineData.getIfaCalGridVolImp(calibMode, MachineAPI.INFLOW_GRID_NOMINAL)
        property int    ifaCalGridNomVelImp : MachineData.getIfaCalGridVelImp(calibMode, MachineAPI.INFLOW_GRID_NOMINAL)
        property int    ifaCalGridNomDcy    : MachineData.getIfaCalGridDcy(calibMode, MachineAPI.INFLOW_GRID_NOMINAL)

        property string ifaCalGridMin       : MachineData.getIfaCalGrid(calibMode, MachineAPI.INFLOW_GRID_MINIMUM)
        property int    ifaCalGridMinTot    : MachineData.getIfaCalGridTot(calibMode, MachineAPI.INFLOW_GRID_MINIMUM)
        property int    ifaCalGridMinAvg    : MachineData.getIfaCalGridAvg(calibMode, MachineAPI.INFLOW_GRID_MINIMUM)
        property int    ifaCalGridMinVol    : MachineData.getIfaCalGridVol(calibMode, MachineAPI.INFLOW_GRID_MINIMUM)
        property int    ifaCalGridMinVel    : MachineData.getIfaCalGridVel(calibMode, MachineAPI.INFLOW_GRID_MINIMUM)
        property int    ifaCalGridMinTotImp : MachineData.getIfaCalGridTotImp(calibMode, MachineAPI.INFLOW_GRID_MINIMUM)
        property int    ifaCalGridMinAvgImp : MachineData.getIfaCalGridAvgImp(calibMode, MachineAPI.INFLOW_GRID_MINIMUM)
        property int    ifaCalGridMinVolImp : MachineData.getIfaCalGridVolImp(calibMode, MachineAPI.INFLOW_GRID_MINIMUM)
        property int    ifaCalGridMinVelImp : MachineData.getIfaCalGridVelImp(calibMode, MachineAPI.INFLOW_GRID_MINIMUM)
        property int    ifaCalGridMinDcy    : MachineData.getIfaCalGridDcy(calibMode, MachineAPI.INFLOW_GRID_MINIMUM)

        property string ifaCalGridStb       : MachineData.getIfaCalGrid(calibMode, MachineAPI.INFLOW_GRID_STANDBY)
        property int    ifaCalGridStbTot    : MachineData.getIfaCalGridTot(calibMode, MachineAPI.INFLOW_GRID_STANDBY)
        property int    ifaCalGridStbAvg    : MachineData.getIfaCalGridAvg(calibMode, MachineAPI.INFLOW_GRID_STANDBY)
        property int    ifaCalGridStbVol    : MachineData.getIfaCalGridVol(calibMode, MachineAPI.INFLOW_GRID_STANDBY)
        property int    ifaCalGridStbVel    : MachineData.getIfaCalGridVel(calibMode, MachineAPI.INFLOW_GRID_STANDBY)
        property int    ifaCalGridStbTotImp : MachineData.getIfaCalGridTotImp(calibMode, MachineAPI.INFLOW_GRID_STANDBY)
        property int    ifaCalGridStbAvgImp : MachineData.getIfaCalGridAvgImp(calibMode, MachineAPI.INFLOW_GRID_STANDBY)
        property int    ifaCalGridStbVolImp : MachineData.getIfaCalGridVolImp(calibMode, MachineAPI.INFLOW_GRID_STANDBY)
        property int    ifaCalGridStbVelImp : MachineData.getIfaCalGridVelImp(calibMode, MachineAPI.INFLOW_GRID_STANDBY)
        property int    ifaCalGridStbDcy    : MachineData.getIfaCalGridDcy(calibMode, MachineAPI.INFLOW_GRID_STANDBY)

        Component.onCompleted: {
            //console.debug("Component.onCompleted")
            jsonStringify.s2j('loaderIfaNomGrid', ifaCalGridNom)
            //jsonStringify.s2j('loaderIfaMinGrid', ifaCalGridMin)
            //jsonStringify.s2j('loaderIfaStbGrid', ifaCalGridStb)

        }//
    }//
}//

/*##^##
Designer {
    D{i:0;autoSize:true;height:480;width:640}
}
##^##*/
