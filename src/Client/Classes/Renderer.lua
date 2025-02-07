local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Chunk = require(ReplicatedStorage.Classes.Chunk)
local Integer3 = require(ReplicatedStorage.Classes.Integer3)
local Voxel = require(ReplicatedStorage.Classes.Voxel)

export type Renderer = {
    RenderChunk: (chunkCoordinates: Integer3.Integer3) -> (),
    ReleaseChunk: (chunkCoordinates: Integer3.Integer3) -> (),
}

local Renderer = {}

function Renderer.RenderVoxel(chunk: Chunk.Chunk, localCoordinates: Integer3.Integer3): Part
    local voxelPart = Instance.new("Part")
    voxelPart.Size = Vector3.one * Voxel.Size
    voxelPart.Position = ((chunk.Coordinates * Chunk.Dimensions) + (localCoordinates * Voxel.Size)):ToVector3()
    voxelPart.Anchored = true
    voxelPart.Parent = chunk.PartFolder
    return voxelPart
end

return Renderer