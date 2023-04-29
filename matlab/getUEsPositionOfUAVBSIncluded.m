function UEsPositionOfUAVBSIncluded = getUEsPositionOfUAVBSIncluded(r_UAVBS, locationOfUEs, UAVBSsSet)
    UEsPositionOfUAVBSIncluded = {};

    for i=1:size(UAVBSsSet,1)
        UEsPositionOfUAVBSIncluded{i} = zeros(0,2);
        for j=1:size(locationOfUEs,1)
            if pdist2(UAVBSsSet(i,:), locationOfUEs(j,:)) <= r_UAVBS
                UEsPositionOfUAVBSIncluded{i}(size(UEsPositionOfUAVBSIncluded{i},1)+1,:) = locationOfUEs(j,:);
            end
        end
    end
end