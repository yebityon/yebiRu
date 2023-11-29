require 'net/http'

class Lurc

  attr_reader :uri

  def initialize
    @response = nil
    @responses = []
  end

  def uri=(url)
    @uri = URI(url)
  end

  def get
    res = core_implementation(proc { Net::HTTP.get_response(@uri) })
      case res
      when Net::HTTPMovedPermanently
        @response = core_implementation(proc { Net::HTTP.get_response(URI.parse(res['location'])) }) if res.is_a?(Net::HTTPMovedPermanently)
          return @response
      end
      @response = res
  end

  def post(params = {})
    res = core_implementation(proc { Net::HTTP.post_form(@uri, params) })
  end

  def desc
    p "response: #{@response.code}"
    p "uri: #{@uri}"
    p "status_code : #{@response.code}"
  end

  def desc_headers(response: @responses.last, key: nil)
    h = response.each_header.each_with_object({}) { |(k, v), headers| headers[k] = v }
    return (key.nil? ? h : h[key])
  end

  def response=(res)
    @responses << res
    @response = res
  end

  def responsies
    @responses
  end


  def clear
    @responses = []
    @response = nil
  end

  private
  def core_implementation(proc)
    retries = 0
      begin
        response = proc.call
        @responses << response
        response
      rescue SocketError, Net::HTTPBadRequest
        retries += 1
        raise if retries > 3

        sleep(3 * (0.5 + (rand / 2)) * (1.5**(retries - 1)))
        retry
      end
  end

end
