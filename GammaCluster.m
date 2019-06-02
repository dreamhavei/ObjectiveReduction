function [Result] = GammaCluster(F,ObjValue)
%=========================================================================%
%                              GammaCluster �㷨                          %
%=========================================================================%
% Description:
%   ��ia[����]����ľ�������(F)
%-------------------------------------------------------------------------
% Input:  Name          description     type
%         F             Ŀ���Ӽ�        vector

%         ObjValue      ����Ŀ��ֵ      array
% Output: 
%         Result        ������        cell(double)
%-------------------------------------------------------------------------
%
% version 1.0 -- June/2019
% Implemented by: Liyu Yang
% Contact Info  : yangliyuokn@sina.cn

Flength          = size(ObjValue,2);       % ����Ŀ��
F0               = 1:Flength;
OutObjInd        = ismember(F0,F);
OutObj           = F0(~OutObjInd);
Result           = zeros(size(F0));
% ����֪��������F��Ѱ����ia[����]�����Ŀ��
for ia           = OutObj
    Min          = (1-corr(ObjValue(:,F(1)),ObjValue(:,ia),'Type','Kendall'))/2;
    c            = 1;                      % ��ia[����]�����Ŀ��index
    for ib       = F(2:end)
        TempCorr = (1-corr(ObjValue(:,ib),ObjValue(:,ia),'Type','Kendall'))/2;
        if  TempCorr < Min
            Min  = TempCorr;
            c    = ib;
        end
    end
    % ��ia[����]����ľ�������
    Result(ia)   = c;
end

