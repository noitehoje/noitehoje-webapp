class ApiHelper
  def initialize api_key
    @api_key = api_key
    @base_url = API_BASE_URL
  end

  # Event methods
  def event_details_json event_id
    get_endpoint "getevent/#{event_id}"
  end

  def event_locations_json
    get_endpoint "getlocations"
  end

  def event_details event_id
    JSON.parse event_details_json(event_id)
  end

  def all_events
    json = JSON.parse get_endpoint("getallevents")
    json["events"]
  end

  # User methods
  def new_user details
    JSON.parse post_endpoint("user", details)
  end

  def user_details user_id
    JSON.parse get_endpoint("user/#{user_id}")
  end

  def add_service user_id, service
    JSON.parse post_endpoint("user/#{user_id}/add_service", service)
  end

  def user_by_service service_provider, uid
    JSON.parse get_endpoint("user?provider=#{service_provider}&uid=#{uid}")
  end

  private
  def get url
    open(URI.encode(url)).read
  end

  def post url, params
    RestClient.post url, params
  end

  def get_endpoint name
    get build_url(name)
  end

  def post_endpoint name, params
    post build_url(name), params
  end

  def build_url resource_name
    "#{@base_url}api/v1/#{@api_key}/#{resource_name}"
  end
end
