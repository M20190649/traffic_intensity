
% Example of connecting Matlab and SaaS Data Access Layer
% 
clear all;
close all;


% Specify the database connection information

%Don't forget to add password

connectionString ='data source=135.222.212.16;initial catalog=wms_kpi;User Id=slbryson; Password=janfeb222!;';

dbHandler = DatabaseHandler(connectionString);

% The data is in this table.
tableName = 'dbo.kpi_series';
histTable = 'dbo.test';
listTable = {histTable};
% listTable = {'dbo.test'}
%Table input list Add to the end of here for additional runs
% Note to limit the processing in any given run, you have to uncomment the
% tables desired
%%%%%%%%%%%%%%%%%%%%%%%%
% listTable = {'dbo.carriera0830' 'dbo.carriera1130'};
% listTable = {'dbo.carriera1630'};
% listTable = {'dbo.carriera2330'};

% listTable = {'dbo.carrierb0830' 'dbo.carrierb1130' 'dbo.carrierb1630' 'dbo.carrierb2330'}
% listTable = {'dbo.carrierc0830' 'dbo.carrierc1130' 'dbo.carrierc1630' 'dbo.carrierc2330'  'dbo.carrieri0830' 'dbo.carrieri1130' 'dbo.carrieri1630' 'dbo.carrieri2330'};
% listTable = {'dbo.carrierl0830' 'dbo.carrierl1130' 'dbo.carrierl1630' 'dbo.carrierl2330'  'dbo.carrierk0830' 'dbo.carrierk1130' 'dbo.carrierk1630' 'dbo.carrierk2330'};
% listTable = {'dbo.carrierj0830' 'dbo.carrierj1130' 'dbo.carrierj1630' 'dbo.carrierj2330'};
% listTable = {'dbo.carrierh0830' 'dbo.carrierh1130' 'dbo.carrierh1630' 'dbo.carrierh2330'};

% listTable = {'dbo.carrierh2330'};
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
listTable = {'dbo.carriera0830' 'dbo.carriera1130' 'dbo.carriera1630' 'dbo.carriera2330' 'dbo.carrierb0830' 'dbo.carrierb1130' 'dbo.carrierb1630' 'dbo.carrierb2330'};
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Location information is in this table

locationTable ='dbo.location'; 
tic
disp('Starting the Select function');
td = dbHandler.SelectLocationTable(locationTable);
disp('Finishing First Table Grab');
toc
%%%%%%
% Loop through multiple databases
for j = 1:length(listTable),
    clf;
    histTable = char(listTable(j));
    tic
    disp(['Starting the Select function ' histTable]);
 
    tb2 = dbHandler.SelectAll(histTable);
  
    select_time = toc
 
    %%%%%%%%%%%%%%%%%%%%%%%
    %  loop through and calculate the average for each unique cell

    clear a b c A B;
    a = zeros(length(td),1); b = a; c =a; f=a; g=a;
    %%%%%%%%%%%%%%%%%%%%%%%%
    % Change dataset format
    %%%%%%%%%%%%%%%%%%%%%%%%
    % This step is very important since the matching done later in average
    % will sum along matched cell names
    tb2 = sortrows(tb2,2);  % sort based on name
    %%%%%%%%%%%%%%%%%%%%%%%%
    t_name = cell2mat(td.name);
    t_cell = cell2mat(tb2.cell);
    %%%%%%%%%%%%%%%%%%%%%%%%
    a = cell2mat(td.utm_northing);
    b = cell2mat(td.utm_easting);
    f = cell2mat(td.latitude);
    g = cell2mat(td.longitude);
    %%%%%%%%%%%%%%%%%%%%%%%%
    td_length = length(td);
    tb_length = length(tb2);
    %%%%%%%%%%%%%%%%%%%%%%%%
    datab = cell2mat(tb2.totPSRRCAtts); %convert from dataset to double

   tic

% Function call to remote .m file for better profiling.
   [mi,mj,c] = average(datab,td_length,tb_length,t_name,t_cell);
   Fuction_average_time = toc
  
  %%%%%%%%%%%%%%%%%%%%%%%%

