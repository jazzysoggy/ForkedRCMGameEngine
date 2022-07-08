repeat wait() until game.Players.LocalPlayer.Character:IsDescendantOf(game.Workspace)

local Player = game.Players.LocalPlayer
local player = game.Players.LocalPlayer
local Character = Player.Character
local char = Player.Character
local Humanoid = Character:WaitForChild("Humanoid")
local Mouse = Player:GetMouse()
local mouse = Player:GetMouse()

local Engine = game.ReplicatedStorage:WaitForChild("ACS_Engine")
local PastaFX = Engine:WaitForChild("FX")
local Evt = Engine:WaitForChild("Events")
local Mod = Engine:WaitForChild("Modules")
local Ultil = require(Mod:WaitForChild("Utilities"))
local SpringMod = require(Mod:WaitForChild("Spring"))
local ServerConfig = require(Engine.GameRules:WaitForChild("Config"))

local Debris = game:GetService("Debris")

local Camera = game.Workspace.CurrentCamera
local UserInputService = game:GetService("UserInputService")
local TS = game:GetService("TweenService")


local Poses = script.Parent.MainFrame.Poses
local Main = script.Parent.MainFrame

local saude = char:WaitForChild("ACS_Client")
local StancesPasta = saude:WaitForChild("Stances")
local Protecao = saude:WaitForChild("Protecao")

local Rendido 	= saude:GetAttribute("Surrender")
local Algemado = StancesPasta.Algemado
local Rappeling = StancesPasta.Rappeling

local Stances = 0
local Virar = 0
local CameraX = 0
local CameraY = 0
local Velocidade = 0
maxAir = 100
air = maxAir
lastHealth = 100
lastHealth2 = 100
local Sentado = false
local CanLean = true
local ChangeStance = true
local cansado = false

----------------

local ZoomDistance = 40

local L_150_ = {}

----------------

---------------------------------------------------------------------------------------
---------------- [ Tween Module ] --------------------------------------------------------
---------------------------------------------------------------------------------------


--[[
	
	tweenJoint Function Parameters:
	
	Object Joint - This has to be a weld with a C0 and C1 property
	
	CFrame newC0 - This is what the new C0 of the weld will be. You can put nil if you don't want to effect the C0
	
	CFrame newC1 - This is what the new C1 of the weld will be. You can put nil if you don't want to effect the C1
	
	function Alpha - This is an alpha function that takes an input parameter of a number between 0 and 90 and returns a number between 0 and 1.
		For example, function(X) return math.sin(math.rad(X)) end
		
	float Duration - This is how long the tweening takes to complete
	
--]]
local RS = game:GetService("RunService")


--[[Algemado.Changed:Connect(function()
	Stance:FireServer(Stances,Virar,Rendido.Value)
end)]]

Humanoid.Died:Connect(function()
	TS:Create(char.Humanoid, TweenInfo.new(1), {CameraOffset = Vector3.new(0,0,0)} ):Play()
	Main.Visible = false
end)

local BleedTween = TS:Create(Main.Poses.Bleeding, TweenInfo.new(1,Enum.EasingStyle.Linear,Enum.EasingDirection.InOut,-1,true), {ImageColor3 =  Color3.fromRGB(150, 0, 0)} )
BleedTween:Play()

saude:GetAttributeChangedSignal("Surrender"):Connect(function()
	local Valor = saude:GetAttribute("Surrender")
	Evt.Stance:FireServer(nil,nil,Valor)
end)

saude:GetAttributeChangedSignal("Bleeding"):Connect(function()
	Main.Poses.Bleeding.Visible = saude:GetAttribute("Bleeding")
end)

saude:GetAttributeChangedSignal("Injured"):Connect(function()
	local Valor = saude:GetAttribute("Injured")

	if Valor == true then
		TS:Create(Main.Poses.Levantado, TweenInfo.new(.2,Enum.EasingStyle.Linear), {ImageColor3 =  Color3.fromRGB(150, 0, 0)}):Play()
		TS:Create(Main.Poses.Agaixado, TweenInfo.new(.2,Enum.EasingStyle.Linear), {ImageColor3 =  Color3.fromRGB(150, 0, 0)}):Play()
		TS:Create(Main.Poses.Deitado, TweenInfo.new(.2,Enum.EasingStyle.Linear), {ImageColor3 =  Color3.fromRGB(150, 0, 0)}):Play()
	else
		TS:Create(Main.Poses.Levantado, TweenInfo.new(.2,Enum.EasingStyle.Linear), {ImageColor3 =  Color3.fromRGB(255, 255, 255)}):Play()
		TS:Create(Main.Poses.Agaixado, TweenInfo.new(.2,Enum.EasingStyle.Linear), {ImageColor3 =  Color3.fromRGB(255, 255, 255)}):Play()
		TS:Create(Main.Poses.Deitado, TweenInfo.new(.2,Enum.EasingStyle.Linear), {ImageColor3 =  Color3.fromRGB(255, 255, 255)}):Play()
	end
end)

