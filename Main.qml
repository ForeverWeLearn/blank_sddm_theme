import Qt5Compat.GraphicalEffects
import QtQuick 2.15
import QtQuick.Controls 2.0
import SddmComponents 2.0

Rectangle {
    id: root

    readonly property color textColor: config.stringValue("basicTextColor")
    property int currentUsersIndex: userModel.lastIndex
    property int currentSessionsIndex: sessionModel.lastIndex
    property int usernameRole: Qt.UserRole + 1
    property int realNameRole: Qt.UserRole + 2
    property int sessionNameRole: Qt.UserRole + 4
    property string currentUsername: config.boolValue("showUserRealNameByDefault") ? userModel.data(userModel.index(currentUsersIndex, 0), realNameRole) : userModel.data(userModel.index(currentUsersIndex, 0), usernameRole)
    property string currentSession: sessionModel.data(sessionModel.index(currentSessionsIndex, 0), sessionNameRole)
    property string passwordFontSize: config.intValue("passwordFontSize") || 96
    property string usersFontSize: config.intValue("usersFontSize") || 48
    property string sessionsFontSize: config.intValue("sessionsFontSize") || 24
    property string defaultFont: config.stringValue("font") || "monospace"

    function usersCycleSelectNext() {
        if (currentUsersIndex >= userModel.count - 1)
            currentUsersIndex = 0;
        else
            currentUsersIndex++;
    }

    function sessionsCycleSelectNext() {
        if (currentSessionsIndex >= sessionModel.rowCount() - 1)
            currentSessionsIndex = 0;
        else
            currentSessionsIndex++;
    }

    width: 640
    height: 480

    Connections {
        function onLoginFailed() {
            passwordInput.clear();
        }

        target: sddm
    }

    Item {
        id: mainFrame

        property variant geometry: screenModel.geometry(screenModel.primary)

        x: geometry.x
        y: geometry.y
        width: geometry.width
        height: geometry.height
        Component.onCompleted: {
            passwordInput.forceActiveFocus();
        }

        Shortcut {
            sequences: ["Alt+U", "F2"]
            onActivated: {
                if (!username.visible) {
                    username.visible = true;
                    if (!sessionName.visible)
                        sessionName.visible = true;

                    return ;
                }
                usersCycleSelectNext();
            }
        }

        Shortcut {
            sequences: ["Alt+S", "F3"]
            onActivated: {
                if (!username.visible) {
                    username.visible = true;
                    if (!sessionName.visible)
                        sessionName.visible = true;

                    return ;
                }
                sessionsCycleSelectNext();
            }
        }

        Shortcut {
            sequence: "F10"
            onActivated: {
                if (sddm.canSuspend)
                    sddm.suspend();

            }
        }

        Shortcut {
            sequence: "F11"
            onActivated: {
                if (sddm.canPowerOff)
                    sddm.powerOff();

            }
        }

        Shortcut {
            sequence: "F12"
            onActivated: {
                if (sddm.canReboot)
                    sddm.reboot();

            }
        }

        Rectangle {
            id: background

            visible: true
            anchors.fill: parent
            color: config.stringValue("backgroundFill") || "transparent"
        }

        TextInput {
            id: passwordInput

            width: parent.width * (config.realValue("passwordInputWidth") || 0.5)
            height: 200 / 96 * passwordFontSize
            font.pointSize: passwordFontSize
            font.bold: true
            font.letterSpacing: 20 / 96 * passwordFontSize
            font.family: defaultFont
            echoMode: config.boolValue("passwordMask") ? TextInput.Password : null
            color: config.stringValue("passwordTextColor") || textColor
            selectionColor: textColor
            selectedTextColor: "#000000"
            clip: true
            horizontalAlignment: TextInput.AlignHCenter
            verticalAlignment: TextInput.AlignVCenter
            leftPadding: font.letterSpacing
            passwordCharacter: config.stringValue("passwordCharacter") || "*"
            cursorVisible: false
            onAccepted: {
                if (text != "" || config.boolValue("passwordAllowEmpty"))
                    sddm.login(userModel.data(userModel.index(currentUsersIndex, 0), usernameRole) || "123test", text, currentSessionsIndex);

            }

            anchors {
                verticalCenter: parent.verticalCenter
                horizontalCenter: parent.horizontalCenter
            }

        }

        UsersChoose {
            id: username

            text: currentUsername
            visible: config.boolValue("showUsersByDefault")
            width: mainFrame.width / 5 / 36 * usersFontSize

            anchors {
                horizontalCenter: parent.horizontalCenter
                top: parent.verticalCenter
                topMargin: usersFontSize
            }

        }

        SessionsChoose {
            id: sessionName

            text: currentSession
            visible: config.boolValue("showSessionsByDefault")
            width: mainFrame.width / 5 / 36 * sessionsFontSize

            anchors {
                horizontalCenter: parent.horizontalCenter
                bottom: parent.verticalCenter
                bottomMargin: sessionsFontSize * 1.2
            }

        }

    }

    Loader {
        active: config.boolValue("hideCursor") || false
        anchors.fill: parent

        sourceComponent: MouseArea {
            enabled: false
            cursorShape: Qt.BlankCursor
        }

    }

}
