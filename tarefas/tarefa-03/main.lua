function love.load()
	gc = love.graphics.newImage("gc.jpg")
	sound = love.audio.newSource("gc.mp3")
	love.audio.play(sound)
end

function love.draw()
	love.graphics.draw(gc,0,0,0,0.5,0.5)
end