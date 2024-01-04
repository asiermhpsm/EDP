funcion_str = input('Ingrese la función f(x): ', 's');
f = str2func(['@(x) ', funcion_str]);
N = 30;

x_valores = linspace(0, 6, 50);
t_valores = linspace(0, 8, 50);

% Precalcular todos los valores de u(x, ti)
u_valores = zeros(length(x_valores), length(t_valores));

for i = 1:length(t_valores)
    u_valores(:, i) = arrayfun(@(x) u(x, t_valores(i), N, f), x_valores);
    disp(i);
end

figure;
h = plot(x_valores, u_valores(:, 1));
axis([0, 6, min(min(u_valores)), max(max(u_valores))]);
title(['t=', num2str(t_valores(1))]);

while true
    for i = 1:length(t_valores)
        set(h, 'XData', x_valores, 'YData', u_valores(:, i));
        title(['t=', num2str(t_valores(i))]);
        pause(0.1);
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
