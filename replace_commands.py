import re
from pprint import pprint
import os

os.rename('src/buildmanager.cpp', 'src/buildmanager.cpp.bak')

with open("src/buildmanager.cpp.bak") as input:
    with open("src/buildmanager.cpp", "w+") as output:
        for line in input:
            if "registerCommand" in line and not "bibtex" in line and not "Ghostscript" in line and not "BuildManager::registerCommand" in line and "txs" not in line:
                print("----------------------------------------")
                if ");" in line:
                    line = line.split(");")[0]+");"
                print("original line:")
                print(line)
                rex = re.compile(r'\ +')
                result = rex.sub(' ', line)
                result = result.replace("registerCommand(","")
                
                result = result.replace(");\r\n","\r\n")
                result = result.replace(");\n","\n")
                result = result.replace(");","")
                args = result.split(",")
                if len(args) >= 4:
                    for i in range(len(args)):
                        args[i] = args[i].strip().replace("\r","").replace("\n","")
                    print(line.strip())
                    # print(result.strip())
                    pprint(args)
                    arg1 = args[1].replace("\"","")
                    arg3 = args[3].replace("\"","")
                    args[3] = f"\"{arg1} {arg3}\""
                    args[1] = "\"flatpak-wrapper\""
                    pprint(args)
                    output_line = f"	registerCommand("
                    for i in range(len(args)):
                        output_line += args[i]
                        if i < len(args)-1:
                            output_line += ", "
                    if ");" in line:
                        output_line += f");"

                    print("line with flatpak-wrapper:")
                    print(output_line)
                    
                else:
                    output_line = line
                output_line += f"\r\n"
            else:
                output_line = line

            output.write(output_line.replace("\n","\r\n"))
        

            
os.remove('src/buildmanager.cpp.bak')