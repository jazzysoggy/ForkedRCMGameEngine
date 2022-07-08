local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Players = game:GetService("Players")

local Teams = game:GetService("Teams")

local ServerStorage = game:GetService("ServerStorage")
local Modules = ServerStorage.Modules
local RankInformation = require(Modules.RankInformation)



local menuEvent = ReplicatedStorage.MenuEvent
local rankEvent = ReplicatedStorage.RankEvent
local newsEvent = ReplicatedStorage.NewsEvent
local teamEvent = ReplicatedStorage.TeamEvent






local TeamRequirements = {
	--REQUIREMENTS TO JOIN TEAM
	-- Group = GroupId, MinRank = Minimum Rank in group
--	{Group = 4934896, MinRank = 0, Name = "Class-D"}, --CD
	{Group = 0, MinRank = 1, Name = "Class-F"},       --CE
	{Group = 0, MinRank = 1, Name = "Class-E"},       --CE
	{Group = 7934624, MinRank = 1, Name = "Site Regulations"}, --SR
	{Group = 4934896, MinRank = 4, Name = "Foundation Personnel"}, --FP
	{Group = 5197725, MinRank = 1, Name = "Military And Security Affairs"}, --MSA
	{Group = 9085216, MinRank = 1, Name = "Unit Of Medical And Scientific Studies"}, --UMSS
	{Group = 5286128, MinRank = 1, Name = "Rapid Response Team"}, --Rapid Responce
	{Group = 5197744, MinRank = 1, Name = "[REDACTED]"},       --CID
	{Group = 4860829, MinRank = 1, Name = "Administrative Department"}, --AD
	{Group = 7114319, MinRank = 1, Name = "Chaos Insurgency"},       --ENT
	{Group = 13389040, MinRank = 2, Name = "The Freedom Fighters"},  
}

local function returnTeam(player)
	local toReturn = {"Class-D"}
	
	for i,v in pairs(TeamRequirements) do
		if player:IsInGroup(v.Group) then
			if player:GetRankInGroup(v.Group) >= v.MinRank then
				if (RankInformation:FullNameToTeam(v.Name)) then
					table.insert(toReturn, v.Name)
				end
			end
		end
	end
	
	teamEvent:FireClient(player,toReturn)
end

local function getNewsToDisplay(player)
	newsEvent:FireClient(player, "Coming Soon")
end

local function pickTeam(player, arg, team)
	if player then
		local chosenTeam = Teams:FindFirstChild(RankInformation:FullNameToTeam(team))
		player.Team = chosenTeam
		for i,v in pairs(player.Backpack:GetChildren()) do
			v:Remove()
		end
		player:LoadCharacter()
		for i,v in pairs(chosenTeam:GetChildren()) do			
			if not player.Backpack:FindFirstChild(v.Name) then
				local clone = v:Clone()
				clone.Parent = player.Backpack				
			end
		end
		game:GetService("ServerStorage").RegiveCard:Fire(player)
	end
end

local function reload(player)
	for i,v in pairs(player.Backpack:GetChildren()) do
		v:Remove()
	end
	player:LoadCharacter()
	game:GetService("ServerStorage").RegiveCard:Fire(player)
end

menuEvent.OnServerEvent:Connect(function(player, arg, ...)
	if arg == "team" then
		returnTeam(player)
	elseif arg == "news" then
		getNewsToDisplay(player)
	elseif arg == "choseTeam" then
		pickTeam(player, arg, ...)
	elseif arg == "reloadCharacter" then
		reload(player)
	end
end)

Players.PlayerAdded:Connect(function(player)
	player.CharacterAdded:Connect(function(char)
		local team = player.Team.Name
		
		local teamUnderTeam = Teams:FindFirstChild(team)
		
		for i,v in pairs(teamUnderTeam:GetChildren()) do
			local clone = teamUnderTeam:Clone()
			clone.Parent = player.Backpack
		end
	end)
end)