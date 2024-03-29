clear;

%--------------------------------------------------------------------------
%EJERCICIO 1
%--------------------------------------------------------------------------
fprintf('EJERCICIO 1\n'); 
f = @(x) sin(pi*x) + sin(2*pi*x);
g = @(x) x*0;

%Apartado c
[u_aprox, x_valores, t_valores] = aprox(1, 1/2, 2, f, g, 1/10, 5/100);
fprintf('Valores aproximados de u:\n'); 
disp(flipud(u_aprox'));

%Apartado e
u = @(x,t) sin(pi*x)*cos(2*pi*t) + sin(2*pi*x)*cos(4*pi*t);
[errors, error_medio] = errores(u, u_aprox, x_valores, t_valores);
fprintf('Errores absolutos cometidos:\n');
disp(flipud(errors'));
fprintf('Error medio cometido:'); 
disp(error_medio);

%Apartado f
representa(u_aprox, x_valores, t_valores);

%--------------------------------------------------------------------------
%EJERCICIO 2
%--------------------------------------------------------------------------
fprintf('EJERCICIO 2\n'); 
f = @(x) (0 <= x & x <= 3/5).* x + (3/5 < x & x <= 1).* (3/2-3/2*x);
g = @(x) x*0;

%Apartado c
[u_aprox, x_valores, t_valores] = aprox(1, 1/2, 2, f, g, 1/10, 5/100);
fprintf('Valores aproximados de u:\n'); 
disp(flipud(u_aprox'));

%Apartado d
representa(u_aprox, x_valores, t_valores);



function [res, x_valores, t_valores] = aprox(a, b, c, f, g, h, k)
    r=c*k/h;
    if r > 1
        error('El método no es estable ya que r>1');
    end
    
    x_valores = 0:h:a;
    t_valores = 0:k:b;
    f_valores = f(x_valores);
    g_valores = g(x_valores);
    
    res = zeros(length(x_valores), length(t_valores));
    res(:, 1) = f_valores;
    for i=2:length(x_valores)-1
        res(i,2)=(1-r^2)*f_valores(1) + k*g_valores(i) + r^2/2*(f_valores(i+1)+f_valores(i-1));
    end

    for j=2:length(t_valores)
        for i=2:length(x_valores)-1
            res(i,j+1)=(2-2*r^2)*res(i,j)+r^2*(res(i+1,j)+res(i-1,j))-res(i, j-1);
        end
    end
    
end

function [res, error_medio] = errores(u, u_aprox, x_valores, t_valores)
    res = zeros(size(u_aprox));
    error_medio  = 0;
    cont = 0;
    for i=1:length(x_valores)
        for j=1:length(t_valores)
            error_ij = abs(u_aprox(i,j)-u(x_valores(i), t_valores(j)));
            error_medio = error_medio + error_ij;
            cont = cont + 1;
            res(i,j)=error_ij;
        end
    end
    error_medio = error_medio/cont;
end

function representa(u_aprox, x_valores, t_valores)
    figure;
    h = plot(x_valores, u_aprox(:, 1));
    axis([0, x_valores(end), min(min(u_aprox)), max(max(u_aprox))]);
    title(['t=', num2str(t_valores(1))]);

    %Se va reproducir 3 veces
    for cont=1:3
        for i = 1:length(t_valores)
            set(h, 'XData', x_valores, 'YData', u_aprox(:, i));
            title(['t=', num2str(t_valores(i))]);
            if i == 1
                pause(1.5);
            else
                pause(0.1);
            end
        end
    end
end

% Representa la gráfica en 3D
function representa3D(x,y,z)
    figure;
    [X,Y] = meshgrid(x,y);
    surf(X,Y,z');
    xlabel('x');
    ylabel('t');
    zlabel('u(x,y)');
    hold off;
end





