Hs = 1.50;
Tz = 5;
h = 17;


[Uw,Urms] = Soulsby_Smallman_Irregular(Hs, Tz, h);

Waveheight = Hs;
Tm02 = Tz;
Waterdepth = h;
new = 1e-6;
density = 1020.96;
diameter = 68.84*10^-6;
phi_d = 90;
Ubar = .30;

[tau_c,tau_w,tau_m,tau_max,Uw] = shearstress(Waveheight,Tm02,Waterdepth,new,density,diameter,phi_d,Ubar);
