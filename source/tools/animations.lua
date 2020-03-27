local Animations = {}

local insert = table.insert
local remove = table.remove

function Animations:create()
	local animations = {}

	renderer.drawers = {}

	for i = 0, num_of_layers do
		renderer.drawers[i] = {}
	end

	function renderer:addRenderer(obj, layer)
		local l = layer or 0
		insert(self.drawers[l], obj)
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