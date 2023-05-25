import QtQuick 2.7
import QtQuick.Window 2.11
import QtQuick.Controls 2.0
import QtQuick.Layouts 1.0
import QtQuick.Dialogs 1.3
import QtQml 2.11
import CouchManager 1.0

Window {
    id: root
    visible: true
    width: 1024
    height: 720
    title: qsTr("CouchDb")

    Item {
        id: defaultSettings
        readonly property real defaultWidth: 200
        readonly property real defaultHeight: 100
    }

    CouchManagerBackend {
        id: managerBackend

        onSuccessRequest: {
            messageDialog.messageText = "Успешно!"
            messageDialog.open()
        }

        onUserAlreadyCreated: {
            messageDialog.messageText = "Данный пользователь уже существует"
            messageDialog.open()
            signTabBar.currentIndex = 0
            signInTabButton.clicked()
        }

        onForbiddenChars: {
            messageDialog.messageText = "Запрещенные символы в пароле или логине"
            messageDialog.open()
        }
    }

    Dialog {
        id: messageDialog
        width: defaultSettings.defaultWidth
        height: defaultSettings.defaultHeight
        standardButtons: Dialog.Ok
        property alias messageText: messageText.text

        Label {
            id: messageText
        }
    }

    ColumnLayout {
        anchors.fill: parent

        Item {
            Layout.fillHeight: true
        }

        TabBar {
            id: signTabBar
            Layout.alignment: Qt.AlignCenter
            implicitWidth: defaultSettings.defaultWidth
            currentIndex: 1

            TabButton {
                id: signInTabButton
                text: "Sign In"
                onClicked: if (mainStackView.depth === 1) mainStackView.push(signInPage)
            }

            TabButton {
                id: signUpTabButton
                text: "Sign Up"
                onClicked: mainStackView.pop()
            }
        }

        StackView {
            id: mainStackView
            initialItem: signUpPage
            Layout.fillWidth: true
            height: defaultSettings.defaultHeight
        }

        Item {
            Layout.fillHeight: true
        }
    }

    Component {
        id: signUpPage

        ColumnLayout {
             Layout.alignment: Qt.AlignCenter

            TextField {
                id: loginTextField
                placeholderText: "Login"
                Layout.alignment: Qt.AlignCenter
                implicitWidth: defaultSettings.defaultWidth
            }

            TextField {
                id: passwordTextField
                placeholderText: "Password"
                Layout.alignment: Qt.AlignCenter
                implicitWidth: defaultSettings.defaultWidth
            }

            TextField {
                id: repeatPasswordTextField
                placeholderText: "Repeat password"
                Layout.alignment: Qt.AlignCenter
                implicitWidth: defaultSettings.defaultWidth
            }

            Button {
                id: signUpButton
                text: "Sign Up"
                Layout.alignment: Qt.AlignCenter
                implicitWidth: defaultSettings.defaultWidth
                onClicked: managerBackend.createUser(loginTextField.text, passwordTextField.text)
            }
        }
    }

    Component {
        id: signInPage

        ColumnLayout {
             Layout.alignment: Qt.AlignCenter

            TextField {
                id: loginTextField
                placeholderText: "Login"
                Layout.alignment: Qt.AlignCenter
                implicitWidth: defaultSettings.defaultWidth
            }

            TextField {
                id: passwordTextField
                placeholderText: "Password"
                Layout.alignment: Qt.AlignCenter
                implicitWidth: defaultSettings.defaultWidth
            }

            Button {
                id: signUpButton
                text: "Sign In"
                Layout.alignment: Qt.AlignCenter
                implicitWidth: defaultSettings.defaultWidth
                onClicked: managerBackend.loginUser(loginTextField.text, passwordTextField.text)
            }
        }
    }
}
