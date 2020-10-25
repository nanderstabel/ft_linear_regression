using CSV
using DataFrames
using Statistics
include("formulas.jl")
include("graph.jl")

# Read and standardize data
data = CSV.read("storage/data.csv", DataFrame)
stats = describe(data)[!, [:variable, :mean, :min, :max]]
stats.std = [std(data.km), std(data.price)]
km = (data[:, :km] .- stats.mean[1]) ./ stats.std[1]
price = (data[:, :price])

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

anim = @animate for epoch in 1:epochs
    tmpθ₀ = α * (1 / m) * 𝚺(map(estimatePrice, km) - price)
    tmpθ₁ = α * (1 / m) * 𝚺((map(estimatePrice, km) - price) .* km)
    global θ₀ -= tmpθ₀
    global θ₁ -= tmpθ₁
    cost = J(θ₀, θ₁)
    animate_graphs()
    println(cost)
end

thetas = DataFrame(thetas = collect(unscale(θ₀, θ₁)))
CSV.write("storage/thetas.csv", thetas)

gif(anim, "storage/graphs.gif", fps = 15)
