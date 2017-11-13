mainSong = love.audio.newSource('sounds/main.mp3')
ohNao = love.audio.newSource('sounds/oh nao.mp3')
help = love.audio.newSource('sounds/me ajuda.mp3')
acertou = love.audio.newSource('sounds/acertou.mp3')
love.math.setRandomSeed(love.timer.getTime())

Utilidade = {
	new = function (x)
		

		local p = {}
		p.mensagemInteracao = ""
		p.result = 0
		p.resposta = ""
		p.opt = ""
		p.opTds = ""
		for i = x, 1, -1 do
			p[i] = {x = i, y = i, img = '', msg = ''}
		end


		-- pegar resultado
		function p:getResult()
			return self.result
		end
		function p:setResult(n)
			self.result = n
		end

		-- pegar mensagem de interacao
		function p:getMsg()
			return self.mensagemInteracao
		end
		function p:setMsg(n)
			self.mensagemInteracao = n
		end

		function p:getOp()
			return self.opt
		end

		function p:setOp(a)
			self.opt = a
		end

		-- dar um num aleatorio
		function p:darNumeros()
			n1,n2 = love.math.random(100),love.math.random(100)
			local op 
			if self:getOp() == "+" then
				 self:setResult(n1+n2)
				 op = "+"
				elseif self:getOp() == "-" then
					 self:setResult(n1-n2)
					 op = "-"
				elseif self:getOp() == "x" then 
					n1 = love.math.random(10) 
					n2 = love.math.random(10) 
					self:setResult(n1*n2)
					op = "x"
			end
			if self:getOp() == "todos" then
				r = love.math.random(1,3)
				if r == 1 then 
					self.opTds = "+" 
					self:setResult(n1+n2)
				end
					if r == 2 then 
						self.opTds = "-" 
						self:setResult(n1-n2) 
					end
					if r == 3 then 
						self.opTds = "x"
						n1 = love.math.random(10)
						n2 = love.math.random(10)
						self:setResult(n1*n2)
				end
				return self.opTds,n1,n2 
			end
						return op,n1,n2
		end -- acaba funcao de dar num random

		-- funcao desenhar
		function p:drawBotoes()
			local btnVermelho = love.graphics.newImage('pngRun/botao.png')
			local btnConfirma = love.graphics.newImage('pngRun/botaoConfirma.png')
			local btnApaga = love.graphics.newImage('pngRun/botaoApaga.png')
			local largura, altura = love.window.getDesktopDimensions()

			local posx, posy = 50+110, altura/2-60
			for i = 1,9 do
			  	self[i].x, self[i].y,self[i].msg = posx,posy,i
			  	if i % 3 == 0 then
			  		posx = 50
			  		posy = posy + 110
			  	end
			  	posx = posx + 110
			end

			self[10].x, self[10].y,self[10].msg = 160+110,self[9].y+110,0
			self[11].x, self[11].y = 160,self[9].y+110
			self[12].x, self[12].y = 270+110, self[9].y+110
			self[13].x, self[13].y,self[13].msg = 160-110, self[9].y+110,"-"

			for i = 1, 10 do
				love.graphics.draw(btnVermelho, self[i].x, self[i].y)
				love.graphics.setColor(39,154,181)
				love.graphics.print(self[i].msg, self[i].x + 40, self[i].y+30)
				love.graphics.setColor(255,255,255)
			end
				love.graphics.setColor(39,154,181)
				love.graphics.print(self[10].msg, self[10].x + 40, self[10].y+30)
				love.graphics.setColor(255,255,255)
				love.graphics.draw(btnApaga, self[11].x,self[11].y)
				
				love.graphics.draw(btnConfirma, self[12].x,self[12].y)
				love.graphics.draw(btnVermelho, self[13].x,self[13].y)
				love.graphics.setColor(39,154,181)
				love.graphics.print(self[13].msg, self[13].x + 40, self[13].y+30)
				love.graphics.setColor(255,255,255)
		end -- fim da funcao desenhar botoes

		function p:mPressed(x,y,button,istouch)
			if button == 1 then
				for i = 1, 10 do
					if x > self[i].x and x < self[i].x+100 
						and y > self[i].y and y < self[i].y+100 then
							if i == 10 then self.resposta = self.resposta..0 
								else self.resposta = self.resposta..i end
								return self.resposta
					end
				end
			end

			if button == 1 then -- botao apagar numero
				if x > self[11].x and x < self[11].x+100
					and y > self[11].y and y < self[11].y+100 then
					self.resposta = self.resposta:sub(1, -2)
					return self.resposta
				end
			end

			if button == 1 then -- botao confirmar
				if x > self[12].x and x < self[12].x+100
					and y > self[12].y and y < self[12].y+100 then
						return self:acertou(tonumber(self.resposta))
				end
			end

			if button == 1 then -- botao menos
				if x > self[13].x and x < self[13].x+100
					and y > self[13].y and y < self[13].y+100 then
						self.resposta = self.resposta.."-" 
						return self.resposta
				end
			end
			return false
		end -- fim da funcao mouse clicked

		function p:acertou(num)
			if num == self:getResult() then
				self.resposta = " "
				self:setMsg("Acertou!")
				self.opTds,n1,n2 = self:darNumeros()
				acertou:play()
				return true
			else
				self.resposta = " "
				self:setMsg("Me ajudaaa")
				local r = love.math.random(2)
				if r == 1 then help:play() else ohNao:play() end
				return nil
			end
		end

		return p
	end -- end funcao
}
