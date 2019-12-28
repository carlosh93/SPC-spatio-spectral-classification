function RGB = ind2rgb8(X, CMAP)
%IND2RGB8 Convert indexed image to uint8 RGB image
%
%   RGB = IND2RGB8(X,CMAP) creates an RGB image of class uint8.  X must be
%   uint8, uint16, or double, and CMAP must be a valid MATLAB colormap.
%
%   Example 
%   -------
%      % Convert the 'boston.tif' image to RGB.
%      [X, cmap, R, bbox] = geotiffread('boston.tif');
%      RGB = ind2rgb8(X, cmap);
%      mapshow(RGB, R);
%
%   See also IND2RGB.

% Copyright 1996-2006 The MathWorks, Inc.
% $Revision: 1.1.6.2 $  $Date: 2006/05/24 03:34:31 $ 

RGB = ind2rgb8c(X, CMAP);
