
%Licencia CC 3.0
%Cite

% A.J. Yuste-Delgado, A. Triviño, D. Diaz-Jimenez, J. C. Cuevas-Martinez,
%Centralized two tier clustering method for wireless sensor networks based
% on a coupled cascaded fuzzy system, Scientific Reports 16 (2025) 1871.
%doi:10.1038/s41598-025-31549-2.

function [FND, HND, LND ] = cascada_2_tier_sostenibilidad_mediana(x,y,x_max,y_max,n,stop,porcentaje_ch,porcentaje_sch,EBx,EBy,Eo,ETX,ERX,Efs,Eamp,EDA,packetSize,controlPacketSize,Eminima)

disp('CASCADA 2 TIER MEDIANA');

    rmax=9999; % default value of Initial Energy


%% Auxiliar variables

%Computation of do
do=sqrt(Efs/Eamp);



disp('EB');
disp([EBx,EBy]);
MAXCAM=sqrt(x_max^2+y_max^2);


nodos_vivos=1:n; %(alive nodes)
energias_nodos=ones(1,n)*Eo;


% para no tener que usar estructuras uso coordenadas x e ya
cx =[x EBx];
cy =[y EBy];

%Primero calculo todas las distancias entre los nodos y los introduzco en la matriz distancia
% con esto luego me sale más fácil encontrar el CH al que se conecta

%quito la EB
distancia = sqrt((cx(1:n) - cx(1:n)').^2 + (cy(1:n)-cy(1:n)').^2);

%distancias a la EB
d_a_EB = sqrt ( (cx(1:n) -cx(n+1)).^2 + (cy(1:n)- cy(n+1)).^2);

%Ahora normalizamos las distancias
	d_a_EB_norm= d_a_EB /max(d_a_EB);

%Envío del mensaje inicial de la estación base
%Sería un mensaje de control

energias_nodos= energias_nodos - disminuir_energia_recibir_mensaje(controlPacketSize,ERX);

	
%los nodos mandan un mensaje a la máxima distancia incluida la MAXCAM para que la EB y todos los nodos lean
%esto será muy negativo para algunos nodos que estén más cerca de la EB
%sobre todo cuanto la EB está fuera del rectángulo
 energias_nodos= energias_nodos - disminuir_energia_envio_mensaje(max(MAXCAM,d_a_EB),controlPacketSize,do,ETX,Eamp,Efs);

%además cada nodo deber recibir n-1 mensajes
energias_nodos= energias_nodos - (n-1)*disminuir_energia_recibir_mensaje(controlPacketSize,ERX);



%ahora vamos a buscar el número de vecinos o degree
% se mide en función de la distancia d0/2
sensado = do/2;

%para cada nodo se buscan las distancias menores a sensado

vecinos=zeros(n,1);
for i=1:length(nodos_vivos)
 vecinos(i)= sum(distancia(i,:) < sensado )- 1;
end

%normalizamos

vecinos = vecinos/max(vecinos);


%ahora nos queda la centralidad

%ahora hay que calcular la centralidad de 0 a 1
%se define como la distancia al centroide del cluster que es la salida del
%kmeans
 

clusteres_actuales = fix(n*porcentaje_ch)+1;
n_superch=fix(n*porcentaje_sch)+1;


