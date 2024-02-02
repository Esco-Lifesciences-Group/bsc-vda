import QtQuick 2.12
import QtQuick.Controls 2.0
import QtQuick.Layouts 1.0

import UI.CusCom 1.1
import "../../CusCom/JS/IntentApp.js" as IntentApp

import ModulesCpp.Utils 1.0
import ModulesCpp.Machine 1.0
import ModulesCpp.Connectify 1.0
import ModulesCpp.Settings 1.0

import "Components" as CusComPage

ViewApp {
    id: viewApp
    title: "Home"

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
                    title: qsTr("Home")

                    contentDateTime.active: false

                    contentTitleBox.sourceComponent: Item{
                        id: headerStatusItem

                        Rectangle {
                            id: headerBackgroundRectangle
                            anchors.fill: parent
                            color: "#db6400"
                            radius: 5
                            border.width: 3
                            border.color: "#dddddd"

                            Image {
                                id: headerBgImage
                                anchors.fill: parent
                                source: "qrc:/UI/Pictures/header-red-bg.png"
                                visible: false
                            }

                            TextApp {
                                id: headerStatusText
                                anchors.fill: parent
                                anchors.margins: 5
                                horizontalAlignment: Text.AlignHCenter
                                verticalAlignment: Text.AlignVCenter
                                text: qsTr("FAN OFF")
                                font.capitalization: Font.AllUppercase
                                font.pixelSize: 32
                                font.bold: true
                                fontSizeMode: Text.Fit
                            }//
                        }//

                        states: [
                            State {
                                when: props.alarmBoardComError
                                PropertyChanges {
                                    target: headerBgImage
                                    visible: true
                                }//
                                PropertyChanges {
                                    target: headerStatusText
                                    text: qsTr("ALARM: MODULE NOT RESPONDING ")
                                }//
                            }//
                            ,
                            State {
                                when: props.modeIsMaintenance
                                PropertyChanges {
                                    target: headerBackgroundRectangle
                                    color: "#db6400"
                                }//
                                PropertyChanges {
                                    target: headerStatusText
                                    text: qsTr("MAINTENANCE")
                                }//
                            }//
                            ,
                            State {
                                when: props.sashCycleLockedAlarm
                                PropertyChanges {
                                    target: headerBgImage
                                    visible: true
                                }//
                                PropertyChanges {
                                    target: headerStatusText
                                    text: qsTr("ALARM: LOCKED SASH MOTOR")
                                }//
                            }//
                            ,
                            State {
                                when: props.sashCycleStopCaution
                                PropertyChanges {
                                    target: headerBgImage
                                    visible: true
                                }//
                                PropertyChanges {
                                    target: headerStatusText
                                    text: qsTr("STOP USING MOTORIZED SASH!")
                                }//
                            }//
                            ,
                            State {
                                when: props.sashCycleReplaceCaution
                                PropertyChanges {
                                    target: headerBgImage
                                    visible: true
                                }//
                                PropertyChanges {
                                    target: headerStatusText
                                    text: qsTr("REPLACE SASH MOTOR")
                                }//
                            }//
                            ,
                            State {
                                when: props.alarmSashMotorDownStuck
                                PropertyChanges {
                                    target: headerBgImage
                                    visible: true
                                }//
                                PropertyChanges {
                                    target: headerStatusText
                                    text: qsTr("ALARM: STUCKED SASH")
                                }//
                            }//
                            ,
                            State {
                                when: props.alarmSashError
                                PropertyChanges {
                                    target: headerBgImage
                                    visible: true
                                }//
                                PropertyChanges {
                                    target: headerStatusText
                                    text: qsTr("ALARM: SASH ERROR")
                                }//
                            }//
                            ,
                            State {
                                when: props.alarmSashUnsafe || props.alarmSashFullyOpen
                                PropertyChanges {
                                    target: headerBgImage
                                    visible: true
                                }//
                                PropertyChanges {
                                    target: headerStatusText
                                    text: qsTr("ALARM: SASH UNSAFE")
                                }//
                            }//
                            ,
                            State {
                                when: !props.sensorCalibrated
                                PropertyChanges {
                                    target: headerBgImage
                                    visible: true
                                }//
                                PropertyChanges {
                                    target: headerStatusText
                                    text: qsTr("SENSOR UNCALIBRATED")
                                }//
                            }//
                            ,
                            State {
                                when: props.alarmTempHigh
                                PropertyChanges {
                                    target: headerBgImage
                                    visible: true
                                }//
                                PropertyChanges {
                                    target: headerStatusText
                                    text: qsTr("ENVIRONMENTAL TEMPERATURE TOO HIGH")
                                }//
                            }//
                            ,
                            State {
                                when: props.alarmTempLow
                                PropertyChanges {
                                    target: headerBgImage
                                    visible: true
                                }//
                                PropertyChanges {
                                    target: headerStatusText
                                    text: qsTr("ENVIRONMENTAL TEMPERATURE TOO LOW")
                                }//
                            }//
                            ,
                            State {
                                when: props.alarmStandbyFanOff
                                PropertyChanges {
                                    target: headerBgImage
                                    visible: true
                                }//
                                PropertyChanges {
                                    target: headerStatusText
                                    text: qsTr("ALARM: STANDBY FAN")
                                }//
                            }//
                            ,
                            State {
                                when: (props.alarmInflowLow
                                       && (props.alarmDownflowLow
                                           || props.alarmDownflowHigh))
                                PropertyChanges {
                                    target: headerBgImage
                                    visible: true
                                }//
                                PropertyChanges {
                                    target: headerStatusText
                                    text: qsTr("ALARM: AIRFLOW FAIL")
                                }//
                            }//
                            ,
                            State {
                                when: (props.alarmInflowLow)
                                PropertyChanges {
                                    target: headerBgImage
                                    visible: true
                                }//
                                PropertyChanges {
                                    target: headerStatusText
                                    text: qsTr("ALARM: INFLOW LOW")
                                }//
                            }//
                            ,
                            State {
                                when: (props.alarmDownflowLow)
                                PropertyChanges {
                                    target: headerBgImage
                                    visible: true
                                }//
                                PropertyChanges {
                                    target: headerStatusText
                                    text: qsTr("ALARM: DOWNFLOW LOW")
                                }//
                            }//
                            ,
                            State {
                                when: (props.alarmDownflowHigh)
                                PropertyChanges {
                                    target: headerBgImage
                                    visible: true
                                }//
                                PropertyChanges {
                                    target: headerStatusText
                                    text: qsTr("ALARM: DOWNFLOW HIGH")
                                }//
                            }//
                            ,
                            State {
                                when: props.alarmSeasTooPositive
                                PropertyChanges {
                                    target: headerBgImage
                                    visible: true
                                }//
                                PropertyChanges {
                                    target: headerStatusText
                                    text: qsTr("ALARM: EXHAUST FAIL")
                                }//
                            }//
                            ,
                            State {
                                when: props.alarmSeasFlapTooPositive
                                PropertyChanges {
                                    target: headerBgImage
                                    visible: true
                                }//
                                PropertyChanges {
                                    target: headerStatusText
                                    text: qsTr("ALARM: EXHAUST COLLAR")
                                }//
                            }//
                            ,
                            State {
                                when: props.warmingUpActive
                                PropertyChanges {
                                    target: headerBackgroundRectangle
                                    color: "#db6400"
                                }//
                                PropertyChanges {
                                    target: headerStatusText
                                    text: qsTr("WARMING UP")
                                          + " (" + utils.strfSecsToAdaptiveHHMMSS(props.warmingUpCountdown) + ")"
                                }//
                            }//
                            ,
                            State {
                                when: props.postPurgeActive
                                PropertyChanges {
                                    target: headerBackgroundRectangle
                                    color: "#db6400"
                                }//
                                PropertyChanges {
                                    target: headerStatusText
                                    text: qsTr("POST PURGING")
                                          + " (" + utils.strfSecsToAdaptiveHHMMSS(props.postPurgeCountdown) + ")"
                                }//
                            }//
                            ,
                            State {
                                when: (props.sashWindowState == MachineAPI.SASH_STATE_FULLY_CLOSE_SSV) && !props.uvState
                                PropertyChanges {
                                    target: headerBackgroundRectangle
                                    color: props.uvInstalled ? "#4b1263" : "#0F2952"
                                }//
                                PropertyChanges {
                                    target: headerStatusText
                                    text: props.uvInstalled ? qsTr("UV OFF") : qsTr("FULLY CLOSED")
                                }//
                            }//
                            ,
                            State {
                                when: (props.sashWindowState == MachineAPI.SASH_STATE_FULLY_CLOSE_SSV) && props.uvState
                                PropertyChanges {
                                    target: headerBackgroundRectangle
                                    color: "#8E44AD"
                                }//
                                PropertyChanges {
                                    target: headerStatusText
                                    text: qsTr("UV ON")
                                }//
                            }//
                            ,
                            State {
                                when: props.fanState == MachineAPI.FAN_STATE_STANDBY
                                PropertyChanges {
                                    target: headerBackgroundRectangle
                                    color: "#2980b9"
                                }//
                                PropertyChanges {
                                    target: headerStatusText
                                    text: qsTr("STANDBY")
                                }//
                            }//
                            ,
                            State {
                                when: props.airflowFailAfMonDisabled
                                PropertyChanges {
                                    target: headerBackgroundRectangle
                                    color: "#102952"
                                }//
                                PropertyChanges {
                                    target: headerStatusText
                                    text: qsTr("FAN ON")
                                }//
                            }//
                            ,
                            State {
                                when: props.fanState == MachineAPI.FAN_STATE_ON
                                PropertyChanges {
                                    target: headerBackgroundRectangle
                                    color: "#18AA00"
                                }//
                                PropertyChanges {
                                    target: headerStatusText
                                    text: qsTr("CABINET IS SAFE")
                                }//
                            }//
                        ]//
                    }//
                }//
            }//

            /// BODY
            Item {
                id: bodyItem
                Layout.fillWidth: true
                Layout.fillHeight: true

                ColumnLayout {
                    anchors.fill: parent

                    Item {
                        id: secondTopBarSpace
                        Layout.minimumHeight: 60
                        Layout.fillWidth: true

                        /// give the space for secondTopBar
                    }//

                    Item {
                        Layout.fillHeight: true
                        Layout.fillWidth: true

                        RowLayout {
                            anchors.fill: parent

                            Item {
                                id: bsc3DItem
                                Layout.minimumWidth: 300
                                Layout.fillHeight: true

                                /// give the space
                            }

                            Item {
                                id: centerContentItem
                                Layout.fillWidth: true
                                Layout.fillHeight: true

                                Column{
                                    anchors.verticalCenter: parent.verticalCenter
                                    spacing: 5

                                    Loader {
                                        //id: seasStatusLoader
                                        sourceComponent: CusComPage.StatusHorizontalApp {
                                            //id: seasStatus
                                            height: 40
                                            width: centerContentItem.width + 150
                                            x: -150
                                            contentItem.x : 150
                                            contentItem.width: centerContentItem.width - 5
                                            //color: "#18AA00" /// green // good
                                            //color: "#f39c12" // Moderate
                                            //color: "#d35400" /// orange / unheatly for sensityv
                                            //color: "#c0392b" /// red / unhelty

                                            textLabel: qsTr("Particle (μg/m3)")
                                            //                                            textValue: props.seasPressureStr /*"-20 Pa"*/
                                            textValue: "PM2.5: " + props.particleCounterPM2_5 +
                                                       " | PM1.0: " + props.particleCounterPM1_0 +
                                                       " | PM10: " + props.particleCounterPM10

                                            MouseArea {
                                                anchors.fill: parent
                                                onClicked: {
                                                    const intent = IntentApp.create("qrc:/UI/Pages/ParticleCounterInfoPage/ParticleCounterInfoPage.qml", {})
                                                    startView(intent)
                                                }
                                            }
                                        }//
                                        visible: active
                                        //                                        active: true
                                        active: {
                                            if(props.particleCounterSensorInstalled){
                                                if (props.fanState) {
                                                    if (!props.alarmBoardComError) {
                                                        return true
                                                    }
                                                }
                                            }
                                            return false
                                        }//
                                    }//

                                    Loader {
                                        id: timerStatusLoader
                                        sourceComponent: CusComPage.StatusHorizontalApp {
                                            id: timerStatus
                                            height: 40
                                            width: centerContentItem.width + 150
                                            x: -150
                                            contentItem.x : 150
                                            contentItem.width: centerContentItem.width - 5

                                            textLabel: qsTr("Timer")
                                            //textValue: utils.strfSecsToHumanReadable(props.expTimerCount)
                                            textValue: {
                                                if(props.stopwatchTimerActive){
                                                    return utils.strfSecsToHumanReadable(props.stopwatchTimerCount)
                                                }
                                                else{
                                                    if(props.expTimerActive || props.expTimerIsPaused)
                                                        return utils.strfSecsToHumanReadable(props.expTimerCount)
                                                    else return utils.strfSecsToHumanReadable(0)
                                                }//
                                            }//

                                            states: [
                                                State {
                                                    when: props.expTimerTimeout
                                                    PropertyChanges {
                                                        target: timerStatus
                                                        color: "#c0392b"
                                                        textValue: qsTr("Time is up!")
                                                    }
                                                },
                                                State {
                                                    when: props.expTimerIsPaused || props.stopwatchTimerIsPaused
                                                    PropertyChanges {
                                                        target: timerStatus
                                                        color: "#db6400"
                                                    }
                                                }
                                            ]

                                            MouseArea {
                                                anchors.fill: parent
                                                onClicked: {
                                                    var intent
                                                    if (!UserSessionService.loggedIn) {
                                                        switch (props.securityAccessLevel) {
                                                        case MachineAPI.MODE_SECURITY_ACCESS_LOW:
                                                            if(props.stopwatchTimerActive)
                                                                intent = IntentApp.create("qrc:/UI/Pages/StopwatchTimerPage/StopwatchTimerPage.qml", {})
                                                            else if(props.expTimerActive || props.expTimerIsPaused)
                                                                intent = IntentApp.create("qrc:/UI/Pages/ExperimentTimerPage/ExperimentTimerPage.qml", {})
                                                            else
                                                                intent = IntentApp.create("qrc:/UI/Pages/ExperimentTimerPage/ExperimentTimerShortcutPage.qml", {})
                                                            startView(intent)
                                                            break;
                                                            //case MachineAPI.MODE_SECURITY_ACCESS_MEDIUM:
                                                        case MachineAPI.MODE_SECURITY_ACCESS_HIGH:
                                                            UserSessionService.askedForLogin()
                                                            break;
                                                        }//
                                                    }//
                                                    else{
                                                        if(props.stopwatchTimerActive)
                                                            intent = IntentApp.create("qrc:/UI/Pages/StopwatchTimerPage/StopwatchTimerPage.qml", {})
                                                        else if(props.expTimerActive || props.expTimerIsPaused)
                                                            intent = IntentApp.create("qrc:/UI/Pages/ExperimentTimerPage/ExperimentTimerPage.qml", {})
                                                        else
                                                            intent = IntentApp.create("qrc:/UI/Pages/ExperimentTimerPage/ExperimentTimerShortcutPage.qml", {})
                                                        startView(intent)
                                                    }//
                                                }//
                                            }//
                                        }//
                                        visible: active
                                        active: {
                                            if (!props.alarmBoardComError) {
                                                if(props.expTimerActive || props.expTimerAlwaysShow) {
                                                    return true
                                                }
                                                else if(props.stopwatchTimerActive){
                                                    return true
                                                }
                                                else return false
                                            }
                                            return false
                                        }//
                                    }//

                                    Loader {
                                        id: muteTimeStatusLoader
                                        sourceComponent: CusComPage.StatusHorizontalApp {
                                            id: muteTimeStatus
                                            height: 40
                                            width: centerContentItem.width + 150
                                            x: -150
                                            contentItem.x : 150
                                            contentItem.width: centerContentItem.width
                                            hightlighted: true

                                            textLabel: props.vivariumMuteState ? qsTr("Vivarium mute") : qsTr("Alarm muted")
                                            textValue: utils.strfSecsToHumanReadableShort(props.muteAlarmTimeCountdown) /*+ " (Vivarium)"*/
                                        }//
                                        visible: active
                                        active: {
                                            if (!props.alarmBoardComError) {
                                                if(props.muteAlarmState){
                                                    return true
                                                }
                                            }
                                            return false
                                        }//
                                    }//

                                    Loader {
                                        id: seasStatusLoader
                                        sourceComponent: CusComPage.StatusHorizontalApp {
                                            id: seasStatus
                                            height: 40
                                            width: centerContentItem.width + 150
                                            x: -150
                                            contentItem.x : 150
                                            contentItem.width: centerContentItem.width - 5

                                            textLabel: qsTr("Pressure")
                                            textValue: props.seasPressureStr /*"-20 Pa"*/

                                            states: [
                                                State {
                                                    when: props.alarmSeasTooPositive
                                                    PropertyChanges {
                                                        target: seasStatus
                                                        textValue: props.seasPressureStr + " (" + qsTr("Too high") + ")"
                                                    }
                                                    PropertyChanges {
                                                        target: seasStatus
                                                        hightlighted: true
                                                    }
                                                }
                                            ]
                                        }//
                                        visible: active
                                        active: {
                                            if(props.seasInstalled/*&& props.airflowMonitorEnable*/){
                                                if (!props.alarmBoardComError) {
                                                    if(props.fanState) {
                                                        return true
                                                    }
                                                }
                                            }
                                            return false
                                        }//
                                    }//

                                    Loader {
                                        id: sashStatusLoader
                                        sourceComponent: CusComPage.StatusHorizontalApp {
                                            id: sashStatus
                                            height: 60
                                            width: centerContentItem.width + 150
                                            x: -150
                                            contentItem.x : 150
                                            contentItem.width: centerContentItem.width - 5

                                            textLabel: qsTr("Sash")
                                            textValue: "---"

                                            states: [
                                                State {
                                                    when: (props.sashWindowState === MachineAPI.SASH_STATE_UNSAFE_SSV)
                                                          && props.alarmSashUnsafe
                                                    PropertyChanges {
                                                        target: sashStatus
                                                        textValue: qsTr("Unsafe height")
                                                    }
                                                    PropertyChanges {
                                                        target: sashStatus
                                                        hightlighted: true
                                                    }
                                                },
                                                State {
                                                    when: (props.sashWindowState === MachineAPI.SASH_STATE_FULLY_OPEN_SSV)
                                                          && props.alarmSashFullyOpen
                                                    PropertyChanges {
                                                        target: sashStatus
                                                        textValue: qsTr("Fully opened")
                                                    }
                                                    PropertyChanges {
                                                        target: sashStatus
                                                        hightlighted: true
                                                    }
                                                },
                                                State {
                                                    when: (props.sashWindowState === MachineAPI.SASH_STATE_FULLY_OPEN_SSV)
                                                          && props.alarmSashUnknown
                                                    PropertyChanges {
                                                        target: sashStatus
                                                        textValue: qsTr("Unknown")
                                                    }
                                                    PropertyChanges {
                                                        target: sashStatus
                                                        hightlighted: true
                                                    }
                                                },
                                                State {
                                                    when: props.sashWindowState === MachineAPI.SASH_STATE_WORK_SSV
                                                    PropertyChanges {
                                                        target: sashStatus
                                                        textValue: qsTr("Safe height")
                                                    }
                                                },
                                                State {
                                                    when: props.sashWindowState === MachineAPI.SASH_STATE_UNSAFE_SSV
                                                    PropertyChanges {
                                                        target: sashStatus
                                                        textValue: qsTr("Unsafe height")
                                                    }
                                                },
                                                State {
                                                    when: props.sashWindowState === MachineAPI.SASH_STATE_FULLY_CLOSE_SSV
                                                    PropertyChanges {
                                                        target: sashStatus
                                                        textValue: qsTr("Fully closed")
                                                    }
                                                },
                                                State {
                                                    when: props.sashWindowState === MachineAPI.SASH_STATE_STANDBY_SSV
                                                    PropertyChanges {
                                                        target: sashStatus
                                                        textValue: qsTr("Standby height")
                                                    }
                                                },
                                                State {
                                                    when: props.sashWindowState === MachineAPI.SASH_STATE_FULLY_OPEN_SSV
                                                    PropertyChanges {
                                                        target: sashStatus
                                                        textValue: qsTr("Fully opened")
                                                    }
                                                },
                                                State {
                                                    when: props.sashWindowState === MachineAPI.SASH_STATE_ERROR_SENSOR_SSV
                                                    PropertyChanges {
                                                        target: sashStatus
                                                        textValue: qsTr("Unknown")
                                                    }
                                                }
                                            ]//
                                        }//

                                        visible: active
                                        active: {
                                            if (!props.alarmBoardComError) {
                                                return true
                                            }
                                            return false
                                        }//
                                    }//

                                    Loader {
                                        id: filterLifeStatusLoader
                                        sourceComponent: CusComPage.StatusHorizontalApp {
                                            id: filterLifeStatus
                                            height: 40
                                            width: centerContentItem.width + 150
                                            x: -150
                                            contentItem.x : 150
                                            contentItem.width: centerContentItem.width - 5

                                            textLabel: qsTr("Filter Life")
                                            textValue: props.filterLifePercent + "% (%1)".arg(props.filterLifeLevelStrf)
                                            textValueColor: props.filterLifeLevelColor
                                        }//
                                        visible: active
                                        active: {
                                            if (!props.alarmsState) {
                                                if(props.filterLifeDisplayEnabled && (props.fanState === MachineAPI.FAN_STATE_ON)){
                                                    return true
                                                }
                                                else if(!props.filterLifeDisplayEnabled && (props.warmingUpActive)){
                                                    return true
                                                }
                                                else return false
                                            }
                                            return false
                                        }//
                                    }//
                                    //

                                    Loader {
                                        id: airfloMonitorStatusLoader
                                        sourceComponent: CusComPage.StatusHorizontalApp {
                                            id: airfloMonitorStatus
                                            height: 40
                                            width: centerContentItem.width + 150
                                            x: -150
                                            contentItem.x : 150
                                            contentItem.width: centerContentItem.width - 5

                                            textLabel: qsTr("A/F Monitor")
                                            textValue: qsTr("Disabled")
                                        }//
                                        visible: active
                                        active: {
                                            if (!props.airflowMonitorEnable
                                                    || ((props.alarmTempLow
                                                         || props.alarmTempHigh)
                                                        && !props.airflowOutTempEnable)) {
                                                if(props.fanState == MachineAPI.FAN_STATE_ON){
                                                    if (props.sashWindowState == MachineAPI.SASH_STATE_WORK_SSV){
                                                        return true
                                                    }
                                                    if (props.modeIsMaintenance){
                                                        return true
                                                    }
                                                }
                                            }
                                            return false
                                        }//
                                    }//

                                    Loader {
                                        id: downflowStatusLoader
                                        sourceComponent: CusComPage.StatusHorizontalApp {
                                            id: downflowStatus
                                            height: 60
                                            width: centerContentItem.width + 150
                                            x: -150
                                            contentItem.x : 150
                                            contentItem.width: centerContentItem.width - 5

                                            textLabel: qsTr("Downflow")
                                            textValue: props.downflowStr

                                            states: [
                                                State {
                                                    when: !props.sensorCalibrated
                                                    PropertyChanges {
                                                        target: downflowStatus
                                                        textValue: qsTr("Uncalibrated")
                                                    }//
                                                }//
                                                ,
                                                State {
                                                    when: props.warmingUpActive
                                                    PropertyChanges {
                                                        target: downflowStatus
                                                        textValue: qsTr("Warming up")
                                                    }//
                                                    PropertyChanges {
                                                        target: downflowStatus
                                                        color: "#db6400"
                                                    }
                                                }//
                                                ,
                                                State {
                                                    when: (props.advancedAirflowAlarmEnable && (props.alarmDownflowLow))
                                                    PropertyChanges {
                                                        target: downflowStatus
                                                        textValue: props.downflowStr + " (" + qsTr("Too low") + ")"
                                                    }//
                                                    PropertyChanges {
                                                        target: downflowStatus
                                                        hightlighted: true
                                                    }//
                                                }//
                                                ,
                                                State {
                                                    when: (props.advancedAirflowAlarmEnable && (props.alarmDownflowHigh))
                                                    PropertyChanges {
                                                        target: downflowStatus
                                                        textValue: props.downflowStr + " (" + qsTr("Too high") + ")"
                                                    }//
                                                    PropertyChanges {
                                                        target: downflowStatus
                                                        hightlighted: true
                                                    }//
                                                }//
                                                ,
                                                State {
                                                    when: ((props.advancedAirflowAlarmEnable ? (!props.alarmDownflowLow
                                                                                                && !props.alarmDownflowHigh)
                                                                                             : (!props.alarmInflowLow))
                                                           && !props.airflowFailAfMonDisabled)
                                                    PropertyChanges {
                                                        target: downflowStatus
                                                        color: "#4ECC44"
                                                    }//
                                                }//
                                            ]//
                                        }//

                                        visible: active
                                        active: {
                                            if (!props.alarmBoardComError
                                                    //&& props.airflowMonitorEnable
                                                    && ((!props.alarmTempLow
                                                         && !props.alarmTempHigh)
                                                        || props.airflowOutTempEnable)) {
                                                if(props.fanState == MachineAPI.FAN_STATE_ON){
                                                    if (props.sashWindowState == MachineAPI.SASH_STATE_WORK_SSV){
                                                        return true
                                                    }
                                                    if (props.modeIsMaintenance){
                                                        return true
                                                    }
                                                }
                                            }
                                            return false
                                        } //
                                    }//

                                    Loader {
                                        id: inflowStatusLoader
                                        sourceComponent: CusComPage.StatusHorizontalApp {
                                            id: inflowStatus
                                            height: 60
                                            width: centerContentItem.width + 150
                                            x: -150
                                            contentItem.x : 150
                                            contentItem.width: centerContentItem.width - 5

                                            textLabel: qsTr("Inflow")
                                            textValue: props.inflowStr

                                            states: [
                                                State {
                                                    when: !props.sensorCalibrated
                                                    PropertyChanges {
                                                        target: inflowStatus
                                                        textValue: qsTr("Uncalibrated")
                                                    }//
                                                }//
                                                ,
                                                State {
                                                    when: props.warmingUpActive
                                                    PropertyChanges {
                                                        target: inflowStatus
                                                        textValue: qsTr("Warming up")
                                                    }
                                                    PropertyChanges {
                                                        target: inflowStatus
                                                        color: "#db6400"
                                                    }
                                                }
                                                ,
                                                State {
                                                    when: props.alarmInflowLow
                                                    PropertyChanges {
                                                        target: inflowStatus
                                                        textValue: props.inflowStr + " (" + qsTr("Too low") + ")"
                                                    }//
                                                    PropertyChanges {
                                                        target: inflowStatus
                                                        hightlighted: true
                                                    }//
                                                }//
                                                ,
                                                State {
                                                    when: (!props.alarmInflowLow && !props.airflowFailAfMonDisabled)
                                                    PropertyChanges {
                                                        target: inflowStatus
                                                        color: "#279F40"
                                                    }//
                                                }//
                                            ]//
                                        }//
                                        visible: active
                                        active: {
                                            if (!props.alarmBoardComError
                                                    //&& props.airflowMonitorEnable
                                                    && ((!props.alarmTempLow
                                                         && !props.alarmTempHigh)
                                                        || props.airflowOutTempEnable)) {
                                                if(props.fanState == MachineAPI.FAN_STATE_ON){
                                                    if (props.sashWindowState == MachineAPI.SASH_STATE_WORK_SSV){
                                                        return true
                                                    }
                                                    if (props.modeIsMaintenance){
                                                        return true
                                                    }
                                                }
                                            }
                                            return false
                                        }//
                                    }//

                                    Loader {
                                        id: uvLifeStatusLoader
                                        sourceComponent: CusComPage.StatusHorizontalApp {
                                            id: uvLifeStatus
                                            height: 40
                                            width: centerContentItem.width + 150
                                            x: -150
                                            contentItem.x : 150
                                            contentItem.width: centerContentItem.width

                                            textLabel: qsTr("UV Life")
                                            textValue: props.uvLifePercent + "% (%1)".arg(props.uvLifeLeftStrf)
                                            textValueColor: props.uvLifeLevelColor

                                            MouseArea {
                                                anchors.fill: parent
                                                onClicked: {
                                                    if (!UserSessionService.loggedIn) {
                                                        switch (props.securityAccessLevel) {
                                                        case MachineAPI.MODE_SECURITY_ACCESS_LOW:
                                                            showDialogMessage(qsTr("UV Life Left"),
                                                                              qsTr("Current UV Life Left ") + "<br>" +
                                                                              props.uvLifePercent + "%" + " (" + utils.strfMinToHumanReadableShort(props.uvLifeMinutes) + ")" + "<br>" +
                                                                              qsTr("Typical life up to 2,000 hours or 120,000 minutes"), dialogInfo, function(){}, false)
                                                            break;
                                                            //case MachineAPI.MODE_SECURITY_ACCESS_MEDIUM:
                                                        case MachineAPI.MODE_SECURITY_ACCESS_HIGH:
                                                            //UserSessionService.askedForLogin()
                                                            break;
                                                        }//
                                                    }//
                                                    else{
                                                        showDialogMessage(qsTr("UV Life Left"),
                                                                          qsTr("Current UV Life Left ") + "<br>" +
                                                                          props.uvLifePercent + "%" + " (" + utils.strfMinToHumanReadableShort(props.uvLifeMinutes) + ")" + "<br>" +
                                                                          qsTr("Typical life up to 2,000 hours or 120,000 minutes"), dialogInfo, function(){}, false)
                                                    }
                                                }
                                            }
                                        }//
                                        visible: active
                                        active: {
                                            if (!props.alarmBoardComError && props.uvInstalled) {
                                                if(props.sashWindowState == MachineAPI.SASH_STATE_FULLY_CLOSE_SSV){
                                                    return true
                                                }
                                            }
                                            return false
                                        }//
                                    }//

                                    Loader {
                                        id: uvTimeStatusLoader
                                        sourceComponent: CusComPage.StatusHorizontalApp {
                                            id: uvTimeStatus
                                            height: 60
                                            width: centerContentItem.width + 150
                                            x: -150
                                            contentItem.x : 150
                                            contentItem.width: centerContentItem.width - 5

                                            textLabel: qsTr("UV Time")
                                            textValue: (props.uvTime ? utils.strfSecsToHHMMSS(props.uvTimeCountDown) : qsTr("Infinite"))

                                            states: [
                                                State {
                                                    when: props.uvState
                                                    PropertyChanges {
                                                        target: uvTimeStatus
                                                        color: "#8E44AD"
                                                    }//
                                                }//
                                            ]//

                                            MouseArea {
                                                anchors.fill: parent
                                                onClicked: {
                                                    const intent = IntentApp.create("qrc:/UI/Pages/UVTimerSetPage/UVTimerSetPage.qml", {})
                                                    startView(intent)
                                                }//
                                            }//
                                        }//

                                        visible: active
                                        active: {
                                            if (!props.alarmBoardComError && props.uvInstalled) {
                                                if(props.sashWindowState == MachineAPI.SASH_STATE_FULLY_CLOSE_SSV){
                                                    return true
                                                }
                                            }//
                                            return false
                                        }//
                                    }//

                                    Loader {
                                        id: moduleErrorStatusLoader
                                        sourceComponent: CusComPage.StatusHorizontalApp {
                                            id: moduleErrorStatus
                                            height: 150
                                            width: centerContentItem.width + 150
                                            x: -150
                                            contentItem.x : 150
                                            contentItem.width: centerContentItem.width - 5
                                            hightlighted: true

                                            textLabel: ""
                                            textValue: ""

                                            Column {
                                                x: 150
                                                spacing: 10

                                                TextApp {
                                                    anchors.horizontalCenter: parent.horizontalCenter
                                                    text: qsTr("ATTENTION !!!")
                                                    font.pixelSize: 24
                                                }//

                                                TextApp {
                                                    width: moduleErrorStatus.width - 150
                                                    wrapMode: Text.WordWrap
                                                    minimumPixelSize: 20
                                                    font.pixelSize: 24
                                                    text: qsTr("System has detected a communication problem between main-board and module-board.") + "<br><br>" +
                                                          qsTr("Call your authorized field service technician!")
                                                }//
                                            }//
                                        }//

                                        visible: active
                                        active: {
                                            if (props.alarmBoardComError) {
                                                return true
                                            }
                                            return false
                                        }//
                                    }//

                                }//
                            }//

                            /// Motorize Sash Button
                            Loader {
                                Layout.fillHeight: true
                                Layout.minimumWidth: 150
                                sourceComponent: Item{
                                    Column{
                                        anchors.centerIn: parent
                                        spacing: 50

                                        CusComPage.ControlButtonApp {
                                            id: sashMotorUpButton
                                            height: 100
                                            width: 150

                                            sourceImage: "qrc:/UI/Pictures/controll/Button_Up.png"
                                            imageFeature.anchors.margins: 1

                                            background.sourceComponent: Item{}

                                            stateInterlock: props.sashMotorizeUpInterlocked
                                            stateIO: props.sashMotorizeState == MachineAPI.MOTOR_SASH_STATE_UP
                                            pressedAndHoldInterval: 250

                                            Timer{
                                                id: timerForTurnOffMotorUp
                                                running: false
                                                interval: 100
                                                repeat: true
                                                readonly property int maxCount: 15
                                                property int count: 0
                                                onRunningChanged: {
                                                    if(running)
                                                        count = 0
                                                }
                                                onTriggered: {
                                                    //console.debug("Up Button Pressed:", sashMotorUpButton.buttonPressed)
                                                    if(!sashMotorUpButton.buttonPressed && props.sashMotorizeState == MachineAPI.MOTOR_SASH_STATE_UP){
                                                        MachineAPI.setSashWindowMotorizeState(MachineAPI.MOTOR_SASH_STATE_OFF)
                                                        MachineAPI.insertEventLog(qsTr("User: Set sash motorize stop"))
                                                        //console.debug("Up Button release, motor off!")
                                                        running = false
                                                    }//
                                                    if(!sashMotorUpButton.buttonPressed){
                                                        if(++count >= maxCount) running = false
                                                    }//
                                                }//
                                            }//

                                            onPressAndHold: {
                                                //console.debug("!!!!!!!!onPressAndHold")
                                                if (stateInterlock) {
                                                    showDialogMessage(qsTr("Warning"), qsTr("Interlocked!"), dialogAlert)
                                                    return
                                                }//
                                                timerForTurnOffMotorUp.running = false
                                                timerForTurnOffMotorUp.running = true

                                                if(props.sashMotorizeState) {
                                                    MachineAPI.setSashWindowMotorizeState(MachineAPI.MOTOR_SASH_STATE_OFF)
                                                    MachineAPI.insertEventLog(qsTr("User: Set sash motorize stop"))
                                                    return
                                                }
                                                MachineAPI.setSashWindowMotorizeState(MachineAPI.MOTOR_SASH_STATE_UP)
                                                MachineAPI.insertEventLog(qsTr("User: Set sash motorize up"))
                                            }//

                                            states: [
                                                State {
                                                    when: sashMotorUpButton.stateInterlock
                                                    PropertyChanges {
                                                        target: sashMotorUpButton
                                                        sourceImage: "qrc:/UI/Pictures/controll/Button_Up_Gray.png"
                                                    }
                                                }
                                                ,
                                                State {
                                                    when: sashMotorUpButton.stateIO
                                                    PropertyChanges {
                                                        target: sashMotorUpButton
                                                        sourceImage: "qrc:/UI/Pictures/controll/Button_Up_Run.png"
                                                    }
                                                }
                                            ]
                                        }//

                                        CusComPage.ControlButtonApp {
                                            id: sashMotorDownButton
                                            height: 100
                                            width: 150

                                            sourceImage: "qrc:/UI/Pictures/controll/Button_Down.png"
                                            imageFeature.anchors.margins: 1

                                            background.sourceComponent: Item{}

                                            stateInterlock: props.sashMotorizeDownInterlocked
                                            stateIO: props.sashMotorizeState == MachineAPI.MOTOR_SASH_STATE_DOWN
                                            pressedAndHoldInterval: 250

                                            Timer{
                                                id: timerForTurnOffMotorDown
                                                running: false
                                                interval: 100
                                                repeat: true
                                                readonly property int maxCount: 15
                                                property int count: 0
                                                onRunningChanged: {
                                                    if(running)
                                                        count = 0
                                                }
                                                onTriggered: {
                                                    //console.debug("Down Button Pressed:", sashMotorDownButton.buttonPressed)
                                                    if(!sashMotorDownButton.buttonPressed && props.sashMotorizeState == MachineAPI.MOTOR_SASH_STATE_DOWN){
                                                        MachineAPI.setSashWindowMotorizeState(MachineAPI.MOTOR_SASH_STATE_OFF)
                                                        MachineAPI.insertEventLog(qsTr("User: Set sash motorize stop"))
                                                        //console.debug("Down Button release, motor off!")
                                                        running = false
                                                    }//
                                                    if(!sashMotorDownButton.buttonPressed){
                                                        if(++count >= maxCount) running = false
                                                    }//
                                                }//
                                            }//

                                            onPressAndHold: {
                                                //console.debug("onClicked")
                                                if (stateInterlock) {
                                                    showDialogMessage(qsTr("Warning"), qsTr("Interlocked!"), dialogAlert)
                                                    return
                                                }//
                                                timerForTurnOffMotorDown.running = false
                                                timerForTurnOffMotorDown.running = true

                                                if(props.sashMotorizeState) {
                                                    MachineAPI.setSashWindowMotorizeState(MachineAPI.MOTOR_SASH_STATE_OFF)
                                                    MachineAPI.insertEventLog(qsTr("User: Set sash motorize stop"))
                                                    return
                                                }
                                                MachineAPI.setSashWindowMotorizeState(MachineAPI.MOTOR_SASH_STATE_DOWN)
                                                MachineAPI.insertEventLog(qsTr("User: Set sash motorize down"))
                                            }//

                                            states: [
                                                State {
                                                    when: sashMotorDownButton.stateInterlock
                                                    PropertyChanges {
                                                        target: sashMotorDownButton
                                                        sourceImage: "qrc:/UI/Pictures/controll/Button_Down_Gray.png"
                                                    }
                                                }
                                                ,
                                                State {
                                                    when: sashMotorDownButton.stateIO
                                                    PropertyChanges {
                                                        target: sashMotorDownButton
                                                        sourceImage: "qrc:/UI/Pictures/controll/Button_Down_Run.png"
                                                    }
                                                }
                                            ]
                                        }//
                                    }//
                                }//

                                visible: active
                                active: {
                                    if (props.sashMotorizeInstalled) {
                                        return true
                                    }
                                    return false
                                }//
                            }//
                        }//

                        /// methode to make this component upper then other content componet
                        /// including status bar
                        BiosafetyCabinet3D {
                            id: cabinet3D
                            x : bsc3DItem.x
                            y : bsc3DItem.y
                            height: bsc3DItem.height
                            width: bsc3DItem.width
                            modelName: props.machineModelName
                            inflowAlarm: props.alarmInflowLow
                            downflowAlarm: (props.advancedAirflowAlarmEnable ? (props.alarmDownflowLow
                                                                                || props.alarmDownflowHigh)
                                                                             : (props.alarmInflowLow))

                            function updateCabinetBaseItem(){
                                if(props.alarmsState){
                                    return cabinet3D.cabinetBaseItem.stateAlarm
                                }
                                if (props.warmingUpActive) {
                                    return cabinet3D.cabinetBaseItem.stateWarn
                                }
                                return cabinet3D.cabinetBaseItem.stateNone
                            }//

                            function updateHeaderIcon(){
                                if (props.fanState == MachineAPI.FAN_STATE_ON){
                                    if(!props.modeIsMaintenance){
                                        if(!props.warmingUpActive){
                                            if(props.sensorCalibrated) {
                                                if (!props.alarmsState) {
                                                    return true && !props.airflowFailAfMonDisabled
                                                }
                                            }
                                        }
                                    }
                                }
                                return false
                            }//

                            function updateSashItem(){
                                switch (props.sashWindowState){
                                case MachineAPI.SASH_STATE_FULLY_CLOSE_SSV:
                                    if(props.uvState) return cabinet3D.sashImageItem.stateUvActive
                                    return cabinet3D.sashImageItem.stateFullyClose
                                case MachineAPI.SASH_STATE_WORK_SSV:
                                    return cabinet3D.sashImageItem.stateSafe
                                case MachineAPI.SASH_STATE_UNSAFE_SSV:
                                    return cabinet3D.sashImageItem.stateUnsafe
                                case MachineAPI.SASH_STATE_FULLY_OPEN_SSV:
                                    return cabinet3D.sashImageItem.stateFullyOpen
                                case MachineAPI.SASH_STATE_STANDBY_SSV:
                                    return cabinet3D.sashImageItem.stateStandby
                                default:
                                    return cabinet3D.sashImageItem.stateNone
                                }
                            }//

                            airflowArrowActive: arrrowActive && contentView.visible
                            property bool arrrowActive: false
                            function updateAirflowArrow(){
                                switch(props.fanState){
                                case MachineAPI.FAN_STATE_ON:
                                    return true && !props.airflowFailAfMonDisabled;
                                case MachineAPI.FAN_STATE_STANDBY:
                                    return true;
                                default:
                                    return false;
                                }
                            }//

                            Component.onCompleted: {
                                sashImageItem.state = Qt.binding(updateSashItem)
                                arrrowActive = Qt.binding(updateAirflowArrow)
                                headerImageItem.visible = Qt.binding(updateHeaderIcon)
                                cabinetBaseItem.state = Qt.binding(updateCabinetBaseItem)
                            }//

                            MouseArea {
                                anchors.fill: parent
                                onClicked: {
                                    var intent
                                    if (!UserSessionService.loggedIn) {
                                        switch (props.securityAccessLevel) {
                                        case MachineAPI.MODE_SECURITY_ACCESS_LOW:
                                            intent = IntentApp.create("qrc:/UI/Pages/ShortCutMenuPage/ShortCutMenuPage.qml", {})
                                            startView(intent)
                                            break;
                                            //case MachineAPI.MODE_SECURITY_ACCESS_MEDIUM:
                                        case MachineAPI.MODE_SECURITY_ACCESS_HIGH:
                                            UserSessionService.askedForLogin()
                                            break;
                                        }//
                                    }//
                                    else{
                                        intent = IntentApp.create("qrc:/UI/Pages/ShortCutMenuPage/ShortCutMenuPage.qml", {})
                                        startView(intent)
                                    }
                                }//
                                onPressAndHold: {
                                    intent = IntentApp.create("qrc:/UI/Pages/LeavePage/LeavePage.qml", {})
                                    startView(intent)
                                }
                            }//

                            /// Badge Notification
                            Column {
                                spacing: 2

                                Loader {
                                    active: (props.alarmPrevMaintActive
                                             && props.sensorCalibrated)
                                    visible: active
                                    sourceComponent: CusComPage.BadgeNotificationApp{
                                        height: 40
                                        width: cabinet3D.width
                                        text: props.alarmPrevMaintenanceReminderStr
                                        opacity: prevMainBtnMA.pressed ? 0.5 : 1

                                        MouseArea {
                                            id: prevMainBtnMA
                                            anchors.fill: parent
                                            //enabled: props.certfRemExpiredCount < 1
                                            onClicked: {
                                                if (!UserSessionService.loggedIn) {
                                                    let message = qsTr("BSC preventive maintenance reminder!")
                                                    switch(props.alarmPrevMaintActiveCode){
                                                    case MachineAPI.PM_DAILY_CODE:
                                                        message = qsTr("Daily BSC preventive maintenance reminder!")
                                                        break
                                                    case MachineAPI.PM_WEEKLY_CODE:
                                                        message = qsTr("Weekly BSC preventive maintenance reminder!")
                                                        break
                                                    case MachineAPI.PM_MONTHLY_CODE:
                                                        message = qsTr("Monthly BSC preventive maintenance reminder!")
                                                        break
                                                    case MachineAPI.PM_QUARTERLY_CODE:
                                                        message = qsTr("Quarterly BSC preventive maintenance reminder!")
                                                        break
                                                    case MachineAPI.PM_ANNUALLY_CODE:
                                                        message = qsTr("Annual BSC preventive maintenance reminder!")
                                                        break
                                                    case MachineAPI.PM_BIENNIALLY_CODE:
                                                        message = qsTr("Biennial BSC preventive maintenance reminder!")
                                                        break
                                                    case MachineAPI.PM_QUINQUENNIALLY_CODE:
                                                        message = qsTr("Quinquennial BSC preventive maintenance reminder!")
                                                        break
                                                    case MachineAPI.PM_CANOPY_CODE:
                                                        message = qsTr("Monthly Canopy preventive maintenance reminder!")
                                                        break
                                                    default: break
                                                    }

                                                    if(UserSessionService.roleLevel < UserSessionService.roleLevelAdmin){
                                                        showDialogMessage(qsTr("Preventive Maintenance Reminder"),
                                                                          message,
                                                                          dialogInfo,
                                                                          function onClosed(){},
                                                                          true,
                                                                          undefined,
                                                                          5000)
                                                        return;
                                                    }//
                                                }
                                                else {
                                                    intent = IntentApp.create("qrc:/UI/Pages/PreventiveMaintenancePage/PreventiveMaintenancePage.qml", {})
                                                    startView(intent)
                                                }//
                                            }//
                                        }//
                                    }//
                                }//

                                Loader {
                                    active: (props.filterLifeReminder
                                             && props.fanState == MachineAPI.FAN_STATE_ON
                                             && !MachineData.filterLifeReminderSnoozed)
                                    visible: active
                                    sourceComponent: CusComPage.BadgeNotificationApp{
                                        id: badgeFilter
                                        height: 40
                                        width: cabinet3D.width
                                        text: qsTr("Please change the filter!")
                                        opacity: filterReminder.pressed ? 0.5 : 1

                                        function showMessage(){
                                            showDialogAsk(qsTr("Filter Life Reminder"),
                                                          qsTr("Filter life is less than 10%.") + "<br>"
                                                          + qsTr("Please change the filter for better performance!"),
                                                          dialogAlert,
                                                          function onAccepted(){
                                                              if(UserSessionService.loggedIn){
                                                                  MachineAPI.setFilterLifeReminderSnoozed(true)
                                                                  MachineAPI.insertEventLog(qsTr("User: Snooze filter life reminder"))
                                                              }else{
                                                                  UserSessionService.askedForLogin()
                                                              }
                                                          },
                                                          function onRejected(){},
                                                          function onClosed(){},
                                                          true,
                                                          5,
                                                          qsTr("Snooze"),
                                                          qsTr("OK"))
                                        }

                                        MouseArea {
                                            id: filterReminder
                                            anchors.fill: parent
                                            //enabled: props.certfRemExpiredCount < 1
                                            onClicked: {
                                                if (!UserSessionService.loggedIn) {
                                                    switch (props.securityAccessLevel) {
                                                    case MachineAPI.MODE_SECURITY_ACCESS_LOW:
                                                        badgeFilter.showMessage()
                                                        break;
                                                        //case MachineAPI.MODE_SECURITY_ACCESS_MEDIUM:
                                                    case MachineAPI.MODE_SECURITY_ACCESS_HIGH:
                                                        UserSessionService.askedForLogin()
                                                        break;
                                                    }//
                                                }
                                                else {
                                                    badgeFilter.showMessage()
                                                }//
                                            }//
                                        }//
                                    }//
                                }//
                                Loader {
                                    active: (props.uvLifeReminder
                                             && props.uvState == MachineAPI.DIG_STATE_ONE
                                             && !MachineData.uvReplacementReminderSnoozed)
                                    visible: active
                                    sourceComponent: CusComPage.BadgeNotificationApp{
                                        id: badgeUv
                                        height: 40
                                        width: cabinet3D.width
                                        text: qsTr("Please change the UV lamp!")
                                        opacity: uvReminder.pressed ? 0.5 : 1

                                        function showMessage(){
                                            showDialogAsk(qsTr("UV Life Reminder"),
                                                          qsTr("UV life is less than 10%.") + "<br>" + qsTr("Please change the UV Lamp!"),
                                                          dialogAlert,
                                                          function onAccepted(){
                                                              if(UserSessionService.loggedIn){
                                                                  MachineAPI.setUvReplacementReminderSnoozed(true)
                                                                  MachineAPI.insertEventLog(qsTr("User: Snooze UV life reminder"))
                                                              }else{
                                                                  UserSessionService.askedForLogin()
                                                              }
                                                          },
                                                          function onRejected(){},
                                                          function onClosed(){},
                                                          true,
                                                          5,
                                                          qsTr("Snooze"),
                                                          qsTr("OK"))
                                        }

                                        MouseArea {
                                            id: uvReminder
                                            anchors.fill: parent
                                            //enabled: props.certfRemExpiredCount < 1
                                            onClicked: {
                                                if (!UserSessionService.loggedIn) {
                                                    switch (props.securityAccessLevel) {
                                                    case MachineAPI.MODE_SECURITY_ACCESS_LOW:
                                                        badgeUv.showMessage()
                                                        break;
                                                        //case MachineAPI.MODE_SECURITY_ACCESS_MEDIUM:
                                                    case MachineAPI.MODE_SECURITY_ACCESS_HIGH:
                                                        UserSessionService.askedForLogin()
                                                        break;
                                                    }//
                                                }
                                                else {
                                                    badgeUv.showMessage()
                                                }//
                                            }//
                                        }//
                                    }//
                                }//

                                Loader {
                                    active: props.datalogIsFull
                                    visible: active
                                    sourceComponent: CusComPage.BadgeNotificationApp{
                                        id: badgeDatalog
                                        height: 40
                                        width: cabinet3D.width
                                        text: qsTr("Data log is full!")
                                        opacity: datalogReminder.pressed ? 0.5 : 1

                                        function showMessage(){
                                            showDialogMessage(qsTr("Data Log Reminder"),
                                                              qsTr("Data log is full!") + "<br>" + qsTr("New data will still be added, and the oldest data will be deleted."),
                                                              dialogAlert,
                                                              function onClosed(){},
                                                              true,
                                                              undefined,
                                                              5000)
                                        }

                                        MouseArea {
                                            id: datalogReminder
                                            anchors.fill: parent
                                            //enabled: props.certfRemExpiredCount < 1
                                            onClicked: {
                                                if (!UserSessionService.loggedIn) {
                                                    switch (props.securityAccessLevel) {
                                                    case MachineAPI.MODE_SECURITY_ACCESS_LOW:
                                                        badgeDatalog.showMessage()
                                                        break;
                                                        //case MachineAPI.MODE_SECURITY_ACCESS_MEDIUM:
                                                    case MachineAPI.MODE_SECURITY_ACCESS_HIGH:
                                                        UserSessionService.askedForLogin()
                                                        break;
                                                    }//
                                                }
                                                else {
                                                    badgeDatalog.showMessage()
                                                }//
                                            }//
                                        }//
                                    }//
                                }//

                                Loader {
                                    active: props.eventlogIsFull
                                    visible: active
                                    sourceComponent: CusComPage.BadgeNotificationApp{
                                        id: badgeEventlog
                                        height: 40
                                        width: cabinet3D.width
                                        text: qsTr("Event log is full!")
                                        opacity: eventlogReminder.pressed ? 0.5 : 1

                                        function showMessage(){
                                            showDialogMessage(qsTr("Event Log Reminder"),
                                                              qsTr("Event log is full!") + "<br>" + qsTr("New data will still be added, and the oldest data will be deleted."),
                                                              dialogAlert,
                                                              function onClosed(){},
                                                              true,
                                                              undefined,
                                                              5000)
                                        }

                                        MouseArea {
                                            id: eventlogReminder
                                            anchors.fill: parent
                                            //enabled: props.certfRemExpiredCount < 1
                                            onClicked: {
                                                if (!UserSessionService.loggedIn) {
                                                    switch (props.securityAccessLevel) {
                                                    case MachineAPI.MODE_SECURITY_ACCESS_LOW:
                                                        badgeEventlog.showMessage()
                                                        break;
                                                        //case MachineAPI.MODE_SECURITY_ACCESS_MEDIUM:
                                                    case MachineAPI.MODE_SECURITY_ACCESS_HIGH:
                                                        UserSessionService.askedForLogin()
                                                        break;
                                                    }//
                                                }
                                                else {
                                                    badgeEventlog.showMessage()
                                                }//
                                            }//
                                        }//
                                    }//
                                }//

                                Loader {
                                    active: props.alarmlogIsFull
                                    visible: active
                                    sourceComponent: CusComPage.BadgeNotificationApp{
                                        id: badgeAlarmlog
                                        height: 40
                                        width: cabinet3D.width

                                        text: qsTr("Alarm log is full!")
                                        opacity: alarmlogReminder.pressed ? 0.5 : 1

                                        function showMessage(){
                                            showDialogMessage(qsTr("Alarm Log Reminder"),
                                                              qsTr("Alarm log is full!") + "<br>" + qsTr("New data will still be added, and the oldest data will be deleted."),
                                                              dialogAlert,
                                                              function onClosed(){},
                                                              true,
                                                              undefined,
                                                              5000)
                                        }

                                        MouseArea {
                                            id: alarmlogReminder
                                            anchors.fill: parent
                                            //enabled: props.certfRemExpiredCount < 1
                                            onClicked: {
                                                if (!UserSessionService.loggedIn) {
                                                    switch (props.securityAccessLevel) {
                                                    case MachineAPI.MODE_SECURITY_ACCESS_LOW:
                                                        badgeAlarmlog.showMessage()
                                                        break;
                                                        //case MachineAPI.MODE_SECURITY_ACCESS_MEDIUM:
                                                    case MachineAPI.MODE_SECURITY_ACCESS_HIGH:
                                                        UserSessionService.askedForLogin()
                                                        break;
                                                    }//
                                                }
                                                else {
                                                    badgeAlarmlog.showMessage()
                                                }//
                                            }//
                                        }//
                                    }//
                                }//

                                Loader {
                                    active: props.replaceableCompRecordIsFull
                                    visible: active
                                    sourceComponent: CusComPage.BadgeNotificationApp{
                                        id: badgeRp
                                        height: 40
                                        width: cabinet3D.width

                                        text: qsTr("Replaceable comp. record is full!")
                                        opacity: rplogReminder.pressed ? 0.5 : 1

                                        function showMessage(){
                                            showDialogMessage(qsTr("Replaceable Comp. Record Reminder"),
                                                              qsTr("Replaceable comp. record is full!") + "<br>" + qsTr("New data will still be added, and the oldest data will be deleted."),
                                                              dialogAlert,
                                                              function onClosed(){},
                                                              true,
                                                              undefined,
                                                              5000)
                                        }

                                        MouseArea {
                                            id: rplogReminder
                                            anchors.fill: parent
                                            //enabled: props.certfRemExpiredCount < 1
                                            onClicked: {
                                                if (!UserSessionService.loggedIn) {
                                                    switch (props.securityAccessLevel) {
                                                    case MachineAPI.MODE_SECURITY_ACCESS_LOW:
                                                        badgeRp.showMessage()
                                                        break;
                                                        //case MachineAPI.MODE_SECURITY_ACCESS_MEDIUM:
                                                    case MachineAPI.MODE_SECURITY_ACCESS_HIGH:
                                                        UserSessionService.askedForLogin()
                                                        break;
                                                    }//
                                                }
                                                else {
                                                    badgeRp.showMessage()
                                                }//
                                            }//
                                        }//
                                    }//
                                }//

                                Loader {
                                    active: props.resmonlogIsFull
                                    visible: active
                                    sourceComponent: CusComPage.BadgeNotificationApp{
                                        id: badgeResmon
                                        height: 40
                                        width: cabinet3D.width

                                        text: qsTr("System monitor log is full!")
                                        opacity: smonlogReminder.pressed ? 0.5 : 1

                                        function showMessage(){
                                            showDialogMessage(qsTr("System Monitor Log Reminder"),
                                                              qsTr("System monitor log is full!") + "<br>" + qsTr("New data will still be added, and the oldest data will be deleted."),
                                                              dialogAlert,
                                                              function onClosed(){},
                                                              true,
                                                              undefined,
                                                              5000)
                                        }

                                        MouseArea {
                                            id: smonlogReminder
                                            anchors.fill: parent
                                            //enabled: props.certfRemExpiredCount < 1
                                            onClicked: {
                                                if (!UserSessionService.loggedIn) {
                                                    switch (props.securityAccessLevel) {
                                                    case MachineAPI.MODE_SECURITY_ACCESS_LOW:
                                                        badgeResmon.showMessage()
                                                        break;
                                                        //case MachineAPI.MODE_SECURITY_ACCESS_MEDIUM:
                                                    case MachineAPI.MODE_SECURITY_ACCESS_HIGH:
                                                        UserSessionService.askedForLogin()
                                                        break;
                                                    }//
                                                }
                                                else {
                                                    badgeResmon.showMessage()
                                                }//
                                            }//
                                        }//
                                    }//
                                }//
                            }//

                            //Booking Schedule Notification
                            Loader {
                                active: props.bookedScheduleNotifDisplay
                                visible: active
                                anchors.bottom: parent.bottom
                                sourceComponent: Item{
                                    height: 46
                                    width: 300
                                    Rectangle{
                                        id: bookSchedNotifBkgRect
                                        anchors.fill: parent
                                        color: "transparent"
                                        Rectangle{
                                            id: bookSchedNotifBkgChildRect
                                            opacity: bookSchedNotifBkgChildRectMArea.pressed ? 0.7 : 1
                                            anchors.left: parent.left
                                            anchors.bottom: parent.bottom
                                            anchors.leftMargin: 33
                                            height: 42
                                            //width: 268
                                            width: props.bookedScheduleNotifCollapse ? 0 : 268
                                            clip: true
                                            color: "transparent"
                                            Image{
                                                id: bookSchedNotifBkgChildImg
                                                height: 42
                                                width: 268
                                                source: "qrc:/UI/Pictures/book-sched-notif-bkg.png"

                                                RowLayout{
                                                    anchors.fill: parent
                                                    spacing: 5
                                                    Item{
                                                        Layout.minimumWidth: 78
                                                        Layout.fillHeight: true
                                                        ColumnLayout{
                                                            anchors.fill: parent
                                                            anchors.topMargin: 3
                                                            spacing: 0
                                                            TextApp{
                                                                Layout.fillHeight: true
                                                                Layout.fillWidth: true
                                                                font.pixelSize: 24
                                                                minimumPixelSize: 24
                                                                horizontalAlignment: Text.AlignHCenter
                                                                verticalAlignment: Text.AlignVCenter
                                                                text: props.bookedScheduleForToday[0].time
                                                            }
                                                            TextApp{
                                                                Layout.minimumHeight: 14
                                                                Layout.fillWidth: true
                                                                padding: 5
                                                                elide: Text.ElideRight
                                                                font.pixelSize: 10
                                                                minimumPixelSize: 10
                                                                horizontalAlignment: Text.AlignHCenter
                                                                verticalAlignment: Text.AlignVCenter
                                                                text: props.bookedScheduleForToday[0].bookForName
                                                                color: "#60FFEB"
                                                            }
                                                        }
                                                    }
                                                    Item{
                                                        Layout.fillWidth: true
                                                        Layout.fillHeight: true
                                                        ColumnLayout{
                                                            anchors.fill: parent
                                                            spacing: 0
                                                            Rectangle{
                                                                Layout.minimumHeight: 12
                                                                Layout.fillWidth: true
                                                                color: "transparent"
                                                            }
                                                            TextApp{
                                                                Layout.fillHeight: true
                                                                Layout.fillWidth: true
                                                                padding: 5
                                                                elide: Text.ElideMiddle
                                                                minimumPixelSize: 16
                                                                text: props.bookedScheduleForToday[0].bookTitle
                                                                verticalAlignment: Text.AlignVCenter
                                                            }
                                                        }
                                                    }
                                                }
                                            }
                                            Behavior on width {
                                                NumberAnimation { duration: 1000}
                                            }
                                            MouseArea{
                                                id: bookSchedNotifBkgChildRectMArea
                                                anchors.fill: parent
                                                onClicked: {
                                                    props.generateBookedScheduleNotifStringList()
                                                    popupBookedScheduleLoader.active = true
                                                }
                                                onPressAndHold: {
                                                    if(UserSessionService.loggedIn){
                                                        const intent = IntentApp.create("qrc:/UI/Pages/BookingSchedule/BookingSchedule.qml", {})
                                                        startView(intent)
                                                    }
                                                }
                                            }
                                        }//
                                        Image{
                                            opacity: bookSchedNotifIconMArea.pressed ? 0.7 : 1
                                            source: "qrc:/UI/Pictures/book-sched-notif-icon.png"
                                            MouseArea{
                                                id: bookSchedNotifIconMArea
                                                anchors.fill: parent
                                                onClicked: {
                                                    let val = props.bookedScheduleNotifCollapse

                                                    MachineAPI.setBookedScheduleNotifCollapse(!val)
                                                    MachineAPI.insertEventLog(qsTr("User: Set booked schedule notif. collapse") + " %1".arg(!val))
                                                }
                                            }
                                        }//
                                    }//
                                }//
                            }//
                        }//
                    }//
                }//

                /// methode to make this component upper then other (centerContentItem) content componet
                /// but the position still what I want ^_^
                RowLayout {
                    id: secondTopBar
                    x: secondTopBarSpace.x
                    y: secondTopBarSpace.y
                    height: secondTopBarSpace.height
                    width: secondTopBarSpace.width
                    spacing: 5

                    Item {
                        Layout.fillHeight: true
                        Layout.minimumWidth: 300

                        Rectangle {
                            anchors.fill: parent
                            color: "#0F2952"
                            radius: 5
                            border.width: 1
                            border.color: "#dddddd"

                            RowLayout {
                                anchors.fill: parent
                                anchors.margins: 1
                                spacing: 1

                                Item {
                                    Layout.fillHeight: true
                                    Layout.fillWidth: true

                                    TextApp {
                                        id: cabinetDisplayName
                                        anchors.fill: parent
                                        horizontalAlignment: Text.AlignHCenter
                                        verticalAlignment: Text.AlignVCenter
                                        wrapMode: Text.WrapAtWordBoundaryOrAnywhere
                                        text: props.cabinetDisplayName
                                    }//
                                }//

                                Rectangle {
                                    Layout.minimumHeight: parent.height * 0.7
                                    Layout.minimumWidth: 1
                                    color: "gray"
                                }//

                                Item {
                                    Layout.fillHeight: true
                                    Layout.fillWidth: true

                                    // Image {
                                    //     height: parent.height
                                    //     fillMode: Image.PreserveAspectFit
                                    //     source: "qrc:/UI/Pictures/user-icon-dark-35px.png"
                                    // }//

                                    TextApp {
                                        anchors.fill: parent
                                        horizontalAlignment: Text.AlignHCenter
                                        verticalAlignment: Text.AlignVCenter
                                        wrapMode: Text.WrapAtWordBoundaryOrAnywhere
                                        elide: Text.ElideMiddle
                                        text: props.loginFullname
                                    }//

                                    MouseArea {
                                        anchors.fill: parent
                                        onClicked: {
                                            // props.goToLogin()
                                            UserSessionService.askedForLogin()
                                        }//
                                    }//
                                }//
                            }//
                        }//
                    }//

                    Item {
                        Layout.fillHeight: true
                        Layout.fillWidth: true

                        ColumnLayout {
                            anchors.fill: parent
                            spacing: 1

                            /// Long information
                            Loader {
                                id: textTeleprompterLoader
                                Layout.fillHeight: true
                                Layout.fillWidth: true
                                z: tempClockDate.z + 1
                                sourceComponent: Item {
                                    height: textTeleprompterLoader.height
                                    width: textTeleprompterLoader.width

                                    TextTeleprompter {
                                        id: textTeleprompter
                                        height: textHeightArea
                                        width: textTeleprompterLoader.width
                                        //text: qsTr("The sash height is not in the normal working height (Safe height).\nSet it back to normal working height!")
                                        //text: qsTr("The inflow value is too low!\nPotentially reducing the protecttive capabilities of the cabinet.\nEnsure that sensors and ventilation paths are not obstructed.")

                                        states: [
                                            State {
                                                when: props.sashCycleLockedAlarm
                                                PropertyChanges {
                                                    target: textTeleprompter
                                                    text: qsTr("The sash motor cycle has exceeded the maximum operating limit!")
                                                          + "<br>"
                                                          + qsTr("Sash motor has been locked.")
                                                          + "<br>" + qsTr("Please contact your service engineer to do maintenance.")
                                                }
                                            }//
                                            ,
                                            State {
                                                when: props.sashCycleStopCaution
                                                PropertyChanges {
                                                    target: textTeleprompter
                                                    text: qsTr("The use of the sash motor is almost at maximum use!")
                                                          + "<br>" + qsTr("Stop using the sash motor!")
                                                          + "<br>" + qsTr("Please contact your service engineer to do maintenance.")
                                                }
                                            }//
                                            ,
                                            State {
                                                when: props.sashCycleReplaceCaution
                                                PropertyChanges {
                                                    target: textTeleprompter
                                                    text: qsTr("The use of the sash motor is almost at maximum use!")
                                                          + "<br>" + qsTr("Replace the sash motor!")
                                                          + "<br>" + qsTr("Please contact your service engineer to do maintenance.")
                                                }//
                                            }//
                                            ,
                                            State {
                                                when: props.alarmSash >= MachineAPI.ALARM_SASH_ACTIVE_UNSAFE_STATE
                                                PropertyChanges {
                                                    target: textTeleprompter
                                                    text: qsTr("The sash height is at unsafe position. Set back to normal working height!")
                                                }
                                            },
                                            State {
                                                when: props.alarmInflowLow
                                                PropertyChanges {
                                                    target: textTeleprompter
                                                    text: qsTr("The inflow value is too low!")
                                                          + "<br>" + qsTr("Potentially reducing the protective capabilities of the cabinet.")
                                                          + "<br>" + qsTr("Ensure that sensors, airflow grill, and ventilation paths are not obstructed.")
                                                }
                                            },
                                            State {
                                                when: props.alarmDownflowLow
                                                PropertyChanges {
                                                    target: textTeleprompter
                                                    text: qsTr("The Downflow value is too low!")
                                                          + "<br>" + qsTr("Potentially reducing the protective capabilities of the cabinet.")
                                                          + "<br>" + qsTr("Ensure that sensors, airflow grill, and ventilation paths are not obstructed.")
                                                }
                                            },
                                            State {
                                                when: props.alarmDownflowHigh
                                                PropertyChanges {
                                                    target: textTeleprompter
                                                    text: qsTr("The Downflow value is too high!")
                                                          + "<br>" + qsTr("Potentially reducing the protective capabilities of the cabinet.")
                                                          + "<br>" + qsTr("Ensure that sensors, airflow grill, and ventilation paths are not obstructed.")
                                                }
                                            },
                                            State {
                                                when: props.alarmSeasTooPositive
                                                PropertyChanges {
                                                    target: textTeleprompter
                                                    text: qsTr("The pressure is too high!")
                                                          + "<br>" + qsTr("Potentially reducing the protective capabilities of the cabinet.")
                                                          + "<br>" + qsTr("Ensure that the fan is in nominal speed and the damper is open.")
                                                }
                                            },
                                            State {
                                                when: props.alarmSeasFlapTooPositive
                                                PropertyChanges {
                                                    target: textTeleprompter
                                                    text: qsTr("The pressure is too high!")
                                                          + "<br>" + qsTr("Potentially reducing the protective capabilities of the cabinet.")
                                                          + "<br>" + qsTr("Ensure that the fan is in nominal speed and the damper is open.")
                                                }
                                            },
                                            State {
                                                when: (props.alarmTempHigh)
                                                      || (props.alarmTempLow)
                                                PropertyChanges {
                                                    target: textTeleprompter
                                                    text: qsTr("The environmental temperature is out of range!")
                                                          + "<br>" + qsTr("Potentially reducing the reading accuracy of the airflow sensor.")
                                                          + "<br>" + qsTr("The ideal environmental temperature is between") + " " + props.tempAmbientLowStrf + " - " + props.tempAmbientHighStrf + "."
                                                }
                                            },
                                            State {
                                                when: props.alarmStandbyFanOff
                                                PropertyChanges {
                                                    target: textTeleprompter
                                                    text: qsTr("The Fan should be operating at standby speed while the sash is at standby height!")
                                                          + "<br>" + qsTr("Please switch on the Fan by tapping the Fan button.")
                                                }
                                            }//
                                        ]//
                                    }//

                                    Timer {
                                        id: delayHeightTimer
                                        interval: 10000 // 10s
                                        running: true; repeat: false
                                        onTriggered: {
                                            textTeleprompter.height = textTeleprompterLoader.height
                                        }
                                    }

                                    MouseArea {
                                        id: expandCollapseInfoTextMouseArea
                                        anchors.fill: parent
                                        onClicked: {
                                            if(textTeleprompter.height == textTeleprompter.textHeightArea){
                                                textTeleprompter.height = textTeleprompterLoader.height
                                                textTeleprompter.textY = 0
                                                delayHeightTimer.stop()
                                                return
                                            }
                                            textTeleprompter.height = textTeleprompter.textHeightArea
                                            textTeleprompter.textY = 0
                                            delayHeightTimer.restart()
                                        }//
                                    }//
                                }//

                                visible: active
                                active: {
                                    if (props.alarmsState) {
                                        if (props.alarmSash >= MachineAPI.ALARM_SASH_ACTIVE_UNSAFE_STATE
                                                || props.alarmInflowLow
                                                || props.alarmDownflowLow
                                                || props.alarmDownflowHigh
                                                || props.alarmSeasTooPositive
                                                || props.alarmSeasFlapTooPositive
                                                || props.alarmTempHigh
                                                || props.alarmTempLow
                                                || props.alarmStandbyFanOff
                                                || props.sashCycleLockedAlarm
                                                || props.sashCycleStopCaution
                                                || props.sashCycleReplaceCaution) {
                                            return true
                                        }
                                    }
                                    return false
                                }//
                            }//

                            /// Temp - Clock - Date
                            Rectangle {
                                id: tempClockDate
                                Layout.fillHeight: true
                                Layout.fillWidth: true
                                color: "#0F2952"
                                radius: 5
                                border.width: 1
                                border.color: "#dddddd"

                                RowLayout {
                                    anchors.fill: parent
                                    anchors.margins: 1
                                    spacing: 1

                                    Item {
                                        Layout.fillHeight: true
                                        Layout.minimumWidth: height

                                        WifiSignalApp {
                                            anchors.fill: parent
                                            //dissconnect: !NetworkService.connected
                                            strength: 100 // dummy Value signal strength
                                            opacity: wifiMArea.pressed ? 0.5 : 1
                                            MouseArea {
                                                id: wifiMArea
                                                anchors.fill: parent
                                                onClicked: {
                                                    var intent
                                                    if (!UserSessionService.loggedIn) {
                                                        UserSessionService.askedForLogin()
                                                    }//
                                                    else{
                                                        if(UserSessionService.roleLevel >= UserSessionService.roleLevelAdmin){
                                                            intent = IntentApp.create("qrc:/UI/Pages/NetworkConfigPage/NetworkConfigPage.qml", {})
                                                            startView(intent)
                                                        }
                                                    }
                                                }
                                            }
                                            Component.onCompleted: {
                                                dissconnect = Qt.binding(function(){return !(NetworkService.connected > 0)})
                                            }
                                        }
                                    }

                                    Rectangle {
                                        Layout.minimumHeight: parent.height * 0.7
                                        Layout.minimumWidth: 1
                                        color: "gray"
                                    }///

                                    //USB Icon
                                    Item {
                                        id: usbItem
                                        Layout.fillHeight: true
                                        Layout.minimumWidth: height
                                        enabled: props.usbListStr !== ""
                                                 && props.frontEndScreenState === MachineAPI.ScreenState_Home
                                        visible: enabled
                                        Image {
                                            anchors.fill: parent
                                            source: "qrc:/UI/Pictures/usbvia.png"
                                            opacity: usbMArea.pressed ? 0.5 : 1
                                        }//

                                        MouseArea{
                                            id: usbMArea
                                            enabled: UserSessionService.roleLevel >= UserSessionService.roleLevelAdmin
                                            anchors.fill: parent
                                            onDoubleClicked: {
                                                ejectUsbOptionLoader.active = !ejectUsbOptionLoader.active
                                            }

                                            onPressed: {
                                                ejectUsbOptionLoader.active = false
                                            }//
                                        }//
                                        Loader{
                                            id: ejectUsbOptionLoader
                                            active: false
                                            height: 150
                                            width: 200
                                            y: usbItem.y + usbItem.height
                                            sourceComponent: Item{
                                                Rectangle{
                                                    anchors.fill: parent
                                                    color: "#ee404244"
                                                    radius: 5
                                                    border.width: 1
                                                    border.color: "grey"
                                                    ColumnLayout{
                                                        anchors.fill: parent
                                                        anchors.margins: 5
                                                        Item {
                                                            Layout.fillWidth: true
                                                            Layout.minimumHeight: 24
                                                            Row{
                                                                spacing: 10
                                                                Image {
                                                                    id: ejectIcon
                                                                    anchors.verticalCenter: parent.verticalCenter
                                                                    source: "qrc:/UI/Pictures/usb-eject.png"
                                                                }
                                                                TextApp{
                                                                    text: qsTr("Eject USB Drive")
                                                                    font.pixelSize: 18
                                                                }
                                                            }
                                                            MouseArea{
                                                                anchors.fill: parent
                                                                onClicked: {
                                                                    ejectUsbOptionLoader.active = false
                                                                }//
                                                            }//
                                                        }//
                                                        Rectangle{
                                                            Layout.minimumHeight: 1
                                                            Layout.fillWidth: true
                                                            color: "grey"
                                                            MouseArea{
                                                                anchors.fill: parent
                                                                onClicked: {
                                                                    ejectUsbOptionLoader.active = false
                                                                }//
                                                            }//
                                                        }//
                                                        Item{
                                                            Layout.fillHeight: true
                                                            Layout.fillWidth: true
                                                            RowLayout {
                                                                anchors.fill: parent
                                                                spacing: 2
                                                                Item{
                                                                    Layout.fillHeight: true
                                                                    Layout.fillWidth: true
                                                                    ColumnLayout{
                                                                        anchors.fill: parent
                                                                        anchors.margins: 5
                                                                        Flickable{
                                                                            id: view2
                                                                            Layout.fillHeight: true
                                                                            Layout.fillWidth: true
                                                                            contentWidth: col2.width
                                                                            contentHeight: col2.height
                                                                            clip: true
                                                                            flickableDirection: Flickable.VerticalFlick
                                                                            ScrollBar.vertical: verticalScrollBar2

                                                                            property real span : contentY + height
                                                                            Column{
                                                                                id: col2
                                                                                spacing: 5
                                                                                Repeater{
                                                                                    model: props.usbList/*[
                                                                                        {"name":"SDA1"},
                                                                                        {"name":"SDA2"},
                                                                                        {"name":"SDA3"},
                                                                                        {"name":"SDA4"}
                                                                                    ]*/
                                                                                    Row{
                                                                                        Rectangle{
                                                                                            color: "transparent"
                                                                                            width: 30
                                                                                            height: 30
                                                                                            MouseArea{
                                                                                                anchors.fill: parent
                                                                                                onClicked: {
                                                                                                    ejectUsbOptionLoader.active = false
                                                                                                }//
                                                                                            }//
                                                                                        }//
                                                                                        TextApp{
                                                                                            width: view2.width
                                                                                            height: 30
                                                                                            text: "- %1".arg(String(modelData['name']).toUpperCase())
                                                                                            verticalAlignment: Text.AlignVCenter
                                                                                            elide: Text.ElideRight
                                                                                            font.pixelSize: 18
                                                                                            color: "#A7D7D7"
                                                                                            opacity: optionRectMA.pressed ? 0.5 : 1
                                                                                            MouseArea{
                                                                                                id: optionRectMA
                                                                                                anchors.fill: parent
                                                                                                onClicked: {
                                                                                                    let usbName = modelData['name']
                                                                                                    MachineAPI.requestEjectUsb(usbName)
                                                                                                    ejectUsbOptionLoader.active = false
                                                                                                }//
                                                                                            }//
                                                                                        }//
                                                                                    }//
                                                                                }//
                                                                            }//
                                                                        }//
                                                                    }//
                                                                }//
                                                                Rectangle{
                                                                    id: verticalScrollRectangle2
                                                                    Layout.fillHeight: true
                                                                    Layout.minimumWidth: 6
                                                                    color: "transparent"
                                                                    border.color: "grey"
                                                                    radius: 5
                                                                    visible: view2.contentHeight > height
                                                                    /// Vertical ScrollBar
                                                                    ScrollBar {
                                                                        id: verticalScrollBar2
                                                                        anchors.fill: parent
                                                                        orientation: Qt.Vertical
                                                                        policy: ScrollBar.AsNeeded

                                                                        contentItem: Rectangle {
                                                                            implicitWidth: 0
                                                                            implicitHeight: 5
                                                                            radius: width / 2
                                                                            color: "grey"
                                                                        }//
                                                                    }//
                                                                }//
                                                            }//
                                                        }
                                                    }
                                                }//
                                            }//
                                        }//
                                        onEnabledChanged: {
                                            if(!enabled)
                                                ejectUsbOptionLoader.active = false
                                        }
                                    }//

                                    Rectangle {
                                        Layout.minimumHeight: parent.height * 0.7
                                        Layout.minimumWidth: 1
                                        color: "gray"
                                        visible: usbItem.visible
                                    }///

                                    Item {
                                        Layout.fillHeight: true
                                        Layout.fillWidth: true

                                        TextApp {
                                            id: tempAmbientText
                                            anchors.fill: parent
                                            horizontalAlignment: Text.AlignHCenter
                                            verticalAlignment: Text.AlignVCenter
                                            wrapMode: Text.WrapAtWordBoundaryOrAnywhere
                                            elide: Text.ElideRight
                                            text: qsTr("Temp") + ": " + props.temperatureStrf

                                            states: [
                                                State {
                                                    when: props.tempAmbientStatus == MachineAPI.TEMP_AMB_LOW /*|| true*/
                                                    PropertyChanges {
                                                        target: tempAmbientText
                                                        text: qsTr("Temp") + ": " + props.temperatureStrf + " " + qsTr("(Too low)")
                                                    }
                                                    PropertyChanges {
                                                        target: tempAmbientText
                                                        color: "#db6400"
                                                    }
                                                },
                                                State {
                                                    when: props.tempAmbientStatus == MachineAPI.TEMP_AMB_HIGH /*|| true*/
                                                    PropertyChanges {
                                                        target: tempAmbientText
                                                        text: qsTr("Temp") + ": " + props.temperatureStrf + " " + qsTr("(Too high)")
                                                    }
                                                    PropertyChanges {
                                                        target: tempAmbientText
                                                        color: "#db6400"
                                                    }
                                                }
                                            ]
                                        }//
                                    }//

                                    Rectangle {
                                        Layout.minimumHeight: parent.height * 0.7
                                        Layout.minimumWidth: 1
                                        color: "gray"
                                    }///

                                    Item {
                                        Layout.fillHeight: true
                                        Layout.fillWidth: true

                                        TextApp {
                                            id: currentTimeText
                                            anchors.fill: parent
                                            horizontalAlignment: Text.AlignHCenter
                                            verticalAlignment: Text.AlignVCenter
                                            wrapMode: Text.WrapAtWordBoundaryOrAnywhere
                                            elide: Text.ElideRight
                                            text: MachineData.systemActualTime
                                        }//
                                    }//

                                    Rectangle {
                                        Layout.minimumHeight: parent.height * 0.7
                                        Layout.minimumWidth: 1
                                        color: "gray"
                                    }//

                                    Item {
                                        Layout.fillHeight: true
                                        Layout.fillWidth: true

                                        TextApp {
                                            id: currentDateText
                                            anchors.fill: parent
                                            horizontalAlignment: Text.AlignHCenter
                                            verticalAlignment: Text.AlignVCenter
                                            wrapMode: Text.WrapAtWordBoundaryOrAnywhere
                                            elide: Text.ElideRight
                                            text: MachineData.systemActualDate
                                        }//

                                        MouseArea {
                                            anchors.fill: parent
                                            onClicked: {
                                                var intent
                                                if (!UserSessionService.loggedIn) {
                                                    switch (props.securityAccessLevel) {
                                                    case MachineAPI.MODE_SECURITY_ACCESS_LOW:
                                                        intent = IntentApp.create("qrc:/UI/Pages/CalendarPage/CalendarPage.qml", {})
                                                        startView(intent)
                                                        break;
                                                        //case MachineAPI.MODE_SECURITY_ACCESS_MEDIUM:
                                                    case MachineAPI.MODE_SECURITY_ACCESS_HIGH:
                                                        UserSessionService.askedForLogin()
                                                        break;
                                                    }//
                                                }//
                                                else{
                                                    intent = IntentApp.create("qrc:/UI/Pages/CalendarPage/CalendarPage.qml", {})
                                                    startView(intent)
                                                }
                                            }//
                                        }//
                                    }//
                                }//
                            }//
                        }//
                    }//
                }//

                Loader{
                    id: safelyShutdownLoader
                    width: parent.width
                    height: 60
                    anchors.bottom: parent.bottom
                    clip: true
                    active: false
                    sourceComponent: Rectangle{
                        id: safelyShutdownRect
                        y: safelyShutdownLoader.height
                        width: safelyShutdownLoader.width
                        height: safelyShutdownLoader.height
                        color: "#BB0F2952"
                        border.width: 1
                        border.color: "#BB777777"
                        radius: 5

                        property bool showState: false

                        TextApp {
                            width: parent.width
                            height: parent.height
                            horizontalAlignment: Text.AlignHCenter
                            verticalAlignment: Text.AlignVCenter
                            text: qsTr("After operating this cabinet, shut down the unit safely before unplugging the power supply!")
                        }

                        Timer{
                            id: rectTimer
                            interval: 50
                            repeat: true
                            running: true
                            onTriggered: {
                                ////console.debug("onTriggered!!!")
                                if(safelyShutdownRect.y > 0 && !safelyShutdownRect.showState){
                                    safelyShutdownRect.y = safelyShutdownRect.y - 5
                                }else if(safelyShutdownRect.y < safelyShutdownLoader.height && safelyShutdownRect.showState){
                                    safelyShutdownRect.y = safelyShutdownRect.y + 5
                                }
                                else{
                                    const temp = safelyShutdownRect.showState
                                    safelyShutdownRect.showState = !safelyShutdownRect.showState;
                                    running = false
                                    if(temp) safelyShutdownLoader.active = false
                                }
                            }
                        }

                        MouseArea{
                            anchors.fill: parent
                            onClicked: {
                                //safelyShutdownRect.y = safelyShutdownLoader.height
                                rectTimer.running = true
                            }
                        }
                    }
                    //onActiveChanged: //console.debug("Active:", active)
                }
            }//

            /// FOOTER
            Item {
                id: footerItem
                Layout.fillWidth: true
                Layout.minimumHeight: 110

                Rectangle {
                    anchors.fill: parent
                    color: "#0F2952"
                    radius: 5

                    RowLayout {
                        id: footerRowLayout
                        anchors.fill: parent
                        anchors.margins: 5
                        spacing: 5

                        Item {
                            Layout.fillHeight: true
                            Layout.fillWidth: true

                            CusComPage.ControlButtonApp {
                                id: menuControlButton
                                anchors.fill: parent

                                sourceImage: "qrc:/UI/Pictures/controll/Menu_W.png"

                                states: [
                                    State {
                                        when: stackViewDepth > 1
                                        PropertyChanges {
                                            target: menuControlButton
                                            sourceImage: "qrc:/UI/Pictures/back-step-100.png"
                                        }
                                    }
                                ]

                                function callMenuControlButton (){
                                    MachineAPI.setBuzzerBeep();

                                    if (stackViewDepth > 1) {
                                        const intent = IntentApp.create(uri, {})
                                        finishView(intent)
                                        return
                                    }

                                    const intent = IntentApp.create("qrc:/UI/Pages/MenuPage/MenuPage.qml", {})
                                    startView(intent)
                                }//

                                onClicked: {
                                    if (!UserSessionService.loggedIn && !props.installationWizardActive) {
                                        // console.log(props.securityAccessLevel )
                                        // switch (props.securityAccessLevel) {
                                        // case MachineAPI.MODE_SECURITY_ACCESS_LOW:
                                        //     callMenuControlButton()
                                        //     break;
                                        // //case MachineAPI.MODE_SECURITY_ACCESS_MEDIUM:
                                        // case MachineAPI.MODE_SECURITY_ACCESS_HIGH:
                                        if(stackViewDepth > 1){
                                            const intent = IntentApp.create(uri, {})
                                            finishView(intent)
                                        }
                                        else
                                            UserSessionService.askedForLogin()
                                        //     break;
                                        // }//
                                    }//
                                    else {
                                        if(props.installationWizardActive){
                                            MachineAPI.setBuzzerBeep();
                                            showDialogAsk(qsTr("Welcome"),
                                                          qsTr("Do you want to setup the cabinet now?"),
                                                          dialogInfo,
                                                          function onAccepted(){
                                                              const intent = IntentApp.create("qrc:/UI/Pages/InstallationWizardPage/InstallationWizardPage.qml", {})
                                                              startView(intent)
                                                          },
                                                          function onRejected(){
                                                              MachineAPI.setBuzzerBeep();
                                                              showDialogAsk(qsTr("Welcome"),
                                                                            qsTr("Show me this dialog message later?"),
                                                                            dialogInfo,
                                                                            function onAccepted(){
                                                                                MachineAPI.setInstallationWizardActive(false)
                                                                            },
                                                                            function onRejected(){
                                                                                MachineAPI.setShippingModeEnable(false)
                                                                                MachineAPI.setInstallationWizardActive(false)
                                                                            },
                                                                            function onCLosed(){},
                                                                            true,5,
                                                                            qsTr("Yes"),
                                                                            qsTr("Never")
                                                                            )//
                                                          },
                                                          function onCLosed(){},
                                                          true,5,
                                                          qsTr("OK"),
                                                          qsTr("No, Thanks"))
                                        }
                                        else{
                                            callMenuControlButton()
                                        }
                                    }//
                                }//
                            }//
                        }//

                        Item {
                            Layout.fillHeight: true
                            Layout.fillWidth: true

                            CusComPage.ControlButtonApp {
                                id: fanButton
                                anchors.fill: parent

                                sourceImage: "qrc:/UI/Pictures/controll/Fan_W.png"

                                Loader {
                                    active: MachineData.fanAutoSetEnabled || MachineData.fanAutoSetEnabledOff
                                    anchors.right: parent.right
                                    anchors.rightMargin: 5
                                    anchors.top: parent.top
                                    anchors.topMargin: 5
                                    sourceComponent: Image {
                                        opacity: props.fanInterlocked ? 0.5 : 1
                                        source: "qrc:/UI/Pictures/controll/output-schedulle-icon.png"
                                    }//
                                }//

                                function callFanButton() {
                                    if(!props.postPurgingActive || !props.postPurgingTime){
                                        ///Check the PIN
                                        if(props.fanPIN != "4a7d1ed414474e4033ac29ccb8653d9b")//0000
                                        {
                                            const intent = IntentApp.create("qrc:/UI/Pages/FanPinPage/FanPinPage.qml", {})
                                            startView(intent);
                                            return
                                        }

                                        if (props.fanState) {
                                            showDialogAsk(qsTr("Attention!"), qsTr("Turn off the Fan?"),
                                                          dialogAlert,
                                                          function onAccepted(){
                                                              MachineAPI.setFanState(MachineAPI.FAN_STATE_OFF);
                                                              props.showFanProgressSwitchingState(!props.fanState)

                                                              MachineAPI.insertEventLog(qsTr("User: Set Fan OFF"))
                                                          });
                                        }//
                                        else {
                                            if((props.sashWindowState === MachineAPI.SASH_STATE_STANDBY_SSV)
                                                    && (props.operationMode !== MachineAPI.MODE_OPERATION_MAINTENANCE))
                                                MachineAPI.setFanState(MachineAPI.FAN_STATE_STANDBY);
                                            else{
                                                MachineAPI.setFanState(MachineAPI.FAN_STATE_ON);
                                                MachineAPI.setFilterLifeReminderSnoozed(false)// Reset snooze reminder
                                            }
                                            props.showFanProgressSwitchingState(!props.fanState)

                                            MachineAPI.insertEventLog(qsTr("User: Set Fan ON"))
                                        }
                                    }
                                    else{
                                        showDialogMessage(qsTr("Attention!"),
                                                          qsTr("Post purge timer is running!"),
                                                          dialogAlert)
                                    }//
                                }//

                                onClicked: {
                                    MachineAPI.setBuzzerBeep();

                                    if (stateInterlock) {
                                        showDialogMessage(qsTr("Warning"), qsTr("Interlocked!"), dialogAlert)
                                        return
                                    }

                                    if (!UserSessionService.loggedIn) {
                                        switch(props.securityAccessLevel) {

                                        case MachineAPI.MODE_SECURITY_ACCESS_LOW:
                                            //case MachineAPI.MODE_SECURITY_ACCESS_MEDIUM:
                                            callFanButton()
                                            break;
                                        case MachineAPI.MODE_SECURITY_ACCESS_HIGH:
                                            UserSessionService.askedForLogin()
                                            break;
                                        }
                                    }
                                    else {
                                        callFanButton()
                                    }//
                                }//

                                onPressAndHold: {
                                    //MachineAPI.setBuzzerBeep();
                                    if (!UserSessionService.loggedIn) {
                                        //                                        switch(props.securityAccessLevel) {

                                        //                                        case MachineAPI.MODE_SECURITY_ACCESS_LOW:
                                        //                                        case MachineAPI.MODE_SECURITY_ACCESS_MEDIUM:
                                        //                                            const intent = IntentApp.create("qrc:/UI/Pages/FanSchedulerPage/FanSchedulerPage.qml", {})
                                        //                                            startView(intent)
                                        //                                            break;
                                        //                                        case MachineAPI.MODE_SECURITY_ACCESS_HIGH:
                                        UserSessionService.askedForLogin()
                                        //                                            break;
                                        //                                        }
                                    }
                                    else {
                                        //                                        if(UserSessionService.roleLevel > UserSessionService.roleLevelGuest){
                                        //                                        if(UserSessionService.roleLevel != UserSessionService.roleLevelAdmin){
                                        let intent1;
                                        if(props.modeIsMaintenance)
                                            intent1 = IntentApp.create("qrc:/UI/Pages/FanSpeedPage/FanSpeedPage.qml", {})
                                        else
                                            intent1 = IntentApp.create("qrc:/UI/Pages/FanSchedulerPage/FanSchedulerPage.qml", {})
                                        const intent = intent1
                                        startView(intent)
                                        //                                        }//
                                        //                                        }
                                    }//
                                }//

                                stateInterlock: props.fanInterlocked

                                states: [
                                    State {
                                        when: props.fanState == MachineAPI.FAN_STATE_ON
                                        PropertyChanges {
                                            target: fanButton
                                            sourceImage: "qrc:/UI/Pictures/controll/Fan_G.png"
                                        }
                                    },
                                    State {
                                        when: props.fanState == MachineAPI.FAN_STATE_STANDBY
                                        PropertyChanges {
                                            target: fanButton
                                            sourceImage: "qrc:/UI/Pictures/controll/STB_G.png"
                                        }
                                    }//
                                ]//
                            }//
                        }//

                        Item {
                            Layout.fillHeight: true
                            Layout.fillWidth: true

                            CusComPage.ControlButtonApp {
                                id: lightButton
                                anchors.fill: parent

                                sourceImage: "qrc:/UI/Pictures/controll/Light_W.png"

                                TextApp {
                                    visible: props.lampState
                                    anchors.left: parent.left
                                    anchors.leftMargin: 10
                                    anchors.top: parent.top
                                    anchors.topMargin: 5
                                    text: props.lampIntensity + "%"
                                    opacity: percentLampMArea.pressed ? 0.5 : 1
                                    MouseArea{
                                        id: percentLampMArea
                                        anchors.fill: parent
                                        onPressAndHold: {
                                            //console.debug("onPressAndHold percentage")
                                            var intent = IntentApp.create("qrc:/UI/Pages/LightIntensityPage/LightIntensityPage.qml", {})
                                            startView(intent)
                                        }
                                    }
                                }//

                                Loader {
                                    active: MachineData.lightAutoSetEnabled || MachineData.lightAutoSetEnabledOff
                                    anchors.right: parent.right
                                    anchors.rightMargin: 5
                                    anchors.top: parent.top
                                    anchors.topMargin: 5
                                    sourceComponent: Image {
                                        opacity: props.lampInterlocked ? 0.5 : 1
                                        source: "qrc:/UI/Pictures/controll/output-schedulle-icon.png"
                                    }//
                                }//

                                // function callLightButtonOnHold() {
                                //     let currentState = MachineData.lightState
                                //     if (!currentState) {
                                //         MachineAPI.setLightState(!currentState);
                                //     }

                                //     var intent = IntentApp.create("qrc:/UI/Pages/LightIntensityPage/LightIntensityPage.qml", {})
                                //     startView(intent)
                                // }//

                                function callLightButton (){
                                    MachineAPI.setBuzzerBeep();

                                    if (stateInterlock) {
                                        showDialogMessage(qsTr("Warning"), qsTr("Interlocked!"), dialogAlert)
                                        return
                                    }//

                                    let currentState = props.lampState
                                    MachineAPI.setLightState(!currentState);

                                    const str = !currentState ? qsTr("User: Set LED light ON")
                                                              : qsTr("User: Set LED light OFF")
                                    MachineAPI.insertEventLog(str)
                                }

                                onPressAndHold: {
                                    //console.debug("onPressAndHold button")
                                    if (!UserSessionService.loggedIn) {
                                        // switch(props.securityAccessLevel) {

                                        // case MachineAPI.MODE_SECURITY_ACCESS_LOW:
                                        // case MachineAPI.MODE_SECURITY_ACCESS_MEDIUM:
                                        //     callLightButtonOnHold()
                                        //     break;
                                        // case MachineAPI.MODE_SECURITY_ACCESS_HIGH:
                                        UserSessionService.askedForLogin()
                                        //     break;
                                        // }
                                    }
                                    else {
                                        // if(UserSessionService.roleLevel != UserSessionService.roleLevelAdmin){
                                        // callLightButtonOnHold()
                                        const intent = IntentApp.create("qrc:/UI/Pages/LightSchedulerPage/LightSchedulerPage.qml", {})
                                        startView(intent)
                                        // }
                                    }//
                                }//

                                onClicked: {

                                    if (!UserSessionService.loggedIn) {
                                        switch(props.securityAccessLevel) {

                                        case MachineAPI.MODE_SECURITY_ACCESS_LOW:
                                            //case MachineAPI.MODE_SECURITY_ACCESS_MEDIUM:
                                            callLightButton()
                                            break;
                                        case MachineAPI.MODE_SECURITY_ACCESS_HIGH:
                                            UserSessionService.askedForLogin()
                                            break;
                                        }
                                    }
                                    else {
                                        callLightButton()
                                    }//
                                }//

                                stateInterlock: props.lampInterlocked

                                states: [
                                    State {
                                        when: props.lampState
                                        PropertyChanges {
                                            target: lightButton
                                            sourceImage: "qrc:/UI/Pictures/controll/Light_G.png"
                                        }//
                                    }//
                                ]
                            }//
                        }//

                        Item {
                            Layout.fillHeight: true
                            Layout.fillWidth: true
                            visible: props.socketInstalled
                            //                            visible: false

                            Loader {
                                active: props.socketInstalled
                                anchors.fill: parent
                                sourceComponent: CusComPage.ControlButtonApp {
                                    id: socketButton
                                    anchors.fill: parent

                                    sourceImage: "qrc:/UI/Pictures/controll/Socket_W.png"

                                    Loader {
                                        active: MachineData.socketAutoSetEnabled || MachineData.socketAutoSetEnabledOff
                                        anchors.right: parent.right
                                        anchors.rightMargin: 5
                                        anchors.top: parent.top
                                        anchors.topMargin: 5
                                        sourceComponent:  Image {
                                            opacity: props.socketInterlocked ? 0.5 : 1
                                            source: "qrc:/UI/Pictures/controll/output-schedulle-icon.png"
                                        }//
                                    }//

                                    function callSocketButton() {
                                        MachineAPI.setBuzzerBeep();

                                        if (stateInterlock) {
                                            showDialogMessage(qsTr("Warning"), qsTr("Interlocked!"), dialogAlert)
                                            return
                                        }//

                                        let currentState = props.socketState
                                        MachineAPI.setSocketState(!currentState);

                                        const str = !currentState ? qsTr("User: Set Outlet ON")
                                                                  : qsTr("User: Set Outlet OFF")
                                        MachineAPI.insertEventLog(str)
                                    }//


                                    onClicked: {

                                        if (!UserSessionService.loggedIn) {
                                            switch(props.securityAccessLevel) {

                                            case MachineAPI.MODE_SECURITY_ACCESS_LOW:
                                                //case MachineAPI.MODE_SECURITY_ACCESS_MEDIUM:
                                                callSocketButton()
                                                break;
                                            case MachineAPI.MODE_SECURITY_ACCESS_HIGH:
                                                UserSessionService.askedForLogin()
                                                break;
                                            }
                                        }
                                        else {
                                            callSocketButton()
                                        }//
                                    }//

                                    onPressAndHold: {
                                        //MachineAPI.setBuzzerBeep();
                                        if (!UserSessionService.loggedIn) {
                                            // switch(props.securityAccessLevel) {

                                            // case MachineAPI.MODE_SECURITY_ACCESS_LOW:
                                            // case MachineAPI.MODE_SECURITY_ACCESS_MEDIUM:
                                            //     const intent = IntentApp.create("qrc:/UI/Pages/UVSchedulerPage/UVSchedulerPage.qml", {})
                                            //     startView(intent)
                                            //     break;
                                            // case MachineAPI.MODE_SECURITY_ACCESS_HIGH:
                                            UserSessionService.askedForLogin()
                                            //     break;
                                            // }
                                        }
                                        else {
                                            // if(UserSessionService.roleLevel != UserSessionService.roleLevelAdmin){
                                            const intent = IntentApp.create("qrc:/UI/Pages/SocketSchedulerPage/SocketSchedulerPage.qml", {})
                                            startView(intent)
                                            // }
                                        }//
                                    }//

                                    stateInterlock: props.socketInterlocked

                                    states: [
                                        State {
                                            when: props.socketState
                                            PropertyChanges {
                                                target: socketButton
                                                sourceImage: "qrc:/UI/Pictures/controll/Socket_G.png"
                                            }
                                        }
                                    ]
                                }//
                            }
                        }//

                        Item {
                            Layout.fillHeight: true
                            Layout.fillWidth: true
                            visible: props.gasInstalled
                            //                            visible: false

                            Loader {
                                active: props.gasInstalled
                                anchors.fill: parent
                                sourceComponent: CusComPage.ControlButtonApp {
                                    id: gasButton
                                    anchors.fill: parent

                                    sourceImage: "qrc:/UI/Pictures/controll/Gas_W.png"

                                    function callGasButton(){
                                        MachineAPI.setBuzzerBeep();

                                        if (stateInterlock) {
                                            showDialogMessage(qsTr("Warning"), qsTr("Interlocked!"), dialogAlert)
                                            return
                                        }//

                                        let currentState = props.gasState
                                        MachineAPI.setGasState(!currentState);

                                        const str = !currentState ? qsTr("User: Set Gas ON")
                                                                  : qsTr("User: Set Gas OFF")
                                        MachineAPI.insertEventLog(str)
                                    }//

                                    onClicked: {
                                        if (!UserSessionService.loggedIn) {
                                            switch(props.securityAccessLevel) {

                                            case MachineAPI.MODE_SECURITY_ACCESS_LOW:
                                                //case MachineAPI.MODE_SECURITY_ACCESS_MEDIUM:
                                                callGasButton()
                                                break;
                                            case MachineAPI.MODE_SECURITY_ACCESS_HIGH:
                                                UserSessionService.askedForLogin()
                                                break;
                                            }
                                        }
                                        else {
                                            callGasButton()
                                        }//
                                    }//

                                    stateInterlock: props.gasInterlocked

                                    states: [
                                        State {
                                            when: props.gasState
                                            PropertyChanges {
                                                target: gasButton
                                                sourceImage: "qrc:/UI/Pictures/controll/Gas_G.png"
                                            }//
                                        }//
                                    ]
                                }//
                            }//
                        }//

                        Item {
                            Layout.fillHeight: true
                            Layout.fillWidth: true
                            // visible: false
                            visible: props.uvInstalled

                            Loader {
                                active: props.uvInstalled
                                anchors.fill: parent
                                sourceComponent: CusComPage.ControlButtonApp {
                                    id: uvButton
                                    anchors.fill: parent

                                    sourceImage: "qrc:/UI/Pictures/controll/UV_W.png"

                                    Loader {
                                        active: MachineData.uvAutoSetEnabled || MachineData.uvAutoSetEnabledOff
                                        anchors.right: parent.right
                                        anchors.rightMargin: 5
                                        anchors.top: parent.top
                                        anchors.topMargin: 5
                                        sourceComponent:  Image {
                                            opacity: props.uvInterlocked ? 0.5 : 1
                                            source: "qrc:/UI/Pictures/controll/output-schedulle-icon.png"
                                        }//
                                    }//

                                    function callUVbutton(){
                                        MachineAPI.setBuzzerBeep();

                                        if (stateInterlock) {
                                            showDialogMessage(qsTr("Warning"), qsTr("Interlocked!"), dialogAlert)
                                            return
                                        }

                                        let currentState = props.uvState
                                        MachineAPI.setUvState(!currentState);

                                        const str = !currentState ? qsTr("User: Set UV light ON")
                                                                  : qsTr("User: Set UV light OFF")
                                        MachineAPI.insertEventLog(str)

                                        if(!currentState){
                                            MachineAPI.setUvReplacementReminderSnoozed(false)// reset UV Replacement Reminder Snooze
                                        }
                                    }//

                                    onClicked: {
                                        if (!UserSessionService.loggedIn) {
                                            switch(props.securityAccessLevel) {

                                            case MachineAPI.MODE_SECURITY_ACCESS_LOW:
                                                //case MachineAPI.MODE_SECURITY_ACCESS_MEDIUM:
                                                callUVbutton()
                                                break;
                                            case MachineAPI.MODE_SECURITY_ACCESS_HIGH:
                                                UserSessionService.askedForLogin()
                                                break;
                                            }
                                        }
                                        else {
                                            callUVbutton()
                                        }//
                                    }//

                                    onPressAndHold: {
                                        //MachineAPI.setBuzzerBeep();

                                        if (!UserSessionService.loggedIn) {
                                            //                                            switch(props.securityAccessLevel) {

                                            //                                            case MachineAPI.MODE_SECURITY_ACCESS_LOW:
                                            //                                            case MachineAPI.MODE_SECURITY_ACCESS_MEDIUM:
                                            //                                                const intent = IntentApp.create("qrc:/UI/Pages/UVSchedulerPage/UVSchedulerPage.qml", {})
                                            //                                                startView(intent)
                                            //                                                break;
                                            //                                            case MachineAPI.MODE_SECURITY_ACCESS_HIGH:
                                            UserSessionService.askedForLogin()
                                            //                                                break;
                                            //                                            }
                                        }
                                        else {
                                            //                                            if(UserSessionService.roleLevel != UserSessionService.roleLevelAdmin){
                                            const intent = IntentApp.create("qrc:/UI/Pages/UVSchedulerPage/UVSchedulerPage.qml", {})
                                            startView(intent)
                                            //                                            }
                                        }//
                                    }//

                                    stateInterlock: props.uvInterlocked || (props.sashWindowState !== MachineAPI.SASH_STATE_FULLY_CLOSE_SSV)

                                    states: [
                                        State {
                                            when: props.uvState
                                            PropertyChanges {
                                                target: uvButton
                                                sourceImage: "qrc:/UI/Pictures/controll/UV_G.png"
                                            }
                                        }
                                    ]
                                }//
                            }//
                        }//

                        Item {
                            Layout.fillHeight: true
                            Layout.fillWidth: true

                            CusComPage.ControlButtonApp {
                                id: muteAlarmButton
                                anchors.fill: parent
                                //stateInterlock: !props.alarmsState

                                sourceImage: "qrc:/UI/Pictures/controll/Mute_W.png"

                                function callMuteAlarmButton () {
                                    if (!props.alarmsState) {
                                        showDialogMessage(qsTr("Audible Alarm"), qsTr("No audible alarm."), dialogAlert)
                                        return
                                    }
                                    else if(props.vivariumMuteState){
                                        MachineAPI.setMuteVivariumState(false)
                                    }//
                                    else if (props.alarmSashFullyOpen
                                             || props.alarmBoardComError
                                             || props.alarmInflowLow
                                             || props.alarmDownflowLow
                                             || props.alarmDownflowHigh
                                             || props.alarmSeasTooPositive
                                             || props.alarmSeasFlapTooPositive) {

                                        MachineAPI.setMuteAlarmState(!props.muteAlarmState)
                                    }
                                    else if (props.alarmsState) {
                                        showDialogMessage(qsTr("Audible Alarm"),
                                                          qsTr("This audible alarm cannot be muted!"), dialogAlert)
                                    }

                                    else {
                                        showDialogMessage(qsTr("Audible Alarm"),
                                                          qsTr("No audible alarm."), dialogAlert)
                                    }//
                                }//

                                onPressAndHold: {
                                    if(props.machineModelName == "VA2")
                                    {
                                        if (!UserSessionService.loggedIn) {
                                            UserSessionService.askedForLogin()
                                        }
                                        else {
                                            const intent = IntentApp.create("qrc:/UI/Pages/VivariumMuteSetPage/VivariumMuteSetPage.qml", {})
                                            startView(intent)
                                        }//
                                    }//
                                }//

                                onClicked: {
                                    MachineAPI.setBuzzerBeep();

                                    if (!UserSessionService.loggedIn) {
                                        switch(props.securityAccessLevel) {

                                        case MachineAPI.MODE_SECURITY_ACCESS_LOW:
                                            //case MachineAPI.MODE_SECURITY_ACCESS_MEDIUM:
                                            callMuteAlarmButton()
                                            break;
                                        case MachineAPI.MODE_SECURITY_ACCESS_HIGH:
                                            UserSessionService.askedForLogin()
                                            break;
                                        }
                                    }
                                    else {
                                        callMuteAlarmButton()
                                    }//
                                }//

                                states: [
                                    State {
                                        when: props.muteAlarmState
                                        PropertyChanges {
                                            target: muteAlarmButton
                                            sourceImage: "qrc:/UI/Pictures/controll/Mute_G.png"
                                        }
                                    }
                                ]
                            }//
                        }//
                    }//
                }//
            }//
        }//

        Loader{
            id: popupBookedScheduleLoader
            active: false
            visible: active
            anchors.fill: parent
            sourceComponent: Item{
                id: popupBookedScheduleItem
                anchors.fill: parent
                property int popUpShowTimer: 5 //seconds

                Rectangle{
                    anchors.fill: parent
                    opacity: 0.8
                    color: "black"
                }
                Item {
                    id: root
                    anchors.centerIn: parent
                    height: 300
                    width: 500
                    clip: true

                    scale: visible ? 1.0 : 0.9
                    Behavior on scale {
                        NumberAnimation { duration: 100}
                    }//
                    property int gridCount: props.bookedScheduleNotifStringList.length

                    Rectangle {
                        anchors.fill: parent
                        color: "#6E6D6D"
                        radius: 5
                    }

                    ColumnLayout {
                        anchors.fill: parent
                        Item {
                            Layout.minimumHeight: 40
                            Layout.fillWidth: true
                            Image {
                                id: featureImage
                                anchors.fill: parent
                                source: "qrc:/UI/CusCom/Dialog/HeaderBackground.png"
                            }

                            Text {
                                id: titleText
                                height: parent.height
                                width: parent.width
                                horizontalAlignment: Text.AlignHCenter
                                verticalAlignment: Text.AlignVCenter
                                font.pixelSize: 20
                                color: "#effffd"
                                font.bold: true
                                text: qsTr("Booking Schedule Notification")
                            }
                        }

                        Item {
                            Layout.fillHeight: true
                            Layout.fillWidth: true
                            ColumnLayout{
                                anchors.fill: parent
                                Item{
                                    Layout.fillHeight: true
                                    Layout.fillWidth: true
                                    RowLayout{
                                        anchors.fill: parent
                                        Item{
                                            visible: root.gridCount >= 1
                                            Layout.fillHeight: true
                                            Layout.fillWidth: true
                                            TextApp{
                                                height: parent.height
                                                width: parent.width
                                                verticalAlignment: Text.AlignVCenter
                                                horizontalAlignment: Text.AlignHCenter
                                                text: parent.visible ? props.bookedScheduleNotifStringList[0] : ""
                                                elide: Text.ElideRight
                                                wrapMode: Text.WordWrap
                                                padding: 5
                                            }
                                        }
                                        Item{
                                            visible: root.gridCount >= 2
                                            Layout.fillHeight: true
                                            Layout.fillWidth: true
                                            TextApp{
                                                height: parent.height
                                                width: parent.width
                                                verticalAlignment: Text.AlignVCenter
                                                horizontalAlignment: Text.AlignHCenter
                                                text: parent.visible ? props.bookedScheduleNotifStringList[1] : ""
                                                elide: Text.ElideRight
                                                wrapMode: Text.WordWrap
                                                padding: 5
                                            }
                                        }
                                    }
                                }
                                Item{
                                    visible: root.gridCount > 2
                                    Layout.fillHeight: true
                                    Layout.fillWidth: true
                                    RowLayout{
                                        anchors.fill: parent
                                        Item{
                                            visible: root.gridCount >= 3
                                            Layout.fillHeight: true
                                            Layout.fillWidth: true
                                            TextApp{
                                                height: parent.height
                                                width: parent.width
                                                verticalAlignment: Text.AlignVCenter
                                                horizontalAlignment: Text.AlignHCenter
                                                text: parent.visible ? props.bookedScheduleNotifStringList[2] : ""
                                                elide: Text.ElideRight
                                                wrapMode: Text.WordWrap
                                                padding: 5
                                            }
                                        }
                                        Item{
                                            visible: root.gridCount >= 4
                                            Layout.fillHeight: true
                                            Layout.fillWidth: true
                                            TextApp{
                                                height: parent.height
                                                width: parent.width
                                                verticalAlignment: Text.AlignVCenter
                                                horizontalAlignment: Text.AlignHCenter
                                                text: parent.visible ? props.bookedScheduleNotifStringList[3] : ""
                                                elide: Text.ElideRight
                                                wrapMode: Text.WordWrap
                                                padding: 5
                                            }//
                                        }//
                                    }//
                                }//
                            }//
                        }//

                        Item {
                            Layout.minimumHeight: 50
                            Layout.fillWidth: true

                            Loader {
                                anchors.fill: parent
                                sourceComponent: Item {
                                    Rectangle {
                                        anchors.fill: parent
                                        color: "#888888"
                                        radius: 5

                                        MouseArea {
                                            id: rejectedMouseArea
                                            anchors.fill: parent
                                            onClicked: {
                                                popupBookedScheduleLoader.active = false
                                            }
                                        }//
                                    }//

                                    Text {
                                        anchors.fill: parent
                                        horizontalAlignment: Text.AlignHCenter
                                        verticalAlignment: Text.AlignVCenter
                                        font.pixelSize: 20
                                        color: "#effffd"
                                        text: "Close"
                                    }
                                }
                            }
                        }
                    }//
                }//

                Timer{
                    running: popupBookedScheduleLoader.active
                    repeat: true
                    interval: 1000
                    onTriggered: {
                        popupBookedScheduleItem.popUpShowTimer--
                        if(popupBookedScheduleItem.popUpShowTimer <= 0){
                            popupBookedScheduleLoader.active = false
                        }
                    }
                }
            }//
        }//

        //        //// Timer for update current clock and date
        //        Timer{
        //            id: timeDateTimer
        //            interval: 10000
        //            repeat: true
        //            running: contentView.visible
        //            triggeredOnStart: true
        //            onTriggered: {
        //                var datetime = new Date();
        //                //            dateText.text = Qt.formatDateTime(datetime, "dddd\nMMM dd yyyy")
        //                let date = Qt.formatDateTime(datetime, "MMM dd yyyy")
        //                currentDateText.text = date

        //                let timeFormatStr = "h:mm AP"
        //                if (HeaderAppService.timePeriod === 24) timeFormatStr = "hh:mm"

        //                let clock = Qt.formatDateTime(datetime, timeFormatStr)
        //                currentTimeText.text = clock
        //            }//
        //        }//

        UtilsApp {
            id: utils
        }//

        ///Note: Each WorkerScript element will instantiate a separate JavaScript engine to ensure perfect isolation and thread-safety.
        ///If the impact of that results in a memory consumption that is too high for your environment, then consider sharing a WorkerScript element.
        WorkerScript {
            id: myWorker
            source: "Components/WorkerScriptGenerateBookedScheduleNotifStrList.mjs"

            property bool established: false
            Component.onCompleted: established = true

            onMessage: {
                props.bookedScheduleNotifStringList = messageObject.bookedScheduleNotifStringList
            }
        }//

        QtObject {
            id: props

            property bool currentPageIsForground: false

            property int    expTimerCount: 0
            property bool   expTimerIsRunning: false
            property bool   expTimerIsPaused: false
            property bool   expTimerTimeout: false
            property bool   expTimerActive: false
            property bool   expTimerAlwaysShow: false

            property int    stopwatchTimerCount: 0
            property bool   stopwatchTimerIsRunning: false
            property bool   stopwatchTimerIsPaused: false
            //property bool   stopwatchTimerTimeout: false
            property bool   stopwatchTimerActive: false

            property string temperatureStrf: "--"

            property string downflowStr: "--"
            property string inflowStr: "--"

            property int sashWindowState: 0
            property int sashCycle: 0
            property bool sashCycleLockedAlarm: false
            property bool sashCycleStopCaution: false
            property bool sashCycleReplaceCaution: false

            property bool fanInterlocked: false
            property int  fanState: 0

            property bool lampInterlocked: false
            property int  lampState: 0
            property int  lampIntensity: 0

            property bool socketInstalled: false
            property bool socketInterlocked: false
            property int  socketState: 0

            property bool gasInstalled: false
            property bool gasInterlocked: false
            property int  gasState: 0

            property bool uvInstalled: false
            property bool uvInterlocked: false
            property int  uvState: 0

            property bool sashMotorizeInstalled: false
            property bool sashMotorizeUpInterlocked: false
            property bool sashMotorizeDownInterlocked: false
            property int  sashMotorizeState: 0

            property bool    seasFlapInstalled: false
            //            property string  seasPressureStr: "---"
            property bool    alarmSeasFlapTooPositive: false

            property bool    seasInstalled: false
            property string  seasPressureStr: "---"
            property bool    alarmSeasTooPositive: false

            property int uvTimeCountDown: 180
            property int uvLifePercent: 100
            property string uvLifeLeftStrf: "2000 hours"
            property string uvLifeLevelColor: "#05B837"

            property int filterLifePercent: 100
            property string filterLifeLevelStrf: "Excellent"
            property string filterLifeLevelColor: "#05B837"

            property bool muteIsAvailable: false
            property int  muteAlarmState: 0
            property int  muteAlarmTimeCountdown: 0
            property bool vivariumMuteState: false

            property string loginUsername: ""
            property string loginFullname: ""

            property bool filterLifeReminder: false
            property bool uvLifeReminder: false
            property bool datalogIsFull: false
            property bool eventlogIsFull: false
            property bool alarmlogIsFull: false
            property bool replaceableCompRecordIsFull: false
            property bool resmonlogIsFull: false

            property string certfRemExpiredDate: ""
            property bool certfRemExpiredValid: false
            property bool certfRemExpiredDue: false
            property int  certfRemExpiredCount: 0

            property bool alarmsState: false

            property int  alarmSash: 0
            property bool alarmSashUnsafe: false
            property bool alarmSashError: false
            property bool alarmSashFullyOpen: false
            property bool alarmSashUnknown: false
            property bool  alarmInflowLow: false
            property bool  alarmDownflowLow: false
            property bool  alarmDownflowHigh: false
            property bool  alarmTempHigh: false
            property bool  alarmTempLow: false
            property bool alarmStandbyFanOff: false

            property bool alarmBoardComError: false

            property bool warmingUpActive: false
            property int  warmingUpCountdown: 180

            property bool postPurgeActive: false
            property int  postPurgeCountdown: 180

            property int tempAmbientStatus: 0
            property string tempAmbientLowStrf: "18°C"
            property string tempAmbientHighStrf: "30°C"

            property bool sensorCalibrated: false

            property bool powerOutage: false

            property bool modeIsMaintenance: false

            property int securityAccessLevel: 0

            property string cabinetDisplayName: "BSC Lab-1"

            property string fanPIN: ""

            property bool particleCounterSensorInstalled:  false
            property int particleCounterPM2_5:  0
            property int particleCounterPM1_0:  0
            property int particleCounterPM10:   0

            //property bool buttonSashMotorizedDownPressed : false;
            property bool airflowMonitorEnable: true
            property bool alarmSashMotorDownStuck: false

            property bool alarmPrevMaintActive: false
            property int alarmPrevMaintActiveCode: 0x0000
            property string alarmPrevMaintenanceReminderStr: ""

            property bool airflowFailAfMonDisabled: false

            property string usbListStr: ""
            property var usbList: []

            property bool bookedScheduleNotifDisplay: false
            property bool bookedScheduleAck: false
            property bool bookedScheduleNotifCollapse: false
            property var bookedScheduleNotifStringList: []

            property var bookedScheduleForToday: []
            //////
            property bool airflowOutTempEnable: false
            property bool advancedAirflowAlarmEnable: false
            property bool filterLifeDisplayEnabled: false

            property int uvLifeMinutes: 0
            property int uvTime: 0

            property string machineModelName: ""

            property int frontEndScreenState: 0

            property bool installationWizardActive: false

            property bool postPurgingActive: false
            property int postPurgingTime: 0

            property int operationMode: 0


            onExpTimerTimeoutChanged: {
                if(expTimerTimeout){
                    MachineAPI.setAlarmExperimentTimerIsOver(MachineAPI.ALARM_ACTIVE_STATE)
                }//
            }//

            function showFanProgressSwitchingState(switchTo){
                //////console.debug("switchTo: " + switchTo)
                let str = ""
                const purgeTime = props.postPurgingTime
                if(!switchTo && (purgeTime > 0))
                    str = "<br>" + qsTr("Please wait for %1").arg(utils.strfSecsToHumanReadableShort(purgeTime))
                const message = switchTo ? qsTr("Switching on the fan") + "..."
                                         : (qsTr("Switching off the fan") + str + "...")
                showNotifToShutDownTheCabinet(false);
                viewApp.showBusyPage(message, function(cycle){
                    if(cycle >= MachineAPI.BUSY_CYCLE_FAN){
                        if(!switchTo && !props.postPurgingActive && (props.sashWindowState !== MachineAPI.SASH_STATE_FULLY_CLOSE_SSV))
                            showNotifToShutDownTheCabinet(true);
                        viewApp.closeDialog()
                    }//
                })//
            }//
            function showNotifToShutDownTheCabinetPostPurge(postpurge){
                showNotifToShutDownTheCabinet(!postpurge)
            }
            function showNotifToShutDownTheCabinet(show){
                safelyShutdownLoader.active = show;
            }//

            function generateBookedScheduleNotifStringList(){
                myWorker.sendMessage({
                                         "action": "init",
                                         "bookedScheduleForToday": bookedScheduleForToday
                                     })
            }//
        }//

        /// One time executed at startup
        Component.onCompleted: {
        }//

        //// Execute This Every This Screen Active/Visible/Foreground
        executeOnPageVisible: QtObject {
            /// onResume
            Component.onCompleted: {
                //                //console.debug("StackView.Active");
                //                    ////console.debug("stackViewDepth: " + stackViewDepth)
                props.usbListStr = Qt.binding(function(){return MachineData.usbDetectedList})
                props.usbList = Qt.binding(function(){
                    let usbList = []
                    let usbListArr = []
                    usbListArr = props.usbListStr.split(',')

                    ////console.debug("USB List: " + usbListArr)

                    for(let i = 0; i < usbListArr.length; i++){
                        usbList.push({"name": usbListArr[i]})
                    }//
                    return usbList;
                })//

                props.securityAccessLevel = Qt.binding(function() {return MachineData.securityAccessMode })

                props.temperatureStrf = Qt.binding(function() { return MachineData.temperatureValueStr })

                props.expTimerCount = Qt.binding( function() { return ExperimentTimerService.count })
                props.expTimerIsRunning = Qt.binding( function() { return ExperimentTimerService.isRunning})
                props.expTimerIsPaused = Qt.binding( function() { return ExperimentTimerService.isPaused})
                props.expTimerTimeout = Qt.binding( function() { return ExperimentTimerService.timeout})
                props.expTimerActive = (props.expTimerIsRunning || props.expTimerIsPaused) && !props.expTimerTimeout
                props.expTimerAlwaysShow = Qt.binding(function(){ return MachineData.experimentTimerAlwaysShow})

                props.stopwatchTimerCount = Qt.binding( function() { return StopwatchTimerService.count })
                props.stopwatchTimerIsRunning = Qt.binding( function() { return StopwatchTimerService.isRunning})
                props.stopwatchTimerIsPaused = Qt.binding( function() { return StopwatchTimerService.isPaused})
                //props.stopwatchTimerTimeout = Qt.binding( function() { return StopwatchTimerService.timeout})
                props.stopwatchTimerActive = (props.stopwatchTimerIsRunning || props.stopwatchTimerIsPaused)

                ////console.debug("@@@@@@@@@expTimerActive", props.expTimerActive, props.expTimerIsRunning, props.expTimerIsPaused, props.expTimerTimeout)

                props.downflowStr = Qt.binding(function(){ return MachineData.dfaVelocityStr })
                props.inflowStr = Qt.binding(function(){ return MachineData.ifaVelocityStr })

                props.alarmsState = Qt.binding(function(){ return MachineData.alarmsState })

                props.alarmBoardComError = Qt.binding(function(){ return MachineData.alarmBoardComError === MachineAPI.ALARM_ACTIVE_STATE })

                props.alarmSash = Qt.binding(function(){ return MachineData.alarmSash })
                props.alarmSashUnsafe = Qt.binding(function(){ return MachineData.alarmSash === MachineAPI.ALARM_SASH_ACTIVE_UNSAFE_STATE })
                props.alarmSashError = Qt.binding(function(){ return MachineData.alarmSash === MachineAPI.ALARM_SASH_ACTIVE_ERROR_STATE })
                props.alarmSashFullyOpen = Qt.binding(function(){ return MachineData.alarmSash === MachineAPI.ALARM_SASH_ACTIVE_FO_STATE })
                props.alarmSashUnknown = Qt.binding(function(){ return MachineData.alarmSash === MachineAPI.ALARM_SASH_ACTIVE_ERROR_STATE })

                props.alarmInflowLow = Qt.binding(function(){ return MachineData.alarmInflowLow === MachineAPI.ALARM_ACTIVE_STATE})
                props.alarmDownflowLow = Qt.binding(function(){ return MachineData.alarmDownflowLow === MachineAPI.ALARM_ACTIVE_STATE})
                props.alarmDownflowHigh = Qt.binding(function(){ return MachineData.alarmDownflowHigh === MachineAPI.ALARM_ACTIVE_STATE})

                props.alarmTempHigh = Qt.binding(function(){ return MachineData.alarmTempHigh === MachineAPI.ALARM_ACTIVE_STATE})
                props.alarmTempLow = Qt.binding(function(){ return MachineData.alarmTempLow === MachineAPI.ALARM_ACTIVE_STATE})

                props.sashWindowState = Qt.binding(function(){ return MachineData.sashWindowState })

                props.alarmStandbyFanOff = Qt.binding(function(){ return MachineData.alarmStandbyFanOff === MachineAPI.ALARM_ACTIVE_STATE})
                props.fanInterlocked = Qt.binding(function(){ return MachineData.fanPrimaryInterlocked })
                props.fanState = Qt.binding(function(){ return MachineData.fanPrimaryState })

                props.lampInterlocked = Qt.binding(function(){ return MachineData.lightInterlocked })
                props.lampState = Qt.binding(function(){ return MachineData.lightState })
                props.lampIntensity = Qt.binding(function(){ return MachineData.lightIntensity })

                props.socketInstalled = MachineData.socketInstalled
                props.socketInterlocked = Qt.binding(function(){ return MachineData.socketInterlocked })
                props.socketState = Qt.binding(function(){ return MachineData.socketState })

                props.gasInstalled = MachineData.gasInstalled
                props.gasInterlocked = Qt.binding(function(){ return MachineData.gasInterlocked })
                props.gasState = Qt.binding(function(){ return MachineData.gasState })

                props.uvInstalled = MachineData.uvInstalled
                props.uvInterlocked = Qt.binding(function(){ return MachineData.uvInterlocked })
                props.uvState = Qt.binding(function(){ return MachineData.uvState })

                //                    props.muteIsAvailable = Qt.binding(function(){ return MachineData.muteAlarmState })
                props.muteAlarmState = Qt.binding(function(){ return MachineData.muteAlarmState })
                props.muteAlarmTimeCountdown = Qt.binding(function(){ return MachineData.muteAlarmCountdown })
                props.vivariumMuteState = Qt.binding(function(){ return MachineData.vivariumMuteState })

                props.filterLifePercent = Qt.binding(function(){ return MachineData.filterLifePercent })
                props.filterLifeLevelStrf = Qt.binding(function(){ return MachineData.filterLifeLevelStrf})
                props.filterLifeLevelColor = Qt.binding(function(){ return MachineData.filterLifeLevelColorStrf})

                props.sensorCalibrated = MachineData.airflowCalibrationStatus

                props.sashMotorizeInstalled = Qt.binding(function(){return MachineData.sashWindowMotorizeInstalled})
                props.sashMotorizeDownInterlocked = Qt.binding(function(){return MachineData.sashWindowMotorizeDownInterlocked || props.sashCycleLockedAlarm})
                props.sashMotorizeUpInterlocked = Qt.binding(function(){return MachineData.sashWindowMotorizeUpInterlocked || props.sashCycleLockedAlarm})
                props.sashMotorizeState = Qt.binding(function(){return MachineData.sashWindowMotorizeState})
                if(props.sashMotorizeInstalled){
                    props.sashCycle = Qt.binding(function(){ return MachineData.sashCycleMeter/10})
                    props.sashCycleLockedAlarm = Qt.binding(function(){return MachineData.sashCycleMotorLockedAlarm === MachineAPI.ALARM_ACTIVE_STATE})
                    props.sashCycleStopCaution = Qt.binding(function(){return ((MachineData.sashCycleMeter/10) > 15500) && props.sashMotorizeState})
                    props.sashCycleReplaceCaution = Qt.binding(function(){return ((MachineData.sashCycleMeter/10) > 15000) && props.sashMotorizeState})
                }//

                ///PARTICLE COUNTER
                props.particleCounterSensorInstalled = Qt.binding(function(){return MachineData.particleCounterSensorInstalled})
                props.particleCounterPM2_5 = Qt.binding(function(){return MachineData.particleCounterPM2_5})
                props.particleCounterPM1_0 = Qt.binding(function(){return MachineData.particleCounterPM1_0})
                props.particleCounterPM10 = Qt.binding(function(){return MachineData.particleCounterPM10})

                props.seasInstalled = MachineData.seasInstalled
                if(props.seasInstalled){
                    props.seasPressureStr = Qt.binding(function(){ return MachineData.seasPressureDiffStr })
                    props.alarmSeasTooPositive = Qt.binding(function(){ return MachineData.seasAlarmPressureLow === MachineAPI.ALARM_ACTIVE_STATE })
                }//

                props.seasFlapInstalled = MachineData.seasFlapInstalled
                if(props.seasFlapInstalled){
                    //                    props.seasPressureStr = Qt.binding(function(){ return MachineData.seasPressureDiffStr })
                    props.alarmSeasFlapTooPositive = Qt.binding(function(){ return MachineData.seasFlapAlarmPressure === MachineAPI.ALARM_ACTIVE_STATE })
                }

                props.warmingUpActive = Qt.binding(function(){ return MachineData.warmingUpActive });
                props.warmingUpCountdown = Qt.binding(function(){ return MachineData.warmingUpCountdown });

                props.uvTimeCountDown = Qt.binding(function(){ return MachineData.uvTimeCountdown });
                props.uvLifePercent = Qt.binding( function(){ return MachineData.uvLifePercent });
                props.uvLifeLeftStrf = Qt.binding( function(){ return utils.strfMinToHumanReadableShort(MachineData.uvLifeMinutes)});
                props.uvLifeLevelColor = Qt.binding(function(){return MachineData.uvLifeLevelColorStrf});

                props.postPurgeActive = Qt.binding(function(){ return MachineData.postPurgingActive });
                props.postPurgeCountdown = Qt.binding(function(){ return MachineData.postPurgingCountdown });

                props.tempAmbientStatus = Qt.binding(function(){ return MachineData.tempAmbientStatus})
                props.tempAmbientLowStrf = Qt.binding(function(){ return "%1°%2".arg(MachineData.envTempLowestLimit).arg(MachineData.measurementUnit ? "F" : "C")})
                props.tempAmbientHighStrf = Qt.binding(function(){ return "%1°%2".arg(MachineData.envTempHighestLimit).arg(MachineData.measurementUnit ? "F" : "C")})

                props.modeIsMaintenance = Qt.binding(function(){ return MachineData.operationMode === MachineAPI.MODE_OPERATION_MAINTENANCE })

                props.filterLifeReminder = Qt.binding(function() { return MachineData.filterLifeReminder })
                props.uvLifeReminder = Qt.binding(function() { return MachineData.uvReplacementReminder })
                props.datalogIsFull = Qt.binding(function() { return MachineData.dataLogIsFull })
                props.eventlogIsFull = Qt.binding(function() { return MachineData.eventLogIsFull })
                props.alarmlogIsFull = Qt.binding(function() { return MachineData.alarmLogIsFull })
                props.replaceableCompRecordIsFull = Qt.binding(function() { return MachineData.replaceableCompRecordIsFull })
                props.resmonlogIsFull = Qt.binding(function() { return MachineData.resourceMonitorLogIsFull })

                /// certificatio reminder
                props.certfRemExpiredDate = Qt.binding(function() { return MachineData.dateCertificationReminder })
                props.certfRemExpiredValid = Qt.binding(function() { return MachineData.certificationExpiredValid })
                props.certfRemExpiredDue = Qt.binding(function() { return MachineData.certificationExpired })


                //                console.log("nilai certif " + props.certfRemExpired)
                props.certfRemExpiredCount = Qt.binding(function(){ return MachineData.certificationExpiredCount})

                ///
                props.cabinetDisplayName = Qt.binding(function(){ return MachineData.cabinetDisplayName})

                ///
                props.fanPIN = Qt.binding(function() { return MachineData.fanPIN })

                props.airflowMonitorEnable = Qt.binding(function(){return MachineData.airflowMonitorEnable})

                props.alarmPrevMaintActive = Qt.binding(function(){ return MachineData.alarmPreventMaintActive})
                props.alarmPrevMaintActiveCode = Qt.binding(function(){ return MachineData.alarmPreventMaintActiveCode})

                props.airflowFailAfMonDisabled = Qt.binding(function(){
                    let afFailStatus = (props.fanState == MachineAPI.FAN_STATE_ON
                                        && !props.airflowMonitorEnable
                                        && props.airflowCalibrationStatus >= MachineAPI.AF_CALIB_FACTORY
                                        && props.tempAmbientStatus === MachineAPI.TEMP_AMB_NORMAL
                                        && !props.warmingUpActive)

                    const ifaFail = (MachineData.ifaVelocity <= MachineData.getInflowLowLimitVelocity())

                    if(props.advancedAirflowAlarmEnable){
                        const actualDfa = MachineData.dfaVelocity
                        let nominalDfa = MachineData.getDownflowVelocityPointFactory(MachineAPI.POINT_NOMINAL)
                        if(MachineData.airflowCalibrationStatus === MachineAPI.AF_CALIB_FIELD)
                            nominalDfa = MachineData.getDownflowVelocityPointField(MachineAPI.POINT_NOMINAL)
                        let tolerance = 1000
                        if(!MachineData.measurementUnit){
                            tolerance = 5; // Downflow alarm +/- 0.0508 m/s
                        }
                        const tooLowDfa = (nominalDfa - actualDfa) >= tolerance;
                        const tooHighDfa = (actualDfa - nominalDfa) >= tolerance;

                        afFailStatus =  afFailStatus && (ifaFail || tooLowDfa || tooHighDfa)
                    }
                    else{
                        afFailStatus = afFailStatus && ifaFail
                    }

                    return afFailStatus
                })

                props.alarmPrevMaintenanceReminderStr = Qt.binding(function(){
                    let reminderStr = qsTr("Preventive Maintenance Reminder")
                    return reminderStr
                })

                props.alarmSashMotorDownStuck = Qt.binding(function(){ return MachineData.alarmSashMotorDownStuck === MachineAPI.ALARM_ACTIVE_STATE })

                props.bookedScheduleNotifDisplay = Qt.binding(function(){
                    return (MachineData.bookingScheduleNotifEnable && MachineData.bookingScheduleTodayDispNotif)
                })
                props.bookedScheduleForToday = Qt.binding(function(){
                    return MachineData.bookingScheduleTodayVarListToShow
                })
                props.bookedScheduleNotifCollapse = Qt.binding(function(){return MachineData.bookingScheduleNotifCollapse})

                //////
                props.airflowOutTempEnable = Qt.binding(function(){return MachineData.airflowOutTempEnable})
                props.advancedAirflowAlarmEnable = Qt.binding(function(){return MachineData.advancedAirflowAlarmEnable})
                props.filterLifeDisplayEnabled = Qt.binding(function(){return MachineData.filterLifeDisplayEnabled})

                props.uvLifeMinutes = Qt.binding(function(){return MachineData.uvLifeMinutes})
                props.uvTime = Qt.binding(function(){return MachineData.uvTime})

                props.machineModelName = Qt.binding(function(){return MachineData.machineModelName})

                props.frontEndScreenState = Qt.binding(function(){return MachineData.frontEndScreenState})

                props.installationWizardActive = Qt.binding(function(){return MachineData.installationWizardActive})

                props.postPurgingActive = Qt.binding(function(){return MachineData.postPurgingActive})
                props.postPurgingTime = Qt.binding(function(){return MachineData.postPurgingTime})

                props.operationMode = Qt.binding(function(){return MachineData.operationMode})


                /// show dialog progress when fan state will be switching
                MachineData.fanPrimarySwithingStateTriggered.connect(props.showFanProgressSwitchingState)
                MachineData.postPurgingActiveChanged.connect(props.showNotifToShutDownTheCabinetPostPurge)

                /// Power outage
                props.powerOutage = MachineData.powerOutage

                if(props.powerOutage && MachineData.getSbcCurrentSerialNumberKnown()) {
                    const powerOutageTime = MachineData.powerOutageTime
                    const powerOutageRecoverTime = MachineData.powerOutageRecoverTime

                    //force clear power outage variable
                    //avoid the dialog show again
                    MachineData.powerOutage = 0

                    /// SHOW DIALOG POWER OUTAGE NOTIFICATION
                    var messageFan = "<b>" +  qsTr("Power failure has been detected while previous fan state is on!") + "</b>" + "<br>"
                            +  qsTr("Potential release of contaminants into the room.") + "<br>"
                            +  qsTr("Failure at") + " " + powerOutageTime + "<br>"
                            +  qsTr("Recovered at") + " " + powerOutageRecoverTime + "<br>"

                    var messageUV = "<b>" +  qsTr("Power failure has been detected while previous UV decontamination is in progress!") + "</b>" + "<br>"
                            +  qsTr("Failure at") + " " + powerOutageTime + "<br>"
                            +  qsTr("Recovered at") + " " + powerOutageRecoverTime + "<br>"

                    const powerOutageFanOrUV = MachineData.powerOutageUvState
                    //                        ////console.debug("powerOutageFanOrUV:" + powerOutageFanOrUV)
                    var message = powerOutageFanOrUV ? messageUV : messageFan

                    const autoClosed = false
                    viewApp.showDialogMessage(qsTr("Be Careful!"),
                                              message,
                                              viewApp.dialogAlert,
                                              function ignoreOnClosed(){
                                                  MachineAPI.resetPowerFailureNotification()
                                              },
                                              autoClosed,
                                              "qrc:/UI/Pictures/power-outage-icon.png")
                }//

                if (UserSessionService.loggedIn){
                    props.loginUsername = UserSessionService.username
                    props.loginFullname = UserSessionService.fullname
                }
                else {
                    props.loginUsername = qsTr("Login")
                    props.loginFullname = qsTr("Login")
                }

                MachineAPI.setFrontEndScreenState(MachineAPI.ScreenState_Home)

                //timeDateTimer.restart()

                //MachineAPI.setPropogateComposeEventGesture(true)
            }//

            /// onPause
            Component.onDestruction: {
                //////console.debug("StackView.DeActivating");

                /// THIS PAGE IS INVISIBLE,
                /// TO PREVENT UNWANTED BEHAVIOUR, DISCONNECT THE SIGNAL
                MachineData.fanPrimarySwithingStateTriggered.disconnect(props.showFanProgressSwitchingState)
                MachineData.postPurgingActiveChanged.disconnect(props.showNotifToShutDownTheCabinetPostPurge)

                MachineAPI.setFrontEndScreenState(MachineAPI.ScreenState_Other)
                //                    props.currentPageIsForground = false

                //MachineAPI.setPropogateComposeEventGesture(false)
            }//

            /// PUT ANY DYNAMIC OBJECT MUST A WARE TO PAGE STATUS
            /// ANY OBJECT ON HERE WILL BE DESTROYED WHEN THIS PAGE NOT IN FOREGROUND
        }//
    }//
}//

/*##^##
Designer {
    D{i:0;autoSize:true;formeditorColor:"#c0c0c0";formeditorZoom:1.1;height:600;width:1024}
}
##^##*/
