io.stdout:setvbuf("no")

local class = require("source.packages.middleclass")
local lovebpm = require("source.packages.lovebpm")

local Music = class("Music")

function Music:initialize(track, bpm)
	self.track = track
	self.bpm = bpm
	self.bps = self.bpm/60	-- beats per second
	self.spb = 1/self.bps	-- seconds per beat (time, in seconds, between beats)

end

function Music:load()
	love.audio.setVolume(.6)
  	font = love.graphics.newFont(50)
  	paused = false
  	pulse = 0

  	self.music = lovebpm.newTrack()
    	:load(self.track)
    	:setBPM(self.bpm)
    	:setLooping(true)
    	:on("beat", function(n) print("beat:", n, "BPM:", self.bpm) end)
    	:play()
end

function Music:update(dt)
	self.music:update(dt)
  	--pulse = math.max(0, pulse - dt)
end

function Music:draw()

end

function Music:remove() 
	self.music:stop()
end

return Music