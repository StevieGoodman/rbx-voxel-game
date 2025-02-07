local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Integer3 = require(ReplicatedStorage.Classes.Integer3)

export type Table3 = {
    new: (size: Integer3.Integer3) -> Table3,
    Get: (location: Integer3.Integer3) -> any?,
    Set: (location: Integer3.Integer3, value: any) -> (),
}

local Table3 = {}
Table3.__index = Table3

function Table3.new(dimensions: Integer3.Integer3, defaultValue: any?): Table3
    local table3 = {
        Dimensions = dimensions,
        _data = table.create(dimensions.X * dimensions.Y * dimensions.Z, defaultValue),
    }
    setmetatable(table3, Table3)
    return table3
end

function Table3:GetIndex(location: Integer3.Integer3): number
    for _, axis in {"X", "Y", "Z"} do
        local coordinate = location[axis]
        assert(coordinate >= 0, `The {axis} coordinate must be greater than or equal to 0`)
        assert(coordinate < self.Dimensions[axis], `The {axis} coordinate must be less than the dimensions of the table ({self.Dimensions[axis]})`)
    end
    local xOffset = location.X
    local zOffset = location.Z * self.Dimensions.X
    local yOffset = location.Y * self.Dimensions.X * self.Dimensions.Z
    return xOffset + zOffset + yOffset
end

function Table3:Get(location: Integer3.Integer3): any
    local index = self:GetIndex(location)
    return self._data[index]
end

function Table3:Set(location: Integer3.Integer3, value: any)
    local index = self:GetIndex(location)
    self._data[index] = value
end

function Table3:Fill(value: any)
    self._data = table.create(self.Dimensions.X * self.Dimensions.Y * self.Dimensions.Z, value)
end

function Table3:Destroy()
    self._data = nil
end

function Table3:__iter()
    local index = 0
    return function()
        index += 1
        if index > #self._data then return end
        return self._data[index]
    end
end

return Table3