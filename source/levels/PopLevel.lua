local class = require("source.packages.middleclass")
local Level = require("source.levels.Level")
local popBoss = require("source.objects.PopBoss")
local melee_enemy = require("source.objects.melee_enemy")
local ranged_enemy = require("source.objects.ranged_enemy")
local dialogue = require("source.packages.dialogue-system.Dialogue")
local message = require("source.packages.dialogue-system.Message")
local Shop = require("source.objects.Shop")
local Music = require("source.tools.music")
local PopStage = require("source.objects.PopStage")

local PopLevel = class("PopLevel", Level)

function PopLevel:initialize()
	self.enemies = {}

	self.shops = {}

	self.stage = PopStage:new(33694, 40, 260, 261)
	self.music = Music:new("audio/synthpop.wav", 100)

	table.insert(self.shops, Shop:new(100, 396, 96, 96))


  table.insert(self.enemies, melee_enemy:new(928,463,64,64,40,"melee_enemy"))
	table.insert(self.enemies, ranged_enemy:new(1152,447,64,64,25,"ranged_enemy"))
	table.insert(self.enemies, melee_enemy:new(1376,463,64,64,40,"melee_enemy"))
	table.insert(self.enemies, ranged_enemy:new(1712,479,64,64,25,"ranged_enemy"))
	table.insert(self.enemies, ranged_enemy:new(1760,479,64,64,25,"ranged_enemy"))
	table.insert(self.enemies, melee_enemy:new(1968,463,64,64,40,"melee_enemy"))
	table.insert(self.enemies, melee_enemy:new(2240,463,64,64,40,"melee_enemy"))
	table.insert(self.enemies, melee_enemy:new(2864,463,64,64,40,"melee_enemy"))
	table.insert(self.enemies, melee_enemy:new(3008,463,64,64,40,"melee_enemy"))
	table.insert(self.enemies, melee_enemy:new(3824,463,64,64,40,"melee_enemy"))
	table.insert(self.enemies, melee_enemy:new(4240,447,64,64,40,"melee_enemy"))
	table.insert(self.enemies, melee_enemy:new(4784,447,64,64,40,"melee_enemy"))
	table.insert(self.enemies, melee_enemy:new(5200,447,64,64,40,"melee_enemy"))
	table.insert(self.enemies, melee_enemy:new(5632,447,64,64,40,"melee_enemy"))
	table.insert(self.enemies, melee_enemy:new(6256,352,64,64,40,"melee_enemy"))
	table.insert(self.enemies, melee_enemy:new(6576,448,64,64,40,"melee_enemy"))
	table.insert(self.enemies, melee_enemy:new(7104,431,64,64,40,"melee_enemy"))
	table.insert(self.enemies, melee_enemy:new(7536,447,64,64,40,"melee_enemy"))
	table.insert(self.enemies, ranged_enemy:new(2608,463,64,64,25,"ranged_enemy"))
	table.insert(self.enemies, ranged_enemy:new(3552,463,64,64,25,"ranged_enemy"))
	table.insert(self.enemies, ranged_enemy:new(5056,319,64,64,25,"ranged_enemy"))
	table.insert(self.enemies, ranged_enemy:new(4992,463,64,64,25,"ranged_enemy"))
	table.insert(self.enemies, ranged_enemy:new(6016,447,64,64,25,"ranged_enemy"))
	table.insert(self.enemies, ranged_enemy:new(7216,447,64,64,25,"ranged_enemy"))
	table.insert(self.enemies, ranged_enemy:new(7728,432,64,64,25,"ranged_enemy"))
	table.insert(self.enemies, melee_enemy:new(8144,432,64,64,40,"melee_enemy"))
	table.insert(self.enemies, ranged_enemy:new(8160,304,64,64,25,"ranged_enemy"))
	table.insert(self.enemies, ranged_enemy:new(7696,272,64,64,25,"ranged_enemy"))
	table.insert(self.enemies, melee_enemy:new(8432,448,64,64,40,"melee_enemy"))
	table.insert(self.enemies, ranged_enemy:new(8848,432,64,64,25,"ranged_enemy"))
	table.insert(self.enemies, melee_enemy:new(9216,432,64,64,40,"melee_enemy"))
	table.insert(self.enemies, ranged_enemy:new(9824,448,64,64,25,"ranged_enemy"))
	table.insert(self.enemies, ranged_enemy:new(10240,448,64,64,25,"ranged_enemy"))
	table.insert(self.enemies, melee_enemy:new(10784,432,64,64,40,"melee_enemy"))
	table.insert(self.enemies, ranged_enemy:new(11200,448,64,64,25,"ranged_enemy"))
	table.insert(self.enemies, melee_enemy:new(11616,416,64,64,40,"melee_enemy"))
	table.insert(self.enemies, ranged_enemy:new(12032,384,64,64,25,"ranged_enemy"))
	table.insert(self.enemies, melee_enemy:new(12304,384,64,64,40,"melee_enemy"))
	table.insert(self.enemies, ranged_enemy:new(12688,432,64,64,25,"ranged_enemy"))
	table.insert(self.enemies, ranged_enemy:new(12976,368,64,64,25,"ranged_enemy"))
	table.insert(self.enemies, melee_enemy:new(13488,432,64,64,40,"melee_enemy"))
	table.insert(self.enemies, melee_enemy:new(13664,432,64,64,40,"melee_enemy"))
	table.insert(self.enemies, ranged_enemy:new(14048,416,64,64,25,"ranged_enemy"))
	table.insert(self.enemies, melee_enemy:new(14448,432,64,64,40,"melee_enemy"))
	table.insert(self.enemies, melee_enemy:new(14768,432,64,64,40,"melee_enemy"))
	table.insert(self.enemies, ranged_enemy:new(15232,432,64,64,25,"ranged_enemy"))
	table.insert(self.enemies, melee_enemy:new(15552,416,64,64,40,"melee_enemy"))
	table.insert(self.enemies, ranged_enemy:new(16016,416,64,64,25,"ranged_enemy"))
	table.insert(self.enemies, ranged_enemy:new(15840,416,64,64,25,"ranged_enemy"))
	table.insert(self.enemies, melee_enemy:new(16368,400,64,64,40,"melee_enemy"))
	table.insert(self.enemies, melee_enemy:new(16704,416,64,64,40,"melee_enemy"))
	table.insert(self.enemies, ranged_enemy:new(17072,416,64,64,25,"ranged_enemy"))
	table.insert(self.enemies, melee_enemy:new(17408,414,64,64,40,"melee_enemy"))
	table.insert(self.enemies, ranged_enemy:new(17680,416,64,64,25,"ranged_enemy"))
	table.insert(self.enemies, melee_enemy:new(17936,416,64,64,40,"melee_enemy"))
	table.insert(self.enemies, ranged_enemy:new(18304,400,64,64,25,"ranged_enemy"))
	table.insert(self.enemies, ranged_enemy:new(18496,400,64,64,25,"ranged_enemy"))
	table.insert(self.enemies, melee_enemy:new(18752,400,64,64,40,"melee_enemy"))
	table.insert(self.enemies, melee_enemy:new(19008,400,64,64,40,"melee_enemy"))
	table.insert(self.enemies, ranged_enemy:new(19408,416,64,64,25,"ranged_enemy"))
	table.insert(self.enemies, melee_enemy:new(19696,416,64,64,40,"melee_enemy"))
	table.insert(self.enemies, ranged_enemy:new(19776,288,64,64,25,"ranged_enemy"))
	table.insert(self.enemies, melee_enemy:new(20016,416,64,64,40,"melee_enemy"))
	table.insert(self.enemies, ranged_enemy:new(20160,272,64,64,25,"ranged_enemy"))
	table.insert(self.enemies, melee_enemy:new(20560,416,64,64,40,"melee_enemy"))
	table.insert(self.enemies, ranged_enemy:new(21008,416,64,64,25,"ranged_enemy"))
	table.insert(self.enemies, ranged_enemy:new(21328,416,64,64,25,"ranged_enemy"))
	table.insert(self.enemies, ranged_enemy:new(21520,416,64,64,25,"ranged_enemy"))
	table.insert(self.enemies, melee_enemy:new(21856,416,64,64,40,"melee_enemy"))
	table.insert(self.enemies, melee_enemy:new(22304,416,64,64,40,"melee_enemy"))
	table.insert(self.enemies, ranged_enemy:new(22624,400,64,64,25,"ranged_enemy"))
	table.insert(self.enemies, melee_enemy:new(23056,416,64,64,40,"melee_enemy"))
	table.insert(self.enemies, melee_enemy:new(23616,320,64,64,40,"melee_enemy"))
	table.insert(self.enemies, ranged_enemy:new(23552,432,64,64,25,"ranged_enemy"))
	table.insert(self.enemies, melee_enemy:new(24604,432,64,64,40,"melee_enemy"))
	table.insert(self.enemies, ranged_enemy:new(24554,400,64,64,25,"ranged_enemy"))
	table.insert(self.enemies, ranged_enemy:new(24976,400,64,64,25,"ranged_enemy"))
	table.insert(self.enemies, melee_enemy:new(25232,400,64,64,40,"melee_enemy"))
	table.insert(self.enemies, melee_enemy:new(25456,400,64,64,40,"melee_enemy"))
	table.insert(self.enemies, ranged_enemy:new(25856,400,64,64,25,"ranged_enemy"))
	table.insert(self.enemies, ranged_enemy:new(26080,400,64,64,25,"ranged_enemy"))
	table.insert(self.enemies, ranged_enemy:new(26544,400,64,64,25,"ranged_enemy"))
	table.insert(self.enemies, melee_enemy:new(26848,400,64,64,40,"melee_enemy"))
	table.insert(self.enemies, melee_enemy:new(27440,400,64,64,40,"melee_enemy"))
	table.insert(self.enemies, melee_enemy:new(27808,400,64,64,40,"melee_enemy"))
	table.insert(self.enemies, ranged_enemy:new(28096,256,64,64,25,"ranged_enemy"))
	table.insert(self.enemies, ranged_enemy:new(28336,256,64,64,25,"ranged_enemy"))
	table.insert(self.enemies, melee_enemy:new(28704,368,64,64,40,"melee_enemy"))
	table.insert(self.enemies, melee_enemy:new(28448,368,64,64,40,"melee_enemy"))
	table.insert(self.enemies, ranged_enemy:new(29488,432,64,64,25,"ranged_enemy"))
	table.insert(self.enemies, melee_enemy:new(29712,432,64,64,40,"melee_enemy"))
	table.insert(self.enemies, ranged_enemy:new(29984,432,64,64,25,"ranged_enemy"))
	table.insert(self.enemies, melee_enemy:new(30176,432,64,64,40,"melee_enemy"))
	table.insert(self.enemies, ranged_enemy:new(30544,432,64,64,25,"ranged_enemy"))
	table.insert(self.enemies, ranged_enemy:new(30896,432,64,64,25,"ranged_enemy"))
	table.insert(self.enemies, melee_enemy:new(31376,432,64,64,40,"melee_enemy"))
	table.insert(self.enemies, ranged_enemy:new(31744,352,64,64,25,"ranged_enemy"))
	table.insert(self.enemies, ranged_enemy:new(31968,320,64,64,25,"ranged_enemy"))
	table.insert(self.enemies, melee_enemy:new(31840,432,64,64,40,"melee_enemy"))
	table.insert(self.enemies, melee_enemy:new(32176,400,64,64,40,"melee_enemy"))
	table.insert(self.enemies, melee_enemy:new(32384,400,64,64,40,"melee_enemy"))

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

	for _, shop in ipairs(self.shops) do
		shop:load()
	end

	self.stage:load()

	tlm:load("images/Pop.lua", require("images.Pop"))

	gameLoop:addLoop(self)
end

function PopLevel:update(dt)
	if self.boss == nil then
		if not self.beginBossDialogue.started and player.collider:getX() >= 33512 then
			self.beginBossDialogue:startDialogue()
			currentDialogue = self.beginBossDialogue
		end

		if self.beginBossDialogue.ended then
			self.boss = popBoss:new(34000, 550, player)
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

	for _,s in ipairs(self.shops) do
		print(s)
		s:keypressed(k)
	end

end

return PopLevel
