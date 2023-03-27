class ValidateController < ApplicationController
  def index
  end

  def update
    count = 0 

    %w(one two three four five six).each do |option|
      count += 1 if params[option]
    end

    respond_to do |format|
      format.turbo_stream { 
        render turbo_stream: turbo_stream.replace('checkboxes',
          render_to_string(partial: 'checkboxes', locals: {params: params, count: count}))
      }
    end
  end
end
