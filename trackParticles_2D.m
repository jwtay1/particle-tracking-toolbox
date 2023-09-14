clearvars
clc

%For poster: 'ROI', [104 111 150 150]

%Set up the tracking
L = LAPLinker;
L.LinkScoreRange = [0 12];

%ROI = [171 84 150 150];

% vid = VideoWriter('2Dtracks_arrows.avi');
% vid.FrameRate = 5;
% open(vid);

reader = BioformatsImage('../data/230724PIVPilot2001.nd2');

ROI = [1 1 reader.width reader.height];

fh = figure;
for iT = 1:reader.sizeT
    
    %Create an MIP
    %I = zeros(reader.height, reader.width, 'uint16');
    I = zeros(ROI(4), ROI(3), 'uint16');
    for iZ = 45:54
        I = max(getPlane(reader, iZ, 1, iT, ...
            'ROI', ROI), I);
    end

    %Identify the beads
    gauss1 = imgaussfilt(I, 4);
    gauss2 = imgaussfilt(I, 1);

    diffImage = gauss2 - gauss1;

    mask = diffImage > 8;

    data = regionprops(mask, 'Centroid');

    L = assignToTrack(L, iT, data);

    % %Create output image
    % Iout = double(I);
    % Iout = (Iout - min(Iout(:)))/(max(Iout(:)) - min(Iout(:)));
    % 
    % 
    % imshow(Iout, [])
    % hold on
    % for iTrack = 1:numel(L.activeTrackIDs)
    % 
    %     ct = getTrack(L, L.activeTrackIDs(iTrack));
    %     %Iout = insertText(Iout, ct.Centroid(end, :), L.activeTrackIDs(iTrack), ...
    %     %    'BoxOpacity', 0, 'TextColor', 'yellow');
    %     Iout = insertShape(Iout, 'circle', [ct.Centroid(end, :) 5], ...
    %        'color', 'red');
    %     % 
    %     % 
    %     if size(ct.Centroid, 1) > 1
    %         plot(ct.Centroid(:, 1), ct.Centroid(:, 2))
    %         % C = (ct.Centroid)';
    %         % Iout = insertShape(Iout, 'line', C(:)', ...
    %         %     'Color', 'white');
    %     end
    % 
    % 
    %     % if size(ct.Centroid, 1) > 1
    %     %     quiver(ct.Centroid(1, 1), ct.Centroid(1, 2), ...
    %     %         ct.Centroid(1, 1) - ct.Centroid(end, 1), ...
    %     %         ct.Centroid(1, 2) - ct.Centroid(end, 2), 2)
    %     % end
    % end
    % hold off
    % Iout = getframe(fh);
    % 
    % writeVideo(vid, Iout);
    
        
end
% close(fh);

% close(vid)

%Save data
tracks = L.tracks;

% export(tracks, '20230911_230828_10wt_PIV.csv')

%% Create image for poster
iT = 1;
I = zeros(ROI(4), ROI(3), 'uint16');
for iZ = 1:reader.sizeZ
    I = max(getPlane(reader, iZ, 1, iT, ...
        'ROI', ROI), I);
end

Iout = double(I);
Iout = (Iout - min(Iout(:)))/(max(Iout(:)) - min(Iout(:)));

imshow(Iout, [])
hold on
for iTrack = 1:L.NumTracks

    ct = getTrack(L, iTrack);
    %Iout = insertText(Iout, ct.Centroid(end, :), L.activeTrackIDs(iTrack), ...
    %    'BoxOpacity', 0, 'TextColor', 'yellow');
    % Iout = insertShape(Iout, 'circle', [ct.Centroid(end, :) 5], ...
    %     'color', 'red');
    %
    %
    if size(ct.Centroid, 1) > 1
        plot(ct.Centroid(:, 1), ct.Centroid(:, 2), 'LineWidth', 1.5)
        % C = (ct.Centroid)';
        % Iout = insertShape(Iout, 'line', C(:)', ...
        %     'Color', rand(1, 3), 'LineWidth', 2);
    end


    % if size(ct.Centroid, 1) > 1
    %     quiver(ct.Centroid(1, 1), ct.Centroid(1, 2), ...
    %         ct.Centroid(1, 1) - ct.Centroid(end, 1), ...
    %         ct.Centroid(1, 2) - ct.Centroid(end, 2), 2)
    % end
end
hold off






