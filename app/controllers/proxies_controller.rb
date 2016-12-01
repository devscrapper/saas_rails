class ProxiesController < ApplicationController

  protect_from_forgery

  skip_before_action :verify_authenticity_token, if: :json_request?
  before_action :anonimity_level, only: [:index]


  # http://hostname/proxies/
  def index
    respond_to do |format|
      format.json { render json: @data}
      format.html { render html: @data }
    end
  end


  protected

  def anonimity_level
    begin
      @data =
          { :ip => request.remote_ip,
           :method => request.method,
           :url => request.original_fullpath,
           :http_version => request.headers.fetch("HTTP_VERSION", "null"),
           :http_host => request.headers.fetch("HTTP_HOST", "null"),
           :http_user_agent => request.headers.fetch("HTTP_USER_AGENT", "null"),
           :http_accept => request.headers.fetch("HTTP_ACCEPT", "null"),
           :http_accept_language => request.headers.fetch("HTTP_ACCEPT_LANGUAGE", "null"),
           :http_encoding => request.headers.fetch("HTTP_ACCEPT_ENCODING", "null"),
           :http_cookie => request.headers.fetch("HTTP_COOKIE", "null"),
           :http_connection => request.headers.fetch("HTTP_CONNECTION", "null"),
           :http_if_none_match => request.headers.fetch("HTTP_IF_NONE_MATCH", "null"),
           :http_cache_control => request.headers.fetch("HTTP_CACHE_CONTROL", "null"),
           :gateway_interface => request.headers.fetch("GATEWAY_INTERFACE", "null"),
           :http_referrer => request.headers.fetch("HTTP_REFERRER", "null"),
           :http_remote_addr => request.headers.fetch("REMOTE_ADDR", "null"),
           :header => headers.to_h,
           :authorization => request.authorization
          }

    rescue Exception => e
      @data = e.message
    else
    end
  end

  #  :"HTTP/1.1","rack.url_scheme":"http","SCRIPT_NAME":"","REMOTE_ADDR":"127.0.0.1","async.callback":"#<Method: Thin::Connection#post_process>","async.close":"#<EventMachine::DefaultDeferrable:0x8ca0768>","ORIGINAL_FULLPATH":"/proxies/192","ORIGINAL_SCRIPT_NAME":"","action_dispatch.routes":"#<ActionDispatch::Routing::RouteSet:0x69a61b8>","action_dispatch.parameter_filter":["password"],"action_dispatch.redirect_filter":[],"action_dispatch.secret_token":null,"action_dispatch.secret_key_base":"9542acc63f4daebcbf385785e19d5b0ebfc8913a45732f4d46fc52f436f88690cbb725c9ca3782853c3563970bfdd11acb6dfe8ceb899e67576a500131c04c92","action_dispatch.show_exceptions":true,"action_dispatch.show_detailed_exceptions":true,"action_dispatch.logger":"#<ActiveSupport::Logger:0x6910a58>","action_dispatch.backtrace_cleaner":"#<Rails::BacktraceCleaner:0x65572c8>","action_dispatch.key_generator":"#<ActiveSupport::CachingKeyGenerator:0x67f6b78>","action_dispatch.http_auth_salt":"http authentication","action_dispatch.signed_cookie_salt":"signed cookie","action_dispatch.encrypted_cookie_salt":"encrypted cookie","action_dispatch.encrypted_signed_cookie_salt":"signed encrypted cookie","action_dispatch.cookies_serializer":"json","action_dispatch.cookies_digest":null,"ROUTES_55390428_SCRIPT_NAME":"","action_dispatch.request_id":"edb5ee7b-ccff-4a83-bdf1-dced3f519928","action_dispatch.remote_ip":"127.0.0.1","rack.session":"#<ActionDispatch::Request::Session:0x8824f08>","rack.session.options":"#<ActionDispatch::Request::Session::Options:0x8824ed8>","action_dispatch.request.path_parameters":{"controller":"proxies","action":"show","id":"192"},"action_controller.instance":"#<ProxiesController:0x7f99da0>","action_dispatch.request.content_type":null,"action_dispatch.request.request_parameters":{},"rack.request.query_string":"","rack.request.query_hash":{},"action_dispatch.request.query_parameters":{},"action_dispatch.request.parameters":{"controller":"proxies","action":"show","id":"192"},"action_dispatch.request.formats":["text/html"],"rack.request.cookie_hash":{"_statupweb_session":"Y2pMMHliMm54dHhSNmtTdkVlYTRmUkhBSDVlV2hpTjJ6ekZOQkUvcGY2dFFpUEt2NGVvNmtCWEJoOHdlNTMyL1B6clJCWHdnNzdPOTVncTlEQzIvWldtYVNSMnYvcHM2TVRzZFozU3NMcUNmTzZVbTd4UCtwb21mT1k4NHptY3g0eithYkRETHZKU25pc1lnQS85cjhRPT0tLVg4Zm9nVjRtR2VURlJwdEcxRjV4dXc9PQ==--3b4229dc637ac07bab009b385a247c474bf1d310"},"rack.request.cookie_string":"_statupweb_session=Y2pMMHliMm54dHhSNmtTdkVlYTRmUkhBSDVlV2hpTjJ6ekZOQkUvcGY2dFFpUEt2NGVvNmtCWEJoOHdlNTMyL1B6clJCWHdnNzdPOTVncTlEQzIvWldtYVNSMnYvcHM2TVRzZFozU3NMcUNmTzZVbTd4UCtwb21mT1k4NHptY3g0eithYkRETHZKU25pc1lnQS85cjhRPT0tLVg4Zm9nVjRtR2VURlJwdEcxRjV4dXc9PQ%3D%3D--3b4229dc637ac07bab009b385a247c474bf1d310","action_dispatch.cookies":"#<ActionDispatch::Cookies::CookieJar:0x7f5e820>","action_dispatch.request.unsigned_session_cookie":{}},"authorization":null}

  def json_request?
    request.format.json?
  end

  private
  # Use callbacks to share common setup or constraints between actions.


  # Never trust parameters from the scary internet, only allow the white list through.
  def proxies_params
    params.require(:proxy).permit()
  end
end
