require 'pry'


# Go through file once and save down all symbols in a symbol table (hash)

# Converts integer into 15 bit binary number
def int_bin(num)

  bin = ''
  [*0..14].reverse.each do |i|
    if num >= 2 ** i
      num -= 2 ** i
      bin += '1'
    else
      bin += '0'
    end
  end
  return bin
end

# Parse out C command into its different components
def c_comp(instr)

  eq = instr.index("=")
  jmp = instr.index(";")

  if eq && jmp
    return [instr[0..(eq-1),
            instr[(eq+1)..(jmp-1)],
            instr[(jmp+1)..-1]]

  elsif eq
    return [instr[0..(eq-1)],
            instr[(eq+1)..-1],
            nil]

  elsif jmp
    return [nil,
            instr[(eq+1)..(jmp-1)],
            instr[(jmp+1)..-1]]]
  end
end

def


asm_filename = ARGV.first
hack_filename =  asm_filename[0..-5] + ".hack"


File.open(hack_filename, "w") do |hack|
File.open(asm_filename, "r").each do |asm|

  asm.strip!
  # Strip out comments and blank lines
  if asm[0..1] != "//" && !asm.empty?

    # A instruction
    if asm[0] == '@'
      hack << '0' + int_bin(asm[1..-1].to_i) + "\n"
    # C instruction
    else
      comp = c_comp(asm)
      


    end
  end
end
end
