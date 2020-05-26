local class = require("source.packages.middleclass")
local Level = require("source.levels.Level")
local dialogue = require("source.packages.dialogue-system.Dialogue")
local message = require("source.packages.dialogue-system.Message")
local Player = require("source.objects.player")
local PopLevel = require("source.levels.PopLevel")
local melee_enemy = require("source.objects.melee_enemy")
local ranged_enemy = require("source.objects.ranged_enemy")
local Music = require("source.tools.music")

local TutorialLevel = class("TutorialLevel", Level)

function TutorialLevel:initialize()
	music = Music:new("audio/tutorial.mp3", 70)
	self.enemies = {}
	table.insert(self.enemies, melee_enemy:new(6000,400,64,64,40,"melee_enemy"))
	table.insert(self.enemies, ranged_enemy:new(6500,400,64,64,25,"ranged_enemy"))
	local introMessages = {
		message:new("???", "There’s one thing every garage band knows about this rock’n’roll business."),
		message:new("???", "If you want to succeed on this savage land, you do everything you can to get a spot on THE GIG."),
		message:new("???", "That platform reveals the truly talented. hat music heaven is the big shot forevery band."),
		message:new("???", "And when you get that chance to play on THE GIG, you give everything you got on that holy stage. You just don’t miss it."),
		message:new("Gadd", "So why would do you, Mac “Master of All Cruelty” Astley, one of the most famous guitar players of these streets, ruin that chance for you and your band? Are you insane?!"),
		message:new("Cliff", "We called you, we went to your house. Where the hell were you Mac?! Lying in a ditch, completely passed out, on the most important night of our lifes!"),
		message:new("Layne", "You had one chance and you let that addiction of yours fuck this up forus, you scumbag. We are tired of your excuses. We can’t trust you anymore."),
		message:new("Everyone", "YOU ARE OUT OF THE BAND!"),
		message:new("Gadd", "And will get that night on THE GIG without you.")
	}
	self.introDialogue = dialogue:new(introMessages)

	local lofdMessages = {
		message:new("Lord Of The Darkness", "Well, well, well... You really fucked it up this time, didn’t you? I can’t say I’m surprised"),
		message:new("Lord Of The Darkness", "You never deserved your talent. You never deserved your friends"),
		message:new("Lord Of The Darkness", "You’re just one more cocky guitar player pretending you’re going to get somewhere in the music world. MUAHAHA."),
		message:new("Lord Of The Darkness", "You thought those drugs would solve everything, didn’t you? Now you’re sinking."),
		message:new("Lord Of The Darkness", "And so is your reputation! Oh Mac, what asight to behold."),
		message:new("Lord Of The Darkness", "Wait, I’m going to call my other Depression friends. They got to see this..."),
	}
	self.lotdDialogue = dialogue:new(lofdMessages)

	local realizationMessages = {
		message:new("Mac", "He’s right. I can’t believe I let it get to this point. This can’t be the end of it..."),
	}
	self.realizationDialogue = dialogue:new(realizationMessages)

	local challengeAcceptedMessages = {

		message:new("Mac", "I won’t sink into this, damn it! I forgot the most important thing. My passion is music andI worked hard for this."),
		message:new("Mac", "I got pure talent in my hands and I can feel it in this chords. My guitar tells me the truth."),
		message:new("Mac", "Oh Lord BB King, get me your guitar licks! May Jimmy Page bless me those riffs! I’m ready to get my reputation back!"),
		message:new("Mac", "Now, I just have to find a new band... And get on THE GIG again!"),
	}
	self.challengeAcceptedDialogue = dialogue:new(challengeAcceptedMessages)

end

function TutorialLevel:load()
	gameLoop:addLoop(self)
	renderer:addRenderer(self)
	music:load()
end

function TutorialLevel:update(dt)
	if not self.introDialogue.started then
		self.introDialogue:startDialogue()
		currentDialogue = self.introDialogue
	end

	if self.introDialogue.ended then
		if not self.lotdDialogue.started then
			self.lotdDialogue:startDialogue()
			currentDialogue = self.lotdDialogue
		end


		if player == nil then
			player = Player:new(9000, 500, 32, 64, 15, 0.5)
			player:load()
			for _, enemy in ipairs(self.enemies) do
				enemy:load()
			end
			tlm:load("images/Tutorial.lua", require("images.Tutorial"))
			player:setmojo(100)
		end
		if not self.lotdDialogue.started then
			self.lotdDialogue:startDialogue()
			currentDialogue = self.lotdDialogue
			player:setmojo(100)
		end
	end

	if player ~= nil then
		if not self.realizationDialogue.started and player.collider:getX() >= 3472 then
			self.realizationDialogue:startDialogue()
			currentDialogue = self.realizationDialogue
		end


		if not self.challengeAcceptedDialogue.started and player.collider:getX() >= 8100 then
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
		music:remove()
		music = Music:new("audio/synthpop.mp3", 110)
		music:load() 
	end
end

function TutorialLevel:draw()
	if not self.introDialogue.ended then
		return
	else
		if not self.lotdDialogue.ended then
			-- draw lotd
			love.graphics.draw(sprites.lotd, 720, 400)
		end
	end

	
	love.graphics.print("Press Left or Right\nto move to the left\nor to the right", 592, 256)
	love.graphics.print("Press Down\nto duck", 1376, 316)	
	love.graphics.print("Press Up\nto jump", 2224, 316)	
	love.graphics.print("Press twice\nrepedeatly on beat\nto do a double jump", 4336, 256)
	love.graphics.print("Press three times\nrepedeatly on beat\nto do a triple jump", 4832, 256)
	love.graphics.print("Press Z\nto do a\nmelee attack", 5712, 256)
	love.graphics.print("You can win MOJO\nwhen hitting an enemy\nwith a melee attack", 5900, 136)		
	love.graphics.print("Press X\nto do a\nranged attack", 6160, 256)
	love.graphics.print("A ranged attack\ncosts you MOJO\nKeep track of your MOJO", 6360, 136)			
	love.graphics.print("As you can see there's a bar below\nThat indicates the song's beat\nMaking attacks on synch with the beat\n will make you deal more damage\n and perform other special abilities", 3552, 250)			
	love.graphics.print("To heal your wounds\npress LShift\nby using one of your potions", 6960, 256)
	love.graphics.print("You have a limit of 3 potions\nTo recharge these\ngo into a store", 7160, 136)
end

function TutorialLevel:restart()
	self.introDialogue:restart()
	self.lotdDialogue:restart()
	self.realizationDialogue:restart()
	self.challengeAcceptedDialogue:restart()
	for _, enemy in ipairs(self.enemies) do
		if not enemy.destroyed then
			enemy:destroy()
			player.money = 0
		end
	end

	self.enemies = nil

end

function TutorialLevel:keypressed(k)
end

return TutorialLevel
