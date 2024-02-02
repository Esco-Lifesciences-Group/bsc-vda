import QtQuick 2.0
import QtQuick.Controls 2.0
import QtQuick.Layouts 1.0
import Qt.labs.settings 1.1
import UI.CusCom 1.1
import ModulesCpp.Machine 1.0

import "../Components" as LocalComp

Item {

    ColumnLayout {
        anchors.fill: parent

        Item {
            Layout.minimumHeight: 50
            Layout.fillHeight: false
            Layout.fillWidth: true

            TextApp {
                text: qsTr("Downflow")
                font.bold: true
                anchors.verticalCenter: parent.verticalCenter
            }//

            Row {
                spacing: 10
                anchors.right: parent.right
                anchors.verticalCenter: parent.verticalCenter

                TextApp {
                    id: velocityTextApp
                    text: qsTr("Average") + ": "+ valueStrf

                    property string valueStrf: "0.32 m/s"
                }//

                TextApp {
                    text: "-"
                }

                TextApp {
                    id: deviationTextApp
                    text: qsTr("Max Deviation") + ": "+ valueStrf

                    property string valueStrf: "0.04 m/s (12.5%)"
                }//
            }//
        }//

        Item {
            Layout.fillHeight: true
            Layout.fillWidth: true

            LocalComp.AirflowGridWrapper {
                id: loaderDfaNomGrid
                anchors.fill: parent
                visibleHorizontalScroll: true
                visibleVerticalScroll: true
            }//
            Loader {
                active: props.gridCount == 0
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

    property bool fieldOrFull

    JsonStringifyWorkerApp {
        id: jsonStringify

        //        onEstablishedChanged: {
        //            console.log("onEstablishedChanged")
        //        }//

        onMessage: {
            //            //console.debug(JSON.stringify(messageObject))

            if(messageObject.id === "loaderDfaNomGrid"){
                const grid = messageObject.data || [{}]
                props.gridCount = grid.length || 0

                let dfaCalGridNomVelHigh    =  MachineData.measurementUnit ? (settings.dfaCalGridNomVelHighImp / 100) : (settings.dfaCalGridNomVelHigh / 100)
                let dfaCalGridNomVelLow     =  MachineData.measurementUnit ? (settings.dfaCalGridNomVelLowImp / 100) : (settings.dfaCalGridNomVelLow / 100)
                let dfaCalGridNomVelDev     =  MachineData.measurementUnit ? (settings.dfaCalGridNomVelDevImp / 100) : (settings.dfaCalGridNomVelDev / 100)
                let dfaCalGridNomVelDevp    =  MachineData.measurementUnit ? (settings.dfaCalGridNomVelDevpImp / 100) : (settings.dfaCalGridNomVelDevp / 100)

                let columns = MachineData.machineProfile['airflow']['dfa']['nominal']['grid']['columns']

                loaderDfaNomGrid.loader.setSource("../Components/AirflowGrid.qml",
                                                  {
                                                      "measureUnit": MachineData.measurementUnit,
                                                      "columns": columns,
                                                      "model": grid,
                                                      "valueMinimum": dfaCalGridNomVelLow,
                                                      "valueMaximum": dfaCalGridNomVelHigh,
                                                  })
            }//
        }//
    }//

    UtilsApp {
        id: utils
    }//

    QtObject{
        id: props
        property int gridCount: 0
    }

    QtObject {
        id: settings
        //        category: "afmeafull"
        property int calibMode: MachineAPI.CALIB_MODE_FULL

        property string dfaCalGridNom           : MachineData.getDfaCalGrid(calibMode, MachineAPI.DOWNFLOW_GRID_NOMINAL)
        property int    dfaCalGridNomVel        : MachineData.getDfaCalGridVel(calibMode, MachineAPI.DOWNFLOW_GRID_NOMINAL)
        property int    dfaCalGridNomVelTot     : MachineData.getDfaCalGridVelTot(calibMode, MachineAPI.DOWNFLOW_GRID_NOMINAL)
        property int    dfaCalGridNomVelDev     : MachineData.getDfaCalGridVelDev(calibMode, MachineAPI.DOWNFLOW_GRID_NOMINAL)
        property int    dfaCalGridNomVelDevp    : MachineData.getDfaCalGridVelDevp(calibMode, MachineAPI.DOWNFLOW_GRID_NOMINAL)
        property int    dfaCalGridNomVelHigh    : MachineData.getDfaCalGridVelHigh(calibMode, MachineAPI.DOWNFLOW_GRID_NOMINAL)
        property int    dfaCalGridNomVelLow     : MachineData.getDfaCalGridVelLow(calibMode, MachineAPI.DOWNFLOW_GRID_NOMINAL)
        property int    dfaCalGridNomVelImp     : MachineData.getDfaCalGridVelImp(calibMode, MachineAPI.DOWNFLOW_GRID_NOMINAL)
        property int    dfaCalGridNomVelTotImp  : MachineData.getDfaCalGridVelTotImp(calibMode, MachineAPI.DOWNFLOW_GRID_NOMINAL)
        property int    dfaCalGridNomVelDevImp  : MachineData.getDfaCalGridVelDevImp(calibMode, MachineAPI.DOWNFLOW_GRID_NOMINAL)
        property int    dfaCalGridNomVelDevpImp : MachineData.getDfaCalGridVelDevpImp(calibMode, MachineAPI.DOWNFLOW_GRID_NOMINAL)
        property int    dfaCalGridNomVelHighImp : MachineData.getDfaCalGridVelHighImp(calibMode, MachineAPI.DOWNFLOW_GRID_NOMINAL)
        property int    dfaCalGridNomVelLowImp  : MachineData.getDfaCalGridVelLowImp(calibMode, MachineAPI.DOWNFLOW_GRID_NOMINAL)

        Component.onCompleted: {
            jsonStringify.s2j('loaderDfaNomGrid', dfaCalGridNom)

            let dfaCalGridNomVel
            if(MachineData.measurementUnit)
                dfaCalGridNomVel = utils.strfVelocityByUnit(MachineData.measurementUnit, settings.dfaCalGridNomVelImp / 100)
            else
                dfaCalGridNomVel = utils.strfVelocityByUnit(MachineData.measurementUnit, settings.dfaCalGridNomVel / 100)

            velocityTextApp.valueStrf = dfaCalGridNomVel

            let dfaCalGridNomVelDev
            if(MachineData.measurementUnit)
                dfaCalGridNomVelDev = utils.strfVelocityByUnit(MachineData.measurementUnit, settings.dfaCalGridNomVelDevImp / 100)
            else
                dfaCalGridNomVelDev = utils.strfVelocityByUnit(MachineData.measurementUnit, settings.dfaCalGridNomVelDev / 100)

            let dfaCalGridNomVelDevp = (settings.dfaCalGridNomVelDevp / 100).toFixed(2) + "%"
            deviationTextApp.valueStrf = dfaCalGridNomVelDev + " (" + dfaCalGridNomVelDevp + ")"
        }//
    }//
}//

/*##^##
Designer {
    D{i:0;autoSize:true;height:480;width:800}
}
##^##*/
