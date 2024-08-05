function [] = converyor_belt_BH_animation()
% converyor_belt_BH_animation : modeling function for a rotating black hole (Kerr black hole)
%
% Author : nicolas.douillet (at) free.fr, 2007-2024.


addpath('../../sampling/logmspace/');
addpath('../../sampling/expmspace/');


step = 2*pi/360;        % catenoid angle step ; default value : 2*pi/60
a = 6;                  % catenoid shape parameter ; default value : 6
t = linspace(0,1.5,32); % rotation & animation time parameter ; default value : linspace(0,1.5,32)
time_lapse = 0.25;      % time lapse for animation ; default value : 0.25
h_sample = 6;
v_sample = 12;

filename = 'Black_hole_animation.gif';


i = 1;
j = 1;

for u = 0:5e-2:8 % expmspace(exp(5),exp(8),1.5,150) % logspace(0.8, log10(12),150) - 1 % catenoid shape parameter sampling vector ; default value : 0:5e-2:8
    
    for v = 0:step:2*pi % catenoid longitudinal (loop over) parameter sampling vector
        
        %--- (X,Y,Z) point belonging to the surface coordinates ---%
        X(i,j,1) = a*cosh(u)*cos(v+t(1,1)*u);
        Y(i,j,1) = a*cosh(u)*sin(v+t(1,1)*u);
        Z(i,j,1) = a*u;
        
        j = j+1;
        
    end        
    
    j = 1;
    i = i+1;
    
end


%--- Static display settings ---%
h = figure;
set(h,'Position',get(0,'ScreenSize'));
set(gcf,'Color',[0 0 0]);
axis tight manual;   

Zid_start = 60;

for k = Zid_start:-1:1
    
    %--- Black hole horizontal circles ---%
    % TODO : + cumsum sampling = f(tidal force)
    for m = 1:h_sample:size(Z,1)
        patch(X(1+mod(k+m,size(Z,1)),:,1),Y(1+mod(k+m,size(Z,1)),:,1),Z(1+mod(k+m,size(Z,1)),:,1),Z(1+mod(k+m,size(Z,1)),:,1).^2,...
            'FaceColor','none','EdgeColor','Interp','Linewidth',2), hold on;
    end
    
    %--- Black hole vertical curves ---%
    for n = 1:v_sample:size(Z,2)
        patch(cat(1,X(:,n,1),flipud(X(1:end-1,n,1))),cat(1,Y(:,n,1),flipud(Y(1:end-1,n,1))),...
              cat(1,Z(:,n,1),flipud(Z(1:end-1,n,1))),cat(1,Z(:,n,1),flipud(Z(1:end-1,n,1))).^2,...
              'FaceColor','none','EdgeColor','Interp','Linewidth',2), hold on;
    end
    
    %--- Event horizon ---%
    line(X(end,:,1),Y(end,:,1),Z(end,:,1),'Color',[0 1 0],'Linewidth',2), hold on;
        
    %--- Object / particle ring ---%
    % TODO : blue octogon
    
    %--- Display settings ---%
    ax = gca;
    set(ax,'Color',[0 0 0]);
    ax.Clipping = 'off';
    
    view(0,30)
    camzoom(2);
    campan(0.5,3);
    colormap(hot);
    axis auto, axis square, axis off;
    
    title('Deformation of a particle ring passing through a black hole horizon because of its gravity tidal force', 'Color', [1 1 1], 'FontSize', 16);

    drawnow;    
    frame = getframe(h);    
    im = frame2im(frame);
    [imind,cm] = rgb2ind(im,256);
    
    %--- Write to the .gif file ---%
    if k == Zid_start
        imwrite(imind,cm,filename,'gif', 'Loopcount',Inf,'DelayTime',time_lapse);
    else
        imwrite(imind,cm,filename,'gif','WriteMode','append','DelayTime',time_lapse);
    end
    
    clf(1);

    
end


end % converyor_belt_BH_animation