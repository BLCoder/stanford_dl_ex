function vectorImage = imageTo20x20Gray(fileName, cropPercentage=0, rotStep=0)
%IMAGETO20X20GRAY display reduced image and converts for digit classification
%
% Sample usage: 
%       imageTo20x20Gray('myDigit.jpg', 100, -1);
%
%       First parameter: Image file name
%             Could be bigger than 20 x 20 px, it will
%             be resized to 20 x 20. Better if used with
%             square images but not required.
% 
%       Second parameter: cropPercentage (any number between 0 and 100)
%             0  0% will be cropped (optional, no needed for square images)
%            50  50% of available croping will be cropped
%           100  crop all the way to square image (for rectangular images)
% 
%       Third parameter: rotStep
%            -1  rotate image 90 degrees CCW
%             0  do not rotate (optional)
%             1  rotate image 90 degrees CW
%
% (Thanks to Edwin Frühwirth for parts of this code)
Image3DmatrixRGB = imread(fileName);
Image3DmatrixYIQ = rgb2ntsc(Image3DmatrixRGB );
Image2DmatrixBW  = Image3DmatrixYIQ(:,:,1);
oldSize = size(Image2DmatrixBW);
cropDelta = floor((oldSize - min(oldSize)) .* (cropPercentage/100));
finalSize = oldSize - cropDelta;
cropOrigin = floor(cropDelta / 2) + 1;
copySize = cropOrigin + finalSize - 1;
croppedImage = Image2DmatrixBW( ...
                    cropOrigin(1):copySize(1), cropOrigin(2):copySize(2));
scale = [28 28] ./ finalSize;
newSize = max(floor(scale .* finalSize),1); 
rowIndex = min(round(((1:newSize(1))-0.5)./scale(1)+0.5), finalSize(1));
colIndex = min(round(((1:newSize(2))-0.5)./scale(2)+0.5), finalSize(2));
newImage = croppedImage(rowIndex,colIndex,:);
newAlignedImage = rot90(newImage, rotStep);
invertedImage = - newAlignedImage;
maxValue = max(invertedImage(:));
minValue = min(invertedImage(:));
delta = maxValue - minValue;
normImage = (invertedImage - minValue) / delta;
contrastedImage = sigmoid((normImage -0.5) * 5);
imshow(contrastedImage, [-1, 1] );
vectorImage = reshape(contrastedImage, 1, newSize(1)*newSize(2));
end