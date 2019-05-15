function [State] = EpsilonDominate(x,y,varargin)
%=========================================================================%
%                                    弱支配                               %
%=========================================================================%
% Description:
%   epsion弱支配
%-------------------------------------------------------------------------
% Input:  Name     description     type
%         U        论域            array
%         C        条件属性        array
%         U_D_cell 决策属性对类划分 cell
% Output: 
%         gama     依赖度          double
%-------------------------------------------------------------------------1
%   'Pos'      - 概率阈值.  Default is 1.
%
% version 1.0 -- May/2019
% Implemented by: Liyu Yang
% Contact Info  : yangliyuokn@sina.cn

%% 初始化
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
if isempty(Eta)                     % 经典弱支配
    State       = all(x<=y);
else                                % eta弱支配
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