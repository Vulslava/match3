require "Model\\IField"

FieldView = {}

function FieldView:new()
    local obj = {}

    function obj:Clear()
        os.execute("cls")
    end

    function obj:Message(text)
        if text:len() > 0 then
            print(text .. "\n")
        end
    end

    function obj:setModel(model)
        self.model = model
    end

    function obj:View()
        io.write("   ")
        for i = 0, self.model.size[1], 1 do
            io.write(i .. " ")
        end
        io.write("\n   -")
        for i = 0, self.model.size[1] - 1, 1 do
            io.write("--")
        end
        io.write("\n")
        for i = 0, self.model.size[1], 1 do
            io.write(i .. "|")
            for j = 0, self.model.size[2], 1 do
                io.write(" " .. self.model.field[i][j])
            end
            io.write("\n\n")
        end
    end

    setmetatable(obj, self)
    self.__index = self
    return obj
end
