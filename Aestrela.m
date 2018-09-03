%Planejamento de caminho A*
clear;
clc;

mapa = [1 1 1 1 1 1 1 1;
        1 1 1 1 1 1 1 1;
        1 1 0 0 0 0 1 1;
        1 1 1 1 1 0 1 1;
        1 1 1 1 1 0 1 1;
        1 1 1 1 1 1 1 1;
        1 1 1 1 1 1 1 1;
        1 1 1 1 1 1 1 1];

copiaMapa = mapa;


i = [4 5];
f = [1 8];

caminhoRes = star2(i,f,mapa,copiaMapa);

caminhoRes = deta(caminhoRes);

function res = deta(caminhoRes);

    res = caminhoRes;
    
    tam = size(res);
    
    anguloAtual = 0;
    anguloReal = 0;
    
    distx = 0;
    disty = 0;
    
    for i=2:tam(1)
        
        distx = caminhoRes(i,2) - caminhoRes(i-1,2);
        disty = caminhoRes(i-1,1) - caminhoRes(i,1);
        
%         disp(distx);
%         disp(disty);

        angulo = atand(disty/distx);
        
%         anguloAtual = angulo;
        
        aux = anguloAtual;

        aux = 0;
        
        if(angulo ~= anguloAtual)
            
            if (i == 2)
                anguloAtual = angulo;
            
            elseif ( angulo < 0)
                if(anguloAtual > 0)
                    anguloAtual = anguloAtual + angulo;
                else
                    anguloAtual = abs(angulo);
                end
            else
                if (angulo > anguloAtual)
                    if (anguloAtual > 0)
                        anguloAtual = anguloAtual + (anguloAtual - angulo);
                    else
                        anguloAtual = anguloAtual + angulo;
                    end
                else
                    anguloAtual = 0 - angulo;
                end
            end
        else
            if ((distx ~= 0)&&(disty ~= 0))  
                anguloAtual = anguloAtual + angulo;
            elseif (xor((distx == 0),(disty == 0)))
%                 disp(i);
                res(i,3) = 0;
                anguloReal = angulo;
                aux = 1;
            else
                anguloAtual = 0;
            end
        end
        
        if (aux == 1)
            res(i,3) = 0;
        else
            res(i,3) = anguloAtual;
            anguloReal = angulo;
        end
        aux = 0;
    end
end

% p = pintar(mapa,caminhoRes,i,f);

