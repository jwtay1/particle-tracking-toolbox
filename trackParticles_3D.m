clearvars
clc

%Set up the tracking
L = LAPLinker;
L.LinkScoreRange = [0 50];

vid = VideoWriter('3Dtrack.avi');
vid.FrameRate = 5;
open(vid);

reader = BioformatsImage('230724PIVPilot2001.nd2');

zRange = 50:75;

h = figure('units','normalized','outerposition',[0 0 1 1]);

for iT = 1:13

    mask = false(reader.height, reader.width, numel(zRange));
    
    for iZ = 1:numel(zRange)

        I = getPlane(reader, zRange(iZ), 1, iT);

        %Identify the beads
        gauss1 = imgaussfilt(I, 4);
        gauss2 = imgaussfilt(I, 1);

        diffImage = gauss2 - gauss1;

        mask(:, :, iZ) = diffImage > 8;

    end

    data = regionprops(mask, 'Centroid');

    % c = cat(1, data.Centroid);
    % 
    % plot3(c(:, 1), c(:, 2), c(:, 3), 'o')
    % 
    % return

    L = assignToTrack(L, iT, data);
    
    %Create output image

    for iTrack = 1:numel(L.activeTrackIDs)

        ct = getTrack(L, L.activeTrackIDs(iTrack));
        plot3(ct.Centroid(end, 1), ct.Centroid(end, 2), ct.Centroid(end, 3), 'o')
        hold on
        text(ct.Centroid(end, 1), ct.Centroid(end, 2), ct.Centroid(end, 3), ...
            int2str(L.activeTrackIDs(iTrack)))
        
    end
    hold off
    frame = getframe(h);
    writeVideo(vid, frame);
    % close(h)
        
end

close(vid)









