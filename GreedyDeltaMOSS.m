function [SelectedObj] = GreedyDeltaMOSS(Objective,delta)
%=========================================================================%
%                         detla-MOSS̰���㷨                              %
%=========================================================================%
% Description:
%   detla-MOSS̰���㷨
%-------------------------------------------------------------------------
% Input:  Name          description     type
%         Objective     Ŀ��ֵ          array
%         delta         deltaֵ         double
% Output: 
%         SelectedObj  ѡ���Ŀ��       vector(double)
%-------------------------------------------------------------------------
%
% version 1.0 -- May/2019
% Implemented by: Liyu Yang
% Contact Info  : yangliyuokn@sina.cn

%% ��ʼ��
[NumInd,NumObj]            = size(Objective);
R                          = ~WeaklyDominate(Objective);       % ��������Ŀ�����и���֮�����֧���ϵ
for ic                     = 1:NumObj                          % ���㵥��Ŀ�����и���֮�����֧���ϵ
    SingleDom{ic}          = WeaklyDominate(Objective(:,ic));
end   
SmallSize                  = NumInd*NumInd;
SelectedObj                = 0;
Range                      = 1:NumObj;
Chosen                     = zeros(1,NumObj,'logical');

%% ѭ��
while SmallSize ~=0
    for id                 = 1:NumObj
        if ~Chosen(id)
            Chosen(id)     = true;
            Mark           = Range(Chosen);                    % ����ѡ��ϲ��Ǹ�Ŀ�� i
            NotMark        = Range(~Chosen);
            TwoR           = and(WeaklyDominate(Objective(:,Mark)),EpsilonDom(Objective,delta,NotMark));
            TempR          = and(R,SingleDom{id});
            TempR(TwoR==1) = 0;
            CurrentSize    = sum(TempR(:));                      % ��ǰ����֧���ϵ����
            if CurrentSize < SmallSize
                SmallSize  = CurrentSize;   % �Ƚ�
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
%   �������Ŀ�����и���֮�����֧���ϵ R 
%   R1(i,j) = 1 ��ʾ��i����֧���j����
% TODO �Ż��ٶ� ��ɾ�����any all
for ia                  = 1:size(Objective,1)
    for ib              = 1:size(Objective,1)
        R1(ia, ib)      = WeakDominate(Objective(ia, :), Objective(ib, :));
    end
end
end
%--------------------------------------------------------------------------
function Relation       = EpsilonDom(Objective,delta,Pos)
% Description:
%   �������Ŀ�����и���֮���epsilon֧���ϵ R  
% TODO �Ż��ٶ� ��ɾ�����any all
for ie                  = 1:size(Objective,1)
    for ig              = 1:size(Objective,1)
        Relation(ie,ig) = EpsilonDominate(Objective(ie,:),Objective(ig,:),delta,Pos);
    end
end
end
end


