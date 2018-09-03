function [Gpi] = PI(input,feedback)
    % TF
    Gmf = tf(dinamica_DC());
    Gmf = input + Gmf
    %achando a tf do controlador
    Kcr = 3;
    Pcr = 8.202;
    Kp = 0.45*Kcr;    %1.350(Ziegler-Nichols),20.7259(tune)
    Ti = (1/1.2)*Pcr; %6.835(Ziegler-Nichols),0.27003(tune)
    %aplicando o tune
    Kp = 20.7259;
    Ti = 0.27003;
    %montando a TF do PI
    Gpi = tf([1],[Ti 0]);
    Gpi = Kp + Kp*Gpi;
    %realimentação
    Gpi = Gpi - feedback
end

