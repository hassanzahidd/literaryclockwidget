import QtQuick 2.0
import org.kde.plasma.plasmoid 2.0
import org.kde.plasma.components 3.0 as PlasmaComponents
import org.kde.plasma.core 2.0 as PlasmaCore
import "../backend/fetchQuotes.js" as Quotes
import QtQml 2.2
PlasmoidItem {
    id: root
    preferredRepresentation: fullRepresentation
    Plasmoid.backgroundHints: PlasmaCore.Types.NoBackground
    property var locale : Qt.locale();
    // Properties to store the quote data
    property string currentQuote: ""
    property string currentAuthor: ""

    fullRepresentation: Item {
        width: 100
        height: 50

        Rectangle {
            anchors.fill: parent
            color: "transparent"

            Column {
                anchors.centerIn: parent
                
                PlasmaComponents.Label {
                    id: quoteLabel
                    text: root.currentQuote
                    color: "white"
                    wrapMode: Text.WordWrap
                    horizontalAlignment: Text.AlignHLeft
                    width: 250
                     font {
                        family: "Noto Sans"
                        pixelSize: 14
                        bold: true
                        italic: false
                        underline: false
                        strikeout: false
                        capitalization: Font.AllUppercase
                        letterSpacing: 1.2
                        wordSpacing: 5
                    }                
                }

                PlasmaComponents.Label {
                    id: authorLabel
                    text: root.currentAuthor
                    color: "white"
                    horizontalAlignment: Text.AlignHCenter
                }
            }
        }
    }

    function getTimeAndQuote() {
        var now = new Date();
        var hours = now.getHours().toString().padStart(2, '0');
        var minutes = now.getMinutes().toString().padStart(2, '0');
        var time = hours + ":" + minutes;

        // TODO: if the quote is not availble for the current time, fetch a quote for the previous available time
        Quotes.readQuotes(time, function(quoteData) {
            if (quoteData.length >= 5) {
                root.currentAuthor = quoteData[4];
                root.currentQuote = quoteData[2];
                root.currentAuthor = "- " + root.currentAuthor;
            } else {
                console.log("No quote found for the specified time.");
                root.currentQuote = time;
                root.currentAuthor = "";
            }

           
        });
    }

    Timer {
        interval: 60000;
        running: true
        repeat: true
        onTriggered: root.getTimeAndQuote()
    }

    Component.onCompleted: root.getTimeAndQuote()
}