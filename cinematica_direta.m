function [v, w] = cinematica_direta(vd, ve)
    %M distancia entre uma roda e a outra em Metros

    v = (vd+ve)/2;      %V=(Vd+Vi)/2
    w = (vd-ve)/0.35;   %W=(Vd-Vi)/M

end