using Pkg
using BSON
import Base: isapprox
using Test

function isapprox((a, b)::Tuple{T,T}, (c, d)::Tuple{L,L}; rtol=1e-2) where {T<:Real,L<:Real}
    return abs(a - c) < rtol && abs(b - d) < rtol
end


function find_minimum_quadratic_search(f::Function, x_1::Real, x_3::Real; max_iter::Int=1000, ϵ::Float64=1e-5)::Tuple{Float64,Float64}
    ## code returns a tuple of the form α, f(α), where α is the point where the minimum is attained. 
    x_2::Real = (x_1 + x_3) / 2
    f_1::Real = f(x_1)
    f_2::Real = f(x_2)
    f_3::Real = f(x_3)
    x_0_upper_line::Real = 10^(99) #HOW DOES JULIA CALCULATES THIS???

    for k in 1:max_iter
        x_upper_line::Real = ((x_2^2-x_3^2)*f_1 + (x_3^2-x_1^2)*f_2 + (x_1^2-x_2^2)*f_3) / (2*((x_2-x_3)*f_1 + (x_3-x_1)*f_2 + (x_1-x_2)*f_3))
        f_upper_line::Real = f(x_upper_line)
        if((x_1 < x_upper_line) & (x_upper_line < x_2))
            if(f_upper_line <= f_2)
                x_3, f_3 = x_2, f_2
                x_2,f_2 = x_upper_line, f_upper_line
            else
                if(f_upper_line > f_2)
                    x_1, x_upper_line = x_upper_line, f_upper_line
                end
            end
        end
        if((x_2 < x_upper_line) & (x_upper_line < x_3))
            if(f_upper_line <= f_2)
                x_1,f_1 = x_2, f_2
                x_2, f_2 = x_upper_line, f_upper_line
            else
                if(f_upper_line > f_2)
                    x_3, f_3 = x_upper_line, f_upper_line
                end
            end
        end
        if(abs(x_upper_line-x_0_upper_line) < ϵ)
            println("Converged! x* is: $(x_upper_line) and f* is: $(f(x_upper_line))")
            return x_upper_line, f(x_upper_line)
        end
        x_0_upper_line = x_upper_line
    end

end

find_minimum_quadratic_search(x -> (x-3)^2 - 1, 0.0, pi) #ANSWER MUST BE 3, -1 BECAUSE FUNCTION WAS SHIFTED 3 UNITS RIGHT AND 1 UNIT DOWN.

function unit_test_for_quadratic_search()
    @assert isa(find_minimum_quadratic_search(x -> x^2, -1, 1), Tuple{Float64,Float64}) "Return type should be a tuple of Float64s"
    try
        @assert isapprox(find_minimum_quadratic_search(x -> x^2 - 1, -1, 1), (0.0, -1.0); rtol=1e-2)
        @assert isapprox(find_minimum_quadratic_search(x -> -sin(x), 0.0, pi), (pi / 2, -1.0); rtol=1e-2)
        @assert isapprox(find_minimum_quadratic_search(x -> x^4 + x^2 + x, -1, 1; max_iter=1000), (-0.3859, -0.2148); rtol=1e-2)
    catch AssertionError
        @info "Something went wrong"
        throw(AssertionError)
    end
    @info "DONE!!!"
    return 1
end

unit_test_for_quadratic_search()


