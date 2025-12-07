clc; clear; close all;

% Параметры модели
lambda = 1e5;
d = 0.1;
a = 0.5;
beta = 2e-7;
k = 100;
u = 5;

% Начальные условия
x0 = 1e6;
y0 = 0;
v0 = 10;
y_init = [x0; y0; v0];

% Время моделирования (например, 0–50 дней)
tspan = [0 50];

% Система ODE
f = @(t,y) [
    lambda - d*y(1) - beta*y(1)*y(3);   % dx/dt
    beta*y(1)*y(3) - a*y(2);            % dy/dt
    k*y(2) - u*y(3)                     % dv/dt
];

% Численное решение
[t, Y] = ode45(f, tspan, y_init);

% Построение графика
figure;
plot(t, Y(:,1), 'LineWidth', 2); hold on;
plot(t, Y(:,2), 'LineWidth', 2);
plot(t, Y(:,3), 'LineWidth', 2);
legend('x(t) — здоровые клетки', 'y(t) — инфицированные клетки', 'v(t) — вирус', 'Location', 'best');
xlabel('t (дни)');
ylabel('Количество');
title('Динамика модели ВИЧ-1');
grid on;

% Сохранение графика
filename = ['practice_3_1_', num2str(i), '.png'];
saveas(gcf, filename);
