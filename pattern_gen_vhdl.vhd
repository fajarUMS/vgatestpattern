-- Test pattern generator for VGA monitor
-- Please adjust the monitor resolution and the corresponding vector width. 
--
-- Author: Fajar Suryawan, 2021. Distributed under MIT License.
library ieee;
use ieee.std_logic_1164.all; use ieee.numeric_std.all; 

Entity pattern_gen_vhdl is
generic( hres : integer := 1024;   vres : integer :=  768 );
port(
  xpos : in  std_logic_vector (9 downto 0);
  ypos : in  std_logic_vector (9 downto 0);
  von  : in  std_logic;
  R,G,B: out std_logic_vector (7 downto 0)); 
end pattern_gen_vhdl;

Architecture geometric of pattern_gen_vhdl is
 signal x : integer range 0 to hres-1;
 signal y : integer range 0 to vres-1;
 constant wb  : integer := 50; 
 constant r2  : integer := 40000; 
 constant wc2 : integer := 400;  
 constant wd  : integer := 2;   
Begin
 x <= to_integer(unsigned(xpos));   y <= to_integer(unsigned(ypos));
 Process(x,y,von)
 Begin
  if ( ( -- cross hair:
         y = vres/2  or  x = hres/2  or
         -- diamond outline:
         ( (y + wd +   vres/2)*hres - x*vres >= 0  and (y - wd +   vres/2)*hres - x*vres <= 0 ) or
         ( (y + wd -   vres/2)*hres + x*vres >= 0  and (y - wd -   vres/2)*hres + x*vres <= 0 ) or
         ( (y + wd -   vres/2)*hres - x*vres >= 0  and (y - wd -   vres/2)*hres - x*vres <= 0 ) or
         ( (y + wd - 3*vres/2)*hres + x*vres >= 0  and (y - wd - 3*vres/2)*hres + x*vres <= 0 ) or
         -- circle:
         ( (x - hres/2)*(x - hres/2) + (y - vres/2)*(y - vres/2) >= r2 - wc2  and  
           (x - hres/2)*(x - hres/2) + (y - vres/2)*(y - vres/2) <= r2 + wc2      ) or
         -- solid corner boxes: 
         ( (x >= 0)      and (x < wb)    and (y >= 0)      and (y < wb)    ) or
         ( (x > hres-wb) and (x <= hres) and (y >= 0)      and (y < wb)    ) or
         ( (x >= 0)      and (x < wb)    and (y > vres-wb) and (y <= vres) ) or
         ( (x > hres-wb) and (x <= hres) and (y > vres-wb) and (y <= vres) )
       ) and von= '1' 
	  ) then
   R <= (others => '1');  G <= (others => '1');  B <= (others => '1'); -- white
  	
  -- RGB boxes:
  elsif ( y < wb and x > 2*wb and x <= 3*wb ) and von= '1' then
   R <= (others => '1');  G <= (others => '0');  B <= (others => '0'); -- Red
  elsif ( y < wb and x > 3*wb and x <= 4*wb ) and von= '1' then
   R <= (others => '0');  G <= (others => '1');  B <= (others => '0'); -- Green
  elsif ( y < wb and x > 4*wb and x <= 5*wb ) and von= '1' then
   R <= (others => '0');  G <= (others => '0');  B <= (others => '1'); -- Blue
  
  -- The rest of the screen:
  else 
   R <= (others => '0');  G <= (others => '0');  B <= (others => '0'); -- black
  end if;
 End process;
End geometric;