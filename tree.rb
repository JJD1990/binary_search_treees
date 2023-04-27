require_relative 'node'
  
  class Tree
    attr_accessor :root
  
    def initialize(data)
      data = data.uniq.sort
      @root = build_tree(data)
    end
  
    def build_tree(data)
      return nil if data.empty?
  
      middle_index = data.length / 2
      root = Node.new(data[middle_index])
      root.left_child = build_tree(data[0...middle_index])
      root.right_child = build_tree(data[(middle_index + 1)..-1])
      root
    end
  
    def insert(value)
      return if contains?(value)
  
      node = Node.new(value)
  
      if @root.nil?
        @root = node
        return
      end
  
      current_node = @root
      while true
        if value < current_node.data
          if current_node.left_child.nil?
            current_node.left_child = node
            break
          else
            current_node = current_node.left_child
          end
        else
          if current_node.right_child.nil?
            current_node.right_child = node
            break
          else
            current_node = current_node.right_child
          end
        end
      end
    end
  
    def delete(value)
      return if !contains?(value)
  
      if @root.data == value
        if @root.left_child.nil? && @root.right_child.nil?
          @root = nil
        elsif @root.left_child.nil?
          @root = @root.right_child
        elsif @root.right_child.nil?
          @root = @root.left_child
        else
          inorder_successor = find_inorder_successor(@root.right_child)
          @root.data = inorder_successor.data
          delete(inorder_successor.data)
        end
  
        return
      end
  
      parent_node = find_parent_node(value)
      node_to_delete = parent_node.left_child.data == value ? parent_node.left_child : parent_node.right_child
  
      if node_to_delete.left_child.nil? && node_to_delete.right_child.nil?
        if parent_node.left_child == node_to_delete
          parent_node.left_child = nil
        else
          parent_node.right_child = nil
        end
      elsif node_to_delete.left_child.nil?
        if parent_node.left_child == node_to_delete
          parent_node.left_child = node_to_delete.right_child
        else
          parent_node.right_child = node_to_delete.right_child
        end
      elsif node_to_delete.right_child.nil?
        if parent_node.left_child == node_to_delete
          parent_node.left_child = node_to_delete.left_child
        else
          parent_node.right_child = node_to_delete.left_child
        end
      else
        inorder_successor = find_inorder_successor(node_to_delete.right_child)
        node_to_delete.data = inorder_successor.data
        delete(inorder_successor.data)
      end
    end
  
    def find(value)
      current_node = @root
      while !current_node.nil?
        if current_node.data == value
          return current_node
        elsif value < current_node.data
          current_node = current_node.left_child
        else
          current_node = current_node.right_child
        end
      end
      nil
    end

    def level_order
        result = []
        queue = [@root]
        while !queue.empty?
          current_node = queue.shift
          result << current_node.data
          queue << current_node.left_child unless current_node.left_child.nil?
          queue << current_node.right_child unless current_node.right_child.nil?
        end
        block_given? ? result.each { |data| yield data } : result
      end
    
      def inorder(node = @root, &block)
        return if node.nil?
    
        inorder(node.left_child, &block)
        block_given? ? yield(node.data) : puts(node.data)
        inorder(node.right_child, &block)
      end
    
      def preorder(node = @root, &block)
        return if node.nil?
    
        block_given? ? yield(node.data) : puts(node.data)
        preorder(node.left_child, &block)
        preorder(node.right_child, &block)
      end
    
      def postorder(node = @root, &block)
        return if node.nil?
    
        postorder(node.left_child, &block)
        postorder(node.right_child, &block)
        block_given? ? yield(node.data) : puts(node.data)
      end
    
      def height(node)
        return -1 if node.nil?
    
        left_height = height(node.left_child)
        right_height = height(node.right_child)
        [left_height, right_height].max + 1
      end
    
      def depth(node)
        return 0 if node.nil?
    
        parent = find_parent_node(node.data)
        parent.nil? ? 0 : 1 + depth(parent)
      end
    
      def balanced?(node = @root)
        return true if node.nil?
      
        left_height = height(node.left_child)
        right_height = height(node.right_child)
        return (left_height - right_height).abs <= 1 && balanced?(node.left_child) && balanced?(node.right_child)
      end
      
    
      def rebalance
        data = level_order.sort.uniq
        self.root = build_tree(data)
      end
    
      private
    
      def contains?(value)
        !find(value).nil?
      end
    
      def find_inorder_successor(node)
        while !node.left_child.nil?
          node = node.left_child
        end
        node
      end
    
      def find_parent_node(value)
        return nil if @root.nil? || @root.data == value
    
        current_node = @root
        while !current_node.nil?
          if current_node.left_child&.data == value || current_node.right_child&.data == value
            return current_node
          elsif value < current_node.data
            current_node = current_node.left_child
          else
            current_node = current_node.right_child
          end
        end
        nil
      end
    end
    
  