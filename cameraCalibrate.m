function [RGBcalib W] = cameraCalibrate(RGB,Aperture,Shutter,whichCamera,transformType,whichMeasure,bComputeTransform,bPLOT)

% function [RGBcalib W] = cameraCalibrate(RGB,Aperture,Shutter,whichCamera,transformType,whichMeasure,bComputeTransform,bPLOT)
%
%   example call: [Icalib cameraCalibW] = cameraCalibrate(I,Aperture,Shutter,'D7H','XYZ',2,0);
%
% convert rgb image into LMS image, or Luminance Image, or XYZ image, etc.
%
% RGB:              image to transform nxnx1 if B&W image
%                                      nxnx3 if RGB image
% Aperture:         aperture of camera (f-stop number)
% Shutter:          shutter speed of camera
% whichCamera:     'D7H'
%                  'D7R'
% transformType:    'LMS'
%                   'Photopic'
%                   'Scotopic'
%                   'XYZ'
% whichMeasure:      two measurements were made in each calibration procedure
%                    1 -> load first measurement  (longer exposure)
%                    2 -> load second measurement (shorter exposure)
%                    NOTE: 2 apperas to give slightly better results...
% bComputeTransform: 1 -> recompute transform matrix from raw calibration data
%                    0 -> load pre-compute transform matrix
% bPLOT:             plot or not
%%%%%%%%%%%%%%%%
% RGBcalib:          calibrated image
% W:                 transform matrix

if ~exist('bPLOT','var')
    bPLOT = 0;
end

% ABORT IF whichCamera IS NaN
if isnan(whichCamera)
   RGBcalib = RGB;
   W = NaN;
   return; 
end

if bComputeTransform
    % COMPUTES THE TRANSFORMS FRESH EACH TIME
    [W K ApertureMax] = cameraCalibTransform(whichCamera,transformType,whichMeasure,0);
    killer = 1;
else
    % LOADS IN STORED CONVERSION MATRIX AND NORMALIZATION FACTORS
    [W K ApertureMax] = preComputedTransform(whichCamera,transformType,whichMeasure);
end

A = (ApertureMax.^2)./(Aperture.^2);
T = Shutter;

RGBsize = size(RGB);
RGBvec = reshape(RGB,[numel(RGB(:,:,1)) size(RGB,3)]);
if strcmp(transformType,'LMS')
    RGBcalibVec = (1  ./( (A)*T )) .* RGBvec * bsxfun(@rdivide,W,K);
elseif strcmp(transformType,'Photopic')
    RGBcalibVec = (683./( (A)*T )) .* RGBvec * bsxfun(@rdivide,W,K);
elseif strcmp(transformType,'Scotopic')
    error(['cameraCalibTransform: unhandled transformType ' transformType]);
elseif strcmp(transformType,'XYZ')
    RGBcalibVec = (683./( (A)*T )) .* RGBvec * bsxfun(@rdivide,W,K);
end
% RESHAPE BACK TO ORIGINAL IMAGE SIZE
RGBcalib = reshape(RGBcalibVec,[RGBsize(1:2) size(W,2)]);
% SCALE TO MAX VALUE OF 65535
RGBcalib = (2^16-1).*RGBcalib./max(RGBcalib(:));

% SET NEGATIVE VALUES TO VALUE VANISHINGLY CLOES TO ZERO
indNeg = find(RGBcalib < 0);
RGBcalib(indNeg) = eps;

if bPLOT
    % GET R,G,B PIXEL LOCATIONS THAT WERE LESS THAN 0
    [indNegR indNegG indNegB] = ind2sub(size(RGBcalib),indNeg);
    
    figure('position',[ 200         493        1002         507]);
    subplot(1,2,1);
    imagesc(sqrt(RGB./max(RGB(:))));
    formatFigure(' ', ' ','Original',0,0,22,18);
    axis square
    if size(RGB,3) == 1
        colormap gray;
    end
    
    subplot(1,2,2);
    imagesc(sqrt(RGBcalib./max(RGBcalib(:))));
    formatFigure([num2str(length(indNegR)) ' negative pixels'], ' ',transformType,0,0,22,18);
    axis square
    if size(RGBcalib,3) == 1
        colormap gray;
    end
    hold on; for i = 1:length(indNegR), plot(indNegG(i),indNegR(i),'b.'); end
    
end

