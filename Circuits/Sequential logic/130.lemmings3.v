module top_module(
    input clk,
    input areset,    // Freshly brainwashed Lemmings walk left.
    input bump_left,
    input bump_right,
    input ground,
    input dig,
    output walk_left,
    output walk_right,
    output aaah,
    output digging ); 
    
    reg[6:0] count; 
    reg [3:0] state;
    reg [3:0] next_state;
    localparam [2:0] GROUND_L = 3'b000,
					 GROUND_R = 3'b001,
					 DIG_L = 3'b010,
 					 DIG_R = 3'b011,
    				 WALK_L = 3'b100,
    				 WALK_R = 3'b101,
    				 DIE = 3'b110;

    //state change
    always @(*)
        begin
            case(state)
                /*GROUND判断这里一定要用if-else 不能用简单的判断语句*/
                GROUND_L: begin
                    if(ground)
                        begin
                            if(count > 19)
                                next_state <= DIE;
                            else
                                next_state <= WALK_L;
                        end
                    else
                        next_state <= GROUND_L;
                end
                GROUND_R: begin
                    if(ground)
                        begin
                            if(count > 19)
                                next_state <= DIE;
                            else
                                next_state <= WALK_R;
                        end
                    else
                        next_state <= GROUND_R;
                end
                DIG_L: next_state <= (ground == 0)? GROUND_L : DIG_L;
                DIG_R: next_state <= (ground == 0)? GROUND_R : DIG_R;
                WALK_L: next_state <= (ground == 0)? GROUND_L : (dig == 1)? DIG_L : (bump_left == 1)? WALK_R : WALK_L;
                WALK_R: next_state <= (ground == 0)? GROUND_R : (dig == 1)? DIG_R : (bump_right == 1)? WALK_L : WALK_R;   
                DIE: next_state <= DIE;
            endcase
        end
    
    //clk
    always @(posedge clk, posedge areset)
        begin
            if(areset)
                begin
                	state <= WALK_L;
                end
            else if((state == GROUND_L)||(state == GROUND_R)) begin
                    count <= count + 1;
                	state <= next_state;
            end
            else
                begin
                	state <= next_state;
                    count <= 0;
                end
        end
                
        	//assign
			assign walk_left = (state  == WALK_L);
        	assign walk_right = (state == WALK_R);
            assign aaah = ((state == GROUND_L)||(state == GROUND_R));
            assign digging = ((state == DIG_L)||(state == DIG_R));

endmodule
