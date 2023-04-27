require_relative 'node'
require_relative 'tree'

data = Array.new(15) { rand(1..100) }
tree = Tree.new(data)

puts "Is the tree balanced? #{tree.balanced?}"
puts "Level order traversal: #{tree.level_order}"
puts "Preorder traversal: "
tree.preorder { |data| print "#{data} " }
puts "\nPostorder traversal: "
tree.postorder { |data| print "#{data} " }
puts "\nInorder traversal: "
tree.inorder { |data| print "#{data} " }

tree.insert(150)
tree.insert(200)
tree.insert(250)

puts "\n\nAfter inserting nodes with values 150, 200, 250..."
puts "Is the tree balanced? #{tree.balanced?}"

tree.rebalance

puts "\nAfter rebalancing the tree..."
puts "Is the tree balanced? #{tree.balanced?}"
puts "Level order traversal: #{tree.level_order}"
puts "Preorder traversal: "
tree.preorder { |data| print "#{data} " }
puts "\nPostorder traversal: "
tree.postorder { |data| print "#{data} " }
puts "\nInorder traversal: "
tree.inorder { |data| print "#{data} " }
