using CSV
using DataFrames
include("formulas.jl")

thetas = CSV.read("storage/thetas.csv", DataFrame)
data = CSV.read("storage/data.csv", DataFrame)

θ₀ = thetas[!, :thetas][1]
θ₁ = thetas[!, :thetas][2]

line = ""
while tryparse(UInt32, line) === nothing
    println("Please enter a number between 0 and 20000:")
    global line = readline()
end

km = parse(UInt64, line)

println("Estimated price of your car is $(max(0, trunc(estimatePrice(km))))")
