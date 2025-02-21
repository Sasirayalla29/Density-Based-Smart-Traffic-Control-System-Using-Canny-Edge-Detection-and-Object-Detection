%-------------------------------------------------------------------------%
%           Traffic Controlling by using Morphological operation          %
%-------------------------------------------------------------------------%
clear 
close all
clc

%%%%%%%%%%%% Select and read a reference image %%%%%%%%%%%%%%%%%%%%%%%%%%%%
I=uigetfile('*.jpg','select a traffic reference image');
I=imread(I);
I=im2double(I);
I=imresize(I,[256 256]);

if size(I,3)>1
    I=rgb2gray(I);
else 
        error('input is not a valid image')
end

%%%%%%%%%%%%%%%%%%% Select and read a traffic image %%%%%%%%%%%%%%%%%%%%%%
I1=uigetfile('*.jpg','select a traffic image');
I1=imread(I1);
I1=im2double(I1);
I1=imresize(I1,[256 256]);

if size(I1,3)>1
    I1=rgb2gray(I1);
end
subplot(221),imshow(I1);title('traffic image');
%%%%%%%%%%%% Enhancement %%%%%%%%%%%%%%%%%%%%%%%%%%%

J=histeq(I1);
subplot(222),imshow(J);title('enhanced image');

se=strel('square',5);
dilatedI=imdilate(I,se);
erodedI=imerode(I,se);
dilatedI1=imdilate(I1,se);
erodedI1=imerode(I1,se);
B1=imsubtract(dilatedI1,erodedI1);
B2=imsubtract(dilatedI,erodedI);
C1=edge(B1,'canny');
C2=edge(B2,'canny');
subplot(223),imshow(B2),title('difference image of reference');
subplot(224),imshow(B1),title('difference image of traffic');
figure,
subplot(221),imshow(dilatedI),title('Dilated image');
subplot(222),imshow(dilatedI),title('eroded image');
subplot(223),imshow(dilatedI1),title('Dilated image');
subplot(224),imshow(erodedI1),title('eroded image');

%%%%%%%%%%%% Image matching %%%%%%%%%%%%%%%%%%%%%%%%%%%%%

M1=mean(C2);S1=std(C2);V1=var(C2);
M2=mean(C1);S2=std(C1);V2=var(C1);

M3=M1/M2*100;
S3=S1/S2*100;
V3=V1/V2*100;
percntge_match=(S3+M3+V3)/3;
if (percntge_match)>0 && (percntge_match<10)
    msgbox('green light is on for 90 seconds')
else if (percntge_match)>10 && (percntge_match<50)
        msgbox('Green light is on for 60 seconds')
    else if (percntge_match)>50 && (percntge_match<70)
            msgbox('Green light is on for 30 seconds')
        else if (percntge_match)>70 && (percntge_match<90)
                msgbox('Green light is on for 20 seconds')
            else
                msgbox('Red light is on for 90 seconds')
        
            end
        end
        
    end
end

%-------------------------------------------------------------------------%