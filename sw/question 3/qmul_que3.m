%%
% combine task 1 and task 2
%  Using function qmul 
% reading all video frames
function qmul_que3(videoname,i)  
vidobj = VideoReader(videoname);      
videoframes = read(vidobj);           

[m,n,c,f] = size(videoframes);         
y= zeros(m,n,c);    
%%
% calculates frame diiference of both task 1 and task 2
for m= 1:size(videoframes,1)
    for n=1:size(videoframes,2)
       y(m,n,:)= abs (  double (videoframes(m,n,:,i))-double(videoframes(m,n,:,1)));
       y01(m,n,:)= abs (  double (videoframes(m,n,:,i))-double(videoframes(m,n,:,i-1)));
    end
   end
 figure,imshow(videoframes(:,:,:,i))                                    
y = rgb2gray(uint8(y));
%%
% threshold the image
figure, title(['grayscale image of task 1',imshow(y)]);       
 % changes the greyscale image in to binary image 
BW = im2bw(y,0.1);                                
figure,title([' binary image of task 1',imshow(BW)]);                       
% changes colour image in to greyscale
y01 = rgb2gray(uint8(y01));                              
figure, title(['grayscale image of task 2',imshow(y01)]); 
BW01= im2bw(y01,0.1);                               
figure, title([' binary image of task 2',imshow(BW01)]);  
%%
% combine task 1 and task 
% uses different combination
% multiply both thresholds
w=immultiply(BW,BW01);                             
figure, title(['Multiply task1&2',imshow(w)]);  
% Add both thresholds
z= imadd(BW,BW01);                                 
figure, title(['Adding task1&2',imshow(z)]);  
% subtract both thresholds
x = imsubtract(BW,BW01);                                 
figure, title(['subtracting 1 from 2',imshow(x)]);  
% using OR gate for both thresholds, and shows the image with title
figure, title(['using OR gate', imshow( BW | BW01)]);  
% using AND gate for both thresholds and show the image with title
figure, title(['using AND gate', imshow(BW & BW01)]);   
end







