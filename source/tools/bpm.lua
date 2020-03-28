local class = require("source.packages.middleclass")

local BPM = class("BPM")


function BPM:initialize(bpm)

	self.bpm = bpm 		-- beats per minute
	self.bps = bpm/60	-- beats per second
	self.spb = 1/self.bps	-- seconds per beat (time, in seconds, between beats)

end

function BPM:load()
	renderer:addRenderer(self)
	gameLoop:addLoop(self)
end


function BPM:update(dt)

end

function BPM:draw()

end

return BPM 