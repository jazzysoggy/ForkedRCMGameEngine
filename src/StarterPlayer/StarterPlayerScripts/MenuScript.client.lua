local menu = workspace:WaitForChild("Menu").Menu

local left = menu:WaitForChild("Left",9999)
local right = menu:WaitForChild("Right",9999)

local leftGUI = left.SurfaceGui.Frame
local rightGUI = right.SurfaceGui.Frame

local playButton = leftGUI.TopBar.Play
local shopButton = leftGUI.TopBar.Shop
local creditsButton = leftGUI.TopBar.Credits

local currentMenu

local optionTemplate = script:WaitForChild("TeamOption")

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local player = game:GetService("Players")
local CAS 			= game:GetService("ContextActionService")
local Player = player.LocalPlayer
local ServerStorage = game:GetService("ServerStorage")
local Character = Player.Character or Player.CharacterAdded:Wait()
local StarterGui = game:GetService("StarterGui")

local camera = workspace.CurrentCamera

local cameraPosition = menu.CameraPosition

local menuEvent = ReplicatedStorage.MenuEvent
local rankEvent = ReplicatedStorage.RankEvent
local newsEvent = ReplicatedStorage.NewsEvent
local teamEvent = ReplicatedStorage.TeamEvent
local TeamItemList = require(ReplicatedStorage.ItemAllowanceList)

local playerTeams = {}
local teamSpecial = {}
local teamRank = {}
local teamIndex = 1
local rankIndex = 1
local primaryIndex = 1
local secondaryIndex = 1
local equipmentIndex = 1
local equipment2Index = 1
local selectedTeam = "Class-D"
local selectedRank = "Class-D"
local allowedAttachments, allowedPrimary, allowedSecondary, allowedEquipment, allowedEquipment2
local selectedPrimary, selectedSecondary, selectedEquipment, selectedEquipment2

local teamChosen = menu.TeamChoosen

local TeamNames = {
	-- TEAM NAMES MUST MATCH EXACTLY AS YOU HAVE
	CD = "Class-D", --Done
	CE = "Class-E", --Not Done
	CI = "Chaos Insurgency", --Done
	DEA = "Department of External Affairs", --Done
	FP = "Foundation Personnel", --Done
	IA = "Intelligence Agency", --Done
	ISD = "The Freedom Fighters", --Not Done
	MD = "Medical Department", --Done
	MTF = "Mobile Task Force", --Done
	SD = "Security Department", --Done
	ScD = "Scientific Department", --Done
	EC = "Ethics Committee",
	CL = "Documental Department", --Documental
	RD = "Rapid Response Team", --Rapid Response
	ET = "Engineering and Technical",
	AD = "Administrative Department", --Done
}

local function addTeams()

	for i, v in pairs(leftGUI.ChooseTeam:GetChildren()) do
		if v.Name ~= "UIListLayout" then
			v:Remove()			
		end
	end

	for i, v in pairs(playerTeams) do
		local clone = optionTemplate:Clone()

		clone.Text = v

		clone.Parent = leftGUI.ChooseTeam

		clone.MouseButton1Click:Connect(function()
			menuEvent:FireServer("choseTeam", clone.Text)
			camera.CameraType = Enum.CameraType.Custom

			teamChosen.Value = true

			game:GetService("ReplicatedStorage").RegiveCard:FireServer()		
		end)
	end
end

