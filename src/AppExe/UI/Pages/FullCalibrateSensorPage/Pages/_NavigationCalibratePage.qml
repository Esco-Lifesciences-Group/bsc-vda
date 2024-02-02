import QtQuick 2.12
import QtQuick.Layouts 1.0
import QtQuick.Controls 2.0
import Qt.labs.settings 1.0

import UI.CusCom 1.1
import "../../../CusCom/JS/IntentApp.js" as IntentApp

import ModulesCpp.Machine 1.0

ViewApp {
    id: viewApp
    title: "Full Sensor Calibration"

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
                    id: headerApp
                    anchors.fill: parent
                    title: qsTr("Full Sensor Calibration")
                }//
            }//

            /// BODY
            Item {
                id: bodyItem
                Layout.fillWidth: true
                Layout.fillHeight: true

                /// Handle sub menu with StackView

                ColumnLayout {
                    anchors.fill: parent

                    Item {
                        Layout.fillWidth: true
                        Layout.minimumHeight: 200

                        PageIndicator {
                            id: calibrationPhasePageIndicator
                            anchors.centerIn: parent
                            count: 2
                            //                            currentIndex: menuItemView.currentIndex > 3 ? 1 : 0

                            property var title: [qsTr("Airflow Balancing"), qsTr("Microprocessor ADC")]

                            delegate: Rectangle {
                                implicitWidth: 250
                                implicitHeight: 50
                                radius: 10
                                color: "#0F2952"

                                opacity: index === calibrationPhasePageIndicator.currentIndex ? 0.95 : pressed ? 0.7 : 0.45

                                TextApp {
                                    anchors.fill: parent
                                    horizontalAlignment: Text.AlignHCenter
                                    verticalAlignment: Text.AlignVCenter
                                    text: (index + 1) + ") " + calibrationPhasePageIndicator.title[index]
                                }//

                                MouseArea {
                                    anchors.fill: parent
                                    onClicked: {
                                        calibrationPhasePageIndicator.currentIndex = index
                                        if(menuStackView.depth > 1) menuStackView.clear()
                                        if (index == 0){
                                            menuStackView.replace(menuGridViewComponent, {"model": props.menuModelCabinet}, StackView.PopTransition)
                                        }
                                        else if(index == 1) {
                                            if((MachineData.getAirflowFactoryCalibrationState(MachineAPI.CalFactoryState_InflowDimNominal) === true)
                                                    && (MachineData.getAirflowFactoryCalibrationState(MachineAPI.CalFactoryState_DownflowNominal) === true)
                                                    && (MachineData.getAirflowFactoryCalibrationState(MachineAPI.CalFactoryState_InflowDimMinimum) === true)
                                                    && (MachineData.getAirflowFactoryCalibrationState(MachineAPI.CalFactoryState_InflowDimStandby) === true)){
                                                menuStackView.replace(menuGridViewComponent, {"model": props.menuModelMicroADC}, StackView.PushTransition)
                                            }//
                                            else{
                                                const message = qsTr("You have not completed the airflow balancing yet, are you sure you want to continue?")

                                                var autoClose = false
                                                viewApp.showDialogAsk(qsTr(viewApp.title),
                                                                      message,
                                                                      viewApp.dialogAlert,
                                                                      function onAccepted(){
                                                                          menuStackView.replace(menuGridViewComponent, {"model": props.menuModelMicroADC}, StackView.PushTransition)
                                                                      }, function onRejected(){
                                                                          calibrationPhasePageIndicator.currentIndex = index - 1
                                                                          return;
                                                                      }, function(){}, autoClose)
                                            }
                                        }
                                    }//
                                }//
                            }//
                        }//
                    }//

                    Item {
                        Layout.fillHeight: true
                        Layout.fillWidth: true

                        StackView {
                            id: menuStackView
                            anchors.fill: parent
                        }//
                    }//
                }//

                /// Menu Component
                Component {
                    id: menuGridViewComponent

                    Item {
                        property alias model: menuItemView.model
                        property alias currentIndex: menuItemView.currentIndex
                        property alias listviewContentX: menuItemView.contentX

                        ListView {
                            id: menuItemView
                            // anchors.fill: parent
                            //If model less than 4, make it center
                            anchors.centerIn: parent
                            width: count < 4 ? (count * (parent.width / 4)) : parent.width
                            height: parent.height //count < 4 ? parent.height / 2 : parent.height
                            //                            height: 250
                            //                            width: parent.width
                            //                            anchors.verticalCenter: parent.verticalCenter
                            clip: true
                            snapMode: ListView.SnapToItem
                            flickableDirection: Flickable.AutoFlickIfNeeded
                            orientation: ListView.Horizontal

                            ScrollBar.horizontal: ScrollBar{}

                            //                                    highlightMoveDuration: 1000
                            //                                    highlightMoveVelocity: -1
                            //                                    highlightRangeMode: ListView.ApplyRange

                            delegate: Item{
                                height: 250
                                width: 250
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
                                        if (modelData.mtype === "submenu") {
                                            menuStackView.push(menuGridViewComponent, {"model": modelData.submenu})
                                        }else {
                                            props.lastSelectedMenuIndex = index
                                            props.openPage(modelData.pid, modelData.mlink, modelData.mtitle)
                                        }
                                    }//
                                    onPressAndHold: {
                                        console.log("index", index, ")", modelData.pid, modelData.mtitle)
                                        const pid = modelData.pid
                                        if(modelData.badge){
                                            showDialogAsk(modelData.mtitle,
                                                          qsTr("Clear the 'Done' badge?"),
                                                          dialogAlert,
                                                          function onAccepted(){
                                                              if(pid === "meaifanom"){
                                                                  MachineAPI.setAirflowFactoryCalibrationState(MachineAPI.CalFactoryState_InflowDimNominal, false)
                                                                  props.menuModelCabinet[0]['badge'] = 0
                                                                  menuStackView.currentItem.model = props.menuModelCabinet
                                                              }else if(pid === "meaifamin"){
                                                                  MachineAPI.setAirflowFactoryCalibrationState(MachineAPI.CalFactoryState_InflowDimMinimum, false)
                                                                  props.menuModelCabinet[1]['badge'] = 0
                                                                  menuStackView.currentItem.model = props.menuModelCabinet
                                                              }else if(pid === "meaifastb"){
                                                                  MachineAPI.setAirflowFactoryCalibrationState(MachineAPI.CalFactoryState_InflowDimStandby, false)
                                                                  props.menuModelCabinet[2]['badge'] = 0
                                                                  menuStackView.currentItem.model = props.menuModelCabinet
                                                              }else if(pid === "meadfanom"){
                                                                  MachineAPI.setAirflowFactoryCalibrationState(MachineAPI.CalFactoryState_DownflowNominal, false)
                                                                  props.menuModelCabinet[3]['badge'] = 0
                                                                  menuStackView.currentItem.model = props.menuModelCabinet
                                                              }else if(pid === "senconst"){
                                                                  MachineAPI.setAirflowFactoryCalibrationState(MachineAPI.CalFactoryState_SensorConstant, false)
                                                                  /// set bagde value to main model
                                                                  props.menuModelMicroADC[0]['badge'] = 0
                                                                  /// update to current menu
                                                                  menuStackView.currentItem.model = props.menuModelMicroADC
                                                              }//
                                                          })
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
                                    menuStackView.pop()
                                }
                                else {
                                    var intent = IntentApp.create(uri, {})
                                    finishView(intent)
                                }
                            }//
                        }//

                        ButtonBarApp {
                            width: 194
                            anchors.verticalCenter: parent.verticalCenter
                            anchors.right: parent.right
                            visible: calibrationPhasePageIndicator.currentIndex === 1

                            imageSource: "qrc:/UI/Pictures/start_small.png"
                            text: qsTr("Start ADC Calibration")

                            onClicked: {
                                if(MachineData.sashWindowState === MachineAPI.SASH_STATE_WORK_SSV){
                                    const allDone = MachineData.getAirflowFactoryCalibrationState(MachineAPI.CalFactoryState_InflowDimNominal)
                                                  && MachineData.getAirflowFactoryCalibrationState(MachineAPI.CalFactoryState_InflowDimMinimum)
                                                  && MachineData.getAirflowFactoryCalibrationState(MachineAPI.CalFactoryState_InflowDimStandby)
                                                  && MachineData.getAirflowFactoryCalibrationState(MachineAPI.CalFactoryState_DownflowNominal)
                                                  && MachineData.getAirflowFactoryCalibrationState(MachineAPI.CalFactoryState_SensorConstant)
                                    if(!allDone){
                                        showDialogAsk(qsTr("Start ADC Calibration"),
                                                      qsTr("There is a calibration stage that seems to have not been completed.")
                                                      + "<br>" + qsTr("Are you sure you want to continue?"),
                                                      dialogAlert,
                                                      function onAccepted(){
                                                          MachineAPI.insertEventLog(qsTr("User: Start ADC Calibration of Full Sensor Calibration."))
                                                          props.openPage("directAdcCalib",
                                                                         "qrc:/UI/Pages/FullCalibrateSensorPage/Pages/ADCDirectCalibrationPage.qml",
                                                                         qsTr("ADC Calibration"))
                                                      })
                                    }else{
                                        MachineAPI.insertEventLog(qsTr("User: Start ADC Calibration of Full Sensor Calibration."))
                                        props.openPage("directAdcCalib",
                                                       "qrc:/UI/Pages/FullCalibrateSensorPage/Pages/ADCDirectCalibrationPage.qml",
                                                       qsTr("ADC Calibration"))
                                    }
                                }//
                                else{
                                    const message = "<b>" + qsTr("Please adjust the height of the sash to working height position!") + "</b>"
                                    showDialogMessage(qsTr("Full Sensor Calibration"),
                                                      message,
                                                      dialogAlert,
                                                      function(){})
                                }
                            }//
                        }//
                    }//
                }//
            }//
        }//

        QtObject {
            id: props

            function openPage(pid, uri, title){

                if (pid === 'meaifanom'){
                    let calibrateReq = props.calibrateReqValues['measure']['ifa']['nominal']

                    let intent = IntentApp.create(uri,
                                                  {
                                                      'pid': pid,
                                                      'title': title,
                                                      "measureUnit": props.measurementUnit,
                                                      'grid': props.meaIfaNominalGrid,
                                                      'fanDutyCycle': props.fanDutyCycleNominal,
                                                      'calibrateReq': calibrateReq
                                                  })
                    startView(intent)
                }//
                else if (pid === 'meaifamin'){
                    //                    if(MachineData.getAirflowFactoryCalibrationState(0) !== true){
                    //                        const message = "<b>" + qsTr("Inflow Nominal not calibrated yet!") + "</b>" + "<br><br>" +
                    //                                      qsTr("It's mandatory to calibrate Inflow Nominal before going to Inflow Minimum!")
                    //                        showDialogMessage(qsTr("Notification"), message, dialogAlert, function(){}, false)
                    //                        return
                    //                    }

                    let calibrateReq = props.calibrateReqValues['measure']['ifa']['minimum']

                    let intent = IntentApp.create(uri,
                                                  {
                                                      'pid': pid,
                                                      'title': title,
                                                      "measureUnit": props.measurementUnit,
                                                      //                                                      'grid': grid,
                                                      'grid': props.meaIfaMinimumGrid,
                                                      'fanDutyCycle': props.fanDutyCycleMinimum,
                                                      'calibrateReq': calibrateReq
                                                  })
                    startView(intent)
                }//
                else if (pid === 'meaifastb'){
                    //                    if(MachineData.getAirflowFactoryCalibrationState(0) !== true){
                    //                        const message = "<b>" + qsTr("Inflow Nominal not calibrated yet!") + "</b>" + "<br><br>" +
                    //                                      qsTr("It's mandatory to calibrate Inflow Nominal before going to Inflow Standby!")
                    //                        showDialogMessage(qsTr("Notification"), message, dialogAlert, function(){}, false)
                    //                        return
                    //                    }

                    let calibrateReq = props.calibrateReqValues['measure']['ifa']['stb']

                    let intent = IntentApp.create(uri,
                                                  {
                                                      'pid': pid,
                                                      'title': title,
                                                      "measureUnit": props.measurementUnit,
                                                      'grid': props.meaIfaStandbyGrid,
                                                      'fanDutyCycle': props.fanDutyCycleStandby,
                                                      'calibrateReq': calibrateReq
                                                  })
                    startView(intent)
                }//
                else if (pid === 'meadfanom'){
                    let calibrateReq = props.calibrateReqValues['measure']['dfa']['nominal']

                    let intent = IntentApp.create(uri,
                                                  {
                                                      'pid': pid,
                                                      'title': title,
                                                      "measureUnit": props.measurementUnit,
                                                      'grid': props.meaDfaNominalGrid,
                                                      'fanDutyCycle': props.fanDutyCycleNominal,
                                                      'calibrateReq': calibrateReq
                                                  })
                    startView(intent)
                }//
                else if (pid === 'senconst'){
                    let intent = IntentApp.create(uri,
                                                  {
                                                      'pid': pid,
                                                      "sensorConstant": props.sensorConstant
                                                  })
                    startView(intent)
                }//
                //                else if (pid === 'adcz'){
                //                    let intent = IntentApp.create(uri,{"pid": pid})
                //                    startView(intent)
                //                }
                //                else if (pid === 'adcm'){
                //                    let intent = IntentApp.create(uri,
                //                                                  {
                //                                                      'pid': pid,
                //                                                      "measureUnit": props.measurementUnit,
                //                                                      "sensorAdcZero": props.sensorAdcZero,
                //                                                      "sensorVelMinimum": props.sensorVelMinimum / 100,
                //                                                      "sensorVelLowAlarm": props.sensorVelLowAlarm / 100,
                //                                                      'fanDutyCycle': props.fanDutyCycleMinimum
                //                                                  })
                //                    startView(intent)
                //                }//
                //                else if (pid === 'adcn'){

                //                    if(props.calibNewSensorConst && (/*!props.calibNewAdcZero || */!props.calibNewAdcMin)){
                //                        const message = "<b>" + qsTr("You have changed the sensor constant.") + "</b>" + "<br><br>" +
                //                                      qsTr("It is mandatory to re-calibrate ADC Minimum before proceeding with ADC Nominal!")
                //                        showDialogMessage(qsTr("Notification"), message, dialogAlert, function(){}, false)
                //                        return
                //                    }
                //                    else if(!props.calibNewAdcMin){
                //                        const message = "<b>" + qsTr("ADC Minimum not calibrated yet!") + "</b>" + "<br><br>" +
                //                                      qsTr("It is mandatory to calibrate ADC Minimum before proceeding with ADC Nominal!")
                //                        showDialogMessage(qsTr("Notification"), message, dialogAlert, function(){}, false)
                //                        return
                //                    }

                //                    let intent = IntentApp.create(uri,
                //                                                  {
                //                                                      'pid': pid,
                //                                                      "measureUnit": props.measurementUnit,
                //                                                      "sensorAdcZero": props.sensorAdcZero,
                //                                                      "sensorAdcMinimum": props.sensorAdcMinimum,
                //                                                      "sensorVelMinimum": props.sensorVelMinimum / 100,
                //                                                      "sensorVelNominal": props.sensorVelNominal / 100,
                //                                                      "sensorVelNominalDfa": props.sensorVelNominalDfa / 100,
                //                                                      'fanDutyCycle': props.fanDutyCycleNominal
                //                                                  })
                //                    startView(intent)
                //                }//
                else if(pid === 'directAdcCalib'){
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
                        let message = qsTr("There's an invalid value!")
                        if(!ducyValid){
                            message = qsTr("There's an invalid Duty cycle!") + "<br>"
                                    + qsTr("Standby") + ": %1%".arg(props.fanDutyCycleStandby) + "<br>"
                                    + qsTr("Minimum") + ": %1%".arg(props.fanDutyCycleMinimum) + "<br>"
                                    + qsTr("Nominal") + ": %1%".arg(props.fanDutyCycleNominal)
                        }
                        else if(!velocityValid){
                            message = qsTr("There's an invalid Velocity!") + "<br>"
                                    + qsTr("Minimum Inflow") + ": %1%".arg(props.sensorVelMinimum) + "<br>"
                                    + qsTr("Nominal Inflow") + ": %1%".arg(props.sensorVelNominal) + "<br>"
                                    + qsTr("Nominal Downflow") + ": %1%".arg(props.sensorVelNominalDfa)
                        }
                        if(!velocityFailValid && velocityValid && ducyValid){
                            props.sensorVelLowAlarm = props.sensorVelMinimum
                            props.openDirectAdcCalibration(uri, pid)
                        }else{
                            showDialogMessage(qsTr("Notification"), message, dialogAlert)
                        }//
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
                for (const label of ['nominal', 'minimum', 'stb']){
                    //                    ////console.debug(item)
                    props.calibrateReqValues['measure']['ifa'][label]['volume']             = profile['airflow']['ifa']['dim'][label][meaUnitStr]['volume']
                    props.calibrateReqValues['measure']['ifa'][label]['velocity']           = profile['airflow']['ifa']['dim'][label][meaUnitStr]['velocity']
                    props.calibrateReqValues['measure']['ifa'][label]['velocityTol']        = profile['airflow']['ifa']['dim'][label][meaUnitStr]['velocityTol']
                    props.calibrateReqValues['measure']['ifa'][label]['velocityTolLow']     = profile['airflow']['ifa']['dim'][label][meaUnitStr]['velocityTolLow']
                    props.calibrateReqValues['measure']['ifa'][label]['velocityTolHigh']    = profile['airflow']['ifa']['dim'][label][meaUnitStr]['velocityTolHigh']
                    props.calibrateReqValues['measure']['ifa'][label]['openingArea']        = profile['airflow']['ifa']['dim'][label][meaUnitStr]['openingArea']
                    props.calibrateReqValues['measure']['ifa'][label]['gridCount']          = profile['airflow']['ifa']['dim']['gridCount']
                }//

                if (MachineData.airflowCalibrationStatus === MachineAPI.AF_CALIB_FIELD) {
                    props.fanDutyCycleNominal = MachineData.getFanPrimaryNominalDutyCycleField()
                    props.fanDutyCycleMinimum = MachineData.getFanPrimaryMinimumDutyCycleField()
                    props.fanDutyCycleStandby = MachineData.getFanPrimaryStandbyDutyCycleField()
                }
                else /*if(MachineData.airflowCalibrationStatus === MachineAPI.AF_CALIB_FACTORY)*/{
                    props.fanDutyCycleNominal = MachineData.getFanPrimaryNominalDutyCycleFactory()
                    props.fanDutyCycleMinimum = MachineData.getFanPrimaryMinimumDutyCycleFactory()
                    props.fanDutyCycleStandby = MachineData.getFanPrimaryStandbyDutyCycleFactory()
                }
                //                else{
                //                    props.fanDutyCycleNominal = profile['airflow']['ifa']['dim']['nominal']['fanDutyCycle']
                //                    props.fanDutyCycleMinimum = profile['airflow']['ifa']['dim']['minimum']['fanDutyCycle']
                //                    props.fanDutyCycleStandby = profile['airflow']['ifa']['dim']['stb']['fanDutyCycle']
                //                }

                /// downflow
                props.calibrateReqValues['measure']['dfa']['nominal']['velocity']          = profile['airflow']['dfa']['nominal'][meaUnitStr]['velocity']
                props.calibrateReqValues['measure']['dfa']['nominal']['velocityTol']       = profile['airflow']['dfa']['nominal'][meaUnitStr]['velocityTol']
                props.calibrateReqValues['measure']['dfa']['nominal']['velocityTolLow']    = profile['airflow']['dfa']['nominal'][meaUnitStr]['velocityTolLow']
                props.calibrateReqValues['measure']['dfa']['nominal']['velocityTolHigh']   = profile['airflow']['dfa']['nominal'][meaUnitStr]['velocityTolHigh']
                props.calibrateReqValues['measure']['dfa']['nominal']['velDevp']           = profile['airflow']['dfa']['nominal']['velDevp']
                props.calibrateReqValues['measure']['dfa']['nominal']['grid']['count']     = profile['airflow']['dfa']['nominal']['grid']['count']
                props.calibrateReqValues['measure']['dfa']['nominal']['grid']['columns']   = profile['airflow']['dfa']['nominal']['grid']['columns']

                //                ///demo
                //                props.fanDutyCycleNominal = 5
                //                props.fanDutyCycleMinimum = 3
                //                props.fanDutyCycleStandby = 1

            }//

            /// Just remember, which last menu index number was selected
            /// this required to modified badge status on each menu item
            property int lastSelectedMenuIndex: 0

            property var menuModelCabinet: [
                {
                    mtype      : "menu",
                    mtitle     : qsTr("Nominal Inflow Measurement"),
                    micon      : "qrc:/UI/Pictures/menu/ifa_dim_nom_measure.png",
                    mlink      : "qrc:/UI/Pages/FullCalibrateSensorPage/Pages/MeasureInflowDimSetPage.qml",
                    badge      : 0,
                    badgeText  : qsTr("Done"),
                    pid        : "meaifanom",
                },
                {
                    mtype      : "menu",
                    mtitle     : qsTr("Minimum Inflow Measurement"),
                    micon      : "qrc:/UI/Pictures/menu/ifa_dim_min_measure.png",
                    mlink      : "qrc:/UI/Pages/FullCalibrateSensorPage/Pages/MeasureInflowDimSetPage.qml",
                    badge      : 0,
                    badgeText  : qsTr("Done"),
                    pid         : "meaifamin",
                },
                {
                    mtype         : "menu",
                    mtitle     : qsTr("Standby Inflow Measurement"),
                    micon      : "qrc:/UI/Pictures/menu/ifa_dim_stb_measure.png",
                    mlink      : "qrc:/UI/Pages/FullCalibrateSensorPage/Pages/MeasureInflowDimSetPage.qml",
                    badge      : 0,
                    badgeText  : qsTr("Done"),
                    pid         : "meaifastb",
                },
                {
                    mtype         : "menu",
                    mtitle     : qsTr("Downflow Measurement"),
                    micon      : "qrc:/UI/Pictures/menu/dfa_measure.png",
                    mlink      : "qrc:/UI/Pages/FullCalibrateSensorPage/Pages/MeasureDownflowSetPage.qml",
                    badge      : 0,
                    badgeText  : qsTr("Done"),
                    pid         : "meadfanom",
                },
            ]//
            property var menuModelMicroADC: [
                {
                    mtype      : "menu",
                    mtitle     : qsTr("Sensor Constant"),
                    micon      : "qrc:/UI/Pictures/menu/Set-Constant.png",
                    mlink      : "qrc:/UI/Pages/FullCalibrateSensorPage/Pages/SensorConstantSetPage.qml",
                    badge      : 0,
                    badgeText  : qsTr("Done"),
                    pid        : "senconst",
                },
                //                {
                //                    mtype      : "menu",
                //                    mtitle     : qsTr("ADC Zero (IF0)"),
                //                    micon      : "qrc:/UI/Pictures/menu/Zero-Sensor.png",
                //                    mlink      : "qrc:/UI/Pages/FullCalibrateSensorPage/Pages/ADCZeroSetPage.qml",
                //                    badge      : 0,
                //                    badgeText  : qsTr("Done"),
                //                    pid        : "adcz",
                //                },
                //                {
                //                    mtype      : "menu",
                //                    mtitle     : qsTr("ADC Minimum (IF1)"),
                //                    micon      : "qrc:/UI/Pictures/menu/Calibrate-Sensor.png",
                //                    mlink      : "qrc:/UI/Pages/FullCalibrateSensorPage/Pages/ADCMinimumSetPage.qml",
                //                    badge      : 0,
                //                    badgeText  : qsTr("Done"),
                //                    pid        : "adcm",
                //                },
                //                {
                //                    mtype      : "menu",
                //                    mtitle     : qsTr("ADC Nominal (IF2)"),
                //                    micon      : "qrc:/UI/Pictures/menu/Calibrate-Sensor.png",
                //                    mlink      : "qrc:/UI/Pages/FullCalibrateSensorPage/Pages/ADCNominalSetPage.qml",
                //                    badge      : 0,
                //                    badgeText  : qsTr("Done"),
                //                    pid        : "adcn",
                //                }
            ]//

            property var calibrateReqValues: {
                "measure": {
                    "ifa": {
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
                        },
                        "stb": {
                            "volume": 0,
                            "velocity": 0,
                            "velocityTol": 0,
                            "velocityTolLow": 0,
                            "velocityTolHigh": 0,
                            "openingArea": 0,
                            "gridCount": 0,
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

            property int operationModeBackup: 0

            property bool calibNewInflowNom:    false
            property bool calibNewInflowMin:    false
            property bool calibNewInflowStb:    false
            property bool calibNewDownflowNom:  false
            property bool calibNewSensorConst:  false
            property bool calibNewAdcZero:      false
            property bool calibNewAdcMin:       false
            property bool calibNewAdcNom:       false

            property var meaIfaNominalGrid:     []
            property int meaIfaNominalVolume:   0
            property int meaIfaNominalVelocity: 0
            property int meaIfaNominalVolTotal: 0
            property int meaIfaNominalVolAvg:   0

            property var meaIfaMinimumGrid:     []
            property int meaIfaMinimumVolume:   0
            property int meaIfaMinimumVelocity: 0
            property int meaIfaMinimumVolTotal: 0
            property int meaIfaMinimumVolAvg:   0

            property var meaIfaStandbyGrid:     []
            property int meaIfaStandbyVolume:   0
            property int meaIfaStandbyVelocity: 0
            property int meaIfaStandbyVolTotal: 0
            property int meaIfaStandbyVolAvg:   0

            property var meaDfaNominalGrid:                 []
            property int meaDfaNominalVelocityTotal:          0
            property int meaDfaNominalVelocity:             0
            property int meaDfaNominalVelocityLowest:       0
            property int meaDfaNominalVelocityHighest:      0
            property int meaDfaNominalVelocityDeviation:    0
            property int meaDfaNominalVelocityDeviationp:   0

            property int sensorConstant: 0

            property int sensorAdcZero: 0
            property int sensorAdcMinimum: 0
            property int sensorAdcNominal: 0

            property int sensorVelStandby: 0 /*+ 40*/
            property int sensorVelMinimum: 0 /*+ 40*/
            property int sensorVelNominal: 0 /*+ 53*/

            property int sensorVelLowAlarm: 0

            property int sensorVelNominalDfa: 0 /*+ 33*/

            property int fanDutyCycleNominal: 0 /*+ 15*/
            property int fanDutyCycleMinimum: 0 /*+ 10*/
            property int fanDutyCycleStandby: 0 /*+ 5*/

            property int temperatureCalib: 0
            property int temperatureAdcCalib: 0

            property int fanRpmNominal: 0
            property int fanRpmMinimum: 0
            property int fanRpmStandby: 0

            property int measurementUnit: 0

            function openDirectAdcCalibration(uri, pid){
                let intent = IntentApp.create(uri,
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
                                              })
                startView(intent)
            }

            function calibrationDataDone(){
                const intent = IntentApp.create("qrc:/UI/Pages/FullCalibrateSensorPage/Pages/_FinishCalibratePage.qml", {})
                finishView(intent);
            }
        }//

        /// called Once but after onResume
        Component.onCompleted: {
            menuStackView.push(menuGridViewComponent, {"model": props.menuModelCabinet})

            props.measurementUnit = MachineData.measurementUnit

            MachineAPI.setOperationMaintenanceMode();
            //            props.operationModeBackup = MachineData.operationMode
            //            MachineAPI.setOperationMode(MachineAPI.MODE_OPERATION_MAINTENANCE)
            //            let executed = false
            //            viewApp.showBusyPage(qsTr("Please wait..."),
            //                                 function onCallback(cycle){
            //                                    ////console.debug(cycle)
            ///force to close
            //                                     if(cycle >= MachineAPI.BUSY_CYCLE_10) {
            //                                         viewApp.dialogObject.close()
            //                                     }

            props.sensorConstant       = MachineData.getInflowSensorConstant();
            props.sensorAdcZero        = MachineData.getInflowAdcPointFactory(0);
            props.sensorAdcMinimum     = MachineData.getInflowAdcPointFactory(1);
            props.sensorVelMinimum     = MachineData.getInflowVelocityPointFactory(1);
            props.sensorVelNominal     = MachineData.getInflowVelocityPointFactory(2);
            props.sensorVelNominalDfa  = MachineData.getDownflowVelocityPointFactory(2);

            props.sensorVelLowAlarm    = MachineData.getInflowLowLimitVelocity();
            //console.debug("sensor vel alarm: " + props.sensorVelLowAlarm)

            props.initCalibrateSpecs(MachineData.machineProfile)

            //
            //console.debug("calib satate: " + MachineData.getAirflowFactoryCalibrationState(0) + " " + MachineData.getAirflowFactoryCalibrationState(1) + " " + MachineData.getAirflowFactoryCalibrationState(2) + " " + MachineData.getAirflowFactoryCalibrationState(3))
            props.menuModelCabinet[0]['badge'] = MachineData.getAirflowFactoryCalibrationState(MachineAPI.CalFactoryState_InflowDimNominal) === true ? 1 : 0 // IF Nominal
            props.menuModelCabinet[1]['badge'] = MachineData.getAirflowFactoryCalibrationState(MachineAPI.CalFactoryState_InflowDimMinimum) === true ? 1 : 0 // IF Fail
            props.menuModelCabinet[2]['badge'] = MachineData.getAirflowFactoryCalibrationState(MachineAPI.CalFactoryState_InflowDimStandby) === true ? 1 : 0 // IF Standby
            props.menuModelCabinet[3]['badge'] = MachineData.getAirflowFactoryCalibrationState(MachineAPI.CalFactoryState_DownflowNominal) === true ? 1 : 0 // DF Nominal
            /// update to current menu
            menuStackView.currentItem.model = props.menuModelCabinet

            props.menuModelMicroADC[0]['badge'] = MachineData.getAirflowFactoryCalibrationState(MachineAPI.CalFactoryState_SensorConstant) === true ? 1 : 0 //Sensor constant
            //                                         props.menuModelMicroADC[0]['badge'] = MachineData.getAdcFactoryCalibrationState(0) === true ? 1 : 0 //Sensor constant
            //                                         props.menuModelMicroADC[1]['badge'] = MachineData.getAdcFactoryCalibrationState(2) === true ? 1 : 0 //Adc Minimum
            //                                         props.menuModelMicroADC[2]['badge'] = MachineData.getAdcFactoryCalibrationState(3) === true ? 1 : 0 //Adc Nominal
            //props.calibNewAdcZero = props.menuModelMicroADC[1]['badge']
            //                                         props.calibNewAdcMin = props.menuModelMicroADC[1]['badge']
            //props.calibNewAdcNom = props.menuModelMicroADC[2]['badge']

            //                                         executed = true
            //                                     if(cycle >= MachineAPI.BUSY_CYCLE_1/* && !executed*/) {
            //                                         viewApp.dialogObject.close()
            //                                     }

            //                                 })

            if(!MachineData.lightState){
                MachineAPI.setLightState(MachineAPI.DIG_STATE_ONE)
            }//
        }//

        /// Execute This Every This Screen Active/Visible
        executeOnPageVisible: Item {

            /// onResume
            Component.onCompleted: {
                //                    ////console.debug("StackView.Active-" + viewApp.uri);
            }//
            /// onPause
            Component.onDestruction: {
                //                    ////console.debug("StackView.DeActivating");
            }//

            Connections{
                target: viewApp

                function onFinishViewReturned(intent){
                    //                        ////console.debug("onFinishViewReturned-" + viewApp.uri)
                    let extradata = IntentApp.getExtraData(intent)

                    if (extradata['pid'] === 'meaifanom'){
                        //                            ////console.debug(JSON.stringify(extradata['result']['grid']))
                        props.meaIfaNominalGrid             = extradata['calibrateRes']['grid']
                        props.meaIfaNominalVolume           = extradata['calibrateRes']['volume']
                        props.meaIfaNominalVolTotal         = extradata['calibrateRes']['volTotal']
                        props.meaIfaNominalVolAvg           = extradata['calibrateRes']['volAvg']

                        //                            props.meaIfaNominalVolumeLowest     = extradata['calibrateRes']['volLow']
                        //                            props.meaIfaNominalVolumeHighest    = extradata['calibrateRes']['volHigh']
                        let velocity = extradata['calibrateRes']['velocity']
                        //                            ////console.debug(velocity)
                        props.meaIfaNominalVelocity = Math.round(velocity * 100)
                        //                            props.calibrateResValues['measure']['ifa']['nominal']['grid'] = extradata['calibrateRes']['grid']
                        //                            ////console.debug(JSON.stringify(extradata['calibrateRes']['grid']))

                        if(extradata['calibrateRes']['fanDucy'] !== props.fanDutyCycleNominal){
                            props.menuModelCabinet[1]['badge'] = 0 //IF Min
                            props.menuModelCabinet[2]['badge'] = 0 //IF Stb
                            props.menuModelCabinet[3]['badge'] = 0 //DF Nom
                            menuStackView.currentItem.model = props.menuModelCabinet
                            MachineAPI.setAirflowFactoryCalibrationState(MachineAPI.CalFactoryState_InflowDimMinimum, false)
                            MachineAPI.setAirflowFactoryCalibrationState(MachineAPI.CalFactoryState_InflowDimStandby, false)
                            MachineAPI.setAirflowFactoryCalibrationState(MachineAPI.CalFactoryState_DownflowNominal, false)

                            //Remove IF Nom Data
                            props.meaIfaMinimumGrid             = []
                            props.meaIfaMinimumVolume           = 0
                            props.meaIfaMinimumVolTotal         = 0
                            props.meaIfaMinimumVolAvg           = 0
                            props.meaIfaMinimumVelocity         = 0

                            //Remove IF Nom Data
                            props.meaIfaStandbyGrid             = []
                            props.meaIfaStandbyVolume           = 0
                            props.meaIfaStandbyVolTotal         = 0
                            props.meaIfaStandbyVolAvg           = 0
                            props.meaIfaStandbyVelocity         = 0

                            //Remove DF Nom Data
                            props.meaDfaNominalGrid                 = []
                            props.meaDfaNominalVelocityTotal        = 0
                            props.meaDfaNominalVelocity             = 0
                            props.meaDfaNominalVelocityLowest       = 0
                            props.meaDfaNominalVelocityHighest      = 0
                            props.meaDfaNominalVelocityDeviation    = 0
                            props.meaDfaNominalVelocityDeviationp   = 0
                        }//

                        props.fanDutyCycleNominal   = extradata['calibrateRes']['fanDucy']
                        props.fanRpmNominal         = extradata['calibrateRes']['fanRpm']

                        /// Duty Cycle minimum is refer on nominal - 10%
                        props.fanDutyCycleMinimum = props.fanDutyCycleNominal - 10

                        //                            if (props.measurementUnit) {
                        //                                velocity = Math.round(velocity) * 100
                        //                            }
                        //                            else {
                        //                                velocity = utilsApp.toFixedFloat();
                        //                            }

                        if(props.measurementUnit) velocity = Math.round(velocity)
                        props.sensorVelNominal      = Math.round(velocity * 100)

                        //Direct Update To Backend
                        MachineAPI.setInflowVelocityPointFactory(2, props.sensorVelNominal)

                        MachineAPI.saveInflowMeaDimNominalGrid(props.meaIfaNominalGrid,
                                                               props.meaIfaNominalVolTotal,
                                                               props.meaIfaNominalVolAvg,
                                                               props.meaIfaNominalVolume,
                                                               props.meaIfaNominalVelocity,
                                                               props.fanDutyCycleNominal,
                                                               props.fanRpmNominal)

                        MachineAPI.setFanPrimaryNominalDutyCycleFactory(props.fanDutyCycleNominal)
                        MachineAPI.setFanPrimaryNominalRpmFactory(props.fanRpmNominal)

                        MachineAPI.initFanConfigurationStatus(MachineAPI.AF_CALIB_FACTORY)

                        //                            ////console.debug(props.fanDutyCycleNominal)

                        //                            ////console.debug('bagde')

                        //Reset Secondary Flag
                        //                        MachineAPI.setAirflowFactorySecondaryCalibrationState(0, false)
                        //                        MachineAPI.setAirflowFactorySecondaryCalibrationState(1, false)
                        //                        MachineAPI.setAirflowFactorySecondaryCalibrationState(2, false)
                        //                        MachineAPI.setAirflowFactorySecondaryCalibrationState(3, false)

                        let done  = props.menuModelCabinet[props.lastSelectedMenuIndex]['badge']
                        if (!done){
                            /// set bagde value to main model
                            props.menuModelCabinet[props.lastSelectedMenuIndex]['badge'] = 1
                            /// update to current menu
                            menuStackView.currentItem.model = props.menuModelCabinet
                            //Save to backend
                            MachineAPI.setAirflowFactoryCalibrationState(MachineAPI.CalFactoryState_InflowDimNominal, true)
                        }//

                        props.calibNewInflowNom = true

                        const meaUnit = props.measurementUnit ? "fpm" : "m/s"
                        const briefData = "%1%2, %3% | %4RPM".arg(velocity).arg(meaUnit).arg(props.fanDutyCycleNominal).arg(props.fanRpmNominal)
                        MachineAPI.insertEventLog(qsTr("User: Nominal Inflow Measurement (%1)").arg(briefData))
                    }//

                    else if (extradata['pid'] === 'meaifamin'){
                        //                            ////console.debug('bagde')
                        props.meaIfaMinimumGrid             = extradata['calibrateRes']['grid']
                        props.meaIfaMinimumVolume           = extradata['calibrateRes']['volume']
                        props.meaIfaMinimumVolTotal         = extradata['calibrateRes']['volTotal']
                        props.meaIfaMinimumVolAvg           = extradata['calibrateRes']['volAvg']
                        //                            props.meaIfaMinimumVolumeLowest     = extradata['calibrateRes']['volLow']
                        //                            props.meaIfaMinimumVolumeHighest    = extradata['calibrateRes']['volHigh']
                        let velocity = extradata['calibrateRes']['velocity']
                        //                            ////console.debug(velocity)
                        props.meaIfaMinimumVelocity = Math.round(velocity * 100)
                        //                            props.calibrateResValues['measure']['ifa']['fail']['grid'] = extradata['calibrateRes']['grid']

                        props.fanDutyCycleMinimum   = extradata['calibrateRes']['fanDucy']
                        props.fanRpmMinimum         = extradata['calibrateRes']['fanRpm']

                        if(props.measurementUnit) velocity = Math.round(velocity)
                        props.sensorVelMinimum      = Math.round(velocity * 100)
                        MachineAPI.setInflowVelocityPointFactory(1, props.sensorVelMinimum)

                        props.sensorVelLowAlarm = props.sensorVelMinimum
                        MachineAPI.setInflowLowLimitVelocity(props.sensorVelLowAlarm)

                        //Direct Update To Backend
                        MachineAPI.saveInflowMeaDimMinimumGrid(props.meaIfaMinimumGrid,
                                                               props.meaIfaMinimumVolTotal,
                                                               props.meaIfaMinimumVolAvg,
                                                               props.meaIfaMinimumVolume,
                                                               props.meaIfaMinimumVelocity,
                                                               props.fanDutyCycleMinimum,
                                                               props.fanRpmMinimum)

                        MachineAPI.setFanPrimaryMinimumDutyCycleFactory(props.fanDutyCycleMinimum)
                        MachineAPI.setFanPrimaryMinimumRpmFactory(props.fanRpmMinimum)

                        let done = props.menuModelCabinet[props.lastSelectedMenuIndex]['badge']
                        if (!done){
                            /// set bagde value to main model
                            props.menuModelCabinet[props.lastSelectedMenuIndex]['badge'] = 1
                            /// update to current menu
                            menuStackView.currentItem.model = props.menuModelCabinet
                            //Save to backend
                            MachineAPI.setAirflowFactoryCalibrationState(MachineAPI.CalFactoryState_InflowDimMinimum, true)
                        }//

                        props.calibNewInflowMin = true

                        const meaUnit = props.measurementUnit ? "fpm" : "m/s"
                        const briefData = "%1%2, %3% | %4RPM".arg(velocity).arg(meaUnit).arg(props.fanDutyCycleMinimum).arg(props.fanRpmMinimum)
                        MachineAPI.insertEventLog(qsTr("User: Minimum Inflow Measurement (%1)").arg(briefData))
                    }//

                    else if (extradata['pid'] === 'meaifastb'){
                        //                            ////console.debug('bagde')

                        props.meaIfaStandbyGrid             = extradata['calibrateRes']['grid']
                        props.meaIfaStandbyVolume           = extradata['calibrateRes']['volume']
                        props.meaIfaStandbyVolTotal         = extradata['calibrateRes']['volTotal']
                        props.meaIfaStandbyVolAvg           = extradata['calibrateRes']['volAvg']
                        //                            props.meaIfaStandbyVolumeLowest     = extradata['calibrateRes']['volLow']
                        //                            props.meaIfaStandbyVolumeHighest    = extradata['calibrateRes']['volHigh']
                        let velocity = extradata['calibrateRes']['velocity']
                        //                            ////console.debug(velocity)
                        props.meaIfaStandbyVelocity = Math.round(velocity * 100)

                        //                            props.calibrateResValues['measure']['ifa']['stb']['grid'] = extradata['calibrateRes']['grid']

                        props.fanDutyCycleStandby  = extradata['calibrateRes']['fanDucy']
                        props.fanRpmStandby        = extradata['calibrateRes']['fanRpm']

                        if(props.measurementUnit) velocity = Math.round(velocity)
                        props.sensorVelStandby      = Math.round(velocity * 100)

                        //Direct Update to backend
                        MachineAPI.saveInflowMeaDimStandbyGrid(props.meaIfaStandbyGrid,
                                                               props.meaIfaStandbyVolTotal,
                                                               props.meaIfaStandbyVolAvg,
                                                               props.meaIfaStandbyVolume,
                                                               props.meaIfaStandbyVelocity,
                                                               props.fanDutyCycleStandby,
                                                               props.fanRpmStandby)

                        MachineAPI.setFanPrimaryStandbyDutyCycleFactory(props.fanDutyCycleStandby)
                        MachineAPI.setFanPrimaryStandbyRpmFactory(props.fanRpmStandby)

                        let done  = props.menuModelCabinet[props.lastSelectedMenuIndex]['badge']
                        if (!done){
                            /// set bagde value to main model
                            props.menuModelCabinet[props.lastSelectedMenuIndex]['badge'] = 1
                            /// update to current menu
                            menuStackView.currentItem.model = props.menuModelCabinet
                            //Save to backend
                            MachineAPI.setAirflowFactoryCalibrationState(MachineAPI.CalFactoryState_InflowDimStandby, true)
                        }//

                        props.calibNewInflowStb = true

                        const meaUnit = props.measurementUnit ? "fpm" : "m/s"
                        const briefData = "%1%2, %3% | %4RPM".arg(velocity).arg(meaUnit).arg(props.fanDutyCycleStandby).arg(props.fanRpmStandby)
                        MachineAPI.insertEventLog(qsTr("User: Standby Inflow Measurement (%1)").arg(briefData))
                    }//

                    else if (extradata['pid'] === 'meadfanom'){

                        props.meaDfaNominalGrid                 = extradata['calibrateRes']['grid']
                        props.meaDfaNominalVelocityTotal        = Math.round(extradata['calibrateRes']['velSum'] * 100)
                        props.meaDfaNominalVelocity             = Math.round(extradata['calibrateRes']['velocity'] * 100)
                        props.meaDfaNominalVelocityLowest       = Math.round(extradata['calibrateRes']['velLow'] * 100)
                        props.meaDfaNominalVelocityHighest      = Math.round(extradata['calibrateRes']['velHigh'] * 100)
                        props.meaDfaNominalVelocityDeviation    = Math.round(extradata['calibrateRes']['velDev'] * 100)
                        props.meaDfaNominalVelocityDeviationp   = Math.round(extradata['calibrateRes']['velDevp'] * 100)

                        //                            console.log(props.meaDfaNominalVelocity)
                        //                            console.log(extradata['calibrateRes']['velLow'])
                        //                            console.log(props.meaDfaNominalVelocityLowest)
                        //                            console.log(props.meaDfaNominalVelocityHighest)
                        //                            console.log(props.meaDfaNominalVelocityDeviation)
                        //                            console.log(props.meaDfaNominalVelocityDeviationp)

                        //                            ////console.debug(extradata['calibrateRes']['velDev'])
                        //                            ////console.debug(extradata['calibrateRes']['velDevp'])

                        //                            ////console.debug(props.meaDfaNominalVelocityDeviation)
                        //                            ////console.debug(props.meaDfaNominalVelocityDeviationp)

                        //                            props.calibrateResValues['measure']['dfa']['nominal']['grid'] = extradata['calibrateRes']['grid']
                        //                            ////console.debug(JSON.stringify(props.calibrateResValues['measure']['dfa']['nominal']['grid']))
                        //console.debug("duty cycle result: " + extradata['calibrateRes']['fanDucy'] + " duty cycle saved already: " + props.fanDutyCycleNominal)
                        if(extradata['calibrateRes']['fanDucy'] !== props.fanDutyCycleNominal){
                            props.menuModelCabinet[0]['badge'] = 0
                            props.menuModelCabinet[1]['badge'] = 0
                            props.menuModelCabinet[2]['badge'] = 0
                            menuStackView.currentItem.model = props.menuModelCabinet
                            MachineAPI.setAirflowFactoryCalibrationState(MachineAPI.CalFactoryState_InflowDimNominal, false)
                            MachineAPI.setAirflowFactoryCalibrationState(MachineAPI.CalFactoryState_InflowDimMinimum, false)
                            MachineAPI.setAirflowFactoryCalibrationState(MachineAPI.CalFactoryState_InflowDimStandby, false)

                            //Remove IF Nom Data
                            props.meaIfaNominalGrid             = []
                            props.meaIfaNominalVolume           = 0
                            props.meaIfaNominalVolTotal         = 0
                            props.meaIfaNominalVolAvg           = 0
                            props.meaIfaNominalVelocity         = 0

                            //Remove IF Nom Data
                            props.meaIfaMinimumGrid             = []
                            props.meaIfaMinimumVolume           = 0
                            props.meaIfaMinimumVolTotal         = 0
                            props.meaIfaMinimumVolAvg           = 0
                            props.meaIfaMinimumVelocity         = 0

                            //Remove IF Nom Data
                            props.meaIfaStandbyGrid             = []
                            props.meaIfaStandbyVolume           = 0
                            props.meaIfaStandbyVolTotal         = 0
                            props.meaIfaStandbyVolAvg           = 0
                            props.meaIfaStandbyVelocity         = 0
                        }//

                        props.fanDutyCycleNominal  = extradata['calibrateRes']['fanDucy']
                        props.fanRpmNominal        = extradata['calibrateRes']['fanRpm']

                        let velocity = extradata['calibrateRes']['velocity']
                        if(props.measurementUnit) velocity = Math.round(velocity)
                        props.sensorVelNominalDfa  = Math.round(velocity * 100)
                        MachineAPI.setDownflowVelocityPointFactory(2, props.sensorVelNominalDfa)

                        //Direct Update To Backend
                        MachineAPI.saveDownflowMeaNominalGrid(props.meaDfaNominalGrid,
                                                              props.meaDfaNominalVelocityTotal,
                                                              props.meaDfaNominalVelocity,
                                                              props.meaDfaNominalVelocityLowest,
                                                              props.meaDfaNominalVelocityHighest,
                                                              props.meaDfaNominalVelocityDeviation,
                                                              props.meaDfaNominalVelocityDeviationp)

                        MachineAPI.setFanPrimaryNominalDutyCycleFactory(props.fanDutyCycleNominal)
                        MachineAPI.setFanPrimaryNominalRpmFactory(props.fanRpmNominal)

                        MachineAPI.initFanConfigurationStatus(MachineAPI.AF_CALIB_FACTORY)

                        //Reset Secondary Flag
                        //                        MachineAPI.setAirflowFactorySecondaryCalibrationState(0, false)
                        //                        MachineAPI.setAirflowFactorySecondaryCalibrationState(1, false)
                        //                        MachineAPI.setAirflowFactorySecondaryCalibrationState(2, false)
                        //                        MachineAPI.setAirflowFactorySecondaryCalibrationState(3, false)

                        let done  = props.menuModelCabinet[props.lastSelectedMenuIndex]['badge']
                        if (!done){
                            /// set bagde value to main model
                            props.menuModelCabinet[props.lastSelectedMenuIndex]['badge'] = 1
                            /// update to current menu
                            menuStackView.currentItem.model = props.menuModelCabinet
                            //Save to backend
                            MachineAPI.setAirflowFactoryCalibrationState(MachineAPI.CalFactoryState_DownflowNominal, true)
                        }//

                        props.calibNewDownflowNom = true

                        const meaUnit = props.measurementUnit ? "fpm" : "m/s"
                        const briefData = "%1%2, %3% | %4RPM".arg(velocity).arg(meaUnit).arg(props.fanDutyCycleNominal).arg(props.fanRpmNominal)
                        MachineAPI.insertEventLog(qsTr("User: Nominal Downflow Measurement (%1)").arg(briefData))
                    }//

                    else if (extradata['pid'] === 'senconst'){
                        const sensorConst = extradata['sensorConstant'] || 0
                        let sensorConstHasChanged = false

                        if(props.sensorConstant !== sensorConst) {
                            props.sensorConstant = sensorConst
                            sensorConstHasChanged = true
                        }

                        /// if Sensor Contant changed, it will effect to ADC Values
                        /// So, required to recalibrate all the ADC point
                        if (sensorConstHasChanged) {
                            props.calibNewAdcZero   = false
                            props.calibNewAdcMin    = false
                            props.calibNewAdcNom    = false
                            ///
                            props.sensorAdcZero     = 0
                            props.sensorAdcMinimum  = 0
                            props.sensorAdcNominal  = 0
                            /// set bagde value to main model
                            //                            props.menuModelMicroADC[props.lastSelectedMenuIndex+1]['badge'] = 0
                            //                            props.menuModelMicroADC[props.lastSelectedMenuIndex+2]['badge'] = 0
                            //props.menuModelMicroADC[props.lastSelectedMenuIndex+3]['badge'] = 0
                            //                            MachineAPI.setAdcFactoryCalibrationState(1, false)
                            //                            MachineAPI.setAdcFactoryCalibrationState(2, false)
                            //                            MachineAPI.setAdcFactoryCalibrationState(3, false)

                        }//

                        //Direct save to backend
                        MachineAPI.setInflowSensorConstant(props.sensorConstant);

                        let done  = props.menuModelMicroADC[props.lastSelectedMenuIndex]['badge']
                        if (!done){
                            /// set bagde value to main model
                            props.menuModelMicroADC[props.lastSelectedMenuIndex]['badge'] = 1
                            /// update to current menu
                            menuStackView.currentItem.model = props.menuModelMicroADC
                            //Save to backend
                            MachineAPI.setAirflowFactoryCalibrationState(MachineAPI.CalFactoryState_SensorConstant, true)
                        }//

                        props.calibNewSensorConst = true
                    }//
                    //                    else if (extradata['pid'] === 'adcz'){
                    //                        props.sensorAdcZero = extradata['sensorAdcZero'] || 0

                    //                        if(props.calibNewAdcMin) {
                    //                            props.calibNewAdcMin = false
                    //                            /// set bagde value to main model
                    //                            props.menuModelMicroADC[props.lastSelectedMenuIndex+1]['badge'] = 0
                    //                        }//

                    //                        if(props.calibNewAdcNom) {
                    //                            props.calibNewAdcNom = false
                    //                            /// set bagde value to main model
                    //                            props.menuModelMicroADC[props.lastSelectedMenuIndex+2]['badge'] = 0
                    //                        }//

                    //                        //Direct save to backend
                    //                        MachineAPI.setInflowAdcPointFactory(0, props.sensorAdcZero)
                    //                        MachineAPI.setInflowVelocityPointFactory(0, 0)
                    //                        MachineAPI.setDownflowVelocityPointFactory(0, 0)

                    //                        let done  = props.menuModelMicroADC[props.lastSelectedMenuIndex]['badge']
                    //                        if (!done){
                    //                            /// set bagde value to main model
                    //                            props.menuModelMicroADC[props.lastSelectedMenuIndex]['badge'] = 1
                    //                            /// update to current menu
                    //                            menuStackView.currentItem.model = props.menuModelMicroADC
                    //                            //Save to backend
                    //                            MachineAPI.setAdcFactoryCalibrationState(1, true)
                    //                        }

                    //                        props.calibNewAdcZero = true
                    //                    }//

                    //                    else if (extradata['pid'] === 'adcm'){

                    //                        props.sensorAdcMinimum = extradata['sensorAdcMinimum'] || 0

                    //                        let velocity = extradata['sensorVelMinimum']
                    //                        if(props.measurementUnit) velocity = Math.round(velocity)
                    //                        props.sensorVelMinimum = Math.round(velocity * 100)

                    //                        let velocityLowAlarm = extradata['sensorVelLowAlarm'] || 0
                    //                        if(props.measurementUnit) velocityLowAlarm = Math.round(velocityLowAlarm)
                    //                        props.sensorVelLowAlarm = Math.round(velocityLowAlarm * 100)
                    //                        //                            //console.debug("velocityLowAlarm: " + velocityLowAlarm)

                    //                        props.fanDutyCycleMinimum = extradata['fanDutyCycleResult']
                    //                        props.fanRpmMinimum       = extradata['fanRpmResult']

                    //                        if(props.calibNewAdcNom) {
                    //                            props.calibNewAdcNom = false
                    //                            /// clear bagde value to main model
                    //                            props.menuModelMicroADC[props.lastSelectedMenuIndex+1]['badge'] = 0
                    //                        }

                    //                        //Direct save to backend
                    //                        MachineAPI.setInflowAdcPointFactory(1, props.sensorAdcMinimum)
                    //                        MachineAPI.setInflowVelocityPointFactory(1, props.sensorVelMinimum)
                    //                        MachineAPI.setDownflowVelocityPointFactory(1, 0)
                    //                        MachineAPI.setInflowLowLimitVelocity(props.sensorVelLowAlarm)

                    //                        MachineAPI.setFanPrimaryMinimumDutyCycleFactory(props.fanDutyCycleMinimum)
                    //                        MachineAPI.setFanPrimaryMinimumRpmFactory(props.fanRpmMinimum)

                    //                        let done  = props.menuModelMicroADC[props.lastSelectedMenuIndex]['badge']
                    //                        if (!done){
                    //                            /// set bagde value to main model
                    //                            props.menuModelMicroADC[props.lastSelectedMenuIndex]['badge'] = 1
                    //                            /// update to current menu
                    //                            menuStackView.currentItem.model = props.menuModelMicroADC
                    //                            //Save to backend
                    //                            MachineAPI.setAdcFactoryCalibrationState(2, true)
                    //                        }

                    //                        props.calibNewAdcMin = true
                    //                    }//

                    //                    else if (extradata['pid'] === 'adcn'){
                    //                        props.sensorAdcNominal = extradata['sensorAdcNominal'] || 0

                    //                        props.fanDutyCycleNominal  = extradata['fanDutyCycleResult']
                    //                        props.fanRpmNominal        = extradata['fanRpmResult']

                    //                        props.sensorAdcNominal      = extradata['sensorAdcNominal'] || 0

                    //                        let velocity = extradata['sensorVelNominal']
                    //                        if(props.measurementUnit) velocity = Math.round(velocity)
                    //                        props.sensorVelNominal = Math.round(velocity * 100)

                    //                        velocity = extradata['sensorVelNominalDfa']
                    //                        if(props.measurementUnit) velocity = Math.round(velocity)
                    //                        props.sensorVelNominalDfa   = Math.round(velocity * 100)

                    //                        props.temperatureCalib      = extradata['temperatureCalib'] || 0
                    //                        props.temperatureAdcCalib   = extradata['temperatureCalibAdc'] || 0

                    //                        //Direct save to backend
                    //                        MachineAPI.setInflowAdcPointFactory(2, props.sensorAdcNominal)
                    //                        MachineAPI.setInflowVelocityPointFactory(2, props.sensorVelNominal)
                    //                        MachineAPI.setDownflowVelocityPointFactory(2, props.sensorVelNominalDfa)
                    //                        MachineAPI.setInflowTemperatureCalib(props.temperatureCalib, props.temperatureAdcCalib)

                    //                        MachineAPI.setFanPrimaryNominalDutyCycleFactory(props.fanDutyCycleNominal)
                    //                        MachineAPI.setFanPrimaryNominalRpmFactory(props.fanRpmNominal)

                    //                        let done  = props.menuModelMicroADC[props.lastSelectedMenuIndex]['badge']
                    //                        if (!done){
                    //                            /// set bagde value to main model
                    //                            props.menuModelMicroADC[props.lastSelectedMenuIndex]['badge'] = 1
                    //                            /// update to current menu
                    //                            menuStackView.currentItem.model = props.menuModelMicroADC
                    //                            //Save to backend
                    //                            MachineAPI.setAdcFactoryCalibrationState(3, true)
                    //                        }

                    //                        props.calibNewAdcNom = true
                    //                        props.calibrationDataDone()
                    //                    }//

                    else if (extradata['pid'] === 'directAdcCalib'){
                        //                        props.temperatureCalib      = extradata['temperatureCalib'] || 0
                        //                        props.temperatureAdcCalib   = extradata['temperatureCalibAdc'] || 0
                        //                        MachineAPI.setInflowTemperatureCalib(props.temperatureCalib, props.temperatureAdcCalib)

                        //                        //                        let errorCode = extradata['failCode'] || 0
                        //                        //                        if(errorCode === 0x0001){
                        //                        //                            MachineAPI.setInflowAdcPointFactory(1, 0)
                        //                        //                            MachineAPI.setInflowAdcPointFactory(2, 0)
                        //                        //                            menuStackView.currentItem.model = props.menuModelMicroADC
                        //                        //                            return
                        //                        //                        }

                        //                        props.sensorAdcMinimum = extradata['sensorAdcMinimum'] || 0

                        //                        props.fanDutyCycleMinimum = extradata['fanDutyCycleMinimum']
                        //                        props.fanRpmMinimum       = extradata['fanRpmMinimum']

                        //                        let velocityMin = extradata['sensorVelMinimum']
                        //                        if(props.measurementUnit) velocityMin = Math.round(velocityMin)
                        //                        props.sensorVelMinimum = Math.round(velocityMin * 100)

                        //                        let velocityLowAlarm = extradata['sensorVelLowAlarm'] || 0
                        //                        if(props.measurementUnit) velocityLowAlarm = Math.round(velocityLowAlarm)
                        //                        props.sensorVelLowAlarm = Math.round(velocityLowAlarm * 100)

                        //                        //Direct save to backend
                        //                        MachineAPI.setInflowAdcPointFactory(1, props.sensorAdcMinimum)
                        //                        MachineAPI.setInflowVelocityPointFactory(1, props.sensorVelMinimum)
                        //                        MachineAPI.setDownflowVelocityPointFactory(1, 0)
                        //                        MachineAPI.setInflowLowLimitVelocity(props.sensorVelLowAlarm)

                        //                        MachineAPI.setFanPrimaryMinimumDutyCycleFactory(props.fanDutyCycleMinimum)
                        //                        MachineAPI.setFanPrimaryMinimumRpmFactory(props.fanRpmMinimum)

                        //                        //ADC Minimum Done Flag
                        //                        //                        let done  = MachineData.getAdcFactoryCalibrationState(2)/*props.menuModelMicroADC[1]['badge']*/
                        //                        //                        if (!done){
                        //                        //                            /// set bagde value to main model
                        //                        //                            //                            props.menuModelMicroADC[1]['badge'] = 1
                        //                        //                            /// update to current menu
                        //                        //                            //                            menuStackView.currentItem.model = props.menuModelMicroADC
                        //                        //                            //Save to backend
                        //                        //                            //                            MachineAPI.setAdcFactoryCalibrationState(2, true)
                        //                        //                        }

                        //                        props.calibNewAdcMin = true;


                        //                        //                        if((errorCode === 0x0002) || (errorCode === 0x0003)){
                        //                        //                            //Dont save nominal value
                        //                        //                            return;
                        //                        //                        }

                        //                        props.sensorAdcNominal = extradata['sensorAdcNominal'] || 0

                        //                        props.fanDutyCycleNominal  = extradata['fanDutyCycleNominal']
                        //                        props.fanRpmNominal        = extradata['fanRpmNominal']

                        //                        let velocityNom = extradata['sensorVelNominal']
                        //                        if(props.measurementUnit) velocityNom = Math.round(velocityNom)
                        //                        props.sensorVelNominal = Math.round(velocityNom * 100)

                        //                        velocityNom = extradata['sensorVelNominalDfa']
                        //                        if(props.measurementUnit) velocityNom = Math.round(velocityNom)
                        //                        props.sensorVelNominalDfa   = Math.round(velocityNom * 100)

                        //                        //Direct save to backend
                        //                        MachineAPI.setInflowAdcPointFactory(2, props.sensorAdcNominal)
                        //                        MachineAPI.setInflowVelocityPointFactory(2, props.sensorVelNominal)
                        //                        MachineAPI.setDownflowVelocityPointFactory(2, props.sensorVelNominalDfa)

                        //                        MachineAPI.setFanPrimaryNominalDutyCycleFactory(props.fanDutyCycleNominal)
                        //                        MachineAPI.setFanPrimaryNominalRpmFactory(props.fanRpmNominal)

                        //                        //                        done  = MachineData.getAirflowFactoryCalibrationState(3)/*props.menuModelMicroADC[2]['badge']*/
                        //                        //                        if (!done){
                        //                        //                            /// set bagde value to main model
                        //                        //                            //                            props.menuModelMicroADC[2]['badge'] = 1
                        //                        //                            /// update to current menu
                        //                        //                            //                            menuStackView.currentItem.model = props.menuModelMicroADC
                        //                        //                            //Save to backend
                        //                        //                            //                            MachineAPI.setAdcFactoryCalibrationState(3, true)
                        //                        //                        }

                        //                        props.calibNewAdcNom = true

                        //                        //Only save when everything ok
                        props.calibrationDataDone()
                    }//
                }//
            }//
        }//
    }//
}//
