function [State] = WeakDominate(x,y,varargin)
%=========================================================================%
%                                    弱支配                               %
%=========================================================================%
% Description:
%   弱支配
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

State       = all(x<=y);
end