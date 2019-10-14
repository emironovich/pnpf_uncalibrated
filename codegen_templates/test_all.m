F = 1.111;
K = [F 0 0; 0 F 0; 0 0 1];
R = rod2dcm([0.05 0.05 0.05]);
T = [0.1 0.2 0.3]';

P = K * [R T];
T = -R'*T;

% XXX: one of rare cases when all algorithms work
pt_3d = [...
    1.8552   -1.0450    2.0844;...
    1.4917    0.2787    2.5323;...
   -2.2789   -0.6067    1.1232;...
    0.1503   -0.5094    6.5421];


pt_hom = [pt_3d ones(4, 1)] * P';
pt_2d = pt_hom(:,1:2) ./ repmat(pt_hom(:,3), [1 2]);

pt_3d_double = pt_3d;
pt_3d_single = single(pt_3d);

pt_2d_double = pt_2d;
pt_2d_single = single(pt_2d);

eps_double = eps('double');
eps_single = eps('single');

[n,fs,r,t] = p35p_double(pt_3d_double', pt_2d_double(:,1)', pt_2d_double(:,2)', eps_double);

[~,bestId] = min(abs(log(F./fs)));
assert(all(size(fs)==[1,n]));
assert(size(r,1)==3);
assert(size(r,2)==3);
assert(size(r,3)==n);
assert(all(size(t)==[3,n]));
assert(n>0)
f=fs(bestId);
r=r(:,:,bestId);
t=t(:,bestId);
assert(abs(f/F-1)<0.1);
assert(norm(r-R,2)/norm(R,2)<0.1);
assert(norm(t-T,2)/norm(T,2)<0.1);


[n,f,r,t] = p35p_single(pt_3d_single', pt_2d_single(:,1)', pt_2d_single(:,2)', eps_single);
[~,bestId] = min(abs(log(F./f)));
assert(all(size(f)==[1,n]));
assert(size(r,1)==3);
assert(size(r,2)==3);
assert(size(r,3)==n);
assert(all(size(t)==[3,n]));
assert(n>0)
f=f(bestId);
r=r(:,:,bestId);
t=t(:,bestId);
assert(abs(f/F-1)<0.1);
assert(norm(r-R,2)/norm(R,2)<0.1);
assert(norm(t-T,2)/norm(T,2)<0.1);


[n,f,r,t] = p4pf_double(pt_3d_double', pt_2d_double(:,1)', pt_2d_double(:,2)', eps_double);
[~,bestId] = min(abs(log(F./f)));
assert(all(size(f)==[1,n]));
assert(size(r,1)==3);
assert(size(r,2)==3);
assert(size(r,3)==n);
assert(all(size(t)==[3,n]));
assert(n>0)
f=f(bestId);
r=r(:,:,bestId);
t=t(:,bestId);
assert(abs(f/F-1)<0.1);
assert(norm(r-R,2)/norm(R,2)<0.1);
assert(norm(t-T,2)/norm(T,2)<0.1);


[n,f,r,t] = p4pf_single(pt_3d_single', pt_2d_single(:,1)', pt_2d_single(:,2)', eps_single);
[~,bestId] = min(abs(log(F./f)));
assert(all(size(f)==[1,n]));
assert(size(r,1)==3);
assert(size(r,2)==3);
assert(size(r,3)==n);
assert(all(size(t)==[3,n]));
assert(n>0)
f=f(bestId);
r=r(:,:,bestId);
t=t(:,bestId);
assert(abs(f/F-1)<0.1);
assert(norm(r-R,2)/norm(R,2)<0.1);
assert(norm(t-T,2)/norm(T,2)<0.1);
