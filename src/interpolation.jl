function bilerp(img, x, y)
    W, H = size(img)
    x = clamp(x, 1, W)
    y = clamp(y, 1, H)
    x0, y0 = floor(Int, x), floor(Int, y)
    xα, yα = x - x0, y - y0
    x1, y1 = min(x0 + 1, W), min(y0 + 1, H)
    @inbounds img00, img01 = img[x0, y0], img[x1, y0]
    @inbounds img10, img11 = img[x0, y1], img[x1, y1]
    (1-xα)*(1-yα)*img00 +
        (xα)*(1-yα)*img01 +
        (1-xα)*(yα)*img10 +
        (xα)*(yα)*img11
end


"""
```
P = bilinear_interpolation(img, r, c)
```

Bilinear Interpolation is used to interpolate functions of two variables
on a rectilinear 2D grid.

The interpolation is done in one direction first and then the values obtained
are used to do the interpolation in the second direction.

This function is adapted from Images.jl package version 0.23.
"""
function bilinear_interpolation(img::AbstractArray{T, 2}, y::Number, x::Number) where T
    y_min = floor(Int, y)
    x_min = floor(Int, x)
    y_max = ceil(Int, y)
    x_max = ceil(Int, x)

    topleft = chkbounds(Bool, img, y_min, x_min) ? img[y_min, x_min] : zero(T)
    bottomleft = chkbounds(Bool, img, y_max, x_min) ? img[y_max, x_min] : zero(T)
    topright = chkbounds(Bool, img, y_min, x_max) ? img[y_min, x_max] : zero(T)
    bottomright = chkbounds(Bool, img, y_max, x_max) ? img[y_max, x_max] : zero(T)

    if x_max == x_min
        if y_max == y_min
            return T(topleft)
        end
        return T(((y_max - y) * topleft + (y - y_min) * bottomleft) / (y_max - y_min))
    elseif y_max == y_min
        return T(((x_max - x) * topleft + (x - x_min) * topright) / (x_max - x_min))
    end

    r1 = ((x_max - x) * topleft + (x - x_min) * topright) / (x_max - x_min)
    r2 = ((x_max - x) * bottomleft + (x - x_min) * bottomright) / (x_max - x_min)

    T(((y_max - y) * r1 + (y - y_min) * r2) / (y_max - y_min))

end

chkbounds(::Type{Bool}, img, x, y) = checkbounds(Bool, img, x, y)
