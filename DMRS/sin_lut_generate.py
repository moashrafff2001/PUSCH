i=0
with open(f'sin_lut.txt', 'r') as file_sin:
    lines_sin = file_sin.readlines()
    
    array_sin = [line.strip() for line in lines_sin]

    with open(f'ver_lut.txt', 'w') as f:
        for x in range(256):
            f.write(f"assign lut [{x}] = 8'b{array_sin[i]};\n")
            i=i+1