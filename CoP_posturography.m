function [mean_AP, mean_ML, stdev_AP, stdev_ML, rms_AP, rms_ML, ampDisp_AP, ampDisp_ML,...
    meanVel_AP, meanVel_ML, cpAreaConf, cpTotalMeanVel, pathLength]...
    = CoP_posturography(CoP_AP, CoP_ML)
%This function uses anteroposterior (AP) and mediolateral (ML) center of pressure
%data to calculate multiple metrics commonly used to quantify postural
%control. This code DOES NOT filter your data. 
%Inputs: AP center of pressure (array), ML center of pressure (array)
%**This code has been verrified to work when center of pressure data is imported
%from a single force plate. 
%Outputs: mean AP, mean ML, stdev AP, stdev ML, rms AP, rms ML, 
%amplitude of displacement AP, amplitude of displacement ML, mean velocity
%AP, mean velocity of ML, 95% ellipse (sway area), total mean velocity, path length
%Author: Daniel Kuhman
%Author Contact: danielkuhman@gmail.com
%Date Updated: 1/21/2020

    %Mean AP CoP
    mean_AP = mean(CoP_AP);
    mean_ML = mean(CoP_ML);

    %Standard deviation
    stdev_AP = std(CoP_AP);
    stdev_ML = std(CoP_ML);

    %Root mean square
    rms_AP = sqrt(mean(CoP_AP.^2));
    rms_ML = sqrt(mean(CoP_ML.^2)); 

    %Amplitude of CP displacement 
    ampDisp_AP = max(CoP_AP) - min(CoP_AP);
    ampDisp_ML = max(CoP_ML) - min(CoP_ML);

    %Mean velocity
    meanVel_AP = mean(abs(diff(CoP_AP)))*frequency;
    meanVel_ML = mean(abs(diff(CoP_ML)))*frequency;

    %Area - Calculated based on equations from Doyle et al. (2007)
    %Find covariance between AP and ML CoP vectors
    covarMat = cov(CoP_AP,CoP_ML);
    SDapml = covarMat(1,2);
    %Calculate D
    tempForD = ((stdev_AP.^2)+(stdev_ML.^2))-(4*((stdev_AP.^2)*(stdev_ML.^2)-SDapml));
    D = sqrt(abs(tempForD));
    %Define major axis
    major_axis = sqrt(3*((stdev_AP^2)+(stdev_ML^2)+D));
    %Define minor axis
    minor_axis = sqrt(3*((stdev_AP^2)+(stdev_ML^2)-D));
    %Calculate area of ellipse 
    cpArea = pi*major_axis*minor_axis;
    %Area with 95% Confidence
    cpAreaConf = 2*pi*3*sqrt((stdev_AP^2)*(stdev_ML^2)-(SDapml^2));

    %Test cpArea (from Duerte)
    %http://nbviewer.jupyter.org/github/demotu/BMC/blob/master/notebooks/PredictionEllipseEllipsoid.ipynb
    %This is a published code for sway area, so you can run this in place
    %of the above code - both result in the same or very similar outcomes
    %(tested and confirmed to be similar on approximately 750 trials)
%     combineAPML = [copY_filt, copX_filt];
%     [n,p] = size(combineAPML);
%     covar = cov(combineAPML);
%     [U,S,V] = svd(covar);
%     f95 = finv(.95,p,n-p)*(n-1)*p*(n+1)/n/(n-p);
%     saxes = sqrt(diag(S)*f95);
%     testCpAreaConf = pi^(p/2)/gamma(p/2+1)*prod(saxes);

    %Total mean velocity 
    cpTotalMeanVel = mean(sqrt(diff(CoP_AP).^2 + diff(CoP_ML).^2))*frequency;

    %Center of pressure path length
    pathLengthSqrts = zeros(length(CoP_AP),1);

    for j = 1:length(CoP_AP)      
        if j == length(CoP_AP)
            break
        else   
        pathLengthSqrts(j,1) = sqrt((CoP_AP(j+1)-CoP_AP(j)).^2+(CoP_ML(j+1)-CoP_ML(j)).^2);   
        end
    end

    pathLength = sum(pathLengthSqrts);

end