function caminho = star2(start,final,mapa,copiaMapa)

    melhor = start;
    %vizinhos do ponto inicial
    vizinhosRaiz = getVizinhos(mapa,start);
    vizinhosRaizVisitados = [];
    loop = 1;
    pontas = [];
    acumulAresta = [];
    acumulPont = [];
    acumuladosCaminhos = [];
    horizontal = 0;
    while 1
        
        [ppMelhorVizinho,melhorVizinho,arestaVizinho] = melhorVizinhos(mapa,copiaMapa,start,final);
        
        if loop ~= 1
            
            tam = size(pontas);
            ppPontas = [];
            mvPontas = [];
            aaPontas = [];
            
            for i=1:tam(1)
                [aux1,aux2,aux3] = melhorVizinhos(mapa,copiaMapa,pontas(i,:),final);
                ppPontas = [ppPontas aux1];
                if aux2 == -1
                    mvPontas = [mvPontas; [-1 -1]];
                else
                    mvPontas = [mvPontas; aux2];
                end
                aaPontas = [aaPontas aux3];
            end
            
            aux = ppMelhorVizinho;
            casa = 0;
            menor = 0;
            
            for i=1:tam(1)
                if (ppPontas(i)+acumulAresta(i)) < aux
                    menor = 1;
                    aux = ppPontas(i)+acumulAresta(i);
                    casa = i;
                end
            end
            
            if menor == 0
                pontas = [pontas; melhorVizinho];
                acumulAresta = [acumulAresta arestaVizinho];
                vizinhosRaizVisitados = [vizinhosRaizVisitados; melhorVizinho];
                melhor = melhorVizinho;
                copiaMapa(melhorVizinho(1),melhorVizinho(2)) = 'x'+casa;
                
                acumuladosCaminhos = adicionarLinha(acumuladosCaminhos,0,0);
                s = size(acumuladosCaminhos);
                
                acumuladosCaminhos(s(1),3) = melhorVizinho(1);
                acumuladosCaminhos(s(1),4) = melhorVizinho(2);
                
            else
                melhor = mvPontas(casa,:);
                
                acumuladosCaminhos = adicionarLinha(acumuladosCaminhos,1,casa);
                
                aux = pontas(casa,:);
                pontas(casa,:) = mvPontas(casa,:);
                pontas = [pontas; aux];
                
                acumulAresta = [acumulAresta acumulAresta(casa)];
                acumulAresta(casa) = acumulAresta(casa) + aaPontas(casa);
                
                copiaMapa(melhor(1),melhor(2)) = 'x'+casa;
                
                s = size(acumuladosCaminhos);
                i = 1;
                encontrou = 0;
                for i=1:s(2)
                    if acumuladosCaminhos(casa,i) == 0
                        encontrou = 1;
                        break;
                    end
                end
                
                if encontrou == 0 
                    i = i+1;
                end
                    
                acumuladosCaminhos(casa,i) = mvPontas(casa,1);
                acumuladosCaminhos(casa,i+1) = mvPontas(casa,2);
                
            end
        
        else
            
            vizinhosRaizVisitados = melhorVizinho;
            pontas = melhorVizinho;
            acumulAresta = [acumulAresta arestaVizinho];
            melhor = pontas;
            
            acumuladosCaminhos = [acumuladosCaminhos start];
            
            copiaMapa(melhorVizinho(1),melhorVizinho(2)) = 'x';
            acumuladosCaminhos(1,3) = pontas(1);
            acumuladosCaminhos(1,4) = pontas(2);
            
            horizontal = 1;
        end
        
        loop = loop + 1;
        
        if melhor == final
            break;
        end
    end
    
    aux = acumuladosCaminhos(casa,:);
    s = size(aux);
    caminho = [];
    for i=1:2:s(2)
        caminho = [caminho; [aux(i) aux(i+1)]];
    end
end

function res = adicionarLinha(arrayOriginal,copiarLinha,linhaASerCopiada)
    
    if copiarLinha == 1
        
        res = [arrayOriginal; arrayOriginal(linhaASerCopiada,:)];
        
    else
        tamH = size(arrayOriginal);

        add = zeros(1,tamH(2));

        add(1) = arrayOriginal(1,1);
        add(2) = arrayOriginal(1,2);

        res = arrayOriginal;
        res = [res; add];
    end
end

function res = getVizinhos(mapa,posicao)
    
    [maxX,maxY] = size(mapa);
    atual = posicao;
    res = [];
    for i=1:8
        if i == 1 %norte

            x = atual(1)-1;
            y = atual(2);

        elseif i == 3 %leste

            x = atual(1);
            y = atual(2)+1;

        elseif i == 5 %sul

            x = atual(1)+1;
            y = atual(2);

        elseif i == 7 %oeste

            x = atual(1);
            y = atual(2)-1;
            
        elseif i == 2 %nordeste
            x = atual(1)-1;
            y = atual(2)+1;

        elseif i == 4 %sudeste
            x = atual(1)+1;
            y = atual(2)+1;

        elseif i == 6 %sudoeste
            x = atual(1)+1;
            y = atual(2)-1;

        elseif i == 8 %noroeste
            x = atual(1)-1;
            y = atual(2)-1;

        end
        if ~(( x > maxX || x < 1) || ( y > maxY || y < 1))
            if mapa(x,y) == 1
                res = [res; [x y]];
            end
        end
    end
end

