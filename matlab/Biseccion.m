function [r, N, xn, fm, E] = biseccion(f_str, xi, xs, Tol, niter, tipe)
    % Convertir la cadena de la función a una función manejable
    f = str2func(['@(x)' f_str]);

    % Evaluar la función en los extremos del intervalo
    fi = f(xi);
    fs = f(xs);
    
    % Inicializar las listas
    N_list = [];
    xn_list = [];
    fm = [];
    E = [];
    
    if fi == 0
        xn = xi;
        E = 0;
        r = sprintf('%f es raíz de f(x)', xi);
    elseif fs == 0
        xn = xs;
        E = 0;
        r = sprintf('%f es raíz de f(x)', xs);
    elseif fs * fi < 0
        N = 0;
        xm = (xi + xs) / 2;
        fm(N + 1) = f(xm);
        fe = fm(N + 1);
        N_list(N + 1) = N;
        xn_list(N + 1) = xm;
        E(N + 1) = Tol + 1;
        error = E(N + 1);
        
        while error > Tol && fe ~= 0 && N < niter
            if fi * fe < 0
                xs = xm;
                fs = f(xs);
            else
                xi = xm;
                fi = f(xi);
            end
            xa = xm;
            xm = (xi + xs) / 2;
            fm(N + 2) = f(xm);
            fe = fm(N + 2);
            N_list(N + 2) = N + 1;
            xn_list(N + 2) = xm;
            if strcmp(tipe, 'Cifras Significativas')
                E(N + 2) = abs(xm - xa) / abs(xm);
            else
                E(N + 2) = abs(xm - xa);
            end
            error = E(N + 2);
            N = N + 1;
        end
        
        if fe == 0
            xn = xm;
            r = sprintf('%f es raíz de f(x)', xm);
        elseif error < Tol
            xn = xm;
            r = sprintf('%f es una aproximación de una raíz de f(x) con una tolerancia = %f', xm, Tol);
        else
            xn = xm;
            r = sprintf('Fracasó en %d iteraciones', niter);
        end
    else
        xn= xm;
        r = sprintf('El intervalo es inadecuado');
    end

    % Asignar las listas de iteración y resultados
    N = N_list;
    xn = xn_list;

    % Guardar la tabla de resultados en un archivo CSV
    currentDir = fileparts(mfilename('fullpath'));
    tablesDir = fullfile(currentDir, '..', 'app', 'tables');
    mkdir(tablesDir);
    csv_file_path = fullfile(tablesDir, 'tabla_biseccion.csv');
    T = table(N', xn', fm', E', 'VariableNames', {'Iteration', 'xn', 'fxn', 'E'});
    writetable(T, csv_file_path);

    % Crear y guardar la gráfica de resultados
    fig = figure('Visible', 'off');
    xplot = linspace(min(xn) - 5, max(xn) + 5, 1000);
    hold on;
    yline(0);
    plot(xplot, f(xplot));
    scatter(xn(end), f(xn(end)), 'r', 'filled');
    img = getframe(gcf);
    staticDir = fullfile(currentDir, '..', 'app', 'static');
    mkdir(staticDir);
    imgPath = fullfile(staticDir, 'grafica_biseccion.png');
    imwrite(img.cdata, imgPath);
    hold off;
    close(fig);
end
