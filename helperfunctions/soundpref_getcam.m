function [] = soundpref_getcam()
%% soundpref_getcam

clc; close all;
% thisFolder=fileparts(which('soundpref_getcam.m'));
% addpath(thisFolder);
% cd(thisFolder);



%% ACQUIRE IMAGE ACQUISITION DEVICE (THERMAL CAMERA) OBJECT

% webcamlist
% cam = webcam('FaceTime')

% preview(cam)
% img = snapshot(cam);
% closePreview(cam)
% imshow(img)
% clear('cam');


cam = webcam; pause(1);

% cam.Brightness = 150;
camres = cam.AvailableResolutions;
camres = camres{1};
sx = strfind(camres, 'x');
camresX = str2num(camres(1:sx-1));
camresY = str2num(camres(sx+1:end));



Nframes = 10;
imgs = {zeros(camresY,camresX)};
imgs = repmat(imgs,Nframes,1);

for nn = 1:Nframes
    imgs{nn} = snapshot(cam);    % Acquire a single image.
end
clear('cam');

figure(1)
for nn = 1:Nframes
    imshow(imgs{nn})
    drawnow
end










% END MAIN FUNCTION
end







