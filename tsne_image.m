%test on iris data
%%%%%%%%%%%%%%%%code from matlab
%load fisheriris
%rng default % for reproducibility
%Y = tsne(meas);
%gscatter(Y(:,1),Y(:,2),species) %scater plot


ImN='1000M_ica.nii'
Roi=niftiread(ImN);
Roi=Roi>0.5;
rp=regionprops3(Roi)

%%
%rp =
%  4×3 table
%    Volume             Centroid             BoundingBox 
%   ______    __________________________    ____________
%
%     4562     62.005    62.601    56.502    [1×6 double]
%       18         32        65      41.5    [1×6 double]
%       24     37.167    58.333      50.5    [1×6 double]
%       24     34.917    62.958    52.792    [1×6 double]
%
%%

%extract more shape data
%obtain CoG, Principal Axis Length Euler angles
s = regionprops3(Roi,"Centroid","PrincipalAxisLength","Orientation");
centers = s.Centroid;
angles=s.Orientation;
axislength=s.PrincipalAxisLength;

%calculate fractal dimension
%https://github.com/cMadan/calcFD

%generate array of data
a=randperm(10,10);
a1= a+rp.Centroid(1);

b=randperm(13,10); %10 number up to 13
b1= b+rp.Centroid(1,2); %column 2 row 1

c=randperm(16,10); %10 number up to 16
c1= c+rp.Centroid(1,3); %column 3 row 1

%create string array
Vol=["small";"medium";"large";"large";"medium";"medium";"large";"large";"small";"medium"]
Vol=categorical(Vol); %convert to categorical

%combine data into array
ArrayCentroid=[a1;b1;c1]'; %transpose to create 3 columns
ArrayCentroid=[ArrayCentroid;Vol]; %error combining doubles and categorical variables
ArrayCentroidTable=table(ArrayCentroid,categorical(Vol));

%%%
% 10×2 table
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

 %access table   
 ArrayCentroidTable.ArrayCentroid;
 ArrayCentroidTable.Var2;
 %change column names
 ArrayCentroidTable.Properties.VariableNames={'XYZdim','Volume'};

 
%%%
%3d scatter plot
scatter3(a1',b1',c1');
%alternate
scatter3(ArrayCentroid(:,1),ArrayCentroid(:,2),ArrayCentroid(:,3));
%add color by vector Vol
scatter3(ArrayCentroid(:,1),ArrayCentroid(:,2),ArrayCentroid(:,3),[],Vol);
%plotting by table
scatter3(ArrayCentroidTable.XYZdim(:,1),ArrayCentroidTable.XYZdim(:,2),ArrayCentroidTable.XYZdim(:,3),[},ArrayCentroidTable.Volume);

%create 4 subplot
rng default % for reproducibility
Y = tsne(ArrayCentroidTable.XYZdim,'Algorithm','exact','Distance','euclidean');
subplot(2,2,1)
gscatter(Y(:,1),Y(:,2),ArrayCentroidTable.Volume) %scater plot
title('Euclidean')

Y = tsne(ArrayCentroidTable.XYZdim,'Algorithm','exact','Distance','mahalanobis');
subplot(2,2,2)
gscatter(Y(:,1),Y(:,2),ArrayCentroidTable.Volume) %scater plot 
title('Mahalanobis')

Y = tsne(ArrayCentroidTable.XYZdim,'Algorithm','exact','Distance','chebychev');
subplot(2,2,3)
gscatter(Y(:,1),Y(:,2),ArrayCentroidTable.Volume) %scater plot
title('Chebychev')

Y = tsne(ArrayCentroid,'Algorithm','exact','Distance','cosine');
subplot(2,2,4)
gscatter(Y(:,1),Y(:,2),ArrayCentroidTable.Volume) %scater plot
title('Cosine')

%Add tsne output
ArrayCentroidTable=table(ArrayCentroidTable,Y(:,1),Y(:,2))
ArrayCentroidTable.Properties.VariableNames={'XYZdim','TSNEdim1','TSNEdim2'}

%save output to CVS - cannot handle nested table
%writetable(ArrayCentroidTable,'SimulatedCentroid.csv')
