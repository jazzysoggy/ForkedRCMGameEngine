repeat
	wait()
until game.Players.LocalPlayer.Character

local TS = game:GetService("TweenService")
local RS = game:GetService("RunService")

local player 	= game.Players.LocalPlayer
local Char 		= player.Character or player.CharacterAdded:Wait()
local mouse 	= player:GetMouse()
local cam 		= workspace.CurrentCamera
local Human 	= Char.Humanoid
local Saude 	= Char.ACS_Client

local MedicSystem 	= game.ReplicatedStorage.ACS_Engine
local Functions 	= MedicSystem.Events.MedSys

local Target 	= Char.ACS_Client.Variaveis.PlayerSelecionado
local PTexto 	= script.Parent.Stats.Patient
PTexto.Text 	= player.Name

local Timer 		= script.Parent.Treat.Frame.Progress.Bar

local PainKiller 		= Char.ACS_Client.Kit.PainKiller
local Bandage 		= Char.ACS_Client.Kit.Bandage
local Splint 		= Char.ACS_Client.Kit.Splint
local Tourniquet 	= Char.ACS_Client.Kit.Tourniquet
local EnergyShot 	= Char.ACS_Client.Kit.EnergyShot
local Epinephrine 	= Char.ACS_Client.Kit.Epinephrine
local Morphine 		= Char.ACS_Client.Kit.Morphine
local SacoDeSangue 	= Char.ACS_Client.Kit.BloodBag

local PainKillerQnt 	 = script.Parent.Medkit.ScrollFrame.Painkiller.Count
local BandageQnt 	 = script.Parent.Medkit.ScrollFrame.Bandage.Count
local SplintQnt		 = script.Parent.Medkit.ScrollFrame.Splint.Count
local TourniquetQnt  = script.Parent.Medkit.ScrollFrame.Tourniquet.Count
local EnergyShotQnt  = script.Parent.Medkit.ScrollFrame.Energy.Count
local EpinephrineQnt  = script.Parent.Medkit.ScrollFrame.Epinephrine.Count
local MorphineQnt	 = script.Parent.Medkit.ScrollFrame.Morphine.Count
local SacoDeSangueQnt= script.Parent.Medkit.ScrollFrame.BloodBag.Count

-----------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------
PainKillerQnt.Text 	= PainKiller.Value
BandageQnt.Text 	= Bandage.Value
EnergyShotQnt.Text 	= EnergyShot.Value
EpinephrineQnt.Text = Epinephrine.Value
MorphineQnt.Text 	= Morphine.Value
SplintQnt.Text 		= Splint.Value
TourniquetQnt.Text 	= Tourniquet.Value

PainKiller.Changed:Connect(function()
	PainKillerQnt.Text = PainKiller.Value
end)

Bandage.Changed:Connect(function()
	BandageQnt.Text = Bandage.Value
end)

Splint.Changed:Connect(function()
	SplintQnt.Text = Splint.Value
end)

Tourniquet.Changed:Connect(function()
	TourniquetQnt.Text = Tourniquet.Value
end)

EnergyShot.Changed:Connect(function()
	EnergyShotQnt.Text = EnergyShot.Value
end)

Epinephrine.Changed:Connect(function()
	EpinephrineQnt.Text = Epinephrine.Value
end)

Morphine.Changed:Connect(function()
	MorphineQnt.Text = Morphine.Value
end)

SacoDeSangue.Changed:Connect(function()
	SacoDeSangueQnt.Text = SacoDeSangue.Value
end)

Target.Changed:Connect(function(Valor)
	if Valor == nil then
		PTexto.Text =  player.Name
	else
		PTexto.Text =  Valor.Name
	end
end)

-----------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------
local TreatDebounce = true
local SavedTarget 	= nil

script.Parent.Treat.Frame.BandFrame.Bandage.MouseButton1Down:Connect(function()
	if TreatDebounce and Bandage.Value > 0 and Human.Health > 0 and not Char.ACS_Client:GetAttribute("Collapsed") then
		TreatDebounce = false
		if Target.Value == nil then
			if Char.ACS_Client:GetAttribute("Bleeding") then
				Timer.Size = UDim2.new(0,0,1,0)
				TS:Create(Timer, TweenInfo.new(5,Enum.EasingStyle.Linear), {Size =  UDim2.new(1,0,1,0)}):Play()
				wait(5)
				Functions.MedHandler:FireServer(nil,1)
			end
		else
			if Target.Value.Character.ACS_Client:GetAttribute("Bleeding") then
				SavedTarget = Target.Value
				Timer.Size = UDim2.new(0,0,1,0)
				TS:Create(Timer, TweenInfo.new(5,Enum.EasingStyle.Linear), {Size =  UDim2.new(1,0,1,0)}):Play()
				wait(5)
				Functions.MedHandler:FireServer(SavedTarget,1)
			end
		end
		TreatDebounce = true
	end
end)

