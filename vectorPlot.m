%[1 1 512 512]

%Divide image
tRange = [10 13];
xRange = 1:16:512;
xRange = [xRange 512];

counter = 1;
for iTrack = 1:numel(tracks)

    ct = getTrack(tracks, iTrack);

    indStart = find(ct.Frames == tRange(1), 1, 'first');
    indEnd = find(ct.Frames == tRange(end), 1, 'first');

    if ~isempty(indStart) && ~isempty(indEnd)

        particle(counter).vector = ct.Centroid(indEnd, :) - ct.Centroid(indStart, :);
        particle(counter).Start = ct.Centroid(indStart, :);

    end

    counter = counter + 1;

end

%Calculate averages
X = [];
Y = [];
U = [];
V = [];

allVectors = cat(1, particle.vector);
allStarts = cat(1, particle.Start);

for iCol = 1:(numel(xRange) - 1)
    for iRow = 1:(numel(xRange) - 1)
        
        X = [X; xRange(iCol) + (xRange(iCol + 1) - xRange(iCol))/2];
        Y = [Y; xRange(iRow) + (xRange(iRow + 1) - xRange(iRow))/2];

        %Check average vector
        idx = allStarts(:, 1) < xRange(iRow + 1) & allStarts(:, 1) >= xRange(iRow);
        idx = idx & (allStarts(:, 2) < xRange(iCol + 1) & allStarts(:, 2) >= xRange(iCol));
        
        avgVector = mean(allVectors(idx, :));
        
        U = [U; avgVector(1)];
        V = [V; avgVector(1)];

    end
end

quiver(X, Y, U, V, 2)
axis image











