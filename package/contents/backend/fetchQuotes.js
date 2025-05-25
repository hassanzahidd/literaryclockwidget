function readQuotes(currentTime, callback) {
    var request = new XMLHttpRequest();
    request.open("GET", "quotes.csv", false);
    request.send(null);

    console.log(request.status);
    if (request.status === 200) {
        var fileContent = request.responseText;
        var lines = fileContent.split("\n");

        let foundQuote = false;
        for (let i = 0; i < lines.length; i++) {
            let line = lines[i].trim();
            if (line === "") continue;

            var splitData = line.split("|");
            if (splitData.length >= 5 && splitData[0].trim() === currentTime) {
                callback(splitData);
                foundQuote = true;
                break;
            }
        }

        if (!foundQuote) {
            callback([]); 
        }
    } else {
        console.error("Failed to read file");
        callback([]);
    }
}