script.Parent.Treat.Frame.BandFrame.Splint.MouseButton1Down:Connect(function()
	if TreatDebounce and Splint.Value > 0 and Human.Health > 0 and not Char.ACS_Client:GetAttribute("Collapsed") then
		TreatDebounce = false
		if Target.Value == nil then
			if Char.ACS_Client:GetAttribute("Injured") then
				Timer.Size = UDim2.new(0,0,1,0)
				TS:Create(Timer, TweenInfo.new(5,Enum.EasingStyle.Linear), {Size =  UDim2.new(1,0,1,0)}):Play()
				wait(5)
				Functions.MedHandler:FireServer(nil,2)
			end
		else
			if Target.Value.Character.ACS_Client:GetAttribute("Injured") then
				SavedTarget = Target.Value
				Timer.Size = UDim2.new(0,0,1,0)
				TS:Create(Timer, TweenInfo.new(5,Enum.EasingStyle.Linear), {Size =  UDim2.new(1,0,1,0)}):Play()
				wait(5)
				Functions.MedHandler:FireServer(SavedTarget,2)
			end
		end
		TreatDebounce = true
	end
end)

script.Parent.Treat.Frame.BandFrame.Tourniquet.MouseButton1Down:Connect(function()
	if TreatDebounce and Human.Health > 0 and not Char.ACS_Client:GetAttribute("Collapsed") then
		TreatDebounce = false
		if Target.Value == nil then
			if Char.ACS_Client:GetAttribute("Bleeding") == true or Char.ACS_Client:GetAttribute("Tourniquet")then
				Timer.Size = UDim2.new(0,0,1,0)
				TS:Create(Timer, TweenInfo.new(1.5,Enum.EasingStyle.Linear), {Size =  UDim2.new(1,0,1,0)}):Play()
				wait(1.5)
				Functions.MedHandler:FireServer(nil,3)
			end
		else
			if Target.Value.Character.ACS_Client:GetAttribute("Bleeding") or Target.Value.Character.ACS_Client:GetAttribute("Tourniquet") then
				SavedTarget = Target.Value
				Timer.Size = UDim2.new(0,0,1,0)
				TS:Create(Timer, TweenInfo.new(1.5,Enum.EasingStyle.Linear), {Size =  UDim2.new(1,0,1,0)}):Play()
				wait(1.5)
				Functions.MedHandler:FireServer(SavedTarget,3)
			end
		end
		TreatDebounce = true
	end
end)

script.Parent.Treat.Frame.MedFrame.PainKiller.MouseButton1Down:Connect(function()
	if TreatDebounce and PainKiller.Value > 0 and Human.Health > 0 and not Char.ACS_Client:GetAttribute("Collapsed") then
		TreatDebounce = false
		if Target.Value == nil then
			if Char.ACS_Client.Variaveis.Dor.Value > 0 then
				Timer.Size = UDim2.new(0,0,1,0)
				TS:Create(Timer, TweenInfo.new(1.5,Enum.EasingStyle.Linear), {Size =  UDim2.new(1,0,1,0)}):Play()
				wait(1.5)
				Functions.MedHandler:FireServer(nil,4)
			end
		else
			if Target.Value.Character.ACS_Client.Variaveis.Dor.Value > 0 then
				SavedTarget = Target.Value
				Timer.Size = UDim2.new(0,0,1,0)
				TS:Create(Timer, TweenInfo.new(1.5,Enum.EasingStyle.Linear), {Size =  UDim2.new(1,0,1,0)}):Play()
				wait(1.5)
				Functions.MedHandler:FireServer(SavedTarget,4)
			end
		end
		TreatDebounce = true
	end
end)

