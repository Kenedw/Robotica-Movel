function [v, w] = fuzzy_controller(err_x, err_y, err_teta)
  
    %variaveis para armazenar o estado final
    V = "";
    W = "";
    
    state_teta = [];
    state_x = [];
    state_y = "";
    
    %matrizes para cada estado
    mat_lp_w = ["RN" "RN" "RN" "RN" "RN";
                "RN" "RN" "RN" "RN" "RN";
                "LN" "LN" "LN" "LN" "LN";
                "_Z" "_Z" "_Z" "_Z" "_Z";
                "LP" "LP" "LP" "LP" "LP";
                "RP" "RP" "RP" "RP" "RP";
                "RP" "RP" "RP" "RP" "RP"];
            
    mat_pp_w = ["RN" "RN" "RN" "RN" "RN";
                "RN" "LN" "RN" "RN" "RN";
                "LN" "LP" "LN" "RN" "LN";
                "_Z" "RP" "_Z" "RN" "_Z";
                "LP" "RP" "LP" "LN" "LP";
                "RP" "RP" "RP" "LP" "RP";
                "RP" "RP" "RP" "RP" "RP"];
            
    mat_z_w =  ["RN" "RN" "_Z" "RN" "RN";
                "RN" "LN" "_Z" "RN" "RN";
                "LN" "_Z" "_Z" "RN" "LN";
                "_Z" "RP" "_Z" "RN" "_Z";
                "LP" "RP" "_Z" "_Z" "LP";
                "RP" "RP" "_Z" "LP" "RP";
                "RP" "RP" "_Z" "RP" "RP"];
            
    mat_pn_w = ["RN" "LN" "LN" "RN" "RN";
                "RN" "LN" "_Z" "RN" "RN";
                "LN" "_Z" "LP" "RN" "LN";
                "_Z" "LP" "LP" "LN" "_Z";
                "LP" "RP" "LN" "_Z" "LP";
                "RP" "RP" "_Z" "LP" "RP";
                "RP" "RP" "LP" "LP" "RP"];
            
    mat_ln_w = ["RN" "RN" "RN" "RN" "RN";
                "RN" "RN" "LN" "RN" "RN";
                "LN" "LN" "_Z" "LN" "LN";
                "_Z" "_Z" "LP" "_Z" "_Z";
                "LP" "LP" "_Z" "LP" "LP";
                "RP" "RP" "LP" "RP" "RP";
                "RP" "RP" "RP" "RP" "RP"];
            
    mat_lp_v = ["Z" "Z" "Z" "Z" "Z";
                "L" "L" "L" "L" "L";
                "R" "R" "R" "R" "R";
                "R" "R" "R" "R" "R";
                "R" "R" "R" "R" "R";
                "L" "L" "L" "L" "L";
                "Z" "Z" "Z" "Z" "Z"];
    
    mat_pp_v = ["Z" "Z" "Z" "Z" "Z";
                "L" "L" "Z" "Z" "L";
                "R" "L" "Z" "L" "R";
                "R" "L" "L" "L" "R";
                "R" "L" "Z" "L" "R";
                "L" "Z" "Z" "L" "L";
                "Z" "Z" "Z" "Z" "Z"];  
            
     mat_z_v = ["Z" "L" "Z" "L" "Z";
                "L" "L" "Z" "L" "L";
                "R" "L" "Z" "L" "R";
                "R" "L" "Z" "L" "R";
                "R" "L" "Z" "L" "R";
                "L" "L" "Z" "L" "L";
                "Z" "L" "Z" "L" "Z"];       
           
    mat_pn_v = ["Z" "R" "L" "Z" "Z";
                "L" "R" "R" "L" "L";
                "R" "L" "L" "L" "R";
                "R" "L" "Z" "L" "R";
                "R" "L" "L" "L" "R";
                "L" "L" "R" "R" "L";
                "Z" "Z" "L" "R" "Z"];
            
    mat_ln_v = ["Z" "Z" "Z" "Z" "Z";
                "L" "L" "L" "L" "L";
                "R" "R" "R" "R" "R";
                "R" "R" "R" "R" "R";
                "R" "R" "R" "R" "R";
                "L" "L" "L" "L" "L";
                "Z" "Z" "Z" "Z" "Z"];
    
    %Condicoes do estado teta para determinado erro
    if err_teta < -2
        state_teta = 1;
    elseif err_teta >= -2 && err_teta < -1
        state_teta = 2;
    elseif err_teta >= -1 && err_teta < 0
        state_teta = 3;
    elseif err_teta == 0
        state_teta = 4;
    elseif err_teta > 0 && err_teta <= 1
        state_teta = 5;
    elseif err_teta > 1 && err_teta <= 2
        state_teta = 6;
    elseif err_teta > 2
        state_teta = 7;
    end
    
    %Condicoes do estado de x para determinado erro
    if err_x < -1
        state_x = 1;
    elseif err_x >= -1 && err_x < 0
        state_x = 2;
    elseif err_x == 0
        state_x = 3;
    elseif err_x > 0 && err_x <= 1
        state_x = 4;
    elseif err_x > 1
        state_x = 5;
    end
    
    %Condicoes do estado de y para determinado erro
    if err_y < -1
        state_y = "LN";
    elseif err_y >= -1 && err_x < 0
        state_y = "PN";
    elseif err_y == 0
        state_y = "_Z";
    elseif err_y > 0 && err_x <= 1
        state_y = "PP";
    elseif err_y > 1
        state_y = "LP";
    end
    
    disp(state_teta)
    disp(state_x)
    disp(state_y)

    %buscando os valores nas matrizes dos estados que iram ser trasformados na velocidade linear e angular        
    if strcmp(state_y, "LP")
        W = mat_lp_w(state_teta, state_x);
        V = mat_lp_v(state_teta, state_x);
    elseif strcmp(state_y, "PP")
        W = mat_pp_w(state_teta, state_x);
        V = mat_pp_v(state_teta, state_x);
    elseif strcmp(state_y, "_Z")
        W = mat_z_w(state_teta, state_x);
        V = mat_z_v(state_teta, state_x);
    elseif strcmp(state_y, "PN")
        W = mat_pn_w(state_teta, state_x);
        V = mat_pn_v(state_teta, state_x);
    elseif strcmp(state_y, "LN")
        W = mat_ln_w(state_teta, state_x);
        V = mat_ln_v(state_teta, state_x);
    end
    
    disp(V)
    disp(W)
    
    %procurando o valor mais adequado a v
    if strcmp(V, "R")
        v = 0.7;
    elseif strcmp(V, "L")
        v = 0.3;
    %elseif strcmp(V, "Z")
    else
        v = 0;
    end
    
    %procurado o valor mais adequado a w
    if strcmp(W, "RN")
        w = 300;
    elseif strcmp(W, "LN")
        w = 210;
    elseif strcmp(W, "_Z")
        w = 0;
    elseif strcmp(W, "LP")
        w = 30;
    %elseif strcmp(W, "RP")
    else
        w = 120;
    end
    
end
