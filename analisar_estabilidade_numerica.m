%% SCRIPT 3: ANÁLISE DE ESTABILIDADE NUMÉRICA

clc;
disp('Iniciando Script 3: Análise de Estabilidade Numérica...');

%% 1. Verificar se A_lin existe no Workspace
if ~exist('A_lin', 'var')
    error(['A matriz simbólica ''A_lin'' não foi encontrada no workspace. ' ...
           'Por favor, execute o script ''calcular_matrizes_linearizadas.m'' PRIMEIRO.']);
end
disp('Matriz A_lin encontrada no workspace.');

%% 2. Definir Parâmetros Simbólicos
% (Precisamos redeclará-los para o MATLAB saber o que substituir)
syms mC mG mP JC K C a b c d g

%% 3. Definir Parâmetros Numéricos (da Tabela 2.2)
disp('Carregando parâmetros numéricos da Tabela 2.2...');

% Massas e Inércia
val_mC = 4400;     % Massa do Chassi (kg) 
val_mG = 200;      % Massa do Garfo (kg) 
val_mP = 2500;     % Massa da Carga (kg) 
val_JC = 3500;     % Momento de Inércia (kg*m^2) 

% Geometria
val_a = 0.5;       % Dist. CG Garfo ao Vínculo (m) 
val_b = 0.82;      % Dist. CG Chassi ao Mastro (m) 
val_c = 0.72;      % Dist. CG Chassi ao Eixo Diant. (m) 
val_d = 1.08;      % Dist. CG Chassi ao Eixo Tras. (m) 

% Suspensão (por roda)
val_K = 175000;    % Rigidez (N/m) 
val_C = 8300;      % Amortecimento (N*s/m) 

% Constante
val_g = 9.81;      % Gravidade (m/s^2) 

%% 4. Criar Listas de Substituição
% Lista de todas as variáveis simbólicas
vars_sym = [mC, mG, mP, JC, K, C, a, b, c, d, g];

% Lista de todos os valores numéricos correspondentes
vars_num = [val_mC, val_mG, val_mP, val_JC, val_K, val_C, val_a, val_b, val_c, val_d, val_g];

%% 5. Substituir Valores e Calcular Autovalores
disp('Substituindo valores numéricos na Matriz A_lin...');
% 'subs' troca os símbolos (vars_sym) pelos números (vars_num)
A_num_sym = subs(A_lin, vars_sym, vars_num);

% 'double' converte a matriz simbólica final em uma matriz numérica
A_num = double(A_num_sym);

disp('Calculando os autovalores (polos) de A_num...');
autovalores = eig(A_num);

%% 6. Exibir os Resultados
disp('--------------------------------------------------');
disp('ANÁLISE DE ESTABILIDADE (SEÇÃO 2.6)');
disp('--------------------------------------------------');
disp('Matriz A Numérica (Baseline Model):');
disp(A_num);

disp('Autovalores (Polos) do Sistema:');
disp(autovalores);