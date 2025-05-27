let foundQuote = false;

function readQuotes(currentTime, callback) {
    findQuotesRecursive(currentTime, callback);
}

function findQuotesRecursive(currentTime, callback) {
    var request = new XMLHttpRequest();
    request.open("GET", "quotes.csv", true);
    request.onload = function() {
        if (request.status === 200) {
            var fileContent = request.responseText;
            var lines = fileContent.split("\n");
           
            for (let i = 0; i < lines.length; i++) {
                let line = lines[i].trim();
                if (line === "") continue;
                var splitData = line.split("|");
                if (splitData.length >= 5 && splitData[0].trim() === currentTime) {
                    callback(splitData);
                    foundQuote = true;
                    return;
                }
            }
            
            if (!foundQuote) {
                var previousTime = prevQuotes(currentTime);
                findQuotesRecursive(previousTime, callback);
            }
        } else {
            callback([]);
        }
    };
    request.send(null);
}

function prevQuotes(currentTime) {
    var splitString = currentTime.split(":");
    var hour = parseInt(splitString[0]);
    var minute = parseInt(splitString[1]);

    minute--;

    if (minute < 0) {
        minute = 59;
        hour--;    
        if (hour < 0) {
            hour = 23;
        }
    }

    var formattedHour = hour.toString().padStart(2, '0');
    var formattedMinute = minute.toString().padStart(2, '0');
    var previousTime = formattedHour + ":" + formattedMinute;
    return previousTime;
}