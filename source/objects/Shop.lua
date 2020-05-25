local class = require("source.packages.middleclass")
local animation = require("source.objects.Animation")
local message = require("source.packages.dialogue-system.Message")
local dialogue = require("source.packages.dialogue-system.Dialogue")
local shopMenu = require("source.objects.ShopMenu")

local Shop = class("Shop")

function Shop:initialize(x, y, w, h)
	self.x = x
	self.y = y
	
	self.animation = animation:new(x, y, sprites.shop, 105, 99, 1, 1, 1)

	self.collider = world:newRectangleCollider(x + w/4, y, w/2, h)
	self.collider:setObject(self)
	self.collider:setCollisionClass("Shop")
	self.collider:setType("static")
	self.collider:setPreSolve(
		function(c1, c2, contact) 
			if (c2.collision_class == 'Player' or c2.collision_class == 'PlayerAttack') then
				contact:setEnabled(false)
			end
			if (c2.collision_class == 'Player') then
				c1:getObject().inContact = true
			end
		end
	)

	local shopDialogueMessages = {
		message:new("Shopkeeper", "Well hello again, Mac. I didn’t think I’d see you again. What do you need now?"),
		message:new("Mac", "Nothing special, just some things for my next journey"),
		message:new("Shopkeeper", "What jorney?"),        
		message:new("Mac", "I’m finding the voice for my band.") 
	}
	self.shopDialogue = dialogue:new(shopDialogueMessages)

	self.shopMenu = shopMenu:new()
end

function Shop:load()
	gameLoop:addLoop(self)
	renderer:addRenderer(self)
end

function Shop:update(dt)
	if self.collider:exit('Player') then
		self.inContact = false
	end

	if self.shopDialogue.ended and not inShop then
		inShop = true
		currentMenu = self.shopMenu 
	end
end

function Shop:keypressed(k)
	if k == "e" then
		if self.inContact and not self.shopDialogue.started then
			self.shopDialogue:startDialogue()
			currentDialogue = self.shopDialogue
		end
	end
end

function Shop:draw()
	self.animation:draw()
end

return Shop