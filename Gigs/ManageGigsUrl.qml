import QtQuick 2.4
import Ubuntu.Components 1.3
import Ubuntu.Components.Popups 1.3
import Ubuntu.Components.Pickers 1.3
import Ubuntu.Layouts 1.0

/* replace the 'incomplete' QML API U1db with the low-level QtQuick API */
import QtQuick.LocalStorage 2.0
import Ubuntu.Components.ListItems 1.3 as ListItem

import "Storage.js" as Storage
import "Utility.js" as Utility


Column{
    id: appConfigurationTablet

    anchors.fill: parent
    spacing: units.gu(3.5)
    anchors.leftMargin: units.gu(2)

    Component{
       id: invalidInputDialog
       OperationResult{msg:i18n.tr("FAILURE: Invalid input (check the Url)")}
    }

    Component{
       id: operationSuccessDialog
       OperationResult{msg:i18n.tr("SUCCESS: Operation executed")}
    }

    /* transparent placeholder: required to place the content under the header */
    Rectangle {
        color: "transparent"
        width: parent.width
        height: units.gu(6)
    }

    Row{
        id: headerCurrencyRow
        Label{
           text: "<b>"+i18n.tr("Add to favourites a new Gigs url")+"</b>"
        }
    }

    Row{
        id: jenkinsUrlRow
        spacing: units.gu(2)

        Label {
            id: artistNameLabel
            anchors.verticalCenter: artistNameText.verticalCenter
            text: "* "+i18n.tr("Artist Name:")
        }

        TextField {
            id: artistNameText
            placeholderText: ""
            echoMode: TextInput.Normal
            readOnly: false
            width: units.gu(28)
        }
    }

    Row{
        spacing: units.gu(4)
        Label {
            id: gigsUrlLabel
            anchors.verticalCenter: gigsUrlText.verticalCenter
            text: "* "+i18n.tr("Gigs URL:")
        }

        TextField {
            id: gigsUrlText
            placeholderText: ""
            echoMode: TextInput.Normal
            readOnly: false
            width: units.gu(28)
        }
    }

    Row{
        Label {
           id: fieldRequiredLabel
           text: "* "+i18n.tr("Field required") +i18n.tr("Don't use https in the urls")
        }
    }

    Row{
        Label {
            id: infoLabel
            text: i18n.tr("Note: url format must be like")+"<br/>"+"http(s)://gigs.gigatools.com/u/<artistName>.json"+"<br/>"+"<br/>"+i18n.tr("See application help page for more information")
        }
    }

    Row{
        spacing: units.gu(1)
        anchors.horizontalCenter: parent.horizontalCenter
        Button{
            id: insertNewJenkinsUrlButton
            width: units.gu(15)
            text: i18n.tr("Save")
            onClicked: {
                if(gigsUrlText.text.length > 0 && artistNameText.text.length > 0 && Utility.isGigsUlrValid(gigsUrlText.text) && Utility.endsWithJson(gigsUrlText.text) )
                {
                  Storage.insertNewGigsUrl(artistNameText.text,gigsUrlText.text)

                  gigsUrlText.text = "";
                  artistNameText.text = "";

                  Storage.loadAllSavedGigsUrl(); //refresh url chooser

                  PopupUtils.open(operationSuccessDialog);

                } else {
                   PopupUtils.open(invalidInputDialog);
                }
            }
        }

        Button{
            id: showSavedJenkinsUrlButton
            width: units.gu(15)
            text: i18n.tr("Manage saved")
            onClicked: {
               Storage.loadAllSavedGigsUrl();

               pageStack.push(editSavedGigsUrlPage);
            }
        }
   }

}
