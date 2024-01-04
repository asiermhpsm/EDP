funcion_str = input('Ingrese la función.\nSugerencia:-cos(pi*x/3)+1\nf(x): ', 's');
f = str2func(['@(x) ', funcion_str]);

if f(0)~=0
    error('NO SE CUMPLEN LA CONDICIONES NECESARIAS. f(0)!=0'); 
end
h= 0.00001;
df_6 = (f(6+h) - f(6))/(h);
if abs(f(6)- df_6) > h
    error('NO SE CUMPLEN LA CONDICIONES NECESARIAS. f(6)!=f´(6)'); 
end

N = 50;
numero_valores = 50;

x_valores = linspace(0, 6, numero_valores);
t_valores = linspace(0, 8, numero_valores);

% Precalcular todos los valores de u(x, ti)
u_valores = zeros(length(x_valores), length(t_valores));
fprintf('Calculando: ');
for i = 1:length(t_valores)
    u_valores(:, i) = arrayfun(@(x) u(x, t_valores(i), N, f), x_valores);
    fprintf('.');
end
fprintf('Fin\n'); 

figure;
h = plot(x_valores, u_valores(:, 1));
axis([0, 6, min(min(u_valores)), max(max(u_valores))]);
title(['t=', num2str(t_valores(1))]);

while true
    for i = 1:length(t_valores)
        set(h, 'XData', x_valores, 'YData', u_valores(:, i));
        title(['t=', num2str(t_valores(i))]);
        if i == 1
            pause(2);
        else
            pause(0.1);
        end
    end
end

function resultado = u(x, t, N, f)
    suma = 0;

    for n = 0:N
        integrand = @(z) f(z) ./ exp(z) .* sin((1+2*n)*pi/12 .*z);
        cn = 1/3*integral(integrand, 0, 6);
        termino = cn .* exp(x) .* sin((1+2*n)*pi/12 .*x) .* exp(-(1+((1+2*n)*pi/12)^2).*t);
        suma = suma + termino;
    end

    resultado = suma;
end
