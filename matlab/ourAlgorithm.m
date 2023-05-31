function [UAVBSsSet, UAVBSsR, UEsPositionOfUAVBSIncluded] = ourAlgorithm(locationOfUEs, minDataTransferRateOfUEAcceptable, config)
    % config.minHeight: 法定最低高度
    % config.maxHeight: 法定最高高度
    % config.maxNumOfUE: 無人機符合滿意度之下，能服務的最大UE數量
    % locationOfUEs: 所有UE的位置 []
    % UAVBSsSet: 所有無人機的位置 []

    maxNumOfUE = int32(config("bandwidth")/minDataTransferRateOfUEAcceptable) % 無人機符合滿意度之下，能服務的最大UE數量
    angle = 90; % 旋轉排序的起始角度(0~360deg)

    % Initialization
    uncoveredUEsSet = locationOfUEs;
    UAVBSsSet = [];
    UAVBSsR = [];
    centerUE = [];
    UEsPositionOfUAVBSIncluded = {};

    % 演算法第1行
    [uncoveredBoundaryUEsSet, angle] = findBoundaryUEsSet(false, uncoveredUEsSet, angle); % 找出邊緣並以逆時針排序
    while ~isempty(uncoveredBoundaryUEsSet)
        % 演算法第2行
        uncoveredInnerUEsSet = setdiff(uncoveredUEsSet, uncoveredBoundaryUEsSet, 'rows');
        centerUE = uncoveredBoundaryUEsSet(1,:);

        % 演算法第3行
        % 涵蓋邊緣點[newPositionOfUAVBS, secondLocalCoverPprio, r]
        [firstLocalCoverU, firstLocalCoverPprio, ~] = ourLocalCover(centerUE, centerUE, setdiff(uncoveredBoundaryUEsSet, centerUE, 'rows'), maxNumOfUE, config);

        % 演算法第4行
        % 涵蓋內點
        [secondLocalCoverU, secondLocalCoverPprio, r] = ourLocalCover(firstLocalCoverU, firstLocalCoverPprio, uncoveredInnerUEsSet, maxNumOfUE, config);
        r = max(r, config("minR"));

        % 演算法第5行
        % 更新結果
        UAVBSsSet(size(UAVBSsSet,1)+1,:) = secondLocalCoverU;
        uncoveredUEsSet = setdiff(uncoveredUEsSet, secondLocalCoverPprio, 'rows');
        UAVBSsR(size(UAVBSsR,1)+1,1) = r;
        UEsPositionOfUAVBSIncluded{1,size(UEsPositionOfUAVBSIncluded,2)+1} = secondLocalCoverPprio;

        % 演算第6行
        % 以不更改排序的情況下移除未覆蓋邊緣集合裡已覆蓋的邊緣點
        commonRows = ismember(uncoveredBoundaryUEsSet, secondLocalCoverPprio, 'rows');
        uncoveredBoundaryUEsSet(commonRows,:) = [];
        if isempty(uncoveredBoundaryUEsSet)
            [uncoveredBoundaryUEsSet, angle] = findBoundaryUEsSet(false, uncoveredUEsSet, angle);
        end
    end
end