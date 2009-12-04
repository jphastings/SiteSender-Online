class BookmarksController < ApplicationController
  helper_method :current_user_session, :current_user
  
  def add
  end

  def add_api
    begin
      raise if params[:token] != current_user.token
      @bookmark = current_user.bookmarks.new(:url => params[:url])
      
      respond_to do |format|
        if @bookmark.save
          begin
            response = nil
            Net::HTTP.start(current_user.send_ip,15685) {|http|
              http.timeout = 5
              response = http.head("/open?url=#{URI.encode(@bookmark.url)}")
            }
            # Todo, check response for it having been sent properly
            p response
            @bookmark.sent = true
            @bookmark.save
            format.json {render :json =>{:bookmarked => true,:sent => true } }
          rescue
            format.json {render :json =>{:bookmarked => true,:sent => false } }
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

  def delete
  end
end
