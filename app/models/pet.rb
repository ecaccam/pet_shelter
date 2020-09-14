class Pet < ApplicationRecord
    include ::QueryHelper

    # LOGICS
    def self.get_pets
        response = { :status => false, :result => nil }
        pets     = self.get_pets_query

        if pets.present? 
            response[:status] = true
            response[:result] = pets
        end

        return response
    end

    def self.get_pet(pet_id)
        response = { :status => false, :result => nil }
        pet      = self.get_pet_query(pet_id)

        if pet.present? 
            response[:status] = true
            response[:result] = pet
        end

        return response
    end

    def self.add_pet(params)
        response = { :status => false, :message => "" }
        check_required_params = self.check_params(params)
        
        if check_required_params[:status] == true
            add_pet_query = self.add_query_pet(params)

            if add_pet_query.present?
                response[:status] = true
            end
        else
            response[:message] = "A required field is missing"
        end

        return response
    end

    def self.update_pet(params)
        response = { :status => false, :message => "" }
        check_required_params = self.check_params(params)
        
        if check_required_params[:status] == true
            pet_record = self.get_pet_query(params[:id])

            if pet_record.present?
                update_pet_record = self.update_query_pet(params)

                if update_pet_record.present?
                    response[:status] = true
                end
            end
        else
            response[:message] = "A required field is missing"
        end

        return response
    end

    def self.adopt_pet(pet_id)
        response   = { :status => false}
        pet_record = self.get_pet_query(pet_id)

        if pet_record.present?
            delete_pet_record = self.delete_query_pet(pet_id)

            if delete_pet_record.present?
                response[:status] = true
                response[:pet_id] = pet_record["pet_id"]
            end
        end

        return response
    end

    # QUERIES AND METHODS
    private
        def self.check_params(params)
            response = { :status => true }

            params.each do |key, value|
                if !value.present? || (key == "skills" && (!value["0"].present? || !value["1"].present? || !value["2"].present?))
                    response[:status] = false
                    break
                end
            end

            return response
        end

        def self.get_pets_query
            return query_records(
                ["SELECT pets.id AS pet_id, pets.name, pet_types.name AS pet_type_name
                  FROM pets
                  INNER JOIN pet_types ON pet_types.id = pets.pet_type_id"]
            )
        end

        def self.get_pet_query(pet_id)
            return query_record(
                ["SELECT pets.id AS pet_id, pets.name, pets.skills, pets.description, pet_types.name AS pet_type_name
                  FROM pets
                  INNER JOIN pet_types ON pet_types.id = pets.pet_type_id
                  WHERE pets.id =?", pet_id]
            )
        end

        def self.add_query_pet(params)
            return insert_record(
                ["INSERT INTO pets (pet_type_id, name, description, skills, created_at, updated_at)
                  VALUES (?,?,?,?,?,?);",
                  params[:type], params[:name], params[:description], params[:skills].to_json, db_datetime, db_datetime
                ]
            )
        end

        def self.update_query_pet(params)
            return update_record(
                ["UPDATE pets
                  SET pet_type_id=?, name=?, description=?, skills=?, updated_at=?
                  WHERE id =?",
                  params[:type], params[:name], params[:description], params[:skills].to_json, db_datetime, params[:id]
                ]
            )
        end

        def self.delete_query_pet(pet_id)
            return delete_record(
                ["DELETE FROM pets 
                  WHERE id =?", pet_id]
            )
        end

end
  