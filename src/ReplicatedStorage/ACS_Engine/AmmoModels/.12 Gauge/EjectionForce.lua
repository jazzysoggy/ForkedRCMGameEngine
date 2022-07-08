local EjectionForce = {}

-- Force direction
function EjectionForce.CalculateForce()
	return Vector3.new(
		math.random(270,320) / 10, -- Side to side
		math.random(50,70) / 10, -- Up
		-math.random(300,320) / 10 -- Front
	)
end

-- Shell physical properties
EjectionForce.PhysProperties = PhysicalProperties.new(
	10, -- Density
	30, -- Friction
	0.1, -- Elasticity
	10, -- FrictionWeight
	1 -- ElasticityWeight
)

-- Force attachment
EjectionForce.ForcePoint = Vector3.new(
	0,0,-0.1
)

return EjectionForce