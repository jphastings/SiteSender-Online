class BookmarksController < ApplicationController
  helper_method :current_user_session, :current_user
  
  def add_api
    begin
      raise if params[:token] != current_user.token
      @bookmark = current_user.bookmarks.new(:url => params[:url])
      
      respond_to do |format|
        if @bookmark.save
          begin
            response = nil
            Net::HTTP.start(current_user.send_ip,current_user.port) {|http|
              http.read_timeout = 5
              response = http.head("/open?url=#{URI.encode(@bookmark.url)}")
            }
            raise "The Target machine refused the connection" if response.class != Net::HTTPOK
            @bookmark.sent = true
            @bookmark.save
            format.json {render :json =>{:bookmarked => true,:sent => true } }
          rescue Exception => e
            format.json {render :json =>{:bookmarked => true,:sent => false, :message =>"#{ e } (#{ e.class })" } }
          end
        else
          format.json {render :json =>{:bookmarked => false,:sent => false } }
        end
      end
    rescue
      respond_to do |format|
        format.json { render :json => {:success => false, :message => 'not logged in'}, :status => :unauthorized }
      end
    end
  end
end
