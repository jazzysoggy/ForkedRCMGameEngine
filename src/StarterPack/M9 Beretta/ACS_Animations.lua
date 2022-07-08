local TS = game:GetService('TweenService')
local self = {}

self.MainCFrame 	= CFrame.new(0.5,-0.85,-0.75)

self.GunModelFixed 	= true
self.GunCFrame 		= CFrame.new(0, 0, 1.25) * CFrame.Angles(math.rad(90),math.rad(0),math.rad(0))
self.LArmCFrame 	= CFrame.new(-0.2,-0.5,0) * CFrame.Angles(math.rad(110),math.rad(0),math.rad(30))
self.RArmCFrame 	= CFrame.new(0.1,-0.15,0.5) * CFrame.Angles(math.rad(90),math.rad(5),math.rad(0))

self.EquipAnim = function(objs)
	objs[4].Handle.MagPouch:Play()
	TS:Create(objs[1], TweenInfo.new(.25,Enum.EasingStyle.Linear), {C1 = (CFrame.new(1,-1,1) * CFrame.Angles(math.rad(0),math.rad(0),math.rad(0))):Inverse() }):Play()
	TS:Create(objs[2], TweenInfo.new(.25,Enum.EasingStyle.Linear), {C1 = (CFrame.new(-1,-1,1) * CFrame.Angles(math.rad(0),math.rad(0),math.rad(0))):Inverse() }):Play()
	wait(.25)
 	objs[4].Handle.FireSelect:Play()
	TS:Create(objs[1], TweenInfo.new(.35,Enum.EasingStyle.Sine), {C1 = self.RArmCFrame:Inverse()}):Play()
	TS:Create(objs[2], TweenInfo.new(.35,Enum.EasingStyle.Sine), {C1 = self.LArmCFrame:Inverse()}):Play()
	wait(.35)
end;

self.IdleAnim = function(objs)
	TS:Create(objs[1], TweenInfo.new(.25,Enum.EasingStyle.Sine), {C1 = self.RArmCFrame:Inverse()}):Play()
	TS:Create(objs[2], TweenInfo.new(.25,Enum.EasingStyle.Sine), {C1 = self.LArmCFrame:Inverse()}):Play()
end;

self.LowReady = function(objs)
	TS:Create(objs[1],TweenInfo.new(.25,Enum.EasingStyle.Sine),{C1 = (CFrame.new(0.05,-0.15,1) * CFrame.Angles(math.rad(65), math.rad(0), math.rad(0))):Inverse() }):Play()
	TS:Create(objs[2],TweenInfo.new(.25,Enum.EasingStyle.Sine),{C1 = (CFrame.new(-.6,-0.75,-.25) * CFrame.Angles(math.rad(65),math.rad(0),math.rad(55))):Inverse() }):Play()
	wait(0.25)	
end;

self.HighReady = function(objs)
	TS:Create(objs[1],TweenInfo.new(.25,Enum.EasingStyle.Sine),{C1 = (CFrame.new(0.35,-0.5,1) * CFrame.Angles(math.rad(135), math.rad(0), math.rad(0))):Inverse() }):Play()
	TS:Create(objs[2],TweenInfo.new(.25,Enum.EasingStyle.Sine),{C1 = (CFrame.new(-.2,-0.7,0.25) * CFrame.Angles(math.rad(155),math.rad(35),math.rad(35))):Inverse() }):Play()
	wait(0.25)	
end;

self.Patrol = function(objs)
	TS:Create(objs[1], TweenInfo.new(.25,Enum.EasingStyle.Sine), {C1 = (CFrame.new(.75,-0.15,0) * CFrame.Angles(math.rad(90),math.rad(20),math.rad(-75))):Inverse() }):Play()
	TS:Create(objs[2], TweenInfo.new(.25,Enum.EasingStyle.Sine), {C1 = (CFrame.new(-1.15,-0.75,0.4) * CFrame.Angles(math.rad(90),math.rad(20),math.rad(55))):Inverse() }):Play()	
	wait(.25)	
end;

