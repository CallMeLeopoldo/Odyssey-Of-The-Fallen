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

	function gameLoop:update(dt)
		for tickers = 0, #self.tickers do
			local obj = self.tickers[tickers]
			if obj ~= nil then
				obj:tick(dt)
			end
		end
	end

	return gameLoop
end

return GameLoop