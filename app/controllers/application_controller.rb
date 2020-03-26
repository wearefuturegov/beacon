class ApplicationController < ActionController::Base
  http_basic_authenticate_with name: 'camden', password: 'camden'
end
