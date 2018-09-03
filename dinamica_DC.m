function [WU] = dinamica_DC()
    %dados do problema
    n = 0.99;
    R = 1.5506;
    Kt= 0.010913;
    Kv= 0.011518;
    Je= 0.0093564;
    s = tf('s');
    %W/U=nKt/(RJe+RFw+KvKt)
    %Fw é tão pequeno que pode ser despresado neste caso
    WU = (n*Kt)/((s*R*Je)+(Kv*Kt));
end
