require "Model\\IField"
require "View\\FieldView"

function Extended(child, parent)
    setmetatable(child, {__index = parent})
end

FieldModel = {}

Extended(FieldModel, IField)

function FieldModel:new(view)
    local obj = {}
    obj.size = {9, 9}
    obj.color = {"A", "B", "C", "D", "E", "F"}
    obj.field = {}
    obj.score = 0
    obj.view = view

    function obj:SetColor(x, y)
        local n = math.random(#self.color)
        self.field[x][y] = self.color[n]
    end

    function obj:CreateCombo()
        local combo = {}
        for x = 0, self.size[1], 1 do
            combo[x] = {}
            for y = 0, self.size[2], 1 do
                combo[x][y] = {}
            end
        end
        return combo
    end

    function obj:SwapCells(x, y, calculate, vertical)
        if vertical then
            self.field[x][y], self.field[calculate][y] = self.field[calculate][y], self.field[x][y]
        else
            self.field[x][y], self.field[x][calculate] = self.field[x][calculate], self.field[x][y]
        end
    end

    function obj:ConditionClone(vertical, x, y, dir)
        local countClone = 0
        if vertical then
            local newX = x + dir
            while newX >= 0 and newX <= self.size[1] do
                if self.field[x][y] == self.field[newX][y] then
                    countClone = countClone + 1
                else
                    break
                end
                newX = newX + dir
            end
        else
            local newY = y + dir
            while newY >= 0 and newY <= self.size[2] do
                if self.field[x][y] == self.field[x][newY] then
                    countClone = countClone + 1
                else
                    break
                end
                newY = newY + dir
            end
        end
        return countClone
    end

    function obj:ConditionStep(step, x, y, move)
        local countClone = {0, 0, 0, 0}
        local newX, newY
        local switch = {
            [1] = function(countClone)
                newX = x - 1
                if newX >= 0 then
                    self.field[x][y], self.field[newX][y] = self.field[newX][y], self.field[x][y]
                    countClone[1] = countClone[1] + self:ConditionClone(true, newX, y, -1)
                    countClone[2] = countClone[2] + self:ConditionClone(false, newX, y, -1)
                    countClone[3] = countClone[3] + self:ConditionClone(false, newX, y, 1)
                    countClone[4] =
                        countClone[4] + self:ConditionClone(false, newX, y, -1) + self:ConditionClone(false, newX, y, 1)
                    self.field[x][y], self.field[newX][y] = self.field[newX][y], self.field[x][y]
                end
                return countClone
            end,
            [2] = function(countClone)
                newX = x + 1
                if newX <= self.size[1] then
                    self.field[x][y], self.field[newX][y] = self.field[newX][y], self.field[x][y]
                    countClone[1] = countClone[1] + self:ConditionClone(true, newX, y, 1)
                    countClone[2] = countClone[2] + self:ConditionClone(false, newX, y, -1)
                    countClone[3] = countClone[3] + self:ConditionClone(false, newX, y, 1)
                    countClone[4] =
                        countClone[4] + self:ConditionClone(false, newX, y, -1) + self:ConditionClone(false, newX, y, 1)
                    self.field[x][y], self.field[newX][y] = self.field[newX][y], self.field[x][y]
                end
                return countClone
            end,
            [3] = function(countClone)
                newY = y - 1
                if newY >= 0 then
                    self.field[x][y], self.field[x][newY] = self.field[x][newY], self.field[x][y]
                    countClone[1] = countClone[1] + self:ConditionClone(false, x, newY, -1)
                    countClone[2] = countClone[2] + self:ConditionClone(true, x, newY, -1)
                    countClone[3] = countClone[3] + self:ConditionClone(true, x, newY, 1)
                    countClone[4] =
                        countClone[4] + self:ConditionClone(true, x, newY, -1) + self:ConditionClone(true, x, newY, 1)
                    self.field[x][y], self.field[x][newY] = self.field[x][newY], self.field[x][y]
                end
                return countClone
            end,
            [4] = function(countClone)
                newY = y + 1
                if newY <= self.size[2] then
                    self.field[x][y], self.field[x][newY] = self.field[x][newY], self.field[x][y]
                    countClone[1] = countClone[1] + self:ConditionClone(false, x, newY, 1)
                    countClone[2] = countClone[2] + self:ConditionClone(true, x, newY, -1)
                    countClone[3] = countClone[3] + self:ConditionClone(true, x, newY, 1)
                    countClone[4] =
                        countClone[4] + self:ConditionClone(true, x, newY, -1) + self:ConditionClone(true, x, newY, 1)
                    self.field[x][y], self.field[x][newY] = self.field[x][newY], self.field[x][y]
                end
                return countClone
            end
        }
        local funcSwitch = switch[move]
        if (funcSwitch) then
            countClone = funcSwitch(countClone)
        end
        for index = 1, 4, 1 do
            if countClone[index] + 1 > 2 then
                step = step + 1
                break
            end
        end
        return step
    end

    function obj:CountSteps()
        local step = 0
        for x = 0, self.size[1], 1 do --проверка наличия ходов
            for y = 0, self.size[2], 1 do
                for index = 1, 4, 1 do
                    step = self:ConditionStep(step, x, y, index)
                end
            end
        end
        return step
    end

    function obj:ConditionSearch(x, y, calculate, block, direction, conditionVertical)
        if conditionVertical then
            if self.field[x][y] == self.field[calculate][y] then
                direction = direction + 1
            else
                block = 1
            end
        else
            if self.field[x][y] == self.field[x][calculate] then
                direction = direction + 1
            else
                block = 1
            end
        end
        return block, direction
    end

    function obj:Search(combo)
        local block, direction = {0, 0, 0, 0}, {0, 0, 0, 0}
        local dk = 0
        if self.size[1] > self.size[2] then
            dk = self.size[1]
        else
            dk = self.size[2]
        end
        for x = 0, self.size[1], 1 do --вычисление рядов
            for y = 0, self.size[2], 1 do
                for k = 0, dk, 1 do
                    if y - k >= 0 and block[1] == 0 then
                        block[1], direction[1] = self:ConditionSearch(x, y, y - k, block[1], direction[1], false)
                    end
                    if x - k >= 0 and block[2] == 0 then
                        block[2], direction[2] = self:ConditionSearch(x, y, x - k, block[2], direction[2], true)
                    end
                    if y + k <= self.size[2] and block[3] == 0 then
                        block[3], direction[3] = self:ConditionSearch(x, y, y + k, block[3], direction[3], false)
                    end
                    if x + k <= self.size[1] and block[4] == 0 then
                        block[4], direction[4] = self:ConditionSearch(x, y, x + k, block[4], direction[4], true)
                    end
                end
                for dir = 1, 4, 1 do
                    combo[x][y][dir] = direction[dir]
                end
                block, direction = {0, 0, 0, 0}, {0, 0, 0, 0}
            end
        end
        return combo
    end

    function obj:AvailableCombination(combo, deleteConfirm)
        local availableCombo = false
        for x = 0, self.size[1], 1 do
            for y = 0, self.size[2], 1 do
                for k = 1, 2, 1 do
                    if combo[x][y][k] > 1 and combo[x][y][k + 2] > 1 or combo[x][y][k] > 2 or combo[x][y][k + 2] > 2 then
                        availableCombo = true
                        if deleteConfirm then
                            self.field[x][y] = " "
                            self.score = self.score + 10
                        else
                            return availableCombo
                        end
                    end
                end
            end
        end
        return availableCombo
    end

    function obj:Init()
        _ = math.randomseed(os.time())
        for x = 0, self.size[1], 1 do
            self.field[x] = {}
            for y = 0, self.size[2], 1 do
                self:SetColor(x, y)
                if x > 1 then
                    while self.field[x - 1][y] == self.field[x - 2][y] and self.field[x][y] == self.field[x - 1][y] do
                        self:SetColor(x, y)
                    end
                end
                if y > 1 then
                    while self.field[x][y - 1] == self.field[x][y - 2] and self.field[x][y] == self.field[x][y - 1] do
                        self:SetColor(x, y)
                    end
                end
            end
        end
    end

    function obj:Tick(first, command, x, y, move)
        _ = math.randomseed(os.time())
        local combo = self:CreateCombo()
        local availableCombo = true
        local down = 0
        while availableCombo do
            availableCombo = obj:AvailableCombination(self:Search(combo), true) --удаление правильных рядов
            if availableCombo == false and first == 1 and command == "m" then --если первый ход ничего не дал, то вернуть элемент
                view:Message("Wrong move")
                self:Move(x, y, move)
                return
            else
                first = 0
            end
            down = 0
            for x = self.size[1], 0, -1 do --смещение вниз элементов
                for y = self.size[2], 0, -1 do
                    if self.field[x][y] == " " then
                        for k = x, 0, -1 do
                            if k >= 0 and self.field[k][y] == " " then
                                down = down + 1
                            end
                        end
                        for k = 0, down - 1, 1 do
                            if x - k - down >= 0 then
                                self:SwapCells(x - k, y, x - k - down, true)
                            else
                                if x - k >= 0 then
                                    self:SetColor(x - k, y)
                                end
                            end
                        end
                        down = 0
                    end
                end
            end
        end
    end

    function obj:Move(y, x, m)
        if x >= 0 and y >= 0 and x <= self.size[1] and y <= self.size[2] then
            if m == "u" and x - 1 >= 0 then
                self:SwapCells(x, y, x - 1, true)
            end
            if m == "d" and x + 1 <= self.size[1] then
                self:SwapCells(x, y, x + 1, true)
            end
            if m == "l" and y - 1 >= 0 then
                self:SwapCells(x, y, y - 1, false)
            end
            if m == "r" and y + 1 <= self.size[2] then
                self:SwapCells(x, y, y + 1, false)
            end
        end
    end

    function obj:Mix()
        if self:CountSteps() > 0 then
            return
        else
            local step = 0
            local mfield = {}
            for x = 0, self.size[1], 1 do --копирование поля
                mfield[x] = {}
                for y = 0, self.size[2], 1 do
                    mfield[x][y] = self.field[x][y]
                    self.field[x][y] = " "
                end
            end
            math.randomseed(os.time()) --заполнение поля
            for x = 0, self.size[1], 1 do
                for y = 0, self.size[2], 1 do
                    step = 0
                    while step == 0 do
                        local a, b = math.random(0, self.size[1]), math.random(0, self.size[2])
                        if self.field[a][b] == " " then
                            self.field[a][b] = mfield[x][y]
                            step = 1
                        end
                    end
                end
            end
            local combo = self:CreateCombo()
            if obj:AvailableCombination(self:Search(combo), false) then
                self:Mix()
            end
            view:Message("The field is mixed")
        end
    end

    function obj:Dump()
        view:Clear()
        view:Message("Available moves: " .. self:CountSteps())
        view:Message("Scores: " .. self.score)
        view:View()
    end

    setmetatable(obj, self)
    self.__index = self
    return obj
end
