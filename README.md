A Julia implementation of Sourav Chatterjee's [new coefficient of correlation](https://arxiv.org/abs/1909.10140) ξ.

Does not support p value calculation.

```julia-repl
julia> x = rand(1_000);

julia> y = sin.(x * 8π) + randn(1_000) / 2;

julia> xicor(x, y)
0.4528054528054528
```
