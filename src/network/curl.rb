require 'net/http'
require 'uri'
require 'byebug'
require 'readline'

class String
  def black;          "\e[30m#{self}\e[0m" end
  def red;            "\e[31m#{self}\e[0m" end
  def green;          "\e[32m#{self}\e[0m" end
  def brown;          "\e[33m#{self}\e[0m" end
  def blue;           "\e[34m#{self}\e[0m" end
  def magenta;        "\e[35m#{self}\e[0m" end
  def cyan;           "\e[36m#{self}\e[0m" end
  def gray;           "\e[37m#{self}\e[0m" end

  def bg_black;       "\e[40m#{self}\e[0m" end
  def bg_red;         "\e[41m#{self}\e[0m" end
  def bg_green;       "\e[42m#{self}\e[0m" end
  def bg_brown;       "\e[43m#{self}\e[0m" end
  def bg_blue;        "\e[44m#{self}\e[0m" end
  def bg_magenta;     "\e[45m#{self}\e[0m" end
  def bg_cyan;        "\e[46m#{self}\e[0m" end
  def bg_gray;        "\e[47m#{self}\e[0m" end

  def bold;           "\e[1m#{self}\e[22m" end
  def italic;         "\e[3m#{self}\e[23m" end
  def underline;      "\e[4m#{self}\e[24m" end
  def blink;          "\e[5m#{self}\e[25m" end
  def reverse_color;  "\e[7m#{self}\e[27m" end
end


module Lurc
  class Response

    attr_accessor :headers, :body, :code, :method

    def initialize(response = nil)
      @headers = response&.each_header&.to_h || {}
      @body = response&.body || ''
      @code = response&.code || ''
    end

    def pp
      header_str = @headers.map { |k, v| "\t#{k}: #{v}" }.join("\n")
      print "#{"Code".bold}: #{@code}\n#{"Body".bold}: #{@body[0...20]}\n#{"Header".bold}:\n#{header_str}\n"
    end

    def serialize
      { method: @method, headers: @headers, body: @body, code: @code }.to_json
    end

    def load(serialized)
      data = JSON.parse(serialized)
      @method = data['method']
      @headers = data['headers']
      @body = data['body']
      @code = data['code']
    end
  end

  class Request
    attr_accessor :uri, :cookie, :headers, :params, :response, :method

    def initialize(uri, cookie = nil, headers = {}, params = {})
      @uri = uri
      @cookie = cookie
      @headers = headers
      @params = params
      @method = 'NIL'
    end
  end

  class Query
    attr_accessor :req, :res, :child

    def initialize(req, res = nil, child = nil)
      @req = req
      @res = res unless res.nil?
      @child = child || []
    end

    def dup
      self.class.new(@req.dup, @res.dup, @child)
    end

    def to_h
      { req: @req, res: @res }
    end

    def add_response(res)
      @res = res
    end

    def pretty_str
      pretty_str = "#{"Request".bold}: #{@req.method.to_s} #{@req.uri} #{"Response".bold}: #{@res.code}\n"
      unless @child.empty?
        @child.map do |c|
          req = c.req
          res = c.res
          pretty_str += " ---> #{"Request".bold}: #{req.method.to_s} #{req.uri} #{"Response".bold}: #{res.code}\n"
        end
      end
      pretty_str
    end

    def pp
      print pretty_str
    end

  end

  class Lurc
    attr_accessor :queries, :target

    def initialize
      @queries = []
      @target = nil
    end

    def get(req)
      if req.is_a?(String)
        req = Request.new(req)
      elsif req.is_a?(Hash)
        req = Request.new(req[:uri], req[:cookie], req[:headers], req[:params])
      end
      _get(req, false)
    end

    def get_query_detail(index)
      @queries[index]
    end

    def pp
      pretty_str = ''
      for i in 0...@queries.length
        pretty_str += "#{"index".bold}: #{i} #{@queries[i].pretty_str}"
      end
      print pretty_str
    end

    def [](index)
      @queries[index]
    end

    def attach(index)
      @target = @queries[index]
    end

    def req
      @target.req
    end

    def res
      @target.res
    end

    def cp
      @queries.push(@target.dup)
      @target = @queries.last
    end

    def send(req)
      _get(req, true)
    end

    def size
      @queries.size
    end

    def q
      @queries
    end

    def ireq
      if @target.nil?
        print "No target query selected"
        return
      end
      loop do 
        input = Readline.readline('> nekoneko', true)
        Readline::HISTORY.pop if input.empty?
        break if input == 'exit'
        puts "You entered: #{input}"
      end
    end

    private
    def _get(req, child_query = false)
      req.method = 'GET'
      @queries.push(Query.new(req)) unless child_query
      @queries.last.child.push(Query.new(req)) if child_query

      get_proc = proc {
        uri = URI.parse(req.uri)
        http = Net::HTTP.new(uri.host, uri.port)
        http.use_ssl = uri.scheme === "https"

        uri.query = URI.encode_www_form(req.params) if req.params
        request = Net::HTTP::Get.new(uri)
        request['Cookie'] = req.cookie if req.cookie
        http.request(request)
      }
      res = with_circuit_breacker(get_proc)
      @queries.last.add_response(Response.new(res)) unless child_query
      if res.is_a?(Net::HTTPRedirection)
        redirect = _get(Request.new(res['location']),true)
        @queries.last.child.last.add_response(redirect)
      end
      Response.new(res)
    end

    def with_circuit_breacker(proc)
      retries = 0
        begin
          proc.call
        rescue SocketError, Net::HTTPBadRequest
          retries += 1
          return nil if retries > 3

          sleep(3 * (0.5 + (rand / 2)) * (1.5**(retries - 1)))
          retry
        end
    end
  end
end