self.SprintAnim = function(objs)
	TS:Create(objs[1],TweenInfo.new(0.3,Enum.EasingStyle.Sine),{C1 = CFrame.new(0, 0.2, -0.4) * CFrame.Angles(math.rad(-80), math.rad(-35), math.rad(-15))}):Play()
	TS:Create(objs[2],TweenInfo.new(0.3,Enum.EasingStyle.Sine),{C1 = (CFrame.new(-1.1,-0.75,-.25) * CFrame.Angles(math.rad(85),math.rad(-15),math.rad(15))):Inverse() }):Play()
	wait(0.3)
end;

self.ReloadAnim = function(objs)

	-- Grab mag
	TS:Create(objs[1], TweenInfo.new(0.3,Enum.EasingStyle.Sine), {C1 = (CFrame.new(0, -.2, 0) * CFrame.Angles(math.rad(90),math.rad(0),math.rad(0))):Inverse() }):Play()
	TS:Create(objs[2], TweenInfo.new(0.3,Enum.EasingStyle.Sine), {C1 = (CFrame.new(0, -.5, 0) * CFrame.Angles(math.rad(50),math.rad(5),math.rad(30))):Inverse() }):Play()
	wait(.3)
	TS:Create(objs[1], TweenInfo.new(0.2,Enum.EasingStyle.Sine), {C1 = (CFrame.new(0, -.2, 0) * CFrame.Angles(math.rad(90),math.rad(15),math.rad(0))):Inverse() }):Play()
	objs[4].Handle.Click:Play()
	wait(.1)
	TS:Create(objs[1], TweenInfo.new(0.2,Enum.EasingStyle.Sine), {C1 = (CFrame.new(0, -.2, 0) * CFrame.Angles(math.rad(90),math.rad(-25),math.rad(0))):Inverse() }):Play()
	objs[4].Handle.MagOut:Play()
	objs[4].Mag.Transparency = 1
	wait(.3)
	-- Pull out mag
	
	-- Grab next mag
	TS:Create(objs[1], TweenInfo.new(0.3,Enum.EasingStyle.Sine), {C1 = (CFrame.new(0.2,-0.2,0.5) * CFrame.Angles(math.rad(75),math.rad(-15),math.rad(0))):Inverse() }):Play()
	
	wait(0.7)
	
	objs[4].Handle.MagPouch:Play()
	
	wait(1.3)
	
	-- Insert new mag
	objs[4].Mag.Transparency = 0
	objs[4].Handle.MagIn:Play()
	TS:Create(objs[2], TweenInfo.new(0.3,Enum.EasingStyle.Sine), {C1 = (CFrame.new(-0.5,-0.5,-0.2) * CFrame.Angles(math.rad(90),math.rad(-15),math.rad(30))):Inverse() }):Play()
	
	TS:Create(objs[1], TweenInfo.new(0.3,Enum.EasingStyle.Back), {C1 = (CFrame.new(0.2,-0.2,0.5) * CFrame.Angles(math.rad(90),math.rad(-15),math.rad(0))):Inverse() }):Play()
	
	wait(0.3)
end;

