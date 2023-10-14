class CustomAVL
end

class CustomBinaryTree
    class Node 
        attr_accessor :value, :left, :right, :parent
        def initialize(value)
            @value = value
            @left = nil
            @right = nil
            @parent = nil
        end

        def get_value
            @value
        end
    end

    class BinaryTree 
        attr_accessor :root

        def initialize(node)
            @root = node ? node : nil
        end

    def emplace!(tgt)
        if @root.nil?
            @root = tgt
            return
        end

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
            return nil if tgt == nil
            
        end
        
        def  top
            @root
        end

        def empty?
            root == nil
        end

        def find(node)
            crt = root
            while crt != nil
                if crt.get_value == node.get_value
                    return crt
                elsif crt.get_value < node.get_value
                    crt = crt.right
                else
                    crt = crt.left
                end            
            end
        end
        
        def print
            return if @root.nil?
            res = []
            stack = [@root]
            while !stack.empty?
                crt = stack.pop
                res.push(crt.get_value)
                stack.push(crt.right) if crt.right
                stack.push(crt.left) if crt.left
            end
            res
        end
        private
    end
end

t = CustomBinaryTree::BinaryTree.new(CustomBinaryTree::Node.new(5))

[2,3,7,9,4,1,6,8].map{ |e| CustomBinaryTree::Node.new(e) }.each do |node|
    t.emplace!(node)
end

puts t.print.join(" ")
