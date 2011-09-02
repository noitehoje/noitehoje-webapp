class ApiHelper
  def initialize api_key
    @api_key = api_key
    @base_url = ENV["RACK_ENV"] == "development" ? "http://localhost:3456/" : "http://api.noitehoje.com.br/"
  end

  def event_details event_id
    JSON.parse event_details_json(event_id)
  end

  def event_details_json event_id
    call_endpoint "getevent/#{event_id}"
  end

  def all_events
    json = get_json "getallevents"
    json["events"]
  end

  def event_locations_json
    call_endpoint "getlocations"
  end

  private
  def call_endpoint name
    open(URI.encode("#{@base_url}api/v1/#{@api_key}/#{name}")).read
  end

  def get_json method_name
    JSON.parse call_endpoint(method_name)
  end
end
