import QtQuick 2.12

Item {
    id: tapIndicatorItem

    property int duration: 100
    property int delayHide: 50
    property int delayHideTime: duration + delayHide
    property bool indicatorVisible: false
    property bool indicatorVisibleInterlocked: false

    signal pressed()

    Rectangle {
        id: indicateRectangle
        height: 70
        width: 70
        radius: 35
        visible: tapIndicatorItem.indicatorVisible
                 && !tapIndicatorItem.indicatorVisibleInterlocked
        opacity: visible
        color: "#70dddddd"

        Behavior on opacity {
            PropertyAnimation {
                target:indicateRectangle;
                duration: tapIndicatorItem.duration;
                property: "scale";
                from: 0.9;
                to: 1.0
                //                onStopped: ////console.debug("hello")
            }
        }

        Timer {
            id: indicatorAutoHideTimer
            running: false
            interval: tapIndicatorItem.delayHideTime
            onTriggered: {
                tapIndicatorItem.indicatorVisible = false
                indicatorAutoHideTimer.stop()
            }
        }
    }

    //    TapHandler {
    //        id: tapHandler
    //        onPressedChanged: {
    //            if(pressed) {
    //                tapIndicatorItem.indicatorVisible = false
    //                indicateRectangle.x = tapHandler.point.position.x - (indicateRectangle.width / 2)
    //                indicateRectangle.y = tapHandler.point.position.y - (indicateRectangle.height / 2)
    //                tapIndicatorItem.indicatorVisible = true
    //                indicatorAutoHideTimer.restart()

    //                tapIndicatorItem.pressed()
    //            }//
    //        }//

    //        //        onTapped: {
    //        //            ////console.debug("tapped", eventPoint.event.device.name,
    //        //                        "button", eventPoint.event.button,
    //        //                        "@", eventPoint.scenePosition)
    //        //        }//
    //    }

    MouseArea {
        id: mouseArea
        anchors.fill: parent
        propagateComposedEvents: true
        onPressed: {
            tapIndicatorItem.indicatorVisible = false
            indicateRectangle.x = mouseArea.mouseX - (indicateRectangle.width / 2)
            indicateRectangle.y = mouseArea.mouseY - (indicateRectangle.height / 2)
            tapIndicatorItem.indicatorVisible = true
            indicatorAutoHideTimer.restart()

            tapIndicatorItem.pressed()

            mouse.accepted = false
        }
    }
}
