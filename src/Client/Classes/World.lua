local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Chunk = require(ReplicatedStorage.Classes.Chunk)
local Integer3 = require(ReplicatedStorage.Classes.Integer3)

local World = {
    Chunks = {},
}

function World.LoadChunk(chunk: Chunk.Chunk)
    local currentlyLoaded = World.Chunks[chunk.Coordinates:__tostring()] ~= nil
    if currentlyLoaded then return end
    World.Chunks[chunk.Coordinates:__tostring()] = chunk
end

function World.UnloadChunk(chunk: Chunk.Chunk)
    World.Chunks[chunk.Coordinates:__tostring()] = nil
end

function World.GetChunk(chunkCoordinates: Integer3.Integer3): Chunk.Chunk?
    return World.Chunks[chunkCoordinates:__tostring()]
end

function World.GetNeighbouringChunks(chunkCoordinates: Integer3.Integer3): {[string]: Chunk.Chunk?}
    return {
        [Integer3.Up:__tostring()] = World.GetChunk(chunkCoordinates + Integer3.Up),
        [Integer3.Down:__tostring()] = World.GetChunk(chunkCoordinates + Integer3.Down),
        [Integer3.Left:__tostring()] = World.GetChunk(chunkCoordinates + Integer3.Left),
        [Integer3.Right:__tostring()] = World.GetChunk(chunkCoordinates + Integer3.Right),
        [Integer3.Forward:__tostring()] = World.GetChunk(chunkCoordinates + Integer3.Forward),
        [Integer3.Back:__tostring()] = World.GetChunk(chunkCoordinates + Integer3.Back),
    }
end

function World.GetVoxel(globalVoxelCoordinates: Integer3.Integer3): number?
    local chunkCoordinates = globalVoxelCoordinates // Chunk.Dimensions
    local chunk = World.GetChunk(chunkCoordinates)
    if not chunk then return nil end
    local localVoxelCoordinates = chunk:ToLocalCoordinates(globalVoxelCoordinates)
    return chunk:GetVoxel(localVoxelCoordinates)
end

function World.SetVoxel(globalVoxelCoordinates: Integer3.Integer3, voxelId: number)
    local chunkCoordinates = globalVoxelCoordinates // Chunk.Dimensions
    local chunk = World.GetChunk(chunkCoordinates)
    if not chunk then return nil end
    local localVoxelCoordinates = chunk:ToLocalCoordinates(globalVoxelCoordinates)
    chunk:SetVoxel(localVoxelCoordinates, voxelId)
end

function World.GetNeighbouringVoxels(globalVoxelCoordinates: Integer3.Integer3): {[string]: number?}
    return {
        [Integer3.Up:__tostring()] = World.GetVoxel(globalVoxelCoordinates + Integer3.Up),
        [Integer3.Down:__tostring()] = World.GetVoxel(globalVoxelCoordinates + Integer3.Down),
        [Integer3.Left:__tostring()] = World.GetVoxel(globalVoxelCoordinates + Integer3.Left),
        [Integer3.Right:__tostring()] = World.GetVoxel(globalVoxelCoordinates + Integer3.Right),
        [Integer3.Forward:__tostring()] = World.GetVoxel(globalVoxelCoordinates + Integer3.Forward),
        [Integer3.Back:__tostring()] = World.GetVoxel(globalVoxelCoordinates + Integer3.Back),
    }
end

function World.IsChunkLoaded(chunkCoordinates: Integer3.Integer3): boolean
    return World.GetChunk(chunkCoordinates) ~= nil
end

function World.IsVoxelLoaded(globalVoxelCoordinates: Integer3.Integer3): boolean
    local chunkCoordinates = globalVoxelCoordinates // Chunk.Dimensions
    return World.IsChunkLoaded(chunkCoordinates)
end

return World