#! /usr/bin/ruby

$files = Hash.new(0)

def isFile(str)
  return /^(\s*\.\.\.\/.*?.java)/.match(str)
end

def storyList(block)
  return block.scan(/(\w+-\d+)/)
end

def parse(stack)
  ustack = Array.new
  sstack = Array.new

  # Look for User and Story
  stack.each do |line|
    hold = line.to_s.chomp.split(/"\s"/)
    if hold.count == 2
     ustack.push(hold[0][1..-1])
      sstack.push(storyList(hold[1]))
    end
  end

  # Look for files
  stack.each do |line|
    file = isFile(line)
    next unless file

    if $files.has_key?(file)
      d = $files[file]
      d[0] = d[0] + 1
      d[1] = d[1] + ustack
      d[2] = d[2] + sstack
    else
      d = Array.new
      d[0] = 1
      d[1] = ustack
      d[2] = sstack
      $files[file] = d
    end
  end

end

lines = Array.new
ARGF.each_line do |line|

  if line =~ /^\s*\n/
    parse(lines)
    lines.clear
  else
    lines.push(line)
  end
end

#print $files.length.to_s + "\n"
$files.each do |k, v|
  print k.to_s + "|" + v[0].to_s + "|" + v[1].uniq.join(",").to_s + "|" + v[2].uniq.join(",").to_s + "\n"
#  print k.to_s + "|" + v[0].to_s + "|" + v[1].uniq.to_s + "|" + v[2].uniq.to_s + "\n"
end
