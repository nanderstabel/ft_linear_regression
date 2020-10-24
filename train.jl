using CSV
using DataFrames
using Plots

# Read and standardize data
data = CSV.read("data.csv", DataFrame)
stats = describe(data)[!, [:variable, :mean, :min, :max]]
stats.std = [std(data.km), std(data.price)]
km = (data[:, :km] .- stats.mean[1]) ./ stats.std[1]
price = (data[:, :price] .- stats.mean[2]) ./ stats.std[2]
# km = (data[:, :km] .- stats.min[1]) ./ (stats.max[1] - stats.min[1])
# price = (data[:, :price] .- stats.min[2]) ./ (stats.max[2] - stats.min[2])
# km = (data[:, :km])
# price = (data[:, :price])
minmax
# Formulæ
𝚺(x) = sum(x)
estimatePrice(km) = θ₀ + (θ₁ * km)
y(x) = θ₀ + θ₁ * x

# Initialise hyperparamters
θ₀ = 0.0
θ₁ = 0.0
α = 500
epochs = 250
m = size(data)[1]

println("start")
for epoch in 1:epochs
    tmpθ₀ = α * (1 / m) * 𝚺(map(estimatePrice, km) - price)
    tmpθ₁ = α * (1 / m) * 𝚺((map(estimatePrice, km) - price) .* km)
    θ₀ -= tmpθ₀
    θ₁ -= tmpθ₁
    println(epoch, ", ", θ₀, θ₁)
end


gr()
scatter(km, price); plot!(x -> y(x), minimum(km), maximum(km))
# scatter(data.km, data.price); plot!(x -> y(x), stats.min[1], stats.max[1])
