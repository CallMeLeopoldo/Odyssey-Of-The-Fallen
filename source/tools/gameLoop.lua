local GameLoop = {}

local num_of_layers = 5
local insert = table.insert
local remove = table.remove

function GameLoop:create()
	local gameLoop = {}

	gameLoop.tickers = {}

	function gameLoop:addLoop(obj)
		insert(self.tickers, obj)
	end

	function gameLoop:removeLoop(obj)
		for i = 0, #self.tickers do
        	if self.tickers[i] == obj then
            	remove(self.tickers, i)
        	end
    	end
	end

	function gameLoop:update(dt)
		for tickers = 0, #self.tickers do
			local obj = self.tickers[tickers]
			if obj ~= nil then
				obj:update(dt)
			end
		end
	end

	return gameLoop
end

return GameLoop