script.Parent.Treat.Frame.MedFrame.Energy.MouseButton1Down:Connect(function()
	if TreatDebounce and EnergyShot.Value > 0 and Human.Health > 0 and not Char.ACS_Client:GetAttribute("Collapsed") then
		TreatDebounce = false
		if Target.Value == nil then
			if Char.Humanoid.Health < Char.Humanoid.MaxHealth then
				Timer.Size = UDim2.new(0,0,1,0)
				TS:Create(Timer, TweenInfo.new(3,Enum.EasingStyle.Linear), {Size =  UDim2.new(1,0,1,0)}):Play()
				wait(3)
				Functions.MedHandler:FireServer(nil,5)
			end
		else
			if Target.Value.Character.Humanoid.Health < Target.Value.Character.Humanoid.MaxHealth then
				SavedTarget = Target.Value
				Timer.Size = UDim2.new(0,0,1,0)
				TS:Create(Timer, TweenInfo.new(3,Enum.EasingStyle.Linear), {Size =  UDim2.new(1,0,1,0)}):Play()
				wait(3)
				Functions.MedHandler:FireServer(SavedTarget,5)
			end
		end
		TreatDebounce = true
	end
end)

script.Parent.Treat.Frame.NeedFrame.Morphine.MouseButton1Down:Connect(function()
	if TreatDebounce and Morphine.Value > 0 and Human.Health > 0 and not Char.ACS_Client:GetAttribute("Collapsed") then
		TreatDebounce = false
		if Target.Value == nil then
			if Char.ACS_Client.Variaveis.Dor.Value > 0 then
				Timer.Size = UDim2.new(0,0,1,0)
				TS:Create(Timer, TweenInfo.new(10,Enum.EasingStyle.Linear), {Size =  UDim2.new(1,0,1,0)}):Play()
				wait(10)
				Functions.MedHandler:FireServer(nil,6)
			end
		else
			if Target.Value.Character.ACS_Client.Variaveis.Dor.Value > 0 then
				SavedTarget = Target.Value
				Timer.Size = UDim2.new(0,0,1,0)
				TS:Create(Timer, TweenInfo.new(10,Enum.EasingStyle.Linear), {Size =  UDim2.new(1,0,1,0)}):Play()
				wait(10)
				Functions.MedHandler:FireServer(SavedTarget,6)
			end
		end
		TreatDebounce = true
	end
end)

script.Parent.Treat.Frame.NeedFrame.Epineprhine.MouseButton1Down:Connect(function()
	if TreatDebounce and Morphine.Value > 0 and Human.Health > 0 and not Char.ACS_Client:GetAttribute("Collapsed") then
		TreatDebounce = false
		if Target.Value == nil then
			if Char.Humanoid.Health < Char.Humanoid.MaxHealth then
				Timer.Size = UDim2.new(0,0,1,0)
				TS:Create(Timer, TweenInfo.new(10,Enum.EasingStyle.Linear), {Size =  UDim2.new(1,0,1,0)}):Play()
				wait(10)
				Functions.MedHandler:FireServer(nil,7)
			end
		else
			if Target.Value.Character.ACS_Client:GetAttribute("Collapsed") then
				SavedTarget = Target.Value
				Timer.Size = UDim2.new(0,0,1,0)
				TS:Create(Timer, TweenInfo.new(10,Enum.EasingStyle.Linear), {Size =  UDim2.new(1,0,1,0)}):Play()
				wait(10)
				Functions.MedHandler:FireServer(SavedTarget,7)
			end
		end
		TreatDebounce = true
	end
end)

script.Parent.Treat.Frame.OtherFrame.Bloodbag.MouseButton1Down:Connect(function()
	if TreatDebounce and SacoDeSangue.Value > 0 and Human.Health > 0 and not Char.ACS_Client:GetAttribute("Collapsed") then
		TreatDebounce = false
		if Target.Value == nil then	
			if Char.ACS_Client.Variaveis.Sangue.Value < Char.ACS_Client.Variaveis.Sangue.MaxValue then
				Timer.Size = UDim2.new(0,0,1,0)
				TS:Create(Timer, TweenInfo.new(20,Enum.EasingStyle.Linear), {Size =  UDim2.new(1,0,1,0)}):Play()
				wait(20)
				Functions.MedHandler:FireServer(nil,8)
			end
		else
			if Target.Value.Character.ACS_Client.Variaveis.Sangue.Value < Target.Value.Character.ACS_Client.Variaveis.Sangue.MaxValue then
				SavedTarget = Target.Value
				Timer.Size = UDim2.new(0,0,1,0)
				TS:Create(Timer, TweenInfo.new(20,Enum.EasingStyle.Linear), {Size =  UDim2.new(1,0,1,0)}):Play()
				wait(20)
				Functions.MedHandler:FireServer(SavedTarget,8)
			end
		end
		TreatDebounce = true
	end
end)


