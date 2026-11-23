classdef AdaptiveAttitudeEstimator < handle
    % Two-state Chapter 8 attitude EKF with retained state and covariance.
    % x = [phi; theta] in rad, P is 2-by-2.
    % Constructor takes the existing EST.attitude_ekf Q/R and MAV.g.
    % Q enters P_dot exactly as in Estimation/Attitude EKF/Predict.
    %
    % step inputs are fixed-size real doubles:
    %   gyro (3,1)  body [p; q; r], rad/s
    %   accel (3,1) body accelerometer measurement, m/s^2
    %   Va (1,1)    airspeed, m/s
    %   dtGyro      elapsed time between gyro samples, seconds
    % gyroNew and accelNew are scalar logical new-sample flags per call.
    % Consecutive true flags each process a sample.
    % Accel sample times must align with gyro sample times in this version.
    % Pass dtGyro = 0 for a first gyro sample without an elapsed interval.
    %
    % Outputs are x (2,1), P (2,2), innovationAccel (3,1), and a
    % scalar logical correctionApplied. Innovation is accel - h(x,u)
    % for this tick's correction, or zeros(3,1) when correction is absent.

    properties (Access = private)
        x (2,1) double = zeros(2,1)
        P (2,2) double = zeros(2,2)
        Q (3, 3) double = zeros(3, 3)
        R (3,3) double = zeros(3,3)
        g (1,1) double = 9.80665
        gamma (1,1) double = 0
        alpha (1,1) double = 0
        beta (1,1) double = 0
        R_max (3,3) double = zeros(3,3)
        R_norm (3,3) double = zeros(3,3)
    end
    properties (Access = public)
        diagnostics (1, 1) struct = struct()
    end

    methods
        function obj = AdaptiveAttitudeEstimator(xInit, PInit, Q, R, g, gamma, alpha, beta, R_max)
            arguments
                xInit (2,1) double {mustBeReal, mustBeFinite}
                PInit (2,2) double {mustBeReal, mustBeFinite}
                Q (3, 3) double {mustBeReal, mustBeFinite}
                R (3,3) double {mustBeReal, mustBeFinite}
                g (1,1) double {mustBeReal, mustBeFinite}
                gamma (1,1) double {mustBeReal, mustBeFinite}
                alpha (1,1) double {mustBeReal, mustBeFinite}
                beta (1,1) double {mustBeReal, mustBeFinite}
                R_max (3,3) double {mustBeReal, mustBeFinite}

            end
            obj.x = xInit;
            obj.P = PInit;
            obj.Q = Q;
            obj.R = R;
            obj.g = g;
            obj.gamma = gamma;
            obj.alpha = alpha;
            obj.beta = beta;
            obj.R_max = R_max;
            obj.R_norm = R;
            obj.diagnostics = struct( ...
                'R_prev', obj.R, ...
                'R_adp',  obj.R, ...
                'K', zeros(2, 3));
        end

        function [x, P, innovationAccel, correctionApplied, dx] = step( ...
                obj, gyro, accel, Va, gyroNew, accelNew, dtGyro)
            arguments
                obj
                gyro (3,1) double {mustBeReal, mustBeFinite}
                accel (3,1) double {mustBeReal, mustBeFinite}
                Va (1,1) double {mustBeReal, mustBeFinite}
                gyroNew (1,1) logical
                accelNew (1,1) logical
                dtGyro (1,1) double {mustBeReal, mustBeFinite, mustBeNonnegative}
            end
            innovationAccel = zeros(3,1);
            correctionApplied = false;
            dx = zeros(2, 1);

            if gyroNew
                [obj.x, obj.P] = obj.predict(gyro, dtGyro);
            end
            if accelNew
                [obj.x, obj.P, innovationAccel, dx] = obj.update(accel, [gyro; Va]);
                correctionApplied = true;
            end

            x = obj.x;
            P = obj.P;

            
        end
    end

    methods (Access = private)
        function [xPred, PPred] = predict(obj, gyro, dt)
            x = obj.x;
            P = obj.P;
            xPred = x;
            PPred = P;
            if dt == 0
                return
            end

            % Estimation/Attitude EKF/Predict: f(x,u), J_fx, predict step.
            sPhi = sin(x(1));
            cPhi = cos(x(1));
            tTheta = tan(x(2));
            cTheta = cos(x(2));

            dotX = zeros(2,1);
            dotX(1) = gyro(1) + gyro(2)*sPhi*tTheta + gyro(3)*cPhi*tTheta;
            dotX(2) = gyro(2)*cPhi - gyro(3)*sPhi;

            A = zeros(2,2);
            A(1,1) = gyro(2)*cPhi*tTheta - gyro(3)*sPhi*tTheta;
            A(1,2) = (gyro(2)*sPhi + gyro(3)*cPhi) / cTheta^2;
            A(2,1) = -gyro(2)*sPhi - gyro(3)*cPhi;

            xPred = x + dt*dotX;
            T_2x3 = [1, sPhi*tTheta, cPhi*tTheta; ...
                    0, cPhi, -sPhi];
            PPred = P + (A*P + P*A' + T_2x3 * obj.Q * T_2x3.')*dt;
            PPred = 0.5*(PPred + PPred');
        end

        function [xUpdate, PUpdate, innovationAccel, dx] = update(obj, accel, u)
            % Estimation/Attitude EKF/Update: h(x,u), J_hx, update step.
            x = obj.x;
            P = obj.P;
            g = obj.g;
            sTheta = sin(x(2));
            cTheta = cos(x(2));
            sPhi = sin(x(1));
            cPhi = cos(x(1));

            h = zeros(3,1);
            h(1) = u(2)*u(4)*sTheta + g*sTheta;
            h(2) = u(3)*u(4)*cTheta - u(1)*u(4)*sTheta - g*cTheta*sPhi;
            h(3) = -u(2)*u(4)*cTheta - g*cTheta*cPhi;

            C = zeros(3,2);
            C(1,2) = u(2)*u(4)*cTheta + g*cTheta;
            C(2,1) = -g*cTheta*cPhi;
            C(2,2) = -u(3)*u(4)*sTheta - u(1)*u(4)*cTheta + g*sPhi*sTheta;
            C(3,1) = g*cTheta*sPhi;
            C(3,2) = u(2)*u(4)*sTheta + g*cPhi*sTheta;


            S = C*P*C' + obj.R;
            L = P*C' / S;

            innovationAccel = accel - h;
            dx = L * innovationAccel;

            obj.diagnostics.R_prev = obj.R;
            
            obj.adaptRacc(accel, innovationAccel);
            obj.diagnostics.R_adp = obj.R;
            obj.diagnostics.K = L;
            
            PUpdate = (eye(2) - L*C)*P;
            PUpdate = 0.5*(PUpdate + PUpdate');
            xUpdate = x + dx;
        end
        function adaptRacc(obj, accel, innovationAccel)
            external_accel = abs(norm(accel) - obj.g) > obj.gamma;
            R_adp = obj.R_norm + obj.alpha * (obj.R - obj.R_norm);

            if external_accel
                R_adp = R_adp + obj.beta * diag(innovationAccel .^ 2);
            end

            R_adp = diag(min(diag(R_adp), diag(obj.R_max)));
            obj.R = R_adp;
        end
    end


end
