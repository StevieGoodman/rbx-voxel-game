local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Integer3Type = require(ReplicatedStorage.Classes.Integer3)

local Integer3 = {
    DisplayName = "Integer3",
}

function Integer3.Default()
    return "0, 0, 0"
end

function Integer3.Transform(rawText: string, _: Player)
    rawText = string.gsub(rawText, "%s+", "")
    local x, y, z = table.unpack(string.split(rawText, ","))
    x, y, z = tonumber(x), tonumber(y), tonumber(z)
    return {
        X = x,
        Y = y,
        Z = z,
    }
end

function Integer3.Validate(value)
    local valid = value.Z ~= nil and value.Y ~= nil and value.X ~= nil
    return
        if valid then true
        else false, `Invalid coordinates provided.`
end

function Integer3.Parse(value)
    return Integer3Type.new(value.X, value.Y, value.Z)
end

return function(registry)
    registry:RegisterType("integer3", Integer3)
end