require_relative  'io/basic'

class Main
    def run
        s = CustomIO.new
        n = s.read_array
        p n
    end
end

main = Main.new
main.run