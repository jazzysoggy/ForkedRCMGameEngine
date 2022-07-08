local HttpService 	= game:GetService("HttpService")
local PhysicsService= game:GetService("PhysicsService")
local TS 			= game:GetService('TweenService')
local Debris 		= game:GetService("Debris")
local PhysicsService= game:GetService("PhysicsService")
local Run 			= game:GetService("RunService")
local RS 			= game:GetService("ReplicatedStorage")
local ServerStorage = game:GetService("ServerStorage")
local plr 			= game:GetService("Players")

local ACS_Workspace = workspace:WaitForChild("ACS_WorkSpace")
local Engine 		= RS:WaitForChild("ACS_Engine")
local Evt 			= Engine:WaitForChild("Events")
local Mods 			= Engine:WaitForChild("Modules")
local ArmModel 		= Engine:WaitForChild("ArmModel")
local GunModels 	= Engine:WaitForChild("GunModels")
local SVGunModels 	= Engine:WaitForChild("GrenadeModels")
local HUDs 			= Engine:WaitForChild("HUD")
local AttModels 	= Engine:WaitForChild("AttModels")
local AttModules  	= Engine:WaitForChild("AttModules")
local Rules			= Engine:WaitForChild("GameRules")

local gameRules		= require(Rules:WaitForChild("Config"))
local CombatLog		= require(Rules:WaitForChild("CombatLog"))
local SpringMod 	= require(Mods:WaitForChild("Spring"))
local HitMod 		= require(Mods:WaitForChild("Hitmarker"))
local Ultil			= require(Mods:WaitForChild("Utilities"))
local Ragdoll		= require(Mods:WaitForChild("Ragdoll"))
local Fracture		= require(Mods:WaitForChild("PartFractureModule"))
local Shrapnel		= require(Mods:WaitForChild("DirCast"))

local ACS_0 		= HttpService:GenerateGUID(true)
local Backup 		= 0

local PhysService = game:GetService("PhysicsService")
PhysService:CreateCollisionGroup("Casings")
PhysService:CreateCollisionGroup("Characters")
PhysService:CreateCollisionGroup("Guns")
PhysService:CollisionGroupSetCollidable("Casings","Characters",false)
PhysService:CollisionGroupSetCollidable("Casings","Casings",false)
PhysService:CollisionGroupSetCollidable("Guns","Characters",false)
PhysService:CollisionGroupSetCollidable("Guns","Guns",gameRules.WeaponCollisions)

_G.TempBannedPlayers = {} --Local ban list

local Explosion = {"287390459"; "287390954"; "287391087"; "287391197"; "287391361"; "287391499"; "287391567";}


local dParts = {} -- Glass/Light storage
dParts.Glass = {}
dParts.Lights = {}

local gBreakParam = OverlapParams.new()
-----------------------------------------------------------------

game.StarterPlayer.CharacterWalkSpeed = gameRules.NormalWalkSpeed

local function AccessID(SKP_0,SKP_1)
	if SKP_0.UserId ~= SKP_1 then
		SKP_0:kick("Exploit Protocol");
		warn(SKP_0.Name.." - Potential Exploiter! Case 0-A: Client Tried To Access Server Code");
		table.insert(_G.TempBannedPlayers, SKP_0);
	end;
	return ACS_0;
end;

Evt.AcessId.OnServerInvoke = AccessID

--Glenn's Anti-Exploit System (GAE for short). This code is very ugly, but does job done
local function compareTables(arr1, arr2)
	if	arr1.gunName==arr2.gunName 				and 
		arr1.Type==arr2.Type 					and
		arr1.ShootRate==arr2.ShootRate 			and
		arr1.Bullets==arr2.Bullets				and
		arr1.LimbDamage[1]==arr2.LimbDamage[1]	and
		arr1.LimbDamage[2]==arr2.LimbDamage[2]	and
		arr1.TorsoDamage[1]==arr2.TorsoDamage[1]and
		arr1.TorsoDamage[2]==arr2.TorsoDamage[2]and
		arr1.HeadDamage[1]==arr2.HeadDamage[1]	and
		arr1.HeadDamage[2]==arr2.HeadDamage[2]
	then return true; end;
	return false;
end;

local function secureSettings(Player,Gun,Module)
	local PreNewModule = Gun:FindFirstChild("ACS_Settings");
	if not Gun or not PreNewModule then
		Player:kick("Exploit Protocol");
		warn(Player.Name.." - Potential Exploiter! Case 2: Missing Gun And Module")	;
		return false;
	end;

	local NewModule = require(PreNewModule);
	if (compareTables(Module, NewModule) == false) then
		Player:kick("Exploit Protocol");
		warn(Player.Name.." - Potential Exploiter! Case 4: Exploiting Gun Stats")	;
		table.insert(_G.TempBannedPlayers, Player);
		return false;
	end;
	return true;
end;

function CalculateDMG(SKP_0, SKP_1, SKP_2, SKP_4, SKP_5, SKP_6, SKP_10, SKP_11)

	local skp_0	= plr:GetPlayerFromCharacter(SKP_1.Parent) or nil
	local skp_1 = 0
	local skp_2 = SKP_5.MinDamage * SKP_6.minDamageMod

	if SKP_4 == 1 then
		local skp_3 = math.random(SKP_5.HeadDamage[1], SKP_5.HeadDamage[2])
		skp_1 = math.max(skp_2 ,(skp_3 * SKP_6.DamageMod) - (SKP_2/25) * SKP_5.DamageFallOf) * SKP_11 / SKP_5.MuzzleVelocity
	elseif SKP_4 == 2 then
		local skp_3 = math.random(SKP_5.TorsoDamage[1], SKP_5.TorsoDamage[2])
		skp_1 = math.max(skp_2 ,(skp_3 * SKP_6.DamageMod) - (SKP_2/25) * SKP_5.DamageFallOf) * SKP_11 / SKP_5.MuzzleVelocity
	else
		local skp_3 = math.random(SKP_5.LimbDamage[1], SKP_5.LimbDamage[2])
		skp_1 = math.max(skp_2 ,(skp_3 * SKP_6.DamageMod) - (SKP_2/25) * SKP_5.DamageFallOf) * SKP_11 / SKP_5.MuzzleVelocity
	end

	if SKP_1.Parent:FindFirstChild("ACS_Client") and not SKP_5.IgnoreProtection then

		local skp_4 = SKP_1.Parent.ACS_Client.Protecao.VestProtect
		local skp_5 = SKP_1.Parent.ACS_Client.Protecao.HelmetProtect

		if SKP_4 == 1 then
			if SKP_5.BulletPenetration - SKP_10 < skp_5.Value  then
				skp_1 = math.max(.5 ,skp_1 * ((SKP_5.BulletPenetration - SKP_10) /skp_5.Value))
			end
		else
			if SKP_5.BulletPenetration - SKP_10 < skp_4.Value  then
				skp_1 = math.max(.5 ,skp_1 * ((SKP_5.BulletPenetration - SKP_10) /skp_4.Value))
			end
		end
	end		

	if skp_0 then
		if skp_0.Team ~= SKP_0.Team or skp_0.Neutral then
			local skp_t	= Instance.new("ObjectValue")
			skp_t.Name	= "creator"
			skp_t.Value	= SKP_0
			skp_t.Parent= SKP_1
			game.Debris:AddItem(skp_t, 1)

			SKP_1:TakeDamage(skp_1)
			return;
		end;

		if not gameRules.TeamKill then return; end;
		local skp_t	= Instance.new("ObjectValue")
		skp_t.Name	= "creator"
		skp_t.Value	= SKP_0
		skp_t.Parent= SKP_1
		game.Debris:AddItem(skp_t, 1)

		SKP_1:TakeDamage(skp_1 * gameRules.TeamDmgMult)
		return;
	end

	local skp_t	= Instance.new("ObjectValue")
	skp_t.Name	= "creator"
	skp_t.Value	= SKP_0
	skp_t.Parent= SKP_1
	game.Debris:AddItem(skp_t, 1)

	SKP_1:TakeDamage(skp_1)
	return;
end

local function Damage(SKP_0, SKP_1, SKP_2, SKP_3, SKP_4, SKP_5, SKP_6, SKP_7, SKP_8, SKP_9, SKP_10, SKP_11)
	if not SKP_0 or not SKP_0.Character then return; end;
	if not SKP_0.Character:FindFirstChild("Humanoid") or SKP_0.Character.Humanoid.Health <= 0 then return; end;
	if SKP_9 == (ACS_0.."-"..SKP_0.UserId) then
		if SKP_7 then
			SKP_0.Character.Humanoid:TakeDamage(math.max(SKP_8, 0))
			return;
		end

		if SKP_1 then
			local skp_0 = secureSettings(SKP_0,SKP_1, SKP_5)
			if not skp_0 or not SKP_2 then return; end;
			CalculateDMG(SKP_0, SKP_2, SKP_3, SKP_4, SKP_5, SKP_6, SKP_10, SKP_11)
			return;
		end

		SKP_0:kick("Exploit Protocol")
		warn(SKP_0.Name.." - Potential Exploiter! Case 1: Tried To Access Damage Event")
		table.insert(_G.TempBannedPlayers, SKP_0)
		return;
	end
	SKP_0:kick("Exploit Protocol")
	warn(SKP_0.Name.." - Potential Exploiter! Case 0-B: Wrong Permission Code")
	table.insert(_G.TempBannedPlayers, SKP_0)
	return;
end

