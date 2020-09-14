class PetsController < ApplicationController

    def index
        @page_layout = "index"

        @pets = Pet.get_pets
    end

    def manage
        @page_layout = "manage"
        
        @pet = { :status => false, :result => nil }

        if params[:id].present? 
            @pet = Pet.get_pet(params[:id])
        end
    end

    def add_pet
        render :json => Pet.add_pet(params.permit(:description, :name, :type, {:skills => {}} ))  
    end

    def update_pet
        render :json => Pet.update_pet(params.permit(:id, :description, :name, :type, {:skills => {}} ))
    end

    def fetch_pet
        fetch_pet_response = Pet.get_pet(params[:pet_id])

        if fetch_pet_response[:status]
            fetch_pet_response[:html] = render_to_string :partial => "pets/templates/pet_details_modal", 
                                                         :locals  => { :pet => fetch_pet_response[:result] }

        end

        render :json => fetch_pet_response
    end

    def adopt_pet
        render :json => Pet.adopt_pet(params[:pet_id])
    end
end
