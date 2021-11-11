require "Model\\IField"
require "View\\Field_View"

function extended(child, parent)
    setmetatable(child, {__index = parent})
end

Field_Model = {}

extended(Field_Model, IField)

Field_Model.x = 9
Field_Model.y = 9
Field_Model.color = {"A", "B", "C", "D", "E", "F"}
Field_Model.field = {}
Field_Model.score = 0

function Field_Model:steps(step)
    for i = 0, Field_Model.x, 1 do --проверка наличия ходов
        for j = 0, Field_Model.y, 1 do
            if i - 1 >= 0 then
                if i - 3 >= 0 then
                    if
                        Field_Model.field[i][j] == Field_Model.field[i - 2][j] and
                            Field_Model.field[i][j] == Field_Model.field[i - 3][j]
                     then
                        step = step + 1
                    end
                end
                if j + 2 <= Field_Model.y then
                    if
                        Field_Model.field[i][j] == Field_Model.field[i - 1][j + 1] and
                            Field_Model.field[i][j] == Field_Model.field[i - 1][j + 2]
                     then
                        step = step + 1
                    end
                end
                if j - 2 >= 0 then
                    if
                        Field_Model.field[i][j] == Field_Model.field[i - 1][j - 1] and
                            Field_Model.field[i][j] == Field_Model.field[i - 1][j - 2]
                     then
                        step = step + 1
                    end
                end
            end
            if i + 1 <= Field_Model.x then
                if i + 3 <= Field_Model.x then
                    if
                        Field_Model.field[i][j] == Field_Model.field[i + 2][j] and
                            Field_Model.field[i][j] == Field_Model.field[i + 3][j]
                     then
                        step = step + 1
                    end
                end
                if j + 2 <= Field_Model.y then
                    if
                        Field_Model.field[i][j] == Field_Model.field[i + 1][j + 1] and
                            Field_Model.field[i][j] == Field_Model.field[i + 1][j + 2]
                     then
                        step = step + 1
                    end
                end
                if j - 2 >= 0 then
                    if
                        Field_Model.field[i][j] == Field_Model.field[i + 1][j - 1] and
                            Field_Model.field[i][j] == Field_Model.field[i + 1][j - 2]
                     then
                        step = step + 1
                    end
                end
            end
            if j - 1 >= 0 then
                if j - 3 >= 0 then
                    if
                        Field_Model.field[i][j] == Field_Model.field[i][j - 2] and
                            Field_Model.field[i][j] == Field_Model.field[i][j - 3]
                     then
                        step = step + 1
                    end
                end
                if i + 2 <= Field_Model.x then
                    if
                        Field_Model.field[i][j] == Field_Model.field[i + 1][j - 1] and
                            Field_Model.field[i][j] == Field_Model.field[i + 2][j - 1]
                     then
                        step = step + 1
                    end
                end
                if i - 2 >= 0 then
                    if
                        Field_Model.field[i][j] == Field_Model.field[i - 1][j - 1] and
                            Field_Model.field[i][j] == Field_Model.field[i - 2][j - 1]
                     then
                        step = step + 1
                    end
                end
            end
            if j + 1 <= Field_Model.y then
                if j + 3 <= Field_Model.y then
                    if
                        Field_Model.field[i][j] == Field_Model.field[i][j + 2] and
                            Field_Model.field[i][j] == Field_Model.field[i][j + 3]
                     then
                        step = step + 1
                    end
                end
                if i + 2 <= Field_Model.x then
                    if
                        Field_Model.field[i][j] == Field_Model.field[i + 1][j + 1] and
                            Field_Model.field[i][j] == Field_Model.field[i + 2][j + 1]
                     then
                        step = step + 1
                    end
                end
                if i - 2 >= 0 then
                    if
                        Field_Model.field[i][j] == Field_Model.field[i - 1][j + 1] and
                            Field_Model.field[i][j] == Field_Model.field[i - 2][j + 1]
                     then
                        step = step + 1
                    end
                end
            end
        end
    end
    return step
end

function Field_Model:search(combo)
    block1, block2, block3, block4 = 0, 0, 0, 0
    l, u, r, d = 0, 0, 0, 0
    for i = 0, 9, 1 do --вычисление рядов
        combo[i] = {}
        for j = 0, 9, 1 do
            for k = 0, 9, 1 do
                if j - k >= 0 and block1 == 0 then
                    if Field_Model.field[i][j] == Field_Model.field[i][j - k] then
                        l = l + 1
                    else
                        block1 = 1
                    end
                end
                if i - k >= 0 and block2 == 0 then
                    if Field_Model.field[i][j] == Field_Model.field[i - k][j] then
                        u = u + 1
                    else
                        block2 = 1
                    end
                end
                if j + k <= Field_Model.y and block3 == 0 then
                    if Field_Model.field[i][j] == Field_Model.field[i][j + k] then
                        r = r + 1
                    else
                        block3 = 1
                    end
                end
                if i + k <= Field_Model.x and block4 == 0 then
                    if Field_Model.field[i][j] == Field_Model.field[i + k][j] then
                        d = d + 1
                    else
                        block4 = 1
                    end
                end
            end
            combo[i][j] = {}
            combo[i][j][0] = l
            combo[i][j][1] = u
            combo[i][j][2] = r
            combo[i][j][3] = d
            block1, block2, block3, block4 = 0, 0, 0, 0
            l, u, r, d = 0, 0, 0, 0
        end
    end
