require "test_helper"

class DnsControllerTest < ActionDispatch::IntegrationTest
  test "should get lookup" do
    get dns_lookup_url
    assert_response :success
  end
end
