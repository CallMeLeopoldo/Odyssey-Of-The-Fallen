local vec2 = require("source.tools.vec2")
local class = require("source.packages.middleclass")
local animation = require("source.objects.Animation")
local Menu = require("source.objects.ShopMenu")
local Shop = class("Shop")
local message = require("source.packages.dialogue-system.Message")
local dialogue = require("source.packages.dialogue-system.Dialogue")

function Shop:initialize(x,y,w,h)
    self.x, self.y = x,y
    self.w, self.h = w,h
    self.collider = world:newRectangleCollider(x+w/4, y, w/2, h)
    self.collider:setCollisionClass("Shop")
    self.collider:setType("static")
    self.animation = animation:new(x, y, sprites.shop, 105, 99, 1, 1, 1)
    self.animation2 = animation:new(x, y, sprites.cage, 64, 64, 1, 1, 1)
    self.inShop = false
    self.menu = nil
    --self.items
    --Criar classe Item
    --Cada Item tem preço, tipo, descrição
    self.collider:setPreSolve(
		function(collider_1, collider_2, contact)
				if (collider_2.collision_class == "Player" or collider_2.collision_class == "PlayerAttack") then
					contact:setEnabled(false)
				end
        end)
    
    local shopDialogueMessages = {
        message:new("Shopkeeper", "Well hello again, Mac. I didn’t think I’d see you again. What do you need now?"),
        message:new("Mac", "Nothing special, just some things for my next journey"),
        message:new("Shopkeeper", "What jorney?"),
        message:new("Mac", "I’m finding the voice for my band.")
    }
    self.shopDialogue = dialogue:new(shopDialogueMessages)

end

function Shop:load()
	renderer:addRenderer(self)
    gameLoop:addLoop(self)
end

function Shop:update(dt)
    if self.inShop then return end

    if self.collider:enter('Player') then
        print('Collision entered!')
    end

    if self.collider:stay('Player') and love.keyboard.isDown("e") then
        if not self.shopDialogue.started then
            self.shopDialogue:startDialogue()
            currentDialogue = self.shopDialogue
        end
    end

    if self.shopDialogue.started and not inDialogue then
        self.inShop = true
        if self.menu == nil then
            self.menu = Menu:new(self)
            self.menu:load(self)
        end
    end

    if self.collider:exit('Player') then
        print('Collision exited!')
    end
end

function Shop:draw()
    self.animation2:draw()
    self.animation:draw()
end

return Shop
