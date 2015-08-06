console.log("* Language detecting...")


var fs = require("fs")

var scanFolder = function (path) {
	var files = []
	var results = fs.readdirSync(path)
	results.forEach(function (filename) {
		var fullPath = path + '/' + filename
		var stats = fs.statSync(fullPath)

		if (stats.isDirectory()) {
			files = files.concat(scanFolder(fullPath))
		} else {
			files.push(fullPath)
		}
	})

	return files
}

var exp = /Language.getLanguage\((\"|\')[^Language.getLanguage]+(\"|\')\)/g
var srcPath = "/Users/gaofei/Projects/jssanguo/src"
var srcFiles = scanFolder(srcPath)
var languageKeys = []

for (var i = 0; i < srcFiles.length; i++) {
	var file = srcFiles[i]
	var content = fs.readFileSync(file, 'utf-8')
	var matches = content.match(exp)

	if (matches != null) {
		for (var j = 0; j < matches.length; j++) {
			var key = matches[j].replace('Language.getLanguage', '') // Remove 'Language.getLanguage'
			var key = key.substr(1, key.length - 2) // Remove '( )'
			if (key[0] == '\'' || key[0] == '\"') {
				key = key.substr(1, key.length - 2)
			}

			if (key.length == 0) {
				continue
			}

			if (languageKeys.indexOf(key) < 0) {
				languageKeys.push(key)

				console.log(key + ',' + key)
			}
		}
	}
}

console.log("== Done: " + languageKeys.length + " matches ==")
// console.log("")
// languageKeys.forEach(function (x) {
// 	console.log(x)
// })