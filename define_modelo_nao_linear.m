function [x_vec, u_var, f_xu, params_list] = define_modelo_nao_linear()
%% 1. Definir Parâmetros Simbólicos
disp('Definindo parâmetros simbólicos...');
syms mG mP mC JC K C a b c d g
params_list = [mG mP mC JC K C a b c d g];

%% 2. Definir Variáveis de Estado e Entrada
disp('Definindo variáveis de estado e entrada...');
% Coordenadas generalizadas (posições)
syms h y theta
q = [h; y; theta];

% Velocidades generalizadas
syms h_dot y_dot theta_dot
q_dot = [h_dot; y_dot; theta_dot];

% Vetor de estado x = [q; q_dot]
x_vec = [q; q_dot]; 

% Variável de entrada u (Fm)
syms u
u_var = u;

%% 3. Definir Componentes do Modelo Não-Linear (da Seção 2.3.6)
disp('Construindo modelo não-linear f(x,u)...');

% Matriz de Massa M (constante)
m_gp = mG + mP;
M = [ m_gp,  m_gp,  -m_gp*b;
        0,    mC,       0;
        0,     0,       JC   ];

% Vetor de Amortecimento c(q_dot)
% Note que usamos as variáveis simbólicas (y_dot, theta_dot)
c_vec = [ 0;
          4*C*y_dot + 2*C*(c-d)*theta_dot;
          2*C*(d-c)*y_dot + 2*C*(c^2+d^2)*theta_dot ];

% Vetor de Rigidez k(q) (NÃO-LINEAR)
% Esta é a mudança crucial: usamos sin(theta)
k_vec = [ 0;
          4*K*y + 2*K*(c-d)*sin(theta);
          2*K*(d-c)*y + 2*K*(c^2+d^2)*sin(theta) ];

% Vetor de Forças f(u, g)
f_vec = [ u - m_gp*g;
         -u - mC*g;
          u*(b-a)    ];

%% 4. Isolar Acelerações (q_dot_dot)
% q_dot_dot = M_inv * (f_vec - c_vec - k_vec)
disp('Invertendo M e isolando acelerações...');
M_inv = inv(M);
q_dot_dot = M_inv * (f_vec - c_vec - k_vec);

%% 5. Construir a Função de Estado Não-Linear f(x, u)
% f_xu = [q_dot; q_dot_dot]
f_xu = [ h_dot;
         y_dot;
         theta_dot;
         q_dot_dot(1);
         q_dot_dot(2);
         q_dot_dot(3) ];

disp('Função não-linear f(x,u) definida com sucesso.');

end