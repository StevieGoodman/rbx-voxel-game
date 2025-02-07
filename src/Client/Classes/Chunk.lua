local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Trove = require(ReplicatedStorage.Packages.Trove)
local Integer3 = require(ReplicatedStorage.Classes.Integer3)
local Table3 = require(ReplicatedStorage.Classes.Table3)
local Voxel = require(ReplicatedStorage.Classes.Voxel)

export type Chunk = {
    Coordinates: Integer3.Integer3,
    VoxelData: {number},

    GetVoxel: (Chunk, localCoordinates: Integer3.Integer3) -> (),
    SetVoxel: (Chunk, localCoordinates: Integer3.Integer3, number) -> (),
    ToLocalCoordinates: (Chunk, globalCoordinates: Integer3.Integer3) -> Integer3.Integer3,
    ToGlobalCoordinates: (Chunk, localCoordinates: Integer3.Integer3) -> Integer3.Integer3,
    Destroy: (Chunk) -> ()
}

local Chunk = {}

Chunk.Dimensions = Integer3.new(16, 16, 16)

function Chunk.new(chunkCoordinates: Integer3.Integer3): Chunk
    local chunk = {
        Coordinates = chunkCoordinates,
        VoxelData = Table3.new(Chunk.Dimensions, 1),
        _trove = Trove.new()
    }
    chunk.PartFolder = Instance.new("Folder")
    chunk.PartFolder.Name = `Chunk {chunkCoordinates}`
    chunk.PartFolder.Parent = workspace
    chunk._trove:Add(chunk.PartFolder)

    setmetatable(chunk, {__index = Chunk})
    return chunk
end

function Chunk:GetVoxel(localCoordinates: Integer3.Integer3): Voxel.Voxel?
    local voxelId = self.VoxelData:Get(localCoordinates)
    return
        if voxelId == nil
        then nil
        else Voxel.Types[voxelId]
end

function Chunk:SetVoxel(localCoordinates: Integer3.Integer3, voxelId: number)
    self.VoxelData:Set(localCoordinates, voxelId)
end

function Chunk:ToLocalCoordinates(globalCoordinates: Integer3.Integer3): Integer3.Integer3
    return globalCoordinates % Chunk.Dimensions
end

function Chunk:ToGlobalCoordinates(localCoordinates: Integer3.Integer3): Integer3.Integer3
    return (Chunk.Dimensions * self.Coordinates) + localCoordinates
end

function Chunk:Destroy()
    self._trove:Destroy()
end

return Chunk