class SearchController < ApplicationController
  def index
    @blogs = Blogs
  end

  def results
    search = params[:prev_search].strip.split(/\s+/).
      map {|pattern| Regexp.new(Regexp.escape(pattern), Regexp::IGNORECASE)}

    prev_blogs = Blogs.select {|blog|
      search.all? {|pattern| pattern.match(blog[:body])}
    }

    search = params[:search].strip.split(/\s+/).
      map {|pattern| Regexp.new(Regexp.escape(pattern), Regexp::IGNORECASE)}

    new_blogs = Blogs.select {|blog|
      search.all? {|pattern| pattern.match(blog[:body])}
    }

    stream = []

    stream << turbo_stream.replace('prev-search',
      render_to_string(partial: 'prev', locals: {search: params[:search]}))

    cursor = nil
    Blogs.each do |blog|
      visible = prev_blogs.include?(blog)

      if visible != new_blogs.include?(blog)
        if visible
          stream << turbo_stream.remove(blog[:id])
        elsif cursor
          stream << turbo_stream.after(cursor,
            render_to_string(partial: 'blog', locals: {blog: blog}))
          cursor = blog[:id]
        else
          stream << turbo_stream.prepend('tbody',
            render_to_string(partial: 'blog', locals: {blog: blog}))
          cursor = blog[:id]
        end
      elsif visible
        cursor = blog[:id] if visible
      end
    end

    respond_to do |format|
      format.turbo_stream { 
        render turbo_stream: stream
      }
    end
  end
end
