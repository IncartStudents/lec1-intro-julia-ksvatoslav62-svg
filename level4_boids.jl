module Boids
using Plots


mutable struct WorldState
    boid::Tuple{Float64, Float64}
    height::Float64
    width::Float64
    function WorldState(n_boids, width, height)
        # TODO: добавить случайные позиции для n_boids птичек вместо одной
        
        new((width/2, height/2), width, height)
    end
end

function update!(state::WorldState)
    state.boid = state.boid .+ 0.1
    # TODO: реализация уравнения движения птичек

    return nothing
end

function (@main)(ARGS)
    w = 30
    h = 30
    n_boids = 10

    state = WorldState(n_boids, w, h)

    anim = @animate for time = 1:100
        update!(state)
        boids = [state.boid]
        scatter(boids, xlim = (0, state.width), ylim = (0, state.height))
    end
    gif(anim, "boids.gif", fps = 10)
end

export main

end

using .Boids
Boids.main("")
