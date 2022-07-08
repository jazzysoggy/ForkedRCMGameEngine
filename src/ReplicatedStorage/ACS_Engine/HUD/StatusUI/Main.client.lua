repeat
	wait()
until game.Players.LocalPlayer.Character

local Engine = game.ReplicatedStorage:WaitForChild("ACS_Engine")
local ACS_WS = workspace:WaitForChild("ACS_WorkSpace")
local Evt = Engine:WaitForChild("Events")
local ServerConfig = require(Engine.GameRules:WaitForChild("Config"))
local TS = game:GetService('TweenService')
local UserInputService = game:GetService("UserInputService")
local Camera = workspace.CurrentCamera
local Players = game:GetService("Players")
local player = Players.LocalPlayer
local Char = player.Character
local Human = Char.Humanoid
local interactionmouse = script.Parent.InteractionMouse
local TextoOmbro = script.Parent.OmbroTexto

local RS = game:GetService("ReplicatedStorage")
local DoorEvent = Evt:WaitForChild("DoorEvent")

local Target = nil
local TratarAtivo = false 
local TratarCheck = false

local InteragirAtivo = false 
local InteragirCheck = false

local EquipeAtivo = false 

local PortaAtivo = false 

local Arrastando = false

local Yeet = false
local GUI = script.Parent 
local Sis = GUI.Medic_Sys

Sgui = script.Parent.Parent
player = Sgui.Parent
mouse = player:GetMouse()
mouse.TargetFilter = workspace.CurrentCamera
IgnoreList = {Camera,Char}

local ACS_Storage = workspace:WaitForChild("ACS_WorkSpace")
local DoorsFolder = ACS_Storage:FindFirstChild("Doors")
local BreachFolder = ACS_WS:FindFirstChild("Breach")
local mDistance = 5

function getNearest()
	local nearest = nil
	local minDistance = mDistance
	local Character = player.Character or player.CharacterAdded:Wait()

	for I,Door in pairs (DoorsFolder:GetChildren()) do
		if Character and Character:FindFirstChild("Torso")and Door.Door:FindFirstChild("Knob") ~= nil then
			local distance = (Door.Door.Knob.Position - Character.Torso.Position).magnitude

			if distance < minDistance then
				nearest = Door
				minDistance = distance
			end
		end
	end
	return nearest
end

function getNearestBreach()
	local nearest = nil
	local minDistance = mDistance
	local Character = player.Character or player.CharacterAdded:Wait()

	for I,Door in pairs (BreachFolder:GetChildren()) do
		if Character and Character:FindFirstChild("Torso") and Door:FindFirstChild("Destroyable") ~= nil and Door.Destroyable:FindFirstChild("Charge") ~= nil then
			local distance = (Door.Destroyable.Charge.Position - Character.Torso.Position).magnitude
			if distance < minDistance then
				nearest = Door
				minDistance = distance
			end

		end
	end
	return nearest
end



local sla = Engine.HUD.DoorTag:Clone()
local slaBreach = Engine.HUD.BreachTag:Clone()

function CheckForHumanoid(L_225_arg1)
	local L_226_ = false
	local L_227_ = nil
	if L_225_arg1 then
		if (L_225_arg1.Parent:FindFirstChild("Humanoid") or L_225_arg1.Parent.Parent:FindFirstChild("Humanoid")) then
			L_226_ = true
			if L_225_arg1.Parent:FindFirstChild('Humanoid') then
				L_227_ = L_225_arg1.Parent.Humanoid
			elseif L_225_arg1.Parent.Parent:FindFirstChild('Humanoid') then
				L_227_ = L_225_arg1.Parent.Parent.Humanoid
			end
		else
			L_226_ = false
		end	
	end
	return L_226_, L_227_
end

