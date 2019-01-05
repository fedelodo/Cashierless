knn = fitcknn(features, imds.Labels);
predicted_test_knn = predict(knn, features);
figure('NumberTitle', 'off', 'Name', 'knn');
for i = 1:numel(imdsValidation.Labels)
    subplot(6,5,i)
    I = readimage(imdsValidation,i);
    label = predicted_test_knn(i);
    imshow(I)
    title(char(label))
end