self.TacticalReloadAnim = function(objs)

	-- Grab mag
	objs[4].Bolt.SlidePull:Play()
	TS:Create(objs[4].Handle.Slide, TweenInfo.new(.2,Enum.EasingStyle.Sine), {C0 =  CFrame.new(0,0,-0.4):Inverse() }):Play()
	TS:Create(objs[1], TweenInfo.new(0.3,Enum.EasingStyle.Sine), {C1 = (CFrame.new(0, -.2, 0) * CFrame.Angles(math.rad(90),math.rad(0),math.rad(0))):Inverse() }):Play()
	TS:Create(objs[2], TweenInfo.new(0.3,Enum.EasingStyle.Sine), {C1 = (CFrame.new(0, -.5, 0) * CFrame.Angles(math.rad(50),math.rad(5),math.rad(30))):Inverse() }):Play()
	wait(.3)
	TS:Create(objs[1], TweenInfo.new(0.2,Enum.EasingStyle.Sine), {C1 = (CFrame.new(0, -.2, 0) * CFrame.Angles(math.rad(90),math.rad(15),math.rad(0))):Inverse() }):Play()
	objs[4].Handle.Click:Play()
	wait(.1)
	TS:Create(objs[1], TweenInfo.new(0.2,Enum.EasingStyle.Sine), {C1 = (CFrame.new(0, -.2, 0) * CFrame.Angles(math.rad(90),math.rad(-25),math.rad(0))):Inverse() }):Play()
	objs[4].Handle.MagOut:Play()
	objs[4].Mag.Transparency = 1
	wait(.3)
	-- Pull out mag

	-- Grab next mag
	TS:Create(objs[1], TweenInfo.new(0.3,Enum.EasingStyle.Sine), {C1 = (CFrame.new(0.2,-0.2,0.5) * CFrame.Angles(math.rad(75),math.rad(-15),math.rad(0))):Inverse() }):Play()

	wait(0.7)

	objs[4].Handle.MagPouch:Play()

	wait(1.3)

	-- Insert new mag
	objs[4].Mag.Transparency = 0
	objs[4].Handle.MagIn:Play()
	TS:Create(objs[2], TweenInfo.new(0.3,Enum.EasingStyle.Sine), {C1 = (CFrame.new(-0.5,-0.5,-0.2) * CFrame.Angles(math.rad(90),math.rad(-15),math.rad(30))):Inverse() }):Play()
	wait(0.2)
	TS:Create(objs[2], TweenInfo.new(.25,Enum.EasingStyle.Sine), {C1 = (CFrame.new(-0.2,-0.5,0) * CFrame.Angles(math.rad(110),math.rad(0),math.rad(30))):Inverse() }):Play()
	wait(0.2)
	TS:Create(objs[2], TweenInfo.new(.25,Enum.EasingStyle.Sine), {C1 = (CFrame.new(0,-0.1,0) * CFrame.Angles(math.rad(110),math.rad(0),math.rad(40))):Inverse() }):Play()
	wait(0.2)
	objs[4].Bolt.SlidePull:Play()
	TS:Create(objs[2], TweenInfo.new(.25,Enum.EasingStyle.Sine), {C1 = (CFrame.new(0,-0.1,0.3) * CFrame.Angles(math.rad(110),math.rad(0),math.rad(40))):Inverse() }):Play()	
	wait(0.1)
	TS:Create(objs[2], TweenInfo.new(.25,Enum.EasingStyle.Sine), {C1 = (CFrame.new(0,-0.1,0) * CFrame.Angles(math.rad(110),math.rad(0),math.rad(40))):Inverse() }):Play()	
	TS:Create(objs[1], TweenInfo.new(0.3,Enum.EasingStyle.Back), {C1 = (CFrame.new(0.2,-0.2,0.5) * CFrame.Angles(math.rad(90),math.rad(-15),math.rad(0))):Inverse() }):Play()
	TS:Create(objs[4].Handle.Slide, TweenInfo.new(.2,Enum.EasingStyle.Sine), {C0 =  CFrame.new(0,0,0.01):Inverse() }):Play()
	
	objs[4].Handle.Click:Play()
	objs[4].Bolt.SlideRelease:Play()
	wait(0.3)
end;

self.JammedAnim = function(objs)
	TS:Create(objs[1], TweenInfo.new(.25,Enum.EasingStyle.Sine), {C1 = (CFrame.new(0.05,-0.15,.75) * CFrame.Angles(math.rad(90),math.rad(0),math.rad(0))):Inverse() }):Play()
	TS:Create(objs[2], TweenInfo.new(.25,Enum.EasingStyle.Sine), {C1 = (CFrame.new(-.5,-0.35,0.45) * CFrame.Angles(math.rad(160),math.rad(0),math.rad(0))):Inverse() }):Play()
	wait(.25)
	objs[4].Bolt.SlidePull:Play()
	TS:Create(objs[4].Handle.Slide, TweenInfo.new(.2,Enum.EasingStyle.Sine), {C0 =  CFrame.new(0,0,-0.4):Inverse() }):Play()
	TS:Create(objs[4].Handle.Bolt, TweenInfo.new(.2,Enum.EasingStyle.Sine), {C0 =  CFrame.new(0,0,-0.4):Inverse() }):Play()
	TS:Create(objs[2], TweenInfo.new(.2,Enum.EasingStyle.Sine), {C1 = (CFrame.new(-.5,-0.35,0.45) * CFrame.Angles(math.rad(180),math.rad(0),math.rad(0))):Inverse() }):Play()
	wait(.3)
	TS:Create(objs[4].Handle.Slide, TweenInfo.new(.1,Enum.EasingStyle.Linear), {C0 =  CFrame.new():Inverse() }):Play()
	TS:Create(objs[4].Handle.Bolt, TweenInfo.new(.1,Enum.EasingStyle.Linear), {C0 =  CFrame.new():Inverse() }):Play()
	objs[4].Bolt.SlideRelease:Play()
