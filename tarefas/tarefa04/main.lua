larguraTela = love.graphics.getWidth()
alturaTela = love.graphics.getHeight()

function love.load()
	tela_ini = love.graphics.newImage("fundo.png")
	fundo = love.graphics.newImage("fundo2.jpg")
	fundo2 = love.graphics.newImage("fundo2_.jpg")
	image_play = love.graphics.newImage("play.png")
	image_play_click = love.graphics.newImage("play_click.png")
	logo = love.graphics.newImage("logo.png")

	vida = 3

	button_play = {
		imagem = image_play,
		posX = larguraTela / 2,
		posY = alturaTela / 2 + 10,
		press = false
	}

	planodefundo = {
		x = 0,
		x2 = 0 - fundo:getWidth(),
		y = 0,
		vel = 180
	}

	imgBalde = love.graphics.newImage("balde.png")

	balde = {
		imagem = imgBalde,
		posX = larguraTela/2,
		posY = alturaTela/2,
		ang = 0;
		vel = 300
	}

	imgGota = love.graphics.newImage("gota.png")

	delay = 3
	tempoNovaGota = delay
	velGota = 200

	gotas = {}
end

function love.update(dt)
	play()
	planoDeFundo(dt)
	movimento(dt)
	gota(dt)
	catch()
end

function love.draw()
	if button_play.press then
		love.graphics.draw(fundo,planodefundo.x, planodefundo.y)
		love.graphics.draw(fundo2,planodefundo.x2, planodefundo.y)

		love.graphics.draw(balde.imagem,balde.posX,balde.posY,ang,1,1,imgBalde:getWidth()/2,imgBalde:getHeight()/2)

		for i, gota in ipairs(gotas) do
			love.graphics.draw(gota.img,gota.x,gota.y)
		end

		love.graphics.print("Vidas:"..vida.." Gotas:"..pontuacao)
	else
		love.graphics.draw(tela_ini)
		love.graphics.draw(button_play.imagem,button_play.posX,button_play.posY,0,1,1,image_play:getWidth()/2,image_play:getHeight()/2 - 100)
		love.graphics.draw(logo,larguraTela/2,alturaTela/2 - 60,0,1,1,logo:getWidth()/2,logo:getHeight()/2)
	end


end

function play()
	if love.keyboard.isDown("space") then
		button_play.press = true
		vida = 3
		pontuacao = 0
		delay = 3
		tempoNovaGota = delay
		velGota = 200
	end
end

function planoDeFundo(dt)
	planodefundo.x = planodefundo.x + planodefundo.vel * dt
	planodefundo.x2 = planodefundo.x2 + planodefundo.vel * dt

	if planodefundo.x2 > larguraTela then
		planodefundo.x2 = planodefundo.x - fundo:getWidth()
	end

	if planodefundo.x > larguraTela then
		planodefundo.x = planodefundo.x2 - fundo2:getWidth()
	end
end

function movimento(dt)
	if love.keyboard.isDown("left") and balde.posX > imgBalde:getWidth()/2 then
		balde.posX = balde.posX - balde.vel * dt
		ang = -0.1
	elseif love.keyboard.isDown("right") and balde.posX < larguraTela - imgBalde:getWidth()/2 then
		balde.posX = balde.posX + balde.vel * dt
		ang = 0.1
	else
		ang = 0
	end

	if love.keyboard.isDown("down") and balde.posY < alturaTela - imgBalde:getHeight()/2 then
		balde.posY = balde.posY + balde.vel * dt
	end


	if love.keyboard.isDown("up") and balde.posY > alturaTela/2 then
		balde.posY = balde.posY - balde.vel * dt
	end
end

function gota(dt)
	tempoNovaGota = tempoNovaGota - (1*dt)
	if tempoNovaGota < 0 then
		tempoNovaGota = delay
		n = math.random(10, larguraTela - ((imgGota:getWidth()/2) + 10))
		novaGota = {x = n, y = -imgGota:getWidth(), img = imgGota}
		table.insert(gotas,novaGota)
	end

	for i, gota in ipairs(gotas) do
		gota.y = gota.y + (velGota*dt)
		if gota.y > alturaTela + imgGota:getHeight() then
			table.remove(gotas,i)
			vida = vida - 1
			if vida <= 0 then
				button_play.press = false
				gotas = {}
			end
		end
	end
end

function catch()

	for i, gota in ipairs(gotas) do
		if colisao(balde.posX,balde.posY,balde.imagem:getWidth(),balde.imagem:getHeight(),gota.x,gota.y,gota.img:getWidth(),gota.img:getHeight()) then
			table.remove(gotas,i)
			pontuacao = pontuacao+1
			velGota = velGota + 5

			if delay > 0.1 then 
				delay = delay - 0.05
			end

			balde.vel = balde.vel + 10
		end
	end
end

function colisao(xb, yb, wb, hb, xg, yg, wg, hg)
	return xb - wb/2 < xg and xg + wg < xb + wb/2 and yb - hb*0.4 < yg + hg and yg < yb - hb/2 
end
