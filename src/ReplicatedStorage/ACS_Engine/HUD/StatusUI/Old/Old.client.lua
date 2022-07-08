repeat
	wait()
until game.Players.LocalPlayer.Character
wait(0.5)

local TS = game:GetService("TweenService")
local RS = game:GetService("RunService")

local Players = game:GetService("Players")
local player = Players.LocalPlayer
local Char = player.Character
local Human = Char.Humanoid
local Saude = Char.ACS_Client

local MedicSystem = game.ReplicatedStorage.ACS_Engine
local Functions = MedicSystem.Events.MedSys
local FunctionsMulti = Functions.Multi
local Reset = Functions.Reset
local Render = Functions.Render

local Target = Char.ACS_Client.Variaveis.PlayerSelecionado
local Texto = script.Parent.Texto
Texto.Text =  player.Name

local Timer = script.Parent.Timer

local Aspirina = Char.ACS_Client.Kit.Aspirina
local Bandagem = Char.ACS_Client.Kit.Bandagem
local Splint = Char.ACS_Client.Kit.Splint
local Tourniquet = Char.ACS_Client.Kit.Tourniquet
local Energetico = Char.ACS_Client.Kit.Energetico
local Epinefrina = Char.ACS_Client.Kit.Epinefrina
local Morfina = Char.ACS_Client.Kit.Morfina
local SacoDeSangue = Char.ACS_Client.Kit.SacoDeSangue

local AspirinaQuantidade = script.Parent.Medkit.Painkiller.Quantidade
local BandagemQuantidade = script.Parent.Medkit.Bandage.Quantidade
local SplintQuantidade = script.Parent.Medkit.Splint.Quantidade
local TourniquetQuantidade = script.Parent.Medkit.Tourniquet.Quantidade
local EnergeticoQuantidade = script.Parent.Medkit.Energy.Quantidade
local EpinefrinaQuantidade = script.Parent.Medkit.Epinefrina.Quantidade
local MorfinaQuantidade = script.Parent.Medkit.Morfina.Quantidade
local SacoDeSangueQuantidade = script.Parent.Medkit.BloodBag.Quantidade

-----------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------
AspirinaQuantidade.Text = Aspirina.Value
BandagemQuantidade.Text = Bandagem.Value
EnergeticoQuantidade.Text = Energetico.Value
EpinefrinaQuantidade.Text = Epinefrina.Value
MorfinaQuantidade.Text = Morfina.Value
SplintQuantidade.Text = Splint.Value
TourniquetQuantidade.Text = Tourniquet.Value

Aspirina.Changed:Connect(function()
	AspirinaQuantidade.Text = Aspirina.Value
end)

Bandagem.Changed:Connect(function()
	BandagemQuantidade.Text = Bandagem.Value
end)

Splint.Changed:Connect(function()
	SplintQuantidade.Text = Splint.Value
end)

Tourniquet.Changed:Connect(function()
	TourniquetQuantidade.Text = Tourniquet.Value
end)

Energetico.Changed:Connect(function()
	EnergeticoQuantidade.Text = Energetico.Value
end)

Epinefrina.Changed:Connect(function()
	EpinefrinaQuantidade.Text = Epinefrina.Value
end)

Morfina.Changed:Connect(function()
	MorfinaQuantidade.Text = Morfina.Value
end)

