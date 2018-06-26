#Test
Framer.Extras.Preloader.enable()

topLeft = 0
topRight = 0
bottomLeft = 0
bottomRight = 0

totalWeight = 0

iniX = indicator.x
iniY = indicator.y

playing = false

state0 = 0
state1 = 1
state2 = 2
state3 = 3
currentState = state0

video = new VideoLayer
	video: "2.1.mp4"
	width: Canvas.width
	height: Canvas.height
	
#video.opacity = 0

mqtt = require("npm").mqtt
client = mqtt.connect("mqtt://wii-board:72140d05bbe63667@broker.shiftr.io", {
	clientID: "FramerJS"
})

zeroState = () ->
	video.player.play()
	return 0
	
firstState = () ->
	video.player.play()
	
secondState = () ->
	video.player.play()
	
thirdState = () ->
	video.player.play()

updateInterface = () ->
	if (playing == true)
		return
	switch currentState
		when state0
			if (topLeft > 2)
				video.player.play()
				playing = true
		when state1
			if (topRight > 20)
				video.video = "2.2.mp4"
				video.player.play()
				playing = true
		when state2
			if (topLeft > 20)
				video.video = "2.3.mp4"
				video.player.play()
				playing = true
		when state3
			if (topRight > 15 && topLeft > 15)
				video.video = "2.4.mp4"
				video.player.play()
				playing = true

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
	topLeft = topLeft - average
	topRight = topRight - average
	bottomLeft = bottomLeft - average
	bottomRight = bottomRight - average
	updateInterface()
	
Events.wrap(video.player).on "pause", ->
	playing = false
	switch currentState
		when state0
			currentState = state1
		when state1
			currentState = state2
		when state2
			currentState = state3
			
video.onClick ->
	updateInterface()