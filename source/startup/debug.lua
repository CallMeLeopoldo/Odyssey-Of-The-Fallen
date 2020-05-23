nMelleAttacks = 0
nRangedAttacks = 0
nHitsTaken = 0
nHitsDealt = 0
nCombosUsed = 0
nDucksPerformed = 0



function SaveToFile() 
	local file = love.filesystem.newFile("instrumentation.txt")
	file:open("a")
	file:write("Run " .. os.date("%c") .. ":\n\n")
	file:close()
end

