local class = require("source.packages.middleclass")
local Level = require("source.objects.Level")
local popBoss = require("source.objects.PopBoss")
local melee_enemy = require("source.objects.melee_enemy")
local ranged_enemy = require("source.objects.ranged_enemy")

local PopLevel = class("PopLevel", Level)

function PopLevel:initialize()
	print("yo")
	self.enemies = {}

	table.insert(self.enemies, melee_enemy:new(450,360,64,64,40,"melee_enemy"))
	table.insert(self.enemies, ranged_enemy:new(1500,300,64,64,25,"ranged_enemy"))
	table.insert(self.enemies, ranged_enemy:new(1400,300,64,64,25,"ranged_enemy2"))

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
