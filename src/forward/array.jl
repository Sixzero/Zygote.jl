using LinearAlgebra

zerolike(x::AbstractArray) = zerolike.(x)

@tangent function (A::Type{<:Array})(::UndefInitializer, sz::Integer...)
  x = A(UndefInitializer(), sz...)
  x, (_...) -> zerolike(x)
end

@tangent length(A::AbstractArray) = length(A), _ -> 0
@tangent size(A::AbstractArray, i::Integer) = size(A, i), (_, _) -> 0
@tangent size(A::AbstractArray) = size(A), _ -> zerolike(size(A))

@tangent first(x) = first(x), ẋ -> first(ẋ)

@tangent setindex!(x::AbstractArray, v, inds...) =
  setindex!(x, v, inds...), (ẋ, v̇, _...) -> setindex!(ẋ, v̇, inds...)

@tangent mul!(C, A, B) = mul!(C, A, B), (Ċ, Ȧ, Ḃ) -> Ċ .+= Ȧ*B .+ A*Ḃ

@tangent A::AbstractArray * B::AbstractArray = A*B, (Ȧ, Ḃ) -> Ȧ*B .+ A*Ḃ

@tangent sum(x; dims = :) = sum(x; dims = dims), ẋ -> sum(x, dims = dims)
