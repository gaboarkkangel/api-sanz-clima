require 'json'

class Api::V1::CalculationsController < ApplicationController
    def index
        @calculations = Calculation.all

        render json: @calculations, status: :ok
    end

    def create
        @calculation = Calculation.new calculation_params
        p @calculation.element
        if @calculation.element == "{\"item\" : []}" 
            json_response "Imposible Realizar una operacion con los campos suministrados", false, {}, :unprocessable_entity
        else

            if @calculation.save
                render json: @calculation, status: :created
            else
                json_response "Somthing wrong", false, {}, :unprocessable_entity            
            end
        end
    end

    def destroy
        @calculation = Calculation.where(id: params[:id]).first

        if @calculation.destroy
            head(:ok)
        else
            head(:unprocessable_entity)
        end
    end

    private
    def calculation_params
        num = params["calculation"]["element"].length()
        p num
        json = "["
        total = 0
        params["calculation"]["element"].each_with_index { |n, i|
            if n['elemento'].numeric?
                dato = n['elemento'].to_f
                total = total + dato
                json = json + "#{n['elemento']}"
                if i < num-1
                    json = json + ","
                end
            end
        }
        json = '{"item" : ' + json + "]}"
        json = json.gsub(",]", "]")
        p json
        params["calculation"]["element"]  = json
        params["calculation"]["total"]  = total
        params.require(:calculation).permit(:total, :element)
    end
    
    def number_or_nil( s )
        number = s.to_i 
        number = nil if (number.to_s != s)
        return number
      end
end
class String 
    def numeric?
        return true if self =~ /^\d+$/ 
        true if Float(self) rescue false 
    end 
end