-----------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------


script.Parent.Treat.Frame.Bandage.MouseButton1Down:connect(function()
	script.Parent.Treat.Frame.BandFrame.Visible  = true
	script.Parent.Treat.Frame.MedFrame.Visible 	 = false
	script.Parent.Treat.Frame.NeedFrame.Visible  = false
	script.Parent.Treat.Frame.OtherFrame.Visible = false
end)

script.Parent.Treat.Frame.Medicine.MouseButton1Down:connect(function()
	script.Parent.Treat.Frame.BandFrame.Visible  = false
	script.Parent.Treat.Frame.MedFrame.Visible 	 = true
	script.Parent.Treat.Frame.NeedFrame.Visible  = false
	script.Parent.Treat.Frame.OtherFrame.Visible = false
end)

script.Parent.Treat.Frame.Needle.MouseButton1Down:connect(function()
	script.Parent.Treat.Frame.BandFrame.Visible  = false
	script.Parent.Treat.Frame.MedFrame.Visible 	 = false
	script.Parent.Treat.Frame.NeedFrame.Visible  = true
	script.Parent.Treat.Frame.OtherFrame.Visible = false
end)

script.Parent.Treat.Frame.Other.MouseButton1Down:connect(function()
	script.Parent.Treat.Frame.BandFrame.Visible  = false
	script.Parent.Treat.Frame.MedFrame.Visible 	 = false
	script.Parent.Treat.Frame.NeedFrame.Visible  = false
	script.Parent.Treat.Frame.OtherFrame.Visible = true
end)
-----------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------
local Vida = script.Parent.Stats.Frame.Vida
local Consciente = script.Parent.Stats.Frame.Consciente
local Dor = script.Parent.Stats.Frame.Dor
local Ferido = script.Parent.Stats.Frame.Ferido
local Sangrando = script.Parent.Stats.Frame.Sangrando

local BleedTween = TS:Create(Sangrando, TweenInfo.new(1,Enum.EasingStyle.Linear,Enum.EasingDirection.InOut,-1,true), {TextColor3 =  Color3.fromRGB(255, 0, 0)} )
BleedTween:Play()

