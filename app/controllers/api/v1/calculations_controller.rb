require 'json'

class Api::V1::CalculationsController < ApplicationController
    def index
        @calculations = Calculation.all

        render json: @calculations, status: :ok
    end

    def create
        @calculation = Calculation.new calculation_params
        p "testear"
        if @calculation.save
            render json: @calculation, status: :created
        else
            json_response "Somthing wrong", false, {}, :unprocessable_entity            
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
        p params
        # params["calculation"]["element"] = '{ "item" : [1, 2, 3]}'
        object = JSON.parse(params["calculation"]["element"], object_class: OpenStruct)
        p "objeto"
        p object
        p object.item
        p object.item.instance_of? Array
        p  params["calculation"]["element"].instance_of? JSON
        params.require(:calculation).permit(:total, :element)
    end
end
