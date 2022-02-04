using Random

module XiCor

function xicor(X, Y, break_ties_randomly=false)
    if break_ties_randomly
        index = randperm(length(x))
        x = x[index]
        y = y[index]
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
