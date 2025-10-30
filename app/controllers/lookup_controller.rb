class LookupController < ApplicationController

    def index
      if params[:abn]
        @message = "Inside the Index Action"
      else
        @message = "In the else of the Index Action"
      end
    end
    
      
    def lookup
      @abn = params[:abn]
      @guid = '890b3a4c-7267-4c8f-8c43-825a349a5e87'
      client = Savon.client(wsdl: "https://www.abn.business.gov.au/abrxmlsearch/ABRXMLSearch.asmx?WSDL")

      if @abn =~ /^\d{11}$/   # number search first
        response = client.call(:abr_search_by_abn, message: { authenticationGuid: @guid, searchString: @abn, includeHistoricalDetails: "N" })
        @result = response.body[:abr_search_by_abn_response][:abr_payload_search_results][:response][:business_entity]
      else
        response = client.call(:abr_search_by_name_simple_protocol, message: { name: @abn, authenticationGuid: @guid })

          @result = response.body[:abr_search_by_name_simple_protocol_response][:abr_payload_search_results][:response][:search_results_list][:search_results_record]
      end
      rescue
          @result = 'No Results'
    end
end