function BreakGlass(HitPart,Position,cPos)
	local sounds = Engine.FX.GlassBreak:GetChildren()
	local sound = HitPart:FindFirstChild("BreakSound") or sounds[math.random(1,#sounds)]:Clone()
	sound.Name = "BreakSound"
	sound.Parent = HitPart

	local breakPoint = Instance.new("Attachment")
	breakPoint.Name = "BreakingPoint"
	breakPoint.Parent = HitPart
	breakPoint.WorldPosition = Position

	if cPos then breakPoint.Position = cPos end

	local config = Mods:WaitForChild("PartFractureModule").Configuration:Clone()
	config.Parent = HitPart
	config.DebrisDespawnDelay.Value = gameRules.ShardDespawn

	local hParent = HitPart.Parent
	local shards = Fracture.FracturePart(HitPart)
	table.insert(dParts.Glass,{HitPart:Clone(),hParent,shards})

	for _, shard in pairs(shards) do
		local forceAtt = Instance.new("Attachment",shard)
		forceAtt.WorldPosition = Position

		local pushForce = Instance.new("VectorForce")
		pushForce.Enabled = true
		pushForce.Force = Vector3.new(math.random(-50,50),math.random(-50,50),math.random(-50,50))
		pushForce.Attachment0 = forceAtt
		pushForce.Parent = forceAtt

		Debris:AddItem(forceAtt,0.1)
		Debris:AddItem(shard,gameRules.ShardDespawn)
	end
end

Evt.Damage.OnServerInvoke = Damage

Evt.BackBlast.OnServerEvent:Connect(function(Player, Arma, Settings)
	
end)


Evt.HitEffect.OnServerEvent:Connect(function(Player, Position, HitPart, Normal, Material, Settings)
	Evt.HitEffect:FireAllClients(Player, Position, HitPart, Normal, Material, Settings)

	-- Explosion
	if Settings.ExplosiveAmmo then

		-- Damage calculation
		for _, cPlr in pairs(plr:GetPlayers()) do
			if cPlr.Character and cPlr.Character:FindFirstChild("HumanoidRootPart") then
				local dist = (cPlr.Character.HumanoidRootPart.Position - Position).Magnitude
				local MaxZone = Settings.ExplosionRadius
				local MinZone = MaxZone / 3

				if cPlr == Player or gameRules.TeamKill or cPlr.Team ~= Player.Team or cPlr.Neutral then
					if dist < Settings.ExplosionRadius / 3 then
						-- Too close!
						cPlr.Character.Humanoid:TakeDamage(300)

						local Pushback = Instance.new("VectorForce")
						Pushback.Force = (cPlr.Character.HumanoidRootPart.Position - Position).Unit * 20000
						Pushback.Parent = cPlr.Character.Torso
						Pushback.Attachment0 = cPlr.Character.Torso.BodyFrontAttachment
						--Pushback.ApplyAtCenterOfMass = true
						Debris:AddItem(Pushback,0.1)
					else
						local hit = Shrapnel.CastToTarget(Position,cPlr.Character.HumanoidRootPart.Position,5,Settings.ExplosionRadius / 2,{})
						if hit then
							local dMult = ((Position - hit.Position).Magnitude + MinZone) / (MaxZone + MinZone)

							cPlr.Character.Humanoid:TakeDamage(100 - (100 * dMult))
						end
					end
				end
			end
		end

		-- Explosion fx
		local expFX
		if Engine.HITFX.Explosion:FindFirstChild(Settings.ExplosionType) then
			expFX = Engine.HITFX.Explosion[Settings.ExplosionType]
		else
			expFX = Engine.HITFX.Explosion.Default
		end

		local effectAtt = Instance.new("Attachment",workspace.Terrain)
		effectAtt.WorldCFrame = CFrame.new(Position)
		local echo = expFX.Echo:Clone()
		local exp = expFX.Explosion:Clone()
		echo.Parent = effectAtt
		exp.Parent = effectAtt
		echo:Play()
		exp:Play()

		--local exp2 = exp:Clone()
		--exp2.Parent = effectAtt
		--exp2.SoundId = Explosion[math.random(1,#Explosion)]
		--exp2:Play()

		for _, fx in pairs(expFX:GetChildren()) do
			if fx:IsA("ParticleEmitter") then
				local nEffect = fx:Clone()
				nEffect.Parent = effectAtt
				nEffect:Emit(nEffect.Count.Value)
			end
		end

		Debris:AddItem(effectAtt,120)

		-- Break nearby glass
		if gameRules.BreakGlass then
			local rParts = workspace:GetPartBoundsInRadius(Position,Settings.ExplosionRadius,gBreakParam)
			for i, cPart in pairs(rParts) do
				if i % 300 == 0 then wait() end
				if cPart.Name == gameRules.GlassName and cPart:IsA("Part") then
					local size = 0.8 * cPart.Size * (math.random(-10,10) / 10)
					BreakGlass(cPart,Position,Vector3.new(0.2,0.2,0.2))
					wait()
				end
			end
		end
	end

	-- Glass breaking
	if gameRules.BreakGlass and HitPart.Name == gameRules.GlassName and HitPart:IsA("Part") then
		BreakGlass(HitPart,Position)
	end

	-- Light breaking
	if gameRules.BreakLights and HitPart.Name == "Light" and not HitPart:FindFirstChild("Broken") then
		table.insert(dParts.Lights,{HitPart,Material})

		local foundALight = false
		local tag = Instance.new("BoolValue",HitPart)
		tag.Name = "Broken"
		tag.Value = true

		local lights = {}

		for _, child in pairs(HitPart:GetChildren()) do
			if child:IsA("Light") then
				table.insert(lights,child)
				foundALight = true
			end
		end

		if foundALight then
			local newSound = Engine.FX.LightBreak:Clone()
			newSound.PlayOnRemove = true
			newSound.Parent = HitPart
			newSound:Destroy()

			local originalMat = HitPart.Material

			for i = 1, math.random(3,6) do
				HitPart.Material = Enum.Material.Metal
				for _, light in pairs(lights) do
					light.Enabled = false
				end

				wait(math.random(50,1000) / 10000)

				HitPart.Material = Enum.Material.Neon
				for _, light in pairs(lights) do
					light.Enabled = true
				end

				wait(math.random(50,1000) / 10000)
			end

			HitPart.Material = Enum.Material.Metal
			for _, light in pairs(lights) do
				light.Enabled = false
			end
		end
	end
end)

Evt.GunStance.OnServerEvent:Connect(function(Player,stance,Data)
	Evt.GunStance:FireAllClients(Player,stance,Data)
end)

Evt.ServerBullet.OnServerEvent:Connect(function(Player,Origin,Direction,WeaponData,ModTable)
	Evt.ServerBullet:FireAllClients(Player,Origin,Direction,WeaponData,ModTable)
end)


Evt.Stance.OnServerEvent:connect(function(Player, Stance, Virar)

	if not Player or not Player.Character then return; end; --// Player or Character doesn't exist
	if not Player.Character:FindFirstChild("Humanoid") or Player.Character.Humanoid.Health <= 0 then return; end; --// Player is dead

	local ACS_Client= Player.Character:FindFirstChild("ACS_Client")
	if not ACS_Client then return; end;

	local Torso 	= Player.Character:FindFirstChild("Torso")
	local RootPart 	= Player.Character:FindFirstChild("HumanoidRootPart")

	if not Torso or not RootPart then return; end; --// Essential bodyparts doesn't exist in this character

	local RootJoint = RootPart:FindFirstChild("RootJoint")
	local RS 		= Torso:FindFirstChild("Right Shoulder")
	local LS 		= Torso:FindFirstChild("Left Shoulder")
	local RH 		= Torso:FindFirstChild("Right Hip")
	local LH 		= Torso:FindFirstChild("Left Hip")

	if not RootJoint or not RS or not LS or not RH or not LH then return; end; --// Joints doesn't exist

	if Stance == 2 then
		TS:Create(RootJoint, TweenInfo.new(.3), {C1 = CFrame.new(0,1.5,2.45) * CFrame.Angles(math.rad(0),math.rad(0),math.rad(180))} ):Play()
		TS:Create(RH, TweenInfo.new(.3), {C1 = CFrame.new(.5,1,0)* CFrame.Angles(math.rad(-5),math.rad(90),math.rad(0))} ):Play()
		TS:Create(LH, TweenInfo.new(.3), {C1 = CFrame.new(-.5,1,0)* CFrame.Angles(math.rad(-5),math.rad(-90),math.rad(0))} ):Play()
	end
	if Virar == 1 then
		if Stance == 0 then
			TS:Create(RootJoint, TweenInfo.new(.3), {C1 = CFrame.new(-1,-0,0) * CFrame.Angles(math.rad(-90),math.rad(-15),math.rad(-180))} ):Play()
			TS:Create(RH, TweenInfo.new(.3), {C1 = CFrame.new(.5,1,0)* CFrame.Angles(math.rad(0),math.rad(90),math.rad(0))} ):Play()
			TS:Create(LH, TweenInfo.new(.3), {C1 = CFrame.new(-.5,1,0)* CFrame.Angles(math.rad(0),math.rad(-90),math.rad(0))} ):Play()

		elseif Stance == 1 then
			TS:Create(RootJoint, TweenInfo.new(.3), {C1 = CFrame.new(-1,.75,0.25)* CFrame.Angles(math.rad(-80),math.rad(-15),math.rad(-180))} ):Play()
			TS:Create(RH, TweenInfo.new(.3), {C1 = CFrame.new(.5,0,0.4)* CFrame.Angles(math.rad(20),math.rad(90),math.rad(0))} ):Play()
			TS:Create(LH, TweenInfo.new(.3), {C1 = CFrame.new(-.5,0,0.4)* CFrame.Angles(math.rad(20),math.rad(-90),math.rad(0))} ):Play()

		end
	elseif Virar == -1 then
		if Stance == 0 then
			TS:Create(RootJoint, TweenInfo.new(.3), {C1 = CFrame.new(1,0,0) * CFrame.Angles(math.rad(-90),math.rad(15),math.rad(180))} ):Play()
			TS:Create(RH, TweenInfo.new(.3), {C1 = CFrame.new(.5,1,0)* CFrame.Angles(math.rad(0),math.rad(90),math.rad(0))} ):Play()
			TS:Create(LH, TweenInfo.new(.3), {C1 = CFrame.new(-.5,1,0)* CFrame.Angles(math.rad(0),math.rad(-90),math.rad(0))} ):Play()

		elseif Stance == 1 then
			TS:Create(RootJoint, TweenInfo.new(.3), {C1 = CFrame.new(1,.75,0.25)* CFrame.Angles(math.rad(-80),math.rad(15),math.rad(180))} ):Play()
			TS:Create(RH, TweenInfo.new(.3), {C1 = CFrame.new(.5,0,0.4)* CFrame.Angles(math.rad(20),math.rad(90),math.rad(0))} ):Play()
			TS:Create(LH, TweenInfo.new(.3), {C1 = CFrame.new(-.5,0,0.4)* CFrame.Angles(math.rad(20),math.rad(-90),math.rad(0))} ):Play()
		end
	elseif Virar == 0 then
		if Stance == 0 then
			TS:Create(RootJoint, TweenInfo.new(.3), {C1 = CFrame.new(0,0,0)* CFrame.Angles(math.rad(-90),math.rad(0),math.rad(180))} ):Play()
			TS:Create(RH, TweenInfo.new(.3), {C1 = CFrame.new(.5,1,0)* CFrame.Angles(math.rad(0),math.rad(90),math.rad(0))} ):Play()
			TS:Create(LH, TweenInfo.new(.3), {C1 = CFrame.new(-.5,1,0)* CFrame.Angles(math.rad(0),math.rad(-90),math.rad(0))} ):Play()

		elseif Stance == 1 then
			TS:Create(RootJoint, TweenInfo.new(.3), {C1 = CFrame.new(0,1,0.25)* CFrame.Angles(math.rad(-80),math.rad(0),math.rad(180))} ):Play()
			TS:Create(RH, TweenInfo.new(.3), {C1 = CFrame.new(.5,0,0.4)* CFrame.Angles(math.rad(20),math.rad(90),math.rad(0))} ):Play()
			TS:Create(LH, TweenInfo.new(.3), {C1 = CFrame.new(-.5,0,0.4)* CFrame.Angles(math.rad(20),math.rad(-90),math.rad(0))} ):Play()
		end
	end

	if ACS_Client:GetAttribute("Surrender") then
		TS:Create(RS, TweenInfo.new(.3), {C1 = CFrame.new(-.5,0.95,0)* CFrame.Angles(math.rad(-175),math.rad(90),math.rad(0))} ):Play()
		TS:Create(LS, TweenInfo.new(.3), {C1 = CFrame.new(.5,0.95,0)* CFrame.Angles(math.rad(-175),math.rad(-90),math.rad(0))} ):Play()
	elseif Stance == 2 then
		TS:Create(RS, TweenInfo.new(.3), {C1 = CFrame.new(-.5,0.95,0)* CFrame.Angles(math.rad(-175),math.rad(90),math.rad(0))} ):Play()
		TS:Create(LS, TweenInfo.new(.3), {C1 = CFrame.new(.5,0.95,0)* CFrame.Angles(math.rad(-175),math.rad(-90),math.rad(0))} ):Play()
	else
		--p1.CFrame:inverse() * p2.CFrame
		TS:Create(RS, TweenInfo.new(.3), {C1 = CFrame.new(-.5,0.5,0)* CFrame.Angles(math.rad(0),math.rad(90),math.rad(0))} ):Play()
		TS:Create(LS, TweenInfo.new(.3), {C1 = CFrame.new(.5,0.5,0)* CFrame.Angles(math.rad(0),math.rad(-90),math.rad(0))} ):Play()
	end

end)

Evt.Surrender.OnServerEvent:Connect(function(Player,Victim)
	if not Player or not Player.Character then return; end;

	local PClient 	= nil
	if Victim then
		if Victim == Player or not Victim.Character then return; end;

		PClient = Victim.Character:FindFirstChild("ACS_Client")
		if not PClient then return; end;

		if PClient:GetAttribute("Surrender") then
			PClient:SetAttribute("Surrender",false)
		end
	end

	PClient = Player.Character:FindFirstChild("ACS_Client")

	if not PClient then return; end;

	if not PClient:GetAttribute("Surrender") and not Victim then
		PClient:SetAttribute("Surrender",true)
	end
end)

Evt.Grenade.OnServerEvent:Connect(function(SKP_0, SKP_1, SKP_2, SKP_3, SKP_4, SKP_5, SKP_6)
	if not SKP_0 or not SKP_0.Character then return; end;
	if not SKP_0.Character:FindFirstChild("Humanoid") or SKP_0.Character.Humanoid.Health <= 0 then return; end;

	if SKP_6 ~= (ACS_0.."-"..SKP_0.UserId) then
		SKP_0:kick("Exploit Protocol")
		warn(SKP_0.Name.." - Potential Exploiter! Case 0-B: Wrong Permission Code")
		table.insert(_G.TempBannedPlayers, SKP_0)
		return;
	end

	if not SKP_1 or not SKP_2 then
		SKP_0:kick("Exploit Protocol")
		warn(SKP_0.Name.." - Potential Exploiter! Case 3: Tried To Access Grenade Event")
		return;
	end

	local skp_0 = secureSettings(SKP_0, SKP_1, SKP_2)
	if not skp_0 or SKP_2.Type ~= "Grenade" then return; end;

	if not SVGunModels:FindFirstChild(SKP_2.gunName) then warn("ACS_Server Couldn't Find "..SKP_2.gunName.." In Grenade Model Folder"); return; end;

	local skp_0 = SVGunModels[SKP_2.gunName]:Clone()

	for SKP_Arg0, SKP_Arg1 in pairs(SKP_0.Character:GetChildren()) do
		if not SKP_Arg1:IsA('BasePart') then continue; end;
		local skp_1 = Instance.new("NoCollisionConstraint")
		skp_1.Parent= skp_0
		skp_1.Part0 = skp_0.PrimaryPart
		skp_1.Part1 = SKP_Arg1
	end

	local skp_1	= Instance.new("ObjectValue")
	skp_1.Name	= "creator"
	skp_1.Value	= SKP_0
	skp_1.Parent= skp_0.PrimaryPart

	skp_0.Parent 	= ACS_Workspace.Server
	skp_0.PrimaryPart.CFrame = SKP_3
	skp_0.PrimaryPart:ApplyImpulse(SKP_4 * SKP_5 * skp_0.PrimaryPart:GetMass())
	skp_0.PrimaryPart:SetNetworkOwner(nil)
	skp_0.PrimaryPart.Damage.Disabled = false

	SKP_1:Destroy()
end)

function loadAttachment(weapon,WeaponData)
	if not weapon or not WeaponData or not weapon:FindFirstChild("Nodes") then return; end;
	--load sight Att
	if weapon.Nodes:FindFirstChild("Sight") and WeaponData.SightAtt ~= "" then

		local SightAtt = AttModels[WeaponData.SightAtt]:Clone()
		SightAtt.Parent = weapon
		SightAtt:SetPrimaryPartCFrame(weapon.Nodes.Sight.CFrame)

		for index, key in pairs(weapon:GetChildren()) do
			if not key:IsA('BasePart') or key.Name ~= "IS" then continue; end;
			key.Transparency = 1
		end

		for index, key in pairs(SightAtt:GetChildren()) do
			if key.Name == "SightMark" or key.Name == "Main" then key:Destroy(); continue; end;
			if not key:IsA('BasePart') then continue; end;
			Ultil.Weld(weapon:WaitForChild("Handle"), key )
			key.Anchored = false
			key.CanCollide = false
		end

	end

	--load Barrel Att
	if weapon.Nodes:FindFirstChild("Barrel") and WeaponData.BarrelAtt ~= "" then

		local BarrelAtt = AttModels[WeaponData.BarrelAtt]:Clone()
		BarrelAtt.Parent = weapon
		BarrelAtt:SetPrimaryPartCFrame(weapon.Nodes.Barrel.CFrame)

		if BarrelAtt:FindFirstChild("BarrelPos") then
			weapon.Handle.Muzzle.WorldCFrame = BarrelAtt.BarrelPos.CFrame
		end

		for index, key in pairs(BarrelAtt:GetChildren()) do
			if not key:IsA('BasePart') then continue; end;
			Ultil.Weld(weapon:WaitForChild("Handle"), key )
			key.Anchored = false
			key.CanCollide = false
		end
	end

	--load Under Barrel Att
	if weapon.Nodes:FindFirstChild("UnderBarrel") and WeaponData.UnderBarrelAtt ~= "" then

		local UnderBarrelAtt = AttModels[WeaponData.UnderBarrelAtt]:Clone()
		UnderBarrelAtt.Parent = weapon
		UnderBarrelAtt:SetPrimaryPartCFrame(weapon.Nodes.UnderBarrel.CFrame)


		for index, key in pairs(UnderBarrelAtt:GetChildren()) do
			if not key:IsA('BasePart') then continue; end;
			Ultil.Weld(weapon:WaitForChild("Handle"), key )
			key.Anchored = false
			key.CanCollide = false
		end
	end

	if weapon.Nodes:FindFirstChild("Other") and WeaponData.OtherAtt ~= "" then

		local OtherAtt = AttModels[WeaponData.OtherAtt]:Clone()
		OtherAtt.Parent = weapon
		OtherAtt:SetPrimaryPartCFrame(weapon.Nodes.Other.CFrame)

		for index, key in pairs(OtherAtt:GetChildren()) do
			if not key:IsA('BasePart') then continue; end;
			Ultil.Weld(weapon:WaitForChild("Handle"), key )
			key.Anchored = false
			key.CanCollide = false

		end
	end
end

function SetupRepAmmo(Tool,Settings)
	if not Tool:FindFirstChild("RepValues") then
		local repValues = Instance.new("Folder",Tool)
		repValues.Name = "RepValues"

		local mag = Instance.new("IntValue",repValues)
		mag.Name = "Mag"
		mag.Value = Settings.AmmoInGun

		--local storedAmmo = Instance.new("IntValue",repValues)
		--storedAmmo.Name = "StoredAmmo"
		--storedAmmo.Value = Settings.StoredAmmo

		local chambered = Instance.new("BoolValue",repValues)
		chambered.Name = "Chambered"
		chambered.Value = true
	end
end

Evt.Equip.OnServerEvent:Connect(function(Player,Arma,Mode,Settings,Anim)
	if not Player or not Player.Character then return; end;

	local Head 		= Player.Character:FindFirstChild('Head')
	local Torso 	= Player.Character:FindFirstChild('Torso')
	local LeftArm 	= Player.Character:FindFirstChild('Left Arm')
	local RightArm 	= Player.Character:FindFirstChild('Right Arm')

	if not Head or not Torso or not LeftArm or not RightArm then return; end;
	local RS 		= Torso:FindFirstChild("Right Shoulder")
	local LS 		= Torso:FindFirstChild("Left Shoulder")
	if not RS or not LS then return; end;
	
	--// Replicate Ammo
	if Arma then SetupRepAmmo(Arma,Settings) end

	--// EQUIP
	if Mode == 1 then
		local GunModel = GunModels:FindFirstChild(Arma.Name)
		if not GunModel then warn(Player.Name..": Couldn't load Server-side weapon model") return; end;

		local ServerGun = GunModel:Clone()
		ServerGun.Name = 'S' .. Arma.Name
		
		for _, part in pairs(ServerGun:GetChildren()) do
			if part.Name == "Warhead" and Settings.IsLauncher and Arma:FindFirstChild("RepValues") and Arma.RepValues.Mag.Value < 1 then
				part.Transparency = 1
			end
		end

		local AnimBase = Instance.new("Part", Player.Character)
		AnimBase.FormFactor = "Custom"
		AnimBase.CanCollide = false
		AnimBase.Transparency = 1
		AnimBase.Anchored = false
		AnimBase.Name = "AnimBase"
		AnimBase.Size = Vector3.new(0.1, 0.1, 0.1)

		local AnimBaseW = Instance.new("Motor6D")
		AnimBaseW.Part0 = Head
		AnimBaseW.Part1 = AnimBase
		AnimBaseW.Parent = AnimBase
		AnimBaseW.Name = "AnimBaseW"
		--AnimBaseW.C0 = CFrame.new(0,-1.25,0)

		local ruaw = Instance.new("Motor6D")
		ruaw.Name = "RAW"
		ruaw.Part0 = RightArm
		ruaw.Part1 = AnimBase
		ruaw.Parent = AnimBase
		ruaw.C0 = Anim.SV_RightArmPos
		RS.Enabled = false

		local luaw = Instance.new("Motor6D")
		luaw.Name = "LAW"
		luaw.Part0 = LeftArm
		luaw.Part1 = AnimBase
		luaw.Parent = AnimBase
		luaw.C0 = Anim.SV_LeftArmPos
		LS.Enabled = false

		ServerGun.Parent = Player.Character

		loadAttachment(ServerGun,Settings)

		if ServerGun:FindFirstChild("Nodes") ~= nil then
			ServerGun.Nodes:Destroy()
		end

		for SKP_001, SKP_002 in pairs(ServerGun:GetDescendants()) do
			if SKP_002.Name ~= "SightMark" then continue; end;
			SKP_002:Destroy()
		end

		for SKP_001, SKP_002 in pairs(ServerGun:GetDescendants()) do
			if not SKP_002:IsA('BasePart') or SKP_002.Name == 'Handle' then continue; end;
			Ultil.WeldComplex(ServerGun:WaitForChild("Handle"), SKP_002, SKP_002.Name)
		end

		local SKP_004 = Instance.new('Motor6D')
		SKP_004.Name = 'Handle'
		SKP_004.Parent = ServerGun.Handle
		SKP_004.Part0 = RightArm
		SKP_004.Part1 = ServerGun.Handle
		SKP_004.C1 = Anim.SV_GunPos:inverse()
		
		if Arma:FindFirstChild("Animate") then
			if Arma:FindFirstChild("Animate").Value then
				local AnimScript = Arma.ACS_Animations
				AnimScript.ServerAnimations:Clone().Parent = Player.Character
				local Animator = Instance.new("Animator", Player.Character:FindFirstChild("Humanoid"))
				for i, v in pairs(AnimScript.ServerAnimations:GetChildren()) do
					if v:IsA("Animation") then
						local loadhum = workspace.CurrentCamera.Viewmodel.Humanoid
						loadhum:LoadAnimation(v)
					end
				end
			end
		end

		for L_74_forvar1, L_75_forvar2 in pairs(ServerGun:GetDescendants()) do
			if not L_75_forvar2:IsA('BasePart') then continue; end;
			L_75_forvar2.Anchored = false
			L_75_forvar2.CanCollide = false
		end
		return;
		
	end;
	--// UNEQUIP
	if Mode == 2 then
		if Arma and Player.Character:FindFirstChild('S' .. Arma.Name) then
			Player.Character['S' .. Arma.Name]:Destroy()
			Player.Character.AnimBase:Destroy()
		end

		RS.Enabled = true
		LS.Enabled = true
	end
	return;
end)

Evt.Squad.OnServerEvent:Connect(function(Player,SquadName,SquadColor)
	if not Player or not Player.Character then return; end;
	if not Player.Character:FindFirstChild("ACS_Client") then return; end;

	Player.Character.ACS_Client.FireTeam.SquadName.Value = SquadName
	Player.Character.ACS_Client.FireTeam.SquadColor.Value = SquadColor
end)

Evt.HeadRot.OnServerEvent:connect(function(Player, CF)
	Evt.HeadRot:FireAllClients(Player, CF)
end)

Evt.Atirar.OnServerEvent:Connect(function(Player, Arma, Suppressor, FlashHider)
	Evt.Atirar:FireAllClients(Player, Arma, Suppressor, FlashHider)
end)

Evt.Whizz.OnServerEvent:Connect(function(Player, Victim)
	Evt.Whizz:FireClient(Victim)
end)

Evt.Suppression.OnServerEvent:Connect(function(Player,Victim,Mode,Intensity,Time)
	Evt.Suppression:FireClient(Victim,Mode,Intensity,Time)
end)

Evt.Refil.OnServerEvent:Connect(function(Player, Tool, Infinite, ContainerStored, MaxStoredAmmo, CurrentStored)
	
	local Settings = require(Tool.ACS_Settings)
	
	if Settings.Type == "Gun" then
		if not Tool:FindFirstChild("RepValues") then
			SetupRepAmmo(Tool,Settings)
		end
		
		local RepValues = Tool.RepValues
		
		if not Infinite then
			local AmountLeft = CurrentStored or RepValues.StoredAmmo.Value
			ContainerStored.Value = ContainerStored.Value - (MaxStoredAmmo - AmountLeft)
		end
	
		RepValues.StoredAmmo.Value = MaxStoredAmmo
	end
	
end)

Evt.SVLaser.OnServerEvent:Connect(function(Player,Position,Modo,Cor,IRmode,Arma)
	Evt.SVLaser:FireAllClients(Player,Position,Modo,Cor,IRmode,Arma)
end)

Evt.SVFlash.OnServerEvent:Connect(function(Player,Arma,Mode)
	Evt.SVFlash:FireAllClients(Player,Arma,Mode)
end)

----------------------------------------------------------------
--\\DOORS & BREACHING SYSTEM
----------------------------------------------------------------

local DoorsFolder 		= ACS_Workspace:FindFirstChild("Doors")
local DoorsFolderClone 	= DoorsFolder:Clone()
local BreachClone 		= ACS_Workspace.Breach:Clone()
BreachClone.Parent 		= ServerStorage
DoorsFolderClone.Parent = ServerStorage

function ToggleDoor(Door)
	local Hinge = Door.Door:FindFirstChild("Hinge")
	if not Hinge then return end
	local HingeConstraint = Hinge.HingeConstraint

	if HingeConstraint.TargetAngle == 0 then
		HingeConstraint.TargetAngle = -90
	elseif HingeConstraint.TargetAngle == -90 then
		HingeConstraint.TargetAngle = 0
	end	
end

Evt.DoorEvent.OnServerEvent:Connect(function(Player,Door,Mode,Key)
	if Door ~= nil then
		if Mode == 1 then
			if Door:FindFirstChild("Locked") ~= nil and Door.Locked.Value == true then
				if Door:FindFirstChild("RequiresKey") then
					local Character = Player.Character
					if Character:FindFirstChild(Key) ~= nil or Player.Backpack:FindFirstChild(Key) ~= nil then
						if Door.Locked.Value == true then
							Door.Locked.Value = false
						end
						ToggleDoor(Door)
					end	
				end
			else
				ToggleDoor(Door)
			end
		elseif Mode == 2 then
			if Door:FindFirstChild("Locked") == nil or (Door:FindFirstChild("Locked") ~= nil and Door.Locked.Value == false) then
				ToggleDoor(Door)
			end
		elseif Mode == 3 then
			if Door:FindFirstChild("RequiresKey") then
				local Character = Player.Character
				Key = Door.RequiresKey.Value
				if Character:FindFirstChild(Key) ~= nil or Player.Backpack:FindFirstChild(Key) ~= nil then
					if Door:FindFirstChild("Locked") ~= nil and Door.Locked.Value == true then
						Door.Locked.Value = false
					else
						Door.Locked.Value = true
					end
				end
			end
		elseif Mode == 4 then
			if Door:FindFirstChild("Locked") ~= nil and Door.Locked.Value == true then
				Door.Locked.Value = false
			end
		end
	end
end)

Evt.MedSys.Collapse.OnServerEvent:Connect(function(Player)

	if not Player or not Player.Character then return; end;

	local Human 	= Player.Character:FindFirstChild("Humanoid") 
	local PClient 	= Player.Character:FindFirstChild("ACS_Client") 

	if not Human or not PClient then return; end;

	local Dor 		= PClient.Variaveis.Dor
	local Sangue 	= PClient.Variaveis.Sangue

	if (Sangue.Value <= 3500) or (Dor.Value >= 200) or PClient:GetAttribute("Collapsed") then -- Man this Guy's Really wounded,
		Human.PlatformStand = true
		Human.AutoRotate = false	
		PClient:SetAttribute("Collapsed",true)
	elseif (Sangue.Value > 3500) and (Dor.Value < 200) and not PClient:GetAttribute("Collapsed")  then -- YAY A MEDIC ARRIVED! =D
		Human.PlatformStand = false
		Human.AutoRotate = true	
		PClient:SetAttribute("Collapsed",false)
	end
end)

Evt.MedSys.MedHandler.OnServerEvent:Connect(function(Player, Victim, Mode)
	if not Player or not Player.Character then return; end;
	if not Player.Character:FindFirstChild("Humanoid") or Player.Character.Humanoid.Health <= 0 then return; end;

	local P1_Client = Player.Character:FindFirstChild("ACS_Client")
	if not P1_Client then warn(Player.Name.."'s Action Failed: Missing ACS_Client"); return; end;

	if P1_Client:GetAttribute("Collapsed") then return; end;

	if Victim then --Multiplayer functions
		if not Victim.Character or not Victim.Character:FindFirstChild("HumanoidRootPart") or not Player.Character:FindFirstChild("HumanoidRootPart") then return; end;
		if (Player.Character.HumanoidRootPart.Position - Victim.Character.HumanoidRootPart.Position).Magnitude > 15 then warn(Player.Name.." is too far to treat "..Victim.Name); return; end;


		local P2_Client = Victim.Character:FindFirstChild("ACS_Client")
		if not P2_Client then warn(Player.Name.."'s Action Failed: Missing "..Victim.Name.."'s ACS_Client"); return; end;

		if Mode == 1 and P1_Client.Kit.Bandage.Value > 0 and P2_Client:GetAttribute("Bleeding") then
			P1_Client.Kit.Bandage.Value = P1_Client.Kit.Bandage.Value - 1
			P2_Client:SetAttribute("Bleeding",false)
			return;

		elseif Mode == 2 and P1_Client.Kit.Splint.Value > 0 and P2_Client:GetAttribute("Injured") then
			P1_Client.Kit.Splint.Value = P1_Client.Kit.Splint.Value - 1
			P2_Client:SetAttribute("Injured",false)
			return;

		elseif Mode == 3 and (P2_Client:GetAttribute("Bleeding") == true or P2_Client:GetAttribute("Tourniquet")) then --Tourniquet works a little different :T
			if P2_Client:GetAttribute("Tourniquet")then
				P1_Client.Kit.Tourniquet.Value = P1_Client.Kit.Tourniquet.Value + 1
				P2_Client:SetAttribute("Tourniquet",false)
				return;
			end

			if P1_Client.Kit.Tourniquet.Value <= 0 then return; end;
			P1_Client.Kit.Tourniquet.Value = P1_Client.Kit.Tourniquet.Value - 1
			P2_Client:SetAttribute("Tourniquet",true)
			return;

		elseif Mode == 4 and P1_Client.Kit.PainKiller.Value > 0 and P2_Client.Variaveis.Dor.Value > 0 then
			P1_Client.Kit.PainKiller.Value = P1_Client.Kit.PainKiller.Value - 1
			P2_Client.Variaveis.Dor.Value = math.clamp(P2_Client.Variaveis.Dor.Value - math.random(35,65),0,300)
			Evt.MedSys.MedHandler:FireClient(Victim,4)
			return;

		elseif Mode == 5 and P1_Client.Kit.EnergyShot.Value > 0 and Victim.Character.Humanoid.Health < Victim.Character.Humanoid.MaxHealth then
			P1_Client.Kit.EnergyShot.Value = P1_Client.Kit.EnergyShot.Value - 1
			local HealValue = math.random(15,25)
			if Victim.Character.Humanoid.Health + HealValue < Victim.Character.Humanoid.MaxHealth then
				Victim.Character.Humanoid:TakeDamage(-HealValue)
			else
				Victim.Character.Humanoid.Health = Victim.Character.Humanoid.MaxHealth
			end
			Evt.MedSys.MedHandler:FireClient(Victim,5)
			return;

		elseif Mode == 6 and P1_Client.Kit.Morphine.Value > 0 and P2_Client.Variaveis.Dor.Value > 0 then
			P1_Client.Kit.Morphine.Value = P1_Client.Kit.Morphine.Value - 1
			P2_Client.Variaveis.Dor.Value = 0
			Evt.MedSys.MedHandler:FireClient(Victim,6)
			return;

		elseif Mode == 7 and P1_Client.Kit.Epinephrine.Value > 0 and P2_Client:GetAttribute("Collapsed")then
			P1_Client.Kit.Epinephrine.Value = P1_Client.Kit.Epinephrine.Value - 1
			local HealValue = math.random(45,55)
			if Victim.Character.Humanoid.Health + HealValue < Victim.Character.Humanoid.MaxHealth then
				Victim.Character.Humanoid:TakeDamage(-HealValue)
			else
				Victim.Character.Humanoid.Health = Victim.Character.Humanoid.MaxHealth
			end
			P2_Client:SetAttribute("Collapsed",false)
			Evt.MedSys.MedHandler:FireClient(Victim,7)
			return;

		elseif Mode == 8 and P1_Client.Kit.BloodBag.Value > 0 and P2_Client.Variaveis.Sangue.Value < P2_Client.Variaveis.Sangue.MaxValue then
			P1_Client.Kit.BloodBag.Value = P1_Client.Kit.BloodBag.Value - 1
			P2_Client.Variaveis.Sangue.Value = P2_Client.Variaveis.Sangue.Value + 2000
			return;
		else
			warn(Player.Name.."'s Action Failed: Unknow Method")
		end
		return;
	end 
	--Self treat
	if Mode == 1 and P1_Client.Kit.Bandage.Value > 0 and P1_Client:GetAttribute("Bleeding") then
		P1_Client.Kit.Bandage.Value = P1_Client.Kit.Bandage.Value - 1
		P1_Client:SetAttribute("Bleeding",false)
		return;

	elseif Mode == 2 and P1_Client.Kit.Splint.Value > 0 and P1_Client:GetAttribute("Injured") then
		P1_Client.Kit.Splint.Value = P1_Client.Kit.Splint.Value - 1
		P1_Client:SetAttribute("Injured",false)
		return;

	elseif Mode == 3 and (P1_Client:GetAttribute("Bleeding") or P1_Client:GetAttribute("Tourniquet")) then --Tourniquet works a little diferent :T
		if P1_Client:GetAttribute("Tourniquet") then
			P1_Client.Kit.Tourniquet.Value = P1_Client.Kit.Tourniquet.Value + 1
			P1_Client:SetAttribute("Tourniquet",false)
			return;
		end

		if P1_Client.Kit.Tourniquet.Value <= 0 then return; end;
		P1_Client.Kit.Tourniquet.Value = P1_Client.Kit.Tourniquet.Value - 1
		P1_Client:SetAttribute("Tourniquet",true)
		return;

	elseif Mode == 4 and P1_Client.Kit.PainKiller.Value > 0 and P1_Client.Variaveis.Dor.Value > 0 then
		P1_Client.Kit.PainKiller.Value = P1_Client.Kit.PainKiller.Value - 1
		P1_Client.Variaveis.Dor.Value = math.clamp(P1_Client.Variaveis.Dor.Value - math.random(35,65),0,300)
		Evt.MedSys.MedHandler:FireClient(Player,4)
		return;

	elseif Mode == 5 and P1_Client.Kit.EnergyShot.Value > 0 and Player.Character.Humanoid.Health < Player.Character.Humanoid.MaxHealth then
		P1_Client.Kit.EnergyShot.Value = P1_Client.Kit.EnergyShot.Value - 1
		local HealValue = math.random(15,25)
		if Player.Character.Humanoid.Health + HealValue < Player.Character.Humanoid.MaxHealth then
			Player.Character.Humanoid:TakeDamage(-HealValue)
		else
			Player.Character.Humanoid.Health = Player.Character.Humanoid.MaxHealth
		end
		Evt.MedSys.MedHandler:FireClient(Player,5)
		return;

	elseif Mode == 6 and P1_Client.Kit.Morphine.Value > 0 and P1_Client.Variaveis.Dor.Value > 0 then
		P1_Client.Kit.Morphine.Value = P1_Client.Kit.Morphine.Value - 1
		P1_Client.Variaveis.Dor.Value = math.clamp(P1_Client.Variaveis.Dor.Value - math.random(125,175),0,300)
		Evt.MedSys.MedHandler:FireClient(Player,6)
		return;

	elseif Mode == 7 and P1_Client.Kit.Epinephrine.Value > 0 and Player.Character.Humanoid.Health < Player.Character.Humanoid.MaxHealth then
		P1_Client.Kit.Epinephrine.Value = P1_Client.Kit.Epinephrine.Value - 1
		local HealValue = math.random(45,55)
		if Player.Character.Humanoid.Health + HealValue < Player.Character.Humanoid.MaxHealth then
			Player.Character.Humanoid:TakeDamage(-HealValue)
		else
			Player.Character.Humanoid.Health = Player.Character.Humanoid.MaxHealth
		end
		Evt.MedSys.MedHandler:FireClient(Player,7)
		return;

	elseif Mode == 8 and P1_Client.Kit.BloodBag.Value > 0 and P1_Client.Variaveis.Sangue.Value < P1_Client.Variaveis.Sangue.MaxValue then
		P1_Client.Kit.BloodBag.Value = P1_Client.Kit.BloodBag.Value - 1
		P1_Client.Variaveis.Sangue.Value = P1_Client.Variaveis.Sangue.Value + 2000
		return;
	else
		warn(Player.Name.."'s Action Failed: Unknow Method")
	end
	return;
end)

Evt.Drag.OnServerEvent:Connect(function(player,Victim)
	if not player or not player.Character then return; end;

	local P1_Client = player.Character:FindFirstChild("ACS_Client")
	local Human 	= player.Character:FindFirstChild("Humanoid")

	if not P1_Client then return; end;

	if Victim then
		P1_Client:SetAttribute("DragPlayer",Victim.Name)
	else
		P1_Client:SetAttribute("DragPlayer","")
		P1_Client:SetAttribute("Dragging",false)
	end

	local target = P1_Client:GetAttribute("DragPlayer")

	if P1_Client:GetAttribute("Collapsed") or target == "" then return; end;

	local player2 = game.Players:FindFirstChild(target)
	if not player2 or not player2.Character then return; end;

	local PlHuman = player2.Character:FindFirstChild("Humanoid")
	local P2_Client = player2.Character:FindFirstChild("ACS_Client")
	if not PlHuman or not P2_Client then return; end;

	if P1_Client:GetAttribute("Dragging") then return; end;
	if not P2_Client:GetAttribute("Collapsed") then return; end;
	P1_Client:SetAttribute("Dragging",true)	
	while P1_Client:GetAttribute("Dragging") and target ~= "" and P2_Client:GetAttribute("Collapsed") and PlHuman.Health > 0 and Human.Health > 0 and not P1_Client:GetAttribute("Collapsed") do wait() 
		player2.Character.Torso.Anchored = true
		player2.Character.Torso.CFrame = Human.Parent.Torso.CFrame*CFrame.new(0,0.75,1.5)*CFrame.Angles(math.rad(0), math.rad(0), math.rad(90))
	end
	player2.Character.Torso.Anchored = false		
end)

function BreachFunction(Player,Mode,BreachPlace,Pos,Norm,Hit)

	if Mode == 1 then
		if Player.Character.ACS_Client.Kit.BreachCharges.Value > 0 then
			Player.Character.ACS_Client.Kit.BreachCharges.Value = Player.Character.ACS_Client.Kit.BreachCharges.Value - 1
			BreachPlace.Destroyed.Value = true
			local C4 = Engine.FX.BreachCharge:Clone()

			C4.Parent = BreachPlace.Destroyable
			C4.Center.CFrame = CFrame.new(Pos, Pos + Norm) * CFrame.Angles(math.rad(-90),math.rad(0),math.rad(0))
			C4.Center.Place:play()

			local weld = Instance.new("WeldConstraint")
			weld.Parent = C4
			weld.Part0 = BreachPlace.Destroyable.Charge
			weld.Part1 = C4.Center

			wait(1)
			C4.Center.Beep:play()
			wait(4)
			if C4 and C4:FindFirstChild("Center") then
				local att = Instance.new("Attachment")
				att.CFrame = C4.Center.CFrame
				att.Parent = workspace.Terrain

				local aw = Engine.FX.ExpEffect:Clone()
				aw.Parent = att
				aw.Enabled = false
				aw:Emit(35)
				Debris:AddItem(aw,aw.Lifetime.Max)

				local Exp = Instance.new("Explosion")
				Exp.BlastPressure = 0
				Exp.BlastRadius = 0
				Exp.DestroyJointRadiusPercent = 0
				Exp.Position = C4.Center.Position
				Exp.Parent = workspace

				local S = Instance.new("Sound")
				S.EmitterSize = 10
				S.MaxDistance = 1000
				S.SoundId = "rbxassetid://"..Explosion[math.random(1, 7)]
				S.PlaybackSpeed = math.random(30,55)/40
				S.Volume = 2
				S.Parent = att
				S.PlayOnRemove = true
				S:Destroy()

				for SKP_001, SKP_002 in pairs(game.Players:GetChildren()) do
					if SKP_002:IsA('Player') and SKP_002.Character and SKP_002.Character:FindFirstChild('Head') and (SKP_002.Character.Head.Position - C4.Center.Position).magnitude <= 15 then
						local DistanceMultiplier = (((SKP_002.Character.Head.Position - C4.Center.Position).magnitude/35) - 1) * -1
						local intensidade = DistanceMultiplier
						local Tempo = 15 * DistanceMultiplier
						Evt.Suppression:FireClient(SKP_002,2,intensidade,Tempo)
					end
				end

				Debris:AddItem(BreachPlace.Destroyable,0)
			end
		end

	elseif Mode == 2 then

		local aw = Engine.FX.DoorBreachFX:Clone()
		aw.Parent = BreachPlace.Door.Door
		aw.RollOffMaxDistance = 100
		aw.RollOffMinDistance = 5
		aw:Play()

		BreachPlace.Destroyed.Value = true
		if BreachPlace.Door:FindFirstChild("Hinge") ~= nil then
			BreachPlace.Door.Hinge:Destroy()
		end
		if BreachPlace.Door:FindFirstChild("Knob") ~= nil then
			BreachPlace.Door.Knob:Destroy()
		end

		local forca = Instance.new("BodyForce")
		forca.Force = -Norm * BreachPlace.Door.Door:GetMass() * Vector3.new(50,0,50)
		forca.Parent = BreachPlace.Door.Door

		Debris:AddItem(BreachPlace,3)

	elseif Mode == 3 then
		if Player.Character.ACS_Client.Kit.Fortifications.Value > 0 then
			Player.Character.ACS_Client.Kit.Fortifications.Value = Player.Character.ACS_Client.Kit.Fortifications.Value - 1
			BreachPlace.Fortified.Value = true
			local C4 = Instance.new('Part')

			C4.Parent = BreachPlace.Destroyable
			C4.Size =  Vector3.new(Hit.Size.X + .05,Hit.Size.Y + .05,Hit.Size.Z + 0.5) 
			C4.Material = Enum.Material.DiamondPlate
			C4.Anchored = true
			C4.CFrame = Hit.CFrame

			local S = Engine.FX.FortFX:Clone()
			S.PlaybackSpeed = math.random(30,55)/40
			S.Volume = 1
			S.Parent = C4
			S.PlayOnRemove = true
			S:Destroy()
		end
	end
end

Evt.Breach.OnServerInvoke = BreachFunction

function UpdateLog(Player,humanoid)

	local tag = humanoid:findFirstChild("creator")

	if tag ~= nil then

		local hours = os.date("%H")
		local mins = os.date("%M")
		local sec = os.date("*S")
		local TagType = tag:findFirstChild("type")

		if tag.Value.Name == Player.Name then
			local String = Player.Name.." Died | "..hours..":"..mins..":"..sec
			table.insert(CombatLog,String)
		else
			local String = tag.Value.Name.." Killed "..Player.Name.." | "..hours..":"..mins..":"..sec
			table.insert(CombatLog,String)
		end

		if #CombatLog > 50 then
			Backup = Backup + 1
			warn("ACS: Cleaning Combat Log | Backup: "..Backup)
			warn(CombatLog)
			CombatLog = {}
		end
	end
end

-- Check if the player can run commands
function CheckHostID(player)

	-- Is the game running in studio
	if Run:IsStudio() then return true end


	if game.CreatorType == Enum.CreatorType.User then
		-- Is the player the game's owner
		if player.UserId == game.CreatorId then return true end
	elseif game.CreatorType == Enum.CreatorType.Group then
		-- Does the player have a high enough group rank
		if player:GetRankInGroup(game.CreatorId) >= gameRules.HostRank then return true end
	end

	-- Is the player in the game host list
	for _, cID in pairs(gameRules.HostList) do
		if player.UserId == cID then return true end
	end
	return false
end

-- Reset broken glass
function ResetGlass()
	for i, gData in pairs(dParts.Glass) do
		gData[1].Parent = gData[2]

		for _, shard in pairs(gData[3]) do
			if shard then shard:Destroy() end
		end

		dParts.Glass[i] = nil
	end
end

-- Reset broken lights
function ResetLights()
	for i, lData in pairs(dParts.Lights) do
		lData[1].Material = lData[2]
		lData[1].Broken:Destroy()

		for _, light in pairs(lData[1]:GetChildren()) do
			if light:IsA("Light") then
				light.Enabled = true
			end
		end
	end
end

-- Clear dropped weapons
function ClearDroppedGuns()
	for _, weapon in pairs(ACS_Workspace.DroppedGuns) do
		weapon:Destroy()
	end
end

function SetupCharacter(player, char)
	for _, part in pairs(char:GetDescendants()) do
		if part:IsA("BasePart") then
			PhysService:SetPartCollisionGroup(part,"Characters")
		end
	end

	if gameRules.TeamTags then
		local L_17_ = HUDs:WaitForChild('TeamTagUI'):clone()
		L_17_.Parent = char
		L_17_.Adornee = char.Head
	end

	char.Humanoid.BreakJointsOnDeath = false
	char.Humanoid.Died:Connect(function()

		-- Drop tools on death
		if gameRules.DropWeaponsOnDeath then
			for _, currTool in pairs(player.Backpack:GetChildren()) do
				if currTool:IsA("Tool") and currTool:FindFirstChild("ACS_Settings") then
					local gunFrame

					if char:FindFirstChild("S_"..currTool.Name) then
						gunFrame = char["S_"..currTool.Name].Handle.CFrame
						char:FindFirstChild("S_"..currTool.Name):Destroy()
					else
						gunFrame = char.Torso.CFrame * CFrame.new(math.random(-5,5) / 10,1,-2)
					end

					SpawnGun(currTool.Name,gunFrame,currTool,player)
					wait()
				end
			end

			wait()
			-- Drop a gun if the player was holding it
			if char:FindFirstChildWhichIsA("Tool") and char:FindFirstChildWhichIsA("Tool"):FindFirstChild("ACS_Settings") then
				local gunName = char:FindFirstChildWhichIsA("Tool").Name
				SpawnGun(gunName,char.Torso.CFrame * CFrame.new(math.random(-5,5) / 10,1,-2),char[gunName],player)
			end
		end

		UpdateLog(player,char.Humanoid)
		pcall(function()
			local clone = char:Clone()
			Debris:AddItem(clone, 30)
			Ragdoll(clone)
		end)
		coroutine.resume(coroutine.create(function()
			wait(10)
			player:LoadCharacter()
		end))
	end)

	repeat wait() until player:FindFirstChild("Backpack")

	-- Check the player's backpack for ACS guns
	for _, tool in pairs(player.Backpack:GetChildren()) do
		if tool:FindFirstChild("ACS_Settings") and require(tool.ACS_Settings).Holster then
			CheckHolster(player,tool.Name,require(tool.ACS_Settings),tool)
		end
	end

	-- Set up listeners for future tools
	player.Backpack.ChildAdded:Connect(function(newChild)
		if newChild:IsA("Tool") and newChild:FindFirstChild("ACS_Settings") and require(newChild.ACS_Settings).Holster then
			CheckHolster(player,newChild.Name,require(newChild.ACS_Settings),newChild)
		end
	end)

	player.Backpack.ChildRemoved:Connect(function(newChild)
		if newChild:IsA("Tool") and newChild:FindFirstChild("ACS_Settings") and char:FindFirstChild("S_"..newChild.Name) and not player.Backpack:FindFirstChild(newChild.Name) then
			char:FindFirstChild("S_"..newChild.Name):Destroy()
		end
	end)
	

end

-- Check if a holster model can be added
function CheckHolster(player,weaponName,toolSettings,tool)
	if player.Character and not player.Character:FindFirstChild("S_"..weaponName) and not player.Character:FindFirstChild(weaponName) then
		HolsterWeapon(player,weaponName,toolSettings,tool)
	end
end

-- Weld holster model to the player
function HolsterWeapon(player,weaponName,toolSettings,tool)
	if player.Character:FindFirstChild(toolSettings.HolsterPoint) then
		local holsterPoint = toolSettings.HolsterPoint
		local holsterModel = GunModels:FindFirstChild(weaponName):Clone()
		holsterModel.Name = "S_"..weaponName
		holsterModel.Parent = player.Character

		if holsterModel:FindFirstChild("Nodes") then
			holsterModel.Nodes:Destroy()
		end
		
		local config = tool:FindFirstChild("RepValues")
		
		for _, part in pairs(holsterModel:GetChildren()) do
			if part:IsA("BasePart") and part.Name ~= "Handle" then
				if part.Name == "SightMark" or (part.Name == "Warhead" and config and config.Mag.Value < 1) then
					part:Destroy()
				else
					local newWeld = Ultil.WeldComplex(holsterModel.Handle,part,part.Name)
					newWeld.Parent = holsterModel.Handle
					part.Anchored = false
					part.CanCollide = false
				end
			end
		end

		local holsterWeld = Ultil.Weld(player.Character[holsterPoint],holsterModel.Handle,toolSettings.HolsterCFrame)
		holsterWeld.Parent = holsterModel
		holsterWeld.Name = "HolsterWeld"
		holsterModel.Handle.Anchored = false
	end
end

function SpawnGun(gunName,gunPosition,tool,player,config)

	local dropModel = GunModels:FindFirstChild(gunName):Clone()
	dropModel.Handle.Anchored = false
	dropModel.Handle.CanTouch = true
	--dropModel.Handle.CFrame = CFrame.new(dropModel["Origin Position"])

	dropModel.PrimaryPart = dropModel.Handle
	dropModel.Handle.Size = dropModel:GetExtentsSize()

	if dropModel:FindFirstChild("Nodes") then dropModel.Nodes:Destroy() end
	
	if #dropModel:GetChildren() < 2 then
		dropModel.Handle.CanCollide = true
	else
		dropModel.Handle.CanCollide = false
	end

	for _, part in pairs(dropModel:GetChildren()) do
		if part.Name == "Warhead" and config and config.IsLauncher and tool:FindFirstChild("RepValues") and tool.RepValues.Mag.Value < 1 then
			part:Destroy()
		elseif part:IsA("BasePart") and part.Name ~= "Handle" then
			local newWeld = Ultil.WeldComplex(dropModel.Handle,part,part.Name)
			newWeld.Parent = dropModel.Handle
			part.Anchored = false
			part.CanCollide = true
			part.CanTouch = false
			PhysService:SetPartCollisionGroup(part,"Guns")
		end
	end

	if not tool then
		tool = Engine.ToolStorage:FindFirstChild(gunName):Clone()
	end
	tool.Parent = dropModel

	local clickDetector = Instance.new("ClickDetector")
	clickDetector.MaxActivationDistance = gameRules.PickupDistance
	clickDetector.Parent = dropModel
	clickDetector.MouseClick:Connect(function(clicker)

		tool.Parent = clicker.Backpack
		dropModel:Destroy()

		local NewSound = Engine.FX.WeaponPickup:Clone()
		NewSound.Parent = clicker.Character.Torso
		--NewSound.PlaybackSpeed = math.random(30,50)/40
		NewSound:Play()
		NewSound.PlayOnRemove = true
		NewSound:Destroy()
	end)

	dropModel.Parent = ACS_Workspace.DroppedGuns

	dropModel.Handle.Touched:Connect(function()
		if dropModel.Handle.AssemblyLinearVelocity.Magnitude > 7 then
			local DropSounds = Engine.FX.GunDrop
			local NewSound = DropSounds["GunDrop"..math.random(#DropSounds:GetChildren())]:Clone()
			NewSound.Parent = dropModel.Handle
			NewSound.PlaybackSpeed = math.random(30,50)/40
			NewSound:Play()
			NewSound.PlayOnRemove = true
			NewSound:Destroy()
		end
	end)

	if player then dropModel.Handle:SetNetworkOwner(player) end

	dropModel:SetPrimaryPartCFrame(gunPosition)

	if #ACS_Workspace.DroppedGuns:GetChildren() > gameRules.MaxDroppedWeapons then
		ACS_Workspace.DroppedGuns:GetChildren()[1]:Destroy()
	end

	if gameRules.TimeDespawn then
		Debris:AddItem(dropModel,gameRules.WeaponDespawnTime)
	end

	return dropModel
end

plr.PlayerAdded:Connect(function(player)

	player.CharacterRemoving:Connect(function(char)

		if char:FindFirstChild("Humanoid") and char.Humanoid.Health > 0 and gameRules.DropWeaponsOnLeave then
			local pos = char.Torso.CFrame
			local tools = {}

			-- Get tools before player leaves
			for _, currTool in pairs(player.Backpack:GetChildren()) do
				if currTool:IsA("Tool") and currTool:FindFirstChild("ACS_Settings") then
					table.insert(tools,currTool)
					currTool.Parent = nil
				end
			end

			if char:FindFirstChildWhichIsA("Tool") and char:FindFirstChildWhichIsA("Tool"):FindFirstChild("ACS_Settings") then
				table.insert(tools,char:FindFirstChildWhichIsA("Tool"))
				char:FindFirstChildWhichIsA("Tool").Parent = nil
				--SpawnGun(gunName,char.Torso.CFrame * CFrame.new(math.random(-5,5) / 10,1,-2),char[gunName],player)
			end

			for _, gun in pairs(tools) do
				SpawnGun(gun.Name,pos,gun)
				wait()
			end
		end

	end)

	for i,v in ipairs(_G.TempBannedPlayers) do
		if v == player.Name then
			player:Kick('Blacklisted')
			warn(player.Name.." (Temporary Banned) tried to join to server")
			break
		end
	end

	for i,v in ipairs(gameRules.Blacklist) do
		if v == player.UserId then
			player:Kick('Blacklisted')
			warn(player.Name.." (Blacklisted) tried to join to server")
			break
		end
	end

	if gameRules.AgeRestrictEnabled and not Run:IsStudio() then
		if player.AccountAge < gameRules.AgeLimit then
			player:Kick('Age restricted server! Please wait: '..(gameRules.AgeLimit - player.AccountAge)..' Days')
		end
	end

	--if game.CreatorType == Enum.CreatorType.User then
	--	if player.UserId == game.CreatorId or Run:IsStudio() then
	--		player.Chatted:Connect(function(Message)
	--			if string.lower(Message) == "/acslog" then
	--				Evt.CombatLog:FireClient(player,CombatLog)
	--			end
	--		end)
	--	end
	--elseif game.CreatorType == Enum.CreatorType.Group then
	--	if player:IsInGroup(game.CreatorId) or Run:IsStudio() then
	--		player.Chatted:Connect(function(Message)
	--			if string.lower(Message) == "/acslog" then
	--				Evt.CombatLog:FireClient(player,CombatLog)
	--			end
	--		end)
	--	end
	--end

	if CheckHostID(player) then
		player.Chatted:Connect(function(msg)
			-- Convert to lowercase
			msg = string.lower(msg)

			local pfx = gameRules.CommandPrefix

			if msg == pfx.."acslog" or msg == pfx.."acs log" then
				Evt.CombatLog:FireClient(player,CombatLog)
			elseif msg == pfx.."reset all" or msg == pfx.."resetall" or msg == pfx.."reset" then
				ResetGlass()
				ResetLights()
			elseif msg == pfx.."reset glass" or msg == pfx.."resetglass" then
				ResetGlass()
			elseif msg == pfx.. "reset lights" or msg == pfx.."resetlights" then
				ResetLights()
			elseif msg == pfx.. "clear guns" or msg == pfx.."clearguns" then
				ClearDroppedGuns()
			end
		end)
	end


	local setupWorked = false
	player.CharacterAdded:Connect(function(char)
		setupWorked = true
		SetupCharacter(player,char)
	end)

	-- Character setup failsafe
	repeat wait() until player.Character
	if not setupWorked then SetupCharacter(player,player.Character) end
end)

Evt.Shell.OnServerEvent:Connect(function(Player,Shell,Origin)
	Evt.Shell:FireAllClients(Shell,Origin)
end)

Evt.DropWeapon.OnServerEvent:Connect(function(player,tool,toolConfig)
	local tool = player.Backpack:FindFirstChild(tool.Name)
	--print(player.Name.. " dropped a " ..tool.Name)
	--tool:Destroy()
	local NewSound = Engine.FX.WeaponDrop:Clone()
	NewSound.Parent = player.Character.Torso
	--NewSound.PlaybackSpeed = math.random(30,50)/40
	NewSound:Play()
	NewSound.PlayOnRemove = true
	NewSound:Destroy()
	SpawnGun(tool.Name,player.Character.Torso.CFrame * CFrame.new(0,1,-3),tool,player,toolConfig)
end)

Evt.RepAmmo.OnServerEvent:Connect(function(Player,tool,mag,ammo,chambered)
	local config = tool.RepValues
--	config.StoredAmmo.Value = ammo
	config.Mag.Value = mag
	config.Chambered.Value = chambered
	
	if tool.Parent:FindFirstChild("Humanoid") and tool.Parent:FindFirstChild("S"..tool.Name) then
		-- Tool is equipped
		for _, part in pairs(tool.Parent["S"..tool.Name]:GetChildren()) do
			if part.Name == "Warhead" then
				if mag > 0 then
					part.Transparency = 0
				else
					part.Transparency = 1
				end
			end
		end
	end
end)

Evt.DropAmmo.OnServerEvent:Connect(function(Player,tool,action)
	if action == "Weld" then
		local canModel = Engine.AmmoModels.AmmoBox:Clone()
		local handle = tool.Handle
		for _, part in pairs(canModel:GetChildren()) do
			if part:IsA("BasePart") and part.Name ~= "Main" then
				local newWeld = Ultil.WeldComplex(canModel.Main,part,part.Name)
				newWeld.Parent = canModel.Main
				part.Anchored = false
				part.CanCollide = true
				part.CanTouch = false
			end

			PhysService:SetPartCollisionGroup(part,"Guns")

			if part.Name == "Main" then
				for _, child in pairs(part:GetChildren()) do
					if child:FindFirstChildWhichIsA("TextLabel") then
						child:FindFirstChildWhichIsA("TextLabel").Text = tool.AmmoType.Value
					end
				end
			end
		end
		local newWeld = Ultil.Weld(handle,canModel.Main,CFrame.new(0,-0.2,0),CFrame.new())
		newWeld.Name = "ToolWeld"
		newWeld.Parent = handle
		canModel.Main.Anchored = false
		handle.Anchored = false
		canModel.Parent = tool
	elseif action == "Destroy" then
		if tool:FindFirstChildWhichIsA("Model") then
			tool:FindFirstChildWhichIsA("Model"):Destroy()
			tool.Handle.ToolWeld:Destroy()
		end
	elseif action == "Drop" then
		local canModel = tool:FindFirstChildWhichIsA("Model")
		local handle = tool.Handle
		handle.ToolWeld:Destroy()
		canModel.Parent = ACS_Workspace.DroppedGuns
		canModel.Main.Touched:Connect(function(hitPart)
			if plr:GetPlayerFromCharacter(hitPart.Parent) then

				local player = plr:GetPlayerFromCharacter(hitPart.Parent)
				local f = player.Backpack:GetChildren()
				for i = 1, #f do

					if f[i]:IsA("Tool") and f[i]:FindFirstChild("ACS_Settings") then
						if tool.AmmoType.Value == "Universal" then
							Evt.Refil:FireClient(player, f[i], tool.Inf.Value, tool.Stored)
							if not canModel.Main.Sound.Playing then
								canModel.Main.Sound:Play()
							end
						elseif require(f[i].ACS_Settings).BulletType == tool.AmmoType.Value then
							Evt.Refil:FireClient(player, f[i], tool.Inf.Value, tool.Stored)
							if not canModel.Main.Sound.Playing then
								canModel.Main.Sound:Play()
							end
						end
					end
				end

				-- No more ammo
				if tool.Stored.Value <= 0 and not tool.Inf.Value then
					canModel:Destroy()
					tool:Destroy()
					return
				end
			end
		end)
		tool.Parent = nil

		local clicker = Instance.new("ClickDetector",canModel)
		clicker.MaxActivationDistance = gameRules.PickupDistance
		clicker.MouseClick:Connect(function(Player)
			--print("Give")
			tool.Parent = Player:WaitForChild("Backpack")
			canModel:Destroy()
		end)

		Debris:AddItem(canModel, gameRules.AmmoBoxDespawn)
	end
end)


for _, spawner in pairs(ACS_Workspace.WeaponSpawners:GetChildren()) do
	local constrainedValue = Instance.new("DoubleConstrainedValue")
	local maxTime = spawner.Config.WaitTime

	constrainedValue.Name = "WaitTime"
	constrainedValue.MaxValue = maxTime.Value
	constrainedValue.Value = maxTime.Value
	constrainedValue.Parent = spawner.Config

	maxTime:Destroy()
end

-- Footsteps
local stepEvent = Evt.Step
stepEvent.OnServerEvent:Connect(function(player,soundId,volume,timeStamp)
	stepEvent:FireAllClients(player,soundId,volume,timeStamp)
end)

-- Blood effects
--if gameRules.BloodSplats then
--	Mods["Realistic Blood"].Parent = game:GetService("ServerScriptService")
--end

-- Weapon spawning
function SetupSpawner(spawner)
	spawner.Transparency = 1
	spawner.Size = Vector3.new(0.2,0.2,0.2)
	spawner.CanCollide = false

	local evt = Instance.new("BindableEvent")
	evt.Name = "SpawnEvent"
	evt.Parent = spawner

	evt.Event:Connect(function()
		local newGun = SpawnGun(string.sub(spawner.Name,7),spawner.CFrame)
		newGun.Parent = spawner
	end)

	Mods.WeaponSpawn:Clone().Parent = spawner
end

for _, spawner in pairs(ACS_Workspace.WeaponSpawners:GetChildren()) do
	SetupSpawner(spawner)
end

ACS_Workspace.WeaponSpawners.ChildAdded:Connect(function(newChild)
	SetupSpawner(newChild)
end)

-- Print version
print(gameRules.Version)
print("Ina's Ro-Combat Mod: Patch v1.2.2")

--while wait(1) do
--	for _, spawner in pairs(ACS_Workspace.WeaponSpawners:GetChildren()) do
--		spawner.Transparency = 1
--		spawner.Size = Vector3.new(0.2,0.2,0.2)
--		spawner.CanCollide = false

--		if not gameRules.SpawnStacking and not spawner:FindFirstChild("CurrentGun") then
--			local objValue = Instance.new("ObjectValue")
--			objValue.Name = "CurrentGun"
--			objValue.Parent = spawner
--		end

--		if not gameRules.SpawnStacking then
--			if not spawner.CurrentGun.Value then
--				spawner.Config.WaitTime.Value = spawner.Config.WaitTime.Value - 1
--			end
--		else
--			spawner.Config.WaitTime.Value = spawner.Config.WaitTime.Value - 1
--		end

--		if spawner.Config.WaitTime.Value < 1 then
--			if spawner.Config.SpawnNumber.Value > 0 or spawner.Config.Infinite.Value then
--				spawner.Config.SpawnNumber.Value = spawner.Config.SpawnNumber.Value - 1
--				local newGun = SpawnGun(string.sub(spawner.Name,7),spawner.CFrame)
--				spawner.Config.WaitTime.Value = spawner.Config.WaitTime.MaxValue

--				if not gameRules.SpawnStacking then
--					spawner.CurrentGun.Value = newGun

--					newGun.Changed:Connect(function()
--						if not newGun.Parent then
--							spawner.CurrentGun.Value = nil
--						end
--					end)
--				end
--			else
--				spawner:Destroy()
--			end
--		end
--	end
--end