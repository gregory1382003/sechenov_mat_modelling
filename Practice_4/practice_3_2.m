clear; clc; close all;

% Параметры
lambda = 1e5;
d = 0.1;
a = 0.5;
beta = 2e-7;
k = 100;
u = 5;

% Начальные условия
X = 1e6;
Y = 0;
V = 10;

state = [X; Y; V];
t = 0;
tmax = 50;

% Матрица событий из вашего слайда
M = [ 1  -1  -1   0   0   0;
      0   0   1  -1   0   0;
      0   0   0   0   1  -1 ];

T = t;
S = state';

while t < tmax

    % === 1. Интенсивности (propensities) ===
    nu = [
        lambda;
        d * state(1);
        beta * state(1) * state(3);
        a * state(2);
        k * state(2);
        u * state(3)
    ];

    nu0 = sum(nu);
    if nu0 <= 0
        break;
    end

    % === 2. Время до следующего события ===
    r1 = rand();
    tau = -log(r1)/nu0;

    t = t + tau;
    if t > tmax
        break;
    end

    % === 3. Выбор события ===
    r2 = rand() * nu0;
    cum = cumsum(nu);
    j = find(cum >= r2, 1);

    % === 4. Обновление состояния ===
    state = state + M(:,j);
    state = max(state,0); % защита

    % === 5. Запись ===
    T(end+1) = t;
    S(end+1,:) = state';
end

% График
figure; 
plot(T, S(:,1)); hold on;
plot(T, S(:,2));
plot(T, S(:,3));
legend('X','Y','V');
xlabel('t'); ylabel('Counts');
title('Gillespie SSA траектория');