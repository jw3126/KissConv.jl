module KissConv

using OffsetArrays
export conv

struct Inner end
struct Outer end

function conv_axes(arr1, arr2, ::Inner)
    if ndims(arr1) != ndims(arr2)
        throw(DimensionMismatch("Cannot convolve arrays of different dimensions."))
    end
    axs = map(axes(arr1), axes(arr2)) do r1, r2
        i_start = first(r1) +  last(r2)
        i_stop  = last(r1)  + first(r2)
        i_start:i_stop
    end
    return axs
end

function conv_axes(arr1, arr2, ::Outer)
    if ndims(arr1) != ndims(arr2)
        throw(DimensionMismatch("Cannot convolve arrays of different dimensions."))
    end
    axs = map(axes(arr1), axes(arr2)) do r1, r2
        i_start = first(r1) + first(r2)
        i_stop  = last(r1)  + last(r2)
        i_start:i_stop
    end
    return axs
end

function conv_out(arr1, arr2, mode)
    T = promote_type(eltype(arr1), eltype(arr2))
    axs = conv_axes(arr1, arr2, mode)
    return similar(arr1, T, axs)
end

function conv!(out, arr1, arr2, ::Inner)
    z = zero(eltype(out))
    @inbounds for I in CartesianIndices(out)
        out[I] = z
        @simd for J in CartesianIndices(arr2)
            IJ = CartesianIndex(map(-, Tuple(I), Tuple(J)))
            out[I] += arr1[IJ] * arr2[J]
        end
    end
    return out
end

function conv(arr1, arr2, mode=Inner())
    out = conv_out(arr1, arr2, mode)
    return conv!(out, arr1, arr2, mode)
end

end#module
