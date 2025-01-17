%% Savitzky-Golay filter generation
% Version: 4.1
% Date: 2024.12
% Author: Han Zhao, Lei Wang, Yanze Zhou, Jianshi Tang, Weiwei Cai, Huaqiang Wu, et al.
% Correspondence: jtang@tsinghua.edu.cn (J.T.), cweiwei@sjtu.edu.cn (W.C.), wuhq@tsinghua.edu.cn (H.W.)

clc;close all;clear;


%% ----- 1. generate SG filters ----- %%

    full_length = 150;
    x = -full_length:full_length;

    % spectra size = 301; M = 40; N = 8;
    kernel_1 = SG_filter_generate(size(x,2),40,8);

    % spectra size = 301; M = 60; N = 8;
    kernel_2 = SG_filter_generate(301,60,8);

    % spectra size = 301; M = 80; N = 8;
    kernel_3 = SG_filter_generate(301,80,8);
 

%% ----- 2. plot kernels ----- %%

    % kernel 1
    figure; plot(kernel_1);  
    title("SG filter (kernel 1)")
    ylim([-0.03,0.1]);
    xlim([-9 310]);
    xlabel('Filter index')
    ylabel("Coefficient")
    saveas(gcf,'./figs_SG_filter/kernel_1.png')

    % kernel 2
    figure; plot(kernel_2);  
    title("SG filter (kernel 2)")
    ylim([-0.03,0.1]);
    xlim([-9 310]);
    xlabel('Filter index')
    ylabel("Coefficient")
    saveas(gcf,'./figs_SG_filter/kernel_2.png')

    % kernel 3
    figure; plot(kernel_3);  
    title("SG filter (kernel 3)")
    ylim([-0.03,0.1]);
    xlim([-9 310]);
    xlabel('Filter index')
    ylabel("Coefficient")
    saveas(gcf,'./figs_SG_filter/kernel_3.png')



function sg_kernel = SG_filter_generate(spectra_size, M, N)

sg_array = zeros(spectra_size,spectra_size);

n = 2*M+1;
k = N + 1;
m=(n-1)/2;
X=[];
for i=0:(n-1)
    for j=0:(k-1)
        X(i+1,j+1)=power(i-m,j);
    end
end
SG_filter=X*inv(X'*X)*X';

for i = 1:spectra_size
    if (i <= M+1)
        sg_array(i,1:(2*M+1)) = SG_filter(i,:);
    end

    if (M+1 < i && i < spectra_size - M)
        sg_array(i,i-M:(2*M+i-M)) = SG_filter(M+1,:);
    end

    if (i >= spectra_size - M)
        sg_array(i,(end-2*M):end) = SG_filter(i-spectra_size + 2*M+1,:);
    end
end

sg_kernel = sg_array((spectra_size-1)./2+1,:);

end

