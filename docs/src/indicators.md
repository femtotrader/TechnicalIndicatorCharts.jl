# First, an Apology

There is a very high chance that the indicator you want to visualize
has not been implemented yet.  So far, I've only implemented the few
indicators that I personally use.  Fortunately, new indicator
visualizations are easy to implement.

# How to Implement a New Indicator Visualization

## Implement a `denominated_price` function.

> Is the output of the indicator a price value?

Moving averages are the best example of this.  It takes a price as an input and generates a price value as an output, so `demominated_price` should return `true`.

> What about the opposite case?

Oscillators typically answer `false` for this. Think of RSI that takes close prices as input but its output is a value between 0 and 100 regardless of how high or low the price is.  The domain and range are different for the RSI function (and many other oscillators) so `denominated_price` should return `false`.

```julia
denominated_price(sma::SMA) = true
denominated_price(rsi::RSI) = false
```
## Implement a `visualize` function.

A visualize function takes 3 parameters.

1. An indicator
2. A `Dict` of visualization options
3. A `DataFrame` containing all the values generated for the `Chart`

Here's what SMA looks like.  It's one of the simplest indicators to
visualize, because it's a single line.

```julia
"""$(TYPEDSIGNATURES)

Return an lwc_line for visualizing an SMA indicator.
"""
function visualize(sma::SMA, opts, df::DataFrame)
    start = sma.period
    name = indicator_fields(sma)[1]
    defaults = Dict(
        :label_name => "SMA $(sma.period)",
        :line_color => "#B84A62",
        :line_width => 2
    )
    kwargs = merge(defaults, Dict(opts))
    return lwc_line(
        df.ts[start:end],
        [df[!, name][start:end]...];
        kwargs...
    )
end
```

If you need to return more than one line, return it as a vector.
A good example of this is [BB.jl](https://github.com/g-gundam/TechnicalIndicatorCharts.jl/blob/main/src/BB.jl) which returns 3 lwc_lines.

You're also not limited to `lwc_line`.  You can use any visualization function supported by [LightweightCharts.jl](https://bhftbootcamp.github.io/LightweightCharts.jl/dev/pages/charts/).

# Examples

All indicator visualizations fall into one of these four categories.

|                       | Denominated in Price | Not Denominated in Price |
|-----------------------|----------------------|--------------------------|
| Single Visual Element | EMA, HMA, SMA        | RSI                      |
| Multi Visual Elements | BB                   | StochRSI                 |

When implementing a new visualization, feel free to look at the
[source](https://github.com/g-gundam/TechnicalIndicatorCharts.jl/tree/main/src)
for these and use them as a starting point for your own work.