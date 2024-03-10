function derivative(f::Function, x::Real; h::Float64 = 1e-3)
    return (f(x+h) - f(x)) /(h)
end

derivative(x->x^3 ,1)

function bisection(f::Function, a::Real, b:: Real; ϵ::Real=1e-3, num_iterations::Int64=100)
    alpha = 0
    alpha_derivative=0
    k=0
    alpha::Real
    alpha_derivative::Real
    k::Real
    for k in 1:num_iterations 
        alpha = (a+b)/2
        if (derivative(f, alpha) < 0)
            a = alpha
        else
            b = alpha       
        end
        if (abs(a-b) < ϵ)
            print("CONVERGED! $(a), $(f(a))")
        end
    end
    return alpha, f(alpha)
end

bisection(x->x^2, -3, 3)