function ResetGui()
	TratarAtivo = false 
	TratarCheck = false

	InteragirAtivo = false 
	InteragirCheck = false

	EquipeAtivo = false
	PortaAtivo = false

	--Arrastando = false

	GUI.InteractionMenu.Tratar.SeTratar.Visible 	= false
	GUI.InteractionMenu.Tratar.OutroTratar.Visible 	= false

	GUI.InteractionMenu.Interagir.Liberar.Visible 	= false
	GUI.InteractionMenu.Interagir.SeRender.Visible 	= false
	GUI.InteractionMenu.Interagir.Revistar.Visible 	= false

	GUI.InteractionMenu.Equipes.Sair.Visible 		= false
	GUI.InteractionMenu.Equipes.Vermelho.Visible 	= false
	GUI.InteractionMenu.Equipes.Verde.Visible 		= false
	GUI.InteractionMenu.Equipes.Azul.Visible 		= false
	GUI.InteractionMenu.Equipes.Amarelo.Visible 	= false

	GUI.InteractionMenu.Porta.Abrir.Visible 		= false
	GUI.InteractionMenu.Porta.Lock.Visible 			= false
	GUI.InteractionMenu.Porta.Lockpick.Visible 		= false

	GUI.Medic_Sys.Treat.Frame.BandFrame.Visible 	= false
	GUI.Medic_Sys.Treat.Frame.MedFrame.Visible 		= false
	GUI.Medic_Sys.Treat.Frame.NeedFrame.Visible 	= false
	GUI.Medic_Sys.Treat.Frame.OtherFrame.Visible 	= false
end

UserInputService.InputBegan:Connect(function(input, gameProcessed)

	if input.KeyCode == ServerConfig.InteractionMenuKey then
		Yeet = not Yeet
		if Yeet then
			if UserInputService.MouseIconEnabled == false then
				interactionmouse.Icon.Visible = true
			end
			GUI.InteractionMenu.FLM.Modal = true
			script.Parent.InteractionMenu.Visible = true
			if ServerConfig.EnableMedSys then
				script.Parent.InteractionMenu.Tratar.Visible = true
			else
				script.Parent.InteractionMenu.Tratar.Visible = false
			end
		else
			interactionmouse.Icon.Visible = false
			GUI.InteractionMenu.FLM.Modal = false
			script.Parent.InteractionMenu.Visible = false

			ResetGui()

			Sis.Visible = false
			Char.ACS_Client.Variaveis.PlayerSelecionado.Value = nil
		end
	end
end)

GUI.InteractionMenu.Fechar.MouseButton1Click:connect(function()
	Yeet = false
	interactionmouse.Icon.Visible = false
	GUI.InteractionMenu.FLM.Modal = false
	script.Parent.InteractionMenu.Visible = false
	Arrastando = false

	ResetGui()
	Char.ACS_Client.Variaveis.PlayerSelecionado.Value = nil
	Sis.Visible = false
end)

GUI.InteractionMenu.Equipes:WaitForChild('Amarelo').MouseButton1Click:connect(function()
	local SquadName = "Delta"
	local SquadColor = Color3.fromRGB(245, 205, 48)
	Evt.Squad:FireServer(SquadName,SquadColor)
end)

GUI.InteractionMenu.Equipes:WaitForChild('Azul').MouseButton1Click:connect(function()
	local SquadName = "Charlie"
	local SquadColor = Color3.fromRGB(0, 143, 156)
	Evt.Squad:FireServer(SquadName,SquadColor)
end)

GUI.InteractionMenu.Equipes:WaitForChild('Verde').MouseButton1Click:connect(function()
	local SquadName = "Bravo"
	local SquadColor = Color3.fromRGB(75, 151, 75)
	Evt.Squad:FireServer(SquadName,SquadColor)
end)

GUI.InteractionMenu.Equipes:WaitForChild('Vermelho').MouseButton1Click:connect(function()
	local SquadName = "Alpha"
	local SquadColor = Color3.fromRGB(255, 89, 89)
	Evt.Squad:FireServer(SquadName,SquadColor)
end)

GUI.InteractionMenu.Equipes:WaitForChild('Sair').MouseButton1Click:connect(function()
	local SquadName = ""
	local SquadColor = Color3.fromRGB(255, 255, 255)
	Evt.Squad:FireServer(SquadName,SquadColor)
end)

GUI.InteractionMenu.Equipes:WaitForChild('Botao').MouseButton1Click:connect(function()
	ResetGui()
	EquipeAtivo = not EquipeAtivo
	if EquipeAtivo then
		GUI.InteractionMenu.Equipes.Sair.Visible = true
		GUI.InteractionMenu.Equipes.Vermelho.Visible = true
		GUI.InteractionMenu.Equipes.Verde.Visible = true
		GUI.InteractionMenu.Equipes.Azul.Visible = true
		GUI.InteractionMenu.Equipes.Amarelo.Visible = true
		InteragirCheck = true
	else
		GUI.InteractionMenu.Equipes.Sair.Visible = false
		GUI.InteractionMenu.Equipes.Vermelho.Visible = false
		GUI.InteractionMenu.Equipes.Verde.Visible = false
		GUI.InteractionMenu.Equipes.Azul.Visible = false
		GUI.InteractionMenu.Equipes.Amarelo.Visible = false
		InteragirCheck = false
	end
end)

