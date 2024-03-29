% qmul_qe7(videoname,a,threshold)
% a is the frame number
% videoname(TestSeq_1.avi)
% threshold is the threshold value
% find the size of the videoframe
function qmul_qe8(videoname,threshold)
vidobj = VideoReader(videoname);
videoframes= read(vidobj);
Number_Of_Objects = zeros(1,140);

[m n c f] = size(videoframes); 
%%
% to find the background of a video
% by making the percent 100 we will get the best background
% ref is the background image
x= 100/100 *f;

for i = 1:m
    for j=1:n
        for r =1:c
            reference (i,j,r)= mean(videoframes(i,j,r,1:x));
        end
    end
end

 ref = uint8(reference); 
% thresholding the image(diff)
% find absolute difference
for a = 2
   
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
   
block_bw = colfilt(result,[8 8],'sliding',@mean);
%%
%[l,numObjects]= bwlabel(block_bw,n)
% labels foreground objects in binary image(block_bw)
% lis the matrix where 0 indicates the background
% 1 indicates the pixel belong to object number 1 and continue like that
% 4 connectivity of pixels  defines the neighborhood 
 % changes the label to colour image which is good for vicualization   
     [L, numObjects] = bwlabel(block_bw,4)
     rgb_label = label2rgb(L,@spring,'c','shuffle');
     figure,imshow(rgb_label);                     
  %%
     % measures a set of properties for each label
     % I use the 'basic' propertieS which is more simple to use
    % checks for all labels
    % to find the smallest possible  bounding box
   stats = regionprops(L,'basic');
     figure,imshow(block_bw);
     hold on
     for k = 1:length(stats)                  
         Bounding_box = stats(k).BoundingBox; 
         
         rectangle('Position',Bounding_box,'EdgeColor','r','LineWidth',2); 
     end
     hold off
     
end
     
end

    
 
                            