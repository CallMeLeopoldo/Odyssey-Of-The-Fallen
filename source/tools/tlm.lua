local Tlm = {}
local sti  = require ("source.packages.sti")
local bump  = require ("source.packages.bump")
local inspect = require("source.packages.inspect")

function Tlm:load(mapname, luamap)
    self.tiles = {}
    self.map = sti(mapname)

    for _, layer in ipairs(luamap.layers) do
        if layer.properties["collidable"] == true then
            print(layer.data[1])
            for i = 1, self.map.height - 1, 1 do
                for j = 0, self.map.width, 1 do
                    if not (layer.data[(i * 600) + (j + 1)] == 0) then
                        local collider = world:newRectangleCollider(16*j, 16*i, 16, 16)
                        collider:setCollisionClass("Ground")
                        collider:setType("static")
                    end
                end
            end
        end
    end
end

function Tlm:update(dt)
	self.map:update(dt)
end


-- Desenha os tiles guardados no Tile Manager 

function Tlm:draw()
	-- Draw map

	local tx, ty = 0,0
	if(player.collider:getY() - love.graphics.getHeight() > 0) then 
		local ty = math.floor(player.collider:getY() - love.graphics.getHeight()/2)
	end
	
	local cx, cy = camera:position()
	local tx = math.floor(cx - love.graphics.getWidth() / 2)
	love.graphics.setColor(1, 1, 1)
	self.map:draw(-tx, -ty)
end

return Tlm