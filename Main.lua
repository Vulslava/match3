require "Model\\FieldModel"
local view = FieldView:new()
local model = FieldModel:new(view)
view:setModel(model)
model:Init()
model:Dump()
while 1 do
    local command = io.read()
    local c = command:lower()
    if c == "q" then
        break
    end
    if c == "m" then
        command = io.read()
        local _, _, x, y, m = string.find(command, "(%d+)[^%d]+(%d+)[^%a]+(%D)")
        if x ~= nil and y ~= nil and m ~= nil then
            x, y, m = tonumber(x), tonumber(y), m:lower()
            if m == "l" or m == "r" or m == "u" or m == "d" then
                model:Move(x, y, m)
                model:Tick(1, c, x, y, m)
            end
        end
    end
    model:Mix()
    model:Dump()
end
