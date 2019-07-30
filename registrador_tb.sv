`timescale 1ns/100ps

module registrador_tb;
 parameter max_vectors=8;
	//logic [3:0] a;
	logic [3:0] d, q, q_esperado;
	//logic [4:0] counter, errors;
	//logic [8:0] counter, errors;
	int counter, errors;
	logic [7:0]vectors[max_vectors];
	logic clk, rst;
	integer file; 
	//inv dut(a,y); //simulação gate level não está aceitando
	registrador dut(.clk(clk), .d(d), .q(q));
	
	initial	begin
  counter = 0; errors = 0;
	rst = 1'b1; #12; rst = 0;
	clk=0;
		if(~rst) begin
			$readmemb("registrador.tv", vectors);
		end	
			file = $fopen("registrador_out.txt");
			$display("Iniciando Testbench");
			$fwrite(file, "Iniciando Testbench\n");
			$display("-------------\n");
			$fwrite(file, "-------------\n");
			// "      |  %d  | %b   |  %b  |
			$display("|linha |   D    |   Q   |");
			$fwrite(file, "|linha |   D    |   Q   |\n");
		
		
	end
		
	always begin
	
		clk = 1; #10;
		clk = 0; #5;
	end

	always @(posedge clk)
		if(~rst) begin
			//{a, y_esperado} = vectors [counter];
		         d[3:0] = vectors[counter][7:4];
				 q_esperado[3:0] = vectors[counter][3:0];
		  
		end	
		
	always @(negedge clk)
	begin
		if(~rst) begin
		  if(q_esperado !== 4'bx) begin
		    assert (q === q_esperado)
			  begin		   //|linha |   D    |   Q   | 	
			       $display("| %0d  |  %b    |  %b   | OK", counter,d,q); 
				$fwrite(file, "| %0d  |  %b    |  %b   | OK\n", counter,d,q);
		    end
		      else begin
				    for( logic[2:0] k = 0; k < 4; k++) begin
						assert (q[k] === q_esperado[k])
						begin
						end 
					    else begin
							if(q_esperado[k]!= "x") begin 
								$error("Erro na linha%d",counter," a[%d",k,"]=%d",d[k]," y[%d",k,"]=%d",q[k]," y_esperado[%d",k,"]=%d",q_esperado[k]);	//lembrar de incluir o d1 no display  			     
								$fwrite(file, "Erro na linha %d ",counter," a[%d",k,"]=%d",d[k]," y[%d",k,"]=%d",q[k]," y_esperado[%d",k,"]=%d\n",q_esperado[k]);//lembrar de incluir o d1 no display
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