local a = Main.Vest
local b = Main.Helm
local Ener = Main.Poses.Energy

function Vest()
	if Protecao.VestProtect.Value <= 0 then
		TS:Create(a, TweenInfo.new(1), {ImageTransparency = 1} ):Play()
	else
		TS:Create(a, TweenInfo.new(1), {ImageTransparency = .125} ):Play()
	end
end

function Helmet()
	if Protecao.HelmetProtect.Value <= 0 then
		TS:Create(b, TweenInfo.new(1), {ImageTransparency = 1} ):Play()
	else
		TS:Create(b, TweenInfo.new(1), {ImageTransparency = .125} ):Play()
	end
end

function Stamina()
	if ServerConfig.EnableStamina then
		if saude.Variaveis.Stamina.Value <= (saude.Variaveis.Stamina.MaxValue/2) then
			Ener.ImageColor3 = Color3.new(1,saude.Variaveis.Stamina.Value/(saude.Variaveis.Stamina.MaxValue/2),saude.Variaveis.Stamina.Value/saude.Variaveis.Stamina.MaxValue)
			Ener.Visible = true
		elseif saude.Variaveis.Stamina.Value < saude.Variaveis.Stamina.MaxValue then
			Ener.ImageColor3 = Color3.new(1,1,saude.Variaveis.Stamina.Value/saude.Variaveis.Stamina.MaxValue)
			Ener.Visible = true
		elseif saude.Variaveis.Stamina.Value >= saude.Variaveis.Stamina.MaxValue then
			Ener.Visible = false
		end
	else
		saude.Variaveis.Stamina.Value = saude.Variaveis.Stamina.MaxValue
		Ener.Visible = false
	end
end

Vest()
Helmet()
Stamina()

Protecao.VestProtect.Changed:Connect(Vest)
Protecao.HelmetProtect.Changed:Connect(Helmet)
saude.Variaveis.Stamina.Changed:Connect(Stamina)



function L_150_.Update()
	if saude.Variaveis.Stamina.Value <= (saude.Variaveis.Stamina.MaxValue/2) then
		local StaminaX = (1 - (saude.Variaveis.Stamina.Value)/(saude.Variaveis.Stamina.MaxValue/2))/20
		Camera.CoordinateFrame = Camera.CoordinateFrame * CFrame.Angles( math.rad( StaminaX * math.sin( tick() * 3.5 )) , math.rad( StaminaX * math.sin( tick() * 1 )), 0)
	end
end





maxAir = 100
air = maxAir

lastHealth = 100
lastHealth2 = 100
maxWidth = 0.96

local Nadando = false
Humanoid.StateChanged:connect(function(state)
	if state == Enum.HumanoidStateType.Swimming then
		Nadando = true
	else
		Nadando = false
	end
end)

game:GetService("RunService"):BindToRenderStep("Camera Update", 200, L_150_.Update)

while wait() do

	if ServerConfig.CanDrown and player.Character:FindFirstChild("Head") then
		local min = player.Character.Head.Position - (.1 * player.Character.Head.Size)
		local max = player.Character.Head.Position + (.1 * player.Character.Head.Size)	
		local region = Region3.new(min,max):ExpandToGrid(4)

		local material = workspace.Terrain:ReadVoxels(region,4)[1][1][1] 

		if player.Character.Humanoid.Health > 0 then
			if material == Enum.Material.Water then
				if air > 0 then
					air = air-0.15
				elseif air <= 0 then
					air = 0
					player.Character.Humanoid.Health = 0
				end
			else
				if air < maxAir then
					air = air + .5
				end
			end
		end

		if air <= 50 then
			script.Parent.Frame.Oxygen.ImageColor3 = Color3.new(1,air/50,air/100)
			script.Parent.Frame.Oxygen.Visible = true
		elseif air < maxAir then
			script.Parent.Frame.Oxygen.ImageColor3 = Color3.new(1,1,air/100)
			script.Parent.Frame.Oxygen.Visible = true
		elseif air >= maxAir then
			script.Parent.Frame.Oxygen.Visible = false
		end
		script.Parent.Efeitos.Oxigen.ImageTransparency = air/100
		if air <= 25 then
			script.Parent.Efeitos.Oxigen.BackgroundTransparency = air/25
		end
	end
end
