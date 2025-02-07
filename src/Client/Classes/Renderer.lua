local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Chunk = require(ReplicatedStorage.Classes.Chunk)
local Voxel = require(ReplicatedStorage.Classes.Voxel)
local World = require(ReplicatedStorage.Classes.World)
local Integer3 = require(ReplicatedStorage.Classes.Integer3)

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

function Renderer.LoadSurroundingChunks(chunk: Chunk.Chunk)
    local coordinateOffsets = {
        Integer3.Up,
        Integer3.Down,
        Integer3.Left,
        Integer3.Right,
        Integer3.Forward,
        Integer3.Back,
    }
    for _, coordinateOffset in coordinateOffsets do
        local chunkCoordinates = chunk.Coordinates + coordinateOffset
        if World.IsChunkLoaded(chunkCoordinates) then continue end
        local unloadedChunk = Chunk.new(chunkCoordinates)
        World.LoadChunk(unloadedChunk)
    end
end

function Renderer.RenderChunk(chunk: Chunk.Chunk)
    Renderer.LoadSurroundingChunks(chunk)
    for x = 0, Chunk.Dimensions.X - 1 do
        for y = 0, Chunk.Dimensions.Y - 1 do
            for z = 0, Chunk.Dimensions.Z - 1 do
                local localCoordinates = Integer3.new(x, y, z)
                local voxel = chunk:GetVoxel(localCoordinates)
                if voxel == 0 then continue end
                local surroundingVoxels = World.GetNeighbouringVoxels(chunk:ToGlobalCoordinates(localCoordinates))
                local exposedToAir = false
                local sideCount = 0
                for _, neighbour in surroundingVoxels do
                    sideCount += 1
                    if neighbour ~= 0 then continue end
                    exposedToAir = true
                    break
                end
                if not exposedToAir and sideCount == 6 then continue end
                Renderer.RenderVoxel(chunk, localCoordinates)
            end
        end
    end
end

return Renderer