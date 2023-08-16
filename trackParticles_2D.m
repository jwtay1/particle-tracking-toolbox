clearvars
clc

%Set up the tracking
L = LAPLinker;
L.LinkScoreRange = [0 50];

vid = VideoWriter('test.avi');
vid.FrameRate = 5;
open(vid);

reader = BioformatsImage('230724PIVPilot2001.nd2');

for iT = 1:13
    
    I = getPlane(reader, 50, 1, iT);

    %Identify the beads
    gauss1 = imgaussfilt(I, 4);
    gauss2 = imgaussfilt(I, 1);

    diffImage = gauss2 - gauss1;

    mask = diffImage > 8;

    data = regionprops(mask, 'Centroid');

    L = assignToTrack(L, iT, data);

    %Create output image
    Iout = double(I);
    Iout = (Iout - min(Iout(:)))/(max(Iout(:)) - min(Iout(:)));

    for iTrack = 1:numel(L.activeTrackIDs)

        ct = getTrack(L, L.activeTrackIDs(iTrack));
        Iout = insertText(Iout, ct.Centroid(end, :), L.activeTrackIDs(iTrack), ...
            'BoxOpacity', 0, 'TextColor', 'yellow');

        if size(ct, 1) > 1
            C = ct.Centroid;
            C = C';
            Iout = insertShape(Iout, line, C(:));
        end
    end

    writeVideo(vid, Iout);
        
end

close(vid)









