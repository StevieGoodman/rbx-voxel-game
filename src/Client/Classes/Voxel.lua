local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Integer3 = require(ReplicatedStorage.Classes.Integer3)

export type Voxel = {
    Id: number,
    Name: string,
    Color: Color3?,
}

local Voxel = {}

Voxel.Dimensions = Integer3.new(4, 4, 4)

Voxel.Types = {
    [0] = {
        Id = 0,
        Name = "Air",
    },
    [1] = {
        Id = 1,
        Name = "Stone",
        Color = BrickColor.new("Medium stone grey").Color,
    },
    [2] = {
        Id = 2,
        Name = "Dirt",
        Color = BrickColor.new("Brown").Color,
    },
    [3] = {
        Id = 3,
        Name = "Grass",
        Color = BrickColor.new("Bright green").Color,
    }
}

return Voxel