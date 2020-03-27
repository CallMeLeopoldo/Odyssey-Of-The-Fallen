local Vec2 = {}

function Vec2:new(x,y)
	local vec2 = {}

	vec2.x = x or 0
	vec2.y = y or 0

	function vec2:move(nx,ny, dt)
		local delta = dt or 1
		self.x = x + nx * delta
		self.y = y + ny * delta
	end
end

return Vec2
