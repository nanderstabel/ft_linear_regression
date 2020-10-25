using CSV
using DataFrames
using Plots
using Statistics

# Read and standardize data
data = CSV.read("data.csv", DataFrame)
stats = describe(data)[!, [:variable, :mean, :min, :max]]
stats.std = [std(data.km), std(data.price)]
km = (data[:, :km] .- stats.mean[1]) ./ stats.std[1]
price = (data[:, :price])

# Formulæ
𝚺(x) = sum(x)
estimatePrice(km) = θ₀ + (θ₁ * km)
h(x, θ₀, θ₁) = θ₀ + (θ₁ * x)
J(θ₀, θ₁) = 1 / (2 * m) * 𝚺((map(estimatePrice, km) - price).^2)

# Initialise hyperparamters
θ₀ = 0.0
θ₁ = 0.0
α = 0.1
epochs = 100
m = size(data)[1]

function unscale(θ₀, θ₁)
    θ₀ = θ₀ - θ₁ * (stats.mean[1] / stats.std[1])
    θ₁ = θ₁ / stats.std[1]
    return θ₀, θ₁
end

function get_regline(scaled=false, (θ₀, θ₁)=(θ₀, θ₁))
    regline = scatter(
            scaled ? km : data.km,
            data.price,
            xlabel = "km",
            ylabel = "price");
        plot!(
            x -> h(x, θ₀, θ₁),
            scaled ? minimum(km) : stats.min[1],
            scaled ? maximum(km) : stats.max[1])
    return regline
end

function animate_graphs()
    regline = get_regline(false, unscale(θ₀, θ₁))
    scaled_regline = get_regline(true)
    plot(regline, scaled_regline, legend=false)
end

anim = @animate for epoch in 1:epochs
    tmpθ₀ = α * (1 / m) * 𝚺(map(estimatePrice, km) - price)
    tmpθ₁ = α * (1 / m) * 𝚺((map(estimatePrice, km) - price) .* km)
    global θ₀ -= tmpθ₀
    global θ₁ -= tmpθ₁
    cost = J(θ₀, θ₁)
    animate_graphs()
    println(cost)
end

gif(anim, "graphs.gif", fps = 15)
