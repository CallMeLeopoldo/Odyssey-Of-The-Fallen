local class = require("source.packages.middleclass")
local Level = require("source.objects.Level")
local popBoss = require("source.objects.PopBoss")
local melee_enemy = require("source.objects.melee_enemy")
local ranged_enemy = require("source.objects.ranged_enemy")

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


	self.boss = nil
end

function PopLevel:load()
	for _, enemy in ipairs(self.enemies) do
		enemy:load()
	end

	tlm:load("images/Pop.lua", require("images.Pop"))

	gameLoop:addLoop(self)
end

function PopLevel:update()
	if self.boss == nil and player.collider:getX() >= 9032 then
		self.boss = popBoss:new(9600, 550, player)
		self.boss:load()
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

return PopLevel
