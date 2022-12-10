local read_lines
local get_tail_positions
local parse_movement
local is_tail_around
local contains
local length
local get_table_filled
local move_head
local move_tail
local move_coordinate

function read_lines()
    file = io.open("input.txt")
    return file:lines()
end

function get_tail_positions(lines, n)
    local positions = {"0 0"}
    local rope_x = get_table_filled(n + 1, 0)
    local rope_y = get_table_filled(n + 1, 0)

    for line in lines do
        local movement, count = parse_movement(line)

        for _ = 1, count, 1 do
            for idx = 1, n + 1, 1 do
                if idx == 1 then
                    rope_x[1], rope_y[1] = move_head(rope_x[1], rope_y[1], movement)
                elseif not is_tail_around(rope_x[idx - 1], rope_y[idx - 1], rope_x[idx], rope_y[idx]) then
                    rope_x[idx], rope_y[idx] = move_tail(rope_x[idx - 1], rope_y[idx - 1], rope_x[idx], rope_y[idx])
                end
            end

            local position = string.format("%d %d", rope_x[n + 1], rope_y[n + 1])
            if not contains(positions, position) then
                table.insert(positions, position)
            end
        end
    end

    return positions
end

function move_head(x, y, movement)
    if movement == "U" then return x + 0, y + 1 end
    if movement == "R" then return x + 1, y + 0 end
    if movement == "D" then return x + 0, y - 1 end
    if movement == "L" then return x - 1, y + 0 end
    return x, y
end

function move_tail(px, py, x, y)
    return move_coordinate(px, x), move_coordinate(py, y)
end

function move_coordinate(prev, current)
    if prev > current then return current + 1 end
    if prev < current then return current - 1 end
    return current
end

function parse_movement(line)
    local movement, count = "", 0

    for match in string.gmatch(line, "[^%s]+") do
        if movement == "" then
            movement = match
        else
            count = tonumber(match, 10)
        end
    end

    return movement, count
end

function is_tail_around(hx, hy, tx, ty)
    for _, mov_x in pairs({-1, 0, 1}) do
        for _, mov_y in pairs({-1, 0, 1}) do
            if tx + mov_x == hx and ty + mov_y == hy then
                return true
            end
        end
    end

    return false
end

function contains(tbl, item)
    for _, tbl_item in pairs(tbl) do
        if tbl_item == item then
            return true
        end
    end

    return false
end

function length(tbl)
    local count = 0

    for _ in pairs(tbl) do
        count = count + 1
    end

    return count
end

function get_table_filled(n, value)
    local tbl = {}

    for _ = 1, n, 1 do
        table.insert(tbl, value)
    end

    return tbl
end

print(length(get_tail_positions(read_lines(), 1)))
print(length(get_tail_positions(read_lines(), 9)))

-- ! Solution A: 5735
-- ! Solution B: 2478
