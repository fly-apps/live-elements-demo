class MarkdownController < ApplicationController
  def index
  end

  def update
    markdown = Redcarpet::Markdown.new(Redcarpet::Render::HTML,
      autolink: true, tables: true)

    html = markdown.render(params[:input])

    respond_to do |format|
      format.turbo_stream { 
        render turbo_stream: turbo_stream.update('output',
          render_to_string(partial: 'output', locals: {html: html}))
      }
    end
  end
end
