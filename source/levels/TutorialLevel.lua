local class = require("source.packages.middleclass")
local Level = require("source.levels.Level")
local dialogue = require("source.packages.dialogue-system.Dialogue")
local message = require("source.packages.dialogue-system.Message")
local Player = require("source.objects.player")
local PopLevel = require("source.levels.PopLevel")

local TutorialLevel = class("TutorialLevel", Level)

function TutorialLevel:initialize()

	local introMessages = {
		message:new("???", "There’s one thing every garage band knows about this rock’n’roll business."),
		message:new("???", "If you want to succeed on this savage land, you do everything you can to get a spot on THE GIG."),
		message:new("???", "That platform reveals the truly talented. hat music heaven is the big shot forevery band."),
		message:new("???", "And when you get that chance to play on THE GIG, you give everything you got on that holy stage. You just don’t miss it."),
		message:new("Gadd", " So why would do you, Mac “Master of All Cruelty” Astley, one of the most famous guitar players of these streets, ruin that chance for you and your band? Are you insane?!"),
		message:new("Cliff", "We called you, we went to your house. Where the hell were you, Mac?Lying in a ditch, completely passed out, on the most important night of our lifes!"),
		message:new("Layne", "You had one chance and you let that addiction of yours fuck this up forus, you scumbag. We are tired of your excuses. We can’t trust you anymore."),
		message:new("Everyone", "You had one chance and you let that addiction of yours fuck this up forus, you scumbag. We are tired of your excuses. We can’t trust you anymore."),
		message:new("Gadd", "And will get that night on THE GIG without you.")
	}
	self.introDialogue = dialogue:new(introMessages)

	local lofdMessages = {
		message:new("Lord Of The Darkness", "Well, well, well... You really fucked it up this time, didn’t you? I can’t say I’m surprised"),
		message:new("Lord Of The Darkness", "You never deserved your talent. You never deserved your friends"),
		message:new("Lord Of The Darkness", "You’re just one more cocky guitar player pretending you’re going to getsomewhere in the music world. MUAHAHA."),
		message:new("Lord Of The Darkness", "You thought those drugs would solveeverything, didn’t you? Now you’re sinking."),
		message:new("Lord Of The Darkness", "And so is your reputation! Oh Mac, what asight to behold."),
		message:new("Lord Of The Darkness", "Wait, I’m going to call my other Depression friends. They got to seethis..."),
	}
	self.lotdDialogue = dialogue:new(lofdMessages)

	local realizationMessages = {
		message:new("Mac", "He’s right. I can’t believe I let it get to this point. This can’t be the end of it..."),
	}
	self.realizationDialogue = dialogue:new(realizationMessages)

	local challengeAcceptedMessages = {
		
		message:new("Mac", "I won’t sink into this, damn it! I forgot the most important thing. My passion is music andI worked hard for this."),
		message:new("Mac", "I got pure talent in my hands and I can feel it in this chords. Myguitar tells me the truth."),
		message:new("Mac", "Oh Lord BB King, get me your guitar licks! May Jimmy Pagebless me those riffs! I’m ready to get my reputation back!"),
		message:new("Mac", "Now, I just have to find a new band... And get on THE GIG again!"),
	}
	self.challengeAcceptedDialogue = dialogue:new(challengeAcceptedMessages)

end

function TutorialLevel:load()
	gameLoop:addLoop(self)
	renderer:addRenderer(self)
end

function TutorialLevel:update(dt)
	if not self.introDialogue.started then
		self.introDialogue:startDialogue()
		currentDialogue = self.introDialogue
	end

	if self.introDialogue.ended then
		if player == nil then
			player = Player:new(688, 400, 32, 64, 15, 0.5)
			player:load()

			tlm:load("images/Tutorial.lua", require("images.Tutorial"))
		end

		if not self.lotdDialogue.started then
			self.lotdDialogue:startDialogue()
			currentDialogue = self.lotdDialogue
		end
	end

	if player ~= nil then
		if not self.realizationDialogue.started and player.collider:getX() >= 3472 then
			self.realizationDialogue:startDialogue()
			currentDialogue = self.realizationDialogue
		end

		
		if not self.challengeAcceptedDialogue.started and player.collider:getX() >= 8700 then
			self.challengeAcceptedDialogue:startDialogue()
			currentDialogue = self.challengeAcceptedDialogue
		end
	end

	if self.challengeAcceptedDialogue.ended then
		gameLoop:removeLoop(self)
		renderer:removeRenderer(self)
		tlm:remove()
		player:destroy()
		player = Player:new(50, 400, 32, 64, 15, 0.5)
		player:load()
		currentLevel = PopLevel:new()
		currentLevel:load()
	end
end

function TutorialLevel:draw()
	if not self.introDialogue.ended then 
		return
	else
		if not self.lotdDialogue.ended then
			-- draw lotd
			love.graphics.draw(sprites.lotd, 50, 200)
		end
	end
end

function TutorialLevel:restart()
	self.introDialogue:restart()
	self.lotdDialogue:restart()
	self.realizationDialogue:restart()
	self.challengeAcceptedDialogue:restart()
end

function TutorialLevel:keypressed(k)
end

return TutorialLevel
