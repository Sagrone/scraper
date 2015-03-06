require 'webmock/rspec'

module StubHelper
  def stub_request_for(url, file_name)
    stub_request(:get, url)
      .to_return({
        body: get_response_file(file_name),
        headers: {'content-type' => 'text/html'},
        status: 200
      })
  end

  def get_response_file(name)
    IO.read(File.join('spec/test_responses', "#{name}"))
  end
end