local Debris = game:GetService("Debris")
local RS = game:GetService("ReplicatedStorage")

local Glass = {"1565824613"; "1565825075";}
local Metal = {"282954522"; "282954538"; "282954576"; "1565756607"; "1565756818";}
local Grass = {"1565830611"; "1565831129"; "1565831468"; "1565832329";}
local Wood = {"287772625"; "287772674"; "287772718"; "287772829"; "287772902";}
local Concrete = {"287769261"; "287769348"; "287769415"; "287769483"; "287769538";}
local Explosion = {"287390459"; "287390954"; "287391087"; "287391197"; "287391361"; "287391499"; "287391567";}
local Cracks = {"342190504"; "342190495"; "342190488"; "342190510";} -- Bullet Cracks
local Hits = {"363818432"; "363818488"; "363818567"; "363818611"; "363818653";} -- Player
local Headshots = {"4459572527"; "4459573786";"3739364168";}
local Whizz = {"342190005"; "342190012"; "342190017"; "342190024";} -- Bullet Whizz

local concrete_bulletholes = {
	"4117124202";
	"4117124881";
	"4117125609";
	"4117126706";
	"4117127411";
}
local glass_bulletholes =
	{"167586754";"347743032";}
local wood_bulletholes = 
	{"4117163813";"4117164277";}
local metal_bulletholes =
	{"190635569";"190093203";}
local bullet_wounds = 
	{"4117590991";"4117588426";"4117589176";"4117589687";"4117590335";}

local grass_bulletholes =
	{"6963521420";"6963521636";"6963521843";"6963522028"}

local sand_bulletholes =
	{"4123587259";"6963524091";"6963524338";"6963524556"}

local blood_splatter =
	{"4533673854";"166540317";"2417489356"; "3236192680"}

local ACS_Storage = workspace:WaitForChild("ACS_WorkSpace")
local BulletModel =  ACS_Storage.Server

local Effects = RS.ACS_Engine.HITFX

local Hitmarker = {}

function CheckColor(Color,Add)
	Color = Color + Add
	if Color > 1 then
		Color = 1
	elseif Color < 0 then
		Color = 0
	end
	return Color
end