end;

self.PumpAnim = function(objs)

end;

self.MagCheck = function(objs)
	objs[4].Handle.AimUp:Play()
	TS:Create(objs[1], TweenInfo.new(.25,Enum.EasingStyle.Sine), {C1 = (CFrame.new(0.5,-0.15,0) * CFrame.Angles(math.rad(100),math.rad(0),math.rad(-45))):Inverse() }):Play()
	TS:Create(objs[2], TweenInfo.new(.25,Enum.EasingStyle.Linear), {C1 = (CFrame.new(-1,-1,1) * CFrame.Angles(math.rad(0),math.rad(0),math.rad(0))):Inverse() }):Play()
	wait(2.5)
	objs[4].Handle.AimDown:Play()
	TS:Create(objs[1], TweenInfo.new(.25,Enum.EasingStyle.Sine), {C1 = (CFrame.new(0.5,-0.15,0) * CFrame.Angles(math.rad(160),math.rad(60),math.rad(-45))):Inverse() }):Play()
	TS:Create(objs[2], TweenInfo.new(.25,Enum.EasingStyle.Linear), {C1 = (CFrame.new(-1,-1,1) * CFrame.Angles(math.rad(0),math.rad(0),math.rad(0))):Inverse() }):Play()
	wait(2.5)
	objs[4].Handle.AimUp:Play()
end;

self.meleeAttack = function(objs)

end;

self.GrenadeReady = function(objs)

end;

self.GrenadeThrow = function(objs)

end;

----------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------
--//Server Animations
------//Idle Position
self.SV_GunPos 		= CFrame.new(-.3, -1, -0.4) * CFrame.Angles(math.rad(-90), math.rad(0), math.rad(0));

self.SV_RightArmPos = CFrame.new(-0.85, 0.1, -1.2) * CFrame.Angles(math.rad(-90), math.rad(0), math.rad(0));
self.SV_LeftArmPos 	= CFrame.new(1.05,0.9,-1.4) * CFrame.Angles(math.rad(-100),math.rad(25),math.rad(-20));

------//High Ready Animations
self.RightHighReady = CFrame.new(-1, -1, -1.5) * CFrame.Angles(math.rad(-160), math.rad(0), math.rad(0));
self.LeftHighReady 	= CFrame.new(.85,-0.35,-1.15) * CFrame.Angles(math.rad(-170),math.rad(60),math.rad(15));

------//Low Ready Animations
self.RightLowReady 	= CFrame.new(-1, 0.5, -1.25) * CFrame.Angles(math.rad(-60), math.rad(0), math.rad(0));
self.LeftLowReady 	= CFrame.new(1.25,1.15,-1.35) * CFrame.Angles(math.rad(-60),math.rad(35),math.rad(-25));

------//Patrol Animations
self.RightPatrol 	= CFrame.new(-1, -.35, -1.5) * CFrame.Angles(math.rad(-80), math.rad(-80), math.rad(0));
self.LeftPatrol 	= CFrame.new(1,1.25,-.75) * CFrame.Angles(math.rad(-90),math.rad(-45),math.rad(-25));

------//Aim Animations
self.RightAim 		= CFrame.new(-.575, 0.1, -1) * CFrame.Angles(math.rad(-90), math.rad(0), math.rad(0));
self.LeftAim 		= CFrame.new(1.4,0.25,-1.45) * CFrame.Angles(math.rad(-120),math.rad(35),math.rad(-25));

------//Sprinting Animations
self.RighTSprint 	= CFrame.new(-1, 0.5, -1.25) * CFrame.Angles(math.rad(-60), math.rad(0), math.rad(0));
self.LefTSprint 	= CFrame.new(1.25,1.15,-1.35) * CFrame.Angles(math.rad(-60),math.rad(35),math.rad(-25));

return self