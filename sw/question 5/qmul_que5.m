%%
% gets the background image
% user enters percentage
% uses a function mean
% Using function qmul

function qmul_que5(videoname,percent)
% multimedia reader object
vidobj = VideoReader(videoname);   
 % reading all video frames
videoframes = read(vidobj);                       
% returns the size of the video frame
[m,n,c,f] = size(videoframes);                     
 %%                                   
 % calculates the frame based on the percentage given

x = (percent/100 *f);                             
% checks all the row number
% checks all the coloumn number
% checks all three colour
for i=1:m                                          
    for j= 1:n                                    
        for r=1:c                                 
         % find the Average between the first frame and calculated frame and compare   
          frame(i,j,r)= mean(videoframes(i,j,r,1:x)); 
  
       
        end
    end
end
figure,imshow(uint8(frame));                       
end