%known data
x = rand(1, 4); %image points
y = rand(1, 4);
X = rand(3, 4); %space points

R = init_R();
F = init_F(x, y, X, R);
G4 = equations_for_groebner(F);
G20 = mult_for_groebner(G4);