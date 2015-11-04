function matcaffe_demo2()

% init caffe network (spews logging info)
matcaffe_init(1);
%w=caffe('get_weights');
%save('/nfs/vision/victor_hao/w_7_new.mat','w');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
fid=fopen('../vic_test.txt','r');
im_ht=java.util.Hashtable;
while ~feof(fid)
    objec=fgetl(fid);
    s=regexp(objec,' ','split');
    file_name=char(s{1});
    gdtruth=str2num(char(s{2}));
    im = imread(file_name);

    % prepare oversampled input
    % input_data is Height x Width x Channel x Num
    tic;
    input_data = {prepare_image(im)};
    toc;

    % do forward pass to get scores
    % scores are now Width x Height x Channels x Num
    tic;
    scores = caffe('forward', input_data);
    toc;

    scores = scores{1};
    scores = squeeze(scores);
    scores = mean(scores,2);

    %[~, maxlabel] = max(scores);
    %maxlabel = maxlabel - 1;
    result=[scores(1,1);scores(2,1);gdtruth];
    id=file_name(30:52);
    if im_ht.containsKey(id)
        A=im_ht.get(id);
        A=[A result];
        im_ht.put(id,A);
    else
        im_ht.put(id,result);
    end
end
fclose(fid);

patient_list=im_ht.keys;
fid1=fopen('../im_result_7_new.txt','w+');
while(patient_list.hasNext)
    patient_id=patient_list.nextElement;
    result_vec=im_ht.get(patient_id);
    l=length(result_vec(1,:));
    result_1=sum(result_vec(1,:))/l;
    result_2=sum(result_vec(2,:))/l;
    result_label=result_vec(3,1);
    fprintf(fid1,'%s ',patient_id);
    fprintf(fid1,'%2.4f %2.4f %d\n',[result_1,result_2,result_label]);
end
fclose(fid1);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% ------------------------------------------------------------------------
function images = prepare_image(im)
% ------------------------------------------------------------------------
IMAGE_DIM = 500;
CROPPED_DIM = 400;

% resize to fixed input size
im = single(im);
im = imresize(im, [IMAGE_DIM IMAGE_DIM], 'bilinear');
% permute from RGB to BGR
im = im(:,:,[3 2 1]);

% oversample (4 corners, center, and their x-axis flips)
images = zeros(CROPPED_DIM, CROPPED_DIM, 3, 10, 'single');
indices = [0 IMAGE_DIM-CROPPED_DIM] + 1;
curr = 1;
for i = indices
  for j = indices
    images(:, :, :, curr) = ...
        permute(im(i:i+CROPPED_DIM-1, j:j+CROPPED_DIM-1, :), [2 1 3]);
    images(:, :, :, curr+5) = images(end:-1:1, :, :, curr);
    curr = curr + 1;
  end
end
center = floor(indices(2) / 2)+1;
images(:,:,:,5) = ...
    permute(im(center:center+CROPPED_DIM-1,center:center+CROPPED_DIM-1,:), ...
        [2 1 3]);
images(:,:,:,10) = images(end:-1:1, :, :, curr);






function  matcaffe_init(use_gpu, model_def_file, model_file)
% matcaffe_init(model_def_file, model_file, use_gpu)
% Initilize matcaffe wrapper

if nargin < 1
  % By default use CPU
  use_gpu = 0;
end
if nargin < 2 || isempty(model_def_file)
  % By default use imagenet_deploy
  model_def_file = '../result_7_5X/brca_7_deploy.prototxt';

end
if nargin < 3 || isempty(model_file)
  % By default use caffe reference model
  model_file = '../result_7_5X/brca_iter_143000.caffemodel';
end


if caffe('is_initialized') == 0
  if exist(model_file, 'file') == 0
    % NOTE: you'll have to get the pre-trained ILSVRC network
    error('You need a network model file');
  end
  if ~exist(model_def_file,'file')
    % NOTE: you'll have to get network definition
    error('You need the network prototxt definition');
  end
  caffe('init', model_def_file, model_file)
end
fprintf('Done with init\n');

% set to use GPU or CPU
if use_gpu
  fprintf('Using GPU Mode\n');
  caffe('set_mode_gpu');
else
  fprintf('Using CPU Mode\n');
  caffe('set_mode_cpu');
end
fprintf('Done with set_mode\n');

% put into test mode
caffe('set_phase_test');
fprintf('Done with set_phase_test\n');
