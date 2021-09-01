include("poly_factorization_project.jl")

include("test/integers_test.jl")
test_euclid_ints()
test_ext_euclid_ints()

include("test/polynomials_test.jl")
prod_test_poly()
prod_derivative_test_poly()
division_test_poly()
ext_euclid_test_poly()