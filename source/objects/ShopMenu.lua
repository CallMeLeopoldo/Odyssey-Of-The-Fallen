local class = require("source.packages.middleclass")
local Item = require("source.objects.Item")
local listbox = require("source.packages.listbox")

local ShopMenu = class("Screen")

function ShopMenu:initialize(shop)

    local hell = Item:new("Hell's Blazes", "passive", 100,"A worshiping flame from the Underworld itself" )
    local jazz = Item:new("Jazzy Blues", "passive", 150, "It grooves like B.B.King")

    self.items = { hell, jazz }
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
end

function ShopMenu:draw()
    font = love.graphics.newFont("fonts/manaspc.ttf", 15)
    love.graphics.setFont(font)

    local ww = love.graphics.getWidth()
    local wh = love.graphics.getHeight()
    local leftMargin = 10
    local topMargin = 10

    local backQuad = love.graphics.newQuad(800, 0, 717, 453, 1517, 510)
    love.graphics.draw(sprites.shopMenu, backQuad, (ww-717)/2, (wh-453)/2)

    local borderQuad = love.graphics.newQuad(0, 0, 800, 510, 1517, 510)
    love.graphics.draw(sprites.shopMenu, borderQuad, (ww-800)/2 , (wh-510)/2)

    ww = ww/2
    wh = wh/2

    local x, y = ww/2 + leftMargin, wh/2 + topMargin
    for i, item in ipairs(self.items) do
        if (self.currentChoice + 1 == i) then
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
    love.graphics.rectangle("fill", ww , wh/2, ww/1.8, wh - 2*(topMargin) )
    love.graphics.setColor(1, 1, 1)
    love.graphics.printf(self.items[self.currentChoice+1].name, ww, wh/2, wh/1.8)
    love.graphics.printf("Description: " .. self.items[self.currentChoice+1].description, ww, wh, ww/1.8)
    love.graphics.printf("Cost: " .. self.items[self.currentChoice+1].price, ww, wh + 100, ww/1.8)
end

function ShopMenu:keypressed(k)
    if (love.keyboard.isDown("up")) then
        self.currentChoice = (self.currentChoice + 1) % #self.items
    elseif (love.keyboard.isDown("down")) then
            self.currentChoice = (self.currentChoice - 1) % #self.items
    elseif (love.keyboard.isDown("z") or love.keyboard.isDown("return")) then
        --self.items[self.currentChoice + 1][2]()
    elseif (love.keyboard.isDown("x") or love.keyboard.isDown("escape")) then
        currentDialogue:restart()
        inShop = false
    end
end

function ShopMenu:remove()
end

return ShopMenu