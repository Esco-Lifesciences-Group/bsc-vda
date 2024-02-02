import QtQuick 2.0
import UI.CusCom 1.0

Item {
    id: control

    property alias model: grid.model
    property alias columns: grid.columns

    property alias valueMinimum: grid.valueMinimum
    property alias valueMaximum: grid.valueMaximum

    signal clickedItem(int index, double value, string valueStrf)

    Flickable {
        id: flick
        anchors.centerIn: parent
        height: grid.height > parent.height ? parent.height - 10 : grid.height
        width: grid.width > parent.width ? parent.width - 10 : grid.width
        clip: true
        contentHeight: grid.height
        contentWidth: grid.width

        //                                ScrollBar.vertical: ScrollBar { }
        //                                ScrollBar.horizontal: ScrollBar { }

        AirflowDownflowGridApp {
            id: grid

            Component.onCompleted: {
                grid.clickedItem.connect(control.clickedItem)
            }
        }//
    }//
}
