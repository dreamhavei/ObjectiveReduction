function [Result] = GammaCluster(F,ObjValue)
%=========================================================================%
%                              GammaCluster 算法                          %
%=========================================================================%
% Description:
%   与ia[距离]最近的聚类中心(F)
%-------------------------------------------------------------------------
% Input:  Name          description     type
%         F             目标子集        vector

%         ObjValue      所有目标值      array
% Output: 
%         Result        聚类结果        cell(double)
%-------------------------------------------------------------------------
%
% version 1.0 -- June/2019
% Implemented by: Liyu Yang
% Contact Info  : yangliyuokn@sina.cn

Flength          = size(ObjValue,2);       % 所有目标
F0               = 1:Flength;
OutObjInd        = ismember(F0,F);
OutObj           = F0(~OutObjInd);
Result           = zeros(size(F0));
% 在已知聚类中心F中寻找与ia[距离]最近的目标
for ia           = OutObj
    Min          = (1-corr(ObjValue(:,F(1)),ObjValue(:,ia),'Type','Kendall'))/2;
    c            = 1;                      % 与ia[距离]最近的目标index
    for ib       = F(2:end)
        TempCorr = (1-corr(ObjValue(:,ib),ObjValue(:,ia),'Type','Kendall'))/2;
        if  TempCorr < Min
            Min  = TempCorr;
            c    = ib;
        end
    end
    % 与ia[距离]最近的聚类中心
    Result(ia)   = c;
end

