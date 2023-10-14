require 'net/http'

class CustomNetWork
    
    def initialize(url)
        if url.present?
            @uri = URI(url)
        else
            @uri = URI('http://google.com')
        end
    end

    def get
        respose = Net::HTTP.get(@uri)
        if get_status(respose) == '200'
            response
        elsif get_status(respose) == Net::HTTPRedirection
            @uri = URI(response['location'])
            get
        else
            nil
        end
    end
    
    def post(params)
        Net::HTTP.post_form(@uri, params)
    end

    def get_status (response)
        response.code
    end
    
    def get_response (response)
        response.body
    end
end
