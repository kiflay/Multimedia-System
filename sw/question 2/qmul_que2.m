
%%
% calculating the pixel by pixel differencing
% using first frame as reference
% uses function qmul
% videoname specifies the users enter video
% i indicates for any frame users enter
%%
% reads the video and returns the size of the video
% calculates the number of pixels and number of frames of the video
function qmul_que2(videoname,i, threshold) 
vidobj = VideoReader(videoname);      
videoframes = read(vidobj);      

[m,n,c,l] = size(videoframes);
%%
% calculates the pixel by pixel defference
for m= 1:size(videoframes,1)
    for n=1:size(videoframes,2)
        y(m,n,:)= abs (  double (videoframes(m,n,:,i))-double(videoframes(m,n,:,i-1))); 
        %%
        % threshold the difference     
        if y(m,n,:) > threshold;       
            result(m,n,:) = 255;
        else
            result(m,n,:) = 0;   
                  
       
      end
    end
end
%%
% shows the original image
%  shows the grayscale image of the difference 
%  shows the binary image of the diifference
figure,imshow (videoframes(:,:,:,i)); 
figure,imshow(rgb2gray(uint8(y)));
       
figure,imshow(uint8(result));                     

                        
end
