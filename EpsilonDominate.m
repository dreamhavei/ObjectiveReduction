function [State] = EpsilonDominate(x,y,varargin)
%=========================================================================%
%                                    ��֧��                               %
%=========================================================================%
% Description:
%   epsion��֧��
%-------------------------------------------------------------------------
% Input:  Name     description     type
%         U        ����            array
%         C        ��������        array
%         U_D_cell �������Զ��໮�� cell
% Output: 
%         gama     ������          double
%-------------------------------------------------------------------------1
%   'Pos'      - ������ֵ.  Default is 1.
%
% version 1.0 -- May/2019
% Implemented by: Liyu Yang
% Contact Info  : yangliyuokn@sina.cn

%% ��ʼ��
Eta             = [];
Pos             = [];
 if length(varargin) >= 1
    Eta         = varargin{1};
 end
if length(varargin) >= 2
    Pos         = varargin{2};
end

% flag          = 0;
%% 
if isempty(Eta)                     % ������֧��
    State       = all(x<=y);
else                                % eta��֧��
    if isempty(Pos)                
        Pos     = 1;
    end
    y           = y(Pos);
    x           = x(Pos);
    z           = zeros(size(x));
    z(:)        = Eta;
    x           = x - z;            % 
    State       = all(x<=y);
end
% varargout = {State,flag};
end