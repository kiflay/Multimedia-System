%%
% qmul_qe7(videoname,a,threshold)
% videoname(TestSeq_1.avi)
% threshold is the threshold value
% a is the frame number

function qmul_que9(videoname,threshold,a)
vidobj = VideoReader(videoname);
videoframes= read(vidobj);
Number_Of_Objects = zeros(1,140);

[m n c f] = size(videoframes);

%%
% to find the background of a video
% by making the percent 100 we will get the best background
x= 100/100 *f;

for i = 1:m
    for j=1:n
        for r =1:c
            reference (i,j,r)= mean(videoframes(i,j,r,1:x));
        end
    end
end

 ref = uint8(reference);
 
    

   %%
   % thresholding the image (diff) 
     diff = abs(double( videoframes(:,:,:,a))- double(ref));
     for i =1:352
         for j= 1:288
             if ((diff(j,i)>threshold))
                 result(j,i) = 255;
             else
                 result(j,i)= 0;
             end
         end
     end
   %%
   % colfilt does columnwise neighborhood operations
   % process image result by rearranging each m-n block
   % and applying the function @mean
   % bwlabel labels object connected together
   % applied regionprops to the labeled objects
    block_bw = colfilt(result,[8 8],'sliding',@mean);
    
     [L, numObjects] = bwlabel(block_bw,4);
     rgb_label = label2rgb(L,@spring,'c','shuffle');
     figure,title(['colour label',imshow(rgb_label)]);
     
    stats = regionprops(L,'basic');
    
    figure,imshow(block_bw);
    %%
    % scaling the image
    % open file
    
   d=  double(videoframes(:,:,:,a)/255);
   s= imagesc(d);
   figure,imshow(videoframes(:,:,:,a));
   File = fopen('ELE006_Question_9.txt','w');
 %%
 %checks for all objects in the frame
 % add the clour of pixels with the same label
   hold on
   for Label = 1:length(stats)
       d_double = double(d);
       rgb = double(zeros(1,3));
        NumberOfpixels = 0; 
     for X = 1:288
         for Y = 1:352
             if (L (X,Y) == Label)
                 rgb(1)=rgb(1)+ d_double(X,Y,1);
                 rgb(2)= rgb(2)+ d_double(X,Y,2);
                 rgb(3)= rgb(3)+ d_double(X,Y,3);
                 NumberOfpixels= NumberOfpixels+1;
             end
         end
     end
     %%
     % to find the smallest bounding box and centroid
      % of the objects
Centroid = stats(Label).Centroid;
Bounding_Box = stats(Label).BoundingBox;
%%
% calculates the average colour
Average_rgb(Label,1)= (rgb(1)/NumberOfpixels);
Average_rgb(Label,2)=(rgb(2)/NumberOfpixels);
Average_rgb(Label,3)= (rgb(3)/NumberOfpixels);
%%
% calculating the vertical and horizontal displacement
centroid(1)= stats(Label).Centroid(1);
centroid(2)= stats(Label).Centroid(2);
x(Label) = centroid(2)-centroid(1);
y(Label) = centroid(1)-centroid(2);
Angel(Label)= atand(y(Label)/x(Label));
%%
% plots rectangle on the bounding box
% writes numbers on the objects
rectangle('Position',Bounding_Box,'EdgeColor','r','LineWidth',2);
text(Centroid(1),Centroid(2),sprintf('%d',Label));
%%
% writes the frame number on the file 
% writes the number of objects in the frame in the file 
% writes the centroid of the object in the file 
% writes the width and length of the object in the file

fprintf(File,'Frame Number: %d\n',a);
fprintf(File,'Object Number: %.0f\n', Label);
fprintf(File,'Pixel Average of rgb values: %2.3f, %2.3f, %2.3f\n', Average_rgb(Label,1), Average_rgb(Label,2), Average_rgb(Label,3));
fprintf(File,'Centre of Mass (Pixel_Value - Plane): %3.3f, Centre of Mass (X_Axis - Plane): %3.3f\n', Centroid(1), Centroid(2));
fprintf(File,'Width of Object (Bounding Box): %3.2f, Height of Object (Bounding Box): %3.2f\n\n', Bounding_Box(3), Bounding_Box(4));
fprintf(File,'horizontal displacement:%3.2f, vertical displacement:%3.2f\n',x(Label),y(Label));
fprintf(File,'the angel is: %3.2f \n',Angel(Label));
end

hold off;
File = fclose('all');                 
     