
module GameOfLife
using Plots

mutable struct Life
    current_frame::Matrix{Int}
    next_frame::Matrix{Int}
end

function count_neighbors(cf::Matrix{Int}, x::Int, y::Int)
    n, m = size(cf)
    count = 0
    for i in -1:1
        for j in -1:1
            if i == 0 && j == 0
                continue
            end
            nx, ny = x + i, y + j
            if 1 <= nx <= n && 1 <= ny <= m
                count += cf[nx, ny]
            end
        end
    end
    return count
end

function step!(state::Life)
    curr = state.current_frame
    next = state.next_frame
    next .= curr
    n, m = size(curr)
    for i in 1:n
        for j in 1:m
            neighbors = count_neighbors(curr, i, j)
            if curr[i,j] == 1
                if neighbors < 2 || neighbors > 3
                    next[i,j] = 0
                end
            else
                if neighbors == 3
                    next[i,j] = 1
                end
            end
        end
    end
    curr .= next
    return nothing
end

function (@main)(ARGS)
    n = 30
    m = 30
    init = rand(0:1, n, m)

    game = Life(init, zeros(n, m))

    anim = @animate for time = 1:100
        step!(game)
        cr = game.current_frame
        heatmap(cr)
    end
    gif(anim, "life.gif", fps = 10)
end

export main

end

using .GameOfLife
GameOfLife.main("")
