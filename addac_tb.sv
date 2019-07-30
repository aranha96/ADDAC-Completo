`timescale 1ns/100ps

module addac_tb;
 parameter max_vectors=10;
	//logic [3:0] a;
	logic [3:0] a, s, s_esperado, cout;
	logic  sel0, sel1;
	//logic [4:0] counter, errors;
	//logic [8:0] counter, errors;
	int counter, errors;
	logic [9:0]vectors[max_vectors];
	logic clk, rst;
	integer file; 
	//inv dut(a,y); //simulação gate level não está aceitando
	addac dut(.a(a), .sel0(sel0), .sel1(sel1), .clk(clk), .s(s), .cout(cout));
	
	initial	begin
  counter = 0; errors = 0;
	rst = 1'b1; #12; rst = 0;
	clk=0;
		if(~rst) begin
			$readmemb("addac.tv", vectors);
		end	
			file = $fopen("addac_out.txt");
			$display("Iniciando Testbench");
			$fwrite(file, "Iniciando Testbench\n");
			$display("-------------\n");
			$fwrite(file, "-------------\n");
			// "      |  %d  | %b   |  %b  |
			$display("|linha |   A    |  sel0 | sel1  |   S   | ");
			$fwrite(file, "|linha |   A    |  sel0 | sel1  |   S   | \n");
		
		
	end
		
	always begin
	
		clk = 1; #15;
		clk = 0; #5;
	end

	always @(posedge clk)
		if(~rst) begin
			//{a, y_esperado} = vectors [counter];
		         a[3:0] = vectors[counter][9:6];
				 sel0 = vectors[counter][5];
				 sel1 = vectors[counter][4];
				 s_esperado[3:0] = vectors[counter][3:0];
		  
		end	
		
	always @(negedge clk)
	begin
		if(~rst) begin
		  if(s_esperado !== 4'bx) begin
		    assert (s === s_esperado)
			  begin		   //|linha |   A    |  sel0 | sel1  |   S   | 	
			       $display("| %0d  |  %b    |  %b   |  %b   |  %b   | OK", counter,a,sel0,sel1,s); 
				$fwrite(file, "| %0d  |  %b    |  %b   |  %b   |  %b   | OK\n", counter,a,sel0,sel1,s);
		    end
		      else begin
				    for( logic[2:0] k = 0; k < 4; k++) begin
						assert (s[k] === s_esperado[k])
						begin
						end 
					    else begin
							if(s_esperado[k]!= "x") begin 
								$error("Erro na linha%d",counter," a[%d",k,"]=%d",a[k]," y[%d",k,"]=%d",s[k]," y_esperado[%d",k,"]=%d",s_esperado[k]);	//lembrar de incluir o d1 no display  			     
								$fwrite(file, "Erro na linha %d ",counter," a[%d",k,"]=%d",a[k]," y[%d",k,"]=%d",s[k]," y_esperado[%d",k,"]=%d\n",s_esperado[k]);//lembrar de incluir o d1 no display
								errors++;
							end
					    end
				    end
				end
	  	 
		  end
		counter++;
			if (counter == max_vectors) begin
				$display("Testes Efetuados  = %0d", counter);
				$fwrite(file, "\nTestes Efetuados = %0d \n", counter);
				$display("Erros Encontrados = %0d", errors);
				$fwrite(file, "Erros Encontrados = %0d \n", errors);
				$fclose(file);
				
				#10
				$stop;
			end
		end
	end
		
 endmodule