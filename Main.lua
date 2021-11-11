require "Model\\Field_Model"
Field_Model:init()
while 1 do
    local command = io.read()
    if command:lower() == "q" then
        break
    end
    if command:len() > 4 then
        local c = string.sub(command, 1, 1):lower()
        local _, _, x, y = string.find(command, "(%d+)[^%d]+(%d+)")
        local m = " "
        for i = 0, command:len(), 1 do
            m = string.sub(command, i, i):lower()
            if m == "l" or m == "r" or m == "u" or m == "d" then
                break
            end
        end
        x, y = tonumber(x), tonumber(y)
        if x ~= nil and y ~= nil then
            if c == "m" then
                Field_Model:move(x, y, m)
            end
            Field_Model:tick(1, x, y, m)
        end
        Field_Model:mix()
        Field_Model:dump()
    end
end
