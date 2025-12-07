% practice 1 task 2
% Решение y'(t) = y(t-1) + y'(t-1), y(t)=1 for t in [-1,0]
% Численное решение с ddensd и сравнение с аналитическим (piecewise polynomials)

function neutral_dde_example
    % Параметры
    tspan = [0 5];
    dely  = 1;  % постоянная задержка для y(t-1)
    delyp = 1;  % постоянная задержка для y'(t-1)

    % История (константа 1 на [-1,0]) — можно передать как скаляр или в виде функции
    history = 1;

    % Вызов решателя ddensd (нейтральный тип)
    sol = ddensd(@ddefun, dely, delyp, history, tspan);

    % Точки для отображения
    tn = linspace(tspan(1), tspan(2), 500);
    yn_num = deval(sol, tn);      % численное решение

    % Аналитическое решение (функция-обёртка для кускового решения)
    yn_analytic = arrayfun(@analytic_y, tn);

    % График
    figure;
    plot(tn, yn_num, 'LineWidth', 1.6); hold on;
    plot(tn, yn_analytic, '--', 'LineWidth', 1.2);
    xlabel('t');
    ylabel('y(t)');
    title('Решение нейтрального DDE: численное (ddensd) и аналитическое');
    legend('ddensd numeric','analytic (piecewise)', 'Location','Best');
    grid on;
    xlim(tspan);

    % Сохранение графика
    saveas(gcf, 'practice_1_2.png');
end

% --- ddefun: правая часть y'(t) = f(t,y, y(dy), y''(dyp) )
function yp = ddefun(t, y, ydel, ypdel)
    % Для нашей задачи: yp = y(t-1) + y'(t-1)
    % Здесь ydel и ypdel приходят как матрицы; при одном уравнении это скаляры.
    % В общем случае использовать ydel(:,i), ypdel(:,j).
    yp = ydel + ypdel;  % т.к. оба одномерные
end

% --- Аналитическая кусочная функция, возвращает y(t) по формулам выше
function y = analytic_y(t)
    if t < 0
        y = 1; return;
    end
    if t <= 1
        y = 1 + t;
    elseif t <= 2
        y = t.^2/2 + t + 1/2;
    elseif t <= 3
        y = t.^3/6 + t.^2/2 + 7/6;
    elseif t <= 4
        y = t.^4/24 + t.^3/6 - t.^2/4 + t + 37/24;
    else % 4 < t <=5 (и далее, по необходимости)
        y = t.^5/120 + t.^4/24 - t.^3/6 + 5*t.^2/12 + 2*t - 13/40;
    end
end