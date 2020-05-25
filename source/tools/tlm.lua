local Tlm = {}
local sti  = require ("source.packages.sti")
local bump  = require ("source.packages.bump")
local inspect = require("source.packages.inspect")

function Tlm:load(mapname, luamap)
    self.tiles = {}
    self.map = sti(mapname)
    self.worldColliders = {}

    for _, layer in ipairs(luamap.layers) do
        print(layer.name, layer.properties["collidable"])
        if layer.properties["collidable"] == true then
            for i = 1, self.map.height - 1, 1 do
                for j = 0, self.map.width, 1 do
                    if not (layer.data[(i * self.map.width) + (j + 1)] == 0) then
                        local collider = world:newRectangleCollider(16*j, 16*i, 16, 16)
                        collider:setCollisionClass("Ground")
                        collider:setType("static")
                        table.insert(self.worldColliders, collider)
                    end
                end
            end
        end
        if layer.properties["stop"] == true then
            for i = 1, self.map.height - 1, 1 do
                for j = 0, self.map.width, 1 do
                    if not (layer.data[(i * self.map.width) + (j + 1)] == 0) then
                        local collider = world:newRectangleCollider(16*j, 16*i, 16, 16)
                        collider:setCollisionClass("Stop")
                        collider:setType("static")
                        table.insert(self.worldColliders, collider)
                    end
                end
            end
        end
    end
end

function Tlm:update(dt)
    if self.map ~= nil then 
        self.map:update(dt)
    end
end


-- Desenha os tiles guardados no Tile Manager 

function Tlm:draw()
    if player == nil then return end
    
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

function Tlm:restart(mapname, luamap)
    for _, col in ipairs(self.worldColliders) do
        col:destroy()
    end
end

function Tlm:remove()
    for _, collider in ipairs(self.worldColliders) do
        collider:destroy()
    end
end

return Tlm