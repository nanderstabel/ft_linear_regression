using CSV
using DataFrames
include("formulas.jl")

line = ""
while tryparse(UInt32, line) === nothing
    println("Please enter the mileage of your car:")
    global line = readline()
end

θ₀ = 0.0
θ₁ = 0.0
if isfile("storage/thetas.csv")
    thetas = CSV.read("storage/thetas.csv", DataFrame)
    global θ₀ = thetas[!, :thetas][1]
    global θ₁ = thetas[!, :thetas][2]
end
km = parse(UInt64, line)

println("Estimated price of your car is $(max(0, trunc(estimatePrice(km))))")
