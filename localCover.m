function [u, Pprio] = localCover(r_UABBS, u, Pprio, Psec)
    % r_UABBS: 無人機的涵蓋範圍
    % u: 當前無人機位置，向量形式[x,y]
    % Pprio: 無人機涵蓋的UE
    % Psec: 未被覆蓋的UE
    
    % 1
    while ~isempty(Psec)
        % 2
        for i = 1:size(Psec, 1)
            if i > size(Psec, 1)
                break
            end
            distances = pdist2(Psec(i,:), Pprio);
            for j = 1:size(distances, 2)
                if distances(j) > 2*r_UABBS
                    Psec(i,:) = [];
                    i = i-1;
                    break;
                end
            end
        end
        
        distances = pdist2(Psec, u);
        for i = 1:size(distances, 1)
            if i > size(distances, 1)
                break
            end
            if distances(i)  <= r_UABBS
                disp('distances(i)')
                disp(distances(i))
                Pprio(size(Pprio, 1)+1,:) = Psec(i,:);
                Psec(i,:) = [];
                distances(i,:) = [];
                i = i-1;
            end
        end


        % 3
        distances = pdist2(Psec, u);
        for i = 1:size(distances, 1)
            if i > size(distances, 1)
                break
            end
            if distances(i)  == min(distances)
                newPprio = Pprio;
                newPprio(size(newPprio,1)+1,:) = Psec(i,:);
                newU = [mean(Pprio(:, 1)), mean(Pprio(:, 2))];
                for j=1:size(newPprio, 1)
                    distances = pdist2(newPprio(j,:), newU);
                    if distances > r_UABBS
                        return
                    end
                end
                Pprio = newPprio;
                Psec(i,:) = [];
                u = newU;
                break
            end
        end
    end
end