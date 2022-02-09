A Julia implementation of Sourav Chatterjee's [new coefficient of correlation](https://arxiv.org/abs/1909.10140) ξ (xi).

Compared to pearson's and spearman's coefficients, ξ is able to detect non-monotonic relationships such as sine waves.

```julia
julia> using XiCor

julia> x = rand(1_000);

julia> y = sin.(x * 8π) + randn(1_000) / 3;

julia> xicor(x, y)
0.6154926154926155
```

![Run tests](https://github.com/kbrose/XiCor.jl/actions/workflows/test.yml/badge.svg)

Does not support p value calculation.
