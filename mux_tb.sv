`timescale 1ns/100ps

module mux_tb;
 parameter max_vectors=13;
	//logic [3:0] a;
	logic [3:0] d0, d1, y, y_esperado;
	logic	s;
	//logic [4:0] counter, errors;
	//logic [8:0] counter, errors;
	int counter, errors;
	logic [12:0]vectors[max_vectors];
	logic clk, rst;
	integer file; 
	//inv dut(a,y); //simulação gate level não está aceitando
	mux dut(.d0(d0),.d1(d1), .s(s), .y(y));
	
	initial	begin
  counter = 0; errors = 0;
	rst = 1'b1; #12; rst = 0;
	clk=0;
		if(~rst) begin
			$readmemb("mux.tv", vectors);
		end	
			file = $fopen("mux_out.txt");
			$display("Iniciando Testbench");
			$fwrite(file, "Iniciando Testbench\n");
			$display("-------------\n");
			$fwrite(file, "-------------\n");
			// "             |  %d  | %b   |  %b  |
			$display("|linha |   A    |   B    |   s  |    Y   |");//lembrar de incluir o d1 no display
			$fwrite(file, "|linha |   A    |   B    |   s  |    Y   |\n");//lembrar de incluir o d1 no display
		
		
	end
		
	always begin
	
		clk = 1; #10;
		clk = 0; #5;
	end

	always @(posedge clk)
		if(~rst) begin
			//{a, y_esperado} = vectors [counter];
		         d0[3:0] = vectors[counter][12:9];
				 d1[3:0] = vectors[counter][8:5];
				 s = vectors[counter][4];
				 y_esperado[3:0] = vectors[counter][3:0];
		  
		end	
		
	always @(negedge clk)
	begin
		if(~rst) begin
		  if(y_esperado !== 4'bx) begin
		    assert (y === y_esperado)
			  begin
			       $display("|  %0d   |  %b  |  %b  |  %b  |  %b  | OK", counter, d0,d1,s, y); //lembrar de incluir o d1 no display
				$fwrite(file, "|  %0d   |  %b  |  %b  |  %b  |  %b  | OK \n", counter, d0,d1,s, y);//lembrar de incluir o d1 no display
		    end
		      else begin
				    for( logic[2:0] k = 0; k < 4; k++) begin
						assert (y[k] === y_esperado[k])
						begin
						end 
					    else begin
							if(y_esperado[k]!= "x") begin 
								$error("Erro na linha%d",counter," a[%d",k,"]=%d",d0[k]," y[%d",k,"]=%d",y[k]," y_esperado[%d",k,"]=%d",y_esperado[k]);	//lembrar de incluir o d1 no display  			     
								$fwrite(file, "Erro na linha %d ",counter," a[%d",k,"]=%d",d0[k]," y[%d",k,"]=%d",y[k]," y_esperado[%d",k,"]=%d\n",y_esperado[k]);//lembrar de incluir o d1 no display
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