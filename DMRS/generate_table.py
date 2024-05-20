
for N in range(4):
    i=0
    # Open the file in read mode
    with open(f'phi{N+1}.txt', 'r') as file:
        lines = file.readlines()
    
    array_phi = [line.strip() for line in lines]
    with open(f'phi{N+1}.v', 'w') as f:
        f.write(f'''module phi{N+1} (
        input   [4:0]   u,   //  Sequence number
        input   [9:0]   counter,   //  Counter of the generator
        output wire [1:0]  phi_value  //  phase of the sequence
    );

    wire [1:0] phi{N+1} [0:29][0:{(N+1)*6 - 1}];

    assign phi_value = phi{N+1}[u][counter];
        \n''')
        
        for x in range(30):
            for y in range((N+1)*6):
                f.write(f"assign phi{N+1} [{x}][{y}] = 2'b{array_phi[i]};\n")
                i=i+1
        f.write("\nendmodule\n")

# Nzc lut
i=0
with open(f'N_zc_rec.txt', 'r') as file_Nzc_rec:
    lines_Nzc_rec = file_Nzc_rec.readlines()
    
    array_Nzc_rec = [line.strip() for line in lines_Nzc_rec]

with open(f'N_zc.txt', 'r') as file_Nzc:
    lines_Nzc = file_Nzc.readlines()
    
    array_Nzc = [line.strip() for line in lines_Nzc]

    with open(f'N_zc.v', 'w') as f:
        f.write(f'''module N_zc (
        input   [9:0]  Mzc,   //  Sequence length
        output reg [9:0]  Nzc,  //  N zadoff chu
        output reg [29:0]  Nzc_rec  //  N_rec zadoff chu
    );

    reg Nzc_flag;
    reg [4:0] ind;
    integer j;

    wire [9:0] prime [0:26];
    wire [29:0] prime_rec [0:26];
                
    // Nzc and Nzc_rec Calculations
    always@(*)
        begin
            ind = 7'b0;
            Nzc_flag = 1'b0;
            
            for(j = 1; j <= 26; j = j + 1) begin
                if ((Mzc < prime[j]) && (!Nzc_flag)) begin
                    ind = j - 1;
                    Nzc_flag = 1'b1;
                end
                
                else if (!Nzc_flag)
                    ind = 7'd26;
                
            end
		
		// Nzc and its reciprocal Calculations
		Nzc = prime[ind];
		Nzc_rec = prime_rec[ind];
        end\n''')

        for x in range(27):
            f.write(f"assign prime [{x}] = 10'b{array_Nzc[i]}; assign prime_rec [{x}] = 30'b{array_Nzc_rec[i]};\n")
            i=i+1
        f.write("\nendmodule\n")

