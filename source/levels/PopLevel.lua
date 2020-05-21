local class = require("source.packages.middleclass")
local Level = require("source.objects.Level")
local popBoss = require("source.objects.PopBoss")
local melee_enemy = require("source.objects.melee_enemy")
local ranged_enemy = require("source.objects.ranged_enemy")
local dialogue = require("source.packages.dialogue-system.Dialogue")
local message = require("source.packages.dialogue-system.Message")

local PopLevel = class("PopLevel", Level)

function PopLevel:initialize()
	self.enemies = {}

	table.insert(self.enemies, melee_enemy:new(450,360,64,64,40,"melee_enemy"))
	table.insert(self.enemies, ranged_enemy:new(1500,300,64,64,25,"ranged_enemy"))
	table.insert(self.enemies, ranged_enemy:new(1400,300,64,64,25,"ranged_enemy2"))
	table.insert(self.enemies, melee_enemy:new(2300,200,64,64,40,"melee_enemy"))
	table.insert(self.enemies, melee_enemy:new(2900,200,64,64,40,"melee_enemy"))
	table.insert(self.enemies, melee_enemy:new(3500,200,64,64,40,"melee_enemy"))
	table.insert(self.enemies, melee_enemy:new(4500,200,64,64,40,"melee_enemy"))
	table.insert(self.enemies, melee_enemy:new(6500,200,64,64,40,"melee_enemy"))
	table.insert(self.enemies, melee_enemy:new(6580,200,64,64,40,"melee_enemy"))
	table.insert(self.enemies, melee_enemy:new(7020,200,64,64,40,"melee_enemy"))
	table.insert(self.enemies, ranged_enemy:new(2000,300,64,64,25,"ranged_enemy"))
	table.insert(self.enemies, ranged_enemy:new(3700,300,64,64,25,"ranged_enemy"))
	table.insert(self.enemies, ranged_enemy:new(3600,300,64,64,25,"ranged_enemy"))
	table.insert(self.enemies, ranged_enemy:new(5000,300,64,64,25,"ranged_enemy"))
	table.insert(self.enemies, ranged_enemy:new(5060,300,64,64,25,"ranged_enemy"))
	table.insert(self.enemies, melee_enemy:new(7450,200,64,64,40,"melee_enemy"))
	table.insert(self.enemies, melee_enemy:new(7400,200,64,64,40,"melee_enemy"))
	table.insert(self.enemies, melee_enemy:new(7500,200,64,64,40,"melee_enemy"))
	table.insert(self.enemies, melee_enemy:new(8000,200,64,64,40,"melee_enemy"))

	local beginBossMessages = {
		message:new("Mac", "Chelsea!"),
		message:new("Chelsea", "Hey. Aren’t you that guy who missed THE GIG?"),
		message:new("Mac", "Yes... But I’m not that guy anymore."),
		message:new("Chelsea", "What are you doing here?"),
		message:new("Mac", "I need you for my new band. I’m starting over"),
		message:new("Chelsea", " I saw what you did to your band. Why would I help you?"),
		message:new("Mac", "Well..."),
		message:new("Chelsea", " I need to know you deserve my help.")
	}
	self.beginBossDialogue = dialogue:new(beginBossMessages)

	local bossWonMessages = {
		message:new("Mac", "Now, will you join me?"),
		message:new("Chelsea", "I was wrong. You got what it takes. Let’s do it."),
	}
	self.battleWonDialogue = dialogue:new(bossWonMessages)

	self.boss = nil
end

function PopLevel:load()
	for _, enemy in ipairs(self.enemies) do
		enemy:load()
	end

	tlm:load("images/Pop.lua", require("images.Pop"))

	gameLoop:addLoop(self)
end

function PopLevel:update(dt)
	if self.boss == nil then
		if not self.beginBossDialogue.started and player.collider:getX() >= 9032 then
			self.beginBossDialogue:startDialogue()
			currentDialogue = self.beginBossDialogue
		end

		if self.beginBossDialogue.ended then
			self.boss = popBoss:new(9600, 550, player)
			self.boss:load()
		end
	else
		if self.boss.killed and not self.battleWonDialogue.started then
			self.battleWonDialogue:startDialogue()
			currentDialogue = self.battleWonDialogue
		end
	end

end

function PopLevel:restart()
	for _, enemy in ipairs(self.enemies) do
		if not enemy.destroyed then
			enemy:destroy()
			player.money = 0
		end
	end

	self.enemies = nil

	if self.boss ~= nil then
		self.boss:destroy()
		self.boss = nil
	end

	tlm:restart()

	self:initialize("images/Pop.lua", require("images.Pop"))
end

function PopLevel:keypressed(k)
	if inDialogue then
		self.beginBossDialogue:keypressed(k)
	end
end

return PopLevel
