function printInfoOfSSModel(A_long, B_long, A_lat, B_lat)
    [eigvec_long, eigval_long] = eig(A_long);
    [wn_long, zeta_long] =damp(diag(eigval_long));
    P = ctrb(A_long, B_long);
    fprintf("---------------------------------\n")
    fprintf("Eigen values of A_long: \n");
    disp(diag(eigval_long))
    fprintf("Natural Frequencies and Damping Rates of Eigen Values of A_long\n")
    fprintf("wn \t\t zeta\n");
    for i=1:length(wn_long)
        fprintf("%.3f\t\t%.3f\n", wn_long(i), zeta_long(i))
    end
    fprintf("Eigen vectors of A_long: \n");
    disp(eigvec_long);
    fprintf("is (A_long, B_long) pair controllable: %d\n", rank(P) == length(A_long));
    fprintf("---------------------------------\n");
    
    [eigvec_lat, eigval_lat] = eig(A_lat);
    [wn_lat, zeta_lat] =damp(diag(eigval_lat));
    P = ctrb(A_lat, B_lat);
    fprintf("---------------------------------\n")
    fprintf("Eigen values of A_lat: \n");
    disp(diag(eigval_lat))
    fprintf("Natural Frequencies and Damping Rates of Eigen Values of A_lat\n")
    fprintf("wn \t\t zeta\n");
    for i=1:length(wn_lat)
        fprintf("%.3f\t\t%.3f\n", wn_lat(i), zeta_lat(i))
    end
    fprintf("Eigen vectors of A_lat: \n");
    disp(eigvec_lat);
    fprintf("is (A_lat, B_lat) pair controllable: %d\n", rank(P) == length(A_long));
    fprintf("---------------------------------\n");
end 