function [W K ApertureMax] = preComputedTransform(whichCamera,transformType,whichMeasure)
if strcmp(whichCamera,'D7H')
    ApertureMax = 2.8;
    if strcmp(transformType,'LMS')
        if whichMeasure == 1,
            W = [0.7287    0.1884   -0.0156
                0.9234    1.0413   -0.0276
                0.0147    0.0815    0.9389];
            K = [3.5293
                1.6853
                2.2469].*1.0e+07;
        elseif whichMeasure == 2,
            W = [0.7312    0.1891   -0.0181
                0.9183    1.0358   -0.0300
                0.0094    0.0700    0.8372];
            K = [3.5184
                1.6677
                1.9706].*1.0e+07;
        else
            error(['cameraCalibrate: WARNING! unhandled whichMeasure ' num2str(whichMeasure) ' for ' transformType ' and ' whichCamera]);
        end
    elseif strcmp(transformType,'Photopic')
        if whichMeasure == 1,
            W = [0.5162
                0.9882
                -0.0028];
            K = [3.5184
                1.6677
                1.9706].*1.0e+07;
        elseif whichMeasure == 2,
            W = [0.4818
                1.0246
                0.0100];
            K = [3.5164
                1.6666
                2.0113].*1.0e+07;
        else
            error(['cameraCalibrate: WARNING! unhandled whichMeasure ' num2str(whichMeasure) ' for ' transformType ' and ' whichCamera]);
        end
    elseif strcmp(transformType,'Scotopic')
        if whichMeasure == 1,
            W = [-0.1201
                0.8503
                0.6369];
            K = [3.5293
                1.6853
                2.2469].*1.0e+07;
        elseif whichMeasure == 2,
            W = [-0.1230
                0.8470
                0.5706];
            K = [3.5184
                1.6677
                1.9706].*1.0e+07;
        else
            error(['cameraCalibrate: WARNING! unhandled whichMeasure ' num2str(whichMeasure) ' for ' transformType ' and ' whichCamera]);
        end
    elseif strcmp(transformType,'XYZ')
        if whichMeasure == 1,
            W = [0.9970    0.5144   -0.0185
                 0.2848    0.9929   -0.0087
                 0.2389    0.0098    0.9901];
            K = [3.5293
                 1.6853
                 2.2469].*1.0e+07;
        elseif whichMeasure == 2,
            W = [0.9995    0.5163   -0.0212
                 0.2820    0.9874   -0.0113
                 0.2102    0.0050    0.8836];
            K = [3.5184
                 1.6677
                 1.9706].*1.0e+07;
        else
            error(['cameraCalibrate: WARNING! unhandled whichMeasure ' num2str(whichMeasure) ' for ' transformType ' and ' whichCamera]);
        end
    else
        error(['cameraCalibrate: WARNING! unhandled transformType ' transformType ' for ' whichCamera]);
    end

elseif strcmp(whichCamera,'D7R')
    ApertureMax = 2.8;
    if strcmp(transformType,'LMS')
        if whichMeasure == 1,
            W = [0.7749    0.2135   -0.0152
                0.8920    1.0056   -0.0312
                0.0184    0.0831    0.8648];
            K = [2.7360
                1.3113
                1.4835].*1.0e+07;
        elseif whichMeasure == 2,
            W = [0.7609    0.2109   -0.0229
                0.9827    1.1016   -0.0293
                0.0232    0.0939    0.9270];
            K = [2.6869
                1.4507
                1.6196].*1.0e+07;
        else
            error(['cameraCalibrate: WARNING! unhandled whichMeasure ' num2str(whichMeasure) ' for ' transformType ' and ' whichCamera]);
        end
    elseif strcmp(transformType,'Photopic')
        if whichMeasure == 1,
            W = [0.5525
                0.9605
                0.0060];
            K = [2.7360
                1.3113
                1.4835].*1.0e+07;
        elseif whichMeasure == 2,
            W = [0.5432
                1.0559
                0.0105];
            K = [2.6869
                1.4507
                1.6196].*1.0e+07;
        else
            error(['cameraCalibrate: WARNING! unhandled whichMeasure ' num2str(whichMeasure) ' for ' transformType ' and ' whichCamera]);
        end
    elseif strcmp(transformType,'Scotopic')
        if whichMeasure == 1,
            W = [-0.1160
                0.8047
                0.6155];
            K = [2.7360
                1.3113
                1.4835].*1.0e+07;
        elseif whichMeasure == 2,
            W = [-0.1131
                0.8686
                0.6622];
            K = [2.6869
                1.4507
                1.6196].*1.0e+07;
        else
            error(['cameraCalibrate: WARNING! unhandled whichMeasure ' num2str(whichMeasure) ' for ' transformType ' and ' whichCamera]);
        end
    elseif strcmp(transformType,'XYZ')
        error(['cameraCalibrate: WARNING! unhandled transformType ' transformType ' for ' whichCamera]);
    else
        error(['cameraCalibrate: WARNING! unhandled transformType ' transformType ' for ' whichCamera]);
    end
end
end
end