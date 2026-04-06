clc; clear;

alphabet = ['0':'9', 'a':'z'];
N = 1000;

idx_random = randi([1, length(alphabet)], 1, N);
text_random = alphabet(idx_random);

weights = [ones(1, 5)*10, ones(1, length(alphabet)-5)]; 
idx_weighted = randsample(1:length(alphabet), N, true, weights);
text_weighted = alphabet(idx_weighted);

[dict_r, encoded_r, avgLen_r] = huffman_process(text_random, alphabet);

[dict_w, encoded_w, avgLen_w] = huffman_process(text_weighted, alphabet);

disp('--- PRZYKŁADOWY SŁOWNIK (LOSOWY) ---');
disp(dict_r(1:10,:)); % pierwsze 10 symboli

disp('--- PRZYKŁADOWY SŁOWNIK (WAŻONY) ---');
disp(dict_w(1:10,:));

fprintf('--- ANALIZA WYNIKÓW KODOWANIA HUFFMANA ---\n\n');

bits_per_char_fixed = ceil(log2(length(alphabet)));
bits_original = N * bits_per_char_fixed;

fprintf('%-25s | %-15s | %-15s | %-25s\n', 'Typ danych', 'Bity wejściowe', 'Bity Huffman', 'Kompresja [%]');
fprintf('%s\n', repmat('-', 1, 75));

comp_r = (1 - length(encoded_r)/bits_original) * 100;
fprintf('%-25s | %-15d | %-15d | %-15.2f%%\n', 'Ciąg losowy', bits_original, length(encoded_r), comp_r);

comp_w = (1 - length(encoded_w)/bits_original) * 100;
fprintf('%-25s | %-15d | %-15d | %-15.2f%%\n', 'Tekst zróżnicowany', bits_original, length(encoded_w), comp_w);

fprintf('\nInterpretacja:\n');
fprintf('Średnia długość kodu (losowy): %.2f bitów/znak\n', avgLen_r);
fprintf('Średnia długość kodu (tekst):  %.2f bitów/znak\n', avgLen_w);

function [dict, encoded, avgLen] = huffman_process(input_text, ~)
 
    symbols_cell = cellstr(input_text');
    
    unique_symbols = unique(symbols_cell);
    
    counts = histcounts(categorical(symbols_cell), categorical(unique_symbols));
    probs = counts / sum(counts);
    
    dict = huffmandict(unique_symbols, probs);
    encoded = huffmanenco(symbols_cell, dict);
    
    avgLen = length(encoded) / length(input_text);

    decoded = huffmandeco(encoded, dict);

    if isequal(symbols_cell, decoded)
        disp('Dekodowanie poprawne');
    else
        disp('Błąd dekodowania');
    end
end
