%known data
p = 31991; %modul
% x = mod(ceil(1000000*rand(1, 4)), p); %image points
% y = mod(ceil(1000000*rand(1, 4)), p);
% X = mod(ceil(1000000*rand(3, 4)), p); %space points

[X, x, y, ~, ~, ~] = generate_data_for_macaulay();

R = init_R();
F = init_F(x, y, X, R);
F = mod(F, p);
G4 = equations_for_groebner(F);
G4 = mod(G4, p);
G20 = mult_for_groebner(G4);
G20 = mod(G20, p);
syms x y;
[mons, ~] = make_monomial_set(6, x, y, 'c');

disp(G4*mons);
% ideal(24988*x^6 + 29971*x^5 + 10982*x^4*y^2 + 18845*x^4*y + 12727*x^4 + 27951*x^3*y^2 + 23145*x^3*y + 14096*x^3 + 10982*x^2*y^4 + 5699*x^2*y^3 + 11907*x^2*y^2 + 29509*x^2*y + 10430*x^2 + 29971*x*y^4 + 23145*x*y^3 + 2801*x*y^2 + 22946*x*y + 8170*x + 24988*y^6 + 18845*y^5 + 31171*y^4 + 23802*y^3 + 29810*y^2 + 4622*y + 12392, 
%       26135*x^6 + 26574*x^5 + 14423*x^4*y^2 + 17480*x^4*y + 25007*x^4 + 21157*x^3*y^2 + 2347*x^3*y + 22089*x^3 + 14423*x^2*y^4 + 2969*x^2*y^3 + 26375*x^2*y^2 + 18105*x^2*y + 9082*x^2 + 26574*x*y^4 + 2347*x*y^3 + 2456*x*y^2 + 23146*x*y + 14824*x + 26135*y^6 + 17480*y^5 + 1368*y^4 + 3195*y^3 + 14861*y^2 + 746*y + 10173, 
%      13958*x^6 + 3161*x^5 + 9883*x^4*y^2 + 10223*x^4*y + 7104*x^4 + 6322*x^3*y^2 + 20590*x^3*y + 24571*x^3 + 9883*x^2*y^4 + 20446*x^2*y^3 + 27993*x^2*y^2 + 12298*x^2*y + 19405*x^2 + 3161*x*y^4 + 20590*x*y^3 + 7020*x*y^2 + 11939*x*y + 23293*x + 13958*y^6 + 10223*y^5 + 20889*y^4 + 2943*y^3 + 11468*y^2 + 28086*y + 15745, 
%       21805*x^6 + 14713*x^5 + 1433*x^4*y^2 + 4598*x^4*y + 27520*x^4 + 29426*x^3*y^2 + 10647*x^3*y + 7314*x^3 + 1433*x^2*y^4 + 9196*x^2*y^3 + 11873*x^2*y^2 + 29055*x^2*y + 9624*x^2 + 14713*x*y^4 + 10647*x*y^3 + 6253*x*y^2 + 16067*x*y + 11130*x + 21805*y^6 + 4598*y^5 + 16344*y^4 + 29274*y^3 + 18016*y^2 + 5885*y + 12073)
 
G20
G20_afterGJ = rref(G20)
spy(G20_afterGJ);