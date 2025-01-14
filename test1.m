clear;close all;clc;
load testdata.mat
dt = 0.002;
wt = 5;
sg = Vsg(data_use,dt,wt);
wigg(sg,dx,dt,1);
