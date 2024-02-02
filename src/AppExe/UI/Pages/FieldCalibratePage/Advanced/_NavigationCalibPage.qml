import QtQuick 2.12
import QtQuick.Layouts 1.0
import QtQuick.Controls 2.0
import Qt.labs.settings 1.0

import UI.CusCom 1.1
import "../../../CusCom/JS/IntentApp.js" as IntentApp

import ModulesCpp.Machine 1.0

ViewApp {
    id: viewApp
    title: "Field Sensor Calibration"

    background.sourceComponent: Item {}

    content.asynchronous: true
    content.sourceComponent: Item{
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
                    id: headerApp
                    anchors.fill: parent
                    title: qsTr("Field Sensor Calibration")
                }
            }

            /// BODY
            Item {
                id: bodyItem
                Layout.fillWidth: true
                Layout.fillHeight: true

                /// handle sub menu
                StackView {
                    id: menuStackView
                    anchors.fill: parent
                    //                    initialItem: menuGridViewComponent
                    //                    Component.onCompleted: {

                    //                    }
                }//

                Component{
                    id: menuGridViewComponent

                    Item {
                        property alias model: menuGridView.model

                        //Rectangle {
                        //    id: msgInfoTextApp
                        //    visible: false
                        //    color: "#80000000"
                        //    TextApp {
                        //        text: qsTr("To measure inflow, select one of the two existing methods!")
                        //        verticalAlignment: Text.AlignVCenter
                        //        padding: 2
                        //    }
                        //    width: childrenRect.width
                        //    height: childrenRect.height
                        //}//

                        GridView{
                            id: menuGridView
                            //                        anchors.fill: parent
                            anchors.centerIn: parent
                            /// If model lest than 4, make it centerIn of parent
                            width: count <= 4 ? (count * (parent.width / 4)) : parent.width
                            height: count <= 4 ? parent.height / 2 : parent.height
                            cellWidth: parent.width / 4
                            cellHeight: count <= 4 ? height : height / 2
                            clip: true
                            snapMode: GridView.SnapToRow
                            flickableDirection: GridView.AutoFlickIfNeeded

                            //                        model: props.menuModel

                            //                        StackView.onStatusChanged: {
                            //                            if(StackView.status == StackView.Activating){
                            //                                model = props.menuModel
                            //                            }
                            //                        }

                            delegate: Item{
                                height: menuGridView.cellHeight
                                width: menuGridView.cellWidth
                                opacity:  iconMouseArea.pressed ? 0.5 : 1

                                ColumnLayout{
                                    anchors.fill: parent
                                    anchors.margins: 10
                                    spacing: 0

                                    //                            Rectangle {
                                    //                                anchors.fill: parent
                                    //                            }

                                    Item {
                                        id: picIconItem
                                        Layout.fillHeight: true
                                        Layout.fillWidth: true

                                        //                Rectangle{anchors.fill: parent}

                                        Image {
                                            id: picIconImage
                                            source: modelData.micon ? modelData.micon : ""
                                            fillMode: Image.PreserveAspectFit
                                            anchors.fill: parent
                                        }

                                        Loader {
                                            id: badgeLoader
                                            anchors.right: parent.right
                                            active: modelData.badge === 1
                                            sourceComponent: TextApp {
                                                id: badgeText
                                                padding: 2
                                                text: modelData.badgeText

                                                Rectangle {
                                                    z: -1
                                                    color: "#27ae60"
                                                    anchors.fill: parent
                                                    radius: 5
                                                }//
                                            }//
                                        }//
                                    }//

                                    Item {
                                        id: iconTextItem
                                        Layout.minimumHeight: parent.height* 0.35
                                        Layout.fillWidth: true

                                        //                Rectangle{anchors.fill: parent}

                                        Text {
                                            id: iconText
                                            text: modelData.mtitle ? ((index + 1) + ") " + modelData.mtitle) : ""
                                            height: parent.height
                                            width: parent.width
                                            wrapMode: Text.WordWrap
                                            horizontalAlignment: Text.AlignHCenter
                                            verticalAlignment: Text.AlignTop
                                            color: "#dddddd"
                                            font.pixelSize: 20
                                        }//
                                    }//
                                }//

                                MouseArea{
                                    id: iconMouseArea
                                    anchors.fill: parent
                                    onClicked: {

                                        if(modelData.mtype === "submenu"){
                                            //props.messageInfoStr = modelData.messageInfo
                                            menuStackView.push(menuGridViewComponent, {"model": modelData.submenu})
                                        }//
                                        else {
                                            props.openPage(modelData.pid, modelData.mlink, modelData.mtitle)
                                        }//
                                    }//
                                }//
                            }//
//                            onModelChanged: {
//                                //console.debug(JSON.stringify(model))
//                                let model01 =
//                            }

                            Component.onCompleted: {
                                ////console.debug("Component.onCompleted", JSON.stringify(modelData.pid))
                                //                                if(count === 2){
                                //                                    msgInfoTextApp.visible = true
                                //                                }
                                //                                else
                                //                                    msgInfoTextApp.visible = false
                            }
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
                                if(menuStackView.depth > 1) {
                                    //                                    props.messageInfoStr = qsTr("Please do it in order!")
                                    menuStackView.pop()
                                }
                                else {
                                    var intent = IntentApp.create(uri, {})
                                    finishView(intent)
                                }
                            }//
                        }//
                    }//
                }//
            }//
        }//

        QtObject {
            id: props

            property int measurementUnit: 0

            function refreshBadge(){
                /// Check Badge
                let dimNom = props.menuModel[0]['submenu'][0]['submenu'][0]['badge']
                let dimMin = props.menuModel[0]['submenu'][0]['submenu'][1]['badge']
                //                let dimStb = props.menuModel[0]['submenu'][0]['submenu'][2]['badge']
                let secNom = props.menuModel[0]['submenu'][1]['submenu'][0]['badge']
                let secMin = props.menuModel[0]['submenu'][1]['submenu'][1]['badge']
                //                let secStb = props.menuModel[0]['submenu'][1]['submenu'][2]['badge']

                if(dimNom && dimMin/* && dimStb*/)
                    props.menuModel[0]['submenu'][0]['badge'] = 1;
                else
                    props.menuModel[0]['submenu'][0]['badge'] = 0;

                if(secNom && secMin/* && secStb*/)
                    props.menuModel[0]['submenu'][1]['badge'] = 1;
                else
                    props.menuModel[0]['submenu'][1]['badge'] = 0;

                let nomDimDone  = props.menuModel[0]['submenu'][0]['badge']
                let nomSecDone  = props.menuModel[0]['submenu'][1]['badge']

                if (nomDimDone || nomSecDone){
                    /// set bagde value to main model
                    props.menuModel[0]['badge'] = 1
                }//
                else
                    props.menuModel[0]['badge'] = 0

                /// update to parent menu
                menuStackView.get(0)['model'] = props.menuModel
            }//

            function openDirectAdcCalibration(uri, pid){
                const airflowBalanced = props.menuModel[0]['badge'] && props.menuModel[1]['badge']

                var intent = IntentApp.create(uri,
                                              {
                                                  'pid': pid,
                                                  "measureUnit": props.measurementUnit,
                                                  "sensorConstant": props.sensorConstant,
                                                  "sensorVelMinimum": props.sensorVelMinimum / 100, //ifa
                                                  "sensorVelLowAlarm": props.sensorVelLowAlarm / 100, //ifa alarm
                                                  "sensorVelNominal": props.sensorVelNominal / 100, //ifa
                                                  "sensorVelNominalDfa": props.sensorVelNominalDfa / 100, //dfa
                                                  'fanDutyCycleNominal': props.fanDutyCycleNominal,
                                                  'fanDutyCycleMinimum': props.fanDutyCycleMinimum
                                                  /*
                                                  "sensorAdcMinimum": props.sensorAdcMinimum,
                                                  "sensorVelMinimum": props.sensorVelMinimum / 100,
                                                  "sensorVelNominal": props.sensorVelNominal / 100,
                                                  "sensorVelNominalDfa": props.sensorVelNominalDfa / 100,
                                                  'fanDutyCycle': props.fanDutyCycleNominal,
                                                  'velMinAdcRef': props.sensorAdcMinimum,
                                                  'velMinRef': props.sensorVelMinimum / 100,
                                                  'velNomAdcRef': props.sensorAdcNominal,
                                                  'velNomRef': props.sensorVelNominal / 100,*/
                                              })//

                if(airflowBalanced){
                    startView(intent)
                }else{
                    const message = qsTr("You have not completed the airflow balancing yet, are you sure you want to continue?")
                    var autoClose = false
                    viewApp.showDialogAsk(qsTr(viewApp.title),
                                          message,
                                          viewApp.dialogAlert,
                                          function onAccepted(){
                                              startView(intent)
                                          }, function onRejected(){
                                              return;
                                          }, function(){}, autoClose)
                }//
            }//

            function openPage(pid, uri, title){
                if (pid === 'meaifanomdimfield'){
                    let calibrateReq = props.calibrateReqValues['measure']['ifa']['dim']['nominal']

                    let intent = IntentApp.create(uri,
                                                  {
                                                      'pid': pid,
                                                      'title': title,
                                                      "measureUnit": props.measurementUnit,
                                                      //                                                      'grid': grid,
                                                      'grid': props.meaIfaNominalGrid,
                                                      'fanDutyCycle': props.fanDutyCycleNominal,
                                                      'calibrateReq': calibrateReq,
                                                      'fieldCalib': true,
                                                  })
                    startView(intent)
                }else if (pid === 'meaifamindimfield'){
                    let calibrateReq = props.calibrateReqValues['measure']['ifa']['dim']['minimum']

                    let intent = IntentApp.create(uri,
                                                  {
                                                      'pid': pid,
                                                      'title': title,
                                                      "measureUnit": props.measurementUnit,
                                                      //                                                      'grid': grid,
                                                      'grid': props.meaIfaMinimumGrid,
                                                      'fanDutyCycle': props.fanDutyCycleMinimum,
                                                      'calibrateReq': calibrateReq,
                                                      'fieldCalib': true,
                                                  })
                    startView(intent)
                }else if (pid === 'meaifastbdimfield'){
                    let calibrateReq = props.calibrateReqValues['measure']['ifa']['dim']['stb']

                    let intent = IntentApp.create(uri,
                                                  {
                                                      'pid': pid,
                                                      'title': title,
                                                      "measureUnit": props.measurementUnit,
                                                      //                                                      'grid': grid,
                                                      'grid': props.meaIfaStbGrid,
                                                      'fanDutyCycle': props.fanDutyCycleStandby,
                                                      'calibrateReq': calibrateReq,
                                                      'fieldCalib': true,
                                                  })
                    startView(intent)
                }
                else if (pid === 'meaifanomsecfield'){
                    let calibrateReq = props.calibrateReqValues['measure']['ifa']['sec']['nominal']
                    //                    ////console.debug(JSON.stringify(calibrateReq))

                    let intent = IntentApp.create(uri,
                                                  {
                                                      'pid': pid,
                                                      'title': title,
                                                      "measureUnit": props.measurementUnit,
                                                      //                                                      'grid': grid,
                                                      'grid': props.meaIfaNominalSecGrid,
                                                      'fanDutyCycle': props.fanDutyCycleNominal,
                                                      'calibrateReq': calibrateReq,
                                                      'fieldCalib': true,
                                                  })
                    startView(intent)
                }
                else if (pid === 'meaifaminsecfield'){
                    let calibrateReq = props.calibrateReqValues['measure']['ifa']['sec']['minimum']
                    //                    ////console.debug(JSON.stringify(calibrateReq))

                    let intent = IntentApp.create(uri,
                                                  {
                                                      'pid': pid,
                                                      'title': title,
                                                      "measureUnit": props.measurementUnit,
                                                      //                                                      'grid': grid,
                                                      'grid': props.meaIfaMinimumSecGrid,
                                                      'fanDutyCycle': props.fanDutyCycleMinimum,
                                                      'calibrateReq': calibrateReq,
                                                      'fieldCalib': true,
                                                  })
                    startView(intent)
                }
                else if (pid === 'meaifastbsecfield'){
                    let calibrateReq = props.calibrateReqValues['measure']['ifa']['sec']['stb']
                    //                    ////console.debug(JSON.stringify(calibrateReq))

                    let intent = IntentApp.create(uri,
                                                  {
                                                      'pid': pid,
                                                      'title': title,
                                                      "measureUnit": props.measurementUnit,
                                                      //                                                      'grid': grid,
                                                      'grid': props.meaIfaStbSecGrid,
                                                      'fanDutyCycle': props.fanDutyCycleStandby,
                                                      'calibrateReq': calibrateReq,
                                                      'fieldCalib': true,
                                                  })
                    startView(intent)
                }
                else if (pid === 'meadfanomfield'){
                    let calibrateReq = props.calibrateReqValues['measure']['dfa']['nominal']
                    //                    let grid = props.calibrateResValues['measure']['dfa']['nominal']['grid']

                    let intent = IntentApp.create(uri,
                                                  {
                                                      'pid': pid,
                                                      'title': title,
                                                      "measureUnit": props.measurementUnit,
                                                      //                                                      'grid': grid,
                                                      'grid': props.meaDfaNominalGrid,
                                                      'fanDutyCycle': props.fanDutyCycleNominal,
                                                      'calibrateReq': calibrateReq,
                                                      'fieldCalib': /*(props.menuModel[0]['badge'] ? */true/* : false)*/
                                                  })
                    startView(intent)
                }//
                else if (pid === 'senconst'){
                    let intent = IntentApp.create(uri,
                                                  {
                                                      'pid': pid,
                                                      "sensorConstant": props.sensorConstant,
                                                      "fieldCalib": true
                                                  })
                    startView(intent)
                }//
                else if (pid === 'directAdcCalib'){
                    if(MachineData.sashWindowState === MachineAPI.SASH_STATE_WORK_SSV){
                        const ducyValid = ((props.fanDutyCycleStandby > 0)
                                           && (props.fanDutyCycleMinimum > props.fanDutyCycleStandby)
                                           && (props.fanDutyCycleNominal > props.fanDutyCycleMinimum))
                        const velocityValid = ((props.sensorVelMinimum > 0)
                                               && (props.sensorVelNominal > props.sensorVelMinimum)
                                               && (props.sensorVelNominalDfa > 0))
                        const velocityFailValid = ((props.sensorVelLowAlarm == props.sensorVelMinimum) && velocityValid)

                        const allParamsValid = ducyValid && velocityValid && velocityFailValid
                        const sensorConst = props.sensorConstant

                        if(allParamsValid){
                            if(sensorConst === 0){
                                const message = "<b>" + qsTr("Sensor Constant is Zero!") + "</b>" + "<br><br>" +
                                              qsTr("Are you sure you want to continue?")
                                showDialogAsk(qsTr("Notification"), message, dialogAlert, function(){
                                    props.openDirectAdcCalibration(uri, pid)
                                }, function(){ return; }, function(){}, false)
                            }
                            else{
                                props.openDirectAdcCalibration(uri, pid)
                            }
                        }
                        else{
                            let msg = qsTr("There's an invalid value!")
                            if(!ducyValid){
                                msg = qsTr("There's an invalid Duty cycle!") + "<br>"
                                        + qsTr("Standby") + ": %1%".arg(props.fanDutyCycleStandby) + "<br>"
                                        + qsTr("Minimum") + ": %1%".arg(props.fanDutyCycleMinimum) + "<br>"
                                        + qsTr("Nominal") + ": %1%".arg(props.fanDutyCycleNominal)
                            }
                            else if(!velocityValid){
                                msg = qsTr("There's an invalid Velocity!") + "<br>"
                                        + qsTr("Minimum Inflow") + ": %1%".arg(props.sensorVelMinimum) + "<br>"
                                        + qsTr("Nominal Inflow") + ": %1%".arg(props.sensorVelNominal) + "<br>"
                                        + qsTr("Nominal Downflow") + ": %1%".arg(props.sensorVelNominalDfa)
                            }
                            if(!velocityFailValid && velocityValid && ducyValid){
                                props.sensorVelLowAlarm = props.sensorVelMinimum
                                props.openDirectAdcCalibration(uri, pid)
                            }else{
                                showDialogMessage(qsTr("Notification"), msg, dialogAlert)
                            }//
                        }//
                    }//
                    else{
                        const message = "<b>" + qsTr("Please adjust the height of the sash to working height position!") + "</b>"
                        showDialogMessage(qsTr("Field Sensor Calibration"),
                                          message,
                                          dialogAlert,
                                          function(){})
                    }//
                }//
                else {
                    let intent = IntentApp.create(uri, {"pid": pid})
                    startView(intent)
                }
            }//

            function initCalibrateSpecs(profile){
                let meaUnitStr = props.measurementUnit ? 'imp' : 'metric'

                /// inflow
                for (const label of ['nominal', 'minimum'/*, 'stb'*/]){
                    props.calibrateReqValues['measure']['ifa']['dim'][label]['volume']             = profile['airflow']['ifa']['dim'][label][meaUnitStr]['volume']
                    props.calibrateReqValues['measure']['ifa']['dim'][label]['velocity']           = profile['airflow']['ifa']['dim'][label][meaUnitStr]['velocity']
                    props.calibrateReqValues['measure']['ifa']['dim'][label]['velocityTol']        = profile['airflow']['ifa']['dim'][label][meaUnitStr]['velocityTol']
                    props.calibrateReqValues['measure']['ifa']['dim'][label]['velocityTolLow']     = profile['airflow']['ifa']['dim'][label][meaUnitStr]['velocityTolLow']
                    props.calibrateReqValues['measure']['ifa']['dim'][label]['velocityTolHigh']    = profile['airflow']['ifa']['dim'][label][meaUnitStr]['velocityTolHigh']
                    props.calibrateReqValues['measure']['ifa']['dim'][label]['openingArea']        = profile['airflow']['ifa']['dim'][label][meaUnitStr]['openingArea']
                    props.calibrateReqValues['measure']['ifa']['dim'][label]['gridCount']          = profile['airflow']['ifa']['dim']['gridCount']

                    /// inflow Secondary
                    props.calibrateReqValues['measure']['ifa']['sec'][label]['velocity']           = profile['airflow']['ifa']['sec'][label][meaUnitStr]['velocity']
                    props.calibrateReqValues['measure']['ifa']['sec'][label]['velocityTol']        = profile['airflow']['ifa']['sec'][label][meaUnitStr]['velocityTol']
                    props.calibrateReqValues['measure']['ifa']['sec'][label]['velocityTolLow']     = profile['airflow']['ifa']['sec'][label][meaUnitStr]['velocityTolLow']
                    props.calibrateReqValues['measure']['ifa']['sec'][label]['velocityTolHigh']    = profile['airflow']['ifa']['sec'][label][meaUnitStr]['velocityTolHigh']
                    props.calibrateReqValues['measure']['ifa']['sec'][label]['gridCount']          = profile['airflow']['ifa']['sec'][label]['gridCount']
                    props.calibrateReqValues['measure']['ifa']['sec'][label]['correctionFactor']   = profile['airflow']['ifa']['sec'][label]['correctionFactor']
                }

                /// downflow
                props.calibrateReqValues['measure']['dfa']['nominal']['velocity']          = profile['airflow']['dfa']['nominal'][meaUnitStr]['velocity']
                props.calibrateReqValues['measure']['dfa']['nominal']['velocityTol']       = profile['airflow']['dfa']['nominal'][meaUnitStr]['velocityTol']
                props.calibrateReqValues['measure']['dfa']['nominal']['velocityTolLow']    = profile['airflow']['dfa']['nominal'][meaUnitStr]['velocityTolLow']
                props.calibrateReqValues['measure']['dfa']['nominal']['velocityTolHigh']   = profile['airflow']['dfa']['nominal'][meaUnitStr]['velocityTolHigh']
                props.calibrateReqValues['measure']['dfa']['nominal']['velDevp']           = profile['airflow']['dfa']['nominal']['velDevpField']
                props.calibrateReqValues['measure']['dfa']['nominal']['grid']['count']     = profile['airflow']['dfa']['nominal']['grid']['count']
                props.calibrateReqValues['measure']['dfa']['nominal']['grid']['columns']   = profile['airflow']['dfa']['nominal']['grid']['columns']

            }//

            property var menuModel: [
                {mtype         : "submenu",
                    mtitle     : qsTr("Inflow Measurement"),
                    micon      : "qrc:/UI/Pictures/menu/ifa_dimsec_measure.png",
                    badge      : 0,
                    badgeText  : qsTr("Done"),
                    pid        : "meaifa",
                    submenu    : [
                        {mtype         : "submenu",
                            mtitle     : qsTr("DIM Method"),
                            micon      : "qrc:/UI/Pictures/menu/ifa_dim_measure.png",
                            //mlink      : "qrc:/UI/Pages/FullCalibrateSensorPage/Pages/MeasureInflowDimSetPage.qml",
                            badge      : 0,
                            badgeText  : qsTr("Done"),
                            pid        : "meaifadimfield",

                            submenu    : [
                                {mtype         : "menu",
                                    mtitle     : qsTr("Nominal Inflow Measurement"),
                                    micon      : "qrc:/UI/Pictures/menu/ifa_dim_nom_measure.png",
                                    mlink      : "qrc:/UI/Pages/FullCalibrateSensorPage/Pages/MeasureInflowDimSetPage.qml",
                                    badge      : 0,
                                    badgeText  : qsTr("Done"),
                                    pid        : "meaifanomdimfield",
                                },
                                {mtype         : "menu",
                                    mtitle     : qsTr("Minimum Inflow Measurement"),
                                    micon      : "qrc:/UI/Pictures/menu/ifa_dim_min_measure.png",
                                    mlink      : "qrc:/UI/Pages/FullCalibrateSensorPage/Pages/MeasureInflowDimSetPage.qml",
                                    badge      : 0,
                                    badgeText  : qsTr("Done"),
                                    pid        : "meaifamindimfield",
                                }/*,
                                {mtype         : "menu",
                                    mtitle     : qsTr("Standby Inflow Measurement"),
                                    micon      : "qrc:/UI/Pictures/menu/ifa_dim_stb_measure.png",
                                    mlink      : "qrc:/UI/Pages/FullCalibrateSensorPage/Pages/MeasureInflowDimSetPage.qml",
                                    badge      : 0,
                                    badgeText  : qsTr("Done"),
                                    pid        : "meaifastbdimfield",
                                },*/
                            ]//
                        },
                        {mtype         : "submenu",
                            mtitle     : qsTr("Secondary Method"),
                            micon      : "qrc:/UI/Pictures/menu/ifa_sec_measure.png",
                            badge      : 0,
                            badgeText  : qsTr("Done"),
                            pid         : "meaifasecfield",

                            submenu    : [
                                {mtype         : "menu",
                                    mtitle     : qsTr("Nominal Inflow Measurement"),
                                    micon      : "qrc:/UI/Pictures/menu/ifa_sec_nom_measure.png",
                                    mlink      : "qrc:/UI/Pages/FullCalibrateSensorPage/Pages/MeasureInflowSecSetPage.qml",
                                    badge      : 0,
                                    badgeText  : qsTr("Done"),
                                    pid        : "meaifanomsecfield",
                                },
                                {mtype         : "menu",
                                    mtitle     : qsTr("Minimum Inflow Measurement"),
                                    micon      : "qrc:/UI/Pictures/menu/ifa_sec_min_measure.png",
                                    mlink      : "qrc:/UI/Pages/FullCalibrateSensorPage/Pages/MeasureInflowSecSetPage.qml",
                                    badge      : 0,
                                    badgeText  : qsTr("Done"),
                                    pid        : "meaifaminsecfield",
                                }/*,
                                {mtype         : "menu",
                                    mtitle     : qsTr("Standby Inflow Measurement"),
                                    micon      : "qrc:/UI/Pictures/menu/ifa_sec_stb_measure.png",
                                    mlink      : "qrc:/UI/Pages/FullCalibrateSensorPage/Pages/MeasureInflowSecSetPage.qml",
                                    badge      : 0,
                                    badgeText  : qsTr("Done"),
                                    pid        : "meaifastbsecfield",
                                },*/
                            ]//
                        },
                    ]
                },
                {mtype         : "menu",
                    mtitle     : qsTr("Downflow Measurement"),
                    micon      : "qrc:/UI/Pictures/menu/dfa_measure.png",
                    mlink      : "qrc:/UI/Pages/FullCalibrateSensorPage/Pages/MeasureDownflowSetPage.qml",
                    badge      : 0,
                    badgeText  : qsTr("Done"),
                    pid         : "meadfanomfield",
                },
                {mtype         : "menu",
                    mtitle     : qsTr("Sensor Constant"),
                    micon      : "qrc:/UI/Pictures/menu/Set-Constant.png",
                    mlink      : "qrc:/UI/Pages/FullCalibrateSensorPage/Pages/SensorConstantSetPage.qml",
                    badge      : 0,
                    badgeText  : qsTr("Done"),
                    pid         : "senconst",
                },
                {mtype         : "menu",
                    mtitle     : qsTr("ADC Calibration"),
                    micon      : "qrc:/UI/Pictures/menu/Calibrate-Sensor.png",
                    mlink      : "qrc:/UI/Pages/FieldCalibratePage/Advanced/ADCDirectCalibrationPage.qml",
                    badge      : 0,
                    badgeText  : qsTr("Done"),
                    pid         : "directAdcCalib",
                }
            ]//

            property var calibrateReqValues: {
                "measure": {
                    "ifa": {
                        "dim":{
                            "nominal": {
                                "volume": 0,
                                "velocity": 0,
                                "velocityTol": 0,
                                "velocityTolLow": 0,
                                "velocityTolHigh": 0,
                                "openingArea": 0,
                                "gridCount": 0,
                            },
                            "minimum": {
                                "volume": 0,
                                "velocity": 0,
                                "velocityTol": 0,
                                "velocityTolLow": 0,
                                "velocityTolHigh": 0,
                                "openingArea": 0,
                                "gridCount": 0,
                            }/*,
                            "stb": {
                                "volume": 0,
                                "velocity": 0,
                                "velocityTol": 0,
                                "velocityTolLow": 0,
                                "velocityTolHigh": 0,
                                "openingArea": 0,
                                "gridCount": 0,
                            },*/
                        },
                        "sec":{
                            "nominal": {
                                "correctionFactor": 0,
                                "gridCount": 0,
                                "velocity": 0,
                                "velocityTol": 0,
                                "velocityTolLow": 0,
                                "velocityTolHigh": 0,
                            },
                            "minimum": {
                                "correctionFactor": 0,
                                "gridCount": 0,
                                "velocity": 0,
                                "velocityTol": 0,
                                "velocityTolLow": 0,
                                "velocityTolHigh": 0,
                            }/*,
                            "stb": {
                                "correctionFactor": 0,
                                "gridCount": 0,
                                "velocity": 0,
                                "velocityTol": 0,
                                "velocityTolLow": 0,
                                "velocityTolHigh": 0,
                            },*/
                        }
                    },//
                    "dfa": {
                        "nominal": {
                            "velocity": 0,
                            "velocityTol": 0,
                            "velocityTolLow": 0,
                            "velocityTolHigh": 0,
                            "velDevp": 0, /*%*/
                            'grid': {
                                'count': 0,
                                'columns': 0,
                            }
                        },
                    }//
                },
            }//

            property bool calibNewSensorConst: false

            property int operationModeBackup: 0
            property bool calibNewInflowNom:    false
            property bool calibNewInflowMin:    false
            property bool calibNewInflowStb:    false
            property bool calibNewInflowNomSec: false
            property bool calibNewInflowMinSec: false
            property bool calibNewInflowStbSec:    false
            property bool calibNewDownflowNom:  false
            property bool calibNewAdc:       false

            property var meaIfaNominalGrid: []
            property int meaIfaNominalTotal: 0
            property int meaIfaNominalAverage: 0
            property int meaIfaNominalVolume: 0
            property int meaIfaNominalVelocity: 0
            //            property int meaIfaNominalDucy: 0
            property var meaIfaMinimumGrid: []
            property int meaIfaMinimumTotal: 0
            property int meaIfaMinimumAverage: 0
            property int meaIfaMinimumVolume: 0
            property int meaIfaMinimumVelocity: 0
            //            property int meaIfaMinimumDucy: 0
            property var meaIfaStbGrid: []
            property int meaIfaStbTotal: 0
            property int meaIfaStbAverage: 0
            property int meaIfaStbVolume: 0
            property int meaIfaStbVelocity: 0
            //            property int meaIfaStbDucy: 0

            property var meaIfaNominalSecGrid: []
            property int meaIfaNominalSecTot: 0
            property int meaIfaNominalSecAvg: 0
            property int meaIfaNominalSecVelocity: 0
            //            property int meaIfaNominalSecVelocity: 0
            property var meaIfaMinimumSecGrid: []
            property int meaIfaMinimumSecTot: 0
            property int meaIfaMinimumSecAvg: 0
            property int meaIfaMinimumSecVelocity: 0
            //            property int meaIfaMinimumSecVelocity: 0
            property var meaIfaStbSecGrid: []
            property int meaIfaStbSecTot: 0
            property int meaIfaStbSecAvg: 0
            property int meaIfaStbSecVelocity: 0
            //            property int meaIfaStbSecVelocity: 0

            property var meaDfaNominalGrid: []
            property int meaDfaNominalVelocity: 0
            property int meaDfaNominalVelocityTotal: 0
            property int meaDfaNominalVelocityLowest: 0
            property int meaDfaNominalVelocityHighest: 0
            property int meaDfaNominalVelocityDeviation: 0
            property int meaDfaNominalVelocityDeviationp: 0


            //            readonly property  int meaFieldCalibModeOn: 1

            property int sensorAdcZero: 0
            property int sensorAdcMinimum: 0
            property int sensorAdcNominal: 0

            property int sensorVelStandby: 0 /*+ 40*/
            property int sensorVelMinimum: 0 /*+ 40*/
            property int sensorVelNominal: 0 /*+ 53*/

            property int sensorVelLowAlarm: 0

            property int sensorVelNominalDfa: 0 /*+ 33*/

            property int sensorConstant: 0

            property int fanDutyCycleNominal: 0 /*+ 15*/
            property int fanDutyCycleMinimum: 0 /*+ 15*/
            property int fanDutyCycleStandby: 0 /*+ 5*/

            property int fanRpmNominal: 0
            property int fanRpmMinimum: 0
            property int fanRpmStandby: 0

            property int temperatureCalib: 0
            property int temperatureAdcCalib: 0

            function saveCalibrationData(){
                if (!props.calibNewAdc) {
                    return
                }

                MachineAPI.initAirflowCalibrationStatus(MachineAPI.AF_CALIB_FIELD);

                viewApp.showBusyPage(qsTr("Setting up..."), function(cycle){
                    if (cycle >= MachineAPI.BUSY_CYCLE_1) {
                        const intent = IntentApp.create("qrc:/UI/Pages/FieldCalibratePage/Advanced/_CalibrationFinishedPage.qml", {})
                        finishView(intent);

                        //                                        viewApp.dialogObject.close()
                    }
                })
            }//

            //            property string messageInfoStr: ""
        }//

        /// called Once but after onResume
        Component.onCompleted: {
            //            props.messageInfoStr = qsTr("Please do it in order!")
            menuStackView.push(menuGridViewComponent, {"model": props.menuModel})

            props.measurementUnit = MachineData.measurementUnit

            MachineAPI.setOperationMaintenanceMode();

            if(MachineData.airflowCalibrationStatus === MachineAPI.AF_CALIB_FIELD){
                props.sensorAdcZero       = MachineData.getInflowAdcPointField(0)
                props.sensorAdcMinimum    = MachineData.getInflowAdcPointField(1);
                props.sensorAdcNominal    = MachineData.getInflowAdcPointField(2);
                //
                props.sensorVelMinimum    = MachineData.getInflowVelocityPointField(1);
                props.sensorVelNominal    = MachineData.getInflowVelocityPointField(2);
                props.sensorVelNominalDfa = MachineData.getDownflowVelocityPointField(2);
            }
            else{
                props.sensorAdcZero       = MachineData.getInflowAdcPointFactory(0);
                props.sensorAdcMinimum    = MachineData.getInflowAdcPointFactory(1);
                props.sensorAdcNominal    = MachineData.getInflowAdcPointFactory(2);
                //
                props.sensorVelMinimum    = MachineData.getInflowVelocityPointFactory(1);
                props.sensorVelNominal    = MachineData.getInflowVelocityPointFactory(2);
                props.sensorVelNominalDfa = MachineData.getDownflowVelocityPointFactory(2);
            }//

            props.sensorVelLowAlarm    = MachineData.getInflowLowLimitVelocity();
            //console.debug("sensor vel alarm: " + props.sensorVelLowAlarm)

            props.fanDutyCycleNominal = MachineData.getFanPrimaryNominalDutyCycle()
            props.fanDutyCycleMinimum = MachineData.getFanPrimaryMinimumDutyCycle()
            props.fanDutyCycleStandby = MachineData.getFanPrimaryStandbyDutyCycle()

            props.fanRpmNominal = MachineData.getFanPrimaryNominalRpm()
            props.fanRpmMinimum = MachineData.getFanPrimaryMinimumRpm()
            props.fanRpmStandby = MachineData.getFanPrimaryStandbyRpm()

            /// Set Badge
            props.menuModel[0]['submenu'][0]['submenu'][0]['badge'] = MachineData.getAirflowFieldCalibrationState(MachineAPI.CalFieldState_InflowDimNominal) ? 1 : 0
            props.menuModel[0]['submenu'][0]['submenu'][1]['badge'] = MachineData.getAirflowFieldCalibrationState(MachineAPI.CalFieldState_InflowDimMinimum) ? 1 : 0
            //            props.menuModel[0]['submenu'][0]['submenu'][2]['badge'] = MachineData.getAirflowFieldCalibrationState(MachineAPI.CalFieldState_InflowDimStandby) ? 1 : 0
            props.menuModel[0]['submenu'][1]['submenu'][0]['badge'] = MachineData.getAirflowFieldCalibrationState(MachineAPI.CalFieldState_InflowSecNominal) ? 1 : 0
            props.menuModel[0]['submenu'][1]['submenu'][1]['badge'] = MachineData.getAirflowFieldCalibrationState(MachineAPI.CalFieldState_InflowSecMinimum) ? 1 : 0
            //            props.menuModel[0]['submenu'][1]['submenu'][2]['badge'] = MachineData.getAirflowFieldCalibrationState(MachineAPI.CalFieldState_InflowSecStandby) ? 1 : 0
            props.menuModel[1]['badge'] = MachineData.getAirflowFieldCalibrationState(MachineAPI.CalFieldState_DownflowNominal) ? 1 : 0
            props.menuModel[2]['badge'] = MachineData.getAirflowFieldCalibrationState(MachineAPI.CalFieldState_SensorConstant) ? 1 : 0
            props.menuModel[3]['badge'] = MachineData.getAirflowFieldCalibrationState(MachineAPI.CalFieldState_AdcCalib) ? 1 : 0

            props.refreshBadge()

            props.sensorConstant = MachineData.getInflowSensorConstant()

            props.initCalibrateSpecs(MachineData.machineProfile)

           if(!MachineData.lightState){
               MachineAPI.setLightState(MachineAPI.DIG_STATE_ONE)
           }
        }//

        UtilsApp {
            id: utilsApp
        }

        /// Execute This Every This Screen Active/Visible
        Loader {
            active: viewApp.stackViewStatusForeground
            sourceComponent: Item {

                /// onResume
                Component.onCompleted: {
                    //                    ////console.debug("StackView.Active-" + viewApp.uri);
                    if(MachineData.installationWizardActive){
                        viewApp.enabledSwipedFromLeftEdge   = false
                        //viewApp.enabledSwipedFromRightEdge  = false
                        viewApp.enabledSwipedFromBottomEdge = false
                    }//
                }//

                /// onPause
                Component.onDestruction: {
                    //                    ////console.debug("StackView.DeActivating");
                }

                Connections{
                    target: viewApp

                    function onFinishViewReturned(intent){
                        //                        ////console.debug("onFinishViewReturned-" + viewApp.uri)

                        let extradata = IntentApp.getExtraData(intent)

                        if (extradata['pid'] === 'meaifanomdimfield'){
                            //////console.debug(JSON.stringify(extradata['result']['grid']))
                            props.meaIfaNominalGrid             = extradata['calibrateRes']['grid']
                            props.meaIfaNominalVolume           = extradata['calibrateRes']['volume']
                            props.meaIfaNominalAverage          = extradata['calibrateRes']['volAvg']
                            props.meaIfaNominalTotal            = extradata['calibrateRes']['volTotal']

                            let velocity = extradata['calibrateRes']['velocity']
                            props.meaIfaNominalVelocity = velocity * 100

                            if(props.fanDutyCycleNominal !== extradata['calibrateRes']['fanDucy']){
                                /// Reset the status of secondary and Downflow (Nominal)
                                props.menuModel[0]['submenu'][1]['submenu'][0]['badge'] = 0 //Inflow Sec Nom
                                props.menuModel[1]['badge'] = 0 //Downflow Nom
                                /// update to current menu
                                menuStackView.currentItem.model = props.menuModel[0]['submenu']
                                /// update to parent menu
                                menuStackView.get(0)['model'] = props.menuModel

                                props.calibNewInflowNomSec = false
                                props.calibNewDownflowNom = false

                                MachineAPI.setAirflowFieldCalibrationState(MachineAPI.CalFieldState_InflowSecNominal, false)
                                MachineAPI.setAirflowFieldCalibrationState(MachineAPI.CalFieldState_DownflowNominal, false)
                            }//

                            props.fanDutyCycleNominal   = extradata['calibrateRes']['fanDucy']
                            props.fanRpmNominal         = extradata['calibrateRes']['fanRpm']

                            console.log("fanDutyCycleNominal: " + props.fanDutyCycleNominal)

                            MachineAPI.setFanPrimaryNominalDutyCycleField(props.fanDutyCycleNominal)
                            MachineAPI.setFanPrimaryNominalRpmField(props.fanRpmNominal)

                            if(props.measurementUnit) velocity = Math.round(velocity)
                            props.sensorVelNominal      = velocity * 100

                            MachineAPI.setInflowVelocityPointField(MachineAPI.POINT_NOMINAL, props.sensorVelNominal)

                            MachineAPI.saveInflowMeaDimNominalGrid(props.meaIfaNominalGrid,
                                                                   props.meaIfaNominalTotal,
                                                                   props.meaIfaNominalAverage,
                                                                   props.meaIfaNominalVolume,
                                                                   props.meaIfaNominalVelocity,
                                                                   props.fanDutyCycleNominal,
                                                                   props.fanRpmNominal,
                                                                   MachineAPI.CALIB_MODE_FIELD)
                            MachineAPI.setAirflowFieldCalibrationState(MachineAPI.CalFieldState_InflowDimNominal, true)

                            //////console.debug('bagde')
                            let nomDimDone  = props.menuModel[0]['submenu'][0]['submenu'][0]['badge']
                            if (!nomDimDone){
                                /// set bagde value to main model
                                props.menuModel[0]['submenu'][0]['submenu'][0]['badge'] = 1
                                /// update to current menu
                                menuStackView.currentItem.model = props.menuModel[0]['submenu'][0]['submenu']
                                /// update to parent menu
                                menuStackView.get(0)['model'] = props.menuModel
                            }

                            props.calibNewInflowNom = true

                            // Set Standby
                            props.fanDutyCycleStandby  = 0.3 * props.fanDutyCycleNominal //30% of nominal Fan
                            props.fanRpmStandby        = 0 // Will be Set later when in standby mode

                            //console.log("fanDutyCycleStb: " + props.fanDutyCycleStandby)

                            MachineAPI.setFanPrimaryStandbyDutyCycleField(props.fanDutyCycleStandby)
                            MachineAPI.setFanPrimaryStandbyRpmField(props.fanRpmStandby)

                        }//
                        else if (extradata['pid'] === 'meaifamindimfield'){
                            //////console.debug(JSON.stringify(extradata['result']['grid']))
                            props.meaIfaMinimumGrid             = extradata['calibrateRes']['grid']
                            props.meaIfaMinimumVolume           = extradata['calibrateRes']['volume']
                            props.meaIfaMinimumAverage          = extradata['calibrateRes']['volAvg']
                            props.meaIfaMinimumTotal            = extradata['calibrateRes']['volTotal']

                            let velocity = extradata['calibrateRes']['velocity']
                            props.meaIfaMinimumVelocity = velocity * 100

                            if(props.fanDutyCycleMinimum !== extradata['calibrateRes']['fanDucy']){
                                /// Reset the status of Inflow secondary (Minimum)
                                props.menuModel[0]['submenu'][1]['submenu'][1]['badge'] = 0 //Inflow Sec Min
                                /// update to current menu
                                menuStackView.currentItem.model = props.menuModel[0]['submenu']
                                /// update to parent menu
                                menuStackView.get(0)['model'] = props.menuModel

                                props.calibNewInflowMinSec = false

                                MachineAPI.setAirflowFieldCalibrationState(MachineAPI.CalFieldState_InflowSecMinimum, false)
                            }//

                            props.fanDutyCycleMinimum   = extradata['calibrateRes']['fanDucy']
                            props.fanRpmMinimum         = extradata['calibrateRes']['fanRpm']

                            console.log("fanDutyCycleMinimum: " + props.fanDutyCycleMinimum)

                            MachineAPI.setFanPrimaryMinimumDutyCycleField(props.fanDutyCycleMinimum)
                            MachineAPI.setFanPrimaryMinimumRpmField(props.fanRpmMinimum)

                            if(props.measurementUnit) velocity = Math.round(velocity)
                            props.sensorVelMinimum      = velocity * 100

                            MachineAPI.setInflowVelocityPointField(MachineAPI.POINT_NOMINAL, props.sensorVelMinimum)

                            MachineAPI.saveInflowMeaDimMinimumGrid(props.meaIfaMinimumGrid,
                                                                   props.meaIfaMinimumTotal,
                                                                   props.meaIfaMinimumAverage,
                                                                   props.meaIfaMinimumVolume,
                                                                   props.meaIfaMinimumVelocity,
                                                                   props.fanDutyCycleMinimum,
                                                                   props.fanRpmMinimum,
                                                                   MachineAPI.CALIB_MODE_FIELD)
                            MachineAPI.setAirflowFieldCalibrationState(MachineAPI.CalFieldState_InflowDimMinimum, true)

                            //                            ////console.debug('bagde')
                            let minDimDone  = props.menuModel[0]['submenu'][0]['submenu'][1]['badge']
                            if (!minDimDone){
                                /// set bagde value to main model
                                props.menuModel[0]['submenu'][0]['submenu'][1]['badge'] = 1
                                /// update to current menu
                                menuStackView.currentItem.model = props.menuModel[0]['submenu'][0]['submenu']
                                /// update to parent menu
                                menuStackView.get(0)['model'] = props.menuModel
                            }

                            props.calibNewInflowMin = true
                        }//
                        else if (extradata['pid'] === 'meaifastbdimfield'){
                            //////console.debug(JSON.stringify(extradata['result']['grid']))
                            props.meaIfaStbGrid             = extradata['calibrateRes']['grid']
                            props.meaIfaStbVolume           = extradata['calibrateRes']['volume']
                            props.meaIfaStbAverage          = extradata['calibrateRes']['volAvg']
                            props.meaIfaStbTotal            = extradata['calibrateRes']['volTotal']

                            let velocity = extradata['calibrateRes']['velocity']
                            props.meaIfaStbVelocity = velocity * 100

                            if(props.fanDutyCycleStandby !== extradata['calibrateRes']['fanDucy']){
                                /// Reset the status of Inflow secondary (Standby)
                                props.menuModel[0]['submenu'][1]['submenu'][2]['badge'] = 0 //Inflow Sec Standby
                                /// update to current menu
                                menuStackView.currentItem.model = props.menuModel[0]['submenu']
                                /// update to parent menu
                                menuStackView.get(0)['model'] = props.menuModel

                                props.calibNewInflowStbSec = false

                                MachineAPI.setAirflowFieldCalibrationState(MachineAPI.CalFieldState_InflowSecStandby, false)
                            }//

                            props.fanDutyCycleStandby  = extradata['calibrateRes']['fanDucy']
                            props.fanRpmStandby        = extradata['calibrateRes']['fanRpm']

                            console.log("fanDutyCycleStb: " + props.fanDutyCycleStandby)

                            MachineAPI.setFanPrimaryStandbyDutyCycleField(props.fanDutyCycleStandby)
                            MachineAPI.setFanPrimaryStandbyRpmField(props.fanRpmStandby)

                            if(props.measurementUnit) velocity = Math.round(velocity)
                            props.sensorVelStandby      = velocity * 100

                            // MachineAPI.setInflowVelocityPointField(MachineAPI.POINT_NOMINAL, props.sensorVelStandby)

                            MachineAPI.saveInflowMeaDimStandbyGrid(props.meaIfaStbGrid,
                                                                   props.meaIfaStbTotal,
                                                                   props.meaIfaStbAverage,
                                                                   props.meaIfaStbVolume,
                                                                   props.meaIfaStbVelocity,
                                                                   props.fanDutyCycleStandby,
                                                                   props.fanRpmStandby,
                                                                   MachineAPI.CALIB_MODE_FIELD)
                            MachineAPI.setAirflowFieldCalibrationState(MachineAPI.CalFieldState_InflowDimStandby, true)

                            //                            ////console.debug('bagde')
                            let stbDimDone  = props.menuModel[0]['submenu'][0]['submenu'][2]['badge']
                            if (!stbDimDone){
                                /// set bagde value to main model
                                props.menuModel[0]['submenu'][0]['submenu'][2]['badge'] = 1
                                /// update to current menu
                                menuStackView.currentItem.model = props.menuModel[0]['submenu'][0]['submenu']
                                /// update to parent menu
                                menuStackView.get(0)['model'] = props.menuModel
                            }//

                            props.calibNewInflowStb = true
                        }//

                        else if (extradata['pid'] === 'meaifanomsecfield'){
                            //// //console.debug('bagde')

                            props.meaIfaNominalSecGrid = extradata['calibrateRes']['grid']

                            let meaIfaNominalSecTot = extradata['calibrateRes']['velTotal'] || 0
                            props.meaIfaNominalSecTot  = meaIfaNominalSecTot * 100
                            let meaIfaNominalSecAvg  = extradata['calibrateRes']['velAvg'] || 0
                            props.meaIfaNominalSecAvg  = meaIfaNominalSecAvg * 100

                            let velocity = extradata['calibrateRes']['velocity']
                            props.meaIfaNominalSecVelocity = velocity * 100
                            ////console.debug(props.meaIfaNominalSecVelocity)

                            if(props.fanDutyCycleNominal !== extradata['calibrateRes']['fanDucy']){
                                /// Reset the status of DIM and Downflow (Nominal)
                                props.menuModel[0]['submenu'][0]['submenu'][0]['badge'] = 0 //Inflow DIM Nom
                                props.menuModel[1]['badge'] = 0
                                /// update to current menu
                                menuStackView.currentItem.model = props.menuModel[0]['submenu']
                                /// update to parent menu
                                menuStackView.get(0)['model'] = props.menuModel

                                props.calibNewInflowNom = false
                                props.calibNewDownflowNom = false

                                MachineAPI.setAirflowFieldCalibrationState(MachineAPI.CalFieldState_InflowDimNominal, false)
                                MachineAPI.setAirflowFieldCalibrationState(MachineAPI.CalFieldState_DownflowNominal, false)
                            }//

                            props.fanDutyCycleNominal   = extradata['calibrateRes']['fanDucy'] || 0
                            props.fanRpmNominal         = extradata['calibrateRes']['fanRpm'] || 0

                            console.log("fanDutyCycleNominal: " + props.fanDutyCycleNominal)

                            MachineAPI.setFanPrimaryNominalDutyCycleField(props.fanDutyCycleNominal)
                            MachineAPI.setFanPrimaryNominalRpmField(props.fanRpmNominal)

                            if(props.measurementUnit) velocity = Math.round(velocity)
                            props.sensorVelNominal = velocity * 100

                            MachineAPI.setInflowVelocityPointField(MachineAPI.POINT_NOMINAL, props.sensorVelNominal)

                            MachineAPI.saveInflowMeaSecNominalGrid(props.meaIfaNominalSecGrid,
                                                                   props.meaIfaNominalSecTot,
                                                                   props.meaIfaNominalSecAvg,
                                                                   props.meaIfaNominalSecVelocity,
                                                                   props.fanDutyCycleNominal,
                                                                   props.fanRpmNominal,
                                                                   MachineAPI.CALIB_MODE_FIELD)
                            MachineAPI.setAirflowFieldCalibrationState(MachineAPI.CalFieldState_InflowSecNominal, true)

                            let nomSecDone = props.menuModel[0]['submenu'][1]['submenu'][0]['badge']
                            if (!nomSecDone) {
                                /// set bagde value to main model
                                props.menuModel[0]['submenu'][1]['submenu'][0]['badge'] = 1
                                /// update to current menu
                                menuStackView.currentItem.model = props.menuModel[0]['submenu'][1]['submenu']
                                /// update to parent menu
                                menuStackView.get(0)['model'] = props.menuModel
                            }

                            props.calibNewInflowNomSec = true
                        }//
                        else if (extradata['pid'] === 'meaifaminsecfield'){
                            //                            ////console.debug('bagde')

                            props.meaIfaMinimumSecGrid = extradata['calibrateRes']['grid']

                            let meaIfaMinimumSecTot = extradata['calibrateRes']['velTotal'] || 0
                            props.meaIfaMinimumSecTot  = meaIfaMinimumSecTot * 100
                            let meaIfaMinimumSecAvg  = extradata['calibrateRes']['velAvg'] || 0
                            props.meaIfaMinimumSecAvg  = meaIfaMinimumSecAvg * 100

                            let velocity = extradata['calibrateRes']['velocity']
                            props.meaIfaMinimumSecVelocity = velocity * 100
                            ////console.debug(props.meaIfaMinimumSecVelocity)

                            if(props.fanDutyCycleMinimum !== extradata['calibrateRes']['fanDucy']){
                                /// Reset the status of dim
                                props.menuModel[0]['submenu'][0]['submenu'][1]['badge'] = 0
                                /// update to current menu
                                menuStackView.currentItem.model = props.menuModel[0]['submenu']
                                /// update to parent menu
                                menuStackView.get(0)['model'] = props.menuModel

                                props.calibNewInflowMin = false
                                MachineAPI.setAirflowFieldCalibrationState(MachineAPI.CalFieldState_InflowDimMinimum, false)
                            }//

                            props.fanDutyCycleMinimum   = extradata['calibrateRes']['fanDucy'] || 0
                            props.fanRpmMinimum         = extradata['calibrateRes']['fanRpm'] || 0

                            console.log("fanDutyCycleMinimum: " + props.fanDutyCycleMinimum)

                            MachineAPI.setFanPrimaryMinimumDutyCycleField(props.fanDutyCycleMinimum)
                            MachineAPI.setFanPrimaryMinimumRpmField(props.fanRpmMinimum)

                            if(props.measurementUnit) velocity = Math.round(velocity)
                            props.sensorVelMinimum = velocity * 100

                            MachineAPI.setInflowVelocityPointField(MachineAPI.POINT_NOMINAL, props.sensorVelMinimum)

                            MachineAPI.saveInflowMeaSecMinimumGrid(props.meaIfaMinimumSecGrid,
                                                                   props.meaIfaMinimumSecTot,
                                                                   props.meaIfaMinimumSecAvg,
                                                                   props.meaIfaMinimumSecVelocity,
                                                                   props.fanDutyCycleMinimum,
                                                                   props.fanRpmMinimum,
                                                                   MachineAPI.CALIB_MODE_FIELD)
                            MachineAPI.setAirflowFieldCalibrationState(MachineAPI.CalFieldState_InflowSecMinimum, true)


                            let minSecDone = props.menuModel[0]['submenu'][1]['submenu'][1]['badge']
                            if (!minSecDone) {
                                /// set bagde value to main model
                                props.menuModel[0]['submenu'][1]['submenu'][1]['badge'] = 1
                                /// update to current menu
                                menuStackView.currentItem.model = props.menuModel[0]['submenu'][1]['submenu']
                                /// update to parent menu
                                menuStackView.get(0)['model'] = props.menuModel
                            }

                            props.calibNewInflowMinSec = true
                        }//
                        else if (extradata['pid'] === 'meaifastbsecfield'){
                            //                            ////console.debug('bagde')

                            props.meaIfaStbSecGrid = extradata['calibrateRes']['grid']

                            let meaIfaStbSecTot = extradata['calibrateRes']['velTotal'] || 0
                            props.meaIfaStbSecTot  = meaIfaStbSecTot * 100
                            let meaIfaStbSecAvg  = extradata['calibrateRes']['velAvg'] || 0
                            props.meaIfaStbSecAvg  = meaIfaStbSecAvg * 100

                            let velocity = extradata['calibrateRes']['velocity']
                            props.meaIfaStbSecVelocity = velocity * 100
                            ////console.debug(props.meaIfaStbSecVelocity)

                            if(props.fanDutyCycleStandby !== extradata['calibrateRes']['fanDucy']){
                                /// Reset the status of dim
                                props.menuModel[0]['submenu'][0]['submenu'][2]['badge'] = 0
                                /// update to current menu
                                menuStackView.currentItem.model = props.menuModel[0]['submenu']
                                /// update to parent menu
                                menuStackView.get(0)['model'] = props.menuModel

                                props.calibNewInflowStb = false
                                MachineAPI.setAirflowFieldCalibrationState(MachineAPI.CalFieldState_InflowDimStandby, false)
                            }//

                            props.fanDutyCycleStandby   = extradata['calibrateRes']['fanDucy'] || 0
                            props.fanRpmStandby         = extradata['calibrateRes']['fanRpm'] || 0

                            console.log("fanDutyCycleStb: " + props.fanDutyCycleStandby)

                            MachineAPI.setFanPrimaryStandbyDutyCycleField(props.fanDutyCycleStandby)
                            MachineAPI.setFanPrimaryStandbyRpmField(props.fanRpmStandby)

                            if(props.measurementUnit) velocity = Math.round(velocity)
                            props.sensorVelStandby = velocity * 100

                            // MachineAPI.setInflowVelocityPointField(MachineAPI.POINT_NOMINAL, props.sensorVelStandby)

                            MachineAPI.saveInflowMeaSecStandbyGrid(props.meaIfaStbSecGrid,
                                                                   props.meaIfaStbSecTot,
                                                                   props.meaIfaStbSecAvg,
                                                                   props.meaIfaStbSecVelocity,
                                                                   props.fanDutyCycleStandby,
                                                                   props.fanRpmStandby,
                                                                   MachineAPI.CALIB_MODE_FIELD)
                            MachineAPI.setAirflowFieldCalibrationState(MachineAPI.CalFieldState_InflowSecStandby, true)

                            let stbSecDone = props.menuModel[0]['submenu'][1]['submenu'][2]['badge']
                            if (!stbSecDone) {
                                /// set bagde value to main model
                                props.menuModel[0]['submenu'][1]['submenu'][2]['badge'] = 1
                                /// update to current menu
                                menuStackView.currentItem.model = props.menuModel[0]['submenu'][1]['submenu']
                                /// update to parent menu
                                menuStackView.get(0)['model'] = props.menuModel
                            }

                            props.calibNewInflowStbSec = true

                            // Set Standby
                            props.fanDutyCycleStandby  = 0.3 * props.fanDutyCycleNominal //30% of nominal Fan
                            props.fanRpmStandby        = 0 // Will be Set later when in standby mode

                            //console.log("fanDutyCycleStb: " + props.fanDutyCycleStandby)

                            MachineAPI.setFanPrimaryStandbyDutyCycleField(props.fanDutyCycleStandby)
                            MachineAPI.setFanPrimaryStandbyRpmField(props.fanRpmStandby)
                        }//

                        else if (extradata['pid'] === 'meadfanomfield'){

                            props.meaDfaNominalGrid                 = extradata['calibrateRes']['grid']
                            props.meaDfaNominalVelocityTotal        = Math.round(extradata['calibrateRes']['velSum'] * 100)
                            props.meaDfaNominalVelocity             = Math.round(extradata['calibrateRes']['velocity'] * 100)
                            props.meaDfaNominalVelocityLowest       = Math.round(extradata['calibrateRes']['velLow'] * 100)
                            props.meaDfaNominalVelocityHighest      = Math.round(extradata['calibrateRes']['velHigh'] * 100)
                            props.meaDfaNominalVelocityDeviation    = Math.round(extradata['calibrateRes']['velDev'] * 100)
                            props.meaDfaNominalVelocityDeviationp   = Math.round(extradata['calibrateRes']['velDevp'] * 100)

                            //                            ////console.debug(extradata['calibrateRes']['velDev'])
                            //                            ////console.debug(extradata['calibrateRes']['velDevp'])

                            //                            ////console.debug(props.meaDfaNominalVelocityDeviation)
                            //                            ////console.debug(props.meaDfaNominalVelocityDeviationp)

                            //                            props.calibrateResValues['measure']['dfa']['nominal']['grid'] = extradata['calibrateRes']['grid']
                            //                            ////console.debug(JSON.stringify(props.calibrateResValues['measure']['dfa']['nominal']['grid']))

                            //                            if(props.fanDutyCycleNominal !== extradata['calibrateRes']['fanDucy']){
                            //                                /// Reset the status of dim and Downflow
                            //                                props.menuModel[0]['submenu'][0]['badge'] = 0
                            //                                props.menuModel[0]['submenu'][1]['badge'] = 0
                            //                                //props.menuModel[0]['badge'] = 0
                            //                                /// update to current menu
                            //                                menuStackView.currentItem.model = props.menuModel[0]['submenu']
                            //                                /// update to parent menu
                            //                                menuStackView.get(0)['model'] = props.menuModel

                            //                                props.calibNewInflowNom = false
                            //                                props.calibNewInflowNomSec = false
                            //                            }//

                            props.fanDutyCycleNominal  = extradata['calibrateRes']['fanDucy']
                            props.fanRpmNominal        = extradata['calibrateRes']['fanRpm']

                            let velocity = extradata['calibrateRes']['velocity']
                            if(props.measurementUnit) velocity = Math.round(velocity)
                            props.sensorVelNominalDfa  = velocity * 100

                            MachineAPI.setDownflowVelocityPointField(MachineAPI.POINT_NOMINAL, props.sensorVelNominalDfa)

                            MachineAPI.saveDownflowMeaNominalGrid(props.meaDfaNominalGrid,
                                                                  props.meaDfaNominalVelocityTotal,
                                                                  props.meaDfaNominalVelocity,
                                                                  props.meaDfaNominalVelocityLowest,
                                                                  props.meaDfaNominalVelocityHighest,
                                                                  props.meaDfaNominalVelocityDeviation,
                                                                  props.meaDfaNominalVelocityDeviationp,
                                                                  MachineAPI.CALIB_MODE_FIELD)
                            MachineAPI.setAirflowFieldCalibrationState(MachineAPI.CalFieldState_DownflowNominal, true)

                            let done  = props.menuModel[1]['badge']
                            if (!done) {
                                /// set bagde value to main model
                                props.menuModel[1]['badge'] = 1
                                /// update to current menu
                                menuStackView.currentItem.model = props.menuModel
                            }

                            props.calibNewDownflowNom = true
                        }//

                        else if (extradata['pid'] === 'senconst'){
                            const sensorConst = extradata['sensorConstant'] || 0
                            props.sensorConstant = sensorConst

                            //Direct save to backend
                            MachineAPI.setInflowSensorConstant(props.sensorConstant);

                            let done  = props.menuModel[2]['badge']
                            if (!done){
                                /// set bagde value to main model
                                props.menuModel[2]['badge'] = 1
                                /// update to current menu
                                menuStackView.currentItem.model = props.menuModel
                            }//

                            MachineAPI.setAirflowFieldCalibrationState(MachineAPI.CalFieldState_SensorConstant, true)

                            props.calibNewSensorConst = true
                        }//

                        else if (extradata['pid'] === 'directAdcCalib'){
                            //props.sensorAdcNominal = extradata['sensorAdcNominal'] || 0

                            //props.fanDutyCycleNominal  = extradata['fanDutyCycleResult']
                            //props.fanRpmNominal        = extradata['fanRpmResult']

                            //props.sensorAdcNominal     = extradata['sensorAdcNominal'] || 0
                            //props.sensorAdcMinimum     = extradata['sensorAdcMinimum'] || 0

                            //let velocity = extradata['sensorVelNominal']
                            //if(props.measurementUnit) velocity = Math.round(velocity)
                            //props.sensorVelNominal = velocity * 100

                            //velocity = extradata['sensorVelNominalDfa']
                            //if(props.measurementUnit) velocity = Math.round(velocity)
                            //props.sensorVelNominalDfa   = velocity * 100

                            //props.temperatureCalib      = extradata['temperatureCalib'] || 0
                            //props.temperatureAdcCalib   = extradata['temperatureCalibAdc'] || 0

                            let done  = props.menuModel[3]['badge']
                            if (!done) {
                                /// set bagde value to main model
                                props.menuModel[3]['badge'] = 1
                                /// update to current menu
                                menuStackView.currentItem.model = props.menuModel
                            }

                            MachineAPI.setAirflowFieldCalibrationState(MachineAPI.CalFieldState_AdcCalib, true)

                            props.calibNewAdc = true
                            props.saveCalibrationData()
                        }//

                        props.refreshBadge()
                    }//
                }//
            }//
        }//
    }//
}//