SacoDeSangue.Changed:Connect(function()
	SacoDeSangueQuantidade.Text = SacoDeSangue.Value
end)
-----------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------
Target.Changed:Connect(function()
	if Target.Value == "N/A" then
		script.Parent.MedicineAberto.TratarFeridasAberto.PainKiller.Style = Enum.ButtonStyle.RobloxButton
		script.Parent.MedicineAberto.TratarFeridasAberto.Energy.Style = Enum.ButtonStyle.RobloxButton
	
		script.Parent.MedicineAberto.TratarFeridasAberto.Epinephrine.Style = Enum.ButtonStyle.RobloxButtonDefault
		script.Parent.MedicineAberto.TratarFeridasAberto.Morphine.Style = Enum.ButtonStyle.RobloxButtonDefault
		
		script.Parent.OtherAberto.TratarFeridasAberto.BloodBag.Style = Enum.ButtonStyle.RobloxButtonDefault
	else

		script.Parent.MedicineAberto.TratarFeridasAberto.PainKiller.Style = Enum.ButtonStyle.RobloxButtonDefault
		script.Parent.MedicineAberto.TratarFeridasAberto.Energy.Style = Enum.ButtonStyle.RobloxButtonDefault	
		
		script.Parent.MedicineAberto.TratarFeridasAberto.Epinephrine.Style = Enum.ButtonStyle.RobloxButton
		script.Parent.MedicineAberto.TratarFeridasAberto.Morphine.Style = Enum.ButtonStyle.RobloxButton

		script.Parent.OtherAberto.TratarFeridasAberto.BloodBag.Style = Enum.ButtonStyle.RobloxButton
	end
end)

script.Parent.BandagesAberto.TratarFeridasAberto.Comprimir.MouseButton1Down:Connect(function()
	if Saude.Variaveis.Doer.Value == false then
	if Target.Value == "N/A" then
		Functions.Compress:FireServer()
		Timer.Barra.Size = UDim2.new(0,0,1,0)
		TS:Create(Timer.Barra, TweenInfo.new(5), {Size =  UDim2.new(1,0,1,0)}):Play()
	else
		FunctionsMulti.Compress:FireServer()
		Timer.Barra.Size = UDim2.new(0,0,1,0)
		TS:Create(Timer.Barra, TweenInfo.new(5), {Size =  UDim2.new(1,0,1,0)}):Play()
	end
	end
end)

script.Parent.BandagesAberto.TratarFeridasAberto.Bandagem.MouseButton1Down:Connect(function()
	if Saude.Variaveis.Doer.Value == false then
	if Target.Value == "N/A" then
		Functions.Bandage:FireServer()
		Timer.Barra.Size = UDim2.new(0,0,1,0)
		TS:Create(Timer.Barra, TweenInfo.new(2), {Size =  UDim2.new(1,0,1,0)}):Play()
	else
		FunctionsMulti.Bandage:FireServer()
		Timer.Barra.Size = UDim2.new(0,0,1,0)
		TS:Create(Timer.Barra, TweenInfo.new(2), {Size =  UDim2.new(1,0,1,0)}):Play()
	end
	end
end)

script.Parent.BandagesAberto.TratarFeridasAberto.Tourniquet.MouseButton1Down:Connect(function()
	if Saude.Variaveis.Doer.Value == false then
	if Target.Value == "N/A" then
		Functions.Tourniquet:FireServer()
		Timer.Barra.Size = UDim2.new(0,0,1,0)
		TS:Create(Timer.Barra, TweenInfo.new(2), {Size =  UDim2.new(1,0,1,0)}):Play()
	else
		FunctionsMulti.Tourniquet:FireServer()
		Timer.Barra.Size = UDim2.new(0,0,1,0)
		TS:Create(Timer.Barra, TweenInfo.new(2), {Size =  UDim2.new(1,0,1,0)}):Play()
	end
	end
end)

