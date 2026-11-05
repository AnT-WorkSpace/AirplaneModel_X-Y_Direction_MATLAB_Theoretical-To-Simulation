%% Parameters for Aircraft Take-Off Model (2D)

% --- Common Physical Parameters ---
F_prop = 30000;   % Propulsive engine thrust [N]
m      = 5000;    % Total aircraft mass [kg]
g      = 9.81;    % Gravitational acceleration [m/s^2]
c_L    = 0.8;     % Lift force coefficient [-]
rho_A  = 1.2;     % Ambient air density [kg/m^3]

% --- X-Direction Parameters ---
c_dx   = 0.3;     % Drag coefficient in x-direction [-]
mu     = 0.01;    % Rolling friction coefficient [-]
A_x    = 10;      % Frontal cross-sectional area [m^2]

% --- Y-Direction Parameters ---
c_dy   = 0.5;     % Drag coefficient in y-direction [-]
A_y    = 30;      % Planform/vertical cross-sectional area [m^2]

%% Dynamic Force Balance Equations (Symbolic / Vectorized)

% --- Y-Direction Forces ---
F_gravityy  = m * g                                                    % Gravitational force [N]
F_lift      = 0.5 * rho_A * c_L * A_x * velocity.^2                    % Aerodynamic lift force [N]
F_normal    = max(F_gravityy - F_lift, 0)                              % Ground reaction force [N]
F_ARy       = 0.5 * rho_A * c_dy * A_y * velocity.^2.* sign(velocity)  % Vertical aerodynamic drag [N]
F_Iny       = m * acceleration                                         % Inertial force(d'Alembert intertial force in Y-direction) [N]

% Net Force Y-Direction
F_netY      = F_normal + F_lift - F_ARy - F_gravityy - F_Iny           % Net force balance y-axis [N]
 
% --- X-Direction Forces ---
F_ARx       = 0.5 * rho_A * c_dx * A_x * velocity.^2.* sign(velocity)  % Horizontal aerodynamic drag [N]
F_frictionx = mu * F_normal .* sign(velocity)                          % Rolling friction force [N]
F_Inx       = m * acceleration                                         % Inertial force (d'Alembert intertial force in X-direction) [N]

% Net Force X-Direction
F_netX      = F_prop - F_ARx - F_frictionx - F_Inx                     % Net force balance x-axis [N]
