%%
% the obstracted object features are represanted in xml file
%  XML file is created using DOM
% qmul_qe7(videoname,a,threshold)
% videoname(TestSeq_1.avi)
% threshold is the threshold value
% a is the frame number

function qmul_quee12(videoname)
vidobj = VideoReader(videoname);
videoframes= read(vidobj);
Number_Of_Objects = zeros(1,140);

[m n c f] = size(videoframes);
 docNode = com.mathworks.xml.XMLUtils.createDocument('frame');
docRootNode = docNode.getDocumentElement;


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
 
File = fopen('question12.txt','w');     

   %%
   % thresholding the image (diff) 
   for a = 1:5
       

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
   % bwlabel labels object connected together
   % applied regionprops to the labeled objects
     block_bw = colfilt(result,[8 8],'sliding',@mean);
     
     
     [L, N] = bwlabel(block_bw,4);
     rgb_label = label2rgb(L,@spring,'c','shuffle');
     figure,title(['colour label',imshow(rgb_label)]);
    
     stats = regionprops(L,'all');
     d = double(videoframes(:,:,:,a)/255);
     colourbox = zeros(1,3);
     figure,imshow(uint8(videoframes(:,:,:,a)));
    File = fopen('question12.txt','a'); 
    fprintf(File,'frame number: %d\n',a);
     hold on
     
     objElement = docNode.createElement('object'); 
 
    docRootNode.appendChild(objElement);
     %%
     % check for all number of objects
     for Label = 1:length(stats)
      
        d_double = double(d);
      rgb= double(zeros(1,3));
 number_of_pixels = 0; 
 
 % checks the colour for all number of ojects
 for colour = 1:N
    if (colourbox(1)==2)
            colourbox(1)=0;
            colourbox(2)=colourbox(2)+1;
        
            if (colourbox(2)==2)
                colourbox(2)=0;
                colourbox(3)= colourbox(3)+1 ; 
                    if (colourbox(3)==2)
                        colourbox(3) = 0;
                    end
            end
 
    end
     
 
  
     % calculates the average colour
         for x= 1:288
             for y = 1:352 
                 if (L(x,y)==Label)
                     rgb(1)= rgb(1)+ d_double(x,y,1);
                     number_of_pixels = number_of_pixels+1;
                     rgb(2)= rgb(2)+ d_double(x,y,2);
                     number_of_pixels = number_of_pixels+1;
                     rgb(3)= rgb(3)+ d_double(x,y,3);
                     number_of_pixels = number_of_pixels +1;
                 end
             end
         end
         average_red= rgb(1)/number_of_pixels;
         
          average_green= rgb(2)/number_of_pixels;
            
           average_blue= rgb(3)/number_of_pixels;
            
 end    
 
 end
    
 %%
 % Document Object Model 
 % create element and text code
 % element represent the object feuture
 % text code relates the value to the element
 for k = 2
     thisElement = docNode.createElement('frame'); 
 thisElement.appendChild... 
        (docNode.createTextNode(sprintf('%.00f',a)));
   objElement.appendChild(thisElement);
   
      thisElement = docNode.createElement('object'); 
 thisElement.appendChild... 
        (docNode.createTextNode(sprintf('%.00f',k)));
   objElement.appendChild(thisElement); 
        bounding_box = stats(k).BoundingBox;
        rectangle('position',bounding_box,'EdgeColor','r','LineWidth',2);
      

        area = stats(k).Area;
       thisElement = docNode.createElement('area'); 
    thisElement.appendChild... 
        (docNode.createTextNode(sprintf('%.00f',area)));
    objElement.appendChild(thisElement);
        perimeter = stats(k).Perimeter;
        thisElement = docNode.createElement('perimeter'); 
    thisElement.appendChild... 
        (docNode.createTextNode(sprintf('%.00f',perimeter)));
   objElement.appendChild(thisElement);
        %compute thiness ratio
        th = 4*pi*(area/(perimeter^2));
        stats(k).ThinnessRatio = th;
        thisElement = docNode.createElement('thinnessratio'); 
    thisElement.appendChild... 
        (docNode.createTextNode(sprintf('%.00f',th)));
    objElement.appendChild(thisElement);
        % compute the aspect ratio
        ar = (bounding_box(3)/bounding_box(4));
        stats(k).AspectRatio = ar;
        thisElement = docNode.createElement('aspectratio'); 
    thisElement.appendChild... 
        (docNode.createTextNode(sprintf('%.00f',ar)));
   objElement.appendChild(thisElement);
   
 thisElement = docNode.createElement('widthofboundingbox'); 
    thisElement.appendChild... 
        (docNode.createTextNode(sprintf('%.00f',bounding_box(3))));
  
 objElement.appendChild(thisElement);
 
 thisElement = docNode.createElement('heightofboundingbox'); 
    thisElement.appendChild... 
        (docNode.createTextNode(sprintf('%.00f',bounding_box(4))));
  
 objElement.appendChild(thisElement);
 thisElement = docNode.createElement('redcolour'); 
    thisElement.appendChild... 
        (docNode.createTextNode(sprintf('%f',average_red)));
  
 objElement.appendChild(thisElement);
 thisElement = docNode.createElement('greencolour'); 
    thisElement.appendChild... 
        (docNode.createTextNode(sprintf('%f',average_green)));
  
 objElement.appendChild(thisElement);
 thisElement = docNode.createElement('bluecolour'); 
    thisElement.appendChild... 
        (docNode.createTextNode(sprintf('%f',average_blue)));
  
 objElement.appendChild(thisElement);
 Centroid = stats(k).Centroid
 text(Centroid(1),Centroid(2),sprintf('%d',k));
 
 
 %%
 % writes the object feuture in to a file
 
        
     fprintf(File, 'Object Number:    %.0f\n', k);
     fprintf(File, ' area:            %.00f\n',area);
     fprintf(File, ' perimeter:       %.00f\n',perimeter);
     fprintf(File, ' Thinness ratio:  %f\n',th);
     fprintf(File, ' Aspect ratio:    %f\n',ar);
     fprintf(File,'Red colour average : %0f\n',average_red);
     fprintf(File, 'Green colour average: %f\n', average_green');
     fprintf(File, 'Blue colour average: %f\n', average_blue);
     colourbox(1)= colourbox(1)+1;
     
    
 end
    %%
    % creates the xml file
    %  xml writes the DOM in to xmlfilename
    % xml file is created
 
 xmlFileName = ('question12.xml')
 xmlwrite(xmlFileName,docNode);
 type(xmlFileName);
hold off
   end
     File = fclose('all');

     
     
     
    