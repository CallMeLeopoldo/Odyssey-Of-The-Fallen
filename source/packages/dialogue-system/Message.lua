local class = require("middleclass")

local Message = class("Message")

function Message:initialize(speaker, message) 
	self.speaker = speaker
	self.message = message
end

return Message