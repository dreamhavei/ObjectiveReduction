function [MinDeltaUnion] = DeltaExact(Objective,delta)
%=========================================================================%
%                           DeltaExact �㷨                               %
%=========================================================================%
% Description:
%   ��ȷ��delta�㷨
%-------------------------------------------------------------------------
% Input:  Name          description     type
%         Objective     Ŀ��ֵ          array
%         delta         deltaֵ         double
% Output: 
%         MinDeltaUnion ����Ŀ�꼯       vector(double)
%-------------------------------------------------------------------------
%
% version 1.0 -- May/2019
% Implemented by: Liyu Yang
% Contact Info  : yangliyuokn@sina.cn

%% ��ʼ��
[NumInd,NumObj]                                         = size(Objective);
MinDeltaUnion                                           =  [];

%%
% a                                                     = 1;
% b                                                     = 2;
for a                                                   = 1:NumInd-1
    for b                                               = a+1:NumInd
        NewSet                                          = {}; 
%---------- ����õ�����a��b������DetlaС��detla�����ӦĿ��� ---------------
        ik                                              = 1;
        for ib                                          = 1:NumObj
            for ic                                      = ib:NumObj
                SelObj                                  = [ib,ic];
                Delta                                   = ComputeDelta(a,b,SelObj,Objective);
                if Delta           <= delta
                    MinDelta(ik,:)                      = {SelObj,Delta};
                    ik                                  = ik + 1;
                end
            end
        end
 %-------------------------------------------------------------------------
 % MinDeltaUnion ���ڱ�����С�� ����ϲ�
     if isempty(MinDeltaUnion)
         MinDeltaUnion                                  =  MinDelta;
     else
     ih                                                 = 1;
     for id                                             = 1:size(MinDeltaUnion,1)
         Set1                                           = MinDeltaUnion(id,:);
         for ie                                         = 1:size(MinDelta,1)
             Set2                                       = MinDelta(ie,:);
             % �Բ�ͬ�ĸ�����Ͻ��������ϲ�
             TempDelta                                  = max(Set1{2},Set2{2}); 
             if TempDelta <= delta
                 TempSet{1}                             = union(Set1{1},Set2{1});
                 TempSet{2}                             = TempDelta;
                 % TODO ��ͬһ������ϲ�ͬ��Ŀ����Ͻ��кϲ�
                 if isempty(NewSet)
                     NewSet                             = TempSet;
                     ih                                 = ih + 1;
                 else
                     flag                               = 0;    % �����ڹ�����
                     Statue                             = zeros(1,size(NewSet,1)); % 2:�滻 1:����
                     for ig                             = 1:size(NewSet,1)
                        if or(all(ismember(NewSet{ig,1},TempSet{1,1})),all(ismember(TempSet{1,1},NewSet{ig,1})))
                            % NewSet{ig}��TempSet�Ӽ������෴
                            if and(length(NewSet{ig,1}) == length(TempSet{1}),NewSet{ig,2}>TempSet{2})
                                % old:[{1,2},1] new:[{1,2},0.5]
                                Statue(ig)              = 2;
                            elseif and(length(NewSet{ig,1}) > length(TempSet{1}),NewSet{ig,2}==TempSet{2})
                                % old:[{1,2,3},1] new:[{1,2},1]
                                Statue(ig)              = 2;
                            elseif and(length(NewSet{ig,1}) > length(TempSet{1}),NewSet{ig,2}>TempSet{2})
                                % old:[{1,2,3},1] new:[{1,2},0.5]
                                Statue(ig)              = 2;
                            elseif and(length(NewSet{ig,1}) < length(TempSet{1}),NewSet{ig,2}>TempSet{2})
                                 % old:[{1,2},1] new:[{1,2,3},0.5]
                                 Statue(ig)             = 1;
                            elseif and(length(NewSet{ig,1}) > length(TempSet{1}),NewSet{ig,2}<TempSet{2})
                               % old:[{1,2,3},0.5] new:[{1,2},1]
                               Statue(ig)               = 1;
                            elseif and(length(NewSet{ig,1}) <= length(TempSet{1}),NewSet{ig,2}<=TempSet{2})
                                % �б��µ��� old:[{1,2},0.5] new:[{1,2},0.51]
                               Statue(ig)               = 3;
                            end
                        else
                            % �����ڹ�����
                            flag                        = flag + 1;
                        end
                     end
                     if flag                            == size(NewSet,1)
                         Statue(ig)                     = 1;
                     end
                     if max(Statue)==3
                         continue;
                     elseif max(Statue)==2
                         ReplIndex                      = find(Statue==2);
                         NewSet(ReplIndex(1),:)         = TempSet(:);
                         for ij                         = length(ReplIndex):-1:2
                             NewSet(ReplIndex(ij),:)    = [];
                             ih                         = ih - 1;
                         end
                     elseif max(Statue)==1
                          NewSet(ih,:)                  = TempSet(:);
                          ih                            = ih + 1;
                     end
                 end
             end
         end
     end
     end
     if ~isempty(NewSet)
         MinDeltaUnion                                  = NewSet;
     end
%-------------------------------------------------------------------------
    clear MinDelta
    end
end


%========================================================================
function Delta    = ComputeDelta(a,b,SelObj,Objective)
% Description:
%   �������{a,b}��Ŀ��SelObj��F֮���detlaֵ
% Input:  Name      description     type
%         a         ����a           double
%         b         ����b           double
%         Objective Ŀ��ֵ          array(double)
%         SelObj    ѡ�е�Ŀ��      vector(double)

Delta             = 0;
if (SelObj(1)     == SelObj(2))
    if (Objective(a,SelObj(1))) <= (Objective(b,SelObj(1)))
        for ia    = 1:size(Objective,2)
            Delta = max(Delta,Objective(a,ia)-Objective(b,ia));
        end
    end
    if (Objective(b,SelObj(1))) <= (Objective(a,SelObj(1)))
        for ia    = 1:size(Objective,2)
            Delta = max(Delta,Objective(b,ia)-Objective(a,ia));
        end
    end
else
    if and((Objective(a,SelObj(1))) <= (Objective(b,SelObj(1))),(Objective(a,SelObj(2))) <= (Objective(b,SelObj(2))))
        for ia    = 1:size(Objective,2)
            Delta = max(Delta,Objective(a,ia)-Objective(b,ia));
        end
    end
    if and((Objective(b,SelObj(1))) <= (Objective(a,SelObj(1))),(Objective(b,SelObj(2))) <= (Objective(a,SelObj(2))))
        for ia    = 1:size(Objective,2)
            Delta = max(Delta,Objective(b,ia)-Objective(a,ia));
        end
    end
end

