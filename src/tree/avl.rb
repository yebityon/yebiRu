class CustomBinaryTree

  class Node
    attr_accessor :value, :left, :right, :parent

    def initialize(value)
      @value = value
      @left = nil
      @right = nil
      @parent = nil
    end

    def val
      @value
    end
  end

  class BinaryTree
    attr_accessor :root

    def initialize(node)
      @root = node || nil
    end

    def emplace!(tgt)
      return @root = tgt if @root.nil?

      parent = nil
      node = @root
      while node
        parent = node
        node = tgt.get_value < node.get_value ? node.left : node.right
      end
      if tgt.get_value < parent.get_value
        parent.left = tgt
      else
        parent.right = tgt
      end
      tgt.parent = parent
    end

    def erase(node)
      tgt = find(node)
      nil if tgt.nil?
    end

    def top
      @root
    end

    def empty?
      root.nil?
    end

    def find(node)
      crt = root
      until crt.nil?
        if crt.get_value == node.get_value
          return crt
        elsif crt.get_value < node.get_value
          crt = crt.right
        else
          crt = crt.left
        end
      end
      return nil
    end

    def print
      return if @root.nil?

      stack = [@root]
        until stack.empty?
          crt = stack.pop
          puts crt.get_value
          stack.push(crt.left) if crt.left
          stack.push(crt.right) if crt.right
        end
    end
  end
end
