function SaveToFile()
	player.overallaccuracy = player.accuracytotal/player.accuracyincrement
	local file = love.filesystem.newFile("instrumentation.txt")
	file:open("a")
	file:write("Run " .. os.date("%c") .. ":\n\n")
	for i=1, 30 do
		file:write("Number of Melee Attacks" .. i .. ":" .. player.nMelleAttacks[i] .. "\n")
		file:write("Number of Ranged Attacks" .. i .. ":" .. player.nRangedAttacks[i] .. "\n")
		file:write("Number of Hits Taken" .. i .. ":" .. player.nHitsTaken[i] .. "\n")
		file:write("Number of Hits Dealt" .. i .. ":" .. player.nHitsDealt[i] .. "\n")
		file:write("Number of Combos Used" .. i .. ":" .. player.nCombosUsed[i] .. "\n")
		file:write("Number of Ducks Performed" .. i .. ":" .. player.nDucksPerformed[i] .. "\n")
		file:write("Number of Deaths" .. i .. ":" .. player.nDeaths[i] .. "\n")
		file:write("Number of Jumps" .. i .. ":" .. player.nJumps[i] .. "\n")
		file:write("Number of Melee Enemies Defeated" .. i .. ":" .. player.nMeleeDefeated[i] .. "\n")
		file:write("Number of Ranged Enemies Defeated" .. i .. ":" .. player.nRangedDefeated[i] .. "\n")
		file:write("Number of Dialogues Skipped" .. i .. ":" .. player.nDialoguesSkipped[i] .. "\n")
	end
	file:write("Number of Bosses Defeated:" .. player.nBossesDefeated .. "\n")
	file:write("Overall Accuracy:" .. player.overallaccuracy .. "\n")
	file:close()
end
