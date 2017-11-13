require("util")
anim8 = require "anim8"

resposta = ""
local btn = {}

btn[1] = {x = 370, y = 270, msg = "+", posx = -300}
btn[2] = {x = 690, y = 270, msg = "-", posx = -300}
btn[3] = {x = 370, y = 390, msg = "x", posx = -300}
btn[4] = {x = 690, y = 390, msg = "todos", posx = -300}
char = {x = 1000, y = 0, aparece = false}
bg = {x = 0, y = 0}
escolherOP, jogar = true, false
erros, acertos = 0,0

function love.load()
	
	 -- semente para random
	lg,lm,lw = love.graphics,love.mouse,love.window -- encurtando metodos

	fonte = lg.newFont('font/fonte.ttf', 30)-- adicionando fonte
	love.graphics.setFont(fonte)
	util = Utilidade.new(13) -- inicia objeto
	op,n1,n2 = 0,0,0
	
	mainSong:play()

	image = love.graphics.newImage('pngRun/correndo1.png') -- personagem
  	local g = anim8.newGrid(376, 328, image:getWidth(), image:getHeight())
  	animation = anim8.newAnimation(g('1-7',1), 0.1)

  	dog = love.graphics.newImage('pngRun/dog1.png') -- personagem
  	g = anim8.newGrid(255, 328, dog:getWidth(), dog:getHeight())
  	dogAnim = anim8.newAnimation(g('1-3',1), 0.7)

  	fundo = lg.newImage('pngRun/fundo.png')
end 

function love.draw()

	 lg.setColor(255,255,255)
	 lg.draw(fundo,0,0)
	 if bg.x < 0 then lg.draw(fundo,bg.x+fundo:getWidth(),0) end
	 if bg.x > 0 then lg.draw(fundo,bg.x-fundo:getWidth(),0) end
     lg.draw(fundo,bg.x,0)
	 if jogar then
	 	lg.setColor(255,255,255)
	 	dogAnim:draw(dog,-50,0)

	 	if char.aparece then animation:draw(image, char.x, char.y) end	 -- desenha char se ele aparecer
	 	lg.print("Resolva "..tostring(n1).." "..op.." "..tostring(n2),500,500) -- printa conta
	 	if util:getMsg() ~= nil then lg.print(util:getMsg(), 500, 550) end -- mostra a msg de interacao
			 if resposta ~= nil then -- mostra a resposta quando ela é diferente de vazio
			 	 lg.setColor(0,0,0)
				 lg.print("Resposta "..tostring(resposta),500,600)
				 lg.setColor(255,255,255)
			 end

		-- variaveis de erros e acertos	 

		lg.print("Acertos "..acertos.."\n".."Erros "..erros, 620, 0)
	 	util:drawBotoes()
     end

     if escolherOP then
     	lg.setColor(0,0,255)
		lg.print("Escolha uma operacao matematica", 450,120)
		for i = 1, 4 do
			lg.setColor(255,255,255)
			lg.rectangle("fill", btn[i].posx, btn[i].y,300,100)
			lg.setColor(39,154,181)
			lg.print(btn[i].msg, btn[i].posx+150, btn[i].y+30)

		end
	end
end 

function love.update(dt)
	if escolherOP then -- reseta variaveis para vazio no inicio do jogo
		util:setMsg("")
		resposta = ""
		erros, acertos = 0,0
		for i=1,4 do
			if btn[i].posx < btn[i].x then
				btn[i].posx = btn[i].posx + 5 -- animacao dos botoes
			end
		end
	else
		for i=1,4 do
			btn[i].posx = -100 -- reseta para pos inicial
		end
	end

	if char.x > -200 and char.aparece then -- faz char andar enqnt nao tocha o cao
		char.x = char.x - 0.5
		if resposta == true and  char.x + 200 <= 1000 then 
			char.x = char.x + 200 -- avança o bichinho se acertar
			resposta = nil
			elseif resposta == true and char.x + 200 > 1000 then
				char.x = 1000 -- nao deixa o cao atravessar a tela
				resposta = nil
		end 
		dogAnim:update(dt) -- faz update do sprite 
		animation:update(dt) -- faz update do sprite
	end

	if char.x <= -200 and escolherOP == false then
		util:setMsg("Fim de jogo! Pressione enter para jogar de novo\n".."Resposta era "..util:getResult())
		char.aparece = false
		resposta = nil
		char.x = 1000 -- posicao iniciao do gato 
	end

	if mainSong:isStopped() then mainSong:play() end -- repete a musica 

	if bg.x < lg.getWidth() and jogar then -- faz o background andar
		bg.x = bg.x + 50 * dt
	else
		bg.x = -1575
	end

end 

function love.mousepressed(mx, my, button, touch)
	if jogar and char.aparece then
		resposta = util:mPressed(mx,my,button,touch)
		if resposta == true and util:getOp() == "todos" then 
				op = util.opTds 
		end
		if resposta == true then acertos = acertos + 1 elseif resposta == nil then erros = erros + 1 end
	end

	if escolherOP then
		for i = 1, 4 do
			if mx > btn[i].posx and mx < btn[i].posx+300
				and my > btn[i].y and my < btn[i].y+100 then
					util:setOp(btn[i].msg)
					op,n1,n2 = util:darNumeros()
					jogar = true
					escolherOP = false
					char.aparece = true
				end
		end
	end

end 

function love.keypressed(key)
	if key == "return" and char.aparece == false then
		jogar = false
		escolherOP = true
	end
end

