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
    voxelPart.Size = Voxel.Dimensions:ToVector3()
    voxelPart.Position = ((chunk.Coordinates * Chunk.Dimensions + localCoordinates) * Voxel.Dimensions):ToVector3()
    voxelPart.Anchored = true
    voxelPart.Parent = chunk.PartFolder
    return voxelPart
end

function Renderer.RenderChunk(chunk: Chunk.Chunk)
    for x = 0, Chunk.Dimensions.X - 1 do
        for y = 0, Chunk.Dimensions.Y - 1 do
            for z = 0, Chunk.Dimensions.Z - 1 do
                local localCoordinates = Integer3.new(x, y, z)
                local voxel = chunk:GetVoxel(localCoordinates)
                if voxel == 0 then continue end
                Renderer.RenderVoxel(chunk, localCoordinates)
            end
        end
    end
end

return Renderer