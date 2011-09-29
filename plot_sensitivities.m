y=load('pixel_sensitivities.txt');
hold on
plot(y(:,2),'r','linewidth',2)
plot(y(:,3),'g','linewidth',2)
plot(y(:,4),'b','linewidth',2)
xlabel('nm')
ylabel('Response')
set(gca,'xtickmode','manual')
set(gca,'xtick',[1,size(y,1)])
set(gca,'xticklabel',{'394','706'})
set(gca,'ytick',[])
xlim([1,size(y,1)])
ylim([-0.01,4])
title('Nikon D700 RGB Pixel Sensitivities');
axis square
