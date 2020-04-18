local Tlm = {}
local sti  = require ("source.packages.sti")
local bump  = require ("source.packages.bump")
local inspect = require("source.packages.inspect")

function Tlm:load(mapname, tx, ty)
	self.tiles = {}
	NewWorld = bump.newWorld()
	NewWorld:add(player.collider, 50, 520, 20, 64)
	self.map = sti(mapname, { "bump" },0,0)
	self.tx = tx
	self.ty = ty
	self.map:bump_init(NewWorld)

--Gets number of tables(objects) in currently loaded map
colliderLayer = self.map.objects
print(inspect(colliderLayer))
--Loops through all objects and gets their respective x, y values
--this then creates a new collider rectangle at respective coordinates
--for i, v in pairs(colliderLayer) do
--	print(self.map.layers[2].data[i].x)
--	local colliderObjectX = self.map.layers[2].data[i].x
--	local colliderObjectY = self.map.layers[2].data[i].y
--	colliderBox = world:newRectangleCollider(
--		(colliderObjectX*2+6), --Multiplies current cordinate by 2 too make up for map scaling in draw()
--		(colliderObjectY*2-28), --then adds specific numbers to allign them just perfect
--		20,
--		25)
--	colliderBox:setType('static')
--end	


	end

function Tlm:update(dt)
	self.map:update(dt)
end


-- Desenha os tiles guardados no Tile Manager 

function Tlm:draw()
	-- Draw map
	love.graphics.setColor(1, 1, 1)
	self.map:draw(-self.tx, -self.ty)
	self.map:bump_draw(NewWorld, -520, 200)
end

return Tlm