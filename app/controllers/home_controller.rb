class HomeController < ApplicationController
  def index
    require"net/http"
    require"json"
    
    @search_location = params[:search] #"london"
    @url = "https://api.weatherapi.com/v1/current.json?key=ffa3372bc900435d89075502231910&q=#{@search_location}&aqi=yes"
    @uri = URI(@url)
    @response = Net::HTTP.get(@uri)
    @output = JSON.parse(@response)

    @error = ""
    
    if @output["error"]
      @error =get_error_message(@output["error"]["code"], @output["error"]["message"])
    else
      @location = @output["location"]["name"]
      @temp = @output["current"]["temp_c"]
      @condition = @output["current"]["condition"]["text"]
      @air_quality_index = get_air_quality_index_text(@output["current"]["air_quality"]["us-epa-index"])
      @background_colour = get_background_colour_from_temp(@temp.to_i)
    end 
  end

  def search
    redirect_to action: 'index', search: params[:search]
  end

  private
  def get_air_quality_index_text(air_quality_index)
    case air_quality_index
      when 1 then "Good"
      when 2 then "Moderate"
      when 3 then "Unhealthy for sensitive group"
      when 4 then "Unhealthy"
      when 5 then "Very Unhealthy"
      when 6 then "Hazardous"
      else ""
    end
  end
  
  def get_error_message(error_code, error_message)
    case error_code
      when 1003
        then "Please enter a location"
      else error_message
    end
  end

  def get_background_colour_from_temp(temp)
    #byebug
    case 
     when temp <= 12 then "blue"
     when temp > 12 && temp <= 30 then "yellow"
     when temp >30 then "red"
     else "grey"
    end
  end
end
