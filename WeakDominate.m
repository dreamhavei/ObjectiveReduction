function [State] = WeakDominate(x,y,varargin)
%=========================================================================%
%                                    ��֧��                               %
%=========================================================================%
% Description:
%   ��֧��
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

State       = all(x<=y);
end