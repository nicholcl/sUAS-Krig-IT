% deformat_variogram : convert gstat variogram line into matlab structure
%
% Call:
%   V=deformat_variogram(txt);
% 
% Example: 
% V=deformat_variogram('1 Sph(2)')
%
%V = 
%
%     par1: 1
%     par2: 2
%     type: 'Sph'
%     itype: 1
% 
% 
% See also : format_variogram
%
% TMH /2004
%

function V=deformat_variogram(txt)

  txt=regexprep(txt,'\<;',''); %removes semicolon from txt
  
  fp=regexp(txt,'\+'); % find position of '+'
  
  nvar=length(fp)+1; %the number of variograms models to be used will be the number of +'s plus one
%   fprintf('Found %d variograms\n',nvar)  

  if  nvar==1 %if only one variogram model
    ifp_array=0;
  else %if multiple, then array includes 0 and all locations of the +'s
    ifp_array=[0 fp];
  end
	
  ivar=0;  
  for ifp=1:length(ifp_array) %separates the models described in txt by using the + identifier
    ivar=ivar+1;
    if nvar==1 %if only one variogram model
      vartxt=txt; %vartxt becomes txt
    else %more than one model
      if ifp_array(ifp)==0 %if at the beginning of ifp (see: ifp_array [line 34])
        vartxt=txt(1:fp(1)-1); %then vartxt becomes all the characters between the beginning of txt to the first + symbol
      elseif ifp_array(ifp)==max(fp) %if the value of ifp_array is equal to the last location of the + symbol
        vartxt=txt(ifp_array(ifp)+1:length(txt)); %then vartxt becomes the characters the immediately following that ifp_array value and the end of the txt
      else 
        ind1=ifp_array(ifp)+1;
        ind2=ifp_array(ifp+1)-1;
        vartxt=txt(ind1:ind2); %else vartxt becomes the characters immediately after the location of the first + and the before the next +	
      end
    end
    
    vartxt=strip_space(vartxt);  %removes spaces at the beginning and ends of vartxt (LOCAL FUNCTION)
% 	fprintf('ivar=%d ifp=%d --%s--\n',ivar,ifp,vartxt)
    
    sp=find(vartxt==' '); %index of center space
    lb=find(vartxt=='('); %index of left parenthesis
    rb=find(vartxt==')'); %index of right parenthesis
    
    par1=vartxt(1:sp-1); %parameter 1 located before the space (sill)
    par2=vartxt(lb+1:rb-1); %parameter 2 located between the parentheses (range)
    type=strip_space(vartxt(sp+1:lb-1)); %model type located after the space and before the first parenthesis 
    
    if ~isempty(str2double(par1)), par1=str2double(par1); end %convert parameter 1 and 2 to double if they are not empty
    if ~isempty(str2double(par2)), par2=str2double(par2); end
    
    if isempty(par2), par2=[];end %if parameter 2 is empty then ignored

		if (strcmp(type,'Nug')) %determine the itype based on the model type
			itype=0;
		elseif (strcmp(type,'iNug'))
			itype=14;
		elseif (strcmp(type,'Sph'))
			itype=1;
		elseif (strcmp(type,'Gau'))
			itype=3;
		elseif (strcmp(type,'Exp'))
			itype=2;
		elseif (strcmp(type,'Log'))
			itype=15;
		elseif (strcmp(type,'Lin'))
			itype=6;
		elseif (strcmp(type,'Pow'))
			itype=4;
		elseif (strcmp(type,'Hole'))
			itype=5;
		elseif (strcmp(type,'Bal'))
			itype=10;
		elseif (strcmp(type,'Thi'))
			itype=11;
		elseif (strcmp(type,'Mat'))
            itype=12;
        elseif (isempty(type))
            itype=-1;
        else 
			fprintf('%s : Unknown semivariogram type : %s \n',mfilename,type)
			itype=8;			
		end
		
% 		fprintf('par1=%5.1f par2=%5.1f type=%4s itype=%d\n',par1,par2,type,itype)
   
    if length(par2)==2 
        V(ivar).nu=par2(2);
        par2=par2(1);     
    end
    
    if length(par2)==4 
        V(ivar).nu=par2(4);
        par2=par2(1:3);       
    end
    
    if length(par2)==7 
        V(ivar).nu=par2(7);
        par2=par2(1:6);       
    end
    
    V(ivar).par1=par1;
    V(ivar).par2=par2;
    V(ivar).type=type;
    V(ivar).itype=itype;
    
  end
