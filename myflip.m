% dataset='train';
dataset='val';
den_dataset=[dataset '_den'];
% Root='D:\crowd\my_dataset\partA\fixsize\nooverlap';
Root='D:\crowd\my_dataset\partA\fixsize\random';
% Root='D:\crowd\my_dataset\partA\adaptive\nooverlap';
% Root='D:\crowd\my_dataset\partA\adaptive\random';
denPathRoot=[Root '\' den_dataset];
denfliplrRoot=[Root '_fliplr\'];
denflipudRoot=[Root '_flipud\'];
mkdir(denfliplrRoot);
mkdir(denflipudRoot);
denfliplr=[denfliplrRoot den_dataset '\'];
denflipud=[denflipudRoot den_dataset '\'];
mkdir(denfliplr);
mkdir(denflipud);
list=dir(fullfile(denPathRoot));
fileNum=size(list,1); 
for j=3:fileNum
    csvname = [denPathRoot '\' list(j).name];
    disp(csvname);
    fliplrname = [denfliplr '\' list(j).name];
    flipudname = [denflipud '\' list(j).name];
    M = csvread(csvname);
    lr = fliplr(M);
    ud = flipud(M);
    csvwrite(fliplrname, lr);
    csvwrite(flipudname, ud);
end

imgPathRoot=[Root '\' dataset];
imgfliplrRoot=[Root '_fliplr\'];
imgflipudRoot=[Root '_flipud\'];
mkdir(imgfliplrRoot);
mkdir(imgflipudRoot);
imgfliplr=[imgfliplrRoot dataset '\'];
imgflipud=[imgflipudRoot dataset '\'];
mkdir(imgfliplr);
mkdir(imgflipud);

list=dir(fullfile(imgPathRoot));
fileNum=size(list,1); 
for j=3:fileNum
    disp(list(j).name);
    imgname = [imgPathRoot '\' list(j).name];
    imglrname = [imgfliplr '\' list(j).name];
    imgudname = [imgflipud '\' list(j).name];
    
    image = imread(imgname);
    image_size=size(image);
    dimension=numel(image_size);
    if dimension==2
        imglr = image(:,end:-1:1,1);
        imgud = image(end:-1:1,:,1);
    end
    if dimension==3
        imglr = image(:,end:-1:1,1:3);
        imgud = image(end:-1:1,:,1:3);
    end 
    imwrite(imglr,imglrname);
    imwrite(imgud,imgudname);
end
