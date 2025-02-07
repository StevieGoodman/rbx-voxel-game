local ReplicatedStorage = game:GetService("ReplicatedStorage")

local ChunkGenerator = require(ReplicatedStorage.Classes.ChunkGenerator)
local Chunk = require(ReplicatedStorage.Classes.Chunk)
local Voxel = require(ReplicatedStorage.Classes.Voxel)
local World = require(ReplicatedStorage.Classes.World)
local Integer3 = require(ReplicatedStorage.Classes.Integer3)

export type Renderer = {
    RenderChunk: (chunkCoordinates: Integer3.Integer3) -> (),
    ReleaseChunk: (chunkCoordinates: Integer3.Integer3) -> (),
}

local DEFAULT_VOXEL_COLOR = BrickColor.new("Medium stone grey").Color

local Renderer = {}

function Renderer.RenderVoxel(chunk: Chunk.Chunk, localCoordinates: Integer3.Integer3, voxel: Voxel.Voxel): Part
    local voxelPart = Instance.new("Part")
    voxelPart.Size = Voxel.Dimensions:ToVector3()
    voxelPart.Position = ((chunk.Coordinates * Chunk.Dimensions + localCoordinates) * Voxel.Dimensions):ToVector3()
    voxelPart.Anchored = true
    voxelPart.Material = Enum.Material.SmoothPlastic
    voxelPart.Color = voxel.Color or DEFAULT_VOXEL_COLOR
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
        ChunkGenerator.GenerateChunk(chunkCoordinates)
    end
end

function Renderer.RenderChunk(chunk: Chunk.Chunk)
    Renderer.ReleaseChunk(chunk)
    Renderer.LoadSurroundingChunks(chunk)
    for x = 0, Chunk.Dimensions.X - 1 do
        for y = 0, Chunk.Dimensions.Y - 1 do
            for z = 0, Chunk.Dimensions.Z - 1 do
                local localCoordinates = Integer3.new(x, y, z)
                local voxel = chunk:GetVoxel(localCoordinates)
                if voxel.Id == 0 then continue end
                local surroundingVoxels = World.GetNeighbouringVoxels(chunk:ToGlobalCoordinates(localCoordinates))
                local exposedToAir = false
                for _, neighbourVoxel in surroundingVoxels do
                    if neighbourVoxel.Id ~= 0 then continue end
                    exposedToAir = true
                    break
                end
                if not exposedToAir then continue end
                Renderer.RenderVoxel(chunk, localCoordinates, voxel)
            end
        end
    end
end

function Renderer.ReleaseChunk(chunk: Chunk.Chunk)
    for _, voxelPart in chunk.PartFolder:GetChildren() do
        voxelPart:Destroy()
    end
end

function Renderer.RenderAround(centerChunkCoordinates: Integer3.Integer3, radius: number)
    for x = -radius, radius-1 do
        for y = -radius, radius-1 do
            for z = -radius, radius-1 do
                local chunkCoordinates = centerChunkCoordinates + Integer3.new(x, y, z)
                local chunk = World.GetChunk(chunkCoordinates) or ChunkGenerator.GenerateChunk(chunkCoordinates)
                Renderer.RenderChunk(chunk)
                task.wait()
            end
        end
    end
end

return Renderer