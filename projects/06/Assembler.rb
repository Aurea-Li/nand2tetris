require 'ap'
require 'pry'

COMP = {
  '0'   =>    '0101010',
  '1'   =>    '0111111',
  '-1'  =>    '0111010',
  'D'   =>    '0001100',
  'A'   =>    '0110000',
  '!D'  =>    '0001101',
  '!A'  =>    '0110001',
  '-D'  =>    '0001111',
  '-A'  =>    '0110011',
  'D+1' =>    '0011111',
  'A+1' =>    '0110111',
  'D-1' =>    '0001110',
  'A-1' =>    '0110010',
  'D+A' =>    '0000010',
  'D-A' =>    '0010011',
  'A-D' =>    '0000111',
  'D&A' =>    '0000000',
  'D|A' =>    '0010101',
  'M'   =>    '1110000',
  '!M'  =>    '1110001',
  '-M'  =>    '1110011',
  'M+1' =>    '1110111',
  'M-1' =>    '1110010',
  'D+M' =>    '1000010',
  'D-M' =>    '1010011',
  'M-D' =>    '1000111',
  'D&M' =>    '1000000',
  'D|M' =>    '1010101'
}

DEST = {
  'M'  => '001',
  'D'  => '010',
  'MD' => '011',
  'A'  => '100',
  'AM' => '101',
  'AD' => '110',
  'AMD'=> '111'
}

JUMP = {
  'JGT' => '001',
  'JEQ' => '010',
  'JGE' => '011',
  'JLT' => '100',
  'JNE' => '101',
  'JLE' => '110',
  'JMP' => '111'
}



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
    return { dest: instr[0..(eq-1)],
             comp: instr[(eq+1)..(jmp-1)],
             jump: instr[(jmp+1)..-1]  }

  # jump field is empty
  elsif eq
    return { dest: instr[0..(eq-1)],
             comp: instr[(eq+1)..-1],
             jump: nil }

  # dest field is empty
  elsif jmp

    return { dest: nil,
             comp: instr[0..(jmp-1)],
             jump: instr[(jmp+1)..-1] }
  end
end

asm_filename = ARGV.first
hack_filename =  asm_filename[0..-5] + ".hack"



# Adding pre-defined symbols
symbols = {
  'SP'      => '0',
  'LCL'     => '1',
  'ARG'     => '2',
  'THIS'    => '3',
  'THAT'    => '4',
  'SCREEN'  => '16384',
  'KEYBOARD'=> '24576'
}

16.times do |i|
  symbols['R' + i.to_s] = i
end

line_num = 1
var_addr = 16

File.open(asm_filename, "r").each do |line|

  line.strip!


  # Ignore comments and blank lines
  if line[0..1] != "//" && !line.empty?

    # strip trailing comments
    if line.include?("//")
      line = line[0..(line.index("//")-1)].strip
    end

    # add labels
    if line[0] == "(" && line[-1] == ")"
      symbols[line[1..-2]] = line_num + 1

    # add variables
    elsif line[0] == '@' && line[1..-1].to_i != line[1..-1].to_i.to_s
      symbols[line[1..-1]] = var_addr
      var_addr += 1
    end

    line_num += 1

  end
end





File.open(hack_filename, "w") do |hack|
File.open(asm_filename, "r").each do |asm|

  asm.strip!
  # Ignore comments, blank lines, and labels
  if asm[0..1] != "//" && !asm.empty? && asm[0] != '('

    # strip trailing comments
    if asm.include?("//")
      asm = asm[0..(asm.index("//")-1)].strip
    end

    # A instruction
    if asm[0] == '@'

      # if symbol (string)
      if asm[1..-1].to_i != asm[1..-1].to_i.to_s
        hack << '0' + int_bin(symbols[asm[1..-1]]) + "\n"
      # if number
      else
        hack << '0' + int_bin(asm[1..-1].to_i) + "\n"
      end

    # C instruction
    else
      components = c_comp(asm)

      # binding.pry
      comp = components[:comp]
      jump = components[:jump]
      dest = components[:dest]

      if jump && dest
        hack << '111' + COMP[comp] + DEST[dest] + JUMP[jump] + "\n"
      elsif jump
        hack << '111' + COMP[comp] + '000' + JUMP[jump] + "\n"
      elsif dest
        hack << '111' + COMP[comp] + DEST[dest] + '000' + "\n"
      end
    end
  end
end
end
