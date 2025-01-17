%% Demonstration of spectral imaging
% Version: 4.1
% Date: 2024.12
% Author: Han Zhao, Lei Wang, Yanze Zhou, Jianshi Tang, Weiwei Cai, Huaqiang Wu, et al.
% Correspondence: jtang@tsinghua.edu.cn (J.T.), cweiwei@sjtu.edu.cn (W.C.), wuhq@tsinghua.edu.cn (H.W.)

clc;close all;clear;


%% ----- 1. load data ----- %%
   
    % photocurrent  
    num_parts = 4;
    I = [];
    for i = 1:num_parts
        filename = sprintf('./data_spectral_imaging/Input_dataset_part_%d.mat', i);
        loaded_data = load(filename);
        data_part = loaded_data.data_part;
        I = [I, data_part];
    end

    % pinv of spectral response matrix
    load('./data_spectral_imaging/Response_matrix.mat','R')
    
    % image ground truth
    num_parts = 4;
    Image_GT = [];
    for i = 1:num_parts
        filename = sprintf('./data_spectral_imaging/Image_GT_part_%d.mat', i);
        loaded_data = load(filename);
        data_part = loaded_data.data_part;
        Image_GT = cat(3, Image_GT, data_part);
    end


%% ----- 2. spectra reconstruction ----- %% 

    numPixel = 512;

    % get spectral reconstruction matrix from response matrix
    [U,S,V] = svd(R,'econ');
    tol = max(size(R)) * eps(max(diag(S)));
   
    S_inv = zeros(size(S'));
    for i = 1:min(size(S))
        if S(i,i) > tol
            S_inv(i,i) = 1 / S(i,i);
        else
            S_inv(i,i) = 0;
        end
    end

    reconstruction_matrix = V * S_inv * U';

    image_reconstruct = reconstruction_matrix * I;

    numColumns = size(image_reconstruct, 2);

    spectraImage = zeros(512,512,61);

    for NumWave = 1:1:61
        idxSpectra = 1;
        for i = 1:numPixel
            for j = 1:numPixel
                spectraImage(i,j,NumWave) = image_reconstruct(NumWave,idxSpectra);
                idxSpectra = idxSpectra + 1;
            end
        end
    end


%% ----- 3. data visulization ----- %%

    plot_spectral_image_index = 30; % choose a index from 1-61

    figure;
    imshow(spectraImage(:,:,plot_spectral_image_index),[])
    title("Spectral image (reconstructed)")
    saveas(gcf,['./figs_spectral_imaging/Spectral image_',num2str(plot_spectral_image_index),' (reconstructed).png'])

    figure;
    imshow(Image_GT(:,:,plot_spectral_image_index),[])
    title("Spectral image (ground truth)")
    saveas(gcf,['./figs_spectral_imaging/Spectral image_',num2str(plot_spectral_image_index),' (ground truth).png'])

