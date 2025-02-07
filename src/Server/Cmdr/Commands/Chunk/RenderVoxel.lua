local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Integer3 = require(ReplicatedStorage.Classes.Integer3)
local Chunk = require(ReplicatedStorage.Classes.Chunk)
local Renderer = require(ReplicatedStorage.Classes.Renderer)

return {
    Name        = "RenderVoxel",
    Description = "Renders a voxel.",
    Args        = {
        {
            Type = "integer3",
            Name = "Voxel Coordinates",
            Description = "The co-ordinates of the voxel to render.",
        },
    },
    ClientRun = function(_, localCoordinates: Integer3.Integer3)
        local chunk = Chunk.new(Integer3.new(0, 0, 0))
        Renderer.RenderVoxel(chunk, localCoordinates)
        return `Rendered`
    end
}