script.Parent.BandagesAberto.TratarFeridasAberto.Splint.MouseButton1Down:Connect(function()
	if Saude.Variaveis.Doer.Value == false then
	if Target.Value == "N/A" then
		Functions.Splint:FireServer()
		Timer.Barra.Size = UDim2.new(0,0,1,0)
		TS:Create(Timer.Barra, TweenInfo.new(2), {Size =  UDim2.new(1,0,1,0)}):Play()
	else
		FunctionsMulti.Splint:FireServer()
		Timer.Barra.Size = UDim2.new(0,0,1,0)
		TS:Create(Timer.Barra, TweenInfo.new(2), {Size =  UDim2.new(1,0,1,0)}):Play()
	end
	end
end)
-----------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------
script.Parent.MedicineAberto.TratarFeridasAberto.PainKiller.MouseButton1Down:Connect(function()
	if Saude.Variaveis.Doer.Value == false then
	if Target.Value == "N/A" then
		Functions.PainKiller:FireServer()
		Timer.Barra.Size = UDim2.new(0,0,1,0)
		TS:Create(Timer.Barra, TweenInfo.new(2), {Size =  UDim2.new(1,0,1,0)}):Play()
	else
		--FunctionsMulti.Energetic:FireServer()
	end
	end
end)

script.Parent.MedicineAberto.TratarFeridasAberto.Energy.MouseButton1Down:Connect(function()
	if Saude.Variaveis.Doer.Value == false then
	if Target.Value == "N/A" then
		Functions.Energetic:FireServer()
		Timer.Barra.Size = UDim2.new(0,0,1,0)
		TS:Create(Timer.Barra, TweenInfo.new(2), {Size =  UDim2.new(1,0,1,0)}):Play()
	else
		--FunctionsMulti.Energetic:FireServer()
	end
end
end)

script.Parent.MedicineAberto.TratarFeridasAberto.Morphine.MouseButton1Down:Connect(function()
	if Saude.Variaveis.Doer.Value == false then
	if Target.Value == "N/A" then
		--Functions.PainKiller:FireServer()
	else
		FunctionsMulti.Morphine:FireServer()
		Timer.Barra.Size = UDim2.new(0,0,1,0)
		TS:Create(Timer.Barra, TweenInfo.new(2), {Size =  UDim2.new(1,0,1,0)}):Play()
	end
	end
end)

script.Parent.MedicineAberto.TratarFeridasAberto.Epinephrine.MouseButton1Down:Connect(function()
	if Saude.Variaveis.Doer.Value == false then
	if Target.Value == "N/A" then
		--Functions.PainKiller:FireServer()
	else
		FunctionsMulti.Epinephrine:FireServer()
		Timer.Barra.Size = UDim2.new(0,0,1,0)
		TS:Create(Timer.Barra, TweenInfo.new(2), {Size =  UDim2.new(1,0,1,0)}):Play()
	end
	end
end)
-----------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------
Target.Changed:Connect(function(Valor)
	if Valor == "N/A" then
		Texto.Text =  player.Name
		script.Parent.Reset.Visible = false
	else
		Texto.Text =  Valor
		script.Parent.Reset.Visible = true
	end
end)

script.Parent.Reset.MouseButton1Down:connect(function()
	Reset:FireServer()
end)

script.Parent.Menu.Bandages.MouseButton1Down:connect(function()
	if Saude.Variaveis.Doer.Value == false and script.Parent.BandagesAberto.Visible == false then
	--Saude.Variaveis.Doer.Value = true
	--Timer.Barra.Size = UDim2.new(0,0,1,0)
	--TS:Create(Timer.Barra, TweenInfo.new(.25), {Size =  UDim2.new(1,0,1,0)}):Play()
	--wait(.25)
	script.Parent.OtherAberto.Visible = false
	script.Parent.MedicineAberto.Visible = false
	script.Parent.BandagesAberto.Visible = true
	--Saude.Variaveis.Doer.Value = false
	end
end)

script.Parent.Menu.Medicines.MouseButton1Down:connect(function()
	if Saude.Variaveis.Doer.Value == false and script.Parent.MedicineAberto.Visible == false then
	--Saude.Variaveis.Doer.Value = true
	--Timer.Barra.Size = UDim2.new(0,0,1,0)
	--TS:Create(Timer.Barra, TweenInfo.new(.25), {Size =  UDim2.new(1,0,1,0)}):Play()
	--wait(.25)
	script.Parent.OtherAberto.Visible = false
	script.Parent.MedicineAberto.Visible = true
	script.Parent.BandagesAberto.Visible = false
	--Saude.Variaveis.Doer.Value = false
	end
end)

