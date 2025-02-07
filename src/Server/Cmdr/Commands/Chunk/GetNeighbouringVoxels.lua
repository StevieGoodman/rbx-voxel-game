local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Integer3 = require(ReplicatedStorage.Classes.Integer3)
local World = require(ReplicatedStorage.Classes.World)

return {
    Name        = "GetNeighbouringVoxels",
    Description = "Gets a list of neighbouring voxels.",
    Args        = {
        {
            Type = "integer3",
            Name = "Voxel Coordinates",
            Description = "The co-ordinates of the voxel to get a list of neighbours for.",
        },
    },
    ClientRun = function(_, voxelCoordinates: Integer3.Integer3)
        local message = ""
        for direction, neighbourVoxel in World.GetNeighbouringVoxels(voxelCoordinates) do
            message ..= `{direction}: {neighbourVoxel}\n`
        end
        if message == "" then
            return `Voxel {voxelCoordinates} is not loaded.`
        end
        return string.gsub(message, "\n$", "")
    end
}