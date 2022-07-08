-- Config variables
local castLimit = 4 -- Number of times the module will recast if a non collided part is hit
local castDebug = false -- Creates red dots where raycasts hit


local dir = {}
local lastResult
local players = game:GetService("Players")

local defaultParams = RaycastParams.new()
defaultParams.FilterType = Enum.RaycastFilterType.Blacklist
defaultParams.IgnoreWater = true

dir.CastToTarget = function(origin,target,tolerance,distLimit,ignore,params)
	
	local cParams
	local hit = false
	local result
	local castCount = 0
	local firstOrigin = origin
	
	-- Set new arguments
	if params then
		cParams = params
	else
		cParams = defaultParams
	end
	
	if not distLimit then distLimit = 4000 end
	
	-- Loop cast until target hit or hit nil
	local direction = (target - origin).Unit
	while castCount < castLimit and not hit do
		castCount = castCount + 1
		
		defaultParams.FilterDescendantsInstances = ignore
		
		-- Too far away
		if (firstOrigin - origin).Magnitude > distLimit then
			break
		end
		
		result = workspace:Raycast(origin,direction * distLimit,defaultParams)
		if result then lastResult = result end
		
		if result and castDebug then
			--print("Cast hit "..result.Instance.Name)
			local dPart = Instance.new("Part")
			dPart.Shape = Enum.PartType.Ball
			dPart.Size = Vector3.new(0.4,0.4,0.4)
			dPart.Anchored = true
			dPart.Position = result.Position
			dPart.CanCollide = false
			dPart.Transparency = 0.5
			dPart.Color = Color3.new(1, 0, 0)
			dPart.Name = "Debug"
			dPart.Parent = workspace
			table.insert(ignore,dPart)
		end
		
		if not result then
			-- Hit nil!
			break
		elseif result.Instance:IsA("Terrain") then
			-- Hit terrain
			hit = true
		elseif result.Instance:IsA("BasePart") and not result.Instance.CanCollide then
			-- Hit a part without collisions, recast
			origin = result.Position
			table.insert(ignore,result.Instance)
		elseif (result.Instance:IsA("BasePart") and result.Instance.CanCollide) or result.Instance.Name == "Armor" then
			-- Hit a part with collisions!
			hit = true
		end
	end
	
	if not hit then
		if (origin - target).Magnitude < tolerance and lastResult then
			return lastResult
		else
			return nil
		end
	else
		if (result.Position - target).Magnitude < tolerance then
			return result
		end
	end
end

return dir