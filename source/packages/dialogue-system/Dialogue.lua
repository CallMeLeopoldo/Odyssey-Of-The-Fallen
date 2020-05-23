local class = require("source.packages.middleclass")

local Dialogue = class("Dialogue")

function Dialogue:initialize(messages)
	self.currentMessage = 1
	self.messages = messages
	self.started = false
	self.ended = false
end

function Dialogue:startDialogue()
	inDialogue = true
	self.started = true
end

function Dialogue:keypressed(key)
	if (key == "z") then
		if self.currentMessage == #self.messages then
			self:destroy()
		else
			self.currentMessage = self.currentMessage + 1
		end
	end
	
	for _, v in ipairs(self.messages) do
		print(v.message)
	end
end

function Dialogue:draw()
	if self.ended then return end

	local width, height = love.graphics.getWidth(), love.graphics.getHeight()
	love.graphics.setColor(0.055, 0.055, 0.055)
	love.graphics.rectangle("fill", 25, (4*height/5) - 25, width - 50, height/5)
	love.graphics.setColor(0.669, 0.787, 0.787)
	love.graphics.printf(self.messages[self.currentMessage].speaker, 35, (4*height/5) - 15, width - 70, "left")
	love.graphics.setColor(0.83,0.83,0.83)
	love.graphics.printf(self.messages[self.currentMessage].message, 35, (4*height/5) + 9, width - 70, "left")
	love.graphics.setColor(1, 1, 1)
	love.graphics.print("Z-Continue", width - 185, height - 59)
end

function Dialogue:destroy()
	inDialogue = false
	self.ended = true
end

function Dialogue:restart()
	self.started = false
	self.ended = false
	self.currentMessage = 1
end

return Dialogue