local function getPlayerTeam()
	menuEvent:FireServer("team")
	teamEvent.OnClientEvent:Connect(function(teamTable)
		if teamTable then
			playerTeams = teamTable
			selectedTeam = playerTeams[#playerTeams]
		end
	end)
	addTeams()
end

local function getNewsToDisplay()
	menuEvent:FireServer("news")
	newsEvent.OnClientEvent:Connect(function(newsString)
		if newsString then
			rightGUI.Feed.TextLabel.Text = newsString			
		end
	end)
end

local function getPlayerRank()
	menuEvent:FireServer("rank", selectedTeam)
	rankEvent.OnClientEvent:Connect(function(rank)
		if rank then
			teamRank = rank		
		end
	end)
	selectedRank = teamRank[#teamRank]
end

creditsButton.MouseButton1Click:Connect(function()
	if currentMenu == leftGUI.Credits then
		return
	end

	if currentMenu then
		currentMenu.Visible = false
		currentMenu.Active = false		
	end

	currentMenu = leftGUI.Credits	

	currentMenu.Visible = true
	currentMenu.Active = true
end)

shopButton.MouseButton1Click:Connect(function()
	if currentMenu == leftGUI.Shop then
		return
	end

	if currentMenu then
		currentMenu.Visible = false
		currentMenu.Active = false		
	end

	currentMenu = leftGUI.Shop	

	currentMenu.Visible = true
	currentMenu.Active = true
end)

playButton.MouseButton1Click:Connect(function()
	addTeams()

	if currentMenu == leftGUI.ChooseTeam then
		return
	end

	if currentMenu then
		currentMenu.Visible = false
		currentMenu.Active = false		
	end


	currentMenu = leftGUI.ChooseTeam	


	currentMenu.Visible = true
	currentMenu.Active = true


end)


local function loadAvatar()

	Character.Archivable = true	

	local clone = Character:Clone()

	clone.Parent = menu
	
	clone.Name = "Roblox"

	clone:WaitForChild("HumanoidRootPart").CFrame = menu.Roblox:WaitForChild("HumanoidRootPart").CFrame

	menu.Roblox:Remove()
end

getNewsToDisplay()

getPlayerTeam()

if not menu.TeamChoosen.Value then
	camera.CameraType = Enum.CameraType.Scriptable

	camera.CFrame = cameraPosition.CFrame	
end

	
repeat wait() until game:IsLoaded()
loadAvatar()


local pressed = false

function handleAction(actionName, inputState, inputObject)
	if actionName == "Menu" and inputState == Enum.UserInputState.End then
		if not pressed then
			pressed = true	
			coroutine.resume(coroutine.create(function() 
				wait(1)
				if pressed then
					pressed = false
				end			
			end))
		else
			if camera.CameraType == Enum.CameraType.Custom then
				teamChosen.Value = false
				
				camera.CameraType = Enum.CameraType.Scriptable

				camera.CFrame = cameraPosition.CFrame	



			else
				
				teamChosen.Value = true
				
				camera.CameraType = Enum.CameraType.Custom 

			end

		end		
	end
end











--Code to save for later
--local function getItemsAllowed()
--	allowedPrimary = TeamItemList.teamAllowedPrimary[selectedTeam][teamRank]
--	allowedSecondary = TeamItemList.teamAllowedSecondary[selectedTeam][teamRank]
--	allowedEquipment = TeamItemList.teamAllowedEquipment[selectedTeam][teamRank]
--	allowedEquipment2 = TeamItemList.teamAllowedEquipment2[selectedTeam][teamRank]
--	allowedAttachments = TeamItemList.TeamAllowedAttachmentsPerRank[selectedTeam][teamRank]
--end



--local function setPlayerTeam()
--	teamIndex += 1
--	if teamIndex <= #playerTeams then
--		selectedTeam = playerTeams[teamIndex]
--	else
--		teamIndex = 1
--		selectedTeam = playerTeams[teamIndex]
--	end
--end

--local function setPlayerRank()
--	rankIndex += 1
--	if rankIndex <= #playerTeams then
--		selectedRank = teamRank[rankIndex]
--	else
--		rankIndex = 1
--		selectedRank = teamRank[rankIndex]
--	end
--end

--local function setPrimary()
--	primaryIndex += 1
--	if primaryIndex <= #allowedPrimary then
--		selectedPrimary = allowedPrimary[primaryIndex]
--	else
--		primaryIndex = 1
--		selectedPrimary = allowedPrimary[primaryIndex]
--	end
--end

--local function setSecondary()
--	secondaryIndex += 1
--	if secondaryIndex <= #allowedSecondary then
--		selectedSecondary = allowedSecondary[secondaryIndex]
--	else
--		secondaryIndex = 1
--		selectedSecondary = allowedSecondary[secondaryIndex]
--	end
--end

--local function setEquipment()
--	equipmentIndex += 1
--	if equipmentIndex <= #allowedEquipment then
--		selectedEquipment = allowedEquipment[equipmentIndex]
--	else
--		equipmentIndex = 1
--		selectedEquipment = allowedEquipment[equipmentIndex]
--	end
--end

--local function setEquipment2()
--	equipment2Index += 1
--	if equipment2Index <= #allowedEquipment2 then
--		selectedEquipment2 = allowedEquipment2[equipment2Index]
--	else
--		equipment2Index = 1
--		selectedEquipment2 = allowedEquipment2[equipment2Index]
--	end
--end