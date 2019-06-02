function [GammaValue] = Gamma(Cluster,F,ObjValue)
%=========================================================================%
%                                  Gamma                                  %
%=========================================================================%
% Description:
%   与ia[距离]最近的聚类中心(F)
%-------------------------------------------------------------------------
% Input:  Name          description     type
%         Cluster       每一类对应的目标 vector
%         F             目标子集         vector
%         ObjValue      所有目标值       array
% Output: 
%         GammaValue    聚类结果        cell(double)
%-------------------------------------------------------------------------
%
% version 1.0 -- June/2019
% Implemented by: Liyu Yang
% Contact Info  : yangliyuokn@sina.cn

Flength             = size(ObjValue,2);
F0                  = 1:Flength;             % 所有目标
ka                  = 1;
% 聚类中心F
for ia              = F
    % 
    OutCenter       = F0(Cluster==ia);
    % 计算类内最大相关系数
    k               = 1;
    for ib          = OutCenter
        TempCorr(k) = (1-corr(ObjValue(:,ib),ObjValue(:,ia),'Type','Kendall'))/2;
        k           = k + 1;
    end
    Max(ka)         = max(TempCorr);
    ka              = ka + 1;
end
GammaValue          = max(Max);

