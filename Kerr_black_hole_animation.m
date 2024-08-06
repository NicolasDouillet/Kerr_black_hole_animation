function [] = Kerr_black_hole_animation()
% Kerr_black_hole_animation : modeling function for a rotating black hole (Kerr black hole)
%
% Author : nicolas.douillet (at) free.fr, 2007-2024.


nb_sample = 360;        % angle precision over 2pi radians
step = 2*pi/nb_sample;  % catenoid angle step ; default value : 2*pi/60
a = 6;                  % catenoid shape parameter ; default value : 6
p = 3;                  % object path angle coefficieent
t = linspace(0,1.5,32); % rotation & animation time parameter ; default value : linspace(0,1.5,32)
time_lapse = 0.25;      % time lapse for animation ; default value : 0.25
h_sample = 6;           % horizontal sample rate for the black hole mesh; must divide Zid_start
v_sample = 24;          % vertical sample rate for the black hole mesh;   must divide Zid_start
Zid_start = 90;         % Framing coefficient; must be a multiple of h_sample and v_sample


filename = 'Kerr_black_hole_animation.gif';


u = (0:5e-2:8)'; % default value : 0:5e-2:8
v = 0:step:2*pi-step; % catenoid longitudinal (loop over) parameter sampling vector

% Black hole mesh coordinates
X = a*cosh(u).*cos(v+t(end)*u);
Y = a*cosh(u).*sin(v+t(end)*u);
Z = repmat(a*u,[1,size(v,2)]);

% Object path coordinates
E = a*cosh(u).*cos(p*t(end)*u-0.5*pi);
F = a*cosh(u).*sin(p*t(end)*u-0.5*pi);
G = a*u;

%--- Static display settings ---%
h = figure;
set(h,'Position',get(0,'ScreenSize'));
set(gcf,'Color',[0 0 0]); 


for k = Zid_start:-1:1
    
    %--- Black hole horizontal circles ---%    
    for m = 1:h_sample:size(Z,1)
        patch(X(1+mod(k+m,size(Z,1)),:),Y(1+mod(k+m,size(Z,1)),:),Z(1+mod(k+m,size(Z,1)),:),Z(1+mod(k+m,size(Z,1)),:).^2,...
              'FaceColor','none','EdgeColor','Interp','Linewidth',2), hold on;
        
    end
    
    %--- Black hole vertical curves ---%
    for n = 1:v_sample:size(Z,2)
        
        patch(cat(1,X(:,1+mod(2*k+n,size(Z,2))),flipud(X(1:end-1,1+mod(2*k+n,size(Z,2))))),cat(1,Y(:,1+mod(2*k+n,size(Z,2))),flipud(Y(1:end-1,1+mod(2*k+n,size(Z,2))))),...
              cat(1,Z(:,1+mod(2*k+n,size(Z,2))),flipud(Z(1:end-1,1+mod(2*k+n,size(Z,2))))),cat(1,Z(:,1+mod(2*k+n,size(Z,2))),flipud(Z(1:end-1,1+mod(2*k+n,size(Z,2))))).^2,...
              'FaceColor','none','EdgeColor','Interp','Linewidth',2), hold on;                
        
    end        
    
    %--- Object and its path ---%
    plot3(E(end-Zid_start+k-1,1),...
          F(end-Zid_start+k-1,1),...
          G(end-Zid_start+k-1,1),...
          'bo','MarkerSize',12,'Linewidth',12), hold on;
    
    plot3(E(end-Zid_start+k-1:end,1),...
          F(end-Zid_start+k-1:end,1),...
          G(end-Zid_start+k-1:end,1),...
          'Color',[0 0 1],'Linewidth',4), hold on;
        
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
    
    title('Spiraling path of an object passing through one rotating | Kerr black hole horizon', 'Color', [1 1 1], 'FontSize', 16);

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


end % Kerr_black_hole_animation