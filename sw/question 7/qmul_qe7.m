
% qmul_qe7(videoname,a,threshold)
% videoname(TestSeq_1.avi)
% a is users enter frame
% threshold is the threshold value

function qmul_qe7(videoname,a)
vidobj = VideoReader(videoname);
videoframes= read(vidobj);
Number_Of_Objects = zeros(1,140); 

[m n c f] = size(videoframes);     
x= 100/100 *f;        
%%
% to find the background of a video
% by making the percent 100 we will get the best background
for i = 1:m
    for j=1:n
        for r =1:c
            reference (i,j,r)= mean(videoframes(i,j,r,1:x));
        end
    end
end

 ref = uint8(reference); % ref is the background image
 %%
% thresholding the image(diff    
% find absolute difference
for a = 1:140
   
     diff = abs(double( videoframes(:,:,:,a))- double(ref)); 
   
     for i =1:352
         for j= 1:288
             if ((diff(j,i)>50))
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
    block = colfilt(result,[8 8],'sliding',@mean);
   
  
  %%  
 % bwconcomp traces the boundries of objects in binary image block
  % calculate connectivity
  % the size of the image block
  % the number of objects in the image block
     objects = bwconncomp (block);
     Number_Of_Objects(a) = objects.NumObjects;
end
%%
    % draw a bar graph
    % number of framse 1 to 140
    % number of objects in each frame
       frames = 1:140;
       barh(frames,Number_Of_Objects(frames));
 
                            