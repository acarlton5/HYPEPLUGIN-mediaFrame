import QtQuick
import Quickshell
import qs.Common
import qs.Services
import qs.Modules.Plugins
import qs.Widgets
import qs.Modals.FileBrowser

PluginSettings {
    id: root
    pluginId: "mediaFrame"

    property bool enableBorder: root.loadValue("enableBorder", false)
    property bool enableRefreshButton: root.loadValue("refreshButtonPosition", "disabled") != "disabled"
    property string imagePath: root.loadValue("imagePath", "")
    property string imageFillMode: root.loadValue("imageFillMode", "PreserveAspectFit")
    property string instanceId: root.loadValue("instanceId")
    property string ipcName: "mediaFrame_" + root.loadValue("customInstanceId", instanceId)

    // Loader for the file browser
    LazyLoader {
        id: imageBrowserLoader
        active: false

        FileBrowserModal {
            browserTitle: I18n.tr("Select picture")
            browserIcon: "image"
            fileExtensions: ["*.jpg", "*.jpeg", "*.png", "*.bmp", "*.webp"]
            onFileSelected: path => {
                root.saveValue("imagePath", path);
                close();
            }
        }
    }

    // Image Settings
    StyledText {
        text: I18n.tr("Image Settings")
        font.pixelSize: Theme.fontSizeLarge
        font.weight: Font.Medium
        color: Theme.surfaceText
    }

    DankButton {
        text: I18n.tr("Select image")
        iconName: "image"
        width: parent.width
        onClicked: {
            imageBrowserLoader.active = true;
            if (imageBrowserLoader.item) {
                imageBrowserLoader.item.open();
            }
        }
    }
    StyledText {
        text: I18n.tr("Current image: ") + String(root.imagePath)
        font.pixelSize: Theme.fontSizeSmall
        color: Theme.surfaceVariantText
        wrapMode: Text.WrapAnywhere
    }

    SelectionSetting {
        settingKey: "fillMode"
        label: I18n.tr("Fill mode")
        description: I18n.tr("Fill mode used for the image")
        options: [
            {
                label: I18n.tr("Stretch"),
                value: "Stretch"
            },
            {
                label: I18n.tr("(Fit) Aspect Ratio"),
                value: "PreserveAspectFit"
            },
            {
                label: I18n.tr("(Crop) Aspect Ratio"),
                value: "PreserveAspectCrop"
            },
            {
                label: I18n.tr("Tile"),
                value: "Tile"
            },
            {
                label: I18n.tr("Tile Vertically"),
                value: "TileVertically"
            },
            {
                label: I18n.tr("Tile Horizontally"),
                value: "TileHorizontally"
            },
            {
                label: I18n.tr("No transform"),
                value: "Pad"
            }
        ]
        defaultValue: "PreserveAspectFit"
    }

    // Appearence Settings
    StyledText {
        text: I18n.tr("Appearance Settings")
        font.pixelSize: Theme.fontSizeLarge
        font.weight: Font.Medium
        color: Theme.surfaceText
    }

    SliderSetting {
        settingKey: "backgroundOpacity"
        label: I18n.tr("Background Opacity")
        defaultValue: 50
        minimum: 0
        maximum: 100
        unit: "%"
    }

    StringSetting {
        settingKey: "matThickness"
        label: I18n.tr("Mat Thickness (px)")
        description: "How much to inlay the image"
        placeholder: "0"
        defaultValue: "0"
    }

    ToggleSetting {
        settingKey: "enableBorder"
        label: I18n.tr("Border")
        defaultValue: root.enableBorder
    }

    SelectionSetting {
        enabled: root.enableBorder
        opacity: root.enableBorder ? 1.0 : 0.2
        settingKey: "borderColor"
        label: I18n.tr("Border Color")
        description: I18n.tr("")
        options: [
            {
                label: I18n.tr("Primary"),
                value: "primary"
            },
            {
                label: I18n.tr("Secondary"),
                value: "secondary"
            },
            {
                label: I18n.tr("Surface"),
                value: "surface"
            },
        ]
        defaultValue: "primary"
    }

    SliderSetting {
        enabled: root.enableBorder
        opacity: root.enableBorder ? 1.0 : 0.2
        settingKey: "borderOpacity"
        label: I18n.tr("Border Opacity")
        defaultValue: 100
        minimum: 0
        maximum: 100
        unit: "%"
    }

    SliderSetting {
        enabled: root.enableBorder
        opacity: root.enableBorder ? 1.0 : 0.2
        settingKey: "borderThickness"
        label: I18n.tr("Border Thickness")
        defaultValue: 2
        minimum: 1
        maximum: 10
        unit: "px"
    }

    StringSetting {
        settingKey: "frameRadius"
        label: I18n.tr("Border Corner Radius")
        description: "Will also inset the image by at least the same amount to prevent clipping"
        placeholder: Theme.cornerRadius
        defaultValue: Theme.cornerRadius
    }

    // Refresh Button
    StyledText {
        text: I18n.tr("Refresh Button")
        font.pixelSize: Theme.fontSizeLarge
        font.weight: Font.Medium
        color: Theme.surfaceText
    }
    SelectionSetting {
        settingKey: "refreshButtonPosition"
        label: I18n.tr("Position")
        description: I18n.tr("")
        options: [
            {
                label: I18n.tr("Disabled"),
                value: "disabled"
            },
            {
                label: I18n.tr("Top Left"),
                value: "top-left"
            },
            {
                label: I18n.tr("Top Right"),
                value: "top-right"
            },
            {
                label: I18n.tr("Bottom Left"),
                value: "bottom-left"
            },
            {
                label: I18n.tr("Bottom Right"),
                value: "bottom-right"
            },
        ]
        defaultValue: "disabled"
    }
    StringSetting {
        enabled: root.enableRefreshButton
        opacity: root.enableRefreshButton ? 1.0 : 0.2
        settingKey: "refreshButtonSize"
        label: I18n.tr("Refresh Button Size (px)")
        description: ""
        placeholder: "48"
        defaultValue: "48"
    }
    StringSetting {
        enabled: root.enableRefreshButton
        opacity: root.enableRefreshButton ? 1.0 : 0.2
        settingKey: "refreshButtonOffset"
        label: I18n.tr("Refresh Button Offset (px)")
        description: "Relative to mat thickness"
        placeholder: "8"
        defaultValue: "8"
    }
    SliderSetting {
        enabled: root.enableRefreshButton
        opacity: root.enableRefreshButton ? 1.0 : 0.2
        settingKey: "refreshButtonOpacity"
        label: I18n.tr("Refresh Button Opacity")
        defaultValue: 80
        minimum: 0
        maximum: 100
        unit: "%"
    }
    StringSetting {
        enabled: root.enableRefreshButton
        opacity: root.enableRefreshButton ? 1.0 : 0.2
        settingKey: "refreshButtonRadius"
        label: I18n.tr("Refresh Button Corner Radius")
        description: ""
        placeholder: Theme.cornerRadius
        defaultValue: Theme.cornerRadius
    }
    StringSetting {
        settingKey: "refreshAction"
        label: "Refresh Action"
        description: I18n.tr("Shell command to run when the refresh button is clicked")
        placeholder: "refresh.sh ..."
        defaultValue: ""
    }

    StringSetting {
        settingKey: "transitionSpeed"
        label: "Transition Speed (ms)"
        description: I18n.tr("Transition speed when refreshing the image")
        placeholder: "2500"
        defaultValue: "2500"
    }

    // Click Action
    StyledText {
        text: I18n.tr("Click Action")
        font.pixelSize: Theme.fontSizeLarge
        font.weight: Font.Medium
        color: Theme.surfaceText
    }
    StringSetting {
        settingKey: "clickAction"
        label: ""
        description: I18n.tr("Shell command to run when the image is clicked")
        placeholder: "xdg-open $MEDIA_FRAME_IMAGE"
        defaultValue: "xdg-open $MEDIA_FRAME_IMAGE"
    }

    // Instance ID
    StyledText {
        text: I18n.tr("Custom Instance ID")
        font.pixelSize: Theme.fontSizeLarge
        font.weight: Font.Medium
        color: Theme.surfaceText
    }
    StringSetting {
        settingKey: "customInstanceId"
        label: ""
        description: I18n.tr("Use a custom IPC name, must be unique to each instance of Media Frame")
        placeholder: root.instanceId
        defaultValue: root.instanceId
    }
    Rectangle {
        width: parent.width
        height: ipcNameText.height + Theme.spacingS * 2
        radius: Theme.cornerRadius / 2
        color: Theme.surfaceHover

        Row {
            x: Theme.spacingS
            anchors.verticalCenter: parent.verticalCenter
            spacing: Theme.spacingS
            width: parent.width - Theme.spacingS * 2

            StyledText {
                id: ipcNameText
                text: "IPC Name: " + root.ipcName
                font.pixelSize: Theme.fontSizeSmall
                font.weight: Font.Light
                color: Theme.surfaceText
                width: parent.width - ipcNameCopyButton.width - Theme.spacingS
                elide: Text.ElideMiddle
                anchors.verticalCenter: parent.verticalCenter
            }

            DankButton {
                id: ipcNameCopyButton
                iconName: "content_copy"
                backgroundColor: "transparent"
                textColor: Theme.surfaceText
                buttonHeight: 28
                horizontalPadding: 4
                anchors.verticalCenter: parent.verticalCenter
                onClicked: {
                    Quickshell.execDetached(["dms", "cl", "copy", root.ipcName]);
                    ToastService.showInfo(I18n.tr("Copied to clipboard"));
                }
            }
        }
    }
}
