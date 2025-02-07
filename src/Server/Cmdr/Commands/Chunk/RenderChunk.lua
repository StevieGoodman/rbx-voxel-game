local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Integer3 = require(ReplicatedStorage.Classes.Integer3)
local Renderer = require(ReplicatedStorage.Classes.Renderer)
local Chunk = require(ReplicatedStorage.Classes.Chunk)
local World = require(ReplicatedStorage.Classes.World)

return {
    Name        = "RenderChunk",
    Description = "Renders a chunk.",
    Args        = {
        {
            Type = "integer3",
            Name = "Chunk Coordinates",
            Description = "The co-ordinates of the chunk to render.",
        },
    },
    ClientRun = function(_, chunkCoordinates: Integer3.Integer3)
        local chunk = Chunk.new(chunkCoordinates)
        World.LoadChunk(chunk)
        Renderer.RenderChunk(chunk)
        return `Rendered chunk at {chunkCoordinates}`
    end
}