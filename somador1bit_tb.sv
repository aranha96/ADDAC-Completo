`timescale 1ns/100ps

module somador1bit_tb;
 parameter max_vectors=8;
	//logic [3:0] a;
	logic a, b, cin, s, s_esperado, cout, cout_esperado;
	//logic [4:0] counter, errors;
	//logic [8:0] counter, errors;
	int counter, errors;
	logic [4:0]vectors[max_vectors];
	logic clk, rst;
	integer file; 
	//inv dut(a,y); //simulação gate level não está aceitando
	somador1bit dut(.a(a),.b(b),.cin(cin),.s(s),.cout(cout));
	
	initial	begin
  counter = 0; errors = 0;
	rst = 1'b1; #12; rst = 0;
	clk=0;
		if(~rst) begin
			$readmemb("somador1bit.tv", vectors);
		end	
			file = $fopen("somador1bit_out.txt");
			$display("Iniciando Testbench");
			$fwrite(file, "Iniciando Testbench\n");
			$display("-------------\n");
			$fwrite(file, "-------------\n");
			// "             |  %d  | %b   |  %b  |
			$display("| linha |  A  |  B  |  I  |  S  |  O  |");
			$fwrite(file, "| linha |  A  |  B  |  I  |  S  |  O  |\n");
		
		
	end
		
	always begin
	
		clk = 1; #10;
		clk = 0; #5;
	end

	always @(posedge clk)
		if(~rst) begin
			//{a, y_esperado} = vectors [counter];
		        a = vectors[counter][4];
				b = vectors[counter][3];
				cin = vectors[counter][2];
				cout_esperado = vectors[counter][0];
				s_esperado = vectors[counter][1];
		  
		end	
		
	always @(negedge clk)
	begin
		if(~rst) begin
		  if(s_esperado !== 1'bx) begin
		    assert (s === s_esperado)
			 begin
			       $display("|   %0d   |  %b  |  %b  |  %b  |  %b  |  %b  | OK", counter, a,b,cin,s,cout);
				$fwrite(file, "|   %0d   |  %b  |  %b  |  %b  |  %b  |  %b  | OK \n", counter, a,b,cin,s,cout);
			  end
		      else begin
				    for( logic k = 0; k < 2; k++) begin
						assert (s === s_esperado)
						begin
						end 
					    else begin
							if(s_esperado!= "x") begin 
								$error("Erro na linha%d",counter," a[%d",k,"]=%d",a," y[%d",k,"]=%d",s," y_esperado[%d",k,"]=%d",s_esperado);	  			     
								$fwrite(file, "Erro na linha %d ",counter," a[%d",k,"]=%d",a," y[%d",k,"]=%d",s," y_esperado[%d",k,"]=%d\n",s_esperado);
								errors++;
							end
					    end
				    end
				end
	  	 
		  end
		counter++;
			if (counter == 8) begin
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