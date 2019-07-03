def stub_getting_wsdl_definition
  wsdl_path = File.join(File.dirname(__FILE__), 'cached_xml', 'general_wsdl_definition.xml')
  wsdl = File.read(wsdl_path)
  stub_request(:get, Mellat.configuration.web_service_url_wsdl).
      with(headers: {'Accept'=>'*/*'}).
      to_return(status: 200,
                body: wsdl,
                headers: {})
end

def mock_authorize_request_timeout
  stub_request(:get, Mellat.configuration.web_service_url_wsdl).
      with(headers: {'Accept'=>'*/*'}).
      to_timeout
end

def mock_payment_request_general_exception
  stub_request(:post, Mellat.configuration.web_service_url_wsdl).to_raise(Exception, "Exception from webmock")
end
