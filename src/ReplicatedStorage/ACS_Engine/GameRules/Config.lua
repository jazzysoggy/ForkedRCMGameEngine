
local ServerConfig = {
----------------------------------------------------------------------------------------------------
-----------------=[ General ]=----------------------------------------------------------------------
----------------------------------------------------------------------------------------------------
	 TeamKill = true					--- Enable TeamKill?
	,TeamDmgMult = 1					--- Between 0-1 | This will make you cause less damage if you hit your teammate
	
	,ReplicatedBullets = true			--- Keep in mind that some bullets will pass through surfaces...
	
	,AntiBunnyHop = true				--- Enable anti bunny hop system?
	,JumpCoolDown = 1.5					--- Seconds before you can jump again
	,JumpPower = 20						--- Jump power, default is 50
	
	,RealisticLaser = true				--- True = Laser line is invisible
	,ReplicatedLaser = true				
	,ReplicatedFlashlight = true
	
	,EnableRagdoll = true				--- Enable ragdoll death?
	,TeamTags = false					--- Aaaaaaa
	,HitmarkerSound = false				--- GGWP MLG 360 NO SCOPE xD
	,Crosshair = false					--- Crosshair for Hipfire shooters and arcade modes
	,CrosshairOffset = 5				--- Crosshair size offset
----------------------------------------------------------------------------------------------------
------------------=[ Core GUI ]=--------------------------------------------------------------------
----------------------------------------------------------------------------------------------------
	,CoreGuiHealth = false				--- Enable Health Bar?
	,CoreGuiPlayerList = false			--- Enable Player List?
	,TopBarTransparency = 1
----------------------------------------------------------------------------------------------------
------------------=[ Status UI ]=-------------------------------------------------------------------
----------------------------------------------------------------------------------------------------
	,EnableStatusUI 	= true				--- Don't disabled it...
	,RunWalkSpeed 		= 18
	,NormalWalkSpeed 	= 12
	,SlowPaceWalkSpeed 	= 6	
	,CrouchWalkSpeed 	= 6
	,ProneWalksSpeed 	= 3
	
	,InjuredWalksSpeed 		= 8
	,InjuredCrouchWalkSpeed = 4

	,EnableHunger = false				--- Hunger and Thirst system 		(Removed)
	,HungerWaitTime = 25

	,CanDrown = true 					--- Glub glub glub *ded*
	
	,EnableStamina = true 				--- Weapon Sway based on stamina	(Unused)
	,RunValue = 1						--- Stamina consumption
	,BreathValue = 0.5                 ---Stamina Consumption To Prevent Swaying
	,WalkRecover  = .125                 ---Stamina Recovery while walking
	,StandRecover = .25					--- Stamina recovery while stading
	,CrouchRecover = .5					--- Stamina recovery while crouching
	,ProneRecover = 1					--- Stamina recovery while lying

	,EnableGPS = false					--- GPS shows your allies around you
	,GPSdistance = 150

	,InteractionMenuKey = Enum.KeyCode.LeftAlt
----------------------------------------------------------------------------------------------------
----------------=[ Medic System ]=------------------------------------------------------------------
----------------------------------------------------------------------------------------------------
	,EnableMedSys = true
	,BleedDamage = 75					--- The damage needed to start bleeding
	,InjuredDamage = 25					--- The damage needed to get injured
	,KODamage = 90						--- The damage needed to pass out
	,PainMult = 1.5					--- 
	,BloodMult = 1.75					--- 

	,EnableFallDamage = true			--- Enable Fall Damage?
	,MaxVelocity = 75					--- Velocity that will trigger the damage
	,DamageMult = 1 					--- The min time a player has to fall in order to take fall damage.
----------------------------------------------------------------------------------------------------
--------------------=[ Others ]=--------------------------------------------------------------------
----------------------------------------------------------------------------------------------------
	,VehicleMaxZoom = 150
	
	,AgeRestrictEnabled = true
	,AgeLimit = 60
	
	,WaterMark = false
	
	,Blacklist = {} 		--- Auto kick the player (via ID) when he tries to join
	
	,Version = "ACS 2.0.1 - R6"
	
	
	
----------------------------------------------------------------------------------------------------
--------------------=[ RCM Settings ]=-----------------------------------------------------------------------
----------------------------------------------------------------------------------------------------
	
	-- Command Settings
										--- List of user IDs able to use regen and clear commands
	,HostList = {						--- Game owners automatically have perms, commands always work in studio
		57158149,						
	}
	,HostRank = 255					--- If the game is group owned, anyone above this rank number will automatically have command perms
	,CommandPrefix = "/"
	
	--	Command List
	--		/ClearGuns		Removes dropped guns from workspace		
	--		/ResetGlass		Replaces broken glass and removes shards
	--		/ResetLights	Fixes broken lights
	--		/ResetAll		Fixes both lights and glass
	--		/ACSlog			View kill log
	
	
	-- Keybinds
	
	,LeanLeft = Enum.KeyCode.Q
	,LeanRight = Enum.KeyCode.E
	,Crouch = Enum.KeyCode.C
	,StandUp = Enum.KeyCode.X
	,Sprint = Enum.KeyCode.LeftShift
	,SlowWalk = Enum.KeyCode.Z
	
	,Reload = Enum.KeyCode.R
	,FireMode = Enum.KeyCode.V
	,CheckMag = Enum.KeyCode.M
	,ZeroUp = Enum.KeyCode.RightBracket
	,ZeroDown = Enum.KeyCode.LeftBracket
	,DropGun = Enum.KeyCode.Backspace
	
	,SwitchSights = Enum.KeyCode.T
	,ToggleLight = Enum.KeyCode.J
	,ToggleLaser = Enum.KeyCode.H
	,ToggleBipod = Enum.KeyCode.B
	
	,Interact = Enum.KeyCode.G
	,ToggleNVG = Enum.KeyCode.N
	
	
	-- Effects Settings
	
	,BreakLights = true					--- Can break any part named "Light" with a light inside of it
	
	,BreakGlass = true					--- Can shatter glass with bullets
	,GlassName = "Glass"				--- Name of parts that can shatter
	,ShardDespawn = 60					--- How long glass stays before being removed
	
	,ShellLimit = 100					--- Max number of ejected shells that can be on the ground
	,ShellDespawn = 60					--- Shells will be deleted after being on the ground for this amount of time, 0 = No despawn
	
	
	-- Weapon Drop Settings
	
	,WeaponDropping = true				--- Enable weapon dropping with backspace?
	,WeaponCollisions = false			--- Allow weapons to collide with each other
	,SpawnStacking = false				--- Enabling this allows multiple guns to be spawned by one spawner, causing them to 'stack'
	,MaxDroppedWeapons = 50				--- Max number of weapons that can be dropped at once
	,PickupDistance = 7					--- Max distance from which a player can pickup guns

	,DropWeaponsOnDeath = true			--- Drop all guns on death
	,DropWeaponsOnLeave = false			--- Drop all guns when the player leaves the game
	
	,TimeDespawn = true					--- Enable a timer for weapon deletion
	,WeaponDespawnTime = 120			--- If TimeDespawn is enabled, dropped guns are deleted after this time

	
	-- Misc Settings
	
	,AmmoBoxDespawn = 300				--- Max time ammo boxes will be on the ground
		
	,EquipInVehicleSeat = true			--- Allow players to use weapons while operating a vehicle
	,EquipInSeat = true					--- Allow players to use weapons in regular seats
	,DisableInSeat = true				--- Prevents movement keybinds from messing with vehicle scripts like blizzard
	
	,WeaponWeight = true				--- Enables the WeaponWeight setting in guns, slowing down the player while a gun is equipped

	,HeadMovement = true				--- Toggles head movement
}

return ServerConfig