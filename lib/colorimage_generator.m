num = 1;
imnameOr=['D:\doc\Mathdoc\ͼ����\paper\colorimage','Or_',num2str(num),'.eps'];
imnameOb=['D:\doc\Mathdoc\ͼ����\paper\colorimage','Ob_',num2str(num),'.eps'];
imnameTMac=['D:\doc\Mathdoc\ͼ����\paper\colorimage','TMac_',num2str(num),'.eps'];
imnameTNN=['D:\doc\Mathdoc\ͼ����\paper\colorimage','TNN_',num2str(num),'.eps'];
imnameLRTC_TV_II=['D:\doc\Mathdoc\ͼ����\paper\colorimage','LRTC_TV_II_',num2str(num),'.eps'];
imnameSPC_QV=['D:\doc\Mathdoc\ͼ����\paper\colorimage','SPC_QV_',num2str(num),'.eps'];
imnameour=['D:\doc\Mathdoc\ͼ����\paper\colorimage','our_',num2str(num),'.eps'];
%% Or
I = Y_tensorT;
figure;imshow(I,'border','tight','initialmagnification','fit');
set(gcf,'Units','centimeters','Position',[0 0 3 3]); axis square;
screenposition = get(gcf,'Position');
set(gcf,'PaperPosition',[0 0 screenposition([3,3])],'PaperSize',screenposition([3,3]));
print(imnameOr,'-dpdf');