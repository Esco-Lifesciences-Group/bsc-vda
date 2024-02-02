pragma Singleton
/**
 *  Copyright (C) 2021 by ESCO Bintan Indonesia
 *  https://escoglobal.com
 *
 *  Author: Heri Cahyono
**/

import QtQuick 2.0
import ModulesCpp.Machine 1.0

Item {
    id: control

    readonly property int statusStop:  0
    readonly property int statusPlay:  1
    readonly property int statusPause: 2

    property int status: statusStop

    //property bool timeout: false
    property bool isPaused: status == statusPause
    property bool isRunning: status == statusPlay

    property int count: 0
    property var captureModel: []
    property int captureIndex: 1
    property int lastCapture: 0

    //property int countTotal: 0
    //signal experminetTimerOver(bool status)

    signal captureModelUpdated()

    //    onTimeoutChanged: {
    //        experminetTimerOver(timeout)
    //        if(timeout){
    //            MachineAPI.insertEventLog(qsTr("Experiment timer is up"))
    //        }
    //    }//

    function start(){
        //if(countTotal == 0) return
        //if(status !== statusPause) count = countTotal
        status = statusPlay
        //timeout = false
        MachineAPI.insertEventLog(qsTr("Stopwatch timer started"))
    }

    function pause(){
        status = statusPause
        MachineAPI.insertEventLog(qsTr("Stopwatch timer is paused"))
    }

    function stop(){
        status = statusStop
        count = 0
        lastCapture = 0
        captureModel = []
        captureModelUpdated()
        MachineAPI.insertEventLog(qsTr("Stopwatch timer is stopped"))
    }

    function capture(){
        var elp = count-lastCapture
        if(elp < 0) elp = 0
        captureModel.push({index: captureIndex, elapsed: elp, count: count})
        lastCapture = count
        captureIndex++

        captureModelUpdated()
    }

    Timer {
        id: timer
        running: status == statusPlay
        interval: 1000
        repeat: true
        onTriggered: {
            count = count + 1

            if(count >= 86400){ //23h 59m 59s
                control.stop()
            }
        }//
    }//
}//
