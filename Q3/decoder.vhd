----------------------------------------------------------------------------------
-- Create Date:    19:09:28 01/08/2020  
-- Module Name:    decoder

-- Revision 0.01 - File Created
-- Additional Comments: 
-- i forgor 💀
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity decoder is
Port ( 
	fetch          : in  STD_LOGIC;
	decode         : in  STD_LOGIC;
	execute        : in  STD_LOGIC;
	
	state          : in  STD_LOGIC_VECTOR(4 DOWNTO 0);
   reg_sel        : in  STD_LOGIC_VECTOR(3 DOWNTO 0);
			  
	move           : in  STD_LOGIC;
	add            : in  STD_LOGIC;
	sub            : in  STD_LOGIC;
	bitWiseAnd     : in  STD_LOGIC;
			  
	load           : in  STD_LOGIC;
	store          : in  STD_LOGIC;			  
	addm           : in  STD_LOGIC;
	subm           : in  STD_LOGIC;

	jumpu          : in  STD_LOGIC;
	jumpz          : in  STD_LOGIC;
	jumpnz         : in  STD_LOGIC;
	jumpc          : in  STD_LOGIC;
	call           : in  STD_LOGIC;	
	
	type_d         : in  STD_LOGIC;	
	type_e         : in  STD_LOGIC;	
	type_f         : in  STD_LOGIC;	
			  
	y0             : in  STD_LOGIC;
	y1             : in  STD_LOGIC;	
	y2             : in  STD_LOGIC;			  
	y3             : in  STD_LOGIC;				  
	y4             : in  STD_LOGIC;
	y5             : in  STD_LOGIC;			  
	y6             : in  STD_LOGIC;		
	y7             : in  STD_LOGIC;		
	y8             : in  STD_LOGIC;
	y9             : in  STD_LOGIC;	
	yA             : in  STD_LOGIC;			  
	yB             : in  STD_LOGIC;				  
	yC             : in  STD_LOGIC;
	yD             : in  STD_LOGIC;			  
	yE             : in  STD_LOGIC;		
	yF             : in  STD_LOGIC;	
	
	ir_en          : out STD_LOGIC;
			  
	pc_en          : out STD_LOGIC;
	pc_ld          : out STD_LOGIC;
	pc_push        : out STD_LOGIC;
	pc_pop         : out STD_LOGIC;
		
	reg_X1         : out STD_LOGIC;
	reg_X0         : out STD_LOGIC;	
	reg_Y1         : out STD_LOGIC;
	reg_Y0         : out STD_LOGIC;	
	reg_en         : out STD_LOGIC;
	
	alu_ctl4       : out STD_LOGIC;
	alu_ctl3       : out STD_LOGIC;
	alu_ctl2       : out STD_LOGIC;	
	alu_ctl1       : out STD_LOGIC;
	alu_ctl0       : out STD_LOGIC;

	addr_sel1      : out STD_LOGIC;
	addr_sel0      : out STD_LOGIC;
			  
	data_sel2      : out STD_LOGIC;			  
	data_sel1      : out STD_LOGIC;
	data_sel0      : out STD_LOGIC;
			  
	ram_en         : out STD_LOGIC;
	ram_wr         : out STD_LOGIC;			  
	rom_en         : out STD_LOGIC;

   update_state	: out STD_LOGIC );
end decoder;

architecture decoder_arch of decoder is

   signal zero           : STD_LOGIC;
   signal carry          : STD_LOGIC;
   signal overflow       : STD_LOGIC;
   signal pos            : STD_LOGIC;
   signal neg            : STD_LOGIC;	

	signal jump           : STD_LOGIC;
	signal write_mem      : STD_LOGIC;	
	
	signal ret            : STD_LOGIC;	
	signal move_reg       : STD_LOGIC;	
	signal load_indirect  : STD_LOGIC;
	signal store_indirect : STD_LOGIC;

	signal rotate_left : STD_LOGIC;
	signal xor_reg : STD_LOGIC;
	
begin

   -- map state input bus to status bits
	
	zero     <= state(0);
	carry    <= state(1);	
	overflow <= state(2);	
	pos      <= state(3);
	neg      <= state(4);	
	
	-- generate zero operand / register / indirect instruction ctl lines
	
   ret            <= type_f and y0;
	move_reg       <= type_f and y1;
	load_indirect  <= type_f and y2; 
	store_indirect <= type_f and y3;
	
	rotate_left    <= type_f and y4;
	xor_reg        <= type_f and yA;

	-- interal logic
	
   jump           <= ( jumpu or (jumpz and zero) or (jumpnz and not zero) or (jumpc and carry) or call or ret );
							  
   write_mem      <= store or store_indirect;

   -- external logic

	ir_en          <= fetch;
	
	pc_en          <= (decode and (not jump)) or (execute and jump) ;
						  
	pc_ld          <= execute and jump;
	
	pc_push        <= decode and call;
	pc_pop         <= execute and ret;
	
	reg_X1         <= (reg_sel(3) and not(load or store or addm or subm));
	reg_X0         <= (reg_sel(2) and not(load or store or addm or subm));
	
	reg_Y1         <= reg_sel(1);
	reg_Y0         <= reg_sel(0);
	
	reg_en         <= (execute and (move or load or add or sub or bitWiseAND or 
                                    addm or subm or 
                                    move_reg or load_indirect or
                                    rotate_left or xor_reg )) ;
	
	-- CTL4  CTL3 CTL2 CTL1 CTL0 
	-- X     0    0    0    0     ADD   
	-- X		0    0    0    1     SUB
	-- X		0    0    1    0     BITWISE AND / XOR
	-- X		0    0    1    1     -
	-- X		0    1    0    0     PASS B 
	-- X		0    1    0    1     -
	-- X		0    1    1    0     ROTATE LEFT
	-- X		0    1    1    1     -  
	-- X		1    0    0    0        
	-- X		1    0    0    1      
	-- X		1    0    1    0          
	-- X		1    0    1    1    
	-- X		1    1    0    0       
	-- X		1    1    0    1    
	-- X		1    1    1    0    
	-- X		1    1    1    1  
	
	alu_ctl4       <= '0';
	alu_ctl3       <= '0';
	alu_ctl2       <= move or load or move_reg or load_indirect or rotate_left;
	alu_ctl1       <= bitWiseAND or rotate_left or xor_reg;
	alu_ctl0       <= sub or subm or xor_reg;
	
	-- SEL1 SEL0
	-- 0    0    PC
	-- 0    1    IR
	-- 1    0    REG
	-- 1    1    NU
	
	addr_sel1      <= (decode or execute) and (load_indirect or store_indirect);
	addr_sel0      <= (decode or execute) and (load or store or addm or subm);
	
	-- SEL2 SEL1 SEL0  
	--  0   0    0     IR 8bit unsigned
	--  1   0    0     IR 8bit sign extended 
	--  X   0    1     IR 12bit unsigned
	--  X   1    0     DATA-BUS-IN 16bit
	--  X   1    1     RY 16bit
	
	data_sel2      <= not(bitWiseAND);	
	data_sel1      <= load or addm or subm or load_indirect or move_reg or xor_reg;
	data_sel0      <= move_reg or xor_reg;
	
	ram_en         <= (decode or execute) and (load or store or addm or subm or load_indirect or store_indirect);
	ram_wr         <= execute and (store or store_indirect);
	rom_en         <= fetch; 

   update_state   <= (execute and (add or sub or bitWiseAND or addm or subm or rotate_left or xor_reg));
	
end decoder_arch;

