// Test pattern generator for VGA monitor
// Please adjust the monitor resolution and the corresponding vector width. 
//
// Author: Fajar Suryawan, 2021. Distributed under MIT License.
module pattern_gen_verilog
      #( parameter hres = 1024, vres = 768 )
       ( input  wire [9:0] x,
         input  wire [9:0] y,
         input  wire von,
         output reg [7:0] R,G,B );
		  
localparam wb  = 50; 
localparam r2  = 40000; 
localparam wc2 = 400;  
localparam wd  = 2; 

always @(x,y,von)
begin
  if ( ( // cross hair:
         (y == vres/2 || x == hres/2) || 
         // diamond outline:
         ( (y + wd +   vres/2)*hres >=  x*vres  && (y - wd +   vres/2)*hres <=  x*vres ) ||
         ( (y + wd -   vres/2)*hres >= -x*vres  && (y - wd -   vres/2)*hres <= -x*vres ) ||
         ( (y + wd -   vres/2)*hres >=  x*vres  && (y - wd -   vres/2)*hres <=  x*vres ) ||
         ( (y + wd - 3*vres/2)*hres >= -x*vres  && (y - wd - 3*vres/2)*hres <= -x*vres ) ||
         // circle:
         ( (x - hres/2)*(x - hres/2) + (y - vres/2)*(y - vres/2) >= r2 - wc2 &&  
           (x - hres/2)*(x - hres/2) + (y - vres/2)*(y - vres/2) <= r2 + wc2    ) ||
         // solid corner boxes:
         ( (x >= 0)      && (x < wb)    && (y >= 0)      && (y < wb)    ) ||
         ( (x > hres-wb) && (x <= hres) && (y >= 0)      && (y < wb)    ) ||
         ( (x >= 0)      && (x < wb)    && (y > vres-wb) && (y <= vres) ) ||
         ( (x > hres-wb) && (x <= hres) && (y > vres-wb) && (y <= vres) )
       ) && von == 1 
	  )
    begin  R = 8'hFF; G = 8'hFF; B = 8'hFF;                 // white
    end

  // RGB boxes:
  else if ( ( y < wb && x > 2*wb && x <= 3*wb ) && von == 1 )
    begin  R = 8'hFF; G = 8'h00; B = 8'h00;                 // Red
    end  
  else if ( ( y < wb && x > 3*wb && x <= 4*wb ) && von == 1 )
    begin  R = 8'h00; G = 8'hFF; B = 8'h00;                 // Green
    end
  else if ( ( y < wb && x > 4*wb && x <= 5*wb ) && von == 1 )
    begin  R = 8'h00; G = 8'h00; B = 8'hFF;                 // Blue
    end
  
  // The rest of the screen:
  else
    begin  R = 8'h00; G = 8'h00; B = 8'h00;                 // black
    end
end
endmodule