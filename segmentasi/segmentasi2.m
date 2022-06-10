clc; clear; close all;
%Gambar Citra
Img = imread('yuki.jpg');
%figure, imshow(Img);

%RGB to Gray
Gray = rgb2gray(Img);
%figure, imshow(Gray);

%Thresholding
bw1 = imbinarize (Gray, 240/255);
%figure, imshow(bw1);

bw2 = imcomplement(bw1);
%figure, imshow(bw2);

%bw2(end, P=1);
%figure, imshow(bw2);

bw3 = imfill (bw2, 'holes');
%figure, imshow(bw3);

%Background
Img2 = imread('yuki.jpg');
%figure, imshow(Img2);
Img2 = imresize (Img2, [size(Img,1) size(Img,2)]);
%figure, imshow (Img2);

%mengekstrak img
Img_red = Img(:,:,1);
Img_green = Img(:,:,2);
Img_blue = Img(:,:,3);

%mengekstrak img2
Img2_red = Img2(:,:,1);
Img2_green = Img2(:,:,2);
Img2_blue = Img2(:,:,3);

%menempelkan objek segmentasi
Img2_red(bw3) = Img_red(bw3);
Img2_green(bw3) = Img_green(bw3);
Img2_blue(bw3) = Img_blue(bw3);

%menggambungkan komponen
rgb = cat(3,Img2_red,Img2_green,Img2_blue);
%figure, imshow(rgb);

text_str = ['Julian F55120117 WM']; 
position = [10 300]; 
box_color = ('blue');

RGB = insertText(rgb, position, text_str, 'FontSize', 50, 'BoxColor',box_color, 'BoxOpacity', 0.3, 'TextColor', 'White'); 

subplot(3,2,1),imshow(Img);title('Citra Asli');
subplot(3,2,2),imshow(Gray);title('Citra Grayscale');
subplot(3,2,3),imshow(bw2);title('Proses Thresholding');
subplot(3,2,4),imshow(bw3);title('Penghalusan Thresholding');
subplot(3,2,5),imshow(rgb);title('Citra Hasil Operasi Thresholding');