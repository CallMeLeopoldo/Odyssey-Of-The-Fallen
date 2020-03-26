local tlm = {}

--Definição do tamanho do tile manager ()
local width = 128
local height = 128

local size = 16 -- tamanho do tile

-- Ou seja o Tile Manager trata de 128/16 = 8 tiles

function tlm:load()
	renderer:addRenderer(self)
	gameLoop:addLoop(self)


	self.tiles = {}

	for i = 1, height do
		self.tiles[i] = {}
	end
end


function tlm:tick(dt)

end


-- Desenha os tiles guardados no Tile Manager 

function tlm:draw()
	for i = 1, #self.tiles do
		for j = 1, #self.tiles[i] do
			local t = self.tiles[i][j]
			love.graphics.rectangle("fill", size*t.x-size, size*t.y-size, t.w, t.h)
		end
	end
end

-- Adiciona um tile ao Tile Manager

function tlm:add(t)
	self.titles[t.y][t.x] = t
end

return tlm