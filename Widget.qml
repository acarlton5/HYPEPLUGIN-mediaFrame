import QtQuick
import Quickshell
import Quickshell.Io
import qs.Common
import qs.Widgets
import qs.Modules.Plugins

DesktopPluginComponent {
    id: root

    // Size constraints
    minWidth: 150
    minHeight: 100

    // Access saved settings via pluginData
    property string imagePath: String(pluginData.imagePath).replace(/~/g, String(Quickshell.env("HOME"))) ?? ""
    property real backgroundOpacity: (pluginData.backgroundOpacity ?? 50) / 100
    property real frameRadius: pluginData.frameRadius ?? Theme.cornerRadius
    property string imageFillMode: pluginData.fillMode ?? "PreserveAspectFit"
    property real matThickness: pluginData.matThickness ?? 0
    // Border
    property bool enableBorder: pluginData.enableBorder ?? false
    property int borderThickness: pluginData.borderThickness ?? 2
    property real borderOpacity: (pluginData.borderOpacity ?? 100) / 100
    property string borderColor: pluginData.borderColor ?? "primary"
    property color resolvedBorderColor: {
        if (root.borderColor === "primary") {
            return Theme.primary;
        } else if (root.borderColor === "secondary") {
            return Theme.secondary;
        } else if (root.borderColor === "surface") {
            return Theme.surfaceText;
        }
    }
    // Refresh Button
    property string refreshButtonPosition: pluginData.refreshButtonPosition ?? "disabled"
    property real refreshButtonSize: pluginData.refreshButtonSize ?? 48
    property real refreshButtonOffset: pluginData.refreshButtonOffset ?? 8
    property real refreshButtonOpacity: (pluginData.refreshButtonOpacity ?? 80) / 100
    property real refreshButtonRadius: pluginData.refreshButtonRadius ?? Theme.cornerRadius
    property string refreshAction: pluginData.refreshAction ?? ""
    property real transitionSpeed: pluginData.transitionSpeed ?? 2500
    property string clickAction: pluginData.clickAction ?? ""
    property string customInstanceId: pluginData.customInstanceId ?? instanceId

    property real imageInset: Math.max((enableBorder ? borderThickness : 0) + matThickness, frameRadius)

    Process {
        id: refreshCommand
        command: ["sh", "-c", root.refreshAction]
        environment: ({
                MEDIA_FRAME_IMAGE: root.imagePath
            })
        onExited: imageContainer.swapImage()
    }

    IpcHandler {
        target: "mediaFrame_" + root.customInstanceId

        function reload() {
            imageContainer.swapImage();
        }
        function refresh() {
            refreshCommand.running = true;
        }
        function getImagePath(): string {
            return root.imagePath;
        }
    }

    Rectangle {
        id: background
        anchors.fill: parent
        radius: root.frameRadius
        color: Theme.withAlpha(Theme.surfaceContainer, root.backgroundOpacity)
        border.color: root.enableBorder ? Theme.withAlpha(root.resolvedBorderColor, root.borderOpacity) : "transparent"
        border.width: root.enableBorder ? root.borderThickness : 0

        Item {
            id: imageContainer
            anchors.centerIn: parent
            height: parent.height - (root.imageInset * 2)
            width: parent.width - (root.imageInset * 2)

            states: [
                State {
                    name: "fadeIn"
                    PropertyChanges {
                        image.opacity: 0
                        fadeInImage.opacity: 1
                    }
                },
                State {
                    name: "swapBack"
                    PropertyChanges {
                        image.opacity: 1
                        fadeInImage.opacity: 0
                    }
                }
            ]

            transitions: [
                Transition {
                    to: "fadeIn"
                    NumberAnimation {
                        property: "opacity"
                        easing.type: Easing.InOutQuad
                        duration: root.transitionSpeed
                    }
                    onRunningChanged: {
                        if (!running) {
                            image.source = "";
                            image.source = root.imagePath;
                            imageContainer.state = "swapBack";
                        }
                    }
                }
            ]

            function swapImage() {
                fadeInImage.source = "";
                fadeInImage.source = root.imagePath;
                imageContainer.state = "fadeIn";
            }

            Image {
                id: image
                anchors.fill: parent
                source: root.imagePath
                fillMode: Image[root.imageFillMode]
                cache: false
            }
            Image {
                id: fadeInImage
                anchors.fill: parent
                source: root.imagePath
                fillMode: Image[root.imageFillMode]
                cache: false
                opacity: 0
            }
        }

        DankRipple {
            id: imageRipple
            rippleColor: Theme.surfaceContainer
            cornerRadius: root.refreshButtonRadius
        }

        MouseArea {
            anchors.fill: parent
            onPressed: mouse => {
                imageRipple.trigger(mouse.x, mouse.y);
            }
            onClicked: Quickshell.execDetached({
                command: ["sh", "-c", root.clickAction],
                environment: {
                    MEDIA_FRAME_IMAGE: root.imagePath
                }
            })
        }

        DankButton {
            id: refreshButton
            visible: root.refreshButtonPosition != "disabled"
            color: Theme.withAlpha(Theme.surfaceContainer, root.refreshButtonOpacity)
            textColor: Theme.surfaceText
            height: root.refreshButtonSize
            width: root.refreshButtonSize
            radius: root.refreshButtonRadius
            iconName: "refresh"
            iconSize: root.refreshButtonSize * 0.75
            anchors.margins: root.imageInset + root.refreshButtonOffset

            onClicked: refreshCommand.running = true

            state: root.refreshButtonPosition
            states: [
                State {
                    name: "top-left"
                    AnchorChanges {
                        target: refreshButton
                        anchors.top: parent.top
                        anchors.left: parent.left
                    }
                },
                State {
                    name: "top-right"
                    AnchorChanges {
                        target: refreshButton
                        anchors.top: parent.top
                        anchors.right: parent.right
                    }
                },
                State {
                    name: "bottom-right"
                    AnchorChanges {
                        target: refreshButton
                        anchors.right: parent.right
                        anchors.bottom: parent.bottom
                    }
                },
                State {
                    name: "bottom-left"
                    AnchorChanges {
                        target: refreshButton
                        anchors.bottom: parent.bottom
                        anchors.left: parent.left
                    }
                }
            ]
        }
    }
}
