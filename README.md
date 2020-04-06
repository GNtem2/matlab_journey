# matlab_journey
This is a simple introduction to matlab for image analysis. The codes used here require installation of image processing toolbox, deep learning toolbox. 

Volume: This part deals with calculation of volume of a binary mask containing ones and zeroes. The file Niti_vol.m also contains codes in R and fsl for performing the same task are also provided.

```matlab
%matlab
ImN='test.nii'; %assign ImN 
info=niftiinfo(ImN);%check dimensions of ImN
Roi=niftiread(ImN); %Roi is handle for image

%nnz=number of nonzero elements
Volume=nnz(Roi)*info.PixelDimensions(1)*info.PixelDimensions(2)*info.PixelDimensions(3)/1000
%equivalent codes in fsl
%fslstats 1000M_ica.nii -V

%describe shape of volume
Roi=Roi>0.5; %ensure binary mask
s = regionprops3(Roi,"Centroid","PrincipalAxisLength","Orientation","Extent","Solidity");
centers = s.Centroid; %note s is the output of regionprops3. Centroid is a subset of s.
angles=s.Orientation;
axislength=s.PrincipalAxisLength;
ratio=s.Extent;
solidity=s.Solidity;

```

TSNE: This part deals with calculation of centre of gravity of a binary image. The file tsne_image.m illustrates the use of random number to create 3D array and 3D plot with scatter3. T-stochastic neighbourhood embedding (tsne) is used to visualise the low dimensional representation of the imaging data. the outputs of tsne are illustrated with 4 subplots, each created from different distance measurements. 

```matlab
%generate array of data
a=randperm(10,10);
a1= a+ s.Centroid(1);

b=randperm(13,10); %10 number up to 13
b1= b+ s.Centroid(1,2); %column 2 row 1

c=randperm(16,10); %10 number up to 16
c1= c+ s.Centroid(1,3); %column 3 row 1

%create string array
Vol=["small";"medium";"large";"large";"medium";"medium";"large";"large";"small";"medium"]
Vol=categorical(Vol); %convert to categorical

%combine data into array
ArrayCentroid=[a1;b1;c1]'; %transpose to create 3 columns

%add Volume data to array. 
%note that Vol is categorical vector and needs to be added as such
ArrayCentroidTable=table(ArrayCentroid,categorical(Vol));

%          ArrayCentroid            Var2 
%    __________________________    ______
%
%    72.005    68.601    57.502    small 
%    71.005    70.601    69.502    medium
%    66.005    75.601    63.502    large 
%    67.005    73.601    68.502    large 
%    64.005    72.601    70.502    medium
%    65.005    65.601    64.502    medium
%    63.005    69.601    66.502    large 
%    70.005    64.601    62.502    large 
%    68.005    71.601    58.502    small 
%    69.005    63.601    67.502    medium

Y = tsne(ArrayCentroidTable.XYZdim,'Algorithm','exact','Distance','euclidean');
subplot(2,2,1)
gscatter(Y(:,1),Y(:,2),ArrayCentroidTable.Volume) %scater plot
title('Euclidean')

```
