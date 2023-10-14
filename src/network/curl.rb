require 'net/http'

class CustomNetWork

  def initialize(url = nil)
    @uri = URI(url || 'http://google.com')
    @response = nil
    @responses = []
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

  def descrive
    p "response: #{@response.code}"
    p "uri: #{@uri}"
    p "status_code : #{@response.code}"
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

        # 再試行する
        sleep(3 * (0.5 + (rand / 2)) * (1.5**(retries - 1)))
        retry
      end
  end

end
