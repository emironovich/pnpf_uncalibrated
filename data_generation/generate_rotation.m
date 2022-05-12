function R = generate_rotation()
    r_vector = rand(3, 1)-0.5;
    r_vector_skew = make_skew(r_vector);
    R = expm(r_vector_skew);
end