GUI.InteractionMenu.Arrastar:WaitForChild('Botao').MouseButton1Click:connect(function()
	ResetGui()
	if Arrastando then
		Evt.Drag:FireServer(nil)
		Arrastando = false
	else
		Evt.Drag:FireServer(Target)
		Arrastando = true
	end
end)

GUI.InteractionMenu.Interagir:WaitForChild('SeRender').MouseButton1Click:connect(function()
	Evt.Surrender:FireServer(nil)
	Yeet = false
	interactionmouse.Icon.Visible = false
	GUI.InteractionMenu.FLM.Modal = false
	script.Parent.InteractionMenu.Visible = false
	Arrastando = false

	ResetGui()

	Sis.Visible = false
end)

GUI.InteractionMenu.Interagir:WaitForChild('Liberar').MouseButton1Click:connect(function()
	Evt.Surrender:FireServer(Target)
end)

GUI.InteractionMenu.Interagir:WaitForChild('Botao').MouseButton1Click:connect(function()
	ResetGui()
	InteragirAtivo = not InteragirAtivo
	if InteragirAtivo then
		GUI.InteractionMenu.Interagir.SeRender.Visible = true
		InteragirCheck = true
	else
		GUI.InteractionMenu.Interagir.SeRender.Visible = false
		InteragirCheck = false
	end
end)

GUI.InteractionMenu.Tratar:WaitForChild('Botao').MouseButton1Click:connect(function()
	ResetGui()
	TratarAtivo = not TratarAtivo
	if TratarAtivo then
		GUI.InteractionMenu.Tratar.SeTratar.Visible = true
		TratarCheck = true
	else
		GUI.InteractionMenu.Tratar.SeTratar.Visible = false
		TratarCheck = false
	end
end)

GUI.InteractionMenu.Tratar:WaitForChild('SeTratar').MouseButton1Click:connect(function()
	interactionmouse.Icon.Visible = false
	GUI.InteractionMenu.FLM.Modal = false
	script.Parent.InteractionMenu.Visible = false

	ResetGui()
	Char.ACS_Client.Variaveis.PlayerSelecionado.Value = nil
	Human:UnequipTools()
	Sis.Visible = true
end)

GUI.InteractionMenu.Tratar:WaitForChild('OutroTratar').MouseButton1Click:connect(function()
	interactionmouse.Icon.Visible = false
	GUI.InteractionMenu.FLM.Modal = false
	script.Parent.InteractionMenu.Visible = false

	ResetGui()
	
	Char.ACS_Client.Variaveis.PlayerSelecionado.Value = Target
	Human:UnequipTools()
	Sis.Visible = true
end)

GUI.InteractionMenu.Ombro:WaitForChild('Botao').MouseButton1Click:connect(function()
	ResetGui()

	--Evt.Ombro:FireServer(Target)
	Yeet = false
	interactionmouse.Icon.Visible = false
	GUI.InteractionMenu.FLM.Modal = false
	script.Parent.InteractionMenu.Visible = false
end)

GUI.InteractionMenu.Porta:WaitForChild('Botao').MouseButton1Click:connect(function()
	ResetGui()
	PortaAtivo = not PortaAtivo
	if PortaAtivo then
		GUI.InteractionMenu.Porta.Abrir.Visible = true
		InteragirCheck = true
	else
		GUI.InteractionMenu.Porta.Abrir.Visible = true
		InteragirCheck = false
	end
end)

GUI.InteractionMenu.Porta:WaitForChild('Abrir').MouseButton1Click:connect(function()
	local nearestDoor = getNearest()
	DoorEvent:FireServer(nearestDoor,2,nil)
end)

GUI.InteractionMenu.Porta:WaitForChild('Lock').MouseButton1Click:connect(function()
	local nearestDoor = getNearest()
	DoorEvent:FireServer(nearestDoor,3,nil)
end)

GUI.InteractionMenu.Porta:WaitForChild('Lockpick').MouseButton1Click:connect(function()
	local nearestDoor = getNearest()
	DoorEvent:FireServer(nearestDoor,4,nil)
end)