a = a(mi);
b = b(mi);
f = f(mi); f = double(f);
g = g(mi); g =double(g);
% Note c(i) is now an average and is only computed for cells matched
    %++++++++++++++++++++++++++++++++++++++++++++++++
    N_gridpoints_per_dim = length(a);
    %++++++++++++++++++++++++++++++++++++++++++++++++
    a = double(a);
    b = double(b);
    c = double(c);
    %+++++++++++++++++++++++++++++++++++++++++++++++++++++++++
    eNb =0;  % turn on the uniqueness function.
    if eNb
        x1 =double(a);
        x2 =double(b);
        % Use a unique set of points for all calculations which simplifies some of
        % the processing.
        X = [x1, x2];
        [~, I, ~] = unique(X,'first','rows');
        I = sort(I);
        X = X(I,:);
        xg= X(:,1);
        yg = X(:,2);
        x1 = xg; x2 = yg;
        N_gridpoints_per_dim = length(x1);
    end
    %+++++++++++++++++++++++++++++++++++++++++++++++++++++++++
    if eNb ==0
        N_gridpoints_per_dim = length(a);
    end

    %++++++++++++++++++++++++++++++++++++++++++++++++
    % Force out any randomness while still being random;
    % seed = 61; randn('seed',seed), rand('seed',seed)
    %++++++++++++++++++++++++++++++++++++++++++++++++
    [coord_x, coord_y] = meshgrid(a,b);
    % Sample 3/4 of the points for Training
    N_train = floor(N_gridpoints_per_dim*(1.0));
    %++++++++++++++++++++++++++++++++
    % data sampling.
    [training_data,idx] = datasample([a b c],N_train);
    
    x = [training_data(:,1) training_data(:,2)];
    y = training_data(:,3);
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %In this iteration, no sampling we will use all the points selected.
    
    x = [a b];
    y = c;
    %%%%%%%%%%%%%%%%%%%%%%%%%%%% 
     
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Now 'x' consist of the inputs and 'y' of the output.
    % 'n' and 'nin' are the number of training data points and the
    % dimensionality of 'x' (the number of inputs).
    [n, nin] = size(x);
    % ---------------------------
    % --- Construct the model ---
    %
    % First create structures for Gaussian likelihood and squared
    % exponential covariance function with ARD
        % Create covariance function
        pn = prior_logunif();
        lik = lik_gaussian('sigma2', .2, 'sigma2_prior', pn);
        pl = prior_gaussian('s2', .5);
        pm = prior_logunif();
%        gpcf = gpcf_ppcs2('nin', nin, 'lengthScale', [1 1], 'magnSigma2', 10, ...
%       'lengthScale_prior', pl, 'magnSigma2_prior', pm);
        gpcf = gpcf_sexp('magnSigma2',.2,'lengthScale', [10 10],'lengthScale_prior', pl, 'magnSigma2_prior', pm);    
%       gpcf = gpcf_matern32('magnSigma2',10,'lengthScale', [2 2],'lengthScale_prior', pl, 'magnSigma2_prior', pm);
% ============================================

% MAP ESTIMATE
% ============================================
        gp = gp_set('lik', lik, 'cf', gpcf, 'jitterSigma2', 1e-3);

        % Optimize the parameters
        % ---------------------------------
        % Set the options for the scaled conjugate gradient optimization
        opt=optimset('TolFun',1e-8,'TolX',1e-8,'Display','iter');
        % Optimize with the scaled conjugate gradient method
        gp=gp_optim(gp,x,y,'opt',opt);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%     disp(' Get optimized Parameters for Display')
    % get optimized parameter values for display
    [w,s]=gp_pak(gp);
    % display exp(w) and labels
    disp(s), disp(exp(w))
% ============================================    
    % For last, make predictions of the underlying function on a dense
    % grid and plot it. Below Eft_map is the predictive mean and
    % Varf_map the predictive variance.
    xt=[coord_x(:) coord_y(:)];
    %In this experession y is now a N X 1 dimensional vector and x is a two
    %dimensional vector.
    [Eft_map, Varft_map] = gp_pred(gp, x, y, xt);
    kk=reshape(Eft_map,N_gridpoints_per_dim,N_gridpoints_per_dim);

    %%%%%%%%%%%%%%%%%%%%
    
    % Plot the prediction and data
