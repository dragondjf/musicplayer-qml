import QtQuick 2.4
import DMusic 1.0
import "../DMusicWidgets"

Rectangle {
    id: simpleWindow

    property var titleBar: titleBar
    property var playBottomBar: playBottomBar
    property var simpleWindowController: simpleWindowController

    focus: true

    color: "#282F3F"

    BorderImage {
        id: bgImage
        objectName: 'bgImage'

        anchors.fill: simpleWindow
        horizontalTileMode: BorderImage.Stretch
        verticalTileMode: BorderImage.Stretch
    }
    Column{

        TitleBar {
            id: titleBar
            objectName: 'simpletitleBar'

            width: simpleWindow.width
            height: 25
            iconWidth: titleBar.height
            iconHeight: titleBar.height
            color: "transparent"
            windowFlag: false
        }

        Rectangle{
            id: simpleCenterWindow
            objectName: 'simpleCenterWindow'

            width: simpleWindow.width
            height: simpleWindow.height - titleBar.height - playBottomBar.height
            color: "transparent"

            Rectangle {

                id: controlBar

                anchors.left: simpleCenterWindow.left
                anchors.top: simpleCenterWindow.top
                anchors.right: simpleCenterWindow.right

                anchors.leftMargin: 25
                anchors.rightMargin: 25

                width: simpleCenterWindow.width - 50
                height: 30


                color: "transparent"

                DSwitchButton {
                    id: switchButton
                    x: 0
                    y: 0
                    width: controlBar.height
                    height: controlBar.height
                }
            }

            DStackView {
                id: stackViews
                objectName: 'stackViews'

                anchors.topMargin: 45
                anchors.leftMargin: 25
                anchors.rightMargin: 25
                anchors.bottomMargin: 45

                anchors.left: simpleCenterWindow.left
                anchors.top: controlBar.bottom
                anchors.right: simpleCenterWindow.right
                anchors.bottom: simpleCenterWindow.bottom

                width: simpleCenterWindow.width
                height: simpleCenterWindow.height - controlBar.width

                currentIndex: 0

                PlaylistPage {
                    id: playlistPage
                    model: MusicDataBase.test
                    color: "transparent"
                }

                LrcPage {
                    id: lrcPage
                    color: "transparent"
                }
            }

        }

        SimplePlayBar{
            id: playBottomBar
            objectName: 'playBottomBar'

            width: simpleWindow.width
            color: "transparent"
        }
    }

    SimpleWindowController{
        id: simpleWindowController

        simpleWindow: simpleWindow
        bgImage: bgImage
        titleBar: titleBar
        switchButton: switchButton
        stackViews: stackViews
        playlistPage: playlistPage
        lrcPage: lrcPage
        playBottomBar: playBottomBar
    }
}