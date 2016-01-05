module Request
  module JsonHelpers
    def json_response
      @json_response ||= JSON.parse(response.body, symbolize_names: true)
    end
  end

  module HeadersHelpers
    def api_header(version = 1)
      request.headers['Accept'] = "application/family.planner.v#{version}"
    end

    def api_response_format(format = Mime::JSON)
      request.headers['Accept'] = "#{request.headers['Accept']},#{format}"
      request.headers['Content-Type'] = format.to_s
    end

    def api_authorization_header(token)
      request.headers['Authorization'] =  token
    end

    def include_default_accept_headers
      api_header
      api_response_format
    end
  end

  module ModelHelpers
    def create_user_with_group
      user = FactoryGirl.create(:user)
      group = FactoryGirl.build(:group)
      group.owner = user
      group.save
      user.reload
      return user
    end
  end
end