script.Parent.Menu.Others.MouseButton1Down:connect(function()
	if Saude.Variaveis.Doer.Value == false and script.Parent.OtherAberto.Visible == false then
	--Saude.Variaveis.Doer.Value = true
	--Timer.Barra.Size = UDim2.new(0,0,1,0)
	--TS:Create(Timer.Barra, TweenInfo.new(.25), {Size =  UDim2.new(1,0,1,0)}):Play()
	--wait(.25)
	script.Parent.OtherAberto.Visible = true
	script.Parent.MedicineAberto.Visible = false
	script.Parent.BandagesAberto.Visible = false
	--Saude.Variaveis.Doer.Value = false
	end
end)
-----------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------
script.Parent.OtherAberto.TratarFeridasAberto.BloodBag.MouseButton1Down:Connect(function()
	if Saude.Variaveis.Doer.Value == false then
	if Target.Value == "N/A" then
		--Functions.PainKiller:FireServer()
	else
		FunctionsMulti.BloodBag:FireServer()
		Timer.Barra.Size = UDim2.new(0,0,1,0)
		TS:Create(Timer.Barra, TweenInfo.new(2), {Size =  UDim2.new(1,0,1,0)}):Play()
	end
	end
end)
-----------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------
local Vida = script.Parent.Overhaul.Vida
local Consciente = script.Parent.Overhaul.Consciente
local Dor = script.Parent.Overhaul.Dor
local Ferido = script.Parent.Overhaul.Ferido
local Sangrando = script.Parent.Overhaul.Sangrando

local BleedTween = TS:Create(Sangrando, TweenInfo.new(1,Enum.EasingStyle.Linear,Enum.EasingDirection.InOut,-1,true), {TextColor3 =  Color3.fromRGB(255, 0, 0)} )

