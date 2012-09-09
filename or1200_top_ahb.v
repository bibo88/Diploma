module or1200_top_ahb (

    hclk               ,
    hresetn            ,

    i_haddr            ,
    i_htrans           ,
    i_hwrite           ,
    i_hsize            ,
    i_hburst           ,
    i_hwdata           ,
    i_hrdata           ,
    i_hready           ,
    i_hresp            ,
    i_hbusreq           ,
    i_hgrant            ,

    d_haddr            ,
    d_htrans           ,
    d_hwrite           ,
    d_hsize            ,
    d_hburst           ,
    d_hwdata           ,
    d_hrdata           ,
    d_hready           ,
    d_hresp            ,
    d_hbusreq           ,
    d_hgrant            ,

    or1200_pic_ints    
      

);

input          hclk;
input          hresetn;


input [31:0]   i_hrdata;
input [1:0]    i_hresp;      
input          i_hready;
input          i_hgrant;//grant
output [31:0]  i_haddr;  //Address
output         i_hwrite; //Write/Read Control 
output [2:0]   i_hsize;  //Size of Data Control
output [2:0]   i_hburst; //Burst Control
output [31:0]  i_hwdata; //Write data bus
output [1:0]   i_htrans; //Transfer type
output         i_hbusreq; //bus_req 

input [31:0]   d_hrdata;
input [1:0]    d_hresp;      
input          d_hready;
input          d_hgrant; // grant
output [31:0]  d_haddr;  //Address
output         d_hwrite; //Write/Read Control 
output [2:0]   d_hsize;  //Size of Data Control
output [2:0]   d_hburst; //Burst Control
output [31:0]  d_hwdata; //Write data bus
output [1:0]   d_htrans; //Transfer type
output         d_hbusreq; //bus_req 

input [19:0]   or1200_pic_ints;


wire [31:0]     wbm_i_or12_adr_o;
wire [31:0]     wbm_i_or12_dat_o;
wire [3:0]      wbm_i_or12_sel_o;
wire 		    wbm_i_or12_we_o;
wire 		    wbm_i_or12_cyc_o;
wire 		    wbm_i_or12_stb_o;

wire [31:0]     wbm_i_or12_dat_i;   
wire 		    wbm_i_or12_ack_i;

wire [31:0]     wbm_d_or12_adr_o;
wire [31:0]     wbm_d_or12_dat_o;
wire [3:0]      wbm_d_or12_sel_o;
wire 		    wbm_d_or12_we_o;
wire 		    wbm_d_or12_cyc_o;
wire 		    wbm_d_or12_stb_o;

wire [31:0]     wbm_d_or12_dat_i;   
wire 		    wbm_d_or12_ack_i;



AHBMAS_WBSLV_TOP i_bridge ( 
 
  .hclk     ( hclk                 ),
  .hresetn  ( hresetn              ),

// AHB Master Interface (Connect to AHB Slave) 
  .haddr    ( i_haddr              ),
  .htrans   ( i_htrans             ),
  .hwrite   ( i_hwrite             ),
  .hsize    ( i_hsize              ),
  .hburst   ( i_hburst             ),
  .hwdata   ( i_hwdata             ),
  .hrdata   ( i_hrdata             ),
  .hready   ( i_hready             ),
  .hresp    ( i_hresp              ),
  .hgrant    ( i_hgrant              ),
  .hbusreq    ( i_hbusreq            ),

// WISHBONE Slave Interface (Connect to WB Master)
  .data_o   ( wbm_i_or12_dat_i     ),
  .data_i   ( wbm_i_or12_dat_o     ),
  .addr_i   ( wbm_i_or12_adr_o     ),

  .clk_i    ( hclk                 ),
  .rst_i    ( ~hresetn             ),
  .cyc_i    ( wbm_i_or12_cyc_o     ),
  .stb_i    ( wbm_i_or12_stb_o     ),
  .sel_i    ( wbm_i_or12_sel_o     ),
  .we_i     ( wbm_i_or12_we_o      ),
  .ack_o    ( wbm_i_or12_ack_i     )
);


