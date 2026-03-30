module Boids
using Plots
mutable struct Boid
    pos::NTuple{2, Float64}
    vel::NTuple{2, Float64}
    vision_radius::Float64
    vision_angle::Float64
    mass::Float64
end

mutable struct WorldState
    boids::Vector{Boid}
    height::Float64
    width::Float64
    max_speed::Float64
    # Коэфиценты правил для мира 
    k_sep::Float64 # Коэфицент разделения
    k_align::Float64 # Коэфиунь выравнивания
    k_coh::Float64 # Коэфицент стремления к массам
    k_drag::Float64 # Сопротивление среды 
    dt::Float64
    function WorldState(n_boids, height, width;
         max_speed = 6.0, vision_radius=4.0, vision_angle=2*pi/3, k_sep = 1.0, k_align = 1, k_coh = 1, k_drag = 0.5, dt = 0.05)
        # TODO: добавить случайные позиции для n_boids птичек вместо одной
        boids = [Boid((rand()*width, rand()*height), 
        (rand()*2-1, rand()*2-1), vision_radius, vision_angle, rand()*0.5 + 0.5)
        for _ in 1:n_boids]
        
        new(boids, height, width, max_speed, k_sep, k_align, k_coh, k_drag, dt)
    end
end

struct ScalarField_temp{T<:AbstractFloat} <: AbstractArray{T,2}
    data::Vector{T}
    rows::Int
    cols::Int
end
Base.size(field::ScalarField_temp) = (field.rows, field.cols)
function Base.getindex(field::ScalarField_temp, i::Int, j::Int)
    @boundscheck checkbounds(field, i, j)
    index = (j-1)*field.rows + i
    return field.data[index]
end
function Base.setindex!(field::ScalarField_temp, value::Float64, i::Int, j::Int)
    @boundscheck checkbounds(field, i, j)
    index = (j-1)*field.rows + i
    field.data[index] = value
end
function ScalarField_temp(state::WorldState, n::Int64) # n-номер шага на котором находимся
    cols = Int(round(state.width/(state.dt*state.max_speed/sqrt(2))))*10
    rows = Int(round(state.height/(state.dt*state.max_speed/sqrt(2))))*10
    data = Vector{Float64}(undef, rows * cols)
    field_temp = ScalarField_temp{Float64}(data, rows, cols)
    for i in 1:field_temp.rows
        for j in 1:field_temp.cols
            value = (i^2 + j^2)/(sin(i*j) < 1e-6 ? 1e-6 : sin(i*j)) * cos(n*state.dt/1000)
            field_temp[i, j]  = value
        end
    end
    return field_temp
end

function d_grad(state::WorldState, field::ScalarField_temp)
    n = length(state.boids)
    vel_temps = Vector{NTuple{2, Float64}}(undef, n)
    for i in 1:n
        berd_i = state.boids[i]
        pos = (Int(round(berd_i.pos[1]/(state.dt*state.max_speed/sqrt(2))))*10, Int(round(berd_i.pos[2]/(state.dt*state.max_speed/sqrt(2))))*10)
        if pos[1] < 1 || pos[1] >= field.cols || pos[2] < 1 || pos[2] >= field.rows
            vel_temps[i] = (0.0, 0.0)
            continue
        end
        temp = field[pos[1], pos[2]]
        dtemp_x = ( field[pos[1]+1, pos[2]] - temp)
        dtemp_y = ( field[pos[1], pos[2]+1] - temp)
        len = sqrt(dtemp_x^2 + dtemp_y^2)
        if len > 1e-6
            vel_temps[i] = (dtemp_x/len, dtemp_y/len)
        else
            vel_temps[i] = (0.0, 0.0)
        end
    end
    return vel_temps
end

