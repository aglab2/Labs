function GUI
f = figure;
columnname1 =   {'R', 't', 'dR/dt', 't'};
columneditable1 = [true true false false]; 

columnname2 = {'Value'};
rowname2 = {'R_к', 'a', 'P', 'T_к(С)', 'dR/dt(T_к)', 'C'};

t1 = uitable('Parent',f,'Units','normalized','Position',...
            [0 0 0.7 1], 'Data', [0 0 0 0],... 
            'ColumnName', columnname1,...
            'ColumnEditable', columneditable1,...
            'CellEditCallback',{@change_Callback});

t2 = uitable('Parent',f,'Units','normalized','Position',...
            [0.7 0 0.3 1], 'Data', [0;0;0;0;0;0],... 
            'ColumnName', columnname2,...
            'RowName', rowname2,...
            'ColumnEditable', columneditable1,...
            'CellEditCallback',{@change_Callback});
        
b1 = uicontrol('Parent',f,'Style', 'pushbutton', 'String', 'Add test',...
    'Position', [20 10 60 20],...
    'Callback', {@but1_Callback});

b2 = uicontrol('Parent',f,'Style', 'pushbutton', 'String', 'Plot',...
    'Position', [90 10 40 20],...
    'Callback', {@but2_Callback});

set(f,'Children',[b1 b2 t1 t2]);
end

function change_Callback(obj,~)
    f = get(obj, 'Parent');
    c = get(f, 'Children');
    t1 = c(3);
    t2 = c(4);
    dat1 = get(t1, 'Data');
    dat2 = get(t2, 'Data');
    set(t1,'Data',dat1);
    set(t2,'Data',dat2);
end

function but1_Callback(obj,~)
    f = get(obj, 'Parent');
    cf = get(f, 'Children');
    
    t1=cf(3);
    dat = get(t1,'Data');
    set(t1,'Data',cat(1,dat,[0 0 0 0]));
end

function but2_Callback(obj,~)
    f = get(obj, 'Parent');
    cf = get(f, 'Children');
    
    t1 = cf(3);
    t2 = cf(4);
    dat1 = get(t1, 'Data');
    dat2 = get(t2, 'Data');
    
    x2 = dat1(:,2);
    y2 = dat1(:,1);
    
    pp = csaps(x2,y2);
    ppder = fnder(pp, 1);
    
    s = size(x2);
    
    xx = linspace(x2(1),x2(end),1000);
    yy = ppval(pp, xx);
    
    figure;
    plot(x2, y2, 'o', xx, yy,'r');
    xlabel('$t$','FontName','Dejavu Serif','Interpreter','latex','FontSize',12);
    ylabel('$R$','FontName','Dejavu Serif','Interpreter','latex','FontSize',12);
    title('$R(t)$','FontName','Dejavu Serif','Interpreter','latex','FontSize',16)
    legend('hide');
    
    
    x1 = linspace(x2(1), x2(end),s(1));
    y1 = ppval(ppder, x1);
    
    ppder2 = csaps(x1, y1);
    
    xx1 = linspace(0,x1(end),1000);
    yy1 = ppval(ppder2, xx1);
    
    figure;
    plot(x1, y1,'o', xx1, yy1, 'r');
    xlabel('$t$','FontName','Dejavu Serif','Interpreter','latex','FontSize',12);
    ylabel('$\frac{dR}{dt}$','FontName','Dejavu Serif','Interpreter','latex','FontSize',12);
    title('$\frac{dR}{dt}$','FontName','Dejavu Serif','Interpreter','latex','FontSize',16)
    legend('hide');
    
    dat1(:,3) = y1.';
    dat1(:,4) = x1.';
    dat2(5) = yy1(1);
    dat2(6) = dat2(1) .* dat2(2) .* dat2(3) ./ dat2(5) ./ (1 + dat2(2) .* (dat2(4)+273));
    set(t1,'Data',dat1);
    set(t2,'Data',dat2);
end