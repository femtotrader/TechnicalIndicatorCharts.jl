denominated_price(sma::SMA) = true

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