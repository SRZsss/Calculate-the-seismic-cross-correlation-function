# Calculate-the-seismic-cross-correlation-function
Calculate the seismic cross-correlation function

This is a convenient code for calculating noise cross-correlation function written by the CSIM team led by Professor Jing Li, Jilin University.
sg=Vsg (Noisedata, dt, wt), the corresponding noise cross-correlation function can be output, where dt is the sampling interval and wt is the segmentation window. Preprocessing includes Onebit normalization, detrended, and mean removed.
To adjust the interference array, sg=Vsg (Noisedata, dt, wt, 'It', 2) can be used, which means that all stations are performing cross-correlation calculations with the second channel.
You can use sg=Vsg (Noisedata, dt, wt,'Calcemode ','xcoh'), which means performing cross-coherence calculation and deconvolution to 'dc'.

这是吉林大学李静教授带领的CSIM团队编写的计算噪声互相关函数的便捷代码。
只需sg = Vsg(Noisedata,dt,wt)，便可输出对应的噪声互相关函数，其中dt为采样间隔，wt为分割时窗，预处理包括Onebit归一化，去趋势和去均值。
如需调整干涉台阵，可以使用sg = Vsg(Noisedata,dt,wt,'It',2)，这表示所有台站与第2道做互相关计算。
可以使用sg = Vsg(Noisedata,dt,wt,'Calculatemode','xcoh')，这表示进行互相干计算，反褶积为'dc'。
