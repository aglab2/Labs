classdef EValue
    
    properties(Dependent = true)
        Val
        Err
        Eps
    end
    properties(SetAccess = private, GetAccess = private)
        Val_
        Err_
        Eps_
    end
    
    methods
        function EV = EValue(Val, ErrorType, ErrorVal)
            if (~isvector(Val) || ~isnumeric(Val))
                error('Given value is not vector!');
            end
            if (~ischar(ErrorType))
                error('Given error type is not string!');
            end
            if (length(ErrorVal) == 1 && isnumeric(ErrorVal))
                ErrorVal = zeros(1, length(Val)) + ErrorVal;
            end
            if (~isvector(ErrorVal) || ~isnumeric(ErrorVal))
                error('Given error value is not vector or number!');
            end
            if (length(Val) ~= length(ErrorVal))
                error('Error value and value has different size!');
            end
            if (~strcmp(ErrorType,'Err') && ~strcmp(ErrorType,'Eps'))
                error('Error Type is incorrect (Err or Eps only)');
            end
           
            EV.Val_ = Val;
            
            if (strcmp(ErrorType,'Err'))
                EV.Err_ = ErrorVal;
                EV.Eps_ = EV.Err_ ./ EV.Val_;
            end
            if (strcmp(ErrorType,'Eps'))
                EV.Eps_ = ErrorVal;
                EV.Err_ = EV.Eps_ .* EV.Val_;
            end
        end
        
        function ret = OK(obj)
            ret = 0;
            if (~isvector(obj.Val_) || ~isnumeric(obj.Val_))
                ret = ret + bin2dec('1');
            end
            if (~isvector(obj.Err_) || ~isnumeric(obj.Err_))
                ret = ret + bin2dec('10');
            end
            if (~isvector(obj.Eps_) || ~isnumeric(obj.Eps_))
                ret = ret + bin2dec('100');
            end
            if (length(obj.Val_) ~= length(obj.Err_))
                ret = ret + bin2dec('1000');
            end           
            if (length(obj.Val_) ~= length(obj.Eps_))
                ret = ret + bin2dec('10000');
            end             
        end
    
        function Val = get.Val(obj)
            if (obj.OK ~= 0) 
                error(strcat('Bad EValue object! ErrCode:', dec2bin(obj.OK)));
            end
            Val = obj.Val_;
        end
        function Err = get.Err(obj)
            if (obj.OK ~= 0) 
                error(strcat('Bad EValue object! ErrCode:', dec2bin(obj.OK)));
            end
            Err = obj.Err_;
        end
        function Eps = get.Eps(obj)
            if (obj.OK ~= 0) 
                error(strcat('Bad EValue object! ErrCode:', dec2bin(obj.OK)));
            end
            Eps = obj.Eps_;
        end
        
        function obj = set.Val(obj, Val__)
            if (obj.OK ~= 0) 
                error(strcat('Bad EValue object! ErrCode:', dec2bin(obj.OK)));
            end
            
            if (~isvector(Val__) || ~isnumeric(Val__))
                error('Input value is not vector!');
            end
            
            if (length(obj.Val_) ~= length(Val__))
                error(strcat('Bad input length! Current length:', int2str(length(obj.Val_))));
            end
          
            obj.Val_ = Val__;
            obj.Eps_ = obj.Err_ ./ obj.Val_;
        end
        function obj = set.Err(obj, Err__)
            if (obj.OK ~= 0) 
                error(strcat('Bad EValue object! ErrCode:', dec2bin(obj.OK)));
            end
            
            if (~isvector(Err__) || ~isnumeric(Err__))
                error('Input value is not vector!');
            end
            
            if (length(obj.Err_) ~= length(Err__))
                error(strcat('Bad input length! Current length:', int2str(length(obj.Err_))));
            end
          
            obj.Err_ = Err__;
            obj.Eps_ = obj.Err_ ./ obj.Val_;
        end
        function obj = set.Eps(obj, Eps__)
            if (obj.OK ~= 0) 
                error(strcat('Bad EValue object! ErrCode:', dec2bin(obj.OK)));
            end
            
            if (~isvector(Eps__) || ~isnumeric(Eps__))
                error('Input value is not vector!');
            end
            
            if (length(obj.Eps_) ~= length(Eps__))
                error(strcat('Bad input length! Current length:', int2str(length(obj.Eps_))));
            end
          
            obj.Eps_ = Eps__;
            obj.Err_ = obj.Eps_ .* obj.Val_;
        end
        
        function c = plus(a, b)
            if (isnumeric(a))
                a = EValue(a, 'Err', 0);
            end
            if (isnumeric(b))
                b = EValue(b, 'Err', 0);
            end
            
            if (isa(a, 'EValue') == 0 || a.OK ~= 0)
                error(strcat('First arg is bad EValue object! ErrCode:', dec2bin(a.OK)));
            end
            if (isa(b, 'EValue') == 0 || b.OK ~= 0)
                error(strcat('First arg is bad EValue object! ErrCode:', dec2bin(b.OK)));
            end
            
            c = EValue(a.Val_ + b.Val_, 'Err', a.Err_ + b.Err_);
        end
        
        function c = minus(a, b)
            if (isnumeric(a))
                a = EValue(a, 'Err', 0);
            end
            if (isnumeric(b))
                b = EValue(b, 'Err', 0);
            end
            
            if (isa(a, 'EValue') == 0 || a.OK ~= 0)
                error(strcat('First arg is bad EValue object! ErrCode:', dec2bin(a.OK)));
            end
            if (isa(b, 'EValue') == 0 || b.OK ~= 0)
                error(strcat('First arg is bad EValue object! ErrCode:', dec2bin(b.OK)));
            end
            
            c = EValue(a.Val_ - b.Val_, 'Err', a.Err_ + b.Err_);
        end
        
        function c = uminus(a)
            if (isa(a, 'EValue') == 0 || a.OK ~= 0)
                error(strcat('First arg is bad EValue object! ErrCode:', dec2bin(a.OK)));
            end
            
            c = EValue(-a.Val_, 'Err', a.Err_);
        end
        
        function c = uplus(a)
            if (isa(a, 'EValue') == 0 || a.OK ~= 0)
                error(strcat('First arg is bad EValue object! ErrCode:', dec2bin(a.OK)));
            end
            
            c = EValue(a.Val_, 'Err', a.Err_);
        end
        
        function c = mtimes(a, b)
            if (isnumeric(a))
                a = EValue(a, 'Err', 0);
            end
            if (isnumeric(b))
                b = EValue(b, 'Err', 0);
            end
            
            if (isa(a, 'EValue') == 0 || a.OK ~= 0)
                error(strcat('First arg is bad EValue object! ErrCode:', dec2bin(a.OK)));
            end
            if (isa(b, 'EValue') == 0 || b.OK ~= 0)
                error(strcat('First arg is bad EValue object! ErrCode:', dec2bin(b.OK)));
            end
            
            c = EValue(a.Val_ .* b.Val, 'Eps', a.Eps_ + b.Eps_);
        end
        
        function c = times(a, b)
            if (isnumeric(a))
                a = EValue(a, 'Err', 0);
            end
            if (isnumeric(b))
                b = EValue(b, 'Err', 0);
            end
            
            if (isa(a, 'EValue') == 0 || a.OK ~= 0)
                error(strcat('First arg is bad EValue object! ErrCode:', dec2bin(a.OK)));
            end
            if (isa(b, 'EValue') == 0 || b.OK ~= 0)
                error(strcat('First arg is bad EValue object! ErrCode:', dec2bin(b.OK)));
            end
            
            c = EValue(a.Val_ .* b.Val, 'Eps', a.Eps_ + b.Eps_);
        end

        function c = rdivide(a, b)
            if (isnumeric(a))
                a = EValue(a, 'Err', 0);
            end
            if (isnumeric(b))
                b = EValue(b, 'Err', 0);
            end
            
            if (isa(a, 'EValue') == 0 || a.OK ~= 0)
                error(strcat('First arg is bad EValue object! ErrCode:', dec2bin(a.OK)));
            end
            if (isa(b, 'EValue') == 0 || b.OK ~= 0)
                error(strcat('First arg is bad EValue object! ErrCode:', dec2bin(b.OK)));
            end
            
            c = EValue(a.Val_ ./ b.Val, 'Eps', a.Eps_ + b.Eps_);
        end
        
        function c = mrdivide(a, b)
            if (isnumeric(a))
                a = EValue(a, 'Err', 0);
            end
            if (isnumeric(b))
                b = EValue(b, 'Err', 0);
            end
           
            if (isa(a, 'EValue') == 0 || a.OK ~= 0)
                error(strcat('First arg is bad EValue object! ErrCode:', dec2bin(a.OK)));
            end
            if (isa(b, 'EValue') == 0 || b.OK ~= 0)
                error(strcat('First arg is bad EValue object! ErrCode:', dec2bin(b.OK)));
            end
            
            c = EValue(a.Val_ ./ b.Val, 'Eps', a.Eps_ + b.Eps_);
        end
        
        function c = power(a, b)
            if (isa(a, 'EValue') == 0 || a.OK ~= 0)
                error(strcat('First arg is bad EValue object! ErrCode:', dec2bin(a.OK)));
            end
            
            if (~isnumeric(b))
                error('Second arg should be numeric!');
            end
            
            c = EValue(a.Val_ .^ b, 'Eps', a.Eps_ .* abs(b));
        end
        
        function c = mpower(a, b)
            if (isa(a, 'EValue') == 0 || a.OK ~= 0)
                error(strcat('First arg is bad EValue object! ErrCode:', dec2bin(a.OK)));
            end
            
            if (~isnumeric(b))
                error('Second arg should be numeric!');
            end
            
            c = EValue(a.Val_ .^ b, 'Eps', a.Eps_ .* abs(b));
        end
        
        function c = subsref(a, s)
            %if (isa(a, 'EValue') == 0 || a.OK ~= 0)
            %    error(strcat('First arg is bad EValue object! ErrCode:', dec2bin(a.OK)));
            %end
            disp(a); disp(s);
            if length(s) == 1
                switch (s.type)
                    case '()'
                        if (~ismatrix(a))
                            c = EValue(subsref(a.Val_, s), 'Eps', subsref(a.Eps_, s));
                        else
                            c = builtin('subsref', a, s);
                        end
                    otherwise
                        c = builtin('subsref', a, s);
                end
            else
                q = builtin('subsref', a, s(1));
                c = subsref(q, s(2:end));
            end
        end
        
        function Eplot(dataX, dataY)
            if (isa(dataX, 'EValue') == 0 || dataX.OK ~= 0)
                error(strcat('First arg is bad EValue object! ErrCode:', dec2bin(dataX.OK)));
            end
            if (isa(dataY, 'EValue') == 0 || dataY.OK ~= 0)
                error(strcat('First arg is bad EValue object! ErrCode:', dec2bin(dataY.OK)));
            end
            
            x = dataX.Val; y=dataY.Val; errX=dataX.Err; errY=dataY.Err;
            x = x(:); y = y(:); errX = errX(:); errY = errY(:);

            if ischar(x) || ischar(y) || ischar(errX) || ischar(errY)
                error('Arguments must be numeric.')
            end

            if ~isequal(size(x),size(y)) || ~isequal(size(x),size(errX)) || ~isequal(size(y),size(errY)),
                error('The sizes of X, Y should be equal');
            end

            xl = x - errX;
            xr = x + errX;
            yl = y - errY;
            yr = y + errY;

            [n, ~] = size(x);

            xb = zeros(n*6, 1);

            xb(1:6:end,:) = xl;
            xb(2:6:end,:) = xr;
            xb(3:6:end,:) = NaN;
            xb(4:6:end,:) = x;
            xb(5:6:end,:) = x;
            xb(6:6:end,:) = NaN;


            yb = zeros(n*6,1);
            yb(1:6:end,:) = y;
            yb(2:6:end,:) = y;
            yb(3:6:end,:) = NaN;
            yb(4:6:end,:) = yl;
            yb(5:6:end,:) = yr;
            yb(6:6:end,:) = NaN;
            
            hold on

            plot(xb,yb);
            plot(x, y, '.');

            grid on
        end
        
        function fitObj = Efit(x, y, fitStr)
            if (isa(x, 'EValue') == 0 || x.OK ~= 0)
                error(strcat('First arg is bad EValue object! ErrCode:', dec2bin(x.OK)));
            end
            if (isa(y, 'EValue') == 0 || y.OK ~= 0)
                error(strcat('First arg is bad EValue object! ErrCode:', dec2bin(y.OK)));
            end
            
            fitObj = fit(x.Val', y.Val', fitStr);
        end
        
        function c = ln(x)
            if (isa(x, 'EValue') == 0 || x.OK ~= 0)
                error(strcat('First arg is bad EValue object! ErrCode:', dec2bin(x.OK)));
            end
            c = EValue(log(x.Val_), 'Err', x.Err_ ./ x.Val_);
        end
    end
end