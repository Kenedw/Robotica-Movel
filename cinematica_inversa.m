function [vd, ve] = cinematica_inversa(v, w)

    vd = (2*v+0.35*w)/2;    %vd=(2v+Lw)/2
    ve = (2*v-0.35w)/2;     %ve=(2v-Lw)/2

end