RS.RenderStepped:connect(function()
	if script.Parent.Visible == true then

		if Target.Value ~= nil then
			local player = game.Players:FindFirstChild(Target.Value.Name)
			local P2_Client = player.Character:FindFirstChild("ACS_Client")

			if player and P2_Client then
				local vHuman = player.Character.Humanoid
				local vSang = player.Character.ACS_Client.Variaveis.Sangue

				local pie = (vHuman.Health / vHuman.MaxHealth)
				script.Parent.Overview.Frame.VidaBar.Bar.Size = UDim2.new(pie, 0, 1, 0)

				local Pizza = (vSang.Value / vSang.MaxValue)
				script.Parent.Overview.Frame.SangueBar.Bar.Size = UDim2.new(Pizza, 0, 1, 0)
			else
				Target.Value = nil
			end
		else
			local pie = (Human.Health / Human.MaxHealth)
			script.Parent.Overview.Frame.VidaBar.Bar.Size = UDim2.new(pie, 0, 1, 0)

			local Pizza = (Saude.Variaveis.Sangue.Value / Saude.Variaveis.Sangue.MaxValue)
			script.Parent.Overview.Frame.SangueBar.Bar.Size = UDim2.new(Pizza, 0, 1, 0)

		end


		if Target.Value == nil then
			if Human.Health <= 0 then
				Vida.Text = "Dead"
				Vida.TextColor3 = Color3.fromRGB(255,0,0)
				Consciente.Visible = false
			elseif Human.Health <= (Human.MaxHealth * .5) then
				Vida.Text = "High Risk"
				Vida.TextColor3 = Color3.fromRGB(255,0,0)
				Consciente.Visible = true
			elseif Human.Health <= (Human.MaxHealth * .75) then
				Vida.Text = "Low Risk"
				Vida.TextColor3 = Color3.fromRGB(255,255,0)
				Consciente.Visible = true
			elseif Human.Health <= (Human.MaxHealth) then
				Vida.Text = "Healthy"
				Vida.TextColor3 = Color3.fromRGB(255,255,255)
				Consciente.Visible = true
			end

			if Saude:GetAttribute("Collapsed") == true then
				Consciente.Text = "Unconscious"
			else
				Consciente.Text = "Conscious"
			end
			
			if Saude.Variaveis.Dor.Value <= 0 then
				Dor.Text = "No pain"
				Dor.TextColor3 = Color3.fromRGB(255,255,255)
				Dor.Visible = false
			elseif Saude.Variaveis.Dor.Value <= 50 then
				Dor.Text = "Minor pain"
				Dor.TextColor3 = Color3.fromRGB(255,255,255)
				Dor.Visible = true
			elseif Saude.Variaveis.Dor.Value < 100 then
				Dor.Text = "Major pain"
				Dor.TextColor3 = Color3.fromRGB(255,255,0)
				Dor.Visible = true
			elseif Saude.Variaveis.Dor.Value >= 100 then
				Dor.Text = "Extreme pain"
				Dor.TextColor3 = Color3.fromRGB(255,0,0)
				Dor.Visible = true
			end


			if Saude:GetAttribute("Injured") == true then
				Ferido.Visible = true
			else
				Ferido.Visible = false
			end

			if Saude:GetAttribute("Bleeding") == true or Saude:GetAttribute("Tourniquet")then
				if Saude:GetAttribute("Tourniquet") then
					Sangrando.Text = 'Tourniquet'
				else
					Sangrando.Text = 'Bleeding'
				end
				Sangrando.Visible = true
			else
				Sangrando.Visible = false
			end

		else
			local player2 = game.Players:FindFirstChild(Target.Value.Name)
			local PlHuman = player2.Character.Humanoid
			local PlSaude = player2.Character.ACS_Client
			if PlHuman.Health > 0 then
				if PlHuman.Health <= 0 then
					Vida.Text = "Dead"
					Vida.TextColor3 = Color3.fromRGB(255,0,0)
					Consciente.Visible = false
				elseif PlHuman.Health <= (PlHuman.MaxHealth * .5) then
					Vida.Text = "High Risk"
					Vida.TextColor3 = Color3.fromRGB(255,0,0)
					Consciente.Visible = true
				elseif PlHuman.Health <= (PlHuman.MaxHealth * .75) then
					Vida.Text = "Low Risk"
					Vida.TextColor3 = Color3.fromRGB(255,255,0)
					Consciente.Visible = true
				elseif PlHuman.Health <= (PlHuman.MaxHealth) then
					Vida.Text = "Healthy"
					Vida.TextColor3 = Color3.fromRGB(255,255,255)
					Consciente.Visible = true
				end

				if PlSaude:GetAttribute("Collapsed") == true then
					Consciente.Text = "Unconscious"
				else
					Consciente.Text = "Conscious"
				end

				if PlSaude.Variaveis.Dor.Value <= 0 then
					Dor.Text = "No pain"
					Dor.TextColor3 = Color3.fromRGB(255,255,255)
					Dor.Visible = false
				elseif PlSaude.Variaveis.Dor.Value <= 50 then
					Dor.Text = "Minor pain"
					Dor.TextColor3 = Color3.fromRGB(255,255,255)
					Dor.Visible = true
				elseif PlSaude.Variaveis.Dor.Value < 100 then
					Dor.Text = "Major pain"
					Dor.TextColor3 = Color3.fromRGB(255,255,0)
					Dor.Visible = true
				elseif PlSaude.Variaveis.Dor.Value >= 100 then
					Dor.Text = "Extreme pain"
					Dor.TextColor3 = Color3.fromRGB(255,0,0)
					Dor.Visible = true
				end

				if PlSaude:GetAttribute("Injured") == true then
					Ferido.Visible = true
				else
					Ferido.Visible = false
				end

				if PlSaude:GetAttribute("Bleeding") == true or PlSaude:GetAttribute("Tourniquet") then
					if PlSaude:GetAttribute("Tourniquet")then
						Sangrando.Text = 'Tourniquet'
					else
						Sangrando.Text = 'Bleeding'
					end
					Sangrando.Visible = true
				else
					Sangrando.Visible = false
				end
			end
		end
	end

end)
-----------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------