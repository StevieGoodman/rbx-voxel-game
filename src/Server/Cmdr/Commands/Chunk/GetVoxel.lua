local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Integer3 = require(ReplicatedStorage.Classes.Integer3)
local World = require(ReplicatedStorage.Classes.World)

return {
    Name        = "GetVoxel",
    Description = "Gets a voxel ID.",
    Args        = {
        {
            Type = "integer3",
            Name = "Voxel Coordinates",
            Description = "The co-ordinates of the voxel to retrieve.",
        },
    },
    ClientRun = function(_, chunkCoordinates: Integer3.Integer3)
        local voxel = World.GetVoxel(chunkCoordinates)
        return `Voxel at {chunkCoordinates} is {voxel}`
    end
}