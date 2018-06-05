#Test

topLeft = 0
topRight = 0
bottomLeft = 0
bottomRight = 0

totalWeight = 0

iniX = indicator.x
iniY = indicator.y

mqtt = require("npm").mqtt
client = mqtt.connect("mqtt://wii-board:72140d05bbe63667@broker.shiftr.io", {
	clientID: "FramerJS"
})

client.on 'connect', ->
	client.subscribe 'topLeft'
	client.subscribe 'topRight'
	client.subscribe 'bottomLeft'
	client.subscribe 'bottomRight'
	
client.on 'message', (topic, message) ->
	messageString = message.toString()
	if (topic == "topLeft")
		topLeft = parseInt(message, 10)
	else if (topic == "topRight")
		topRight = parseInt(message, 10)
	else if (topic == "bottomLeft")
		bottomLeft = parseInt(message, 10)
	else if (topic == "bottomRight")
		bottomRight = parseInt(message, 10)
		
	totalWeight = topLeft + topRight + bottomLeft + bottomRight
	average = totalWeight / 4
	topLeftLabel.text = topLeft - average
	topRightLabel.text = topRight - average
	bottomLeftLabel.text = bottomLeft - average
	bottomRightLabel.text = bottomRight - average
	
	factor = 3
	indicator.x = iniX + ((topRight - average) + (bottomRight - average) - (bottomLeft - average) - (topLeft - average)) * factor
	indicator.y = iniY + (- (topLeft - average) - (topRight-average) + (bottomLeft - average) + (bottomRight - average)) * factor
	