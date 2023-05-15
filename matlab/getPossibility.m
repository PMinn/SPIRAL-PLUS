function possibility = getPossibility(UAVBSsSet, UEsPositionOfUAVBSIncluded, a, b, r_UAVBS)
    % possibility: LoS及NLoS機率 {[Los,NLos;...],[Los,NLos;...],...}
    % a: 環境變數
    % b: 環境變數
    
    UAVBSsHigh = getHeightByArea(r_UAVBS); % UAVBS無人機的高度

    for i=1:size(UAVBSsSet(:,1),1)%UAV個數
        % 算式(2)
        UAVandUEsHorDist = pdist2(UAVBSsSet(i,:),UEsPositionOfUAVBSIncluded{i}); % 該UAV到UE的距離 [d1 d2 d3...;]
        for j=1:size(UAVandUEsHorDist,2)
            % 算式(1)
            possibility{i}(j,1) = 1 / (1 + a * exp(-b * (180 * atan(UAVBSsHigh / UAVandUEsHorDist(j)) / pi - a)));
            possibility{i}(j,2) = 1 - possibility{i}(j,1);
        end
    end
end