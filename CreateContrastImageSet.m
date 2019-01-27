clearvars;

imds = imageDatastore('images','IncludeSubfolders',true,'LabelSource','foldernames');
imgs = imds.Files;

for i = 1:numel(imgs)
    
    out = Preprocessing(imgs{i});
    imwrite(out,strrep(imgs{i}, "images", "contrasted"));
end
    