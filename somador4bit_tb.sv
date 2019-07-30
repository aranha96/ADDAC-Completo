`timescale 1ns/100ps

module somador4bit_tb;
 parameter max_vectors=17;
	//logic [3:0] a;
	logic [3:0] a, b, s, s_esperado, cout, cout_esperado;
	logic cin;
	//logic [4:0] counter, errors;
	//logic [8:0] counter, errors;
	int counter, errors;
	logic [16:0]vectors[max_vectors];
	logic clk, rst;
	integer file; 
	//inv dut(a,y); //simulação gate level não está aceitando
	somador4bit dut(.a(a),.b(b), .cin(cin), .s(s), .cout(cout));
	
	initial	begin
  counter = 0; errors = 0;
	rst = 1'b1; #12; rst = 0;
	clk=0;
		if(~rst) begin
			$readmemb("somador4bit.tv", vectors);
		end	
			file = $fopen("somador4bit_out.txt");
			$display("Iniciando Testbench");
			$fwrite(file, "Iniciando Testbench\n");
			$display("-------------\n");
			$fwrite(file, "-------------\n");
			// "             |  %d  | %b   |  %b  |
			$display("|linha |   A     |   B     |   S     |   cout  |");//lembrar de incluir o d1 no display
			$fwrite(file, "|linha |   A     |   B     |   S     |   cout  |\n");//lembrar de incluir o d1 no display
		
		
	end
		
	always begin
	
		clk = 1; #20;
		clk = 0; #5;
	end

	always @(posedge clk)
		if(~rst) begin
			//{a, y_esperado} = vectors [counter];
		         a[3:0] = vectors[counter][16:13];
				 b[3:0] = vectors[counter][12:9];
				 cin = vectors[counter][8];
				 s_esperado[3:0] = vectors[counter][7:4];
				 cout_esperado[3:0] = vectors[counter][3:0];
		  
		end	
		
	always @(negedge clk)
	begin
		if(~rst) begin
		  if(s_esperado !== 4'bx) begin
		    assert (s === s_esperado)
			  begin
			       $display("| %0d    |  %b   |  %b   |  %b   |  %b   | OK", counter, a,b,s, cout); //lembrar de incluir o d1 no display
				$fwrite(file, "| %0d    |  %b   |  %b   |  %b   |  %b   | OK\n", counter, a,b,s, cout);//lembrar de incluir o d1 no display
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