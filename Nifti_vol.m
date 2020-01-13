function Nifti_vol (ImN)

%The program will calculate the size of nifti roi 
%use function by entering ImN
%ImN='1000M_ica.nii'
%Nifti_vol('1000M_ica.nii')

Roi=niftiread(ImN);
%ImN=[Stem '_svd2.mnc'];

Roi=Roi>0.5;
 
%check dimensions
info=niftiinfo(ImN);

%nnz=number of nonzero elements
%fslstats 1000M_ica.nii -V
Volume=nnz(Roi)*info.PixelDimensions(1)*info.PixelDimensions(2)*info.PixelDimensions(3)/1000

%centroid
%same answer in fsl
%fslstats 1000M_ica.nii -C

%obtain table with Volume, CoG, Bounding Box 
rp=regionprops3(Roi)

%obtain CoG, Principal Axis Length Euler angles
s = regionprops3(Roi,"Centroid","PrincipalAxisLength","Orientation");
centers = s.Centroid
angles=s.Orientation

%https://au.mathworks.com/matlabcentral/answers/420966-input-euler-angles-which-outputs-rotation-matrix-r?s_tid=answers_rc1-2_p2_MLT
p = s.Orientation(1)%phi ;
t = s.Orientation(2)% theta ;
s = s.Orientation(3) % psi ;

D = [cos(p) sin(p) 0 ; -sin(p) cos(p) 0 ; 0 0 1] ;
C = [1 0 0 ; 0 cos(t) sin(t) ; 0 -sin(t) cos(t)] ;
B = [cos(s) sin(s) 0 ; -sin(s) cos(s) 0 ; 0 0 1] ;
R = B*C*D ; 
%surface 

disp(['Apollo bites: ' ImN])
disp(['The Volume (cm3) is: ' num2str(Volume)])
 



