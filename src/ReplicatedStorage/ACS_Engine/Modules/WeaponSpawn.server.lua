local config = script.Parent.Config
local inf = config.Infinite.Value
local numRemaining = config.SpawnNumber
local waitTime = config.WaitTime.Value
local evt = script.Parent:WaitForChild("SpawnEvent")

function SpawnNewGun()
	evt:Fire()
	if not inf then
		numRemaining.Value = numRemaining.Value - 1
		if numRemaining.Value < 1 then
			script.Parent:Destroy()
		end
	end
end
SpawnNewGun()

script.Parent.ChildRemoved:Connect(function(oldChild)
	if oldChild:IsA("Model") then
		task.wait(waitTime)
		SpawnNewGun()
	end
end)