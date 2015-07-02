require 'spec_helper'

describe 'Swagger' do
  context 'swaggerUi' do
    before do
      visit '/swagger'
    end
    it 'loads foos resource' do
      expect(page).to have_css "li#resource_foos"
    end
    it 'loads Swagger UI' do
      expect(page.evaluate_script('window.swaggerUi != null')).to be true
    end
  end
  context "#options" do
    before do
      @options = GrapeSwaggerRails.options.dup
    end
    context "#headers" do
      before do
        GrapeSwaggerRails.options.headers['X-Test-Header'] = 'Test Value'
        visit '/swagger'
      end
      it 'adds headers' do
        find('#endpointListTogger_headers', visible: true).click
        find('a[href="#!/headers/GET_api_headers_format"]', visible: true).click
        click_button 'Try it out!'
        expect(page).to have_css "span.attribute", text: 'X-Test-Header'
        expect(page).to have_css "span.string", text: 'Test Value'
      end
    end
    context "#api_auth:basic" do
      before do
        GrapeSwaggerRails.options.api_auth = 'basic'
        GrapeSwaggerRails.options.api_key_name = 'Authorization'
        GrapeSwaggerRails.options.api_key_type = 'header'
        visit '/swagger'
      end
      it 'adds an Authorization header' do
        fill_in 'apiKey', with: 'username:password'
        find('#endpointListTogger_headers', visible: true).click
        first('a[href="#!/headers/GET_api_headers_format"]', visible: true).click
        click_button 'Try it out!'
        expect(page).to have_css "span.attribute", text: 'Authorization'
        expect(page).to have_css "span.string", text: "Basic #{Base64.encode64('username:password').strip}"
      end
    end
    context "#api_auth:bearer" do
      before do
        GrapeSwaggerRails.options.api_auth = 'bearer'
        GrapeSwaggerRails.options.api_key_name = 'Authorization'
        GrapeSwaggerRails.options.api_key_type = 'header'
        visit '/swagger'
      end
      it 'adds an Authorization header' do
        fill_in 'apiKey', with: 'token'
        find('#endpointListTogger_headers', visible: true).click
        first('a[href="#!/headers/GET_api_headers_format"]', visible: true).click
        click_button 'Try it out!'
        expect(page).to have_css "span.attribute", text: 'Authorization'
        expect(page).to have_css "span.string", text: 'Bearer token'
      end
    end
    context "#api_auth:token" do
      before do
        GrapeSwaggerRails.options.api_key_name = 'api_token'
        GrapeSwaggerRails.options.api_key_type = 'query'
        visit '/swagger'
      end
      it 'adds an api_token query parameter' do
        fill_in 'apiKey', with: 'dummy'
        find('#endpointListTogger_params', visible: true).click
        first('a[href="#!/params/GET_api_params_format"]', visible: true).click
        click_button 'Try it out!'
        expect(page).to have_css "span.attribute", text: 'api_token'
        expect(page).to have_css "span.string", text: "dummy"
      end
    end
    context "#before_filter" do
      before do
        GrapeSwaggerRails.options.before_filter do |request|
          flash[:error] = "Unauthorized Access"
          redirect_to '/'
          false
        end
        visit '/swagger'
      end
      it 'denies access' do
        expect(current_path).to eq "/"
        expect(page).to have_content "Unauthorized Access"
      end
    end
    context "#app_name" do
      context 'set' do
        before do
          GrapeSwaggerRails.options.app_name = "Test App"
          visit '/swagger'
        end
        it 'sets page title' do
          expect(page.title).to eq "Test App"
        end
      end
      context 'not set' do
        before do
          visit '/swagger'
        end
        it 'defaults page title' do
          expect(page.title).to eq "Swagger"
        end
      end
    end
    after do
      GrapeSwaggerRails.options = @options
    end
  end
end
