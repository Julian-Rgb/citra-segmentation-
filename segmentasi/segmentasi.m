% File   : segmentasi.m
% Desc   : Proses segmentasi warna menggunakna citra tresholding
% Outhor : Julian Witjaksono
% Nim    : F55120117


% Load image
Img = imread('yor.jpg');
% membuat matriks zero
putih = uint8(zeros(size(Img)));
% Pengambilan warna menggunakan HUE
for i = 1:size(Img,1)
    for j = 1:size(Img,2)
        if ((Img(i,j,1) >= 210) && (Img(i,j,2) >= 210) && (Img(i,j,3) >= 210))
            putih(i,j,:) = Img(i,j,:);
        end
        
    end
end
% Segmentasi Ekstraksi Ciri Citra RGB
% Pengguanaan warna menggunakan Segmentation K-Means Clustering
cform = makecform('srgb2lab');
lab = applycform(Img,cform);
%__________________________________
ab = double(lab(:,:,2:3));
nrows = size(ab,1);
ncols = size(ab,2);
ab = reshape(ab,nrows*ncols,2);
 
nColors = 3;
[cluster_idx, cluster_center] = kmeans(ab,nColors,'distance','sqEuclidean', ...
                                      'Replicates',3);
pixel_labels = reshape(cluster_idx,nrows,ncols);
RGB = label2rgb(pixel_labels);

segmented_images = cell(1,3);
rgb_label = repmat(pixel_labels,[1 1 3]);
 
for k = 1:nColors
    color = Img;
    color(rgb_label ~= k) = 0;
    segmented_images{k} = color;
end
 
% img segmentation
area_cluster1 = sum(sum(pixel_labels==1));
area_cluster2 = sum(sum(pixel_labels==2));
area_cluster3 = sum(sum(pixel_labels==3));
 
[~,cluster_mitsuha] = min([area_cluster1,area_cluster2,area_cluster3]);
mitsuha_bw = (pixel_labels==cluster_mitsuha);
mitsuha_bw = imfill(mitsuha_bw,'holes');
mitsuha_bw = bwareaopen(mitsuha_bw,1000);
 
m = Img;
R = m(:,:,1);
G = m(:,:,2);
B = m(:,:,3);
R(~mitsuha_bw) = 0;
G(~mitsuha_bw) = 0;
B(~mitsuha_bw) = 0;
mitsuha = cat(3,R,G,B);

%grayscale
Gray = rgb2gray(Img);
%tresholding
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
Img2 = imread('bg.jpg');
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


% output
subplot(3,3,1), imshow(Img), title('Gambar Citra Asli');
subplot(3,3,2), imshow(Gray), title('Citra GrayScale');
subplot(3,3,3), imshow(mitsuha), title('Citra Clustering');
subplot(3,3,4), imshow(putih), title('Citra Color Selection ');
subplot(3,3,5),imshow(bw2);title('Proses Thresholding');
subplot(3,3,6),imshow(bw3);title('halusan Thresholding');
subplot(3,3,8),imshow(rgb);title('Citra Hasil Operasi Thresholding');
%subplot(2,3,7), imshow(segmented_images{1}), title('Citra Color Selection ');
%subplot(2,3,8), imshow(segmented_images{2}), title('Citra Color Selection ');
%subplot(2,3,9), imshow(segmented_images{3}), title('Citra Color Selection ');
%figure,imshow(segmented_images{1}), title('objects in cluster 1');
%figure,imshow(segmented_images{2}), title('objects in cluster 2');
%figure,imshow(segmented_images{3}), title('objects in cluster 3');
%figure, imshow(lab), title('L*a*b color space');
%figure, imshow(RGB,[]), title('image labeled by cluster index');
%subplot(2,3,1), imshow(bw4), title('Gambar Asli');