function update!(state::WorldState, g::Int)
    # TODO: реализация уравнения движения птичек
    field = ScalarField_temp(state, g)
    n = length(state.boids)
    vel_temps = d_grad(state, field)
    
    forses = [(0.0, 0.0) for _ in 1:n]

    for i in 1:n
        berd_i = state.boids[i]
        mid_pos_sum = (0.0, 0.0)
        good_mass_sum = 0.0
        bad_vel_sum = (0.0, 0.0)
        good_vel_sum = (0.0, 0.0)
        bad_berd = 0
        good_beard = 0
        for j in 1:n
            if i == j
                continue
            end
            berd_j = state.boids[j]
            dx = berd_j.pos[1] - berd_i.pos[1]
            dy = berd_j.pos[2] - berd_i.pos[2]
            dist = sqrt(dx^2 + dy^2)
            if dist < berd_i.vision_radius
                if dist < berd_i.vision_radius*0.2
                    bad_vel_sum = (bad_vel_sum[1] + berd_j.vel[1], bad_vel_sum[2] + berd_j.vel[2])
                    bad_berd+=1
                else
                    good_vel_sum = (good_vel_sum[1] + berd_j.vel[1], good_vel_sum[2] + berd_j.vel[2])
                    mid_pos_sum = (mid_pos_sum[1]+berd_j.pos[1]*berd_j.mass, mid_pos_sum[2]+berd_j.pos[2]*berd_j.mass)
                    good_mass_sum += berd_j.mass
                    good_beard+=1
                end
            end
        end
    if bad_berd > 0 
        avg_vel_bad = (bad_vel_sum[1]/bad_berd, bad_vel_sum[2]/bad_berd)
        perp = (-avg_vel_bad[2], avg_vel_bad[1])
        len_perp = sqrt(perp[1]^2 + perp[2]^2)
        if len_perp > 1e-6
            perp = (perp[1]/len_perp, perp[2]/len_perp)
        else
            perp = (0.0, 0.0)
        end
        F_sep = (state.k_sep*perp[1]*(bad_berd^2), state.k_sep*perp[2]*(bad_berd^2))
    else
        F_sep = (0.0, 0.0)
    end

    if good_beard > 0
        good_vel_mid = (good_vel_sum[1]/good_beard, good_vel_sum[2]/good_beard)
        diff = (good_vel_mid[1] - berd_i.vel[1], good_vel_mid[2] - berd_i.vel[2])
        F_align = (state.k_align*diff[1], state.k_align*diff[2])
    else
        F_align = (0.0, 0.0)
    end

    if good_beard > 0
        center_mass = (mid_pos_sum[1]/good_mass_sum, mid_pos_sum[2]/good_mass_sum)
        to_center = (center_mass[1] - berd_i.pos[1], center_mass[2] - berd_i.pos[2])
        F_coh = (state.k_coh*to_center[1]*(good_beard), state.k_coh*to_center[2]*(good_beard))
    else
        F_coh = (0.0, 0.0)
    end
    F_drag = (-state.k_drag*berd_i.vel[1], -state.k_drag*berd_i.vel[2])
    total_F = ((F_align[1] + F_coh[1] + F_drag[1] + F_sep[1]), (F_align[2] + F_coh[2] + F_drag[2] + F_sep[2]))
    forses[i] = total_F
end
    for i in 1:n
        vel_temp = vel_temps[i]
        berd_i = state.boids[i]
        F = forses[i]
        ax = F[1]/berd_i.mass
        ay = F[2]/berd_i.mass
        new_vx = berd_i.vel[1]+ vel_temp[1] + ax * state.dt
        new_vy = berd_i.vel[2]+ vel_temp[2] + ay * state.dt
        berd_i.vel = (new_vx, new_vy)
        speed = sqrt(berd_i.vel[1]^2 + berd_i.vel[2]^2)
        if speed > state.max_speed
            berd_i.vel = (berd_i.vel[1]/speed * state.max_speed, berd_i.vel[2]/speed * state.max_speed)
        end
        new_px = berd_i.pos[1] + berd_i.vel[1] * state.dt
        new_py = berd_i.pos[2] + berd_i.vel[2] * state.dt
        berd_i.pos = (new_px, new_py)
    end
    return nothing
end

function (@main)(ARGS)
    w = 30
    h = 30
    n_boids = 40

    state = WorldState(n_boids, w, h)

    anim = @animate for time = 1:200
        update!(state, time)
        positions = [b.pos for b in state.boids]
        scatter(positions, xlim=(0, state.width), ylim=(0, state.height))
    end
    gif(anim, "boids.gif", fps = 24)
end

end  

using .Boids
Boids.main("")