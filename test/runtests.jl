using Test
import NNlib
import KissConv

to_whcn(arr) = reshape(arr, (size(arr)..., 1, 1))

@testset "Against NNlib" begin
    for item in [
            (arr1=randn(10), arr2=randn(2)),
            (arr1=randn(Float32, 10), arr2=randn(Float32, 2)),
            (arr1=randn(Float32, 2,3), arr2=randn(Float32, 2,1)),
            (arr1=rand(1:10, 2,3), arr2=randn(Float32, 2,1)),
            (arr1=rand(1:100, 2,3,4), arr2=rand(1:100, 2,1, 3)),
        ]

        res_nn = NNlib.conv(
            to_whcn(item.arr1),
            to_whcn(item.arr2),
        )

        res_kiss = @inferred KissConv.conv(item.arr1, item.arr2)
        @test eltype(res_kiss) == eltype(res_nn)
        @test to_whcn(res_kiss) ≈ res_nn
    end
end
