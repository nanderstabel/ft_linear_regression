using Plots

function get_regline((θ₀, θ₁)=(θ₀, θ₁))
    regline = scatter(
            data.km,
            data.price,
            xlabel = "km",
            ylabel = "price");
        plot!(
            x -> h(x, θ₀, θ₁),
            stats.min[1],
            stats.max[1])
    return regline
end

function animate_graphs()
    regline = get_regline(unscale(θ₀, θ₁))
    plot(regline, legend=false)
end
