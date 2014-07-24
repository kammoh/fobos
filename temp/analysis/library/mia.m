%--------------------------------------------------------------
clc;
clear all;
close all;

strk = sprintf('//local//windows//shared//Dropbox//FOBOS//DPA_AES//power_model//2bkey_guess_1.txt');
template = load(strk, 'r');

strp = sprintf('//local//windows//shared//Dropbox//FOBOS//DPA_AES//power_model//2b_Power_1.txt');
power = load(strp, 'r');
key_guess = template(2,1:999)';
power_measured = power';
mi = infometic(power, key_guess);
fprintf('Mutual Information MI = %d\n', mi);
