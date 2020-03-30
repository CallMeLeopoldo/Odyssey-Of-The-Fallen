local Renderer = {}

local num_of_layers = 5
local insert = table.insert
local remove = table.remove

function Renderer:create()
	local renderer = {}

	renderer.drawers = {}

	for i = 0, num_of_layers do
		renderer.drawers[i] = {}
	end

	function renderer:addRenderer(obj, layer)
		local l = layer or 0
		insert(self.drawers[l], obj)
	end

	function renderer:removeRenderer(obj, layer)
		local l = layer or 0
		for i = 0, #self.drawers[l] do
        	if self.drawers[l][i] == obj then
            	remove(self.drawers[l], i)
        	end
    	end
	end

	function renderer:draw()
		for layer = 0, #self.drawers do
			for draw = 0, #self.drawers[layer] do
				local obj = self.drawers[layer][draw]
				if obj ~= nil then
					obj:draw()
				end
			end
		end
	end

	return renderer
end

return Renderer