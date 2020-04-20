local class = require("source.packages.middleclass")

local Item = class("Item")

function Item:initialize(name, i_type, price, description)
    self.type = i_type
    self.name = name
    self.price = price
    self.description = description
end

function Item:load()

end

function Item:update()
    
end

function Item:draw()

end

function Item:remove()

end

return Item