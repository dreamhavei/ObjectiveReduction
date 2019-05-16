function [MinDeltaUnion] = DeltaExact(Objective,delta)
%=========================================================================%
%                           DeltaExact 算法                               %
%=========================================================================%
% Description:
%   精确的delta算法
%-------------------------------------------------------------------------
% Input:  Name          description     type
%         Objective     目标值          array
%         delta         delta值         double
% Output: 
%         MinDeltaUnion 最下目标集       vector(double)
%-------------------------------------------------------------------------
%
% version 1.0 -- May/2019
% Implemented by: Liyu Yang
% Contact Info  : yangliyuokn@sina.cn

%% 初始化
[NumInd,NumObj]                                         = size(Objective);
MinDeltaUnion                                           =  [];

%%
% a                                                     = 1;
% b                                                     = 2;
for a                                                   = 1:NumInd-1
    for b                                               = a+1:NumInd
        NewSet                                          = {}; 
%---------- 计算得到个体a和b的满足Detla小于detla保存对应目标对 ---------------
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
 % MinDeltaUnion 用于保存最小集 个体合并
     if isempty(MinDeltaUnion)
         MinDeltaUnion                                  =  MinDelta;
     else
     ih                                                 = 1;
     for id                                             = 1:size(MinDeltaUnion,1)
         Set1                                           = MinDeltaUnion(id,:);
         for ie                                         = 1:size(MinDelta,1)
             Set2                                       = MinDelta(ie,:);
             % 对不同的个体组合进行两两合并
             TempDelta                                  = max(Set1{2},Set2{2}); 
             if TempDelta <= delta
                 TempSet{1}                             = union(Set1{1},Set2{1});
                 TempSet{2}                             = TempDelta;
                 % TODO 对同一个体组合不同的目标组合进行合并
                 if isempty(NewSet)
                     NewSet                             = TempSet;
                     ih                                 = ih + 1;
                 else
                     flag                               = 0;    % 不存在关联性
                     Statue                             = zeros(1,size(NewSet,1)); % 2:替换 1:增加
                     for ig                             = 1:size(NewSet,1)
                        if or(all(ismember(NewSet{ig,1},TempSet{1,1})),all(ismember(TempSet{1,1},NewSet{ig,1})))
                            % NewSet{ig}是TempSet子集或者相反
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
                                % 有比新的优 old:[{1,2},0.5] new:[{1,2},0.51]
                               Statue(ig)               = 3;
                            end
                        else
                            % 不存在关联性
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
%   计算个体{a,b}在目标SelObj和F之间的detla值
% Input:  Name      description     type
%         a         个体a           double
%         b         个体b           double
%         Objective 目标值          array(double)
%         SelObj    选中的目标      vector(double)

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

