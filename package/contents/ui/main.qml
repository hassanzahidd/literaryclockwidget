import QtQuick 2.0
import org.kde.plasma.plasmoid 2.0
import org.kde.plasma.core 2.0 as PlasmaCore
import "../backend/fetchQuotes.js" as Quotes
import QtQml 2.2

PlasmoidItem {
    id: root
    preferredRepresentation: fullRepresentation
    Plasmoid.backgroundHints: PlasmaCore.Types.NoBackground
    
    property var locale: Qt.locale()
    property string currentQuoteBeforeTimeString: ""
    property string currentQuoteAfterTimeString: ""
    property string currentAuthor: ""
    property string timeString: ""
    property real textOpacity: 1.0  // Added this property to control opacity
    
    fullRepresentation: Item {
        width: plasmoid.formFactor === PlasmaCore.Types.Vertical ? parent.width : 450
        height: plasmoid.formFactor === PlasmaCore.Types.Horizontal ? parent.height : content.height
        
        Text {
            id: content
            width: parent.width + 200
            anchors.centerIn: parent
            text: {
                if (root.currentQuoteBeforeTimeString || root.currentQuoteAfterTimeString) {
                    return root.currentQuoteBeforeTimeString + 
                           "<b><font size='5' color='#f9f9f9'> " + root.timeString + " </font></b>" + 
                           root.currentQuoteAfterTimeString + 
                           "<br><font size='3' color='#dddddd'><i>" + root.currentAuthor + "</i></font>"
                }
                return "<i>Loading quote...</i>"
            }
            textFormat: Text.StyledText
            color: "white"
            wrapMode: Text.WordWrap
            horizontalAlignment: Text.AlignHCenter
            opacity: root.textOpacity
            font {
                family: "Noto Sans"
                pixelSize: 14
                capitalization: Font.AllUppercase
                letterSpacing: 1.2
                wordSpacing: 5
            }
            
            Behavior on opacity {
                NumberAnimation { duration: 200 }
            }
        }
    }

    function getTimeAndQuote() {
        var now = new Date();
        var hours = now.getHours().toString().padStart(2, '0');
        var minutes = now.getMinutes().toString().padStart(2, '0');
        var time = hours + ":" + minutes;
        
        root.textOpacity = 0 
        
        Quotes.readQuotes(time, function(quoteData) {
            if (quoteData.length >= 5) {
                root.timeString = quoteData[1];
                var quoteSplitTimeString = quoteData[2].split(root.timeString);
                root.currentAuthor = quoteData[4];
                root.currentQuoteBeforeTimeString = quoteSplitTimeString[0].trim();
                root.currentQuoteAfterTimeString = quoteSplitTimeString[1].trim();
                root.currentAuthor = "- " + root.currentAuthor;
            } else {
                console.log("No quote found for the specified time.");
                root.currentQuoteBeforeTimeString = time;
                root.currentQuoteAfterTimeString = "";
                root.currentAuthor = "";
                root.timeString = time;
            }
            root.textOpacity = 1
        });
    }

    Timer {
        interval: 60000
        running: true
        repeat: true
        onTriggered: root.getTimeAndQuote()
    }

    Component.onCompleted: {
        root.textOpacity = 0
        root.getTimeAndQuote()
    }
}