end

function Field_Model:init()
    math.randomseed(os.time())
    for i = 0, Field_Model.x, 1 do
        Field_Model.field[i] = {}
        for j = 0, Field_Model.y, 1 do
            local n = math.random(#Field_Model.color)
            Field_Model.field[i][j] = Field_Model.color[n]
            if i > 1 then
                while Field_Model.field[i - 1][j] == Field_Model.field[i - 2][j] and
                    Field_Model.field[i][j] == Field_Model.field[i - 1][j] do
                    local n = math.random(#Field_Model.color)
                    Field_Model.field[i][j] = Field_Model.color[n]
                end
            end
            if j > 1 then
                while Field_Model.field[i][j - 1] == Field_Model.field[i][j - 2] and
                    Field_Model.field[i][j] == Field_Model.field[i][j - 1] do
                    local n = math.random(#Field_Model.color)
                    Field_Model.field[i][j] = Field_Model.color[n]
                end
            end
        end
    end
    Field_View:clear()
    Field_View:message("Available moves: " .. Field_Model:steps(0))
    Field_View:message("Scores: " .. Field_Model.score)
    Field_View:view()
end

function Field_Model:tick(first, y, x, m)
    math.randomseed(os.time())
    local temp
    local combo = {}
    local comb = 1
    local down = 0
    while comb == 1 do
        Field_Model:search(combo)
        comb = 0
        for i = 0, Field_Model.x, 1 do --удаление правильных рядов
            for j = 0, Field_Model.y, 1 do
                for k = 0, 1, 1 do
                    if combo[i][j][k] > 1 and combo[i][j][k + 2] > 1 or combo[i][j][k] > 2 or combo[i][j][k + 2] > 2 then
                        Field_Model.field[i][j] = " "
                        comb = 1
                        Field_Model.score = Field_Model.score + 10
                    end
                end
            end
        end
        if comb == 0 and first == 1 then --если первый ход ничего не дал, то вернуть элемент
            Field_View:message("Wrong move")
            Field_Model:move(x, y, m)
            return
        else
            first = 0
        end
        down = 0
        for i = Field_Model.x, 0, -1 do --смещение вниз элементов
            for j = Field_Model.y, 0, -1 do
                if Field_Model.field[i][j] == " " then
                    for k = i, 0, -1 do
                        if k >= 0 and Field_Model.field[k][j] == " " then
                            down = down + 1
                        end
                    end
                    for k = 0, down - 1, 1 do
                        if i - k - down >= 0 then
                            Field_Model.field[i - k][j], Field_Model.field[i - k - down][j] =
                                Field_Model.field[i - k - down][j],
                                Field_Model.field[i - k][j]
                        else
                            if i - k >= 0 then
                                local n = math.random(#Field_Model.color)
                                Field_Model.field[i - k][j] = Field_Model.color[n]
                            end
                        end
                    end
                    down = 0
                end
            end
        end
    end
end

function Field_Model:move(y, x, m)
    if x >= 0 and y >= 0 and y <= Field_Model.x and x <= Field_Model.y then
        local temp = Field_Model.field[x][y]
        if m == "u" and x - 1 >= 0 then
            Field_Model.field[x][y] = Field_Model.field[x - 1][y]
            Field_Model.field[x - 1][y] = temp
        end
        if m == "d" and x + 1 <= Field_Model.x then
            Field_Model.field[x][y] = Field_Model.field[x + 1][y]
            Field_Model.field[x + 1][y] = temp
        end
        if m == "l" and y - 1 >= 0 then
            Field_Model.field[x][y] = Field_Model.field[x][y - 1]
            Field_Model.field[x][y - 1] = temp
        end
        if m == "r" and y + 1 <= Field_Model.y then
            Field_Model.field[x][y] = Field_Model.field[x][y + 1]
            Field_Model.field[x][y + 1] = temp
        end
    end
end

function Field_Model:mix()
    mixed = 0
    Field_View:clear()
    Field_View:message("Available moves: " .. Field_Model:steps(0))
    Field_View:message("Scores: " .. Field_Model.score)
    if Field_Model:steps(0) > 0 then
        return
    else
        local mfield = {}
        for i = 0, Field_Model.x, 1 do --копирование поля
            mfield[i] = {}
            for j = 0, Field_Model.y, 1 do
                mfield[i][j] = Field_Model.field[i][j]
                Field_Model.field[i][j] = " "
            end
        end
        math.randomseed(os.time()) --заполнение поля
        for i = 0, Field_Model.x, 1 do
            for j = 0, Field_Model.y, 1 do
                step = 0
                while step == 0 do
                    local a, b = math.random(0, Field_Model.x), math.random(0, Field_Model.y)
                    if Field_Model.field[a][b] == " " then
                        Field_Model.field[a][b] = mfield[i][j]
                        step = 1
                    end
                end
            end
        end
        local combo = {}
        local comb = 1
        Field_Model:search()
        if comb == 1 then
            Field_Model:mix()
        end
        Field_View:message("The field is mixed")
    end
end

function Field_Model:dump()
    Field_View:view()
end
