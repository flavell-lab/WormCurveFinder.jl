module WormCurveFinder

using Statistics, LinearAlgebra, Images, ImageTransformations

include("interpolation.jl")
include("track.jl")
include("curve_finder.jl")

export track_curve,
    find_curve

end # module
