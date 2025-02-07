local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Integer3 = require(ReplicatedStorage.Classes.Integer3)
local Table3 = require(ReplicatedStorage.Classes.Table3)
local Chunk = require(ReplicatedStorage.Classes.Chunk)
local World = require(ReplicatedStorage.Classes.World)

local ChunkGenerator = {
    NoiseStretch = 0.02,
    DirtDepth = 3,
}

function ChunkGenerator.GenerateChunk(chunkCoordinates: Integer3.Integer3): Chunk.Chunk
    local chunk = World.GetChunk(chunkCoordinates) or Chunk.new(chunkCoordinates)
    chunk.VoxelData = ChunkGenerator.GenerateVoxelData(chunkCoordinates)
    World.LoadChunk(chunk)
    return chunk
end

function ChunkGenerator.GenerateVoxelData(chunkCoordinates: Integer3.Integer3): Table3.Table3
    local voxelData = Table3.new(Chunk.Dimensions, 0)
    for x = 0, Chunk.Dimensions.X - 1 do
        for y = 0, Chunk.Dimensions.Y - 1 do
            for z = 0, Chunk.Dimensions.Z - 1 do
                local globalVoxelCoordinates = (Chunk.Dimensions * chunkCoordinates) + Integer3.new(x, y, z)
                local voxelId = ChunkGenerator.CalculateVoxelId(globalVoxelCoordinates)
                voxelData:Set(Integer3.new(x, y, z), voxelId)
            end
        end
    end
    return voxelData
end

function ChunkGenerator.CalculateVoxelId(globalVoxelCoordinates: Integer3.Integer3): number
    local groundHeight = math.noise(
        globalVoxelCoordinates.X * ChunkGenerator.NoiseStretch,
        0,
        globalVoxelCoordinates.Z * ChunkGenerator.NoiseStretch
    )
    groundHeight *= 5

    if globalVoxelCoordinates.Y > groundHeight then
        return 0
    elseif globalVoxelCoordinates.Y > groundHeight - 1 then
        return 3
    elseif globalVoxelCoordinates.Y < groundHeight - ChunkGenerator.DirtDepth then
        return 1
    elseif globalVoxelCoordinates.Y < groundHeight then
        return 2
    end
end

return ChunkGenerator