# #############################################################################
# #############################################################################
# #
# # This file defines polynomials mod p 
# #                                                                               
# #############################################################################
# #############################################################################

# ##########################################
# # Polynomial mod p type and construction #
# ##########################################

# """
# A polynomial mod p is based on a polynomial and p. It is guaranteed that all coefficients of the polynomial are in 0,...,p-1.
# """
# struct PolynomialModP
#     polynomial::Polynomial   
#     prime::Int
# end




# """
# Generates a random polynomial.
# """
# function rand(::Type{Polynomial} ; 
#                 degree::Int = -1, 
#                 terms::Int = -1, 
#                 max_coeff::Int = 100, 
#                 mean_degree::Float64 = 5.0,
#                 prob_term::Float64  = 0.7,
#                 monic = false,
#                 condition = (p)->true)
        
#     while true 
#         _degree = degree == -1 ? rand(Poisson(mean_degree)) : degree
#         _terms = terms == -1 ? rand(Binomial(_degree,prob_term)) : terms
#         degrees = vcat(sort(sample(0:_degree-1,_terms,replace = false)),_degree)
#         coeffs = rand(1:max_coeff,_terms+1)
#         monic && (coeffs[end] = 1)
#         p = Polynomial( [Term(coeffs[i],degrees[i]) for i in 1:length(degrees)] )
#         condition(p) && return p
#     end
# end

# ###########
# # Display #
# ###########

# """
# Show a polynomial.
# """
# #STD-(polynomial.jl#3): Improve pretty printing.
# function Base.show(io::IO, p::Polynomial) 
#     p = deepcopy(p)
#     if iszero(p)
#         print(io,"0")
#     else
#         for t in extract_all!(p.terms)
#             print(io, t, "+ ")
#         end
#     end
# end

# ##############################################
# # Iteration over the terms of the polynomial #
# ##############################################

# """
# Allows to do iteration over the terms of the polynomial. The iteration is in an arbitrary order.
# """
# iterate(p::Polynomial, state=1) = iterate(p.terms, state)

# ##############################
# # Queries about a polynomial #
# ##############################

# """
# The number of terms of the polynomial.
# """
# length(p::Polynomial) = length(p.terms)

# """
# The leading term of the polynomial.
# """
# leading(p::Polynomial)::Term = isempty(p.terms) ? zero(Term) : first(p.terms) 

# """
# Returns the coefficients of the polynomial.
# """
# coeffs(p::Polynomial)::Vector{Int} = [t.coeff for t in p]

# """
# The degree of the polynomial.
# """
# degree(p::Polynomial)::Int = leading(p).degree 

# """
# The content of the polynomial is the GCD of its coefficients.
# """
# content(p::Polynomial)::Int = euclid_alg(coeffs(p))

# """
# QQQQ
# """
# #QQQQ - use a "map" after making it.
# evaluate(f::Polynomial, x::T) where T <: Number = sum(evaluate(tt,x) for tt in extract_all!(deepcopy(f.terms)))

# ################################
# # Pushing and popping of terms #
# ################################

# """
# Push a new term into the polynomial.
# """
# #STD-(polynomial.jl#4): Handle error if pushing another term of same degree
# function push!(p::Polynomial, t::Term) 
#     iszero(t) && return #don't push a zero
#     push!(p.terms,t)
# end

# """
# Pop the leading term out of the polynomial.
# """
# pop!(p::Polynomial)::Term = pop!(p.terms)

# """
# Check if the polynomial is zero.
# """
# iszero(p::Polynomial)::Bool = isempty(p.terms)

# #################################################################
# # Transformation of the polynomial to create another polynomial #
# #################################################################

# """
# The negative of a polynomial.
# """
# -(p::Polynomial) = Polynomial(map((pt)->-pt, p.terms))
# #     p_temp = deepcopy(p)
# #     p_out = Polynomial()
# #     while !iszero(p_temp)
# #         push!(p_out,-pop!(p_temp))
# #     end
# #     return p_out
# # end

# #QQQQ Can't specify return Polynomial?
# # -(p::Polynomial) = Polynomial(map((pt)->-pt, p.terms)) 


# """
# Create a new polynomial which is the derivative of the polynomial.
# """
# function derivative(p::Polynomial)::Polynomial 
#     der_p = Polynomial()
#     for term in p
#         der_term = derivative(term)
#         !iszero(der_term) && push!(der_p,der_term)
#     end
#     return der_p
# end

# """
# The prim part (multiply a polynomial by the inverse of its content)
# """
# prim_part(p::Polynomial)::Polynomial = p ÷ content(p)


# """
# QQQQ
# """
# square_free(p::Polynomial, prime::Int)::Polynomial = (p ÷ gcd(p,derivative(p),prime))(prime)

# #################################
# # Queries about two polynomials #
# #################################

# """
# Check if two polynomials are the same
# """
# ==(p1::Polynomial, p2::Polynomial)::Bool = p1.terms == p2.terms


# """
# Check if a polynomial is equal to 0.
# """
# #STD: There is a problem here. E.g The polynomial 3 will return true to equalling the integer 2.
# ==(p::Polynomial, n::T) where T <: Real = iszero(p) == iszero(n)

# ##################################################################
# # Operations with two objects where at least one is a polynomial #
# ##################################################################

# """
# Subtraction of two polynomials.
# """
# -(p1::Polynomial, p2::Polynomial)::Polynomial = p1 + (-p2)


# """
# Multiplication of polynomial and term.
# """
# *(t::Term,p1::Polynomial)::Polynomial = iszero(t) ? Polynomial() : Polynomial(map((pt)->t*pt, p1.terms))
# *(p1::Polynomial, t::Term)::Polynomial = t*p1

# """
# Multiplication of polynomial and an integer.
# """
# *(n::Int,p::Polynomial)::Polynomial = p*Term(n,0)
# *(p::Polynomial,n::Int)::Polynomial = n*p

# """
# Integer division of a polynomial by an integer.

# Warning this may not make sense if n does not divide all the coefficients of p.
# """
# ÷(p::Polynomial,n::Int)::Polynomial = Polynomial(map((pt)->pt ÷ n, p.terms))

# """
# Take the smod of a polynomial with an integer.
# """
# #QQQQ - Yoni - use map as needed and also maintain not having Term(0,0) as invairant
# function smod(f::Polynomial, p::Int)::Polynomial
#     p_out = Polynomial()
#     for tt in extract_all!(deepcopy(f.terms))
#         push!(p_out, smod(tt, p)) #if coeff reduced to zero, push! will handle it
#     end
#     return p_out
# end