load w;
w_1=w(1).weights;
figure;
for k=1:80
    filters=w_1{1};
    f1=filters(:,:,:,k);
    f1 = (f1 - min(f1(:))) / (max(f1(:)) - min(f1(:)));
    subplot(8,10,k);
    imshow(f1);
end

