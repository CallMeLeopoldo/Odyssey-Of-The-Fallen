local class = require("source.packages.middleclass")
local Item = require("source.objects.Item")
local listbox = require("source.packages.listbox")
local ShopMenu = class("Screen")

function ShopMenu:initialize(shop)

    local hell = Item:new("Hell's Blazes", "passive", 100,"A worshiping flame from the Underworld itself" )
    local jazz = Item:new("Jazzy Blues", "passive", 150, "It grooves like B.B.King")
    self.items = { hell, jazz}
    self.currentChoice = 0
    self.shop = shop

    local tlist={
        x=200, y=100,
        font=love.graphics.newFont(8),ismouse=true,
        rounded=true,
        w=200,h=300,showindex=true}

    self.lastKeyPressed = nil
    self.timerPress = 0
    --listbox:newprop(tlist)
    --for _,item in ipairs(self.items) do
    --    listbox:additem(item.name, "HELLO BUDDY")
    --end
end

function ShopMenu:load()
    gameLoop:addLoop(self)
    renderer:addRenderer(self, 5)
end

function ShopMenu:update(dt)
    self.timerPress = self.timerPress - dt
    if (love.keyboard.isDown("up")) then
        if (self.lastKeyPressed ~= "up" or self.timerPress <= 0) then
            self.currentChoice = (self.currentChoice + 1) % #self.items
            self.lastKeyPressed = "up"
            self.timerPress = 0.5
        end
    elseif (love.keyboard.isDown("down")) then
        if (self.lastKeyPressed ~= "down" or self.timerPress <= 0) then
            self.lastKeyPressed = "down"
            self.currentChoice = (self.currentChoice - 1) % #self.items
            self.timerPress = 0.5
        end
    elseif (love.keyboard.isDown("z") or love.keyboard.isDown("return")) then
        --self.items[self.currentChoice + 1][2]()
    elseif (love.keyboard.isDown("x") or love.keyboard.isDown("escape")) then
        self.shop.shopDialogue:restart()
        self.shop.inShop = false
        self.shop.menu = nil
        self:remove()
        self = nil
    end
end

function ShopMenu:draw()
    local ww = love.graphics.getWidth() * 0.5
    local wh = love.graphics.getHeight() * 0.5
    local leftMargin = 10
    local topMargin = 10

    love.graphics.setColor(0, 0, 0)
    love.graphics.rectangle("fill", ww/2 , wh/2 ,ww, wh)

    local x, y = ww/2 + leftMargin, wh/2 + topMargin
    for i, item in ipairs(self.items) do
        if (self.currentChoice == i) then
            love.graphics.setColor(0, 0, 1)
            love.graphics.rectangle("fill", x-1, y - 1, (ww/3) + 2, (wh/3) + 2)
        end
        love.graphics.setColor(0.4, 0.4, 0.4)
        
        love.graphics.rectangle("fill", x, y, ww / 3, wh / 3)
        
        love.graphics.setColor(1, 1, 1)
        love.graphics.print(item.name, x, y)
    
        y = y + wh/3 + topMargin
    end

    local newx = (ww/2) + (ww/3) + 2*leftMargin
    local newy = wh/2 + topMargin

    love.graphics.setColor(0.4, 0.4, 0.4)
    love.graphics.rectangle("fill", newx , newy, ww / 1.8, wh - 2*(topMargin) )
    love.graphics.setColor(1, 1, 1)
    love.graphics.print(self.items[self.currentChoice+1].description, newx, newy)
    --listbox:draw()
end

function ShopMenu:remove()
    gameLoop:removeLoop(self)
    renderer:removeRenderer(self, 5)
end

return ShopMenu