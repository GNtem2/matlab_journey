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
rp =

  4×3 table

    Volume             Centroid             BoundingBox 
    ______    __________________________    ____________

     4562     62.005    62.601    56.502    [1×6 double]
       18         32        65      41.5    [1×6 double]
       24     37.167    58.333      50.5    [1×6 double]
       24     34.917    62.958    52.792    [1×6 double]

%%
%obtain CoG, Principal Axis Length Euler angles
s = regionprops3(Roi,"Centroid","PrincipalAxisLength","Orientation");
centers = s.Centroid
angles=s.Orientation

%generate array of data
a=randperm(10,10)
a1= a+rp.Centroid(1)

b=randperm(13,10) %10 number up to 13
b1= b+rp.Centroid(1,2) %column 2 row 1

c=randperm(16,10) %10 number up to 16
c1= c+rp.Centroid(1,3) %column 3 row 1

%create string array
Vol=["small";"medium";"large";"large";"medium";"medium";"large";"large";"small";"medium"]
Vol=categorical(Vol) %convert to categorical

%combine data into array
ArrayCentroid=[a1;b1;c1]' %transpose to create 3 columns
ArrayCentroid=[ArrayCentroid;Vol]

%3d scatter plot
scatter3(a1',b1',c1')
%alternate
scatter3(ArrayCentroid(:,1),ArrayCentroid(:,2),ArrayCentroid(:,3))
%add color by vector Vol
scatter3(ArrayCentroid(:,1),ArrayCentroid(:,2),ArrayCentroid(:,3),[],Vol)

%create 4 subplot
rng default % for reproducibility
Y = tsne(ArrayCentroid(:,1:3),'Algorithm','exact','Distance','euclidean');
subplot(2,2,1)
gscatter(Y(:,1),Y(:,2),Vol) %scater plot
title('Euclidean')

Y = tsne(ArrayCentroid,'Algorithm','exact','Distance','mahalanobis');
subplot(2,2,2)
gscatter(Y(:,1),Y(:,2),Vol) %scater plot 
title('Mahalanobis')

Y = tsne(ArrayCentroid,'Algorithm','exact','Distance','chebychev');
subplot(2,2,3)
gscatter(Y(:,1),Y(:,2),Vol) %scater plot
title('Chebychev')

Y = tsne(ArrayCentroid,'Algorithm','exact','Distance','cosine');
subplot(2,2,4)
gscatter(Y(:,1),Y(:,2),Vol) %scater plot
title('Cosine')