RS.RenderStepped:connect(function()
	if script.Parent.Visible == true then
		
	if Target.Value ~= "N/A" then

		local player = game.Players:FindFirstChild(Target.Value)	
		local vHuman = player.Character.Humanoid
		local vSang = player.Character.ACS_Client.Variaveis.Sangue
	
		local pie = (vHuman.Health / vHuman.MaxHealth)
		script.Parent.Menu.Base.VidaBar.Sangue.Size = UDim2.new(1, 0, pie, 0)

		local Pizza = (vSang.Value / vSang.MaxValue)
		script.Parent.Menu.Base.SangueBar.Sangue.Size = UDim2.new(1, 0, Pizza, 0)

	else

		local pie = (Human.Health / Human.MaxHealth)
		script.Parent.Menu.Base.VidaBar.Sangue.Size = UDim2.new(1, 0, pie, 0)

		local Pizza = (Saude.Variaveis.Sangue.Value / Saude.Variaveis.Sangue.MaxValue)
		script.Parent.Menu.Base.SangueBar.Sangue.Size = UDim2.new(1, 0, Pizza, 0)

	end
		
		
		if Target.Value == "N/A" then
			if Human.Health <= 0 then
				Vida.Text = "Dead"
				Vida.TextColor3 = Color3.fromRGB(255,0,0)
			elseif Human.Health <= (Human.MaxHealth * .5) then
				Vida.Text = "High Risk"
				Vida.TextColor3 = Color3.fromRGB(255,0,0)
			elseif Human.Health <= (Human.MaxHealth * .75) then
				Vida.Text = "Low Risk"
				Vida.TextColor3 = Color3.fromRGB(255,255,0)
			elseif Human.Health <= (Human.MaxHealth) then
				Vida.Text = "Healthy"
				Vida.TextColor3 = Color3.fromRGB(255,255,255)
			end
		
			if Saude.Stances.Caido.Value == true then
				Consciente.Text = "Unconscious"
			else
				Consciente.Text = "Conscious"
			end

			if Saude.Variaveis.Dor.Value <= 0 then
				Dor.Text = "No pain"
				Dor.TextColor3 = Color3.fromRGB(255,255,255)
			elseif Saude.Variaveis.Dor.Value <= 25 then
				Dor.Text = "Minor pain"
				Dor.TextColor3 = Color3.fromRGB(255,255,255)
			elseif Saude.Variaveis.Dor.Value < 100 then
				Dor.Text = "Major pain"
				Dor.TextColor3 = Color3.fromRGB(255,255,0)
			elseif Saude.Variaveis.Dor.Value >= 100 then
				Dor.Text = "Extreme pain"
				Dor.TextColor3 = Color3.fromRGB(255,0,0)
			end


			if Saude.Stances.Ferido.Value == true then
				Ferido.Visible = true
			else
				Ferido.Visible = false
			end

			if Saude.Stances.Sangrando.Value == true or Saude.Stances.Tourniquet.Value == true then
				if Saude.Stances.Tourniquet.Value == true then
					Sangrando.Text = 'Tourniquet'
				else
					Sangrando.Text = 'Bleeding'
				end
				Sangrando.Visible = true
				Sangrando.TextColor3 = Color3.fromRGB(255,255,255)
				BleedTween:Play()
			else
				Sangrando.Visible = false
				BleedTween:Cancel()
			end
		
		else
			local player2 = game.Players:FindFirstChild(Target.Value)
			local PlHuman = player2.Character.Humanoid
			local PlSaude = player2.Character.ACS_Client
			if PlHuman.Health > 0 then
			if PlHuman.Health <= 0 then
				Vida.Text = "Dead"
				Vida.TextColor3 = Color3.fromRGB(255,0,0)
			elseif PlHuman.Health <= (PlHuman.MaxHealth * .5) then
				Vida.Text = "High Risk"
				Vida.TextColor3 = Color3.fromRGB(255,0,0)
			elseif PlHuman.Health <= (PlHuman.MaxHealth * .75) then
				Vida.Text = "Low Risk"
				Vida.TextColor3 = Color3.fromRGB(255,255,0)
			elseif PlHuman.Health <= (PlHuman.MaxHealth) then
				Vida.Text = "Healthy"
				Vida.TextColor3 = Color3.fromRGB(255,255,255)
			end

			if PlSaude.Stances.Caido.Value == true then
				Consciente.Text = "Unconscious"
			else
				Consciente.Text = "Conscious"
			end
	
			if PlSaude.Variaveis.Dor.Value <= 0 then
				Dor.Text = "No pain"
				Dor.TextColor3 = Color3.fromRGB(255,255,255)
			elseif PlSaude.Variaveis.Dor.Value <= 25 then
				Dor.Text = "Minor pain"
				Dor.TextColor3 = Color3.fromRGB(255,255,255)
			elseif PlSaude.Variaveis.Dor.Value < 100 then
				Dor.Text = "Major pain"
				Dor.TextColor3 = Color3.fromRGB(255,255,0)
			elseif PlSaude.Variaveis.Dor.Value >= 100 then
				Dor.Text = "Extreme pain"
				Dor.TextColor3 = Color3.fromRGB(255,0,0)
			end
	
			if PlSaude.Stances.Ferido.Value == true then
				Ferido.Visible = true
			else
				Ferido.Visible = false
			end
	
			if PlSaude.Stances.Sangrando.Value == true or PlSaude.Stances.Tourniquet.Value == true then
				if PlSaude.Stances.Tourniquet.Value == true then
					Sangrando.Text = 'Tourniquet'
				else
					Sangrando.Text = 'Bleeding'
				end
				Sangrando.Visible = true
				Sangrando.TextColor3 = Color3.fromRGB(255,255,255)
				BleedTween:Play()
			else
				Sangrando.Visible = false
				BleedTween:Cancel()
			end
			else
				Reset:FireServer()
			end
		end
	end

end)
-----------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------