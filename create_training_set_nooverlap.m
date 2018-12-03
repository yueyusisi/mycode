%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% File to create training and validation set       %
% for ShanghaiTech Dataset Part A and B. 10% of    %
% the training set is set aside for validation     %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


clc; clear all;
seed = 0000;
rng(seed)
N = 9;
crop = 3;
dataset = 'A';

% kersize = 'adaptive';
kersize = 'fixsize';
dataset_name = ['shanghaitech_part_' dataset '_patches_' num2str(N) '_' num2str(seed)];
path = ['D:/crowd/my_code/data/shanghaitech_original/part_' dataset '_final/train_data/images/'];
gt_path = ['D:/crowd/my_code/data/shanghaitech_original/part_' dataset '_final/train_data/ground-truth/'];

output_path = ['D:\crowd\my_dataset\part' dataset '\' kersize '\nooverlap' ];
train_path_img = strcat(output_path, '/train/');
train_path_den = strcat(output_path, '/train_den/');
val_path_img = strcat(output_path, '/val/');
val_path_den = strcat(output_path, '/val_den/');


mkdir(output_path)
mkdir(train_path_img);
mkdir(train_path_den);
mkdir(val_path_img);
mkdir(val_path_den);

if (dataset == 'A')
    num_images = 300;
else
    num_images = 400;
end
num_val = ceil(num_images*0.1);
indices = randperm(num_images);

for idx = 1:num_images
    i = indices(idx);
    if (mod(idx,10)==0)
        fprintf(1,'Processing %3d/%d files\n', idx, num_images);
    end
    load(strcat(gt_path, 'GT_IMG_',num2str(i),'.mat')) ;
    input_img_name = strcat(path,'IMG_',num2str(i),'.jpg');
    im = imread(input_img_name);
    [h, w, c] = size(im);
    
    twosize = crop;

    wn2 =twosize * floor(w/twosize);
    hn2 =twosize * floor(h/twosize);
    
    annPoints =  image_info{1}.location;
    [h, w, c] = size(im);
    a_w = wn2+1; b_w = w - wn2;
    a_h = hn2+1; b_h = h - hn2;
    
    if(strcmp(kersize, 'adaptive')==1)
        im_density = get_density_map_gaussian_adaptive(im,annPoints);
    end
    if(strcmp(kersize, 'fixsize')==1)
        im_density = get_density_map_gaussian_fixsize(im,annPoints);
    end
    
%no overlap
    for j = 1:N
        id = j-1;
        k_x = floor(id/3);
        k_y = mod(id,3);
%         fprintf('k_x:%d   k_y:%d\n',k_x,k_y)
%         
        x1 = floor(wn2/3)*(k_x)+1; y1 = floor(hn2/3)*(k_y)+1;
        x2 = floor(wn2/3)*(k_x+1); y2 = floor(hn2/3)*(k_y+1);
%         fprintf('x1:%d   y1:%d\n',x1,y1);
%         fprintf('x2:%d   y2:%d\n',x2,y2);
        
        im_crop=imcrop(im,[x1,y1,x2-x1,y2-y1]);
        gt_crop=im_density(y1:y2,x1:x2);
        
        img_idx = strcat(num2str(i), '_',num2str(j));
        if(idx < num_val)
            imwrite(im_crop, [val_path_img num2str(img_idx) '.jpg']);
            csvwrite([val_path_den num2str(img_idx) '.csv'], gt_crop);
        else
            imwrite(im_crop, [train_path_img num2str(img_idx) '.jpg']);
            csvwrite([train_path_den num2str(img_idx) '.csv'], gt_crop);
        end
    end
    
end

