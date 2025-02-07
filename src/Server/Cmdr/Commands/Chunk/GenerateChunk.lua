local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Integer3 = require(ReplicatedStorage.Classes.Integer3)
local ChunkGenerator = require(ReplicatedStorage.Classes.ChunkGenerator)
local Renderer = require(ReplicatedStorage.Classes.Renderer)

return {
    Name        = "RenderAround",
    Description = "Renders around a specific chunk.",
    Args        = {
        {
            Type = "integer3",
            Name = "Chunk Coordinates",
            Description = "The chunk to render around",
        },
        {
            Type = "integer",
            Name = "Radius",
            Description = "The chunk radius to render around the chunk",
        },
    },
    ClientRun = function(_, chunkCoordinates: Integer3.Integer3, chunkRadius: number)
        Renderer.RenderAround(chunkCoordinates, chunkRadius)
        return `Generated chunk at {chunkCoordinates}`
    end
}