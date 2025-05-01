clear;
close all;
clc;

GUI;

function y = custom_filter(b, a, x)
    % % Sprawdź czy wektory a i b mają równą długość
    % if length(b) ~= length(a)
    %     error('Wektory a i b muszą mieć tą samą długość.');
    % end
    % % Sprawdź czy pierwszy element a == 0
    % if a(1) ~= 1
    %     error('Pierwszy element wektoru musi mieć wartość 1');
    % end
    

    M = length(b);
    N = length(a);

    y = zeros(size(x));
    for n = 1:length(x)
        y_n = 0;
        for m = 1:M
            if n - m + 1 > 0
                y_n = y_n + b(m) * x(n - m + 1);
            end
        end
        for k = 2:N
            if n - k + 1 > 0
                y_n = y_n - a(k) * y(n - k + 1);
            end
        end

        % Znormalizować za pomocą a(1)
        y(n) = y_n / a(1);
    end
end

function GUI()
    % Stwórz nowe okno
    fig = figure('Name', 'Ratio Plotter', 'NumberTitle', 'off', 'Position', [100, 100, 600, 400]);

    % Elementy GUI
    elementWidth = 150;
    elementHeight = 25;
    verticalSpacing = 20;
    horizontalSpacing = 10;

    uicontrol('Style', 'text', 'String', 'Współczynniki b:', 'Position', [20, 350, elementWidth, elementHeight]);
    global editNumerator;
    editNumerator = uicontrol('Style', 'edit', 'Position', [20 + elementWidth + horizontalSpacing, 350, elementWidth, elementHeight]);

    uicontrol('Style', 'text', 'String', 'Współczynniki a:', 'Position', [20, 350 - verticalSpacing, elementWidth, elementHeight]);
    global editDenominator;
    editDenominator = uicontrol('Style', 'edit', 'Position', [20 + elementWidth + horizontalSpacing, 350 - verticalSpacing, elementWidth, elementHeight]);

    uicontrol('Style', 'text', 'String', 'Zakres:', 'Position', [20, 350 - 2 * verticalSpacing, elementWidth, elementHeight]);
    global editZakres;
    editZakres = uicontrol('Style', 'edit', 'Position', [20 + elementWidth + horizontalSpacing, 350 - 2 * verticalSpacing, elementWidth, elementHeight]);

    uicontrol('Style', 'text', 'String', 'Funkcja x(n):', 'Position', [20, 350 - 3 * verticalSpacing, elementWidth, elementHeight]);
    global editFunction;
    editFunction = uicontrol('Style', 'edit', 'Position', [20 + elementWidth + horizontalSpacing, 350 - 3 * verticalSpacing, elementWidth, elementHeight]);

    uicontrol('Style', 'pushbutton', 'String', 'Uruchom.', 'Position', [20, 80, elementWidth, elementHeight], 'Callback', @main);
end


function main(~, ~)
    global editNumerator;
    global editDenominator;
    global editZakres;
    global editFunction;

    % Pobierz wartości z pól tekstowych
    numeratorStr = get(editNumerator, 'String');
    denominatorStr = get(editDenominator, 'String');
    zakresStr = get(editZakres, 'String');
    functionStr = get(editFunction, 'String');

    % Przetwórz pobrane dane

    if isempty(numeratorStr)
        disp('Błąd: Współczynniki b nie mogą być pusty.');
        return;
    else
        numerator = str2num(numeratorStr);
    end

    if isempty(denominatorStr)
        disp('Uwaga: Nie podano współczynników b.');
        denominator = [zeros(1, length(numerator))];
        denominator(1) = 1;
        disp(['Uwaga: Współczynniki zostały ustawione jako: ', num2str(denominator)]);
    else
        denominator = str2num(denominatorStr);
    end

    if isempty(editZakres)
        disp('Uwaga: Zakres nie może być pusty.');
        return;
    else
        zakres = str2num(zakresStr);
    end
    
    n = 0:1:zakres;

    if isempty(functionStr)
        disp('Uwaga: Funkcja sygnału wejściowego nie może być pusta.')
    else
        try
            x = eval(functionStr);
        catch
            disp('Błąd: Nieprawidłowa funkcja.')
            return;
        end
    end
    
    % Obliczanie odpowiedzi systemu
    y = custom_filter(numerator, denominator, x);
    % Wizualizacja wyników
    
    figure; 

    % Sygnał wejściowy x[n]
    subplot(2, 1, 1);
    stem(n, x, 'r', 'LineWidth', 2, 'Marker', 'o');
    title('Sygnał Wejściowy x[n]');
    grid on;

    % Odpowiedź systemu y[n]
    subplot(2, 1, 2);
    stem(n, y, 'g', 'LineWidth', 2, 'Marker', 'o');
    title('Odpowiedź Systemu y[n]');
    grid on;

    xlabel('Indeks próbek');

end