GUI.InteractionMenu.Porta:WaitForChild('Breach').MouseButton1Click:connect(function()
	ResetGui()
	Yeet = false
	interactionmouse.Icon.Visible = false
	GUI.InteractionMenu.FLM.Modal = false
	script.Parent.InteractionMenu.Visible = false
	local nearestDoor = getNearest()
	local Raio2 = Ray.new(Camera.CFrame.Position, Camera.CFrame.LookVector * 5)
	local Hit, Pos, Norm = workspace:FindPartOnRayWithIgnoreList(Raio2, IgnoreList, false, true)

	Evt.Breach:InvokeServer(2,nearestDoor,Pos,Norm,Hit)
end)

GUI.InteractionMenu.Fortify:WaitForChild('Botao').MouseButton1Click:connect(function()
	ResetGui()
	Yeet = false
	interactionmouse.Icon.Visible = false
	GUI.InteractionMenu.FLM.Modal = false
	script.Parent.InteractionMenu.Visible = false
	local nearestDoor = getNearestBreach()
	local Raio2 = Ray.new(Camera.CFrame.Position, Camera.CFrame.LookVector * 5)
	local Hit, Pos, Norm = workspace:FindPartOnRayWithIgnoreList(Raio2, IgnoreList, false, true)

	Evt.Breach:InvokeServer(3,nearestDoor,Pos,Norm,Hit)
end)

GUI.InteractionMenu.Breach:WaitForChild('Botao').MouseButton1Click:connect(function()
	ResetGui()
	Yeet = false
	interactionmouse.Icon.Visible = false
	GUI.InteractionMenu.FLM.Modal = false
	script.Parent.InteractionMenu.Visible = false
	local nearestDoor = getNearestBreach()
	local Raio2 = Ray.new(Camera.CFrame.Position, Camera.CFrame.LookVector * 5)
	local Hit, Pos, Norm = workspace:FindPartOnRayWithIgnoreList(Raio2, IgnoreList, false, true)

	Evt.Breach:InvokeServer(1,nearestDoor,Pos,Norm,Hit)
end)

GUI.InteractionMenu.Rappel:WaitForChild('Botao').MouseButton1Click:connect(function()
	ResetGui()
	Yeet = false
	interactionmouse.Icon.Visible = false
	GUI.InteractionMenu.FLM.Modal = false
	script.Parent.InteractionMenu.Visible = false

	if Char.ACS_Client.Stances.Rappeling.Value == false then
		local Raio = Ray.new(Camera.CFrame.Position, Camera.CFrame.LookVector * 12)
		local Hit, Pos = workspace:FindPartOnRayWithIgnoreList(Raio, IgnoreList, false, true)

		if player.Character ~= nil and Char.Humanoid.Health > 0 then
			Evt.Rappel.PlaceEvent:FireServer(Pos,Hit)
			Char.ACS_Client.Stances.Rappeling.Value = true
			GUI.InteractionMenu.Rappel.Botao.Text = "Cut Rappel"
		end
	else
		if player.Character ~= nil and Char.Humanoid.Health > 0 then
			Evt.Rappel.CutEvent:FireServer()
			Char.ACS_Client.Stances.Rappeling.Value = false
			GUI.InteractionMenu.Rappel.Botao.Text = "Attach Rappel"
		end
	end
end)


