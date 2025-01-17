%% Demonstration of spectral reconstruction (narrowband)
% Version: 4.1
% Date: 2024.12
% Author: Han Zhao, Lei Wang, Yanze Zhou, Jianshi Tang, Weiwei Cai, Huaqiang Wu, et al.
% Correspondence: jtang@tsinghua.edu.cn (J.T.), cweiwei@sjtu.edu.cn (W.C.), wuhq@tsinghua.edu.cn (H.W.)

clc;close all;clear;


%% ----- 1. load data ----- %%
    
    % photocurrent
    load('./data_narrowband_spectra/Input_dataset.mat','I')
    
    % spectral response matrix
    load('./data_narrowband_spectra/Response_matrix.mat','R')
    
    % spectra ground truth
    load('./data_narrowband_spectra/Spectra_GT.mat','Spectra_GT')


%% ----- 2. spectral reconstruction ----- %%
    
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

    % spectral reconstruction
    spectra_rec = reconstruction_matrix * I;


%% ----- 3. data visulization ----- %%
    
    plot_spectra_index = 5000; % choose a index from 1-5000

    % ground truth
    figure; plot(Spectra_GT(:,plot_spectra_index));  
    title("Spectra (ground truth)")
    ylim([-0.1,1.1]);
    xlim([-9 310]);
    xlabel('Spectral index')
    ylabel("Intensity (a.u.)")
    saveas(gcf,'./figs_narrowband_spectra/ground_truth.png')

    % reconstructed
    figure; plot(spectra_rec(:,plot_spectra_index));
    title("Spectra (reconstructed)")
    ylim([-0.1,1.1]);
    xlim([-9 310]);
    xlabel('Spectral index')
    ylabel("Intensity (a.u.)")
    saveas(gcf,'./figs_narrowband_spectra/reconstructed.png')


