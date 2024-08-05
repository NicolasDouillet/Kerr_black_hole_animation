function [] = converyor_belt_BH_animation()
% converyor_belt_BH_animation : modeling function for a rotating black hole (Kerr black hole)
%
% Author : nicolas.douillet (at) free.fr, 2007-2024.


% addpath('../../sampling/logmspace/');
% addpath('../../sampling/expmspace/');


nb_sample = 360;        % angle precision over 2pi radians
step = 2*pi/nb_sample;  % catenoid angle step ; default value : 2*pi/60
a = 6;                  % catenoid shape parameter ; default value : 6
t = linspace(0,1.5,32); % rotation & animation time parameter ; default value : linspace(0,1.5,32)
time_lapse = 0.25;      % time lapse for animation ; default value : 0.25
h_sample = 6;           % horizontal sample rate for the black hole mesh
v_sample = 12;          % vertical sample rate for the black hole mesh

filename = 'Black_hole_animation.gif';

i = 1;
j = 1;

for u = 0:5e-2:8 % expmspace(exp(5),exp(8),1.5,150) % logspace(0.8, log10(12),150) - 1 % catenoid shape parameter sampling vector ; default value : 0:5e-2:8
    
    for v = 0:step:2*pi % catenoid longitudinal (loop over) parameter sampling vector
        
        %--- (X,Y,Z) point belonging to the surface coordinates ---%
        X(i,j) = a*cosh(u)*cos(v+t(1,1)*u);
        Y(i,j) = a*cosh(u)*sin(v+t(1,1)*u);
        Z(i,j) = a*u;
        
        j = j+1;
        
    end        
    
    j = 1;
    i = i+1;
    
end


%--- Static display settings ---%
h = figure;
set(h,'Position',get(0,'ScreenSize'));
set(gcf,'Color',[0 0 0]); 

Zid_start = 60;

for k = Zid_start:-1:1
    
    %--- Black hole horizontal circles ---%    
    for m = 1:h_sample:size(Z,1)
        patch(X(1+mod(k+m,size(Z,1)),:),Y(1+mod(k+m,size(Z,1)),:),Z(1+mod(k+m,size(Z,1)),:),Z(1+mod(k+m,size(Z,1)),:).^2,...
            'FaceColor','none','EdgeColor','Interp','Linewidth',2), hold on;
        
        %--- Object / particle ring ---%        
        M1 = cat(2,X(end-Zid_start+k-3,1+floor(nb_sample/6)),Y(end-Zid_start+k-3,1+floor(nb_sample/6)),Z(end-Zid_start+k-3,1+floor(nb_sample/6)));
        M2 = cat(2,X(end-h_sample-Zid_start+k-3,1+floor(nb_sample/6)),Y(end-h_sample-Zid_start+k-3,1+floor(nb_sample/6)),Z(end-h_sample-Zid_start+k-3,1+floor(nb_sample/6)));
        M3 = cat(2,X(end-h_sample-Zid_start+k-3,1+floor(nb_sample/6)-v_sample),Y(end-h_sample-Zid_start+k-3,1+floor(nb_sample/6)-v_sample),Z(end-h_sample-Zid_start+k-3,1+floor(nb_sample/6)-v_sample));
        M4 = cat(2,X(end-Zid_start+k-3,1+floor(nb_sample/6)-v_sample),Y(end-Zid_start+k-3,1+floor(nb_sample/6)-v_sample),Z(end-Zid_start+k-3,1+floor(nb_sample/6)-v_sample));

        C1 = mean(cat(1,M1,M2),1);
        C2 = mean(cat(1,M2,M3),1);
        C3 = mean(cat(1,M3,M4),1);
        C4 = mean(cat(1,M4,M1),1);
        C5 = mean(cat(1,C1,M2,C2),1);
        C6 = mean(cat(1,C2,M3,C3),1);
        C7 = mean(cat(1,C3,M4,C4),1);
        C8 = mean(cat(1,C4,M1,C1),1);
                
        plot3(C1(1),C1(2),C1(3),'bo','Linewidth',2), hold on;
        plot3(C2(1),C2(2),C2(3),'bo','Linewidth',2), hold on;
        plot3(C3(1),C3(2),C3(3),'bo','Linewidth',2), hold on;
        plot3(C4(1),C4(2),C4(3),'bo','Linewidth',2), hold on;
        plot3(C5(1),C5(2),C5(3),'bo','Linewidth',2), hold on;
        plot3(C6(1),C6(2),C6(3),'bo','Linewidth',2), hold on;
        plot3(C7(1),C7(2),C7(3),'bo','Linewidth',2), hold on;
        plot3(C8(1),C8(2),C8(3),'bo','Linewidth',2), hold on;
        
        line([C1(1),C5(1),C2(1),C6(1),C3(1),C7(1),C4(1),C8(1),C1(1)],...
             [C1(2),C5(2),C2(2),C6(2),C3(2),C7(2),C4(2),C8(2),C1(2)],...
             [C1(3),C5(3),C2(3),C6(3),C3(3),C7(3),C4(3),C8(3),C1(3)],...
             'Color',[0 0 1],'Linewidth',3), hold on;        

    end
    
    %--- Black hole vertical curves ---%
    for n = 1:v_sample:size(Z,2)
        patch(cat(1,X(:,n),flipud(X(1:end-1,n))),cat(1,Y(:,n),flipud(Y(1:end-1,n))),...
              cat(1,Z(:,n),flipud(Z(1:end-1,n))),cat(1,Z(:,n),flipud(Z(1:end-1,n))).^2,...
              'FaceColor','none','EdgeColor','Interp','Linewidth',2), hold on;
    end
    
    %--- Event horizon ---%
    line(X(end,:),Y(end,:),Z(end,:),'Color',[0 1 0],'Linewidth',2), hold on;            
    
    %--- Display settings ---%
    ax = gca;
    set(ax,'Color',[0 0 0]);
    ax.Clipping = 'off';
    
    view(0,30)
    camzoom(2);
    campan(0.5,2.5);
    colormap(hot);
    axis auto, axis square, axis off;
    
    title('Deformation of a particle ring passing through one black hole horizon and caused by its gravity tidal force', 'Color', [1 1 1], 'FontSize', 16);

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