game:GetService("RunService").RenderStepped:connect(function()
	local Jogadors = game.Players:GetChildren()



	local Breachs = getNearestBreach()
	if Breachs ~= nil and Char.Humanoid.Health > 0 and Breachs.Destroyed.Value == false then
		if (Breachs:FindFirstChild("Destroyable") ~= nil) and Breachs.Destroyable:FindFirstChild("Charge") ~= nil then
			local Raio2 = Ray.new(Camera.CFrame.Position, Camera.CFrame.LookVector * 5)
			local Hit2, Pos2 = workspace:FindPartOnRayWithIgnoreList(Raio2, IgnoreList, false, true)



			if Char.ACS_Client.Kit.Fortifications.Value > 0 then
				if Breachs.Fortified.Value == false then
					slaBreach.Parent = Breachs
					slaBreach.Adornee = Breachs.Destroyable.Charge
					slaBreach.Frame.Frame.ImageColor3 = Color3.fromRGB(255,255,255)

					if Hit2 ~= nil and Hit2.Parent == Breachs.Destroyable then
						GUI.InteractionMenu.Fortify.Visible = true
					else
						GUI.InteractionMenu.Fortify.Visible = false
					end
				else
					GUI.InteractionMenu.Fortify.Visible = false
					slaBreach.Parent = Breachs
					slaBreach.Adornee = Breachs.Destroyable.Charge
					slaBreach.Frame.Frame.ImageColor3 = Color3.fromRGB(255,0,0)
				end
			else
				GUI.InteractionMenu.Fortify.Visible = false
			end


			if Char.ACS_Client.Kit.BreachCharges.Value > 0 then

				if Breachs.Fortified.Value == true then
					slaBreach.Parent = Breachs
					slaBreach.Adornee = Breachs.Destroyable.Charge
					slaBreach.Frame.Frame.ImageColor3 = Color3.fromRGB(255,0,0)
					GUI.InteractionMenu.Breach.Visible = false
				else
					slaBreach.Parent = Breachs
					slaBreach.Adornee = Breachs.Destroyable.Charge
					slaBreach.Frame.Frame.ImageColor3 = Color3.fromRGB(255,255,255)
					if Hit2 ~= nil and Hit2.Parent == Breachs.Destroyable then
						GUI.InteractionMenu.Breach.Visible = true
					else
						GUI.InteractionMenu.Breach.Visible = false
					end
				end
			end

		else
			GUI.InteractionMenu.Breach.Visible = false
		end
	else
		slaBreach.Parent = nil
		GUI.InteractionMenu.Breach.Visible = false
		GUI.InteractionMenu.Fortify.Visible = false
	end
	--print(Breachs)


	local Porta = getNearest()
	if Porta ~= nil and Char.Humanoid.Health > 0 then
		GUI.InteractionMenu.Porta.Visible = true

		if Porta.Destroyed.Value == false and Char.ACS_Client.Kit.BreachCharges.Value > 0  then
			local Raio2 = Ray.new(Camera.CFrame.Position, Camera.CFrame.LookVector * 5)
			local Hit2, Pos2 = workspace:FindPartOnRayWithIgnoreList(Raio2, IgnoreList, false, true)
			if PortaAtivo == true and Hit2 ~= nil and Hit2.Parent.Name == "Door" then
				GUI.InteractionMenu.Porta.Breach.Visible = true
			else
				GUI.InteractionMenu.Porta.Breach.Visible = false
			end
		end

		if Porta.Locked.Value == true then
			sla.Frame.Frame.ImageColor3 = Color3.fromRGB(255,0,0)
			GUI.InteractionMenu.Porta.Abrir.Imagem.ImageColor3 = Color3.fromRGB(255,0,0)
			GUI.InteractionMenu.Porta.Lock.Text = "Unlock door"
		else
			sla.Frame.Frame.ImageColor3 = Color3.fromRGB(255,255,255)
			GUI.InteractionMenu.Porta.Abrir.Imagem.ImageColor3 = Color3.fromRGB(255,255,255)
			GUI.InteractionMenu.Porta.Lock.Text = "Lock door"
		end

		sla.Parent = Porta

		if (Porta.Door:FindFirstChild("Knob") ~= nil) and (Porta.Door:FindFirstChild("DoorHinge") ~= nil) then
			sla.Adornee = Porta.Door.Knob
		else
			GUI.InteractionMenu.Porta.Visible = false
			PortaAtivo = false
			GUI.InteractionMenu.Porta.Abrir.Visible = false
			GUI.InteractionMenu.Porta.Lock.Visible = false
			GUI.InteractionMenu.Porta.Lockpick.Visible = false
			GUI.InteractionMenu.Porta.Breach.Visible = false
			sla.Parent = nil
		end

		if PortaAtivo == true then
			if Porta:FindFirstChild("RequiresKey") then
				if Char:FindFirstChild(Porta.RequiresKey.Value) or player.Backpack:FindFirstChild(Porta.RequiresKey.Value) then
					GUI.InteractionMenu.Porta.Lock.Visible = true
				end
			end
		end

	else
		GUI.InteractionMenu.Porta.Visible = false
		PortaAtivo = false
		GUI.InteractionMenu.Porta.Abrir.Visible = false
		GUI.InteractionMenu.Porta.Lock.Visible = false
		GUI.InteractionMenu.Porta.Lockpick.Visible = false
		GUI.InteractionMenu.Porta.Breach.Visible = false
		sla.Parent = nil
	end


	if mouse.Target then
		if (player.Character:FindFirstChild("HumanoidRootPart")) and (player.Character.HumanoidRootPart.Position - mouse.Target.Position).magnitude <= 100 then
			if game.Players:FindFirstChild(mouse.Target.Parent.Name) or game.Players:FindFirstChild(mouse.Target.Parent.Parent.Name) then
				local playera = game.Players:FindFirstChild(mouse.Target.Parent.Name)
				if playera == nil then
					playera = game.Players:FindFirstChild(mouse.Target.Parent.Parent.Name)
				end
				if playera.Team == player.Team then
					interactionmouse.Fundo.Visible = true
					interactionmouse.Fundo.Username.Text = playera.Name
				else
					interactionmouse.Fundo.Visible = false
				end
			else
				interactionmouse.Fundo.Visible = false
			end
		else
			interactionmouse.Fundo.Visible = false
		end
	else
		interactionmouse.Fundo.Visible = false
	end

	if Yeet then

		local Raio = Ray.new(Camera.CFrame.Position, Camera.CFrame.LookVector * 6)
		local Hit, Pos = workspace:FindPartOnRayWithIgnoreList(Raio, IgnoreList, false, true)

		if not Arrastando then
			GUI.InteractionMenu.Arrastar.Botao.Text = "Drag"
		else
			GUI.InteractionMenu.Arrastar.Botao.Text = "Release"
		end

		if Hit then
			local FoundHuman,VitimaHuman = CheckForHumanoid(Hit)
			if FoundHuman == true and VitimaHuman.Health > 0 and game.Players:GetPlayerFromCharacter(VitimaHuman.Parent) then
				GUI.InteractionMenu.Ombro.Visible = true
				Target = game.Players:GetPlayerFromCharacter(VitimaHuman.Parent)
				if TratarCheck then
					GUI.InteractionMenu.Tratar.OutroTratar.Visible = true
					GUI.InteractionMenu.Tratar.OutroTratar.TextLabel.Text = VitimaHuman.Parent.Name
				end
				if InteragirCheck and VitimaHuman.Parent.ACS_Client:GetAttribute("Surrender") then
					GUI.InteractionMenu.Interagir.Liberar.Visible = true
					GUI.InteractionMenu.Interagir.Revistar.Visible = true
				end
				if VitimaHuman.Parent.ACS_Client:GetAttribute("Collapsed") or VitimaHuman.Parent.ACS_Client.Stances.Algemado.Value == true and not Arrastando then
					GUI.InteractionMenu.Arrastar.Visible = true
				end
			else
				GUI.InteractionMenu.Tratar.OutroTratar.Visible = false
				GUI.InteractionMenu.Ombro.Visible = false
				GUI.InteractionMenu.Interagir.Liberar.Visible = false
				GUI.InteractionMenu.Interagir.Revistar.Visible = false
				if not Arrastando then
					GUI.InteractionMenu.Arrastar.Visible = false
				end
				Target = nil
			end
		else
			GUI.InteractionMenu.Tratar.OutroTratar.Visible = false
			GUI.InteractionMenu.Ombro.Visible = false
			GUI.InteractionMenu.Interagir.Liberar.Visible = false
			GUI.InteractionMenu.Interagir.Revistar.Visible = false
			if not Arrastando then
				GUI.InteractionMenu.Arrastar.Visible = false
			end
			Target = nil
		end
	end

	if Yeet and (Char.ACS_Client.Stances.Can_Rappel.Value == true or Char.ACS_Client.Stances.Rappeling.Value == true) then

		if Char.ACS_Client.Stances.Rappeling.Value == true then
			GUI.InteractionMenu.Rappel.Visible = true
		else
			local Raio = Ray.new(Camera.CFrame.Position, Camera.CFrame.LookVector * 12)
			local Hit, Pos = workspace:FindPartOnRayWithIgnoreList(Raio, IgnoreList, false, true)

			if Hit then
				GUI.InteractionMenu.Rappel.Visible = true
			else
				GUI.InteractionMenu.Rappel.Visible = false	
			end
		end
	else
		GUI.InteractionMenu.Rappel.Visible = false	
	end

end)

local function onMouseMove()
	local positionX = mouse.X
	local positionY = mouse.Y
	interactionmouse.Position =UDim2.new(0,positionX,0,positionY)
end
mouse.Move:Connect(onMouseMove)

--[[Evt.Ombro.OnClientEvent:Connect(function(Nome)
	TextoOmbro.Text = Nome .." tapped your shoulder!"
	TextoOmbro.TextTransparency = 0
	TextoOmbro.TextStrokeTransparency = 0
	TS:Create(TextoOmbro, TweenInfo.new(5), {TextTransparency = 1,TextStrokeTransparency = 1} ):Play()
end)]]