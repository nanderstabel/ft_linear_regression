# Formulæ
𝚺(x) = sum(x)
estimatePrice(km) = θ₀ + (θ₁ * km)
h(x, θ₀, θ₁) = θ₀ + (θ₁ * x)
J(θ₀, θ₁) = 1 / (2 * m) * 𝚺((map(estimatePrice, km) - price).^2)
