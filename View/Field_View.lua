require "Model\\IField"

function extended(child, parent)
    setmetatable(child, {__index = parent})
end

Field_View = {}

extended(Field_View, IField)

function Field_View:clear()
    os.execute("cls")
end

function Field_View:message(text)
    if text:len() > 0 then
        print(text .. "\n")
    end
end

function Field_View:view()
    io.write("   ")
    for i = 0, Field_Model.x, 1 do
        io.write(i .. " ")
    end
    io.write("\n   -")
    for i = 0, Field_Model.x - 1, 1 do
        io.write("--")
    end
    io.write("\n")
    for i = 0, Field_Model.x, 1 do
        io.write(i .. "|")
        for j = 0, Field_Model.y, 1 do
            io.write(" " .. Field_Model.field[i][j])
        end
        io.write("\n\n")
    end
end
