local TS = game:GetService('TweenService')
local self = {}

self.SlideEx 		= CFrame.new(0,0,-0.4)
self.SlideLock 		= false

self.canAim 		= true
self.Zoom 			= 60
self.Zoom2 			= 60

self.gunName 		= script.Parent.Name
self.Type 			= "Gun"
self.EnableHUD		= true
self.IncludeChamberedBullet = true
self.Ammo 			= 15
self.StoredAmmo 	= 45
self.AmmoInGun 		= self.Ammo
self.MaxStoredAmmo	= 60
self.CanCheckMag 	= true
self.MagCount		= true
self.ShellInsert	= false
self.ShootRate 		= 600
self.Bullets 		= 1
self.BurstShot 		= 3
self.ShootType 		= 1				--[1 = SEMI; 2 = BURST; 3 = AUTO; 4 = PUMP ACTION; 5 = BOLT ACTION]
self.FireModes = {
	ChangeFiremode = true;		
	Semi = true;
	Burst = false;
	Auto = false;}

self.LimbDamage 	= {15,25}
self.TorsoDamage 	= {25,35} 
self.HeadDamage 	= {120,120} 
self.DamageFallOf 	= 1
self.MinDamage 		= 5
self.IgnoreProtection = false
self.BulletPenetration = 72

self.adsTime 		= 1

self.CrossHair 		= false
self.CenterDot 		= false
self.CrosshairOffset= 0
self.CanBreachDoor 	= false

self.SightAtt 		= ""
self.BarrelAtt		= ""
self.UnderBarrelAtt = ""
self.OtherAtt 		= ""

self.camRecoil = {
	camRecoilUp 	= {5,10}
	,camRecoilTilt 	= {10,15}
	,camRecoilLeft 	= {7,10}
	,camRecoilRight = {6,9}
}

self.gunRecoil = {
	gunRecoilUp 	= {45,50}
	,gunRecoilTilt 	= {10,20}
	,gunRecoilLeft 	= {15,20}
	,gunRecoilRight = {15,20}
}

self.AimRecoilReduction 		= 4
self.AimSpreadReduction 		= 1

self.MinRecoilPower 			= .5
self.MaxRecoilPower 			= 1.5
self.RecoilPowerStepAmount 		= .1

self.MinSpread 					= 0.75
self.MaxSpread 					= 100					
self.AimInaccuracyStepAmount 	= 0.75
self.AimInaccuracyDecrease 		= .25
self.WalkMult 					= 0

self.EnableZeroing 				= true
self.MaxZero 					= 500
self.ZeroIncrement 				= 50
self.CurrentZero 				= 0

self.BulletType 				= "9x19mm"
self.MuzzleVelocity 			= 910 --m/s
self.BulletDrop 				= .25 --Between 0 - 1
self.Tracer						= false
self.BulletFlare 				= false
self.TracerColor				= Color3.fromRGB(255,255,255)
self.RandomTracer				= {
	Enabled = false
	,Chance = 25 -- 0-100%
}
self.TracerEveryXShots			= 3
self.RainbowMode 				= false
self.InfraRed 					= false

self.CanBreak	= false
self.Jammed		= false

-- RCM Settings V

self.WeaponWeight		= 1 -- Weapon weight must be enabled in the Config module

self.ShellEjectionMod	= true

self.Holster			= true
self.HolsterPoint		= "Torso"
self.HolsterCFrame		= CFrame.new(0.65,0.1,-0.8) * CFrame.Angles(math.rad(-90),math.rad(15),math.rad(75))

self.FlashChance = 5 -- 0 = no muzzle flash, 10 = Always muzzle flash

self.ADSEnabled 		= { -- Ignore this setting if not using an ADS Mesh
	true, -- Enabled for primary sight
	false} -- Enabled for secondary sight (T)

self.ExplosiveAmmo		= false -- Enables explosive ammo
self.ExplosionRadius	= 70 -- Radius of explosion damage in studs
self.ExplosionType		= "Default" -- Which explosion effect is used from the HITFX Explosion folder
self.IsLauncher			= true -- For RPG style rocket launchers

self.EjectionOverride	= nil -- Don't touch unless you know what you're doing with Vector3s

self.SwayBase = 0			--- Weapon Base Sway | Studs
self.MaxSway =	0				--- Max sway value based on player stamina | Studs

self.AmmoWidth          = 9

return self