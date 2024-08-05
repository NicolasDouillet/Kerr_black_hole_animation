function [] = Kerr_black_hole_animation()
% Kerr_black_hole_animation : modeling function for a rotating black hole (Kerr black hole)
%
% Author : nicolas.douillet (at) free.fr, 2007-2024.


step = 2*pi/60;         % catenoid angle step ; default value : 2*pi/60
step2 = 2;              % catenoid sub sampling parameter ; default value : 2
a = 6;                  % catenoid shape parameter ; default value : 6
t = linspace(0,1.5,32); % rotation & animation time parameter ; default value : linspace(0,1.5,32)
time_lapse = 0.25;      % time lapse for animation ; default value : 0.25

filename = 'Kerr_black_hole_animation.gif';

%--- Static display settings ---%
h = figure;
set(h,'Position',get(0,'ScreenSize'));
set(gcf,'Color',[0 0 0]);
axis tight manual;


for k = 1:numel(t)   

    i = 1;
    j = 1;
    
    for u = 0:5e-2:8 % catenoid shape parameter sampling vector ; default value : 0:5e-2:8
        
        for v = 0:step:2*pi % catenoid longitudinal (loop over) parameter sampling vector
            
            %--- (X,Y,Z) point belonging to the surface coordinates ---%
            X(i,j,k) = a*cosh(u)*cos(v+t(1,k)*u);
            Y(i,j,k) = a*cosh(u)*sin(v+t(1,k)*u);
            Z(i,j,k) = a*u;
            
            j = j+1;
            
        end
        
        % --- Object coordinates ---%
        E(k,i) = a*cosh(u).*cos(2*t(1,k)*u); % object 'deviation' coefficient ; default : 2
        F(k,i) = a*cosh(u).*sin(2*t(1,k)*u);
        G(k,i) = a*u;
        
        j = 1;
        i = i+1;
        
    end

    %--- Sample in x, y, z ---%
    X = X(1:step2:size(X,1),1:step2:size(X,2),:);
    Y = Y(1:step2:size(Y,1),1:step2:size(Y,2),:);
    Z = Z(1:step2:size(Z,1),1:step2:size(Z,2),:);

    %--- Black hole mesh ---%
    for m = 1:size(Z,1)
        line(X(m,:,k),Y(m,:,k),Z(m,:,k),'Color',[0 1 1],'Linewidth',2), hold on;
    end

    for n = 1:size(Z,2)
        line(X(:,n,k),Y(:,n,k),Z(:,n,k),'Color',[0 1 1],'Linewidth',2), hold on;
    end

    %--- Object path ---%
    plot3(E(k,:),F(k,:),G(k,:),'Color',[1 0 0],'Linewidth',4), hold on;
    plot3(E(k,round((numel(t)-k+1)*(i-1)/numel(t))),F(k,round((numel(t)-k+1)*(i-1)/numel(t))),G(k,round((numel(t)-k+1)*(i-1)/numel(t))),'ro','MarkerSize',12,'Linewidth',12), hold on;        

    %--- Display settings ---%
    set(gca,'Color',[0 0 0]);           
    view(0,30);
    campan(0,2.3);
    camzoom(3.2);            

    title('Kerr black hole rotation and trajectory of an object passing through its horizon.', 'Color', [1 1 1], 'FontSize', 16);
    
    drawnow;
    
    frame = getframe(h);    
    im = frame2im(frame);
    [imind,cm] = rgb2ind(im,256);
    
    %--- Write to the .gif file ---%
    if k == 1
        imwrite(imind,cm,filename,'gif', 'Loopcount',Inf,'DelayTime',time_lapse);
    else
        imwrite(imind,cm,filename,'gif','WriteMode','append','DelayTime',time_lapse);
    end
    
    clf(1);
    
end


end % Kerr_black_hole_animation