function [GammaValue] = Gamma(Cluster,F,ObjValue)
%=========================================================================%
%                                  Gamma                                  %
%=========================================================================%
% Description:
%   ��ia[����]����ľ�������(F)
%-------------------------------------------------------------------------
% Input:  Name          description     type
%         Cluster       ÿһ���Ӧ��Ŀ�� vector
%         F             Ŀ���Ӽ�         vector
%         ObjValue      ����Ŀ��ֵ       array
% Output: 
%         GammaValue    ������        cell(double)
%-------------------------------------------------------------------------
%
% version 1.0 -- June/2019
% Implemented by: Liyu Yang
% Contact Info  : yangliyuokn@sina.cn

Flength             = size(ObjValue,2);
F0                  = 1:Flength;             % ����Ŀ��
ka                  = 1;
% ��������F
for ia              = F
    % 
    OutCenter       = F0(Cluster==ia);
    % ��������������ϵ��
    k               = 1;
    for ib          = OutCenter
        TempCorr(k) = (1-corr(ObjValue(:,ib),ObjValue(:,ia),'Type','Kendall'))/2;
        k           = k + 1;
    end
    Max(ka)         = max(TempCorr);
    ka              = ka + 1;
end
GammaValue          = max(Max);

