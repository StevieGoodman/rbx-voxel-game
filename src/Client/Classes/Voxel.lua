local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Integer3 = require(ReplicatedStorage.Classes.Integer3)

local Voxel = {}

Voxel.Dimensions = Integer3.new(4, 4, 4)

return Voxel