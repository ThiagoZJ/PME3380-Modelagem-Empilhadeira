clear;
clc;
close all;

%% 1. Obter o Modelo Não-Linear
disp('Carregando o modelo não-linear f(x,u)...');
% x_vec = [h; y; theta; h_dot; y_dot; theta_dot]
% u_var = u
[x_vec, u_var, f_xu, params_list] = define_modelo_nao_linear();

%% 2. Calcular Matrizes Jacobianas Simbólicas
% Este é o núcleo da Seção 2.5
disp('Calculando Jacobiano A = df/dx...');
A_sym = jacobian(f_xu, x_vec);

disp('Calculando Jacobiano B = df/du...');
B_sym = jacobian(f_xu, u_var);

disp('Jacobianos simbólicos A e B calculados.');

%% 3. Definir o Ponto de Equilíbrio (da Seção 2.4)
disp('Definindo o ponto de equilíbrio (x_bar, u_bar)...');

% Precisamos de alguns parâmetros simbólicos para definir o equilíbrio
syms h0 mG mP mC g K
m_gp = mG + mP;
m_total = m_gp + mC;

% Ponto de equilíbrio para u
u_bar = m_gp * g;

% Ponto de equilíbrio para x
y_bar = -(m_total * g) / (4*K);
x_bar = [ h0;      % h_bar (h0 qualquer)
          y_bar;   % y_bar (y_estatico)
          0;       % theta_bar
          0;       % h_dot_bar
          0;       % y_dot_bar
          0        % theta_dot_bar
        ];

%% 4. Linearizar: Substituir o Ponto de Equilíbrio nos Jacobianos
disp('Linearizando (substituindo o ponto de equilíbrio)...');

% Lista de variáveis originais para substituição
vars_originais = [x_vec; u_var];
% Lista de valores de equilíbrio para substituição
valores_equilibrio = [x_bar; u_bar];

% Substituir em A
A_lin = subs(A_sym, vars_originais, valores_equilibrio);

% Substituir em B
B_lin = subs(B_sym, vars_originais, valores_equilibrio);

disp('Substituição completa. Simplificando matrizes...');

% Simplificar as expressões algébricas
A_lin = simplify(A_lin);
B_lin = simplify(B_lin);

%% 5. Exibir os Resultados Finais
disp('--------------------------------------------------');
disp('MATRIZES DO SISTEMA LINEARIZADO (A, B, C, D)');
disp('--------------------------------------------------');

disp('Matriz de Estado A (Linearizada):');
pretty(A_lin)

disp('Matriz de Entrada B (Linearizada):');
pretty(B_lin)

% Matrizes C e D (saídas = posições [h; y; theta])
disp('Matriz de Saída C:');
I3 = sym(eye(3));
O3 = sym(zeros(3,3));
C_ss = [ I3, O3 ];
pretty(C_ss)

disp('Matriz D:');
D_ss = sym(zeros(3,1));
pretty(D_ss)