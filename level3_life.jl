
module GameOfLife
using Plots

mutable struct Life
    current_frame::Matrix{Int}
    next_frame::Matrix{Int}
end

function step!(state::Life)
    curr = state.current_frame
    next = state.next_frame

    #=
    TODO: вместо случайного шума
    реализовать один шаг алгоритма "Игра жизнь"
    =#
    for i in 1:length(curr)
        curr[i] = rand(0:1)
    end

    # Подсказка для граничных условий - тор:
    # julia> mod1(10, 30)
    # 10
    # julia> mod1(31, 30)
    # 1

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
