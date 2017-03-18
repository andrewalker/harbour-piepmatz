import QtQuick 2.0
import QtGraphicalEffects 1.0
import Sailfish.Silica 1.0
import "../pages"
import "../js/functions.js" as Functions

Item {

    property variant accountModel;

    id: profileComponent
    height: profileItemColumn.height
    width: parent.width

    Item {
        id: profileBackgroundItem
        width: parent.width
        height: appWindow.height / 5
        Rectangle {
            id: profileBackgroundColor
            color: "#" + accountModel.profile_link_color
            anchors.fill: parent
        }
    }

    Column {
        id: profilePictureColumn
        width: appWindow.width > appWindow.height ? ( appWindow.height / 3 ) : ( appWindow.width / 3 )
        height: appWindow.width > appWindow.height ? ( appWindow.height / 3 ) : ( appWindow.width / 3 )
        x: Theme.horizontalPageMargin
        anchors {
            verticalCenter: profileBackgroundItem.bottom
        }
        Item {
            id: profilePictureItem
            width: parent.width
            height: parent.height
            Rectangle {
                id: profilePictureBackground
                width: parent.width
                height: parent.height
                color: Theme.primaryColor
                radius: parent.width / 6
                anchors {
                    margins: Theme.horizontalPageMargin
                }
                visible: profilePicture.status === Image.Ready ? true : false
                opacity: profilePicture.status === Image.Ready ? 1 : 0
                Behavior on opacity { NumberAnimation {} }
            }

            Component {
                id: singleImageComponent
                ImagePage {
                    imageUrl: Functions.findHiResImage(accountModel.profile_image_url_https)
                    imageHeight: appWindow.width > appWindow.height ? appWindow.height : appWindow.width
                    imageWidth: appWindow.width > appWindow.height ? appWindow.height : appWindow.width
                }
            }

            Image {
                id: profilePicture
                source: Functions.findHiResImage(accountModel.profile_image_url_https)
                width: parent.width - parent.width / 10
                height: parent.height - parent.height / 10
                anchors.margins: Theme.horizontalPageMargin + parent.width / 60
                anchors.centerIn: profilePictureBackground
                visible: false
            }

            Rectangle {
                id: profilePictureMask
                width: parent.width - parent.width / 10
                height: parent.height - parent.height / 10
                color: Theme.primaryColor
                radius: parent.width / 7
                anchors.margins: Theme.horizontalPageMargin + parent.width / 60
                anchors.centerIn: profilePictureBackground
                visible: false
            }

            OpacityMask {
                id: maskedProfilePicture
                source: profilePicture
                maskSource: profilePictureMask
                anchors.fill: profilePicture
                visible: profilePicture.status === Image.Ready ? true : false
                opacity: profilePicture.status === Image.Ready ? 1 : 0
                Behavior on opacity { NumberAnimation {} }
                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                        pageStack.push( singleImageComponent );
                    }
                }
            }

            ImageProgressIndicator {
                image: profilePicture
                withPercentage: false
            }

        }
    }

    Column {
        id: profileOverviewColumn
        width: appWindow.width > appWindow.height ? ( appWindow.height * 2 / 3 ) : ( appWindow.width * 2 / 3 )
        height: profileNameText.height + profileScreenNameText.height + ( Theme.paddingMedium )
        spacing: Theme.paddingSmall
        anchors {
            top: profileBackgroundItem.bottom
            topMargin: Theme.paddingMedium
            left: profilePictureColumn.right
            leftMargin: Theme.horizontalPageMargin
        }
        Text {
            id: profileNameText
            text: accountModel.name
            font {
                pixelSize: Theme.fontSizeLarge
                bold: true
            }
            color: Theme.primaryColor
            wrapMode: Text.Wrap
        }
        Text {
            id: profileScreenNameText
            text: qsTr("@%1").arg(accountModel.screen_name)
            font {
                pixelSize: Theme.fontSizeSmall
                bold: true
            }
            color: Theme.primaryColor
            wrapMode: Text.Wrap
        }
    }

    Row {
        id: profileFollowingRow
        width: parent.width - ( 2 * Theme.horizontalPageMargin )
        spacing: Theme.paddingMedium
        anchors {
            horizontalCenter: parent.horizontalCenter
            top: profileOverviewColumn.bottom
            topMargin: Theme.paddingMedium
        }
        Text {
            id: profileFriendsText
            text: qsTr("%1 Following").arg(accountModel.friends_count)
            font.pixelSize: Theme.fontSizeExtraSmall
            color: Theme.primaryColor
            wrapMode: Text.Wrap
        }
        Text {
            id: profileFollowingSeparatorText
            text: "|"
            font.pixelSize: Theme.fontSizeExtraSmall
            color: Theme.primaryColor
        }
        Text {
            id: profileFollowersText
            text: qsTr("%1 Followers").arg(accountModel.followers_count)
            font.pixelSize: Theme.fontSizeExtraSmall
            color: Theme.primaryColor
            wrapMode: Text.Wrap
        }
    }

    Row {
        id: profileActivityRow
        width: parent.width - ( 2 * Theme.horizontalPageMargin )
        spacing: Theme.paddingMedium
        anchors {
            horizontalCenter: parent.horizontalCenter
            top: profileFollowingRow.bottom
            topMargin: Theme.paddingMedium
        }
        Text {
            id: profileTweetsText
            text: qsTr("%1 Tweets").arg(accountModel.statuses_count)
            font.pixelSize: Theme.fontSizeExtraSmall
            color: Theme.primaryColor
        }
        Text {
            id: profileActivitySeparatorText
            text: "|"
            font.pixelSize: Theme.fontSizeExtraSmall
            color: Theme.primaryColor
        }
        Text {
            id: profileJoinedText
            text: qsTr("Joined in %1").arg(Functions.getValidDate(accountModel.created_at).toLocaleDateString(Qt.locale(), "MMMM yyyy"))
            font.pixelSize: Theme.fontSizeExtraSmall
            color: Theme.primaryColor
            wrapMode: Text.Wrap
        }
    }


    Column {
        id: profileItemColumn
        width: parent.width
        spacing: Theme.paddingMedium

        anchors {
            top: profileActivityRow.bottom
            topMargin: Theme.paddingMedium
        }

        Row {
            id: profileDetailsRow
            spacing: Theme.paddingMedium
            width: parent.width - ( 2 * Theme.horizontalPageMargin )
            anchors {
                horizontalCenter: parent.horizontalCenter
            }

            Text {
                id: profileDescriptionText
                text: accountModel.description
                font.pixelSize: Theme.fontSizeExtraSmall
                color: Theme.primaryColor
                wrapMode: Text.Wrap
                width: parent.width
            }
        }


        Row {
            id: profileLocationRow
            spacing: Theme.paddingMedium
            width: parent.width - ( 2 * Theme.horizontalPageMargin )
            anchors {
                horizontalCenter: parent.horizontalCenter
            }
            Row {
                visible: accountModel.location.length === 0 ? false : true
                Image {
                    id: profileLocationImage
                    source: "image://theme/icon-m-location"
                    width: Theme.fontSizeSmall
                    height: Theme.fontSizeSmall
                }
                Text {
                    id: profileLocationText
                    text: accountModel.location
                    font.pixelSize: Theme.fontSizeExtraSmall
                    color: Theme.primaryColor
                    wrapMode: Text.Wrap
                    anchors.verticalCenter: parent.verticalCenter
                }
            }
            Row {
                visible: accountModel.entities.url.urls.length === 0 ? false : true
                Image {
                    id: profileUrlImage
                    source: "image://theme/icon-m-link"
                    width: Theme.fontSizeSmall
                    height: Theme.fontSizeSmall
                }
                Text {
                    id: profileUrlText
                    text: "<a href=\"" + accountModel.entities.url.urls[0].url + "\">" + accountModel.entities.url.urls[0].display_url + "</a>"
                    font.pixelSize: Theme.fontSizeExtraSmall
                    color: Theme.primaryColor
                    wrapMode: Text.Wrap
                    anchors.verticalCenter: parent.verticalCenter
                    onLinkActivated: Qt.openUrlExternally(accountModel.entities.url.urls[0].url)
                    linkColor: Theme.highlightColor
                }
            }
        }

    }

}