function [melhor,nos,aresta] = melhorVizinhos(mapa,copiaMapa,atual,final)

    nos = [[1 1];[2 2];[3 3];[4 4];[5 5];[6 6];[7 7];[8 8]];
    acumulado = [0,0,0,0,0,0,0,0];
    [maxX,maxY] = size(mapa);
    
    if mapa(atual(1),atual(2)) == 0
        melhor = -1;
        nos = 0;
        return;
    end
    
    for i=8:-1:1

        if mod(i,2)

            x = 0;
            y = 0;

            if i == 1 %norte

                x = atual(1)-1;
                y = atual(2);

            elseif i == 3 %leste

                x = atual(1);
                y = atual(2)+1;

            elseif i == 5 %sul

                x = atual(1)+1;
                y = atual(2);

            elseif i == 7 %oeste

                x = atual(1);
                y = atual(2)-1;

            end
                
            if ~(( x > maxX || x < 1) || ( y > maxY || y < 1))
           
                if mapa(x,y) == 1
                    
                    jaVerificado = 0;
                    
                    if copiaMapa(x,y) > 1
                        jaVerificado = 1;
                    end
                    
                    if jaVerificado == 0                        
                        valorAresta = 10;
                        pontosAteOFinal = valorAresta + disEuclidianaPontos([x y],final);
                        
                        acumulado(i) = pontosAteOFinal;
                        nos(i,1) = x;
                        nos(i,2) = y;
                    else
                        nos(i,1) = -1;
                        nos(i,2) = -1; 
                        acumulado(i) = inf;
                    end
                        
                else
                    nos(i,1) = -1;
                    nos(i,2) = -1; 
                    acumulado(i) = inf;
                        
                end
                    
            else
                nos(i,1) = -1;
                nos(i,2) = -1; 
                acumulado(i) = inf;
                    
            end

        else

            if i == 2 %nordeste
                x = atual(1)-1;
                y = atual(2)+1;

            elseif i == 4 %sudeste
                x = atual(1)+1;
                y = atual(2)+1;

            elseif i == 6 %sudoeste
                x = atual(1)+1;
                y = atual(2)-1;

            elseif i == 8 %noroeste
                x = atual(1)-1;
                y = atual(2)-1;

            end

            if ~(( x > maxX || x < 1) || ( y > maxY || y < 1))
           
                if mapa(x,y) == 1
                    
                    jaVerificado = 0;
                    
                    if copiaMapa(x,y) > 1
                        jaVerificado = 1;
                    end
                    
                    if jaVerificado == 0                        
                        valorAresta = 14;
                        pontosAteOFinal = valorAresta + disEuclidianaPontos([x y],final);


                        acumulado(i) = pontosAteOFinal;
                        nos(i,1) = x;
                        nos(i,2) = y;
                    else
                        nos(i,1) = -1;
                        nos(i,2) = -1; 
                        acumulado(i) = inf;
                    end
                    
                else
                    nos(i,1) = -1;
                    nos(i,2) = -1;
                    acumulado(i) = inf;
                end                    
            else
                nos(i,1) = -1;
                nos(i,2) = -1; 
                acumulado(i) = inf;
                    
            end

        end

    end
    
    %procurando o melhor custo
    casa = 0;
    valorTest = inf;
    aresta = [10,14,10,14,10,14,10,14];
    for i=1:8
        if acumulado(i) < valorTest
            valorTest = acumulado(i);
            casa = i;
        end
    end
    if casa ~= 0
        aresta = aresta(casa);
        melhor = acumulado(casa);
        nos = nos(casa,:);
    else
        aresta = 0;
        melhor = inf;
        nos = -1;
    end

end

function res = disEuclidianaPontos(inicio,fim)

    res = 10*sqrt((fim(1)-inicio(1))^2+(fim(2)-inicio(2))^2);

end
function res = pintar(mapa,caminho,inicio, fim)

    [maxX,maxY] = size(mapa);
    
    m = [];
    
    for i=1:maxY
        m = [m 'o '];
    end
    for i=1:maxX-1
        aux = m(1,:);
        m = [m; aux];
    end
    
    m(inicio(1),inicio(2)*2-1) = 'i';
    m(fim(1),fim(2)*2-1) = 'f';
    
    for i=1:maxY
        for k=1:maxX
            if mapa(k,i) == 0
                m(k,i*2-1) = 'x';
                %m(k,i*2+1) = ' '
            end
        end
    end
    
    tam = size(caminho);
    
    for i=2:tam(1)-1
        m(caminho(i,1),caminho(i,2)*2-1) = 'c';
    end
    
    res = m;
end