AHBMAS_WBSLV_TOP d_bridge ( 
 
  .hclk     ( hclk                 ),
  .hresetn  ( hresetn              ),

// AHB Master Interface (Connect to AHB Slave) 
  .haddr    ( d_haddr              ),
  .htrans   ( d_htrans             ),
  .hwrite   ( d_hwrite             ),
  .hsize    ( d_hsize              ),
  .hburst   ( d_hburst             ),
  .hwdata   ( d_hwdata             ),
  .hrdata   ( d_hrdata             ),
  .hready   ( d_hready             ),
  .hresp    ( d_hresp              ),
  .hgrant    (d_hgrant              ),
  .hbusreq    ( d_hbusreq            ),

// WISHBONE Slave Interface (Connect to WB Master)
  .data_o   ( wbm_d_or12_dat_i     ),
  .data_i   ( wbm_d_or12_dat_o     ),
  .addr_i   ( wbm_d_or12_adr_o     ),

  .clk_i    ( hclk                 ),
  .rst_i    ( ~hresetn             ),
  .cyc_i    ( wbm_d_or12_cyc_o     ),
  .stb_i    ( wbm_d_or12_stb_o     ),
  .sel_i    ( wbm_d_or12_sel_o     ),
  .we_i     ( wbm_d_or12_we_o      ),
  .ack_o    ( wbm_d_or12_ack_i     )
);



   // 
   // Instantiation
   //    
   or1200_top or1200_top0
       (
	// Instruction bus, clocks, reset
	.iwb_clk_i			(hclk),
	.iwb_rst_i			(~hresetn),
	.iwb_ack_i			(wbm_i_or12_ack_i),
	.iwb_err_i			(1'b0),
	.iwb_rty_i			(1'b0),
	.iwb_dat_i			(wbm_i_or12_dat_i),
	
	.iwb_cyc_o			(wbm_i_or12_cyc_o),
	.iwb_adr_o			(wbm_i_or12_adr_o),
	.iwb_stb_o			(wbm_i_or12_stb_o),
	.iwb_we_o			(wbm_i_or12_we_o),
	.iwb_sel_o			(wbm_i_or12_sel_o),
	.iwb_dat_o			(wbm_i_or12_dat_o),
	.iwb_cti_o			(),
	.iwb_bte_o			(),
	
	// Data bus, clocks, reset            
	.dwb_clk_i			(hclk),
	.dwb_rst_i			(~hresetn),
	.dwb_ack_i			(wbm_d_or12_ack_i),
	.dwb_err_i			(1'b0),
	.dwb_rty_i			(1'b0),
	.dwb_dat_i			(wbm_d_or12_dat_i),

	.dwb_cyc_o			(wbm_d_or12_cyc_o),
	.dwb_adr_o			(wbm_d_or12_adr_o),
	.dwb_stb_o			(wbm_d_or12_stb_o),
	.dwb_we_o			(wbm_d_or12_we_o),
	.dwb_sel_o			(wbm_d_or12_sel_o),
	.dwb_dat_o			(wbm_d_or12_dat_o),
	.dwb_cti_o			(),
	.dwb_bte_o			(),
	
	// Debug interface ports
	.dbg_stall_i        (1'b0),
	.dbg_ewt_i			(1'b0),
	.dbg_lss_o			(),
	.dbg_is_o			(),
	.dbg_wp_o			(),
	.dbg_bp_o			(),

	.dbg_adr_i			(0),      
	.dbg_we_i			(1'b0 ), 
	.dbg_stb_i			(1'b0),          
	.dbg_dat_i			(0),
	.dbg_dat_o			(),
	.dbg_ack_o			(),


	.pm_clksd_o			(),
	.pm_dc_gate_o		(),
	.pm_ic_gate_o		(),
	.pm_dmmu_gate_o		(),
	.pm_immu_gate_o		(),
	.pm_tt_gate_o		(),
	.pm_cpu_gate_o		(),
	.pm_wakeup_o		(),
	.pm_lvolt_o			(),

	// Core clocks, resets
	.clk_i				( hclk              ),
	.rst_i				(~hresetn           ),
	
	.clmode_i			( 2'b00             ),
	// Interrupts      
	.pic_ints_i			( or1200_pic_ints   ),
	.sig_tick           (                   ), /// ??????????????? 
	/*
	 .mbist_so_o			(),
	 .mbist_si_i			(0),
	 .mbist_ctrl_i			(0),
	 */

	.pm_cpustall_i      ( 1'b0              )

	);



endmodule
