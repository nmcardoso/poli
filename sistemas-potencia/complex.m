1;
function retval = pol (z)
  a = abs(z);
  b = rad2deg(arg(z));
  retval = [a b];
 endfunction

 function retval = rect (z)
   r = z(1);
   theta = deg2rad(z(2));
   retval = r*(cos(theta) + j*sin(theta));
 endfunction

