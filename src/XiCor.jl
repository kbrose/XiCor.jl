module XiCor

using Random

export xicor

"""
    xicor(X, Y[, break_ties_randomly=false[, rng=nothing]])

Computes the correlation ξ between X and Y.

Unlike most coefficients of correlation, ξ ranges from -0.5 to 1.

If there are duplicate values in X, then ties are
broken based on the order in which they are observed.
If the order of X is not random, then you should
set `break_ties_randomly` to `true` to avoid a biased
estimate. You can use the `rng` parameter to
deterministically break ties.

See _A new coefficient of correlation_ by Chatterjee.

[arXiv:1909.10140 [math.ST]](https://arxiv.org/abs/1909.10140)

# Examples
```julia-repl
julia> ξ = xicor(1:100, 1:100)
0.9702970297029703
julia> x = trunc.((1:100) ./ 10);  # create x with lots of duplicates
julia> y = rand(MersenneTwister(0), 100);
julia> ξ = xicor(x, y, true, MersenneTwister(0))
-0.01830183018301823
julia> ξ = xicor(x, y, true, MersenneTwister(42))
0.004500450045004545
```
"""
function xicor(X, Y, break_ties_randomly=false, rng=nothing)
    if break_ties_randomly
        if !isnothing(rng)
            index = randperm(rng, length(X))
        else
            index = randperm(length(X))
        end
        X = X[index]
        Y = Y[index]
    end
    n = length(X)
    Y = Y[sortperm(X)]  # how should offset arrays be handled?
    sorter = sortperm(Y)
    R = zeros(Int, n)  # R[i] is the number of j such that Y[j] ≤ Y[i]
    L = zeros(Int, n)  # L[i] is the number of j such that Y[j] ≥ Y[i]

    i = 1
    while i <= n
        curr = Y[sorter[i]]
        counter = 1
        i += 1  # look ahead for repeated Y values
        while i <= n && Y[sorter[i]] == curr
            counter += 1
            i += 1
        end
        i -= 1
        for j = i-counter+1:i  # fill in R and L values wherever Y == curr
            R[sorter[j]] = i
            L[sorter[j]] = (n-i) + counter
        end
        i += 1
    end

    1 - n * sum(abs.(diff(R))) / (2 * sum(L .* (n .- L)))
end

end # module