%     figure(3)
%     clf;
%     hold off;
%     hb = figure(1);
%     surf(a, b, reshape(Eft_map,N_gridpoints_per_dim,N_gridpoints_per_dim));
%     hold on
%     shading interp
%     colormap(hot);
%     scatter3(x(:,1), x(:,2), y, 'g+');
%     scatter3(a,b,c,'mo','Linewidth', 2);

       %%%%%%%%%%%%%%%%%%%%
% 
%         hb = figure(3);
%         clf;
%         hold off;
%  alim ([min(Eft_map) max(Eft_map)]);
%         surf(g, f, kk, ...
%         'FaceAlpha','interp',...
%         'AlphaDataMapping','scaled',...
%         'AlphaData',gradient(kk),...
%         'FaceColor','red');
%         hold on
%         shading interp
%         colormap(hot);
%         scatter3(g,f,c,'mo','Linewidth', 1);   
%         alpha(0.4)
%         axis tight;
%     %%%%%%%%%%%%%%%%%%%%
% 
% title(['eNB Level Interpolation Results ' histTable]);
% saveas(hb,[histTable '_interp' '.jpg'], 'jpg');
% % axis on;
% %%%%%%%%%%%%%%%%%%%%
% tn = 100;
% h_lat_lon = figure(2);
% clf;
% hold off;
% xi = linspace(min(g),max(g),tn);
% yi = linspace(min(f),max(f),tn);
% [Xi, Yi] = meshgrid(xi,yi);
% Zi = griddata(g,f,kk,Xi,Yi);
% % h_contour_latlon = contourf(Xi,Yi,Zi,128);
% surf(Xi,Yi,Zi)
% hold on;
% axis tight;
% shading flat;
% plot3(g,f,kk,'md','LineWidth',1);
% plot3(g,f,c,'bo');
% 
% % colormap(hot(256));
% colormap(jet);
% view(2);
% alpha(0.6);

%%%%%%%%%%%%%%%%%%%%
% plot_google_map('MapType','roadmap','AutoAxis', 0);
% 
% set(gcf, 'PaperType', 'A4', 'PaperOrientation', 'portrait', 'PaperPositionMode', 'auto');
% title(['eNB Level Heatmap Results ' histTable]);
% saveas(h_lat_lon,[histTable '_contour' '.jpg'], 'jpg');

%%%%%%%%%%%%%%%%%%%%
    %Plot the Estimation map
%%%%%%%%%%%%%%%%%%%%
        hbb = figure(1);
        var_map = Varft_map + gp.lik.sigma2;
        var_map = Eft_map + 2.*sqrt(var_map) ;
        var_map_minus = Varft_map + gp.lik.sigma2;
        var_map_minus = Eft_map -2.*sqrt(var_map) ;
        jj =reshape(var_map,N_gridpoints_per_dim,N_gridpoints_per_dim);
        jg =reshape(var_map_minus,N_gridpoints_per_dim,N_gridpoints_per_dim);
        clf;
        hold off;

        h5 = surf(g, f, kk, ...
        'FaceAlpha','interp',...
        'AlphaDataMapping','scaled',...
        'AlphaData',gradient(kk),...
        'FaceColor','red');

        hold on
%         h5= plot3(g,f,jj,'r+');
%         h6 = plot3(g,f,kk,'bd');
        h7 = plot3(g,f,y,'go');
        shading flat
        alim ([5 max(Eft_map)]);
        view(3);
        colormap(mapcolor(Eft_map));
        legend([h5, h7],'Predictive Surface', 'Mean RRC Attempts per Location');
        set(h5,'DisplayName','Predictive Surface');
        set(h7,'DisplayName','Mean RRC Attempts');
 
        axis tight;
    %%%%%%%%%%%%%%%%%%%%
    title(['The Estimated Surface from Mean RRC Attempt observations' histTable]);
    saveas(hbb,[histTable '_interp' '.jpg'], 'jpg');
   

end
%%%%%%%%%%%%%%%%%%%%


