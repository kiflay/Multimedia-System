%%
% block difference method
% Using function qmul
% multimedia reader object
function qmul_que4(videoname,k )
vidobj = VideoReader(videoname);              
videoframes = read(vidobj);  
 % shows the 1st frame
figure,imshow(videoframes(:,:,:,1));  
 % shows any frame the user enters
figure,imshow(videoframes(:,:,:,k)); 
 % changes the 1st frame from color to greyscale image
y0 = rgb2gray(videoframes(:,:,:,1));  
% changes the colour of any frame the user enter in to gray scale image
y = rgb2gray(videoframes(:,:,:,k));           
y1 = rgb2gray(videoframes(:,:,:,k-1));
  %% 
  % colfilt does columnwise neighborhood operations
   % process image result by rearranging each m-n block
   % and applying the function @mean
     
       I0 = (colfilt(y0,[5 5],'sliding',@mean)); 
       figure,imshow(uint8(I0));
       I1 = (colfilt(y,[5 5],'sliding',@mean));
       figure,imshow(uint8(I1));
       I2 = uint8(colfilt(y1,[5 5],'sliding',@mean));
       figure,imshow(I2);
       %%
       % calculate absolute difference
       % changes image in to binary image, 0.06 is the level
      
       d1 =abs (double(I1)-double(I0));   
       d2 =abs(double(I1)- double(I2));  
       BW = im2bw(uint8(d1),0.1);        
       figure,imshow(BW);                
       BW1= im2bw(uint8(d2),0.06);       
       figure,imshow(BW1);        