function CreateEffect(Type,Attachment,ColorAdjust,HitPart)
	local NewType
	if Effects:FindFirstChild(Type) then
		NewType = Effects:FindFirstChild(Type)
	else
		NewType = Effects.Stone -- Default to Stone/Concrete
	end
	local NewEffect = NewType:GetChildren()[math.random(1,#NewType:GetChildren())]:Clone()
	local MaxTime = 3 -- Placeholder for max time of total effect
	for _, Effect in pairs(NewEffect:GetChildren()) do
		Effect.Parent = Attachment
		Effect.Enabled = false
		
		if ColorAdjust and HitPart then
			local NewColor = HitPart.Color
			local Add = 0.3
			if HitPart.Material == Enum.Material.Fabric then
				Add = -0.2 -- Darker
			end
			
			NewColor = Color3.new(CheckColor(NewColor.R, Add),CheckColor(NewColor.G, Add),CheckColor(NewColor.B, Add)) -- Adjust new color
			
			Effect.Color = ColorSequence.new({ -- Set effect color
				ColorSequenceKeypoint.new(0,NewColor),
				ColorSequenceKeypoint.new(1,NewColor)
			})
		end
		
		Effect:Emit(Effect.Rate / 10) -- Calculate how many particles emit based on rate
		if Effect.Lifetime.Max > MaxTime then
			MaxTime = Effect.Lifetime.Max
		end
	end
	local HitSound = Instance.new("Sound")
	local SoundType -- Convert Type to equivalent sound table
	if Type == "Headshot" then
		SoundType = Headshots
	elseif Type == "Hit" then
		SoundType = Hits
	elseif Type == "Glass" then
		SoundType = Glass
	elseif Type == "Metal" then
		SoundType = Metal
	elseif Type == "Ground" then
		SoundType = Grass
	elseif Type == "Wood" then
		SoundType = Wood
	elseif Type == "Stone" then
		SoundType = Concrete
	else
		SoundType = Concrete -- Default to Stone/Concrete
	end
	HitSound.Parent = Attachment
	HitSound.Volume = math.random(5,10)/10
	HitSound.MaxDistance = 500
	HitSound.EmitterSize = 10
	HitSound.PlaybackSpeed = math.random(34, 50)/40
	HitSound.SoundId = "rbxassetid://" .. SoundType[math.random(1, #SoundType)]
	HitSound:Play()
	if HitSound.TimeLength > MaxTime then MaxTime = HitSound.TimeLength end
	Debris:AddItem(Attachment,MaxTime) -- Destroy attachment after all effects and sounds are done
end


function Hitmarker.HitEffect(Ray_Ignore,Position, HitPart, Normal, Material,Settings)
	--print(HitPart)
	local Attachment = Instance.new("Attachment")
	Attachment.CFrame = CFrame.new(Position, Position + Normal)
	Attachment.Parent = workspace.Terrain
	if HitPart then
		if (HitPart.Name == "Head" or HitPart.Parent.Name == "Top") then
			
			CreateEffect("Headshot",Attachment)
			
		elseif HitPart:IsA("BasePart") and (HitPart.Parent:FindFirstChild("Humanoid") or HitPart.Parent.Parent:FindFirstChild("Humanoid") or (HitPart.Parent.Parent.Parent and HitPart.Parent.Parent.Parent:FindFirstChild("Humanoid"))) then

			CreateEffect("Hit",Attachment)

		elseif HitPart.Parent:IsA("Accessory") then -- Didn't feel like putting this in the other one
			
			CreateEffect("Hit",Attachment)
			
		elseif Material == Enum.Material.Wood or Material == Enum.Material.WoodPlanks then
			
			CreateEffect("Wood",Attachment)
			
		elseif HitPart.Material == Enum.Material.Concrete or  HitPart.Material == Enum.Material.Cobblestone or HitPart.Material == Enum.Material.Pebble or  HitPart.Material == Enum.Material.Fabric then
			local BulletWhizz = Instance.new("Sound")
			BulletWhizz.Parent = Attachment
			BulletWhizz.Volume = math.random(20,30)/10
			BulletWhizz.MaxDistance = 100
			BulletWhizz.EmitterSize = 5
			BulletWhizz.PlaybackSpeed = math.random(38, 46)/40
			BulletWhizz.SoundId = "rbxassetid://" .. Concrete[math.random(1, #Concrete)]

			BulletWhizz:Play()	

			local Particles = Instance.new("ParticleEmitter")
			Particles.Enabled = false
			Particles.Color = ColorSequence.new(Color3.new(50, 50, 50))
			Particles.LightEmission = 0
			Particles.LightInfluence = 1
			Particles.Size = NumberSequence.new(
				{
					NumberSequenceKeypoint.new(0, 0.1, 0.1);
					NumberSequenceKeypoint.new(1, 2);
				}
			)
			Particles.Texture = "rbxasset://textures/particles/smoke_main.dds"
			Particles.Transparency = NumberSequence.new(
				{
					NumberSequenceKeypoint.new(0, 0.75, 0);
					NumberSequenceKeypoint.new(1, 1);
				}
			)
			Particles.Acceleration = Vector3.new(0, 0, 0)
			Particles.Lifetime = NumberRange.new(0.5, 1)
			Particles.Rate = 1000
			Particles.Drag = 20
			Particles.RotSpeed = NumberRange.new(-360,360)
			Particles.Speed = NumberRange.new(15,30)
			Particles.SpreadAngle = Vector2.new(180,360)
			Particles.Parent = Attachment
			Particles.EmissionDirection = "Front"
			Particles:Emit(50)

			Debris:AddItem(Attachment, Particles.Lifetime.Max)

			local bg = Instance.new("BillboardGui", Attachment)
			bg.Adornee = Attachment
			local flashsize = math.random(10, 15)/10
			bg.Size = UDim2.new(flashsize, 0, flashsize, 0)
			local flash = Instance.new("ImageLabel", bg)
			flash.BackgroundTransparency = 1
			flash.Size = UDim2.new(0.05, 0, 0.05, 0)
			flash.Position = UDim2.new(0.5, 0, 0.5, 0)
			flash.Image = "http://www.roblox.com/asset/?id=476778304"
			flash.ImageTransparency = math.random(0, .5)
			flash.Rotation = math.random(0, 360)
			flash:TweenSizeAndPosition(UDim2.new(1, 0, 1, 0), UDim2.new(0, 0, 0, 0), "Out", "Quad", 0.1)	
			game.Debris:AddItem(bg, 0.1)

			local a = Instance.new("Part", BulletModel)
			a.FormFactor = "Custom"
			a.TopSurface = 0
			a.BottomSurface = 0
			a.Transparency = 1
			a.CanCollide = false
			a.Size = Vector3.new(0.5, 0, 0.5)
			a.CFrame = 	CFrame.new(Position,Position-Normal) * CFrame.Angles(90*math.pi/180,math.random(0,360)*math.pi/180,0)
			a.BrickColor = BrickColor.new("Really black")
			a.Material = Enum.Material.Air
			Debris:AddItem(a, 60)

			local b = Instance.new('WeldConstraint')
			b.Parent = a
			b.Part0 = a
			b.Part1 = HitPart

			local c = Instance.new("Decal", a)
			c.Texture = "rbxassetid://"..concrete_bulletholes[math.random(1,5)]
			c.Face = "Top"
			--		c.Transparency = 0

			local d = Instance.new("PointLight", a)
			d.Color = Color3.new(0, 0, 0)
			d.Range = 0
			d.Shadows = true

			local e = Instance.new("Weld")
			e.Part0 = a
			e.Part1 = HitPart
		elseif HitPart.Material == Enum.Material.Glass or HitPart.Material == Enum.Material.Ice or HitPart.Material == Enum.Material.Glacier then 

			local BulletWhizz = Instance.new("Sound")
			BulletWhizz.Parent = Attachment
			BulletWhizz.Volume = math.random(20,30)/10
			BulletWhizz.MaxDistance = 100
			BulletWhizz.EmitterSize = 5
			BulletWhizz.PlaybackSpeed = math.random(32, 60)/40
			BulletWhizz.SoundId = "rbxassetid://" .. Glass[math.random(1, #Glass)]

			BulletWhizz:Play()


			local Particles = Instance.new("ParticleEmitter")
			Particles.Enabled = false
			Particles.Color = ColorSequence.new(Color3.new(50, 50, 50))
			Particles.LightEmission = 0
			Particles.LightInfluence = 1
			Particles.Size = NumberSequence.new(
				{
					NumberSequenceKeypoint.new(0, 1, 0.1);
					NumberSequenceKeypoint.new(1, 1);
				}
			)
			Particles.Texture = "http://www.roblox.com/asset/?id=5984841909"
			Particles.Transparency = NumberSequence.new(
				{
					NumberSequenceKeypoint.new(0, 0, 0);
					NumberSequenceKeypoint.new(1, 1);
				}
			)
			Particles.Acceleration = Vector3.new(0, -50, 0)
			Particles.Lifetime = NumberRange.new(0.5, 0.5)
			Particles.Rate = 100
			Particles.Drag = 5
			Particles.RotSpeed = NumberRange.new(-360,360)
			Particles.Speed = NumberRange.new(25, 25)
			Particles.VelocitySpread = 50
			Particles.Parent = Attachment
			Particles.EmissionDirection = "Front"
			Particles:Emit(5)
			Debris:AddItem(Attachment, Particles.Lifetime.Max)

			local bg = Instance.new("BillboardGui", Attachment)
			bg.Adornee = Attachment
			local flashsize = math.random(10, 15)/10
			bg.Size = UDim2.new(flashsize, 0, flashsize, 0)
			local flash = Instance.new("ImageLabel", bg)
			flash.BackgroundTransparency = 1
			flash.Size = UDim2.new(0.05, 0, 0.05, 0)
			flash.Position = UDim2.new(0.5, 0, 0.5, 0)
			flash.Image = "http://www.roblox.com/asset/?id=476778304"
			flash.ImageTransparency = math.random(0, .5)
			flash.Rotation = math.random(0, 360)
			flash:TweenSizeAndPosition(UDim2.new(1, 0, 1, 0), UDim2.new(0, 0, 0, 0), "Out", "Quad", 0.1)	
			game.Debris:AddItem(bg, 0.1)

			local a = Instance.new("Part", BulletModel)
			a.FormFactor = "Custom"
			a.TopSurface = 0
			a.BottomSurface = 0
			a.Transparency = 1
			a.CanCollide = false
			a.Size = Vector3.new(0.5, 0, 0.5)
			a.CFrame = 	CFrame.new(Position,Position-Normal) * CFrame.Angles(90*math.pi/180,math.random(0,360)*math.pi/180,0)
			a.BrickColor = BrickColor.new("Really black")
			a.Material = Enum.Material.Air

			local b = Instance.new('WeldConstraint')
			b.Parent = a
			b.Part0 = a
			b.Part1 = HitPart

			local c = Instance.new("Decal", a)
			c.Texture = "rbxassetid://"..glass_bulletholes[math.random(1,2)]
			c.Face = "Top"
			--		c.Transparency = 0

			local d = Instance.new("PointLight", a)
			d.Color = Color3.new(0, 0, 0)
			d.Range = 0
			d.Shadows = true

			local e = Instance.new("Weld")
			e.Part0 = a
			e.Part1 = HitPart

		elseif HitPart.Material == Enum.Material.Neon then 
			HitPart.Material = Enum.Material.Glass
			local a = Instance.new("Part", BulletModel)
			a.FormFactor = "Custom"
			a.TopSurface = 0
			a.BottomSurface = 0
			a.Transparency = 1
			a.CanCollide = false
			a.Size = Vector3.new(0.5, 0, 0.5)
			a.CFrame = 	CFrame.new(Position,Position-Normal) * CFrame.Angles(90*math.pi/180,math.random(0,360)*math.pi/180,0)
			a.BrickColor = BrickColor.new("Really black")
			a.Material = Enum.Material.Air
			Debris:AddItem(a, 60)

			local b = Instance.new('WeldConstraint')
			b.Parent = a
			b.Part0 = a
			b.Part1 = HitPart

			local c = Instance.new("Decal", a)
			c.Texture = "rbxassetid://"..glass_bulletholes[math.random(1,2)]
			c.Face = "Top"
			--		c.Transparency = 0

			local d = Instance.new("PointLight", a)
			d.Color = Color3.new(0, 0, 0)
			d.Range = 0
			d.Shadows = true

			local e = Instance.new("Weld")
			e.Part0 = a
			e.Part1 = HitPart
		elseif HitPart.Material == Enum.Material.Wood or HitPart.Material == Enum.Material.WoodPlanks then 

			local BulletWhizz = Instance.new("Sound")
			BulletWhizz.Parent = Attachment
			BulletWhizz.Volume = math.random(20,30)/10
			BulletWhizz.MaxDistance = 100
			BulletWhizz.EmitterSize = 5
			BulletWhizz.PlaybackSpeed = math.random(38, 50)/40
			BulletWhizz.SoundId = "rbxassetid://" .. Wood[math.random(1, #Wood)]

			BulletWhizz:Play()

			local Particles = Instance.new("ParticleEmitter")
			Particles.Enabled = false
			Particles.Color = ColorSequence.new(HitPart.Color)
			Particles.LightEmission = 0
			Particles.LightInfluence = 1
			Particles.Size = NumberSequence.new(
				{
					NumberSequenceKeypoint.new(0, 0.25, 0);
					NumberSequenceKeypoint.new(1, .25);
				}
			)
			Particles.Texture = "http://www.roblox.com/asset/?id=434255560"
			Particles.Transparency = NumberSequence.new(
				{
					NumberSequenceKeypoint.new(0, 0, 0);
					NumberSequenceKeypoint.new(1, 1);
				}
			)
			Particles.Acceleration = Vector3.new(0, -50, 0)
			Particles.Lifetime = NumberRange.new(0.5 - 0.05, 0.5 + 0.05)
			Particles.Rate = 100
			Particles.Drag = 5
			Particles.RotSpeed = NumberRange.new(-360,360)
			Particles.Speed = NumberRange.new(35 - 5, 35 + 5)
			Particles.VelocitySpread = 50
			Particles.Parent = Attachment
			Particles.EmissionDirection = "Front"
			Particles:Emit(10)
			Debris:AddItem(Attachment, Particles.Lifetime.Max)

			local bg = Instance.new("BillboardGui", Attachment)
			bg.Adornee = Attachment
			local flashsize = math.random(10, 15)/10
			bg.Size = UDim2.new(flashsize, 0, flashsize, 0)
			local flash = Instance.new("ImageLabel", bg)
			flash.BackgroundTransparency = 1
			flash.Size = UDim2.new(0.05, 0, 0.05, 0)
			flash.Position = UDim2.new(0.5, 0, 0.5, 0)
			flash.Image = "http://www.roblox.com/asset/?id=476778304"
			flash.ImageTransparency = math.random(0, .5)
			flash.Rotation = math.random(0, 360)
			flash:TweenSizeAndPosition(UDim2.new(1, 0, 1, 0), UDim2.new(0, 0, 0, 0), "Out", "Quad", 0.1)	
			game.Debris:AddItem(bg, 0.1)

			local a = Instance.new("Part", BulletModel)
			a.FormFactor = "Custom"
			a.TopSurface = 0
			a.BottomSurface = 0
			a.Transparency = 1
			a.CanCollide = false
			a.Size = Vector3.new(0.5, 0, 0.5)
			a.CFrame = 	CFrame.new(Position,Position-Normal) * CFrame.Angles(90*math.pi/180,math.random(0,360)*math.pi/180,0)
			a.BrickColor = BrickColor.new("Really black")
			a.Material = Enum.Material.Air
			Debris:AddItem(a, 60)

			local b = Instance.new('WeldConstraint')
			b.Parent = a
			b.Part0 = a
			b.Part1 = HitPart

			local c = Instance.new("Decal", a)
			c.Texture = "rbxassetid://"..wood_bulletholes[math.random(1,2)]
			c.Face = "Top"
			--		c.Transparency = 0

			local d = Instance.new("PointLight", a)
			d.Color = Color3.new(0, 0, 0)
			d.Range = 0
			d.Shadows = true

			local e = Instance.new("Weld")
			e.Part0 = a
			e.Part1 = HitPart
		elseif HitPart.Material == Enum.Material.Metal then 

			local BulletWhizz = Instance.new("Sound")
			BulletWhizz.Parent = Attachment
			BulletWhizz.Volume = math.random(20,30)/10
			BulletWhizz.MaxDistance = 100
			BulletWhizz.EmitterSize = 5
			BulletWhizz.PlaybackSpeed = math.random(38, 58)/40
			BulletWhizz.SoundId = "rbxassetid://" .. Metal[math.random(1, #Metal)]

			BulletWhizz:Play()

			local Particles = Instance.new("ParticleEmitter")
			Particles.Enabled = false
			Particles.Color = ColorSequence.new(Color3.fromRGB(255, 150, 0))
			Particles.LightEmission = 1
			Particles.LightInfluence = 0
			Particles.Texture = "rbxasset://textures/particles/sparkles_main.dds"
			Particles.Size = NumberSequence.new(
				{
					NumberSequenceKeypoint.new(0, 0.25, 0);
					NumberSequenceKeypoint.new(1, 0.1);
				}
			)
			Particles.Acceleration = Vector3.new(0, -50, 0)
			Particles.Lifetime = NumberRange.new(0.15 - 0.05, 0.15 + 0.5)
			Particles.Rate = 1000
			Particles.Drag = 10
			Particles.RotSpeed = NumberRange.new(-360,360)
			Particles.Speed = NumberRange.new(50 - 25, 50 + 25)
			Particles.VelocitySpread = math.random(5,20)
			Particles.Parent = Attachment
			Particles.EmissionDirection = "Front"
			Particles:Emit(50)
			Debris:AddItem(Attachment, Particles.Lifetime.Max)
			local bg = Instance.new("BillboardGui", Attachment)
			bg.Adornee = Attachment
			local flashsize = math.random(15, 30)/10
			bg.Size = UDim2.new(flashsize, 0, flashsize, 0)
			local flash = Instance.new("ImageLabel", bg)
			flash.BackgroundTransparency = 1
			flash.Size = UDim2.new(0.05, 0, 0.05, 0)
			flash.Position = UDim2.new(0.45, 0, 0.45, 0)
			flash.Image = "http://www.roblox.com/asset/?id=233113663"
			flash.ImageTransparency = math.random(0, .5)
			flash.Rotation = math.random(0, 360)
			flash:TweenSizeAndPosition(UDim2.new(1, 0, 1, 0), UDim2.new(0, 0, 0, 0), "Out", "Quad", 0.15)	
			game.Debris:AddItem(bg, 0.07)

			local a = Instance.new("Part", BulletModel)
			a.FormFactor = "Custom"
			a.TopSurface = 0
			a.BottomSurface = 0
			a.Transparency = 1
			a.CanCollide = false
			a.Size = Vector3.new(0.5, 0, 0.5)
			a.CFrame = 	CFrame.new(Position,Position-Normal) * CFrame.Angles(90*math.pi/180,math.random(0,360)*math.pi/180,0)
			a.BrickColor = BrickColor.new("Really black")
			a.Material = Enum.Material.Air
			Debris:AddItem(a, 60)

			local b = Instance.new('WeldConstraint')
			b.Parent = a
			b.Part0 = a
			b.Part1 = HitPart

			local c = Instance.new("Decal", a)
			c.Texture = "rbxassetid://"..metal_bulletholes[math.random(1,2)]
			c.Face = "Top"
			--		c.Transparency = 0

			local d = Instance.new("PointLight", a)
			d.Color = Color3.new(0, 0, 0)
			d.Range = 0
			d.Shadows = true

			local e = Instance.new("Weld")
			e.Part0 = a
			e.Part1 = HitPart
		elseif HitPart.Material == Enum.Material.DiamondPlate then 

			local BulletWhizz = Instance.new("Sound")
			BulletWhizz.Parent = Attachment
			BulletWhizz.Volume = math.random(20,30)/10
			BulletWhizz.MaxDistance = 100
			BulletWhizz.EmitterSize = 5
			BulletWhizz.PlaybackSpeed = math.random(38, 58)/40
			BulletWhizz.SoundId = "rbxassetid://" .. Metal[math.random(1, #Metal)]

			BulletWhizz:Play()

			local Particles = Instance.new("ParticleEmitter")
			Particles.Enabled = false
			Particles.Color = ColorSequence.new(Color3.fromRGB(255, 150, 0))
			Particles.LightEmission = 1
			Particles.LightInfluence = 0
			Particles.Texture = "rbxasset://textures/particles/sparkles_main.dds"
			Particles.Size = NumberSequence.new(
				{
					NumberSequenceKeypoint.new(0, 0.25, 0);
					NumberSequenceKeypoint.new(1, 0.1);
				}
			)
			Particles.Acceleration = Vector3.new(0, -50, 0)
			Particles.Lifetime = NumberRange.new(0.15 - 0.05, 0.15 + 0.5)
			Particles.Rate = 1000
			Particles.Drag = 10
			Particles.RotSpeed = NumberRange.new(-360,360)
			Particles.Speed = NumberRange.new(50 - 25, 50 + 25)
			Particles.VelocitySpread = math.random(5,20)
			Particles.Parent = Attachment
			Particles.EmissionDirection = "Front"
			Particles:Emit(50)
			Debris:AddItem(Attachment, Particles.Lifetime.Max)
			local bg = Instance.new("BillboardGui", Attachment)
			bg.Adornee = Attachment
			local flashsize = math.random(15, 30)/10
			bg.Size = UDim2.new(flashsize, 0, flashsize, 0)
			local flash = Instance.new("ImageLabel", bg)
			flash.BackgroundTransparency = 1
			flash.Size = UDim2.new(0.05, 0, 0.05, 0)
			flash.Position = UDim2.new(0.45, 0, 0.45, 0)
			flash.Image = "http://www.roblox.com/asset/?id=233113663"
			flash.ImageTransparency = math.random(0, .5)
			flash.Rotation = math.random(0, 360)
			flash:TweenSizeAndPosition(UDim2.new(1, 0, 1, 0), UDim2.new(0, 0, 0, 0), "Out", "Quad", 0.15)	
			game.Debris:AddItem(bg, 0.07)

			local a = Instance.new("Part", BulletModel)
			a.FormFactor = "Custom"
			a.TopSurface = 0
			a.BottomSurface = 0
			a.Transparency = 1
			a.CanCollide = false
			a.Size = Vector3.new(0.5, 0, 0.5)
			a.CFrame = 	CFrame.new(Position,Position-Normal) * CFrame.Angles(90*math.pi/180,math.random(0,360)*math.pi/180,0)
			a.BrickColor = BrickColor.new("Really black")
			a.Material = Enum.Material.Air
			Debris:AddItem(a, 60)

			local b = Instance.new('WeldConstraint')
			b.Parent = a
			b.Part0 = a
			b.Part1 = HitPart

			local c = Instance.new("Decal", a)
			c.Texture = "rbxassetid://"..metal_bulletholes[math.random(1,2)]
			c.Face = "Top"
			--		c.Transparency = 0

			local d = Instance.new("PointLight", a)
			d.Color = Color3.new(0, 0, 0)
			d.Range = 0
			d.Shadows = true

			local e = Instance.new("Weld")
			e.Part0 = a
			e.Part1 = HitPart
		elseif HitPart.Material == Enum.Material.CorrodedMetal then 

			local BulletWhizz = Instance.new("Sound")
			BulletWhizz.Parent = Attachment
			BulletWhizz.Volume = math.random(20,30)/10
			BulletWhizz.MaxDistance = 100
			BulletWhizz.EmitterSize = 5
			BulletWhizz.PlaybackSpeed = math.random(38, 58)/40
			BulletWhizz.SoundId = "rbxassetid://" .. Metal[math.random(1, #Metal)]

			BulletWhizz:Play()

			local Particles = Instance.new("ParticleEmitter")
			Particles.Enabled = false
			Particles.Color = ColorSequence.new(Color3.fromRGB(255, 150, 0))
			Particles.LightEmission = 1
			Particles.LightInfluence = 0
			Particles.Texture = "rbxasset://textures/particles/sparkles_main.dds"
			Particles.Size = NumberSequence.new(
				{
					NumberSequenceKeypoint.new(0, 0.25, 0);
					NumberSequenceKeypoint.new(1, 0.1);
				}
			)
			Particles.Acceleration = Vector3.new(0, -50, 0)
			Particles.Lifetime = NumberRange.new(0.15 - 0.05, 0.15 + 0.5)
			Particles.Rate = 1000
			Particles.Drag = 10
			Particles.RotSpeed = NumberRange.new(-360,360)
			Particles.Speed = NumberRange.new(50 - 25, 50 + 25)
			Particles.VelocitySpread = math.random(5,20)
			Particles.Parent = Attachment
			Particles.EmissionDirection = "Front"
			Particles:Emit(50)
			Debris:AddItem(Attachment, Particles.Lifetime.Max)
			local bg = Instance.new("BillboardGui", Attachment)
			bg.Adornee = Attachment
			local flashsize = math.random(15, 30)/10
			bg.Size = UDim2.new(flashsize, 0, flashsize, 0)
			local flash = Instance.new("ImageLabel", bg)
			flash.BackgroundTransparency = 1
			flash.Size = UDim2.new(0.05, 0, 0.05, 0)
			flash.Position = UDim2.new(0.45, 0, 0.45, 0)
			flash.Image = "http://www.roblox.com/asset/?id=233113663"
			flash.ImageTransparency = math.random(0, .5)
			flash.Rotation = math.random(0, 360)
			flash:TweenSizeAndPosition(UDim2.new(1, 0, 1, 0), UDim2.new(0, 0, 0, 0), "Out", "Quad", 0.15)	
			game.Debris:AddItem(bg, 0.07)

			local a = Instance.new("Part", BulletModel)
			a.FormFactor = "Custom"
			a.TopSurface = 0
			a.BottomSurface = 0
			a.Transparency = 1
			a.CanCollide = false
			a.Size = Vector3.new(0.5, 0, 0.5)
			a.CFrame = 	CFrame.new(Position,Position-Normal) * CFrame.Angles(90*math.pi/180,math.random(0,360)*math.pi/180,0)
			a.BrickColor = BrickColor.new("Really black")
			a.Material = Enum.Material.Air
			Debris:AddItem(a, 60)

			local b = Instance.new('WeldConstraint')
			b.Parent = a
			b.Part0 = a
			b.Part1 = HitPart

			local c = Instance.new("Decal", a)
			c.Texture = "rbxassetid://"..metal_bulletholes[math.random(1,2)]
			c.Face = "Top"
			--		c.Transparency = 0

			local d = Instance.new("PointLight", a)
			d.Color = Color3.new(0, 0, 0)
			d.Range = 0
			d.Shadows = true

			local e = Instance.new("Weld")
			e.Part0 = a
			e.Part1 = HitPart
		elseif HitPart.Material == Enum.Material.Asphalt then

			local BulletWhizz = Instance.new("Sound")
			BulletWhizz.Parent = Attachment
			BulletWhizz.Volume = math.random(20,30)/10
			BulletWhizz.MaxDistance = 100
			BulletWhizz.EmitterSize = 5
			BulletWhizz.PlaybackSpeed = math.random(38, 46)/40
			BulletWhizz.SoundId = "rbxassetid://" .. Concrete[math.random(1, #Concrete)]

			BulletWhizz:Play()	

			local Particles = Instance.new("ParticleEmitter")
			Particles.Enabled = false
			Particles.Color = ColorSequence.new(Color3.new(50, 50, 50))
			Particles.LightEmission = 0
			Particles.LightInfluence = 1
			Particles.Size = NumberSequence.new(
				{
					NumberSequenceKeypoint.new(0, 0.1, 0.1);
					NumberSequenceKeypoint.new(1, 2);
				}
			)
			Particles.Texture = "rbxasset://textures/particles/smoke_main.dds"
			Particles.Transparency = NumberSequence.new(
				{
					NumberSequenceKeypoint.new(0, 0.75, 0);
					NumberSequenceKeypoint.new(1, 1);
				}
			)
			Particles.Acceleration = Vector3.new(0, 0, 0)
			Particles.Lifetime = NumberRange.new(0.5, 1)
			Particles.Rate = 1000
			Particles.Drag = 20
			Particles.RotSpeed = NumberRange.new(-360,360)
			Particles.Speed = NumberRange.new(15,30)
			Particles.SpreadAngle = Vector2.new(180,360)
			Particles.Parent = Attachment
			Particles.EmissionDirection = "Front"
			Particles:Emit(50)

			Debris:AddItem(Attachment, Particles.Lifetime.Max)

			local bg = Instance.new("BillboardGui", Attachment)
			bg.Adornee = Attachment
			local flashsize = math.random(10, 15)/10
			bg.Size = UDim2.new(flashsize, 0, flashsize, 0)
			local flash = Instance.new("ImageLabel", bg)
			flash.BackgroundTransparency = 1
			flash.Size = UDim2.new(0.05, 0, 0.05, 0)
			flash.Position = UDim2.new(0.5, 0, 0.5, 0)
			flash.Image = "http://www.roblox.com/asset/?id=476778304"
			flash.ImageTransparency = math.random(0, .5)
			flash.Rotation = math.random(0, 360)
			flash:TweenSizeAndPosition(UDim2.new(1, 0, 1, 0), UDim2.new(0, 0, 0, 0), "Out", "Quad", 0.1)	
			game.Debris:AddItem(bg, 0.1)

			local a = Instance.new("Part", BulletModel)
			a.FormFactor = "Custom"
			a.TopSurface = 0
			a.BottomSurface = 0
			a.Transparency = 1
			a.CanCollide = false
			a.Size = Vector3.new(0.5, 0, 0.5)
			a.CFrame = 	CFrame.new(Position,Position-Normal) * CFrame.Angles(90*math.pi/180,math.random(0,360)*math.pi/180,0)
			a.BrickColor = BrickColor.new("Really black")
			a.Material = Enum.Material.Air
			Debris:AddItem(a, 60)

			local b = Instance.new('WeldConstraint')
			b.Parent = a
			b.Part0 = a
			b.Part1 = HitPart

			local c = Instance.new("Decal", a)
			c.Texture = "rbxassetid://"..concrete_bulletholes[math.random(1,5)]
			c.Face = "Top"
			--		c.Transparency = 0

			local d = Instance.new("PointLight", a)
			d.Color = Color3.new(0, 0, 0)
			d.Range = 0
			d.Shadows = true

			local e = Instance.new("Weld")
			e.Part0 = a
			e.Part1 = HitPart
		elseif HitPart.Material == Enum.Material.Slate then

			local BulletWhizz = Instance.new("Sound")
			BulletWhizz.Parent = Attachment
			BulletWhizz.Volume = math.random(20,30)/10
			BulletWhizz.MaxDistance = 100
			BulletWhizz.EmitterSize = 5
			BulletWhizz.PlaybackSpeed = math.random(38, 46)/40
			BulletWhizz.SoundId = "rbxassetid://" .. Concrete[math.random(1, #Concrete)]

			BulletWhizz:Play()	

			local Particles = Instance.new("ParticleEmitter")
			Particles.Enabled = false
			Particles.Color = ColorSequence.new(Color3.new(50, 50, 50))
			Particles.LightEmission = 0
			Particles.LightInfluence = 1
			Particles.Size = NumberSequence.new(
				{
					NumberSequenceKeypoint.new(0, 0.1, 0.1);
					NumberSequenceKeypoint.new(1, 2);
				}
			)
			Particles.Texture = "rbxasset://textures/particles/smoke_main.dds"
			Particles.Transparency = NumberSequence.new(
				{
					NumberSequenceKeypoint.new(0, 0.75, 0);
					NumberSequenceKeypoint.new(1, 1);
				}
			)
			Particles.Acceleration = Vector3.new(0, 0, 0)
			Particles.Lifetime = NumberRange.new(0.5, 1)
			Particles.Rate = 1000
			Particles.Drag = 20
			Particles.RotSpeed = NumberRange.new(-360,360)
			Particles.Speed = NumberRange.new(15,30)
			Particles.SpreadAngle = Vector2.new(180,360)
			Particles.Parent = Attachment
			Particles.EmissionDirection = "Front"
			Particles:Emit(50)

			Debris:AddItem(Attachment, Particles.Lifetime.Max)

			local bg = Instance.new("BillboardGui", Attachment)
			bg.Adornee = Attachment
			local flashsize = math.random(10, 15)/10
			bg.Size = UDim2.new(flashsize, 0, flashsize, 0)
			local flash = Instance.new("ImageLabel", bg)
			flash.BackgroundTransparency = 1
			flash.Size = UDim2.new(0.05, 0, 0.05, 0)
			flash.Position = UDim2.new(0.5, 0, 0.5, 0)
			flash.Image = "http://www.roblox.com/asset/?id=476778304"
			flash.ImageTransparency = math.random(0, .5)
			flash.Rotation = math.random(0, 360)
			flash:TweenSizeAndPosition(UDim2.new(1, 0, 1, 0), UDim2.new(0, 0, 0, 0), "Out", "Quad", 0.1)	
			game.Debris:AddItem(bg, 0.1)

			local a = Instance.new("Part", BulletModel)
			a.FormFactor = "Custom"
			a.TopSurface = 0
			a.BottomSurface = 0
			a.Transparency = 1
			a.CanCollide = false
			a.Size = Vector3.new(0.5, 0, 0.5)
			a.CFrame = 	CFrame.new(Position,Position-Normal) * CFrame.Angles(90*math.pi/180,math.random(0,360)*math.pi/180,0)
			a.BrickColor = BrickColor.new("Really black")
			a.Material = Enum.Material.Air
			Debris:AddItem(a, 60)

			local b = Instance.new('WeldConstraint')
			b.Parent = a
			b.Part0 = a
			b.Part1 = HitPart

			local c = Instance.new("Decal", a)
			c.Texture = "rbxassetid://"..concrete_bulletholes[math.random(1,5)]
			c.Face = "Top"
			--		c.Transparency = 0

			local d = Instance.new("PointLight", a)
			d.Color = Color3.new(0, 0, 0)
			d.Range = 0
			d.Shadows = true

			local e = Instance.new("Weld")
			e.Part0 = a
			e.Part1 = HitPart
		elseif HitPart.Material == Enum.Material.Marble then

			local BulletWhizz = Instance.new("Sound")
			BulletWhizz.Parent = Attachment
			BulletWhizz.Volume = math.random(20,30)/10
			BulletWhizz.MaxDistance = 100
			BulletWhizz.EmitterSize = 5
			BulletWhizz.PlaybackSpeed = math.random(38, 46)/40
			BulletWhizz.SoundId = "rbxassetid://" .. Concrete[math.random(1, #Concrete)]

			BulletWhizz:Play()	

			local Particles = Instance.new("ParticleEmitter")
			Particles.Enabled = false
			Particles.Color = ColorSequence.new(Color3.new(50, 50, 50))
			Particles.LightEmission = 0
			Particles.LightInfluence = 1
			Particles.Size = NumberSequence.new(
				{
					NumberSequenceKeypoint.new(0, 0.1, 0.1);
					NumberSequenceKeypoint.new(1, 2);
				}
			)
			Particles.Texture = "rbxasset://textures/particles/smoke_main.dds"
			Particles.Transparency = NumberSequence.new(
				{
					NumberSequenceKeypoint.new(0, 0.75, 0);
					NumberSequenceKeypoint.new(1, 1);
				}
			)
			Particles.Acceleration = Vector3.new(0, 0, 0)
			Particles.Lifetime = NumberRange.new(0.5, 1)
			Particles.Rate = 1000
			Particles.Drag = 20
			Particles.RotSpeed = NumberRange.new(-360,360)
			Particles.Speed = NumberRange.new(15,30)
			Particles.SpreadAngle = Vector2.new(180,360)
			Particles.Parent = Attachment
			Particles.EmissionDirection = "Front"
			Particles:Emit(50)

			Debris:AddItem(Attachment, Particles.Lifetime.Max)

			local bg = Instance.new("BillboardGui", Attachment)
			bg.Adornee = Attachment
			local flashsize = math.random(10, 15)/10
			bg.Size = UDim2.new(flashsize, 0, flashsize, 0)
			local flash = Instance.new("ImageLabel", bg)
			flash.BackgroundTransparency = 1
			flash.Size = UDim2.new(0.05, 0, 0.05, 0)
			flash.Position = UDim2.new(0.5, 0, 0.5, 0)
			flash.Image = "http://www.roblox.com/asset/?id=476778304"
			flash.ImageTransparency = math.random(0, .5)
			flash.Rotation = math.random(0, 360)
			flash:TweenSizeAndPosition(UDim2.new(1, 0, 1, 0), UDim2.new(0, 0, 0, 0), "Out", "Quad", 0.1)	
			game.Debris:AddItem(bg, 0.1)

			local a = Instance.new("Part", BulletModel)
			a.FormFactor = "Custom"
			a.TopSurface = 0
			a.BottomSurface = 0
			a.Transparency = 1
			a.CanCollide = false
			a.Size = Vector3.new(0.5, 0, 0.5)
			a.CFrame = 	CFrame.new(Position,Position-Normal) * CFrame.Angles(90*math.pi/180,math.random(0,360)*math.pi/180,0)
			a.BrickColor = BrickColor.new("Really black")
			a.Material = Enum.Material.Air
			Debris:AddItem(a, 60)

			local b = Instance.new('WeldConstraint')
			b.Parent = a
			b.Part0 = a
			b.Part1 = HitPart

			local c = Instance.new("Decal", a)
			c.Texture = "rbxassetid://"..concrete_bulletholes[math.random(1,5)]
			c.Face = "Top"
			--		c.Transparency = 0

			local d = Instance.new("PointLight", a)
			d.Color = Color3.new(0, 0, 0)
			d.Range = 0
			d.Shadows = true

			local e = Instance.new("Weld")
			e.Part0 = a
			e.Part1 = HitPart
		elseif HitPart.Material == Enum.Material.Granite or HitPart.Material == Enum.Material.Foil  then

			local BulletWhizz = Instance.new("Sound")
			BulletWhizz.Parent = Attachment
			BulletWhizz.Volume = math.random(20,30)/10
			BulletWhizz.MaxDistance = 100
			BulletWhizz.EmitterSize = 5
			BulletWhizz.PlaybackSpeed = math.random(38, 46)/40
			BulletWhizz.SoundId = "rbxassetid://" .. Concrete[math.random(1, #Concrete)]

			BulletWhizz:Play()	

			local Particles = Instance.new("ParticleEmitter")
			Particles.Enabled = false
			Particles.Color = ColorSequence.new(Color3.new(50, 50, 50))
			Particles.LightEmission = 0
			Particles.LightInfluence = 1
			Particles.Size = NumberSequence.new(
				{
					NumberSequenceKeypoint.new(0, 0.1, 0.1);
					NumberSequenceKeypoint.new(1, 2);
				}
			)
			Particles.Texture = "rbxasset://textures/particles/smoke_main.dds"
			Particles.Transparency = NumberSequence.new(
				{
					NumberSequenceKeypoint.new(0, 0.75, 0);
					NumberSequenceKeypoint.new(1, 1);
				}
			)
			Particles.Acceleration = Vector3.new(0, 0, 0)
			Particles.Lifetime = NumberRange.new(0.5, 1)
			Particles.Rate = 1000
			Particles.Drag = 20
			Particles.RotSpeed = NumberRange.new(-360,360)
			Particles.Speed = NumberRange.new(15,30)
			Particles.SpreadAngle = Vector2.new(180,360)
			Particles.Parent = Attachment
			Particles.EmissionDirection = "Front"
			Particles:Emit(50)

			Debris:AddItem(Attachment, Particles.Lifetime.Max)

			local bg = Instance.new("BillboardGui", Attachment)
			bg.Adornee = Attachment
			local flashsize = math.random(10, 15)/10
			bg.Size = UDim2.new(flashsize, 0, flashsize, 0)
			local flash = Instance.new("ImageLabel", bg)
			flash.BackgroundTransparency = 1
			flash.Size = UDim2.new(0.05, 0, 0.05, 0)
			flash.Position = UDim2.new(0.5, 0, 0.5, 0)
			flash.Image = "http://www.roblox.com/asset/?id=476778304"
			flash.ImageTransparency = math.random(0, .5)
			flash.Rotation = math.random(0, 360)
			flash:TweenSizeAndPosition(UDim2.new(1, 0, 1, 0), UDim2.new(0, 0, 0, 0), "Out", "Quad", 0.1)	
			game.Debris:AddItem(bg, 0.1)

			local a = Instance.new("Part", BulletModel)
			a.FormFactor = "Custom"
			a.TopSurface = 0
			a.BottomSurface = 0
			a.Transparency = 1
			a.CanCollide = false
			a.Size = Vector3.new(0.5, 0, 0.5)
			a.CFrame = 	CFrame.new(Position,Position-Normal) * CFrame.Angles(90*math.pi/180,math.random(0,360)*math.pi/180,0)
			a.BrickColor = BrickColor.new("Really black")
			a.Material = Enum.Material.Air
			Debris:AddItem(a, 60)

			local b = Instance.new('WeldConstraint')
			b.Parent = a
			b.Part0 = a
			b.Part1 = HitPart

			local c = Instance.new("Decal", a)
			c.Texture = "rbxassetid://"..concrete_bulletholes[math.random(1,5)]
			c.Face = "Top"
			--		c.Transparency = 0

			local d = Instance.new("PointLight", a)
			d.Color = Color3.new(0, 0, 0)
			d.Range = 0
			d.Shadows = true

			local e = Instance.new("Weld")
			e.Part0 = a
			e.Part1 = HitPart
			
		elseif HitPart.Material == Enum.Material.SmoothPlastic then


			local BulletWhizz = Instance.new("Sound")
			BulletWhizz.Parent = Attachment
			BulletWhizz.Volume = math.random(20,30)/10
			BulletWhizz.MaxDistance = 100
			BulletWhizz.EmitterSize = 5
			BulletWhizz.PlaybackSpeed = math.random(32, 50)/40
			BulletWhizz.SoundId = "rbxassetid://" .. Cracks[math.random(1, #Cracks)]

			BulletWhizz:Play()
			local Particles = Instance.new("ParticleEmitter")
			Particles.Enabled = false
			Particles.Color = ColorSequence.new(Color3.new(50, 50, 50))
			Particles.LightEmission = 0
			Particles.LightInfluence = 1
			Particles.Size = NumberSequence.new(
				{
					NumberSequenceKeypoint.new(0, 0.1, 0.1);
					NumberSequenceKeypoint.new(1, 2);
				}
			)
			Particles.Texture = "rbxasset://textures/particles/smoke_main.dds"
			Particles.Transparency = NumberSequence.new(
				{
					NumberSequenceKeypoint.new(0, 0.85, 0);
					NumberSequenceKeypoint.new(1, 1);
				}
			)
			Particles.Acceleration = Vector3.new(0, -10, 0)
			Particles.Lifetime = NumberRange.new(0.7 - 0.5, 0.7 + 0.5)
			Particles.Rate = 1000
			Particles.Drag = 20
			Particles.RotSpeed = NumberRange.new(-360,360)
			Particles.Speed = NumberRange.new(25 - 5, 25 + 5)
			Particles.SpreadAngle = Vector2.new(35,360)
			Particles.Parent = Attachment
			Particles.EmissionDirection = "Top"
			Particles:Emit(25)
			Debris:AddItem(Attachment, Particles.Lifetime.Max)

			local bg = Instance.new("BillboardGui", Attachment)
			bg.Adornee = Attachment
			local flashsize = math.random(10, 15)/10
			bg.Size = UDim2.new(flashsize, 0, flashsize, 0)
			local flash = Instance.new("ImageLabel", bg)
			flash.BackgroundTransparency = 1
			flash.Size = UDim2.new(0.05, 0, 0.05, 0)
			flash.Position = UDim2.new(0.5, 0, 0.5, 0)
			flash.Image = "http://www.roblox.com/asset/?id=476778304"
			flash.ImageTransparency = math.random(0, .5)
			flash.Rotation = math.random(0, 360)
			flash:TweenSizeAndPosition(UDim2.new(1, 0, 1, 0), UDim2.new(0, 0, 0, 0), "Out", "Quad", 0.1)	
			game.Debris:AddItem(bg, 0.1)

			local a = Instance.new("Part", BulletModel)
			a.FormFactor = "Custom"
			a.TopSurface = 0
			a.BottomSurface = 0
			a.Transparency = 1
			a.CanCollide = false
			a.Size = Vector3.new(0.5, 0, 0.5)
			a.CFrame = 	CFrame.new(Position,Position-Normal) * CFrame.Angles(90*math.pi/180,math.random(0,360)*math.pi/180,0)
			a.BrickColor = BrickColor.new("Really black")
			a.Material = Enum.Material.Air
			Debris:AddItem(a, 60)

			local b = Instance.new('WeldConstraint')
			b.Parent = a
			b.Part0 = a
			b.Part1 = HitPart

			local c = Instance.new("Decal", a)
			c.Texture = "rbxassetid://"..concrete_bulletholes[math.random(1,5)]
			c.Face = "Top"
			--		c.Transparency = 0

			local d = Instance.new("PointLight", a)
			d.Color = Color3.new(0, 0, 0)
			d.Range = 0
			d.Shadows = true

			local e = Instance.new("Weld")
			e.Part0 = a
			e.Part1 = HitPart
		elseif HitPart.Material == Enum.Material.Plastic then

			local BulletWhizz = Instance.new("Sound")
			BulletWhizz.Parent = Attachment
			BulletWhizz.Volume = math.random(20,30)/10
			BulletWhizz.MaxDistance = 100
			BulletWhizz.EmitterSize = 5
			BulletWhizz.PlaybackSpeed = math.random(32, 50)/40
			BulletWhizz.SoundId = "rbxassetid://" .. Cracks[math.random(1, #Cracks)]

			BulletWhizz:Play()
			local Particles = Instance.new("ParticleEmitter")
			Particles.Enabled = false
			Particles.Color = ColorSequence.new(Color3.new(50, 50, 50))
			Particles.LightEmission = 0
			Particles.LightInfluence = 1
			Particles.Size = NumberSequence.new(
				{
					NumberSequenceKeypoint.new(0, 0.1, 0.1);
					NumberSequenceKeypoint.new(1, 2);
				}
			)
			Particles.Texture = "rbxasset://textures/particles/smoke_main.dds"
			Particles.Transparency = NumberSequence.new(
				{
					NumberSequenceKeypoint.new(0, 0.85, 0);
					NumberSequenceKeypoint.new(1, 1);
				}
			)
			Particles.Acceleration = Vector3.new(0, -10, 0)
			Particles.Lifetime = NumberRange.new(0.7 - 0.5, 0.7 + 0.5)
			Particles.Rate = 1000
			Particles.Drag = 20
			Particles.RotSpeed = NumberRange.new(-360,360)
			Particles.Speed = NumberRange.new(25 - 5, 25 + 5)
			Particles.SpreadAngle = Vector2.new(35,360)
			Particles.Parent = Attachment
			Particles.EmissionDirection = "Top"
			Particles:Emit(25)
			Debris:AddItem(Attachment, Particles.Lifetime.Max)

			local bg = Instance.new("BillboardGui", Attachment)
			bg.Adornee = Attachment
			local flashsize = math.random(10, 15)/10
			bg.Size = UDim2.new(flashsize, 0, flashsize, 0)
			local flash = Instance.new("ImageLabel", bg)
			flash.BackgroundTransparency = 1
			flash.Size = UDim2.new(0.05, 0, 0.05, 0)
			flash.Position = UDim2.new(0.5, 0, 0.5, 0)
			flash.Image = "http://www.roblox.com/asset/?id=476778304"
			flash.ImageTransparency = math.random(0, .5)
			flash.Rotation = math.random(0, 360)
			flash:TweenSizeAndPosition(UDim2.new(1, 0, 1, 0), UDim2.new(0, 0, 0, 0), "Out", "Quad", 0.1)	
			game.Debris:AddItem(bg, 0.1)

			local a = Instance.new("Part", BulletModel)
			a.FormFactor = "Custom"
			a.TopSurface = 0
			a.BottomSurface = 0
			a.Transparency = 1
			a.CanCollide = false
			a.Size = Vector3.new(0.5, 0, 0.5)
			a.CFrame = 	CFrame.new(Position,Position-Normal) * CFrame.Angles(90*math.pi/180,math.random(0,360)*math.pi/180,0)
			a.BrickColor = BrickColor.new("Really black")
			a.Material = Enum.Material.Air
			Debris:AddItem(a, 60)

			local b = Instance.new('WeldConstraint')
			b.Parent = a
			b.Part0 = a
			b.Part1 = HitPart

			local c = Instance.new("Decal", a)
			c.Texture = "rbxassetid://"..concrete_bulletholes[math.random(1,5)]
			c.Face = "Top"
			--		c.Transparency = 0

			local d = Instance.new("PointLight", a)
			d.Color = Color3.new(0, 0, 0)
			d.Range = 0
			d.Shadows = true

			local e = Instance.new("Weld")
			e.Part0 = a
			e.Part1 = HitPart
		elseif HitPart.Material == Enum.Material.Brick then
			local BulletWhizz = Instance.new("Sound")
			BulletWhizz.Parent = Attachment
			BulletWhizz.Volume = math.random(20,30)/10
			BulletWhizz.MaxDistance = 100
			BulletWhizz.EmitterSize = 5
			BulletWhizz.PlaybackSpeed = math.random(38, 46)/40
			BulletWhizz.SoundId = "rbxassetid://" .. Concrete[math.random(1, #Concrete)]

			BulletWhizz:Play()	

			local Particles = Instance.new("ParticleEmitter")
			Particles.Enabled = false
			Particles.Color = ColorSequence.new(Color3.new(50, 50, 50))
			Particles.LightEmission = 0
			Particles.LightInfluence = 1
			Particles.Size = NumberSequence.new(
				{
					NumberSequenceKeypoint.new(0, 0.1, 0.1);
					NumberSequenceKeypoint.new(1, 2);
				}
			)
			Particles.Texture = "rbxasset://textures/particles/smoke_main.dds"
			Particles.Transparency = NumberSequence.new(
				{
					NumberSequenceKeypoint.new(0, 0.75, 0);
					NumberSequenceKeypoint.new(1, 1);
				}
			)
			Particles.Acceleration = Vector3.new(0, 0, 0)
			Particles.Lifetime = NumberRange.new(0.5, 1)
			Particles.Rate = 1000
			Particles.Drag = 20
			Particles.RotSpeed = NumberRange.new(-360,360)
			Particles.Speed = NumberRange.new(15,30)
			Particles.SpreadAngle = Vector2.new(180,360)
			Particles.Parent = Attachment
			Particles.EmissionDirection = "Front"
			Particles:Emit(50)

			Debris:AddItem(Attachment, Particles.Lifetime.Max)

			local bg = Instance.new("BillboardGui", Attachment)
			bg.Adornee = Attachment
			local flashsize = math.random(10, 15)/10
			bg.Size = UDim2.new(flashsize, 0, flashsize, 0)
			local flash = Instance.new("ImageLabel", bg)
			flash.BackgroundTransparency = 1
			flash.Size = UDim2.new(0.05, 0, 0.05, 0)
			flash.Position = UDim2.new(0.5, 0, 0.5, 0)
			flash.Image = "http://www.roblox.com/asset/?id=476778304"
			flash.ImageTransparency = math.random(0, .5)
			flash.Rotation = math.random(0, 360)
			flash:TweenSizeAndPosition(UDim2.new(1, 0, 1, 0), UDim2.new(0, 0, 0, 0), "Out", "Quad", 0.1)	
			game.Debris:AddItem(bg, 0.1)

			local a = Instance.new("Part", BulletModel)
			a.FormFactor = "Custom"
			a.TopSurface = 0
			a.BottomSurface = 0
			a.Transparency = 1
			a.CanCollide = false
			a.Size = Vector3.new(0.5, 0, 0.5)
			a.CFrame = 	CFrame.new(Position,Position-Normal) * CFrame.Angles(90*math.pi/180,math.random(0,360)*math.pi/180,0)
			a.BrickColor = BrickColor.new("Really black")
			a.Material = Enum.Material.Air
			Debris:AddItem(a, 60)

			local b = Instance.new('WeldConstraint')
			b.Parent = a
			b.Part0 = a
			b.Part1 = HitPart

			local c = Instance.new("Decal", a)
			c.Texture = "rbxassetid://"..concrete_bulletholes[math.random(1,5)]
			c.Face = "Top"
			--		c.Transparency = 0

			local d = Instance.new("PointLight", a)
			d.Color = Color3.new(0, 0, 0)
			d.Range = 0
			d.Shadows = true

			local e = Instance.new("Weld")
			e.Part0 = a
			e.Part1 = HitPart

		elseif HitPart.Material == Enum.Material.Grass then
			local BulletWhizz = Instance.new("Sound")
			BulletWhizz.Parent = Attachment
			BulletWhizz.Volume = math.random(20,30)/10
			BulletWhizz.MaxDistance = 100
			BulletWhizz.EmitterSize = 5
			BulletWhizz.PlaybackSpeed = math.random(38, 50)/40
			BulletWhizz.SoundId = "rbxassetid://" .. Grass[math.random(1, #Grass)]

			BulletWhizz:Play()

			local Particles = Instance.new("ParticleEmitter")
			Particles.Enabled = false
			Particles.Color = ColorSequence.new(workspace.Terrain:GetMaterialColor(Material))
			Particles.LightEmission = 0
			Particles.LightInfluence = 1
			Particles.Size = NumberSequence.new(
				{
					NumberSequenceKeypoint.new(0, 0.1, 0.1);
					NumberSequenceKeypoint.new(1, 5);
				}
			)
			Particles.Texture = "rbxasset://textures/particles/smoke_main.dds"
			Particles.Transparency = NumberSequence.new(
				{
					NumberSequenceKeypoint.new(0, 0.75, 0);
					NumberSequenceKeypoint.new(1, 1);
				}
			)
			Particles.Acceleration = Vector3.new(0, 0, 0)
			Particles.Lifetime = NumberRange.new(0.5, 1)
			Particles.Rate = 1000
			Particles.Drag = 20
			Particles.RotSpeed = NumberRange.new(-360,360)
			Particles.Speed = NumberRange.new(15,30)
			Particles.SpreadAngle = Vector2.new(180,360)
			Particles.Parent = Attachment
			Particles.EmissionDirection = "Front"
			Particles:Emit(25)

			Debris:AddItem(Attachment, Particles.Lifetime.Max)

			local Particles = Instance.new("ParticleEmitter")
			Particles.Enabled = false
			Particles.Color = ColorSequence.new(Color3.new(50, 50, 50))
			Particles.LightEmission = 0
			Particles.LightInfluence = 1
			Particles.Size = NumberSequence.new(
				{
					NumberSequenceKeypoint.new(0, 0.25, 0.1);
					NumberSequenceKeypoint.new(1, 2);
				}
			)
			Particles.Texture = "http://www.roblox.com/asset/?id=159998966"
			Particles.Transparency = NumberSequence.new(
				{
					NumberSequenceKeypoint.new(0, 0, 0);
					NumberSequenceKeypoint.new(1, 1);
				}
			)
			Particles.Acceleration = Vector3.new(0, -192, 0)
			Particles.Lifetime = NumberRange.new(.5, .5)
			Particles.Drag = 5
			Particles.RotSpeed = NumberRange.new(-15,15)
			Particles.Rotation = NumberRange.new(-360,360)
			Particles.Speed = NumberRange.new(50,50)
			Particles.SpreadAngle = Vector2.new(15,15)
			Particles.Parent = Attachment
			Particles.EmissionDirection = "Front"
			Particles:Emit(1)


			local bg = Instance.new("BillboardGui", Attachment)
			bg.Adornee = Attachment
			local flashsize = math.random(10, 15)/10
			bg.Size = UDim2.new(flashsize, 0, flashsize, 0)
			local flash = Instance.new("ImageLabel", bg)
			flash.BackgroundTransparency = 1
			flash.Size = UDim2.new(0.05, 0, 0.05, 0)
			flash.Position = UDim2.new(0.5, 0, 0.5, 0)
			flash.Image = "http://www.roblox.com/asset/?id=476778304"
			flash.ImageTransparency = math.random(0, .5)
			flash.Rotation = math.random(0, 360)
			flash:TweenSizeAndPosition(UDim2.new(1, 0, 1, 0), UDim2.new(0, 0, 0, 0), "Out", "Quad", 0.1)	
			game.Debris:AddItem(bg, 0.1)

			local a = Instance.new("Part", BulletModel)
			a.FormFactor = "Custom"
			a.TopSurface = 0
			a.BottomSurface = 0
			a.Transparency = 1
			a.CanCollide = false
			a.Size = Vector3.new(0.5, 0, 0.5)
			a.CFrame = 	CFrame.new(Position,Position-Normal) * CFrame.Angles(90*math.pi/180,math.random(0,360)*math.pi/180,0)
			a.BrickColor = BrickColor.new("Really black")
			a.Material = Enum.Material.Air
			Debris:AddItem(a, 60)

			local b = Instance.new('WeldConstraint')
			b.Parent = a
			b.Part0 = a
			b.Part1 = HitPart

			local c = Instance.new("Decal", a)
			c.Texture = "rbxassetid://"..grass_bulletholes[math.random(1,4)]
			c.Face = "Top"
			--		c.Transparency = 0

			local d = Instance.new("PointLight", a)
			d.Color = Color3.new(0, 0, 0)
			d.Range = 0
			d.Shadows = true

			local e = Instance.new("Weld")
			e.Part0 = a
			e.Part1 = HitPart

		elseif HitPart.Material == Enum.Material.Sand then
			local BulletWhizz = Instance.new("Sound")
			BulletWhizz.Parent = Attachment
			BulletWhizz.Volume = math.random(20,30)/10
			BulletWhizz.MaxDistance = 100
			BulletWhizz.EmitterSize = 5
			BulletWhizz.PlaybackSpeed = math.random(38, 50)/40
			--BulletWhizz.SoundId = "rbxassetid://" .. Grass[math.random(1, #Grass)]

			--BulletWhizz:Play()

			local Particles = Instance.new("ParticleEmitter")
			Particles.Enabled = false
			Particles.Color = ColorSequence.new(workspace.Terrain:GetMaterialColor(Material))
			Particles.LightEmission = 0
			Particles.LightInfluence = 1
			Particles.Size = NumberSequence.new(
				{
					NumberSequenceKeypoint.new(0, 0.1, 0.1);
					NumberSequenceKeypoint.new(1, 5);
				}
			)
			Particles.Texture = "rbxasset://textures/particles/smoke_main.dds"
			Particles.Transparency = NumberSequence.new(
				{
					NumberSequenceKeypoint.new(0, 0.75, 0);
					NumberSequenceKeypoint.new(1, 1);
				}
			)
			Particles.Acceleration = Vector3.new(0, 0, 0)
			Particles.Lifetime = NumberRange.new(0.5, 1)
			Particles.Rate = 1000
			Particles.Drag = 20
			Particles.RotSpeed = NumberRange.new(-360,360)
			Particles.Speed = NumberRange.new(15,30)
			Particles.SpreadAngle = Vector2.new(180,360)
			Particles.Parent = Attachment
			Particles.EmissionDirection = "Front"
			Particles:Emit(25)

			Debris:AddItem(Attachment, Particles.Lifetime.Max)

			local Particles = Instance.new("ParticleEmitter")
			Particles.Enabled = false
			Particles.Color = ColorSequence.new(Color3.new(50, 50, 50))
			Particles.LightEmission = 0
			Particles.LightInfluence = 1
			Particles.Size = NumberSequence.new(
				{
					NumberSequenceKeypoint.new(0, 0.25, 0.1);
					NumberSequenceKeypoint.new(1, 2);
				}
			)
			Particles.Texture = "http://www.roblox.com/asset/?id=159998966"
			Particles.Transparency = NumberSequence.new(
				{
					NumberSequenceKeypoint.new(0, 0, 0);
					NumberSequenceKeypoint.new(1, 1);
				}
			)
			Particles.Acceleration = Vector3.new(0, -192, 0)
			Particles.Lifetime = NumberRange.new(.5, .5)
			Particles.Drag = 5
			Particles.RotSpeed = NumberRange.new(-15,15)
			Particles.Rotation = NumberRange.new(-360,360)
			Particles.Speed = NumberRange.new(50,50)
			Particles.SpreadAngle = Vector2.new(15,15)
			Particles.Parent = Attachment
			Particles.EmissionDirection = "Front"
			Particles:Emit(1)


			local bg = Instance.new("BillboardGui", Attachment)
			bg.Adornee = Attachment
			local flashsize = math.random(10, 15)/10
			bg.Size = UDim2.new(flashsize, 0, flashsize, 0)
			local flash = Instance.new("ImageLabel", bg)
			flash.BackgroundTransparency = 1
			flash.Size = UDim2.new(0.05, 0, 0.05, 0)
			flash.Position = UDim2.new(0.5, 0, 0.5, 0)
			flash.Image = "http://www.roblox.com/asset/?id=476778304"
			flash.ImageTransparency = math.random(0, .5)
			flash.Rotation = math.random(0, 360)
			flash:TweenSizeAndPosition(UDim2.new(1, 0, 1, 0), UDim2.new(0, 0, 0, 0), "Out", "Quad", 0.1)	
			game.Debris:AddItem(bg, 0.1)

			local a = Instance.new("Part", BulletModel)
			a.FormFactor = "Custom"
			a.TopSurface = 0
			a.BottomSurface = 0
			a.Transparency = 1
			a.CanCollide = false
			a.Size = Vector3.new(0.5, 0, 0.5)
			a.CFrame = 	CFrame.new(Position,Position-Normal) * CFrame.Angles(90*math.pi/180,math.random(0,360)*math.pi/180,0)
			a.BrickColor = BrickColor.new("Really black")
			a.Material = Enum.Material.Air
			Debris:AddItem(a, 60)

			local b = Instance.new('WeldConstraint')
			b.Parent = a
			b.Part0 = a
			b.Part1 = HitPart

			local c = Instance.new("Decal", a)
			c.Texture = "rbxassetid://"..sand_bulletholes[math.random(1,4)]
			c.Face = "Top"
			--		c.Transparency = 0

			local d = Instance.new("PointLight", a)
			d.Color = Color3.new(0, 0, 0)
			d.Range = 0
			d.Shadows = true

			local e = Instance.new("Weld")
			e.Part0 = a
			e.Part1 = HitPart
		end

		if Material == Enum.Material.Wood or Material == Enum.Material.WoodPlanks then

			CreateEffect("Wood",Attachment)

		elseif Material == Enum.Material.Concrete -- Stone stuff
			or Material == Enum.Material.Slate
			or Material == Enum.Material.Brick
			or Material == Enum.Material.Pebble
			or Material == Enum.Material.Cobblestone
			or Material == Enum.Material.Marble

			-- Terrain materials
			or Material == Enum.Material.Basalt
			or Material == Enum.Material.Asphalt
			or Material == Enum.Material.Pavement
			or Material == Enum.Material.Rock
			or Material == Enum.Material.CrackedLava
			or Material == Enum.Material.Sandstone
			or Material == Enum.Material.Limestone
		then

			CreateEffect("Stone",Attachment)

		elseif Material == Enum.Material.Metal -- Metals
			or Material == Enum.Material.CorrodedMetal
			or Material == Enum.Material.DiamondPlate
			or Material == Enum.Material.Neon

			-- Terrain materials
			or Material == Enum.Material.Salt
		then

			CreateEffect("Metal",Attachment)

		elseif Material == Enum.Material.Grass -- Ground stuff

			-- Terrain materials
			or Material == Enum.Material.Ground
			or Material == Enum.Material.LeafyGrass
			or Material == Enum.Material.Mud
		then

			CreateEffect("Ground",Attachment)

		elseif Material == Enum.Material.Sand -- Soft things
			or Material == Enum.Material.Fabric

			-- Terrain materials
			or Material == Enum.Material.Snow
		then

			CreateEffect("Sand",Attachment,true,HitPart)

		elseif Material == Enum.Material.Foil -- Brittle things
			or Material == Enum.Material.Ice
			or Material == Enum.Material.Glass
			or Material == Enum.Material.ForceField
		then

			CreateEffect("Glass",Attachment,true,HitPart)

		else

			CreateEffect("Stone",Attachment)

		end
	end
end

function Hitmarker.Explosion(Position, HitPart, Normal)

	local Hitmark = Instance.new("Attachment")
		Hitmark.CFrame = CFrame.new(Position, Position + Normal)
		Hitmark.Parent = workspace.Terrain

		local S = Instance.new("Sound")
		S.EmitterSize = 50
		S.MaxDistance = 1500
		S.SoundId = "rbxassetid://".. Explosion[math.random(1, 7)]
		S.PlaybackSpeed = math.random(30,55)/40
		S.Volume = 2
		S.Parent = Hitmark
		S.PlayOnRemove = true
		S:Destroy()

	local Exp = Instance.new("Explosion")
		Exp.BlastPressure = 0
		Exp.BlastRadius = 0
		Exp.DestroyJointRadiusPercent = 0
		Exp.Position = Hitmark.Position
		Exp.Parent = Hitmark

	Debris:AddItem(Hitmark, 5)
	
end

return Hitmarker