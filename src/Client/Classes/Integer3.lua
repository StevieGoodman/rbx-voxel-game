export type Integer3 = {
    X: number,
    Y: number,
    Z: number,

    new: (x: number, y: number, z: number) -> Integer3,
    Forward: () -> Integer3,
    Back: () -> Integer3,
    Left: () -> Integer3,
    Right: () -> Integer3,
    Up: () -> Integer3,
    Down: () -> Integer3,
    ToVector3: (Integer3) -> Vector3
}

local Integer3 = {}
Integer3.__index = Integer3

function Integer3.new(x: number, y: number, z: number)
    local integer3 = {
        X = math.round(x),
        Y = math.round(y),
        Z = math.round(z)
    }
    setmetatable(integer3, Integer3)
    return integer3
end

function Integer3.Forward()
    return Integer3.new(0, 0, -1)
end

function Integer3.Back()
    return -Integer3.Forward()
end

function Integer3.Up()
    return Integer3.new(0, 1, 0)
end

function Integer3.Down()
    return -Integer3.Up()
end

function Integer3.Right()
    return Integer3.new(1, 0, 0)
end

function Integer3.Left()
    return -Integer3.Right()
end

function Integer3:ToVector3()
    return Vector3.new(self.X, self.Y, self.Z)
end

function Integer3:__unm()
    return Integer3.new(-self.X, -self.Y, -self.Z)
end

function Integer3:__add(other: Integer3 | number)
    if typeof(other) == "number" then
        other = Integer3.new(other, other, other)
    end
    return Integer3.new(self.X + other.X, self.Y + other.Y, self.Z + other.Z)
end

function Integer3:__sub(other: Integer3 | number)
    return self + -other
end

function Integer3:__mul(other: Integer3 | number)
    if typeof(other) == "number" then
        other = Integer3.new(other, other, other)
    end
    return Integer3.new(self.X * other.X, self.Y * other.Y, self.Z * other.Z)
end

function Integer3:__div(other: Integer3 | number)
    return self * (1 / other)
end

function Integer3:__idiv(other: Integer3 | number)
    if typeof(other) == "number" then
        other = Integer3.new(other, other, other)
    end
    return Integer3.new(
        math.floor(self.X / other.X),
        math.floor(self.Y / other.Y),
        math.floor(self.Z / other.Z)
    )
end

function Integer3:__eq(other: Integer3)
    if self.X == nil or self.Y == nil or self.Z == nil then return false end
    return self.X == other.X and self.Y == other.Y and self.Z == other.Z
end

function Integer3:__tostring()
    return `({self.X}, {self.Y}, {self.Z})`
end

return Integer3