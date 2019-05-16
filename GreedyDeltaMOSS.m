function [SelectedObj] = GreedyDeltaMOSS(Objective,delta)
%=========================================================================%
%                         detla-MOSS贪心算法                              %
%=========================================================================%
% Description:
%   detla-MOSS贪心算法
%-------------------------------------------------------------------------
% Input:  Name          description     type
%         Objective     目标值          array
%         delta         delta值         double
% Output: 
%         SelectedObj  选择的目标       vector(double)
%-------------------------------------------------------------------------
%
% version 1.0 -- May/2019
% Implemented by: Liyu Yang
% Contact Info  : yangliyuokn@sina.cn

%% 初始化
[NumInd,NumObj]            = size(Objective);
R                          = ~WeaklyDominate(Objective);       % 计算所有目标所有个体之间的弱支配关系
for ic                     = 1:NumObj                          % 计算单个目标所有个体之间的弱支配关系
    SingleDom{ic}          = WeaklyDominate(Objective(:,ic));
end   
SmallSize                  = NumInd*NumInd;
SelectedObj                = 0;
Range                      = 1:NumObj;
Chosen                     = zeros(1,NumObj,'logical');

%% 循环
while SmallSize ~=0
    for id                 = 1:NumObj
        if ~Chosen(id)
            Chosen(id)     = true;
            Mark           = Range(Chosen);                    % 用于选择合并那个目标 i
            NotMark        = Range(~Chosen);
            TwoR           = and(WeaklyDominate(Objective(:,Mark)),EpsilonDom(Objective,delta,NotMark));
            TempR          = and(R,SingleDom{id});
            TempR(TwoR==1) = 0;
            CurrentSize    = sum(TempR(:));                      % 当前存在支配关系个数
            if CurrentSize < SmallSize
                SmallSize  = CurrentSize;   % 比较
                Selected   = id;
                UsedR      = TempR;
            end
            Chosen(id)     = false;
        end
    end
    Chosen(Selected)       = true; 
    R                      = UsedR;         % 
end
SelectedObj                = Range(Chosen);

%==========================================================================
function R1             = WeaklyDominate(Objective)
% Description:
%   计算给定目标所有个体之间的弱支配关系 R 
%   R1(i,j) = 1 表示第i个体支配第j个体
% TODO 优化速度 变成矩阵用any all
for ia                  = 1:size(Objective,1)
    for ib              = 1:size(Objective,1)
        R1(ia, ib)      = WeakDominate(Objective(ia, :), Objective(ib, :));
    end
end
end
%--------------------------------------------------------------------------
function Relation       = EpsilonDom(Objective,delta,Pos)
% Description:
%   计算给定目标所有个体之间的epsilon支配关系 R  
% TODO 优化速度 变成矩阵用any all
for ie                  = 1:size(Objective,1)
    for ig              = 1:size(Objective,1)
        Relation(ie,ig) = EpsilonDominate(Objective(ie,:),Objective(ig,:),delta,Pos);
    end
end
end
end


