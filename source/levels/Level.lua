local class = require("source.packages.middleclass")

local Level = class("Level")

function Level:initialize()
	self.enemies = {}

end

function Level:update(dt)
	for _, enemy in ipairs(self.enemies) do
		enemy:update(dt)
	end
end

function Level:remove()
end

return Level