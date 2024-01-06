funcion_str = input('Ingrese la función.\nSugerencia:cos(4*x)\nf(x): ', 's');
f = str2func(['@(x) ', funcion_str]);
h= 0.00001;

df_0 = (f(0+h) - f(0))/(h);
if abs(df_0) > 0.01
    error('NO SE CUMPLEN LA CONDICIONES NECESARIAS. f´(0)!=0'); 
end

df_pi = (f(pi+h) - f(pi))/(h);
if abs(df_pi) > 0.01
    error('NO SE CUMPLEN LA CONDICIONES NECESARIAS. f´(pi)!=0'); 
end

N = 50;

x_valores = linspace(0, 6, 100);
t_valores = linspace(0, 8, 35);

% Precalcular todos los valores de u(x, ti)
u_valores = zeros(length(x_valores), length(t_valores));
% Imprimo arcadores para saber el estado de la ejecucion
fprintf('    Inicio|');
for i = 1:length(t_valores)
    fprintf(' ');
end
fprintf('|Fin\n'); 
fprintf('Calculando:');
for i = 1:length(t_valores)
    u_valores(:, i) = arrayfun(@(x) u(x, t_valores(i), N, f), x_valores);
    fprintf('.');
end
fprintf('\n'); 

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
    intgrand0 = @(z) f(z);
    c0 = 1/pi*integral(intgrand0, 0, pi);
    integrand1 = @(z) f(z) .* cos(z);
    c1 = 2/pi*integral(integrand1, 0, pi);
    suma = c0 + c1 .* cos(x) .* exp(-t) .* (1 + t);

    for n = 2:N
        integrand = @(z) f(z) .* cos(n .*z);
        cn = 2/pi*integral(integrand, 0, pi);
        betan = sqrt(n^2 - 1);
        termino = cn .* cos(n.*x) .* exp(-t) .* (cos(betan .* t) + 1./betan .* sin(betan .* t));
        suma = suma + termino;
    end

    resultado = suma;
end