[idx,centroides] = kmeans([cx;cy]',clusteres_actuales);
 centralidad=[];

 for i=1:clusteres_actuales
  nodos = (idx == i);
  centralidad = [centralidad (cx(nodos)- centroides(i,1)).^2 + (cy(nodos) - centroides(i,2)).^2];
 end
 
 %cuánto más pequeño es la centralidad mejor. Así que hay que invertir.
 centralidad = 1- centralidad/ max(centralidad);


dead=0;

FND=-1;
HND=-1;
LND=-1;



chance_ch = readfis('ch_cascada_1.fis');
chance_sch = readfis('sch_cascada_2.fis');

%cuantas más veces menos chance, empieza en uno para evitar dividir por cero 

veces_ch = ones(1,n);
veces_sch =ones(1,n);





r=0;



while r<=rmax

    
    if mod(r,500)==0
		disp([r length(nodos_vivos) dead FND HND LND min(energias_nodos(nodos_vivos))*100])
	end

	%primero eliminamos los nodos sin energía
    i=1;
	
    while (i<=length(nodos_vivos))
    %for i=1:length(nodos_vivos) Nodos vivos los voy eliminados en el bucle
    %por lo que no puede ser un for
        	
		
		if (energias_nodos(nodos_vivos(i))<=Eminima)
            fin_del_nodo(nodos_vivos(i))=r;
            
       %     clusteres_actuales = fix(length(nodos_vivos)*porcentaje_ch)+1;
        %    n_superch=fix(length(nodos_vivos)*porcentaje_sch);
                    %nombre=sprintf('FND_map_set%d_%.3d.mat',set,nmap);

            %energias_nodos(nodos_vivos(i))
			%eliminar el nodo vivo de la lista
			if (i==1)
				nodos_vivos=nodos_vivos(2:length(nodos_vivos));
                i=i-1;
			elseif i==length(nodos_vivos)
				nodos_vivos=nodos_vivos(1:length(nodos_vivos)-1);
                i=i-1;
			else
				nodos_vivos=[nodos_vivos(1:i-1) nodos_vivos(i+1:length(nodos_vivos))];
                i=i-1;
			end
			
			
			dead=dead+1;
            
			if (dead==1)
					FND=r;
            end
			if (dead==fix(n*0.5))
				HND=r;
       		end
	
        end
		
        i=i+1;
        
    end
    
	%comprobar que no se ha acabado
	if(n-dead<=n*stop)
		LND=r;
	break;
    end
     
    
			 
        %ahora calculamos el difuso con las variables para obtener los CH
        
        %centralidad;energia residual;vecinos;veces_ch;dEB

     %con distancia a la EB  
    %     chance =evalfis(chance_ch,[centralidad(nodos_vivos); energias_nodos(nodos_vivos)/Eo; vecinos(nodos_vivos)'; veces_ch(nodos_vivos)/max(veces_ch(nodos_vivos));d_a_EB_norm(nodos_vivos)])/110;
    %sin distancia a la EB

    clusteres_actuales =fix(n*porcentaje_ch)+1; %faltaba el +1 para estudios porcentajes

    chance =evalfis(chance_ch,[centralidad(nodos_vivos); energias_nodos(nodos_vivos)/Eo; vecinos(nodos_vivos)'; veces_ch(nodos_vivos)/max(veces_ch(nodos_vivos))]);
     

         indices_ch=1:length(nodos_vivos);

        %ahora comprobamos que los CH sean capaz al menos de aguantar 
        %un vez un nodo en la recepciones de mensajes
        
       ch_a_eliminar = energias_nodos(nodos_vivos) < disminuir_energia_recibir_mensaje(packetSize,ERX)+disminuir_energia_agregacion(packetSize,EDA) | energias_nodos(nodos_vivos) < median(energias_nodos(nodos_vivos));
       
        if (sum(ch_a_eliminar) >0)
            %eliminamos los que no aguanten
            indices_ch = indices_ch(ch_a_eliminar==0);
        end

    %  disp([length(indices_ch) min(energias_nodos(indices_ch)) max(energias_nodos(indices_ch)) median(energias_nodos) veces_ch(49) veces_sch(49) energias_nodos(49)]);
        %ahora los CH vendrán dados por clusteres_actuales, siempre los que
        %mejor chance tienen
 
        %ahora elegimos los mejores CH
        [chance_ordenados, indices_ch_ordenados]= sort(chance(indices_ch),'descend');
        

        %hay que tener en cuenta que puede que se eliminen muchos nodos
        if length(indices_ch_ordenados)<clusteres_actuales
            clusteres_actuales = length(indices_ch_ordenados);
        end

        indices_ch =indices_ch(indices_ch_ordenados(1:clusteres_actuales));

                
        veces_ch(nodos_vivos(indices_ch)) =veces_ch(nodos_vivos(indices_ch)) + 1;
        
        %ELIJAMOS LOS SUPERCH   
        %puede que no todos sean superCH porque vamos a poner la
        %restricción de separación al menos d0/factor
        
        n_superch=fix(n*porcentaje_sch)+1; 

        if (n_superch>clusteres_actuales)
            n_superch =clusteres_actuales;
        end

        
       sch_eleccion = evalfis(chance_sch,[chance(indices_ch)'; veces_ch(nodos_vivos(indices_ch))/max(veces_ch(nodos_vivos(indices_ch))); veces_sch(nodos_vivos(indices_ch))/max(veces_sch(nodos_vivos(indices_ch))); 1-d_a_EB_norm(nodos_vivos(indices_ch))]);
        
        %ahora elegimos los mejores SCH
        [sch_eleccion_ordenados, indices_ordenados]= sort(sch_eleccion,'descend');

        indices_superch = indices_ch(indices_ordenados(1:n_superch));

                veces_sch(nodos_vivos(indices_superch)) =veces_sch(nodos_vivos(indices_superch)) + 1;

        %LA estación base manda un mensaje con la información de los CH y
        %los SCH
        
        energias_nodos(nodos_vivos) = energias_nodos(nodos_vivos) - disminuir_energia_recibir_mensaje(controlPacketSize,ERX);
        
        
        for i=1:length(nodos_vivos)
            
           %primero vemos que no es ch
           ver_si_ch = nodos_vivos(i) == nodos_vivos(indices_ch);
           
           if sum(ver_si_ch) == 0
           
            %vemos las distancias entre el nodo y los clusteres
            d = distancia(nodos_vivos(i),nodos_vivos(indices_ch));
           
            [valor, ch_elegido]= min(d);
            ch_elegido = nodos_vivos(indices_ch(ch_elegido)); %ahora estará el índice en absoluto
            
            %ahora enviamos el dato al cluster
              energias_nodos(nodos_vivos(i)) = energias_nodos(nodos_vivos(i))- disminuir_energia_envio_mensaje(valor,packetSize,do,ETX,Eamp,Efs);
            %ahora el cluster recibe el dato y lo agrega
            energias_nodos(ch_elegido) = energias_nodos(ch_elegido)- disminuir_energia_recibir_mensaje(packetSize,ERX);
            energias_nodos(ch_elegido) = energias_nodos(ch_elegido) - disminuir_energia_agregacion(packetSize,EDA);
           end
           
        end
            
       %los CH mandan a su SCH
            for i=1:length(indices_ch)
            
               %primero vemos que no es Sch
               ver_si_super_ch = nodos_vivos(indices_ch(i)) == nodos_vivos(indices_superch);
           
               if sum(ver_si_super_ch) == 0
           
                %vemos las distancias entre el nodo y los clusteres
                d = distancia(nodos_vivos(indices_ch(i)),nodos_vivos(indices_superch));
           
                [valor, ch_elegido]= min(d);
                ch_elegido = nodos_vivos(indices_superch(ch_elegido)); %ahora estará el índice en absoluto
            
                %ahora enviamos el dato al cluster
                  energias_nodos(nodos_vivos(indices_ch(i))) = energias_nodos(nodos_vivos(indices_ch(i)))- disminuir_energia_envio_mensaje(valor,packetSize,do,ETX,Eamp,Efs);
                %ahora el cluster recibe el dato y lo agrega
                energias_nodos(ch_elegido) = energias_nodos(ch_elegido)- disminuir_energia_recibir_mensaje(packetSize,ERX);
                energias_nodos(ch_elegido) = energias_nodos(ch_elegido) - disminuir_energia_agregacion(packetSize,EDA);
               end
           
            
            end
       
	
	%%AHORA los super clusteres envían los datos a la EB
    
	for i=1:length(indices_superch)
    	energias_nodos(nodos_vivos(indices_superch(i)))=  energias_nodos(nodos_vivos(indices_superch(i))) -  disminuir_energia_envio_mensaje(d_a_EB(nodos_vivos(indices_superch(i))),packetSize,do,ETX,Eamp,Efs);	
	end
		
	r=r+1;

end %r
	
%cprintf('_red',['- FND=', num2str(FND),' HND=', num2str(HND),' LND=', num2str(LND) ]);

disp(['- FND=', num2str(FND),' HND=', num2str(HND),' LND=', num2str(LND) ]);
disp(' ');

end %function




function perdidas= disminuir_energia_envio_mensaje(distancia,longitud,do,ETX,Emp,Efs)


 if (distancia>do)
    perdidas=( ETX*(longitud) + Emp*longitud*(distancia.^4));
 else
    perdidas=( ETX*(longitud) + Efs*longitud*(distancia.^2)); 
 end

 end


function perdidas= disminuir_energia_recibir_mensaje(longitud,ERX)

 %%DEFINIR ETX ...
 
 %distancia = sqrt((xa-xb)^2+(ya-yb)^2);

 perdidas= ERX*longitud;
end

function perdidas= disminuir_energia_agregacion(longitud,EDA)

perdidas= longitud * EDA;

end


